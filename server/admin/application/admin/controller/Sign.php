<?php

namespace app\admin\controller;

use app\admin\model\SignInRecord;
use app\common\controller\Backend;
use think\Db;
use think\db\exception\DataNotFoundException;
use think\db\exception\ModelNotFoundException;
use think\exception\DbException;
use think\Log;
use think\response\Json;
use app\admin\model\Account;
use app\admin\model\Bill;
use app\common\library\GRedis;

/**
 * This table stores content with title, author, and additional metadata like cover image, type, and timestamps
 *
 * @icon fa fa-circle-o
 */
class Sign extends Backend
{

    /**
     * News模型对象
     * @var \app\admin\model\News
     */
    protected $model = null;

    protected $relationSearch = true;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\SignInRecord();

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
            ->order("type", "asc")
            ->paginate($limit);
        //奖励类型: 1余额, 2 回报钱包, 3补助钱包, 4圆梦基金
        $rewardTypeArr = [
            1 => '余额',
            2 => '回报钱包',
            3 => '补助钱包',
            4 => '国众基金'
        ];
        $typeArr = [
            1 => '默认',
            2 => '通过',
            3 => '拒绝',
        ];
        foreach ($list->items() as $k => &$v) {
            $v['img'] = $this->view->config['upload']['cdnurl'] . $v['img'];
            $v['rewardType'] = $rewardTypeArr[$v['rewardType']] ?? "";
            $v['_type'] = $v['type'];
            $v['type'] = $typeArr[$v['type']] ?? "";
            $v->getRelation('user')->visible(['nickname']);
            $v->getRelation('user')->visible(['account']);
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
        $signIds = $this->model
            ->where("type", 2)
            ->where("uid", $row->uid)
            ->where("is_pay", 0)
            ->limit(10)
            ->order("id asc")
            ->column("id");
        if (count($signIds) == 10) {
            try {
                Db::transaction(function () use ($signIds, $row) {
                    $signModel = new SignInRecord();
                    $signModel->whereIn("id", $signIds)->update(['is_pay' => 1]);

                    $money = mt_rand(3, 8);
                    $accountModel = new Account();
                    $accountModel->where('uid', $row->uid)
                        ->inc('pay_back', $money)->update();
                    $billData = [
                        'uid' => $row->uid,
                        'money' => $money,
                        'money_type' => 2,
                        'bill_unit' => 'add',
                        'bill_type' => Bill::BillTypeSign,
                        'itime' => time(),
                        'utime' => time(),
                    ];
                    $billModel = new Bill();
                    $billModel->data($billData);
                    $billModel->save();

                    $redis = new GRedis();
                    $key = $redis::SignNotice . $row->uid;
                    $redis->setString($key, $money, $redis::SignNoticeTime);
                });
            } catch (\Exception $e) {
                Log::record("sign:" . $e->getMessage(), 'error');
                $this->error("发放签到奖励失败");
            }
        }
        $this->success();
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
            $signIds = $this->model
                ->where("type", 2)
                ->where("uid", $row->uid)
                ->where("is_pay", 0)
                ->limit(10)
                ->order("id asc")
                ->column("id");

            if (count($signIds) == 10) {
                try {
                    Db::transaction(function () use ($signIds, $row) {
                        $signModel = new SignInRecord();
                        $signModel->whereIn("id", $signIds)->update(['is_pay' => 1]);

                        $money = mt_rand(3, 8);
                        $accountModel = new Account();
                        $accountModel->where('uid', $row->uid)
                            ->inc('pay_back', $money)->update();
                        $billData = [
                            'uid' => $row->uid,
                            'money' => $money,
                            'money_type' => 2,
                            'bill_unit' => 'add',
                            'bill_type' => Bill::BillTypeSign,
                            'itime' => time(),
                            'utime' => time(),
                        ];
                        $billModel = new Bill();
                        $billModel->data($billData);
                        $billModel->save();

                        $redis = new GRedis();
                        $key = $redis::SignNotice . $row->uid;
                        $redis->setString($key, $money, $redis::SignNoticeTime);
                    });
                } catch (\Exception $e) {
                    Log::record("sign:" . $e->getMessage(), 'error');
                }
            }
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
        }
        $this->success();
    }

}
