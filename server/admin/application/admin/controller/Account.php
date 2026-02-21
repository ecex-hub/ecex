<?php

namespace app\admin\controller;

use app\admin\model\Bill;
use app\common\controller\Backend;
use common\models\AccountInfo;
use think\Db;
use think\exception\DbException;
use think\exception\PDOException;
use think\exception\ValidateException;
use think\response\Json;

/**
 * 视频管理
 *
 * @icon fa fa-circle-o
 */
class Account extends Backend
{

    /**
     * Video模型对象
     * @var \app\admin\model\Video
     */
    protected $model = null;


    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\Account;

    }


    /**
     * 查看
     *
     * @return string|Json
     * @throws \think\Exception
     * @throws DbException
     */
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
            ->whereIn("account_type", [0, 2])
            ->order($sort, $order)
            ->paginate($limit);
        $isRealArr = [
            0 => '未认证',
            1 => '待审核',
            2 => '实名认证',
        ];
        $statusArr = [
            0 => '正常',
            1 => '删除',
            2 => '冻结',
        ];    
        foreach ($list->items() as $k => &$v) {
            $v['avatar'] = $this->view->config['upload']['cdnurl'] . $v['avatar'];
            $v['is_real'] = $isRealArr[$v['is_real']] ?? "";
//            $v['video_url'] = $this->view->config['upload']['cdnurl'] . $v['video_url'];
            $v['status_name'] = $statusArr[$v['account_type']] ?? "";
            $payM = new \app\admin\model\Pay();
            $v['rechargeAllMoney'] = $payM
                ->where("uid", $v['uid'])
                ->where("type", 2)
                ->sum("money");
           // $v['is_self'] = $v['is_business'];
        }
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
    }


    public function export()
    {
        set_time_limit(0);
        ini_set("memory_limit", "256M");
//        $search = $this->request->post('search');
//        $ids = $this->request->post('ids');
//        $filter = $this->request->post('filter');
//        $op = $this->request->post('op');
//        $sort = $this->request->post('sort');
//        $order = $this->request->post('order');
//        $columns = $this->request->post('columns');
//        $searchList = $this->request->post('searchList');
//        $searchList = json_decode($searchList, true);

//        $this->request->get(['search' => $search, 'ids' => $ids, 'filter' => urldecode($filter), 'op' => urldecode($op), 'sort' => $sort, 'order' => $order]);

//        list($where, $sort, $order, $offset, $limit) = $this->buildparams();
        //$columns 是得到的字段，可以在这里写上自己的逻辑，比如删除或添加其他要写的字段
//        $columns_arr = $new_columns_arr = explode(',', $columns);
//        $key = array_search('serviceFee', $columns_arr);
//        if ($key) {
//            $new_columns_arr[$key] = "(platformFee + agentFee)/100 AS serviceFee";
//            $columns = implode(',', $new_columns_arr);
//        }
        $title = '用户信息' . date("YmdHis");
        $fileName = $title . '.xlsx';
        $writer = new \XLSXWriter();
        $sheet = 'Sheet1';
        // 处理标题数据，都设置为 string 类型
        $header = [
            'uid' => 'string',
            '手机号' => 'string',
            '真实姓名' => 'string',
            '身份证号' => 'string',
            '开户行' => 'string',
            '银行卡号' => 'string',
            '支付宝账号' => 'string',
        ];
        $writer->writeSheetHeader($sheet, $header);
        $this->model
            ->field([
                'uid', 'account', 'realName', 'IDCard'
            ])
            ->with(['bank'])
            ->chunk(1000, function ($items) use (&$writer) {
                $items = collection($items)->toArray();
                foreach ($items as $index => $item) {
                    $sheet = 'Sheet1';
                    $row = [];
                    foreach ($item as $field => $value) {
                        if ($field == "bank") {
                            $row['bankName'] = $value['bankName'] ?? "";
                            $row['bankCard'] = $value['bankCard'] ?? "";
                            $row['alipay_card'] = $value['alipay_card'] ?? "";
                        } else {
                            $row[$field] = $value;
                        }
                    }
                    $writer->writeSheetRow($sheet, $row);
                }
            }, 'account.uid', 'asc');
        // 设置 header，用于浏览器下载
        header('Content-disposition: attachment; filename="' . \XLSXWriter::sanitize_filename($fileName) . '"');
        header("Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        header('Content-Transfer-Encoding: binary');
        header('Cache-Control: must-revalidate');
        header('Pragma: public');
        $writer->writeToStdOut();
        exit(0);
    }

    public function edit($ids = null)
    {
        $row = $this->model->get($ids);
        if (!$row) {
            $this->error(__('No Results were found'));
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
        $result = false;
        Db::startTrans();
        try {
            //是否采用模型验证
            if ($this->modelValidate) {
                $name = str_replace("\\model\\", "\\validate\\", get_class($this->model));
                $validate = is_bool($this->modelValidate) ? ($this->modelSceneValidate ? $name . '.edit' : $name) : $this->modelValidate;
                $row->validateFailException()->validate($validate);
            }
            $remark = $params['remark'];
            //加分
            if ($params['type'] == 1) {
                if ($params['money_type'] == 1) {
                    $money = $params['money'] ?? 0;
                    $user = new \app\admin\model\Account();
                    $user->inc("money", $money)
                        ->where("uid", $ids)
                        ->update();
                    $billData = [
                        'uid' => $row->uid,
                        'money' => $money,
                        'money_type' => 1,
                        'bill_unit' => 'add',
                        'bill_type' => Bill::BillTypeSys,
                        'itime' => time(),
                        'utime' => time(),
                        'ext_content' => $remark,
                        'ext_id' => $this->auth->id
                    ];
                    $billModel = new Bill();
                    $billModel->data($billData);
                    $billModel->save();
                } else if ($params['money_type'] == 2) {
                    $money = $params['money'] ?? 0;
                    $user = new \app\admin\model\Account();
                    $user->inc("pay_back", $money)
                        ->where("uid", $ids)
                        ->update();
                    $billData = [
                        'uid' => $row->uid,
                        'money' => $money,
                        'money_type' => 2,
                        'bill_unit' => 'add',
                        'bill_type' => Bill::BillTypeSys,
                        'itime' => time(),
                        'utime' => time(),
                        'ext_content' => $remark,
                        'ext_id' => $this->auth->id

                    ];
                    $billModel = new Bill();
                    $billModel->data($billData);
                    $billModel->save();
                } else if ($params['money_type'] == 3) {
                    $money = $params['money'] ?? 0;
                    $user = new \app\admin\model\Account();
                    $user->inc("allowance", $money)
                        ->where("uid", $ids)
                        ->update();
                    $billData = [
                        'uid' => $row->uid,
                        'money' => $money,
                        'money_type' => 3,
                        'bill_unit' => 'add',
                        'bill_type' => Bill::BillTypeSys,
                        'itime' => time(),
                        'utime' => time(),
                        'ext_content' => $remark,
                        'ext_id' => $this->auth->id

                    ];
                    $billModel = new Bill();
                    $billModel->data($billData);
                    $billModel->save();
                } else if ($params['money_type'] == 4) {
                    $money = $params['money'] ?? 0;
                    $user = new \app\admin\model\Account();
                    $user->inc("dream_fund", $money)
                        ->where("uid", $ids)
                        ->update();
                    $billData = [
                        'uid' => $row->uid,
                        'money' => $money,
                        'money_type' => 4,
                        'bill_unit' => 'add',
                        'bill_type' => Bill::BillTypeSys,
                        'itime' => time(),
                        'utime' => time(),
                        'ext_content' => $remark,
                        'ext_id' => $this->auth->id

                    ];
                    $billModel = new Bill();
                    $billModel->data($billData);
                    $billModel->save();
                }
            } else {
                //减分
                if ($params['money_type'] == 1) {
                    $money = $params['money'] ?? 0;
                    $user = new \app\admin\model\Account();
                    $user->dec("money", $money)
                        ->where("uid", $ids)
                        ->where("money", ">=", $money) // 检查余额是否足够
                        ->update();
                    $billData = [
                        'uid' => $row->uid,
                        'money' => $money,
                        'money_type' => 1,
                        'bill_unit' => 'sub',
                        'bill_type' => Bill::BillTypeSys,
                        'itime' => time(),
                        'utime' => time(),
                        'ext_content' => $remark,
                        'ext_id' => $this->auth->id

                    ];
                    $billModel = new Bill();
                    $billModel->data($billData);
                    $billModel->save();
                } else if ($params['money_type'] == 2) {
                    $money = $params['money'] ?? 0;
                    $user = new \app\admin\model\Account();
                    $user->dec("pay_back", $money)
                        ->where("pay_back", ">=", $money) // 检查余额是否足够
                        ->where("uid", $ids)
                        ->update();
                    $billData = [
                        'uid' => $row->uid,
                        'money' => $money,
                        'money_type' => 2,
                        'bill_unit' => 'sub',
                        'bill_type' => Bill::BillTypeSys,
                        'itime' => time(),
                        'utime' => time(),
                        'ext_content' => $remark,
                        'ext_id' => $this->auth->id

                    ];
                    $billModel = new Bill();
                    $billModel->data($billData);
                    $billModel->save();
                } else if ($params['money_type'] == 3) {
                    $money = $params['money'] ?? 0;
                    $user = new \app\admin\model\Account();
                    $user->dec("allowance", $money)
                        ->where("allowance", ">=", $money) // 检查余额是否足够
                        ->where("uid", $ids)
                        ->update();
                    $billData = [
                        'uid' => $row->uid,
                        'money' => $money,
                        'money_type' => 3,
                        'bill_unit' => 'sub',
                        'bill_type' => Bill::BillTypeSys,
                        'itime' => time(),
                        'utime' => time(),
                        'ext_content' => $remark,
                        'ext_id' => $this->auth->id
                    ];
                    $billModel = new Bill();
                    $billModel->data($billData);
                    $billModel->save();
                } else if ($params['money_type'] == 4) {
                    $money = $params['money'] ?? 0;
                    $user = new \app\admin\model\Account();
                    $user->dec("dream_fund", $money)
                        ->where("dream_fund", ">=", $money) // 检查余额是否足够
                        ->where("uid", $ids)
                        ->update();
                    $billData = [
                        'uid' => $row->uid,
                        'money' => $money,
                        'money_type' => 4,
                        'bill_unit' => 'sub',
                        'bill_type' => Bill::BillTypeSys,
                        'itime' => time(),
                        'utime' => time(),
                        'ext_content' => $remark,
                        'ext_id' => $this->auth->id
                    ];
                    $billModel = new Bill();
                    $billModel->data($billData);
                    $billModel->save();
                }
            }
            Db::commit();
            $this->success();
        } catch (ValidateException|PDOException|Exception $e) {
            Db::rollback();
            $this->error($e->getMessage());
        }
    }


    public function edita($ids = null)
    {
        $row = $this->model->get($ids);
        if (!$row) {
            $this->error(__('No Results were found'));
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
        $result = false;
        Db::startTrans();
        try {
            //是否采用模型验证
            if ($this->modelValidate) {
                $name = str_replace("\\model\\", "\\validate\\", get_class($this->model));
                $validate = is_bool($this->modelValidate) ? ($this->modelSceneValidate ? $name . '.edit' : $name) : $this->modelValidate;
                $row->validateFailException()->validate($validate);
            }
            if (isset($params['password']) && $params['password']) {
                $params['password'] = md5($params['password']);
            }
            if (isset($params['payPassword']) && $params['payPassword']) {
                $params['payPassword'] = md5($params['payPassword']);
            }
            if (isset($params['IDCard']) && $params['IDCard']) {
                $params['is_real'] = 2;
            }
            if (empty($params['password'])) {
                unset($params['password']);
            }
            if (empty($params['payPassword'])) {
                unset($params['payPassword']);
            }
            $result = $row->allowField(true)->save($params);
            Db::commit();
        } catch (ValidateException|PDOException|Exception $e) {
            Db::rollback();
            $this->error($e->getMessage());
        }
        if (false === $result) {
            $this->error(__('No rows were updated'));
        }
        return $this->success();
    }

    public function del($ids = null)
    {
        $params = $this->request->param();
        $uid = $params['uid'];
        $user = $this->model->where("uid", $uid)->find();
        if (empty($user)) {
            $this->error(__('No rows were updated'));
        }
        $this->model->where("uid", $uid)->update([
            "account_type" => 1,
            'account' => $user->account . "_bak",
        ]);
        return $this->success();
    }


    public function freeze($ids = null)
    {
        $params = $this->request->param();
        $uid = $params['uid'];
        $this->model->where("uid", $uid)->update([
            "account_type" => 2, //冻结用户
        ]);
        return $this->success();
    }

    public function unfreeze($ids = null)
    {
        $params = $this->request->param();
        $uid = $params['uid'];
        $this->model->where("uid", $uid)->update([
            "account_type" => 0, //解冻用户
        ]);
        return $this->success();
    }

    public function notWithdrawal($ids = null)
    {
        $params = $this->request->param();
        $uid = $params['uid'];
        $day = $params['day'];
        $limitTime = 0;
        $now = time();
        if ($day == 0) {
            $limitTime = 0;
        }
        if ($day == 3) {
            $limitTime = $now + (86400 * 3);
        }
        if ($day == 5) {
            $limitTime = $now + (86400 * 5);
        }
        if ($day == 10) {
            $limitTime = $now + (86400 * 10);
        }
        if ($day == -1) {
            $limitTime = -1;
        }
        $this->model->where("uid", $uid)->update([
            "limit_time" => $limitTime, //解冻用户
        ]);
        return $this->success();
    }
}