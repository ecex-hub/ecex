<?php

namespace app\admin\controller;

use app\admin\model\Admin;
use app\admin\model\User;
use app\common\controller\Backend;
use app\common\model\Attachment;
use fast\Date;
use think\Db;

/**
 * 控制台
 *
 * @icon   fa fa-dashboard
 * @remark 用于展示当前系统中的统计数据、统计报表及重要实时数据
 */
class Dashboard extends Backend
{

    /**
     * 查看
     */
    public function index()
    {

        $this->view->assign([
            'totaluser' => 0,
            'totaladdon' => "",
            'totaladmin' => 0,
            'totalcategory' => 0,
            'todayusersignup' => 0,
            'todayuserlogin' => 0,
            'sevendau' =>0,
            'thirtydau' => 0,
            'threednu' => 0,
            'sevendnu' => 0,
            'dbtablenums' => 0,
            'dbsize' => 0,
            'totalworkingaddon' => "",
            'attachmentnums' => 0,
            'attachmentsize' => Attachment::sum('filesize'),
            'picturenums' => Attachment::where('mimetype', 'like', 'image/%')->count(),
            'picturesize' => Attachment::where('mimetype', 'like', 'image/%')->sum('filesize'),
        ]);

        $this->assignconfig('column', array_keys([]));
        $this->assignconfig('userdata', array_values([]));

        return $this->view->fetch();
    }

}
