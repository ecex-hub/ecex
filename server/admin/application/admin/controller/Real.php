<?php

namespace app\admin\controller;

use app\admin\model\Account;
use app\admin\model\Bill;
use app\common\controller\Backend;
use think\Db;
use think\db\exception\DataNotFoundException;
use think\db\exception\ModelNotFoundException;
use think\exception\DbException;
use think\response\Json;
use \app\admin\model\Real as RealModel;

/**
 * 实名认证
 *
 * @icon fa fa-circle-o
 */
class Real extends Backend
{

    /**
     * Real模型对象
     * @var \app\admin\model\Real
     */
    protected $model = null;
    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\Real;

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
            ->with(["user"])
            ->order('type', "asc")
            ->paginate($limit);
        $typeArr = [
            1 => '默认',
            2 => '通过',
            3 => '拒绝',
        ];
        foreach ($list->items() as $k => &$v) {
            $v['IDFrontUrl'] = $this->view->config['upload']['cdnurl'] . $v['IDFrontUrl'];
            $v['IDOppositeUrl'] = $this->view->config['upload']['cdnurl'] . $v['IDOppositeUrl'];
            $v['_type'] = $v['type'];
            $v['type'] = $typeArr[$v['type']] ?? "";
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
    /**
     * 通过
     *
     * @param $ids
     * @return void
     * @throws DbException
     * @throws DataNotFoundException
     * @throws ModelNotFoundException
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
        $result = $row->allowField(true)->save([
            'type' => 2,
        ]);
        Db::transaction(function () use ($ids, $row) {
            //实名认证
            $realModel = new RealModel();
            $realModel->whereIn("id", $ids)->update(['type' => 2]);

            //用户账号
            $money = 10000;
            $accountModel = new Account();
            $accountModel->where('uid', $row->uid)
                ->inc("dream_fund", $money)
                ->update([
                    'realName' => $row->realName,
                    'IDFrontUrl' => $row->IDFrontUrl,
                    'IDOppositeUrl' => $row->IDOppositeUrl,
                    'IDCard' => $row->IDCard,
                    'is_real' => 2,
                ]);

            //圆梦基金
            $billData = [
                'uid' => $row->uid,
                'money' => $money,
                'money_type' => Bill::MoneyTypeFour,
                'bill_unit' => 'add',
                'bill_type' => Bill::BillTypeRegister,
                'itime' => time(),
                'utime' => time(),
            ];
            $billModel = new Bill();
            $billModel->data($billData);
            $billModel->save();
        });
        $this->makeInviteUserAuth($row->uid);
        $notice = new \app\admin\model\Notice();
        $data = [
            'uid' => $row->uid,
            'title' => '实名认证通知',
            'content' => "实名认证成功，您发起的实名认证成功，系统已发放奖励到国众基金，请查收",
            'msg_type' => 2,
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $notice->insert($data);
        $this->success();
    }


    public function makeInviteUserAuth($uid)
    {
        $account = new Account();
        $user = $account->find($uid);
        if (empty($user)) {
            return;
        }
        //给oneLevel 加钱
        if (empty($user['oneLevel'])) {
            return;
        }
        //实名认证
        $inviteUid = $user['oneLevel'];
        $uid = $user['uid'];
        //用户账号
        $money = 10000;
        $payBack = 2;
        $accountModel = new Account();
        $accountModel->where('uid', $inviteUid)
            ->inc("pay_back", $payBack)
            ->inc('dream_fund', $money)->update();
        //加基金
        $billData = [
            'uid' => $inviteUid,
            'money' => $money,
            'money_type' => Bill::MoneyTypeFour,
            'bill_unit' => 'add',
            'bill_type' => Bill::BillTypeInviteAuth,
            'ext_id' => $uid,
            'itime' => time(),
            'utime' => time(),
        ];
        $billModel = new Bill();
        $billModel->data($billData);
        $billModel->save();

        //加
        $billDataA = [
            'uid' => $inviteUid,
            'money' => $payBack,
            'money_type' => Bill::MoneyTypeTwo,
            'bill_unit' => 'add',
            'bill_type' => Bill::BillTypeInviteAuth,
            'ext_id' => $uid,
            'itime' => time(),
            'utime' => time(),
        ];
        $billModelA = new Bill();
        $billModelA->data($billDataA);
        $billModelA->save();
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
        $result = $row->allowField(true)->save([
            'type' => 3,
        ]);
        $accountModel = new Account();
        $accountModel->where('uid', $row->uid)
            ->update([
                'is_real' => 3,
            ]);
        $notice = new \app\admin\model\Notice();
        $data = [
            'uid' => $row->uid,
            'title' => '实名认证通知',
            'content' => "实名认证失败，您发起的实名认证审核失败，请重新上传或者联系客服",
            'msg_type' => 3,
            'itime' => time(), //加入时间
            'utime' => time(), //更新时间
        ];
        $notice->insert($data);
        $this->success();
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
            $result = $row->allowField(true)->save([
                'type' => 2,
            ]);
            Db::transaction(function () use ($id, $row) {
                //实名认证
                $realModel = new RealModel();
                $realModel->whereIn("id", $id)->update(['type' => 2]);

                //用户账号
                $money = 10000;
                $accountModel = new Account();
                $accountModel->where('uid', $row->uid)
                    ->inc("dream_fund", $money)
                    ->update([
                        'realName' => $row->realName,
                        'IDCard' => $row->IDCard,
                        'IDFrontUrl' => $row->IDFrontUrl,
                        'IDOppositeUrl' => $row->IDOppositeUrl,
                        'is_real' => 2,
                    ]);

                //圆梦基金
                $billData = [
                    'uid' => $row->uid,
                    'money' => $money,
                    'money_type' => Bill::MoneyTypeFour,
                    'bill_unit' => 'add',
                    'bill_type' => Bill::BillTypeRegister,
                    'itime' => time(),
                    'utime' => time(),
                ];
                $billModel = new Bill();
                $billModel->data($billData);
                $billModel->save();
            });
            $this->makeInviteUserAuth($row->uid);
            $notice = new \app\admin\model\Notice();
            $data = [
                'uid' => $row->uid,
                'title' => '实名认证通知',
                'content' => "实名认证成功，您发起的实名认证成功，系统已发放奖励到国众基金，请查收",
                'msg_type' => 2,
                'itime' => time(), //加入时间
                'utime' => time(), //更新时间
            ];
            $notice->insert($data);
        }
        $this->success();
    }

    public function multinopass($ids = null)
    {
        $ids = $ids ?: $this->request->post("ids");
        if (empty($ids)) {
            $this->error(__('Parameter %s can not be empty', 'ids'));
        }
        foreach ($ids as $id) {
            $row = $this->model->get($id);
            if ($row->type != 1) {
                continue;
            }
            $result = $row->allowField(true)->save([
                'type' => 3,
            ]);
            $accountModel = new Account();
            $accountModel->where('uid', $row->uid)
                ->update([
                    'is_real' => 3,
                ]);
            $notice = new \app\admin\model\Notice();
            $data = [
                'uid' => $row->uid,
                'title' => '实名认证通知',
                'content' => "实名认证失败，您发起的实名认证审核失败，请重新上传或者联系客服",
                'msg_type' => 3,
                'itime' => time(), //加入时间
                'utime' => time(), //更新时间
            ];
            $notice->insert($data);
        }
        $this->success();
    }
}
