<?php

use yii\db\Migration;

/**
 * 创建用户资料信息管理表单记录表
 */
class m20260212_120000_create_user_data_management_table extends Migration
{
    public function up()
    {
        $tableOptions = null;
        if ($this->db->driverName === 'mysql') {
            $tableOptions = 'CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ENGINE=InnoDB';
        }

        $this->createTable('t_user_data_management', [
            'id' => $this->primaryKey()->unsigned(),
            'uid' => $this->integer()->notNull()->comment('用户ID'),
            'name' => $this->string(64)->notNull()->comment('姓名'),
            'id_number' => $this->string(32)->notNull()->comment('身份证号'),
            'projects' => $this->text()->notNull()->comment('曾参加的项目'),
            'contribution' => $this->decimal(16, 2)->null()->comment('业绩贡献总资产'),
            'additional_notes' => $this->text()->null()->comment('补充说明'),
            'itime' => $this->integer()->notNull()->defaultValue(0)->comment('创建时间'),
            'utime' => $this->integer()->notNull()->defaultValue(0)->comment('更新时间'),
        ], $tableOptions);

        $this->createIndex(
            'idx_user_data_management_uid',
            't_user_data_management',
            'uid'
        );
    }

    public function down()
    {
        $this->dropTable('t_user_data_management');
    }
}

