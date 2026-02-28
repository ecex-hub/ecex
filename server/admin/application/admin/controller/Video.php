<?php

namespace app\admin\controller;

use app\common\controller\Backend;
use think\exception\DbException;
use think\response\Json;
use think\Db;
use think\exception\ValidateException;
use think\Exception;
use PDOException;

/**
 * 视频管理
 *
 * @icon fa fa-circle-o
 */
class Video extends Backend
{

    /**
     * Video模型对象
     * @var \app\admin\model\Video
     */
    protected $model = null;

    public function _initialize()
    {
        parent::_initialize();
        $this->model = new \app\admin\model\Video;

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
            ->where("type", 1)
            ->order($sort, $order)
            ->paginate($limit);
        foreach ($list->items() as $k => &$v) {
            $v['coverUrl'] = $this->view->config['upload']['cdnurl'] . $v['coverUrl'];
            $v['video_url'] = $this->view->config['upload']['cdnurl'] . $v['video_url'];
            if($v['is_new']){
                $v['is_new']='是';
            }else{
                $v['is_new']='否';
            }
            if($v['is_hot']){
                $v['is_hot']='是';
            }else{
                $v['is_hot']='否';
            }
        }
        $result = ['total' => $list->total(), 'rows' => $list->items()];
        return json($result);
    }


     /**
     * 添加
     *
     * @return string
     * @throws \think\Exception
     */
    public function add()
    {
        if (false === $this->request->isPost()) {
            return $this->view->fetch();
        }
        $params = $this->request->post('row/a');
        if (empty($params)) {
            $this->error(__('Parameter %s can not be empty', ''));
        }
        $params = $this->preExcludeFields($params);

        // 自动计算视频时长
        if (!empty($params['video_url'])) {
            $videoDuration = $this->calculateVideoDuration($params['video_url']);
            if ($videoDuration !== false) {
                $params['video_duration'] = $videoDuration;
            }
        }

        if ($this->dataLimit && $this->dataLimitFieldAutoFill) {
            $params[$this->dataLimitField] = $this->auth->id;
        }
        $result = false;
        Db::startTrans();
        try {
            //是否采用模型验证
            if ($this->modelValidate) {
                $name = str_replace("\\model\\", "\\validate\\", get_class($this->model));
                $validate = is_bool($this->modelValidate) ? ($this->modelSceneValidate ? $name . '.add' : $name) : $this->modelValidate;
                $this->model->validateFailException()->validate($validate);
            }
            $result = $this->model->allowField(true)->save($params);
            Db::commit();
        } catch (ValidateException|PDOException|Exception $e) {
            Db::rollback();
            $this->error($e->getMessage());
        }
        if ($result === false) {
            $this->error(__('No rows were inserted'));
        }
        $this->success();
    }

    /**
     * 计算视频时长
     * 
     * @param string $videoUrl 视频URL（相对路径，如 /uploads/20260222/xxx.mp4）
     * @return int|false 返回视频时长（秒），失败返回 false
     */
    private function calculateVideoDuration($videoUrl)
    {
        try {
            // 将相对路径转换为绝对路径
            // video_url 格式可能是 /uploads/20260222/xxx.mp4
            $videoUrl = ltrim($videoUrl, '/');
            $videoPath = ROOT_PATH . 'public' . DS . str_replace('/', DS, $videoUrl);
            
            // 检查文件是否存在
            if (!file_exists($videoPath)) {
                \think\Log::write("视频文件不存在: {$videoPath}", 'error');
                return false;
            }
            
            // 检查文件是否可读
            if (!is_readable($videoPath)) {
                \think\Log::write("视频文件不可读: {$videoPath}", 'error');
                return false;
            }
            
            // 使用 getID3 分析视频文件
            // getID3 类在全局命名空间，通过 composer 自动加载
            $getID3 = new \getID3();
            $fileInfo = $getID3->analyze($videoPath);
            
            // 获取视频时长（秒）
            if (isset($fileInfo['playtime_seconds'])) {
                $duration = (int)round($fileInfo['playtime_seconds']);
                return $duration;
            } else {
                \think\Log::write("无法获取视频时长: {$videoPath}", 'error');
                return false;
            }
        } catch (\Exception $e) {
            \think\Log::write("计算视频时长失败: " . $e->getMessage(), 'error');
            return false;
        }
    }

    /**
     * 默认生成的控制器所继承的父类中有index/add/edit/del/multi五个基础方法、destroy/restore/recyclebin三个回收站方法
     * 因此在当前控制器中可不用编写增删改查的代码,除非需要自己控制这部分逻辑
     * 需要将application/admin/library/traits/Backend.php中对应的方法复制到当前控制器,然后进行修改
     */


}
