<?php

namespace app\admin\controller;

use app\admin\model\Account;
use app\admin\model\Bill;
use app\common\controller\Backend;
use think\App;
use think\Db;
use think\db\exception\DataNotFoundException;
use think\db\exception\ModelNotFoundException;
use think\exception\DbException;

/**
 * 交易记录管理
 *
 * @icon fa fa-circle-o
 */
class Withdrawal extends Backend
{


    /**
     * Withdrawal模型对象
     * @var \app\admin\model\Withdrawal
     */
    protected $model = null;
    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\Withdrawal;

    }


    public function index()
    {
        //设置过滤方法
        $this->request->filter(['strip_tags', 'trim']);
        if (false === $this->request->isAjax()) {
            return $this->view->fetch();
        }
        //如果发送的来源是 Selectpage，则转发到 Selectpage
        if ($this->request->request('keyField')) {
            return $this->selectpage();
        }
        [$where, $sort, $order, $offset, $limit] = $this->buildparams();
        $list = $this->model
            ->where($where)
            ->with(["user", "admin"])
            ->order("type", "asc")
            ->order("id", "desc")
            ->paginate($limit);
        $typeArr = [
            1 => '待审核',
            2 => '通过',
            3 => '拒绝',
        ];
        $payTypeArr = [
            1 => '银行卡',
            2 => '支付宝',
        ];
        foreach ($list->items() as $k => &$v) {
            $v['_type'] = $v['type'];
            $v['type'] = $typeArr[$v['type']] ?? "";
            $v['pay_type'] = $payTypeArr[$v['pay_type']] ?? "";
            $v->getRelation('user')->visible(['nickname']);
        }
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
    }

    /**
     * 默认生成的控制器所继承的父类中有index/add/edit/del/multi五个基础方法、destroy/restore/recyclebin三个回收站方法
     * 因此在当前控制器中可不用编写增删改查的代码,除非需要自己控制这部分逻辑
     * 需要将application/admin/library/traits/Backend.php中对应的方法复制到当前控制器,然后进行修改
     */

    public function pass($ids = null)
    {

        $ids = $ids ?: $this->request->get("ids");
        if (empty($ids)) {
            $this->error(__('Parameter %s can not be empty', 'ids'));
        }
        $row = $this->model->get($ids);
        if ($row->type != 1) {
            $this->error(__('已通过审核,禁止修改', 'ids'));
        }
        $withdrawal = new \app\admin\model\Withdrawal();
        $bool = $withdrawal->whereIn("id", $ids)->update([
            'type' => 2,
            'pay_time' => time(),
            'ext_id' => $this->auth->id,
        ]);
        if (empty($bool)) {
            $this->error(__('审核失败', 'ids'));
        }
        $notice = new \app\admin\model\Notice();
        $data = [
            'uid' => $row->uid,
            'title' => '提现成功通知',
            'content' => "您发起的提现 {$row->money} 金额已审核通过，系统将尽快打款",
            'msg_type' => 22,
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $notice->insert($data);
//        //https://opendocs.alipay.com/apis/api_28/alipay.fund.trans.uni.transfer/?scene=ca56bca529e64125a2786703c6192d41
//        if ($row->pay_type == 1) {
//            $data = [
//                'out_biz_no' => $row->otn, // 订单号
//                'trans_amount' => $row->money, // 转账金额
//                'product_code' => 'TRANS_ACCOUNT_NO_PWD',
//                'biz_scene' => 'DIRECT_TRANSFER',
//                'order_title' => "转账",
//                'payee_info' => [
//                    'identity' => $row->alipay_card,
//                    'identity_type' => 'ALIPAY_LOGON_ID',
//                    'name' => $row->realName,
//                ],
//            ];
//        } else {
//            $data = [
//                'out_biz_no' => $row->otn, // 订单号
//                'trans_amount' => $row->money, // 转账金额
//                'product_code' => 'TRANS_BANKCARD_NO_PWD',
//                'biz_scene' => 'DIRECT_TRANSFER',
//                'payee_info' => [
//                    'identity_type' => 'BANKCARD_ACCOUNT', // 银行名称
//                    'identity' => $row->bankCard, // 卡号
//                    'name' => $row->realName, // 银行卡号
//                    "bankcard_ext_info" => [                  // 银行卡扩展信息
//                        "account_type" => "1",
//                        "inst_name" => $row->bankName,
////                            "inst_branch_name" => "上海市支行",
////                            "inst_city" => "上海市",
////                            "inst_province" => "上海市",
////                            "bank_code" => "123456",
//                    ]
//                ],
//            ];
//        }
//
//        $result = [];
//        try {
//            $pay = \AliPay\Transfer::instance($this->getAliConf());
//            $result = $pay->create($data);
//            if (empty($result)) {
//                throw new \Exception("转账失败");
//            }
//            if ($result['code'] !== '10000') {
//                throw new \Exception("转账失败：" . $result['msg']);
//            }
//            if (!isset($result['status']) || $result['status'] !== 'SUCCESS') {
//                throw new \Exception("转账未成功，状态：{$result['status']}，原因：{$result['msg']}");
//            }
//            $bool = $withdrawal->whereIn("id", $ids)
//                ->update([
//                    'request' => json_encode($data),
//                    'response' => json_encode($result),
//                ]);
//        } catch (\Exception $e) {
//            $bool = $withdrawal->whereIn("id", $ids)
//                ->update([
//                    'request' => json_encode($data),
//                    'response' => json_encode($result),
//                    'err' => $e->getMessage(),
//                ]);
//            $this->error("转账失败:" . $e->getMessage());
//        }
        $this->success();
    }


    public function getAliConf()
    {
//        ● 密钥方式：生成 RSA 密钥对（应用公钥、应用私钥）
//        ● 证书方式：生成 RSA 密钥对（应用公钥、应用私钥）以及公钥证书申请 CSR 文件
//        alipayConfig.setAppCertPath("<-- 请填写您的应用公钥证书文件路径，例如：/foo/appCertPublicKey_2019051064521003.crt -->");
//        alipayConfig.setAlipayPublicCertPath("<-- 请填写您的支付宝公钥证书文件路径，例如：/foo/alipayCertPublicKey_RSA2.crt -->");
//        alipayConfig.setRootCertPath("<-- 请填写您的支付宝根证书文件路径，例如：/foo/alipayRootCert.crt -->");
        $config = [
            // 沙箱模式
            'debug' => false,
            // 签名类型 ( RSA|RSA2 )
            'sign_type' => 'RSA2',
            // 应用ID
            'appid' => \think\facade\Config::get('my.appid'),
            // 应用私钥内容 ( 需1行填写，特别注意：这里的应用私钥通常由支付宝密钥管理工具生成 )
            'private_key' => \think\facade\Config::get('my.private_key'),
            // 公钥模式，支付宝公钥内容 ( 需1行填写，特别注意：这里不是应用公钥而是支付宝公钥，通常是上传应用公钥换取支付宝公钥，在网页可以复制 )
            'public_key' => \think\facade\Config::get('my.public_key'),
            // 证书模式，应用公钥证书路径 ( 新版资金类接口转 app_cert_sn，如文件 appCertPublicKey.crt )
            'app_cert_path' => __DIR__ . '/alipay/appPublicCert.crt', // 'app_cert' => '证书内容',
            // 证书模式，支付宝根证书路径 ( 新版资金类接口转 alipay_root_cert_sn，如文件 alipayRootCert.crt )
            'alipay_root_path' => __DIR__ . '/alipay/alipayRootCert.crt', // 'root_cert' => '证书内容',
            // 证书模式，支付宝公钥证书路径 ( 未填写 public_key 时启用此参数，如文件 alipayPublicCert.crt )
            'alipay_cert_path' => __DIR__ . '/alipay/alipayPublicCert.crt', // 'public_key' => '证书内容'
            // 支付成功通知地址
            'notify_url' => \think\facade\Config::get('my.notify_url'),
        ];
        return $config;
    }

    /**
     * 删除
     *
     * @param $ids
     * @return void
     * @throws DbException
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
     */
    public function nopass($ids = null)
    {
        $ids = $ids ?: $this->request->post("ids");
        if (empty($ids)) {
            $this->error(__('Parameter %s can not be empty', 'ids'));
        }
        $row = $this->model->get($ids);
        if ($row->type != 1) {
            $this->error(__('已通过审核,禁止修改', 'ids'));
        }
        $adminIds = $this->getDataLimitAdminIds();
        if (is_array($adminIds) && !in_array($row[$this->dataLimitField], $adminIds)) {
            $this->error(__('You have no permission'));
        }
        if (false === $this->request->isPost()) {
            $this->view->assign('row', $row);
            return $this->view->fetch();
        }
        $params = $this->request->post('row/a');
        if (empty($params)) {
            $this->error(__('Parameter %s can not be empty', ''));
        }
        $params = $this->preExcludeFields($params);
        Db::transaction(function () use ($ids, $row, $params) {
            $content = $params['content'] ?? "";
            $money = $row['money'];
            $withdrawal = new \app\admin\model\Withdrawal();
            $withdrawal->whereIn("id", $ids)->update([
                'type' => 3,
                'content' => $content,
                'ext_id' => $this->auth->id,
            ]);

            $accountModel = new Account();
            $accountModel->where('uid', $row->uid)
                ->inc('pay_back', $money)->update();
            $billData = [
                'uid' => $row->uid,
                'money' => $money,
                'money_type' => 1,
                'bill_unit' => 'add',
                'bill_type' => Bill::BillTypeWithdrawal,
                'itime' => time(),
                'utime' => time(),
                'ext_content' => $content,
                'ext_id' => $this->auth->id,
            ];
            $billModel = new Bill();
            $billModel->data($billData);
            $billModel->save();


        });
        $notice = new \app\admin\model\Notice();
        $data = [
            'uid' => $row->uid,
            'title' => '提现失败通知',
            'content' => "您发起的提现 {$row->money} 金额已审核为不通过，详情请咨询客服",
            'msg_type' => 33,
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $notice->insert($data);
        $this->success();
    }


    public function export()
    {
        set_time_limit(0);
        ini_set("memory_limit", "256M");
        ob_end_clean();
        ob_start();
        $originWhere = $this->getSearchConditions();
        $query = $this->model->alias("withdrawal")
            ->join('account_info user', 'user.uid = withdrawal.uid', 'LEFT');
        foreach ($originWhere as $item) {
            if ($item[0] == "withdrawal.pay_type") {
                $query = $query->where("withdrawal.pay_type", $item[2]);
            }
            if ($item[0] == "withdrawal.type") {
                $query = $query->where("withdrawal.type", $item[2]);
            }
            if ($item[0] == "withdrawal.otn") {
                $query = $query->where("withdrawal.otn", 'like', $item[2]);
            }
            if ($item[0] == "withdrawal.otn") {
                $query = $query->where("withdrawal.otn", 'like', $item[2]);
            }
            if ($item[0] == "user.nickname") {
                $query = $query->where("user.nickname", 'like', $item[2]);
            }
            if ($item[0] == "user.uid") {
                $query = $query->where("user.uid", 'like', $item[2]);
            }
            if ($item[0] == "withdrawal.pay_time") {
                $query = $query->where("withdrawal.pay_time", '>=', strtotime($item[2][0]));
                $query = $query->where("withdrawal.pay_time", '<=', strtotime($item[2][1]));
            }
        }
        $title = '用户信息' . date("YmdHis");
        $fileName = $title . '.xlsx';
        $writer = new \XLSXWriter();
        $sheet = 'Sheet1';
        // 处理标题数据，都设置为 string 类型
        //用户id
        //账号昵称
        //订单号
        //金额
        //订单状态
        //时间
        //提现时间
        //提现类型
        //姓名
        //银行名字
        //银行卡号
        //支付宝账号
        $header = [
            'id' => 'string',
            'uid' => 'string',
            '昵称' => "string",
            '订单号' => 'string',
            '金额' => 'string',
            '订单状态' => 'string',
            '提现时间' => 'string',
            '提现类型' => 'string',
            '真实姓名' => 'string',
            '银行名字' => 'string',
            '银行卡号' => 'string',
            '支付宝账号' => 'string',
        ];
        $writer->writeSheetHeader($sheet, $header);
        $query->field([
            "withdrawal.id", "withdrawal.uid", 'user.nickname', 'withdrawal.otn', 'withdrawal.money', 'withdrawal.type',
            'withdrawal.pay_time', 'withdrawal.pay_type', 'withdrawal.realName',
            'withdrawal.bankName', 'withdrawal.bankCard', 'withdrawal.alipay_card'
        ])
            ->chunk(1000, function ($items) use (&$writer) {
                $items = collection($items)->toArray();
                foreach ($items as $index => $item) {
                    $sheet = 'Sheet1';
                    $row = [];
                    foreach ($item as $field => $value) {
                        if ($field == "type") {
                            $typeArr = [
                                1 => '待审核',
                                2 => '已审核',
                                3 => '审核失败',
                            ];
                            $value = $typeArr[$value] ?? "";
                        }
                        if ($field == "pay_type") {
                            $typeArr = [
                                1 => '银行',
                                2 => '支付宝',
                            ];
                            $value = $typeArr[$value] ?? "";
                        }
                        if ($field == "pay_time") {
                            if ($value > 0) {
                                $value = date("Y-m-d H:i:s", $value);
                            }
                        }
                        $row[$field] = $value;
                    }
                    $writer->writeSheetRow($sheet, $row);
                }
            }, 'withdrawal.id', 'desc');
        // 设置 header，用于浏览器下载
        ob_end_clean();
        ob_start();
        header('Content-disposition: attachment; filename="' . \XLSXWriter::sanitize_filename($fileName) . '"');
        header("Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        header('Content-Transfer-Encoding: binary');
        header('Cache-Control: must-revalidate');
        header('Pragma: public');
        $writer->writeToStdOut();
        exit(0);
    }


    public function multipass($ids = null)
    {

        $ids = $ids ?: $this->request->get("ids");
        if (empty($ids)) {
            $this->error(__('Parameter %s can not be empty', 'ids'));
        }
        foreach ($ids as $id) {
            $row = $this->model->get($id);
            if ($row->type != 1) {
                continue;
            }
            $withdrawal = new \app\admin\model\Withdrawal();
            $bool = $withdrawal->whereIn("id", $id)->update([
                'type' => 2,
                'pay_time' => time(),
                'ext_id' => $this->auth->id,
            ]);
            if (empty($bool)) {
                continue;
            }
            $notice = new \app\admin\model\Notice();
            $data = [
                'uid' => $row->uid,
                'title' => '提现成功通知',
                'content' => "您发起的提现 {$row->money} 金额已审核通过，系统将尽快打款",
                'msg_type' => 22,
                'itime' => time(), //加入时间
                'utime' => time(), //更新时间
            ];
            $notice->insert($data);
        }
        $this->success();
    }


    public function multinopass($ids = null)
    {
        $ids = $ids ?: $this->request->request("ids");
        if (empty($ids)) {
            $this->error(__('Parameter %s can not be empty', 'ids'));
        }
        $reason = $this->request->post('reason');
        if (empty($reason)) {
            $this->error(__('Parameter %s can not be empty', 'reason'));
        }
        foreach ($ids as $id) {
            $row = $this->model->get($id);
            if ($row->type != 1) {
                continue;
            }
            Db::transaction(function () use ($id, $row, $reason) {
                $money = $row['money'];
                $withdrawal = new \app\admin\model\Withdrawal();
                $withdrawal->whereIn("id", $id)->update([
                    'type' => 3,
                    'content' => $reason,
                    'ext_id' => $this->auth->id,
                ]);

                $accountModel = new Account();
                $accountModel->where('uid', $row->uid)
                    ->inc('pay_back', $money)->update();
                $billData = [
                    'uid' => $row->uid,
                    'money' => $money,
                    'money_type' => 1,
                    'bill_unit' => 'add',
                    'bill_type' => Bill::BillTypeWithdrawal,
                    'itime' => time(),
                    'utime' => time(),
                    'ext_content' => $reason,
                    'ext_id' => $this->auth->id,
                ];
                $billModel = new Bill();
                $billModel->data($billData);
                $billModel->save();
            });
            $notice = new \app\admin\model\Notice();
            $data = [
                'uid' => $row->uid,
                'title' => '提现失败通知',
                'content' => "您发起的提现 {$row->money} 金额已审核为不通过，详情请咨询客服",
                'msg_type' => 33,
                'itime' => time(), //加入时间
                'utime' => time(), //更新时间
            ];
            $notice->insert($data);
        }
        $this->success();
    }
}
