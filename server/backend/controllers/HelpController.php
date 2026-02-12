<?php

namespace backend\controllers;

use Yii;
use common\models\UserDataManagement;

/**
 * 帮助与资料管理相关接口
 */
class HelpController extends \backend\lib\ApiBaseController
{
    public $layout = false;

    /**
     * @OA\Post(
     *     path="/help/data-management",
     *     summary="提交资料信息管理表单",
     *     tags={"帮助"},
     *     security={{"bearerAuth": {}}},
     *     @OA\RequestBody(
     *         required=true,
     *         description="资料信息表单",
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 required={"name", "id_number", "projects"},
     *                 @OA\Property(
     *                     property="name",
     *                     description="姓名",
     *                     type="string",
     *                     example="张三"
     *                 ),
     *                 @OA\Property(
     *                     property="id_number",
     *                     description="身份证号",
     *                     type="string",
     *                     example="110101199001011234"
     *                 ),
     *                 @OA\Property(
     *                     property="projects",
     *                     description="曾参加的项目及详细描述",
     *                     type="string",
     *                     example="1、ABC 项目；2、DEF 项目"
     *                 ),
     *                 @OA\Property(
     *                     property="contribution",
     *                     description="业绩贡献，该项目滞留的总资产",
     *                     type="number",
     *                     format="float",
     *                     example=1000000.00
     *                 ),
     *                 @OA\Property(
     *                     property="additional_notes",
     *                     description="补充说明",
     *                     type="string",
     *                     example="其他需要说明的情况"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="操作成功",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(property="data", type="nullable", example=null)
     *         )
     *     )
     * )
     */
    public function actionDataManagement()
    {
        // 前端传参（提交或更新一条记录）
        $params = $this->params(['name', 'id_number', 'projects', 'contribution', 'additional_notes']);
        // 必填项校验
        $this->VerificationParameter($params, ['name', 'id_number', 'projects']);

        $user = Yii::$app->user->identity;
        if (empty($user)) {
            $this->output_error('用户未登录', 401);
        }

        $model = new UserDataManagement();
        $success = $model->addRecord(
            $user->uid,
            $params['name'],
            $params['id_number'],
            $params['projects'],
            $params['contribution'],
            $params['additional_notes']
        );

        if ($success) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            if (!empty($error_mesg[0])) {
                $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
            } else {
                $this->output_error('提交失败，请稍后重试', 500);
            }
        }
    }

    /**
     * @OA\Get(
     *     path="/help/data-management",
     *     summary="获取资料信息管理表单最新记录",
     *     tags={"帮助"},
     *     security={{"bearerAuth": {}}},
     *     @OA\Response(
     *         response=200,
     *         description="成功返回最近一次提交记录（如不存在则 data 为空）",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="success"),
     *             @OA\Property(
     *                 property="data",
     *                 type="object",
     *                 nullable=true,
     *                 @OA\Property(property="name", type="string", example="张三"),
     *                 @OA\Property(property="id_number", type="string", example="110101199001011234"),
     *                 @OA\Property(property="projects", type="string", example="1、ABC 项目；2、DEF 项目"),
     *                 @OA\Property(property="contribution", type="number", format="float", example=1000000.00),
     *                 @OA\Property(property="additional_notes", type="string", example="其他需要说明的情况")
     *             )
     *         )
     *     )
     * )
     */
    public function actionDataManagementLatest()
    {
        $user = Yii::$app->user->identity;
        if (empty($user)) {
            $this->output_error('用户未登录', 401);
        }

        $model = new UserDataManagement();
        $latest = $model->find()
            ->where(['uid' => $user->uid])
            ->orderBy(['itime' => SORT_DESC, 'id' => SORT_DESC])
            ->asArray()
            ->one();

        if (empty($latest)) {
            $this->output(null);
            return;
        }

        $data = [
            'name' => $latest['name'],
            'id_number' => $latest['id_number'],
            'projects' => $latest['projects'],
            'contribution' => $latest['contribution'],
            'additional_notes' => $latest['additional_notes'],
        ];

        $this->output($data);
    }
}

