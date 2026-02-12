<?php
/**
 * x消息发送.
 *
 * 
 */

namespace common\helpers;

use Yii;
use yii\db\Migration;

/**
 * Sql Helper
 */
class SqlHelper extends Migration
{

    /**
     * 创建JDB游戏日志表
     * @param string $date 日期
     * @return mixed.
     */
    public static function createJdbRecordData($date)
    {
        $sql = 'USE [JdbLogDB]';
        $sql .= 'CREATE TABLE [dbo].[RecordData_'. $date .'] (
                  [id] int  IDENTITY(1,1) NOT NULL,
                  [ts] varchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [transferId] varchar(128) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [gameSeqNo] varchar(128) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [uid] varchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [gType] int  NOT NULL,
                  [mType] int  NOT NULL,
                  [reportDate] varchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [gameDate] varchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [currency] varchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [bet] decimal(18)  NOT NULL,
                  [win] decimal(18)  NOT NULL,
                  [netWin] decimal(18)  NOT NULL,
                  [denom] decimal(18)  NOT NULL,
                  [ipAddress] varchar(64) COLLATE Chinese_PRC_CI_AS  NULL,
                  [clientType] varchar(32) COLLATE Chinese_PRC_CI_AS  NULL,
                  [systemTakeWin] int  NULL,
                  [sessionNo] varchar(64) COLLATE Chinese_PRC_CI_AS  NULL,
                  [mb] decimal(18)  NULL,
                  [transaction_status] int  NOT NULL,
                  [detailedRecord] varchar(255) COLLATE Chinese_PRC_CI_AS  NULL,
                  [channelID] int  NULL
                )';
        $sql .= 'ALTER TABLE [dbo].[RecordData_ ' . $date . ' ] SET (LOCK_ESCALATION = TABLE)
                 ALTER TABLE [dbo].[RecordData_ ' . $date . ' ] ADD CONSTRAINT [PK__RecordDa__' . $date . ' ] PRIMARY KEY CLUSTERED ([transferId])
                 WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
                 ON [PRIMARY]';
        $boor = Yii::$app->db->createCommand($sql)->execute();
        if ($boor) {
            Yii::$app->redis->set('Jdb_RecordData_' . $date, 1);
            Yii::$app->redis->expire('Jdb_RecordData_' . $date, 86400);
            return $boor;
        }
        return false;
    }

    /**
     * 创建PG游戏日志表
     * @param string $date 日期
     * @return mixed.
     */
    public static function createPgRecordData($date)
    {
        $sql = 'USE [PGLogDB]';
        $sql .= 'CREATE TABLE [dbo].[RecordData_' . $date . ' ] (
                  [id] int  IDENTITY(1,1) NOT NULL,
                  [player_name] varchar(64) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [game_id] int  NOT NULL,
                  [parent_bet_id] varchar(256) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [bet_id] varchar(256) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [currency_code] varchar(64) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                 [bet_amount] decimal(18,4)  DEFAULT 0 NOT NULL,
                 [win_amount] decimal(18,4)  DEFAULT 0 NOT NULL,
                 [transfer_amount] decimal(18,4)  NOT NULL,
                 [transaction_id] varchar(256) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                 [wallet_type] varchar(64) COLLATE Chinese_PRC_CI_AS  NULL,
                 [is_minus_count] int  NULL,
                 [bet_type] int  NULL,
                 [updated_time] varchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [create_time] varchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [channelID] int  NULL,
                  [detailed_info] text  NULL,
            )
            ';
        $sql .= 'ALTER TABLE [dbo].[RecordData_' . $date . ' ] SET (LOCK_ESCALATION = TABLE)
                 ALTER TABLE [dbo].[RecordData_' . $date . ' ] ADD CONSTRAINT [PK__RecordDa__' . $date . ' ] PRIMARY KEY CLUSTERED ([transaction_id])
                 WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
                 ON [PRIMARY]';
        $boor = Yii::$app->db->createCommand($sql)->execute();
        if ($boor) {
            Yii::$app->redis->set('Pg_RecordData_' . $date, 1);
            Yii::$app->redis->expire('Pg_RecordData_' . $date, 86400);
            return $boor;
        }
        return false;
    }

    /**
     * 创建库存表
     * @param type $table 表名
     * @param type $data 行集合
     * @return type
     */
    public function createStockSql($table, $data)
    {
        $sql = 'USE [BackendDB] 
                SET ANSI_NULLS ON 
                SET QUOTED_IDENTIFIER ON 
                CREATE TABLE [dbo].[' . $table . ']([_id] [varchar](12) NOT NULL,[date] [varchar](50) NULL,';
        foreach ($data as $key => $value) {
            $sql .= $key . ' [bigint] NULL,';
        }
        $sql .= '[itime] [int] NULL,[utime] [int] NULL, CONSTRAINT [PK_' . $table . '] PRIMARY KEY CLUSTERED ([_id] ASC )
	             WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY]
                 ';
        $boor = Yii::$app->db->createCommand($sql)->execute();
        return $boor;
    }

    /**
     * 库存表添加字段
     * @param type $table 表名
     * @param type $data 行集合
     * @return type
     */
    public function addColumnStockSql($table, $data)
    {
        $sql = 'select * from {{' . $table . '}} ';
        $column = Yii::$app->db->createCommand($sql)->queryOne();
        $column = array_keys($column);
        foreach ($data as $key => $value) {
            if (!in_array($key, $column)) {
                $this->addColumn($table, $key, $this->bigInteger());
            }
        }
    }

    /**
     * 表删除字段
     * @param type $table 表名
     * @param type $data 行集合
     * @return type
     */
    public function dropColumn($table, $data)
    {
        foreach ($data as $key => $value) {
            $this->dropColumn($table, $key);
        }
    }

    /**
     * 创建BG游戏日志表
     * @param string $date 日期
     * @return mixed.
     */
    public static function createBgRecordData($date)
    {
        $sql = 'USE [BGLogDB]';
        $sql .= 'CREATE TABLE [dbo].[RecordData_' . $date . '] (
                  [id] int  IDENTITY(1,1) NOT NULL,
                  [loginId] int  NOT NULL,
                  [bgUserId] varchar(128) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [moduleId] int  NOT NULL,
                  [tranId] varchar(256) COLLATE Chinese_PRC_CI_AS   NULL,
                  [orderId]  bigint  NOT NULL,
                  [gameId] varchar(128) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [basics_amount] decimal(18,4) DEFAULT 0 NOT NULL,
                  [issueId] varchar(32) COLLATE Chinese_PRC_CI_AS   NULL,
                  [playId] varchar(32) COLLATE Chinese_PRC_CI_AS   NULL,
                  [orderFrom] int  NOT NULL,
                  [fromIp] varchar(128) COLLATE Chinese_PRC_CI_AS   NULL,
                  [gameResult] text COLLATE Chinese_PRC_CI_AS  NULL,
                  [recalc] varchar(32) COLLATE Chinese_PRC_CI_AS  NULL,
                  [orderAmount] decimal(18,4) DEFAULT 0  NULL,
                  [orderStatus] int  NOT NULL,
                  [validAmount] decimal(18,4) DEFAULT 0 NULL,
                  [winAmount] decimal(18,4) DEFAULT 0 NOT NULL,
                  [channelID] int  NULL,
                  [itime] int  NOT NULL,
                  [utime] int  NOT NULL
            )
            ';
        $sql .= 'ALTER TABLE [dbo].[RecordData_' . $date . '] SET (LOCK_ESCALATION = TABLE)
                 ALTER TABLE [dbo].[RecordData_' . $date . '] ADD CONSTRAINT [PK__RecordDa__' . $date . ' ] PRIMARY KEY CLUSTERED ([orderId])
                 WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
                 ON [PRIMARY]';
        $boor = Yii::$app->db->createCommand($sql)->execute();
        if ($boor) {
            Yii::$app->redis->set('Bg_RecordData_' . $date, 1);
            Yii::$app->redis->expire('Bg_RecordData_' . $date, 2 * 86400);
            return $boor;
        }
        return false;
    }

    /**
     * 创建PG游戏日志表(老)
     * @param string $date 日期
     * @return mixed.
     */
    public static function createPgRecordDataOld($date)
    {
        $sql = 'USE [PGLogDB]';
        $sql .= 'CREATE TABLE [dbo].[RecordData_' . $date . '] (
                  [id] int  IDENTITY(1,1) NOT NULL,
                  [player_name] varchar(64) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [game_id] int  NOT NULL,
                  [parent_bet_id] varchar(256) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [bet_id] varchar(256) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [currency_code] varchar(64) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                 [bet_amount] decimal(18,4)  DEFAULT 0 NOT NULL,
                 [win_amount] decimal(18,4)  DEFAULT 0 NOT NULL,
                 [transfer_amount] decimal(18,4)  NOT NULL,
                 [transaction_id] varchar(256) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                 [wallet_type] varchar(64) COLLATE Chinese_PRC_CI_AS  NULL,
                 [is_minus_count] int  NULL,
                 [bet_type] int  NULL,
                 [updated_time] varchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                 [is_validate_bet] int   NULL,
                 [is_adjustment] int   NULL,
                 [is_parent_zero_stake] int  NULL,
                 [is_feature] int  NULL,
                 [is_feature_buy] int NULL,
                 [is_wager] int  NULL,
                 [is_end_round] int  NULL,
                  [free_game_transaction_id] varchar(256) COLLATE Chinese_PRC_CI_AS  NULL,
                  [free_game_name] varchar(256) COLLATE Chinese_PRC_CI_AS  NULL,
                  [free_game_id] varchar(64) COLLATE Chinese_PRC_CI_AS  NULL,
                  [is_minus_count] int  NULL,
                  [bonus_transaction_id] varchar(128) COLLATE Chinese_PRC_CI_AS  NULL,
                  [bonus_name] varchar(128) COLLATE Chinese_PRC_CI_AS  NULL,
                  [bonus_id] int  NULL,
                  [bonus_balance_amount]  decimal(18,4)   NULL,,
                  [bonus_ratio_amount] decimal(18,4)   NULLL,
                  [jackpot_rtp_contribution_amount] decimal(18,4)   NULLL,,
                  [create_time] varchar(32) COLLATE Chinese_PRC_CI_AS  NOT NULL,
                  [channelID] int  NULL,
            )
            ';
        $sql .= 'ALTER TABLE [dbo].[RecordData_' . $date . '] SET (LOCK_ESCALATION = TABLE)
                 ALTER TABLE [dbo].[RecordData_' . $date . '] ADD CONSTRAINT [PK__RecordDa__' . $date . ' ] PRIMARY KEY CLUSTERED ([transaction_id])
                 WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
                 ON [PRIMARY]';
        $boor = Yii::$app->db->createCommand($sql)->execute();
        if ($boor) {
            Yii::$app->redis->set('Pg_RecordData_' . $date, 1);
            Yii::$app->redis->expire('Pg_RecordData_' . $date, 86400);
            return $boor;
        }
        return false;
    }

    /**
     * 创建BL游戏日志表
     * @param string $date 日期
     * @return mixed.
     */
    public static function createBlRecordData($date)
    {
        $sql = "CREATE TABLE  IF NOT EXISTS `bllogdb`.`recorddata_$date` (
                    `id` int(11) NOT NULL AUTO_INCREMENT,
                    `player_account` int(11)  NOT NULL,
                    `operator_id` varchar(128)  NOT NULL,
                    `operator_sub_id` varchar(128)  NULL,
                    `game_code` varchar(128) NOT NULL,
                    `report_id` varchar(256) NOT NULL,
                    `amount` decimal(18,4) DEFAULT 0 NOT NULL,
                    `type`  int(11)  NOT NULL,
                    `time` int(11)  NOT NULL,
                    `app_id` varchar(128)  NULL,
                    `cost_info` text  NULL,
                    `cost_type` int  NOT NULL,
                    `gain_gold` decimal(18,4) DEFAULT 0 NOT NULL,
                    `bet_num` decimal(18,4) DEFAULT 0 NOT NULL,
                    `bet_base` decimal(18,4) DEFAULT 0 NOT NULL,
                    `taxes` decimal(18,4) DEFAULT 0 NOT NULL,
                    `bet_card` varchar(256)   NULL,
                    `game_type` int   NULL,
                    `channelID` int  NULL,
                    `utime` int  NOT NULL,
                    PRIMARY KEY (`id`))";
       Yii::$app->db->createCommand($sql)->execute();
        Yii::$app->redis->set('Bl_RecordData_' . $date, 1);
        Yii::$app->redis->expire('Bl_RecordData_' . $date, 2 * 86400);
        return true;
    }

    /**
     * 创建BoleBit游戏日志表
     * @param string $date 日期
     * @return mixed.
     */
    public static function createBoleBitRecordData($date)
    {
        $sql = "CREATE TABLE  IF NOT EXISTS `bolebitlogdb`.`recorddata_$date` (
                  `id` int(11)  NOT NULL AUTO_INCREMENT,
                  `account_id` varchar(64)  NOT NULL,
                  `game_id` varchar(64)  NOT NULL,
                  `game_type` varchar(16)  NOT NULL,
                  `sn` varchar(128)   NOT NULL,
                  `currency` varchar(32)   NULL,
                 `bet` decimal(18,4)  DEFAULT 0 NOT NULL,
                 `win` decimal(18,4)  DEFAULT 0 NOT NULL,
                `details` text  NOT NULL,
                 `create_time` varchar(13)   NOT NULL,
                `channelID` int  NULL,
                 `water` decimal(18,4)  DEFAULT 0  NOT NULL,
                PRIMARY KEY (`id`)) ";
        $boor = Yii::$app->db->createCommand($sql)->execute();
        if ($boor) {
            Yii::$app->redis->set('BoleBit_RecordData_' . $date, 1);
            Yii::$app->redis->expire('BoleBit_RecordData_' . $date, 86400);
            return $boor;
        }
        return false;
    }
}
