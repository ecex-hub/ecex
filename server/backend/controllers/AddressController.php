<?php

namespace backend\controllers;

use common\models\Address;
use common\models\City;
use Yii;

class AddressController extends \backend\lib\ApiBaseController
{

    /**
     * @OA\Post(
     *     path="/address/add",
     *     summary="添加收货地址",
     *     tags={"地址"},
     *     @OA\RequestBody(
     *         required=true,
     *         description="用户所需信息",
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 @OA\Property(
     *                     property="name",
     *                     description="姓名",
     *                     type="string",
     *                     example="张三"
     *                 ),
     *                 @OA\Property(
     *                     property="phone",
     *                     description="手机号",
     *                     type="string",
     *                     example="13259303333"
     *                 ),
     *                 @OA\Property(
     *                     property="address",
     *                     description="地址",
     *                     type="string",
     *                     example="北京天安门"
     *                 ),
     *                 @OA\Property(
     *                     property="is_default",
     *                     description="1-初始化 2-默认选中",
     *                     type="integral",
     *                     example="2"
     *                 ),
     *                 @OA\Property(
     *                     property="city_id",
     *                     description="区ID",
     *                     type="integral",
     *                     example="2"
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功返回",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="操作成功"),
     *             @OA\Property(property="data", type="nullable", example="null"),
     *         )
     *     )
     * )
     */
    public function actionAdd()
    {
        $params = $this->params(['name', 'phone', 'address', 'is_default', 'city_id']);
        $this->VerificationParameter($params, ['name', 'phone', 'address', 'is_default', 'city_id']);
        $uid = Yii::$app->user->identity->uid;
        $model = new Address();
        $boor = $model->addAddress($uid,
            $params['name'],
            $params['phone'],
            $params['address'],
            $params['is_default'],
            $params['city_id']
        );
        if ($boor) {
            $this->output();
        } else {
            $error_mesg = $model->getErrors('mesg');
            $this->output_error($error_mesg[0][1], $error_mesg[0][0]);
        }
    }


    /**
     * @OA\Post(
     *     path="/address/del",
     *     summary="删除收获地址",
     *     tags={"地址"},
     *     @OA\RequestBody(
     *         required=true,
     *         description="用户所需信息",
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 @OA\Property(
     *                     property="id",
     *                     description="主键",
     *                     type="integral",
     *                     example=1
     *                 )
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功返回",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="操作成功"),
     *             @OA\Property(property="data", type="nullable", example="null"),
     *         )
     *     )
     * )
     */
    public function actionDel()
    {
        $params = $this->params(['id']);
        $this->VerificationParameter($params, ['id']);
        $uid = Yii::$app->user->identity->uid;
        $model = new Address();
        $bool = $model->updateAll(['type' => 2], ['id' => $params['id'], 'uid' => $uid]);
        if ($bool) {
            $this->output();
        } else {
            $this->output_error("删除失败", 204);
        }
    }

    /**
     * @OA\POST(
     *     path="/address/list",
     *     summary="收货地址列表",
     *     description="Retrieve a paginated list of bank cards bound to the user.",
     *     operationId="getBankCardBindings",
     *     tags={"地址"},
     *     security={{"bearerAuth": {}}},
     *     @OA\Response(
     *         response=200,
     *         description="Successful response with a list of bank card bindings",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(
     *                 property="code",
     *                 type="integer",
     *                 example=200,
     *                 description="HTTP status code"
     *             ),
     *             @OA\Property(
     *                 property="message",
     *                 type="string",
     *                 example="success",
     *                 description="Response message"
     *             ),
     *             @OA\Property(
     *                 property="data",
     *                 type="array",
     *                 @OA\Items(
     *                     type="object",
     *                     @OA\Property(property="id", type="integer", example=1),
     *                     @OA\Property(property="name", type="string", example="李四"),
     *                     @OA\Property(property="phone", type="string", example="13260339999"),
     *                     @OA\Property(property="address", type="string", example="北京朝阳区"),
     *                 )
     *             )
     *         )
     *     ),
     * )
     */
    public function actionList()
    {
        $model = new Address();
        $uid = Yii::$app->user->identity->uid;
        $fields = ['id', 'name', 'phone', 'address', 'is_default', 'city_id'];
        $list = $model->getList(1, 100, $uid, $fields);
        foreach ($list as &$item) {
            $item['area'] = '';
            $item['city'] = "";
            $item['province'] = "";
            $city = new City();
            $areaInfo = $city->getInfo($item['city_id']);
            if ($areaInfo) {
                $item['area'] = $areaInfo['name'];
            }
            $city = new City();
            $cityInfo = $city->getInfo($areaInfo['parent_id']);
            if ($cityInfo) {
                $item['city'] = $cityInfo['name'];
            }
            $city = new City();
            $provinceInfo = $city->getInfo($cityInfo['parent_id']);
            if ($provinceInfo) {
                $item['province'] = $provinceInfo['name'];
            }
            $item['prefix'] = $item['province'] . $item['city'] . $item['area'];
        }
        $this->output($list);
    }


    /**
     * @OA\Post(
     *     path="/address/edit",
     *     summary="修改收货地址",
     *     tags={"地址"},
     *     @OA\RequestBody(
     *         required=true,
     *         description="用户所需信息",
     *         @OA\MediaType(
     *             mediaType="application/json",
     *             @OA\Schema(
     *                 type="object",
     *                 @OA\Property(
     *                     property="id",
     *                     description="主键",
     *                     type="integral",
     *                     example=1
     *                 ),
     *                 @OA\Property(
     *                     property="name",
     *                     description="名称",
     *                     type="string",
     *                     example="李四"
     *                 ),
     *                 @OA\Property(
     *                     property="phone",
     *                     description="手机号",
     *                     type="string",
     *                     example="12223232"
     *                 ),
     *                 @OA\Property(
     *                     property="address",
     *                     description="地址",
     *                     type="string",
     *                     example="北京"
     *                 ),
     *                 @OA\Property(
     *                     property="is_default",
     *                     description="1-初始化 2-默认",
     *                     type="integral",
     *                     example=1
     *                 ),
     *                 @OA\Property(
     *                     property="city_id",
     *                     description="区ID",
     *                     type="integral",
     *                     example="2"
     *                 ),
     *             )
     *         )
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="成功返回",
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="code", type="integer", example=200),
     *             @OA\Property(property="message", type="string", example="操作成功"),
     *             @OA\Property(property="data", type="nullable", example="null"),
     *         )
     *     )
     * )
     */
    public function actionEdit()
    {
        $params = $this->params(['id', 'name', 'phone', 'address', 'is_default', 'city_id']);
        $this->VerificationParameter($params, ['id']);
        $uid = Yii::$app->user->identity->uid;
        $model = new Address();
        $data = [];
        foreach ($params as $key => $item) {
            if (in_array($key, ['name', 'phone', 'address', 'is_default', 'city_id'])) {
                if ($item) {
                    $data[$key] = $item;
                }
            }
            if ($params['city_id']) {
                $city = new City();
                $cityInfo = $city->getInfo($params['city_id']);
                if (empty($cityInfo)) {
                    $this->addError('mesg', ['212', '未选择省市县']);
                    return false;
                }
                $city = new City();
                $provinceInfo = $city->getInfo($cityInfo['parent_id']);
                if (empty($provinceInfo)) {
                    $this->addError('mesg', ['212', '未选择省市县']);
                    return false;
                }
                $data['city_id_a'] = $cityInfo['parent_id'];
                $data['city_id_b'] = $provinceInfo['parent_id'];
            }
        }
        if (empty($data)) {
            $this->output_error("参数有误", 204);
        }
        $bool = $model->updateAll($data, ['id' => $params['id'], 'uid' => $uid]);
        if ($data['is_default'] == 2) {
            $model->setDefault($uid, $params['id']);
        }
        $this->output();
    }
}