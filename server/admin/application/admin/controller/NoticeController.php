<?php

/**
 * _______________#########_______________________
 * ______________############_____________________
 * ______________#############____________________
 * _____________##__###########___________________
 * ____________###__######_#####__________________
 * ____________###_#######___####_________________
 * ___________###__##########_####________________
 * __________####__###########_####_______________
 * ________#####___###########__#####_____________
 * _______######___###_########___#####___________
 * _______#####___###___########___######_________
 * ______######___###__###########___######_______
 * _____######___####_##############__######______
 * ____#######__#####################_#######_____
 * ____#######__##############################____
 * ___#######__######_#################_#######___
 * ___#######__######_######_#########___######___
 * ___#######____##__######___######_____######___
 * ___#######________######____#####_____#####____
 * ____######________#####_____#####_____####_____
 * _____#####________####______#####_____###______
 * ______#####______;###________###______#________
 * ________##_______####________####______________
 */

namespace backend\controllers;

use common\models\NoticeRead;
use Yii;
use common\models\Notice;


class NoticeController extends \backend\lib\ApiBaseController
{

    /**
     * @OA\POST(
     *     path="/notice/list",
     *     summary="公告",
     *     description="This API returns a paginated list of items with video details.",
     *     operationId="getItems",
     *     tags={"通知"},
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         description="The page number for pagination.",
     *         required=true,
     *         @OA\Schema(
     *             type="integer",
     *             example=1
     *         )
     *     ),
     *     @OA\Parameter(
     *         name="size",
     *         in="query",
     *         description="The number of items per page.",
     *         required=true,
     *         @OA\Schema(
     *             type="integer",
     *             example=10
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="A successful response with a list of items.",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(
     *                     property="list",
     *                     type="array",
     *                     @OA\Items(
     *                         type="object",
     *                         @OA\Property(
     *                             property="id",
     *                             type="string",
     *                             example="2"
     *                         ),
     *                         @OA\Property(
     *                             property="title",
     *                             type="string",
     *                             example="nihoa"
     *                         ),
     *                         @OA\Property(
     *                             property="content",
     *                             type="string",
     *                             example="你好"
     *                         ),
     *                         @OA\Property(
     *                             property="create_time",
     *                             type="string",
     *                             example="2024-12-01"
     *                         )
     *                     )
     *                 )
     *             )
     *         )
     *     )
     * )
     */
    public function actionList()
    {
        $params = $this->params([
            'page',
            'size',
        ]);
        $uid = Yii::$app->user->identity->uid;
        $model = new Notice();
        $list = $model->getClientList($params['page'], $params['size']);
        foreach ($list as &$item) {
            $item['is_read'] = false;
            $model = new NoticeRead();
            $info = $model->getInfo($uid, $item['id']);
            if ($info) {
                $item['is_read'] = true;
            }
            $item['create_time'] = date("Y-m-d H:i:s", $item['itime']);
        }
        $this->output($list);
    }


    /**
     * @OA\POST(
     *     path="/notice/user-list",
     *     summary="用户通知",
     *     description="This API returns a paginated list of items with video details.",
     *     tags={"通知"},
     *     @OA\Parameter(
     *         name="page",
     *         in="query",
     *         description="The page number for pagination.",
     *         required=true,
     *         @OA\Schema(
     *             type="integer",
     *             example=1
     *         )
     *     ),
     *     @OA\Parameter(
     *         name="size",
     *         in="query",
     *         description="The number of items per page.",
     *         required=true,
     *         @OA\Schema(
     *             type="integer",
     *             example=10
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="A successful response with a list of items.",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(
     *                     property="list",
     *                     type="array",
     *                     @OA\Items(
     *                         type="object",
     *                         @OA\Property(
     *                             property="id",
     *                             type="string",
     *                             example="2"
     *                         ),
     *                         @OA\Property(
     *                             property="title",
     *                             type="string",
     *                             example="nihoa"
     *                         ),
     *                         @OA\Property(
     *                             property="content",
     *                             type="string",
     *                             example="你好"
     *                         ),
     *                         @OA\Property(
     *                             property="create_time",
     *                             type="string",
     *                             example="2024-12-01"
     *                         )
     *                     )
     *                 )
     *             )
     *         )
     *     )
     * )
     */
    public function actionUserList()
    {
        $params = $this->params([
            'page',
            'size',
        ]);
        $uid = Yii::$app->user->identity->uid;
        //视频
        $model = new Notice();
        $list = $model->getUserList($uid, $params['page'], $params['size']);
        foreach ($list as &$item) {
            $item['is_read'] = boolval($item['is_read']);
            $item['create_time'] = date("Y-m-d H:i:s", $item['itime']);
        }
        $this->output($list);
    }

    /**
     * @OA\POST(
     *     path="/notice/read",
     *     summary="读取",
     *     description="读取",
     *     tags={"通知"},
     *     @OA\Parameter(
     *         name="id",
     *         in="query",
     *         description="The page number for pagination.",
     *         required=true,
     *         @OA\Schema(
     *             type="integer",
     *             example=1
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="A successful response with a list of items.",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="object"
     *             )
     *         )
     *     )
     * )
     */
    public function actionRead()
    {
        $uid = Yii::$app->user->identity->uid;
        $params = $this->params([
            'id',
        ]);
        $notice = new Notice();
        $noticeInfo = $notice->getInfo($params['id']);
        if (empty($noticeInfo)) {
            $this->output_error('参数有误', 202);
        }
        if ($noticeInfo['uid'] == 0) {

            $uid = Yii::$app->user->identity->uid;
            $where = [
                'and',
                ['=', 'uid', $uid],
                ['=', 'notice_id', $params['id']],
            ];
            $noticeM = new NoticeRead();
            $info = $noticeM->find()->where($where)
                ->asArray()->one();
            if ($info) {
                $this->output();
            }
            //视频
            $model = new NoticeRead();
            $model->insertData([
                "uid" => $uid,
                'notice_id' => $params['id'],
                'itime' => time(),
                'utime' => time()
            ]);
        } else {
            $notice->updateAll([
                'is_read' => 1,
            ], ['uid' => $uid, 'id' => $params['id']]);
        }
        $this->output();
    }


    /**
     * @OA\POST(
     *     path="/notice/all-read",
     *     summary="读取所有",
     *     description="读取",
     *     tags={"通知"},
     *     @OA\Response(
     *         response=200,
     *         description="A successful response with a list of items.",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="object"
     *             )
     *         )
     *     )
     * )
     */
    public function actionAllRead()
    {

        $uid = Yii::$app->user->identity->uid;
        $noticeM = new Notice();
        $ids = $noticeM->getAllIds();
        foreach ($ids as $id) {
            try {
                $model = new NoticeRead();
                $model->insertData([
                    "uid" => $uid,
                    'notice_id' => $id,
                    'itime' => time(),
                    'utime' => time()
                ]);
            } catch (\Exception $e) {

            }
        }
        $noticeM->updateAll([
            'is_read' => 1,
        ], ['uid' => $uid, 'is_read' => 0]);
        $this->output();
    }


    /**
     * @OA\POST(
     *     path="/notice/info",
     *     summary="公告弹窗",
     *     tags={"通知"},
     *     @OA\Response(
     *         response="200",
     *         description="Success",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 @OA\Property(
     *                     property="id",
     *                     type="string",
     *                     example="9"
     *                 ),
     *                 @OA\Property(
     *                     property="title",
     *                     type="string",
     *                     example="1"
     *                 ),
     *                 @OA\Property(
     *                     property="content",
     *                     type="string",
     *                     example="1"
     *                 ),
     *                 @OA\Property(
     *                     property="image",
     *                     type="string",
     *                     example="http://192.168.30.119:8199/uploads/20250107/9b37ccaa401d890d6983b6b75d5afb2c.jpeg"
     *                 ),
     *                 @OA\Property(
     *                     property="itime",
     *                     type="string",
     *                     example="1736241664"
     *                 ),
     *                 @OA\Property(
     *                     property="is_read",
     *                     type="string",
     *                     example="0"
     *                 )
     *             )
     *         )
     *     )
     * )
     */
    public function actionInfo()
    {
        //公告提醒
        $model = new Notice();
        $notice = $model->getLastNotice();
        $this->output($notice);

    }
}