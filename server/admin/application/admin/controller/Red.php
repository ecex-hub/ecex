<?php

namespace app\admin\controller;

use app\admin\model\UserRedPacket;
use app\admin\model\UserRedPacketTotal;

use app\common\controller\Backend;
use think\Db;
use think\exception\DbException;
use think\exception\PDOException;
use think\exception\ValidateException;
use think\response\Json;

/**
 *
 * @icon fa fa-circle-o
 */
class Red extends Backend
{

    /**
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
            ->order($sort, $order)
            ->paginate($limit);
        foreach ($list->items() as $v) {
            $redM = new UserRedPacket();
            $v->normal_red = $redM->where('uid', $v['uid'])
                ->where("type", 1)
                ->where("is_receive", 0)
                ->count();
            $v->to_red = $redM->where('uid', $v['uid'])
                ->where("type", 2)
                ->where("is_receive", 0)
                ->count();
            $v->to_money = $redM->where('uid', $v['uid'])
                ->where("type", 2)
                ->where("is_receive", 0)
                ->sum("money");;
        }
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
    }


    public function add()
    {
        if (false === $this->request->isPost()) {
            return $this->view->fetch();
        }
        $params = $this->request->post('row/a');
        if (empty($params)) {
            $this->error(__('Parameter %s can not be empty', ''));
        }
        $uid = $params['uid'];
        $user = $this->model->where("uid", $uid)->find();
        if (empty($user)) {
            $this->error("用户不存在");
        }
        $params = $this->preExcludeFields($params);
        if ($this->dataLimit && $this->dataLimitFieldAutoFill) {
            $params[$this->dataLimitField] = $this->auth->id;
        }
        $adminId = $this->auth->id;
        $totalData = [
            'uid' => $params['uid'],
            'money' => $params['money'] ?? 0,
            'type' => $params['type'],
            'num' => $params['num'],
            'itime' => time(),
            'utime' => time(),
            'operation_uid' => $adminId,
        ];
        $totalM = new UserRedPacketTotal();
        $totalM->insert($totalData);
        $allData = [];
        for ($i = 0; $i < $params['num']; $i++) {
            $money = $params['money'];
            if ($params['type'] == 1) {
                $money = $this->generateRedEnvelopeAmount();
            }
            $data = [
                'uid' => $params['uid'],
                'money' => $money,
                'type' => $params['type'],
                'itime' => time(),
                'utime' => time(),
            ];
            $allData[] = $data;
        }
        if ($allData) {
            $redM = new UserRedPacket();
            $redM->insertAll($allData);
        }
        $this->success();
    }

    function generateRedEnvelopeAmount($minAmount = 10.00, $maxAmount = 20.00)
    {
        // 初始化红包金额数组
        $amounts = [];

        // 生成所有可能的金额，保留两位小数
        for ($i = $minAmount * 100; $i <= $maxAmount * 100; $i++) {
            $amounts[] = $i / 100;
        }

        // 随机选择一个红包金额
        $totalAmounts = count($amounts);
        $randomIndex = rand(0, $totalAmounts - 1);
        $selectedAmount = $amounts[$randomIndex];

        // 返回随机选中的红包金额，保留两位小数
        return number_format($selectedAmount, 2);
    }

    public function search()
    {
        $uid = $this->request->get('uid');
        if (empty($uid)) {
            $this->error(__('Parameter %s can not be empty', ''));
        }
        $user = $this->model->where("uid", $uid)->find();
        if (empty($user)) {
            $this->error("用户不存在");
        }
        return json($user);
    }
}