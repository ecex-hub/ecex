/*
 Navicat Premium Dump SQL

 Source Server         : 本地5.7
 Source Server Type    : MySQL
 Source Server Version : 50726 (5.7.26)
 Source Host           : localhost:3306
 Source Schema         : stock

 Target Server Type    : MySQL
 Target Server Version : 50726 (5.7.26)
 File Encoding         : 65001

 Date: 12/02/2026 19:43:45
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for fa_ems
-- ----------------------------
DROP TABLE IF EXISTS `fa_ems`;
CREATE TABLE `fa_ems`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `event` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '事件',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '邮箱',
  `code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '验证码',
  `times` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '验证次数',
  `ip` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'IP',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '邮箱验证码表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fa_ems
-- ----------------------------

-- ----------------------------
-- Table structure for fa_sms
-- ----------------------------
DROP TABLE IF EXISTS `fa_sms`;
CREATE TABLE `fa_sms`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `event` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '事件',
  `mobile` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号',
  `code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '验证码',
  `times` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '验证次数',
  `ip` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'IP',
  `createtime` bigint(16) UNSIGNED NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '短信验证码表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fa_sms
-- ----------------------------

-- ----------------------------
-- Table structure for fa_user_group
-- ----------------------------
DROP TABLE IF EXISTS `fa_user_group`;
CREATE TABLE `fa_user_group`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '组名',
  `rules` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '权限节点',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '添加时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `status` enum('normal','hidden') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fa_user_group
-- ----------------------------
INSERT INTO `fa_user_group` VALUES (1, '默认组', '1,2,3,4,5,6,7,8,9,10,11,12', 1491635035, 1491635035, 'normal');

-- ----------------------------
-- Table structure for fa_user_money_log
-- ----------------------------
DROP TABLE IF EXISTS `fa_user_money_log`;
CREATE TABLE `fa_user_money_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '会员ID',
  `money` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '变更余额',
  `before` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '变更前余额',
  `after` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '变更后余额',
  `memo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员余额变动表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fa_user_money_log
-- ----------------------------

-- ----------------------------
-- Table structure for fa_user_rule
-- ----------------------------
DROP TABLE IF EXISTS `fa_user_rule`;
CREATE TABLE `fa_user_rule`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(10) NULL DEFAULT NULL COMMENT '父ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '标题',
  `remark` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `ismenu` tinyint(1) NULL DEFAULT NULL COMMENT '是否菜单',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NULL DEFAULT 0 COMMENT '权重',
  `status` enum('normal','hidden') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fa_user_rule
-- ----------------------------
INSERT INTO `fa_user_rule` VALUES (1, 0, 'index', 'Frontend', '', 1, 1491635035, 1491635035, 1, 'normal');
INSERT INTO `fa_user_rule` VALUES (2, 0, 'api', 'API Interface', '', 1, 1491635035, 1491635035, 2, 'normal');
INSERT INTO `fa_user_rule` VALUES (3, 1, 'user', 'User Module', '', 1, 1491635035, 1491635035, 12, 'normal');
INSERT INTO `fa_user_rule` VALUES (4, 2, 'user', 'User Module', '', 1, 1491635035, 1491635035, 11, 'normal');
INSERT INTO `fa_user_rule` VALUES (5, 3, 'index/user/login', 'Login', '', 0, 1491635035, 1491635035, 5, 'normal');
INSERT INTO `fa_user_rule` VALUES (6, 3, 'index/user/register', 'Register', '', 0, 1491635035, 1491635035, 7, 'normal');
INSERT INTO `fa_user_rule` VALUES (7, 3, 'index/user/index', 'User Center', '', 0, 1491635035, 1491635035, 9, 'normal');
INSERT INTO `fa_user_rule` VALUES (8, 3, 'index/user/profile', 'Profile', '', 0, 1491635035, 1491635035, 4, 'normal');
INSERT INTO `fa_user_rule` VALUES (9, 4, 'api/user/login', 'Login', '', 0, 1491635035, 1491635035, 6, 'normal');
INSERT INTO `fa_user_rule` VALUES (10, 4, 'api/user/register', 'Register', '', 0, 1491635035, 1491635035, 8, 'normal');
INSERT INTO `fa_user_rule` VALUES (11, 4, 'api/user/index', 'User Center', '', 0, 1491635035, 1491635035, 10, 'normal');
INSERT INTO `fa_user_rule` VALUES (12, 4, 'api/user/profile', 'Profile', '', 0, 1491635035, 1491635035, 3, 'normal');

-- ----------------------------
-- Table structure for fa_user_score_log
-- ----------------------------
DROP TABLE IF EXISTS `fa_user_score_log`;
CREATE TABLE `fa_user_score_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '会员ID',
  `score` int(10) NOT NULL DEFAULT 0 COMMENT '变更积分',
  `before` int(10) NOT NULL DEFAULT 0 COMMENT '变更前积分',
  `after` int(10) NOT NULL DEFAULT 0 COMMENT '变更后积分',
  `memo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员积分变动表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fa_user_score_log
-- ----------------------------

-- ----------------------------
-- Table structure for fa_user_token
-- ----------------------------
DROP TABLE IF EXISTS `fa_user_token`;
CREATE TABLE `fa_user_token`  (
  `token` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Token',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '会员ID',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `expiretime` bigint(16) NULL DEFAULT NULL COMMENT '过期时间',
  PRIMARY KEY (`token`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员Token表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fa_user_token
-- ----------------------------

-- ----------------------------
-- Table structure for fa_version
-- ----------------------------
DROP TABLE IF EXISTS `fa_version`;
CREATE TABLE `fa_version`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `oldversion` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '旧版本号',
  `newversion` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '新版本号',
  `packagesize` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '包大小',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '升级内容',
  `downloadurl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '下载地址',
  `enforce` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '强制更新',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NOT NULL DEFAULT 0 COMMENT '权重',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '版本表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of fa_version
-- ----------------------------

-- ----------------------------
-- Table structure for t_account_info
-- ----------------------------
DROP TABLE IF EXISTS `t_account_info`;
CREATE TABLE `t_account_info`  (
  `uid` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '账号',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码 md5',
  `invite_code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '邀请码',
  `payPassword` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付密码 md5',
  `rechargeAllMoney` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '充值总金额',
  `withdrawalAllMoney` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '提现总金额',
  `buy_product_money` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '购买产品总金额',
  `accountIncome` decimal(18, 2) NULL DEFAULT NULL COMMENT '总收入',
  `money` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '余额',
  `dream_fund` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '圆梦基金',
  `pay_back` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '回报金额',
  `allowance` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '补贴',
  `oneLevel` bigint(20) NULL DEFAULT 0 COMMENT '一级上级',
  `twoLevel` bigint(20) NULL DEFAULT 0 COMMENT '二级上级',
  `threeLevel` bigint(20) NULL DEFAULT 0 COMMENT '三级上级',
  `oneIncome` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '一级总收益',
  `twoIncome` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '二级总收益',
  `threeIncome` decimal(18, 2) NULL DEFAULT 0.00 COMMENT '三级总收益',
  `oneSharePeople` int(11) NULL DEFAULT NULL COMMENT '一级总人数',
  `twoSharePeople` int(11) NULL DEFAULT NULL COMMENT '二级总人数',
  `threeSharePeople` int(11) NULL DEFAULT NULL COMMENT '三级总人数',
  `oneReward` int(11) NULL DEFAULT NULL COMMENT '累积奖励等级1剩余次数',
  `twoReward` int(11) NULL DEFAULT NULL COMMENT '累积奖励等级2剩余次数',
  `threeReward` int(11) NULL DEFAULT NULL COMMENT '累积奖励等级3剩余次数',
  `realName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '姓名',
  `IDCard` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `IDFrontUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证正面 人像',
  `IDOppositeUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证反面 国徽',
  `qq` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'qq',
  `wechat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '微信',
  `RegisterIp` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '注册IP',
  `e_uid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '别名uid',
  `is_real` tinyint(1) NULL DEFAULT 0 COMMENT '1-默认 2-真人认证',
  `itime` int(11) NULL DEFAULT 0,
  `utime` int(11) NULL DEFAULT 0,
  `path` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '用户级别',
  `login_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `last_login_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `account_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '账号状态：0正常，1删除，2冻结',
  PRIMARY KEY (`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_account_info
-- ----------------------------
INSERT INTO `t_account_info` VALUES (1, 'qqq1111', 'qqq1111', '/uploads/2.png', '96e79218965eb72c92a549dd5a330112', 'qHUYMMZWSQ6IwkRT7MsH', '96e79218965eb72c92a549dd5a330112', 0.00, 0.00, 0.00, NULL, 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0.00, 0.00, 0.00, 1, 1, 0, NULL, NULL, NULL, '', '', NULL, NULL, '', '', '127.0.0.1', '', 0, 1769874582, 1769874582, NULL, NULL, NULL, 0);
INSERT INTO `t_account_info` VALUES (2, '222222', '222222', '/uploads/4.png', '96e79218965eb72c92a549dd5a330112', 'hSSBL9gU1Jg3mCBVE1k3', '96e79218965eb72c92a549dd5a330112', 0.00, 0.00, 0.00, NULL, 0.00, 0.00, 0.00, 0.00, 1, 0, 0, 0.00, 0.00, 0.00, 1, 0, 0, NULL, NULL, NULL, '', '', NULL, NULL, '', '', '127.0.0.1', '', 0, 1769875068, 1769875068, '1,', NULL, NULL, 0);
INSERT INTO `t_account_info` VALUES (3, '333333', '333333', '/uploads/1.png', '7fa8282ad93047a4d6fe6111c93b308a', 'AdjLdBwDAhKKSEJ7VIkR', '96e79218965eb72c92a549dd5a330112', 0.00, 0.00, 0.00, NULL, 0.00, 0.00, 0.00, 0.00, 2, 1, 0, 0.00, 0.00, 0.00, 0, 0, 0, NULL, NULL, NULL, '', '', NULL, NULL, '', '', '127.0.0.1', '', 1, 1769875250, 1769875250, '1,2,', '127.0.0.1', '1770896566', 0);

-- ----------------------------
-- Table structure for t_address
-- ----------------------------
DROP TABLE IF EXISTS `t_address`;
CREATE TABLE `t_address`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名字',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '地址',
  `type` int(11) NULL DEFAULT 1 COMMENT '1-创建 2-删除',
  `is_default` tinyint(4) NULL DEFAULT 1 COMMENT '1-初始化 2-默认',
  `itime` int(11) NOT NULL COMMENT '创建时间',
  `utime` int(11) NOT NULL COMMENT '更新时间',
  `city_id` int(11) NULL DEFAULT 0 COMMENT '城市ID',
  `city_id_a` int(11) NULL DEFAULT 0 COMMENT '省',
  `city_id_b` int(11) NULL DEFAULT 0 COMMENT '市',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '收货地址' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_address
-- ----------------------------

-- ----------------------------
-- Table structure for t_admin
-- ----------------------------
DROP TABLE IF EXISTS `t_admin`;
CREATE TABLE `t_admin`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户名',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '昵称',
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码',
  `salt` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码盐',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '电子邮箱',
  `mobile` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `loginfailure` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '失败次数',
  `logintime` bigint(16) NULL DEFAULT NULL COMMENT '登录时间',
  `loginip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '登录IP',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `token` varchar(59) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'Session标识',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'normal' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_admin
-- ----------------------------
INSERT INTO `t_admin` VALUES (1, 'admin', 'admin', 'c34b47113a5da90fb5a13717e5819fa4', '081232b36b87b9a57e9750b2dd15c7', 'http://127.0.0.1:8097/assets/img/avatar.png', 'admin@admin.com', '', 0, 1770119678, '127.0.0.1', 1491635035, 1770119678, '6ad146b7-182a-4144-bd6a-10036b3cb664', 'normal');
INSERT INTO `t_admin` VALUES (2, 'root', '123456', '478bc66ebc75cdc7942966672e14e004', 'Jf4HeD', '/assets/img/avatar.png', 'root@qq.com', '13250023231', 0, 1735874267, '192.168.5.62', 1735198623, 1735874267, '4fe17a1c-3d8a-42bf-bf83-ab03462b9146', 'normal');

-- ----------------------------
-- Table structure for t_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `t_admin_log`;
CREATE TABLE `t_admin_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '管理员ID',
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '管理员名字',
  `url` varchar(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作页面',
  `title` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '日志标题',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'IP',
  `useragent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'User-Agent',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `name`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 275 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_admin_log
-- ----------------------------
INSERT INTO `t_admin_log` VALUES (1, 1, 'admin', '/admin.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\",\"captcha\":\"7dtv\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735020546);
INSERT INTO `t_admin_log` VALUES (2, 1, 'admin', '/admin.php/general.config/edit', '常规管理 / 系统配置 / 编辑', '{\"__token__\":\"***\",\"row\":{\"name\":\"stock\",\"beian\":\"\",\"version\":\"1.0.1\",\"timezone\":\"Asia\\/Shanghai\",\"forbiddenip\":\"\",\"languages\":\"{&quot;backend&quot;:&quot;zh-cn&quot;,&quot;frontend&quot;:&quot;zh-cn&quot;}\",\"fixedpage\":\"dashboard\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735021003);
INSERT INTO `t_admin_log` VALUES (3, 1, 'admin', '/stock.php/news/add?dialog=1', '新闻 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"author\":\"1\",\"coverUrl\":\"1\",\"content\":\"1\",\"type\":\"1\",\"itime\":\"2024-12-24 14:35:21\",\"utime\":\"2024-12-24 14:35:21\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735022142);
INSERT INTO `t_admin_log` VALUES (4, 1, 'admin', '/stock.php/news/edit/ids/1?dialog=1', '新闻 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"你好\",\"author\":\"李明\",\"coverUrl\":\"\",\"content\":\"你好啊\",\"type\":\"1\",\"itime\":\"1970-01-01 08:00:09\",\"utime\":\"1970-01-01 08:00:09\"},\"ids\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735022360);
INSERT INTO `t_admin_log` VALUES (5, 1, 'admin', '/stock.php/news/edit/ids/1?dialog=1', '新闻 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"你好\",\"author\":\"李明\",\"coverUrl\":\"\",\"content\":\"你好啊\",\"type\":\"1\",\"itime\":\"1970-01-28 08:00:09\",\"utime\":\"1970-01-29 08:00:09\"},\"ids\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735022373);
INSERT INTO `t_admin_log` VALUES (6, 1, 'admin', '/stock.php/news/del', '新闻 / 删除', '{\"action\":\"del\",\"ids\":\"1\",\"params\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735022383);
INSERT INTO `t_admin_log` VALUES (7, 0, 'Unknown', '/stock.php/index/login', '', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\",\"captcha\":\"q8zb\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735112821);
INSERT INTO `t_admin_log` VALUES (8, 0, 'Unknown', '/stock.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\",\"captcha\":\"c3kc\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735112829);
INSERT INTO `t_admin_log` VALUES (9, 0, 'Unknown', '/stock.php/index/login', '', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\",\"captcha\":\"mkez\",\"keeplogin\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735112838);
INSERT INTO `t_admin_log` VALUES (10, 0, 'Unknown', '/stock.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\",\"captcha\":\"dera\",\"keeplogin\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735112849);
INSERT INTO `t_admin_log` VALUES (11, 1, 'admin', '/stock.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\",\"captcha\":\"j6ha\",\"keeplogin\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735112904);
INSERT INTO `t_admin_log` VALUES (12, 1, 'admin', '/stock.php/news/edit/ids/2?dialog=1', '新闻 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"author\":\"1\",\"coverUrl\":\"1\",\"content\":\"1\",\"type\":\"2\",\"itime\":\"2024-12-24 14:35:21\",\"utime\":\"2024-12-24 14:35:21\"},\"ids\":\"2\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735112932);
INSERT INTO `t_admin_log` VALUES (13, 1, 'admin', '/stock.php/news/add?dialog=1', '新闻 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"你好\",\"author\":\"我是小李\",\"coverUrl\":\"\",\"content\":\"随时随地\",\"type\":\"1\",\"itime\":\"2024-12-25 15:50:15\",\"utime\":\"2024-12-25 15:50:15\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735113031);
INSERT INTO `t_admin_log` VALUES (14, 1, 'admin', '/stock.php/news/del', '新闻 / 删除', '{\"action\":\"del\",\"ids\":\"3\",\"params\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735113457);
INSERT INTO `t_admin_log` VALUES (15, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735113936);
INSERT INTO `t_admin_log` VALUES (16, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735114591);
INSERT INTO `t_admin_log` VALUES (17, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735114713);
INSERT INTO `t_admin_log` VALUES (18, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735115009);
INSERT INTO `t_admin_log` VALUES (19, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735115121);
INSERT INTO `t_admin_log` VALUES (20, 1, 'admin', '/stock.php/news/add?dialog=1', '新闻 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"author\":\"1\",\"coverUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"content\":\"111\",\"type\":\"1\",\"itime\":\"2024-12-25 16:25:13\",\"utime\":\"2024-12-25 16:25:13\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735115130);
INSERT INTO `t_admin_log` VALUES (21, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735118132);
INSERT INTO `t_admin_log` VALUES (22, 1, 'admin', '/stock.php/news/edit/ids/4?dialog=1', '新闻 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"2\",\"author\":\"1\",\"coverUrl\":\"\\/uploads\\/20241225\\/f3d54e5ccb2caa40c6218433aefeac1e.jpg\",\"content\":\"111\",\"type\":\"1\",\"itime\":\"2024-12-25 16:25:13\",\"utime\":\"2024-12-25 16:25:13\"},\"ids\":\"4\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735118136);
INSERT INTO `t_admin_log` VALUES (23, 1, 'admin', '/stock.php/auth/rule/del', '权限管理 / 菜单规则 / 删除', '{\"action\":\"del\",\"ids\":\"66\",\"params\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735118296);
INSERT INTO `t_admin_log` VALUES (24, 1, 'admin', '/stock.php/general.config/edit', '常规管理 / 系统配置 / 编辑', '{\"__token__\":\"***\",\"row\":{\"name\":\"stock\",\"beian\":\"\",\"version\":\"1.0.7\",\"timezone\":\"Asia\\/Shanghai\",\"forbiddenip\":\"\",\"languages\":\"{&quot;backend&quot;:&quot;zh-cn&quot;}\",\"fixedpage\":\"dashboard\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735118411);
INSERT INTO `t_admin_log` VALUES (25, 1, 'admin', '/stock.php/auth/rule/multi', '权限管理 / 菜单规则', '{\"action\":\"\",\"ids\":\"6\",\"params\":\"ismenu=0\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735118460);
INSERT INTO `t_admin_log` VALUES (26, 1, 'admin', '/stock.php/notice/edit/ids/1?dialog=1', '通知管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"你好啊\",\"content\":\"999\",\"sort\":\"1\",\"type\":\"1\",\"itime\":\"2024-12-03 17:21:43\",\"utime\":\"2024-12-27 17:21:46\"},\"ids\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735118509);
INSERT INTO `t_admin_log` VALUES (27, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120526);
INSERT INTO `t_admin_log` VALUES (28, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120557);
INSERT INTO `t_admin_log` VALUES (29, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120621);
INSERT INTO `t_admin_log` VALUES (30, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120651);
INSERT INTO `t_admin_log` VALUES (31, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120702);
INSERT INTO `t_admin_log` VALUES (32, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120714);
INSERT INTO `t_admin_log` VALUES (33, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120772);
INSERT INTO `t_admin_log` VALUES (34, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120781);
INSERT INTO `t_admin_log` VALUES (35, 1, 'admin', '/stock.php/video/add?dialog=1', '视频管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"西瓜头\",\"coverUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"Video_url\":\"\\/uploads\\/20241225\\/962cc50084f9c5bec691eb91317444e5.mp4\",\"video_duration\":\"10\",\"type\":\"1\",\"itime\":\"2024-12-25 17:59:29\",\"utime\":\"2024-12-25 17:59:29\",\"is_hot\":\"1\",\"is_new\":\"1\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120794);
INSERT INTO `t_admin_log` VALUES (36, 1, 'admin', '/stock.php/video/add?dialog=1', '视频管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"西瓜头\",\"coverUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"Video_url\":\"\\/uploads\\/20241225\\/962cc50084f9c5bec691eb91317444e5.mp4\",\"video_duration\":\"10\",\"type\":\"1\",\"itime\":\"2024-12-25 17:59:29\",\"utime\":\"2024-12-25 17:59:29\",\"is_hot\":\"1\",\"is_new\":\"1\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120800);
INSERT INTO `t_admin_log` VALUES (37, 1, 'admin', '/stock.php/video/add?dialog=1', '视频管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"西瓜头\",\"coverUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"Video_url\":\"\\/uploads\\/20241225\\/962cc50084f9c5bec691eb91317444e5.mp4\",\"video_duration\":\"10\",\"type\":\"1\",\"itime\":\"2024-12-25 17:59:29\",\"utime\":\"2024-12-25 17:59:29\",\"is_hot\":\"1\",\"is_new\":\"1\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120809);
INSERT INTO `t_admin_log` VALUES (38, 1, 'admin', '/stock.php/video/add?dialog=1', '视频管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"西瓜头\",\"coverUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"Video_url\":\"\\/uploads\\/20241225\\/962cc50084f9c5bec691eb91317444e5.mp4\",\"video_duration\":\"10\",\"type\":\"1\",\"itime\":\"2024-12-25 17:59:29\",\"utime\":\"2024-12-25 17:59:29\",\"is_hot\":\"1\",\"is_new\":\"1\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120817);
INSERT INTO `t_admin_log` VALUES (39, 1, 'admin', '/stock.php/video/add?dialog=1', '视频管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"西瓜头\",\"coverUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"Video_url\":\"\\/uploads\\/20241225\\/962cc50084f9c5bec691eb91317444e5.mp4\",\"video_duration\":\"10\",\"type\":\"1\",\"itime\":\"2024-12-25 17:59:29\",\"utime\":\"2024-12-25 17:59:29\",\"is_hot\":\"1\",\"is_new\":\"1\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120818);
INSERT INTO `t_admin_log` VALUES (40, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120833);
INSERT INTO `t_admin_log` VALUES (41, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120839);
INSERT INTO `t_admin_log` VALUES (42, 1, 'admin', '/stock.php/video/add?dialog=1', '视频管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"coverUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"video_url\":\"\\/uploads\\/20241225\\/962cc50084f9c5bec691eb91317444e5.mp4\",\"video_duration\":\"1\",\"type\":\"1\",\"itime\":\"2024-12-25 18:00:24\",\"utime\":\"2024-12-25 18:00:24\",\"is_hot\":\"1\",\"is_new\":\"1\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735120842);
INSERT INTO `t_admin_log` VALUES (43, 1, 'admin', '/stock.php/video/edit/ids/3?dialog=1', '视频管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"coverUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"video_url\":\"\\/uploads\\/20241225\\/962cc50084f9c5bec691eb91317444e5.mp4\",\"video_duration\":\"1\",\"type\":\"1\",\"itime\":\"2024-12-25 18:00:24\",\"utime\":\"2024-12-25 18:00:24\",\"is_hot\":\"1\",\"is_new\":\"1\"},\"ids\":\"3\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735121341);
INSERT INTO `t_admin_log` VALUES (44, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735121715);
INSERT INTO `t_admin_log` VALUES (45, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735121719);
INSERT INTO `t_admin_log` VALUES (46, 1, 'admin', '/stock.php/video/add?dialog=1', '视频管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"coverUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"video_url\":\"\\/uploads\\/20241225\\/962cc50084f9c5bec691eb91317444e5.mp4\",\"video_duration\":\"10\",\"type\":\"1\",\"is_hot\":\"1\",\"is_new\":\"1\",\"sort\":\"1\",\"itime\":\"2024-12-25 18:15:00\",\"utime\":\"2024-12-25 18:15:00\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735121725);
INSERT INTO `t_admin_log` VALUES (47, 1, 'admin', '/stock.php/video/edit/ids/3?dialog=1', '视频管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"coverUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"video_url\":\"\\/uploads\\/20241225\\/962cc50084f9c5bec691eb91317444e5.mp4\",\"video_duration\":\"1\",\"type\":\"1\",\"is_hot\":\"1\",\"is_new\":\"1\",\"sort\":\"7\",\"itime\":\"2024-12-25 18:00:24\",\"utime\":\"2024-12-25 18:00:24\"},\"ids\":\"3\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735121784);
INSERT INTO `t_admin_log` VALUES (48, 1, 'admin', '/stock.php/auth/rule/multi', '权限管理 / 菜单规则', '{\"action\":\"\",\"ids\":\"2\",\"params\":\"ismenu=0\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735121986);
INSERT INTO `t_admin_log` VALUES (49, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735123133);
INSERT INTO `t_admin_log` VALUES (50, 1, 'admin', '/stock.php/carousel/edit/ids/1?dialog=1', '轮播管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"轮播\",\"PicUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"sort\":\"1\",\"type\":\"1\",\"itime\":\"1970-01-01 08:00:01\",\"utime\":\"1970-01-01 08:00:01\"},\"ids\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735123138);
INSERT INTO `t_admin_log` VALUES (51, 1, 'admin', '/stock.php/carousel/edit/ids/1?dialog=1', '轮播管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"轮播1\",\"PicUrl\":\"\",\"sort\":\"1\",\"type\":\"1\",\"itime\":\"1970-01-01 08:00:01\",\"utime\":\"1970-01-01 08:00:01\"},\"ids\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735123165);
INSERT INTO `t_admin_log` VALUES (52, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735123191);
INSERT INTO `t_admin_log` VALUES (53, 1, 'admin', '/stock.php/carousel/add?dialog=1', '轮播管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"nihao\",\"PicUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"sort\":\"0\",\"type\":\"1\",\"itime\":\"2024-12-25 18:39:44\",\"utime\":\"2024-12-25 18:39:44\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735123195);
INSERT INTO `t_admin_log` VALUES (54, 1, 'admin', '/stock.php/carousel/add?dialog=1', '轮播管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"nihao\",\"PicUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"sort\":\"0\",\"type\":\"1\",\"itime\":\"2024-12-25 18:39:44\",\"utime\":\"2024-12-25 18:39:44\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735123217);
INSERT INTO `t_admin_log` VALUES (55, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735123225);
INSERT INTO `t_admin_log` VALUES (56, 1, 'admin', '/stock.php/carousel/add?dialog=1', '轮播管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"picUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"sort\":\"0\",\"type\":\"1\",\"itime\":\"2024-12-25 18:40:19\",\"utime\":\"2024-12-25 18:40:19\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735123227);
INSERT INTO `t_admin_log` VALUES (57, 1, 'admin', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735123244);
INSERT INTO `t_admin_log` VALUES (58, 1, 'admin', '/stock.php/carousel/edit/ids/1?dialog=1', '轮播管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"轮播1\",\"picUrl\":\"\\/uploads\\/20241225\\/c50f50e52573da19a2b7161f21cd8cea.png\",\"sort\":\"1\",\"type\":\"1\",\"itime\":\"1969-12-31 08:00:01\",\"utime\":\"1970-01-08 08:00:01\"},\"ids\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735123254);
INSERT INTO `t_admin_log` VALUES (59, 1, 'admin', '/stock.php/general.profile/update', '常规管理 / 个人资料 / 更新个人信息', '{\"__token__\":\"***\",\"row\":{\"avatar\":\"http:\\/\\/127.0.0.1:8097\\/assets\\/img\\/avatar.png\",\"email\":\"admin@admin.com\",\"nickname\":\"Admin\",\"password\":\"***\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735182160);
INSERT INTO `t_admin_log` VALUES (60, 1, 'admin', '/stock.php/general.profile/update', '常规管理 / 个人资料 / 更新个人信息', '{\"__token__\":\"***\",\"row\":{\"avatar\":\"http:\\/\\/127.0.0.1:8097\\/assets\\/img\\/avatar.png\",\"email\":\"admin@admin.com\",\"nickname\":\"Admin\",\"password\":\"***\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735182161);
INSERT INTO `t_admin_log` VALUES (61, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"name\":\"名称\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735182829);
INSERT INTO `t_admin_log` VALUES (62, 1, 'admin', '/stock.php/sign/pass', '会议签到', '', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735182990);
INSERT INTO `t_admin_log` VALUES (63, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183053);
INSERT INTO `t_admin_log` VALUES (64, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183083);
INSERT INTO `t_admin_log` VALUES (65, 1, 'admin', '/stock.php/sign/nopass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183120);
INSERT INTO `t_admin_log` VALUES (66, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183149);
INSERT INTO `t_admin_log` VALUES (67, 1, 'admin', '/stock.php/sign/nopass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183163);
INSERT INTO `t_admin_log` VALUES (68, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183169);
INSERT INTO `t_admin_log` VALUES (69, 1, 'admin', '/stock.php/sign/nopass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183182);
INSERT INTO `t_admin_log` VALUES (70, 1, 'admin', '/stock.php/sign/nopass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183189);
INSERT INTO `t_admin_log` VALUES (71, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183204);
INSERT INTO `t_admin_log` VALUES (72, 1, 'admin', '/stock.php/sign/nopass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183239);
INSERT INTO `t_admin_log` VALUES (73, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183284);
INSERT INTO `t_admin_log` VALUES (74, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183285);
INSERT INTO `t_admin_log` VALUES (75, 1, 'admin', '/stock.php/sign/nopass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183318);
INSERT INTO `t_admin_log` VALUES (76, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183378);
INSERT INTO `t_admin_log` VALUES (77, 1, 'admin', '/stock.php/sign/nopass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735183380);
INSERT INTO `t_admin_log` VALUES (78, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735184696);
INSERT INTO `t_admin_log` VALUES (79, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735184697);
INSERT INTO `t_admin_log` VALUES (80, 1, 'admin', '/stock.php/sign/nopass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735184698);
INSERT INTO `t_admin_log` VALUES (81, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735184702);
INSERT INTO `t_admin_log` VALUES (82, 1, 'admin', '/stock.php/address/edit/ids/2?dialog=1', '收货地址 / 编辑', '{\"dialog\":\"1\",\"row\":{\"uid\":\"5\",\"name\":\"111\",\"phone\":\"18081077689\",\"address\":\"121212\",\"type\":\"1\",\"itime\":\"2024-12-25 15:00:45\",\"utime\":\"2024-12-25 15:00:45\",\"is_default\":\"1\"},\"ids\":\"2\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735185115);
INSERT INTO `t_admin_log` VALUES (83, 1, 'admin', '/stock.php/address/edit/ids/2?dialog=1', '收货地址 / 编辑', '{\"dialog\":\"1\",\"row\":{\"name\":\"111\",\"phone\":\"18081077689\",\"address\":\"121212\",\"type\":\"1\",\"itime\":\"2024-12-25 15:00:45\",\"utime\":\"2024-12-25 15:00:45\",\"is_default\":\"1\"},\"ids\":\"2\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735185159);
INSERT INTO `t_admin_log` VALUES (84, 1, 'admin', '/stock.php/bank/edit/ids/1?dialog=1', '银行卡号 / 编辑', '{\"dialog\":\"1\",\"row\":{\"uid\":\"5\",\"bankName\":\"中国农业银行\",\"bankCard\":\"wewwe\",\"subBranchName\":\"sdsd\",\"phone\":\"\",\"itime\":\"2024-12-24 18:11:41\",\"utime\":\"2024-12-24 18:11:41\",\"realName\":\"张三\",\"type\":\"1\",\"alipay_card\":\"\",\"pay_type\":\"1\"},\"ids\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735191236);
INSERT INTO `t_admin_log` VALUES (85, 1, 'admin', '/stock.php/auth/rule/add?dialog=1', '权限管理 / 菜单规则 / 添加', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"0\",\"name\":\"\\/\",\"title\":\"用户管理\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735191856);
INSERT INTO `t_admin_log` VALUES (86, 1, 'admin', '/stock.php/auth/rule/edit/ids/130?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"140\",\"name\":\"bank\",\"title\":\"银行卡号\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"130\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735193162);
INSERT INTO `t_admin_log` VALUES (87, 1, 'admin', '/stock.php/auth/rule/edit/ids/116?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"140\",\"name\":\"address\",\"title\":\"收货地址\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"116\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735193223);
INSERT INTO `t_admin_log` VALUES (88, 1, 'admin', '/stock.php/auth/rule/edit/ids/110?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"140\",\"name\":\"sign\",\"title\":\"会议签到\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"110\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735193238);
INSERT INTO `t_admin_log` VALUES (89, 1, 'admin', '/stock.php/ajax/weigh', '', '{\"ids\":\"1,2,3,5,4,85,91,97,103,140,139,110,116,130,141,142,143,144,145\",\"changeid\":\"139\",\"pid\":\"140\",\"field\":\"weigh\",\"orderway\":\"desc\",\"table\":\"auth_rule\",\"pk\":\"id\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735193524);
INSERT INTO `t_admin_log` VALUES (90, 1, 'admin', '/stock.php/ajax/weigh', '', '{\"ids\":\"1,2,3,5,4,85,91,97,103,140,139,110,116,130,141,142,143,144,145\",\"changeid\":\"139\",\"pid\":\"140\",\"field\":\"weigh\",\"orderway\":\"desc\",\"table\":\"auth_rule\",\"pk\":\"id\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735193538);
INSERT INTO `t_admin_log` VALUES (91, 1, 'admin', '/stock.php/product/edit/ids/5?dialog=1', '产品 / 编辑', '{\"dialog\":\"1\",\"row\":{\"name\":\"2333\",\"price\":\"2.00\",\"day\":\"3\",\"day_income\":\"10.00\",\"allowance\":\"343.00\",\"remark\":\"\",\"is_hot\":\"2\",\"sort\":\"1\",\"type\":\"1\",\"itime\":\"2024-12-25 16:07:24\",\"utime\":\"2024-12-25 16:07:24\"},\"ids\":\"5\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735193936);
INSERT INTO `t_admin_log` VALUES (92, 1, 'admin', '/stock.php/product/edit/ids/5?dialog=1', '产品 / 编辑', '{\"dialog\":\"1\",\"row\":{\"name\":\"2333\",\"price\":\"2.00\",\"day\":\"3\",\"day_income\":\"10.00\",\"allowance\":\"343.00\",\"remark\":\"\",\"is_hot\":\"2\",\"sort\":\"1\",\"type\":\"4\",\"itime\":\"2024-12-25 16:07:24\",\"utime\":\"2024-12-25 16:07:24\"},\"ids\":\"5\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735194304);
INSERT INTO `t_admin_log` VALUES (93, 1, 'admin', '/stock.php/product/edit/ids/5?dialog=1', '产品 / 编辑', '{\"dialog\":\"1\",\"row\":{\"name\":\"2333\",\"price\":\"2.00\",\"day\":\"3\",\"day_income\":\"10.00\",\"allowance\":\"343.00\",\"remark\":\"\",\"is_hot\":\"2\",\"sort\":\"1\",\"type\":\"1\",\"itime\":\"2024-12-25 16:07:24\",\"utime\":\"2024-12-25 16:07:24\"},\"ids\":\"5\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735194586);
INSERT INTO `t_admin_log` VALUES (94, 1, 'admin', '/stock.php/auth/admin/add?dialog=1', '权限管理 / 管理员管理 / 添加', '{\"dialog\":\"1\",\"__token__\":\"***\",\"group\":[\"1\"],\"row\":{\"username\":\"root\",\"email\":\"root@qq.com\",\"mobile\":\"13250023231\",\"nickname\":\"123456\",\"password\":\"***\",\"status\":\"normal\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735198623);
INSERT INTO `t_admin_log` VALUES (95, 2, 'root', '/stock.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"root\",\"password\":\"***\",\"captcha\":\"ukwp\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735198834);
INSERT INTO `t_admin_log` VALUES (96, 0, 'Unknown', '/stock.php/index/login', '', '{\"__token__\":\"***\",\"username\":\"root\",\"password\":\"***\",\"captcha\":\"FWRX\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735198859);
INSERT INTO `t_admin_log` VALUES (97, 2, 'root', '/stock.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"root\",\"password\":\"***\",\"captcha\":\"ikkp\",\"keeplogin\":\"1\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735198868);
INSERT INTO `t_admin_log` VALUES (98, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"10\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735201283);
INSERT INTO `t_admin_log` VALUES (99, 1, 'admin', '/stock.php/sign/nopass', '会议签到', '{\"ids\":\"10\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735201285);
INSERT INTO `t_admin_log` VALUES (100, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"10\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735201303);
INSERT INTO `t_admin_log` VALUES (101, 1, 'admin', '/stock.php/sign/nopass', '会议签到', '{\"ids\":\"10\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735201304);
INSERT INTO `t_admin_log` VALUES (102, 1, 'admin', '/stock.php/sign/pass', '会议签到', '{\"ids\":\"9\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735203435);
INSERT INTO `t_admin_log` VALUES (103, 2, 'root', '/stock.php/sys/edit/ids/2?dialog=1', '支付账号 / 编辑', '{\"dialog\":\"1\",\"row\":{\"name\":\"支付宝\",\"pay_type\":\"1\",\"appid\":\"11\",\"appsecret\":\"111\",\"sort\":\"1\",\"type\":\"1\",\"itime\":\"1970-01-01 08:00:01\",\"utime\":\"1970-01-01 08:00:01\"},\"ids\":\"2\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735207227);
INSERT INTO `t_admin_log` VALUES (104, 2, 'root', '/stock.php/auth/rule/add?dialog=1', '权限管理 / 菜单规则 / 添加', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"0\",\"name\":\"\\/\",\"title\":\"平台配置\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"}}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735297295);
INSERT INTO `t_admin_log` VALUES (105, 2, 'root', '/stock.php/auth/rule/edit/ids/85?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"172\",\"name\":\"news\",\"title\":\"新闻管理\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"85\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735297389);
INSERT INTO `t_admin_log` VALUES (106, 2, 'root', '/stock.php/news/edit/ids/4?dialog=1', '新闻管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"2\",\"author\":\"1\",\"coverUrl\":\"\\/uploads\\/20241225\\/f3d54e5ccb2caa40c6218433aefeac1e.jpg\",\"content\":\"111\",\"type\":\"1\",\"itime\":\"2024-12-25 16:25:13\",\"utime\":\"2024-12-25 16:25:13\"},\"ids\":\"4\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735297689);
INSERT INTO `t_admin_log` VALUES (107, 2, 'root', '/stock.php/news/del', '新闻管理 / 删除', '{\"action\":\"del\",\"ids\":\"4\",\"params\":\"\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735297909);
INSERT INTO `t_admin_log` VALUES (108, 2, 'root', '/stock.php/news/add?dialog=1', '新闻管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"author\":\"1\",\"coverUrl\":\"1\",\"content\":\"1\",\"itime\":\"2024-12-27 19:14:44\",\"utime\":\"2024-12-27 19:14:44\"}}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735298088);
INSERT INTO `t_admin_log` VALUES (109, 2, 'root', '/stock.php/news/add?dialog=1', '新闻管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"author\":\"1\",\"coverUrl\":\"1\",\"content\":\"1\",\"itime\":\"2024-12-27 19:14:44\",\"utime\":\"2024-12-27 19:14:44\"}}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735298104);
INSERT INTO `t_admin_log` VALUES (110, 2, 'root', '/stock.php/news/del', '新闻管理 / 删除', '{\"action\":\"del\",\"ids\":\"5\",\"params\":\"\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735298258);
INSERT INTO `t_admin_log` VALUES (111, 2, 'root', '/stock.php/news/add?dialog=1', '新闻管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"3\",\"author\":\"3\",\"coverUrl\":\"3\",\"content\":\"1\",\"itime\":\"2024-12-27 19:18:45\",\"utime\":\"2024-12-27 19:18:45\"}}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735298330);
INSERT INTO `t_admin_log` VALUES (112, 2, 'root', '/stock.php/news/edit/ids/6?dialog=1', '新闻管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"3\",\"author\":\"3\",\"coverUrl\":\"3\",\"content\":\"2\",\"itime\":\"2024-12-27 19:18:45\",\"utime\":\"2024-12-27 19:18:45\"},\"ids\":\"6\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735298335);
INSERT INTO `t_admin_log` VALUES (113, 2, 'root', '/stock.php/news/del', '新闻管理 / 删除', '{\"action\":\"del\",\"ids\":\"6\",\"params\":\"\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735298341);
INSERT INTO `t_admin_log` VALUES (114, 2, 'root', '/stock.php/auth/rule/edit/ids/97?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"172\",\"name\":\"video\",\"title\":\"视频管理\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"97\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735298363);
INSERT INTO `t_admin_log` VALUES (115, 2, 'root', '/stock.php/news/add?dialog=1', '新闻管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"author\":\"1\",\"coverUrl\":\"1\",\"content\":\"1\",\"itime\":\"2024-12-27 19:23:36\",\"utime\":\"2024-12-27 19:23:36\"}}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735298624);
INSERT INTO `t_admin_log` VALUES (116, 2, 'root', '/stock.php/video/del', '视频管理 / 删除', '{\"action\":\"del\",\"ids\":\"4\",\"params\":\"\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735299218);
INSERT INTO `t_admin_log` VALUES (117, 2, 'root', '/stock.php/auth/rule/edit/ids/91?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"172\",\"name\":\"notice\",\"title\":\"公告管理\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"91\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735299281);
INSERT INTO `t_admin_log` VALUES (118, 2, 'root', '/stock.php/auth/rule/edit/ids/146?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"172\",\"name\":\"product\",\"title\":\"产品管理\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"146\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735299492);
INSERT INTO `t_admin_log` VALUES (119, 2, 'root', '/stock.php/auth/rule/multi', '权限管理 / 菜单规则', '{\"action\":\"\",\"ids\":\"1\",\"params\":\"ismenu=0\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735299502);
INSERT INTO `t_admin_log` VALUES (120, 2, 'root', '/stock.php/notice/del', '公告管理 / 删除', '{\"action\":\"del\",\"ids\":\"2\",\"params\":\"\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735299671);
INSERT INTO `t_admin_log` VALUES (121, 2, 'root', '/stock.php/auth/rule/edit/ids/140?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"0\",\"name\":\"main\",\"title\":\"用户中心\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"140\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735300307);
INSERT INTO `t_admin_log` VALUES (122, 2, 'root', '/stock.php/auth/rule/edit/ids/110?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"140\",\"name\":\"sign\",\"title\":\"签到核对\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"110\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735300395);
INSERT INTO `t_admin_log` VALUES (123, 2, 'root', '/stock.php/sign/nopass', '签到核对', '{\"ids\":\"8\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735300687);
INSERT INTO `t_admin_log` VALUES (124, 2, 'root', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"8\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735300777);
INSERT INTO `t_admin_log` VALUES (125, 2, 'root', '/stock.php/auth/rule/edit/ids/139?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"140\",\"name\":\"account\",\"title\":\"用户资料\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"139\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735302527);
INSERT INTO `t_admin_log` VALUES (126, 2, 'root', '/stock.php/sign/pass', '签到核对', '', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735303115);
INSERT INTO `t_admin_log` VALUES (127, 2, 'root', '/stock.php/sign/pass', '签到核对', '', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735303116);
INSERT INTO `t_admin_log` VALUES (128, 2, 'root', '/stock.php/auth/rule/multi', '权限管理 / 菜单规则', '{\"action\":\"\",\"ids\":\"116\",\"params\":\"ismenu=0\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735304106);
INSERT INTO `t_admin_log` VALUES (129, 2, 'root', '/stock.php/auth/rule/multi', '权限管理 / 菜单规则', '{\"action\":\"\",\"ids\":\"130\",\"params\":\"ismenu=0\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735305301);
INSERT INTO `t_admin_log` VALUES (130, 1, 'admin', '/stock.php/index/login?url=/stock.php/account?ref=addtabs', '登录', '{\"url\":\"\\/stock.php\\/account?ref=addtabs\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\",\"captcha\":\"pple\",\"keeplogin\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735309313);
INSERT INTO `t_admin_log` VALUES (131, 1, 'admin', '/stock.php/auth/rule/edit/ids/173?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"140\",\"name\":\"real\",\"title\":\"实名认证\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"173\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735309347);
INSERT INTO `t_admin_log` VALUES (132, 1, 'admin', '/stock.php/video/add?dialog=1', '视频管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"coverUrl\":\"1\",\"video_url\":\"1\",\"video_duration\":\"1\",\"is_hot\":\"0\",\"is_new\":\"0\",\"sort\":\"0\",\"itime\":\"2024-12-27 23:28:34\",\"utime\":\"2024-12-27 23:28:34\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735313331);
INSERT INTO `t_admin_log` VALUES (133, 1, 'admin', '/stock.php/video/add?dialog=1', '视频管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"coverUrl\":\"1\",\"video_url\":\"1\",\"video_duration\":\"1\",\"is_hot\":\"0\",\"is_new\":\"0\",\"sort\":\"0\",\"itime\":\"2024-12-27 23:28:34\",\"utime\":\"2024-12-27 23:28:34\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735313352);
INSERT INTO `t_admin_log` VALUES (134, 1, 'admin', '/stock.php/video/edit/ids/5?dialog=1', '视频管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"coverUrl\":\"1\",\"video_url\":\"1\",\"video_duration\":\"1\",\"is_hot\":\"0\",\"is_new\":\"0\",\"sort\":\"0\",\"itime\":\"2024-12-27 23:28:34\",\"utime\":\"2024-12-27 23:28:34\"},\"ids\":\"5\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735313554);
INSERT INTO `t_admin_log` VALUES (135, 1, 'admin', '/stock.php/video/edit/ids/5?dialog=1', '视频管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"coverUrl\":\"1\",\"video_url\":\"1\",\"video_duration\":\"1\",\"is_hot\":\"0\",\"is_new\":\"1\",\"sort\":\"0\",\"itime\":\"2024-12-27 23:28:34\",\"utime\":\"2024-12-27 23:28:34\"},\"ids\":\"5\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735313738);
INSERT INTO `t_admin_log` VALUES (136, 1, 'admin', '/stock.php/video/edit/ids/5?dialog=1', '视频管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"coverUrl\":\"1\",\"video_url\":\"1\",\"video_duration\":\"1\",\"is_hot\":\"1\",\"is_new\":\"1\",\"sort\":\"0\",\"itime\":\"2024-12-27 23:28:34\",\"utime\":\"2024-12-27 23:28:34\"},\"ids\":\"5\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735313809);
INSERT INTO `t_admin_log` VALUES (137, 1, 'admin', '/stock.php/video/edit/ids/5?dialog=1', '视频管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"coverUrl\":\"1\",\"video_url\":\"1\",\"video_duration\":\"1\",\"is_hot\":\"0\",\"is_new\":\"0\",\"sort\":\"0\",\"itime\":\"2024-12-27 23:28:34\",\"utime\":\"2024-12-27 23:28:34\"},\"ids\":\"5\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735313815);
INSERT INTO `t_admin_log` VALUES (138, 1, 'admin', '/stock.php/news/edit/ids/7?dialog=1', '新闻管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"1\",\"author\":\"1\",\"coverUrl\":\"1\",\"is_new\":\"1\",\"content\":\"1\",\"itime\":\"2024-12-27 19:23:36\",\"utime\":\"2024-12-27 19:23:36\"},\"ids\":\"7\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735357067);
INSERT INTO `t_admin_log` VALUES (139, 1, 'admin', '/stock.php/product/edit/ids/5?dialog=1', '产品管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"name\":\"2333\",\"price\":\"2.00\",\"day\":\"3\",\"day_income\":\"10.00\",\"allowance\":\"343.00\",\"remark\":\"\",\"is_hot\":\"0\",\"sort\":\"1\",\"itime\":\"2024-12-25 16:07:24\",\"utime\":\"2024-12-25 16:07:24\"},\"ids\":\"5\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735357289);
INSERT INTO `t_admin_log` VALUES (140, 1, 'admin', '/stock.php/product/edit/ids/4?dialog=1', '产品管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"name\":\"nihao\",\"price\":\"1.00\",\"day\":\"1\",\"day_income\":\"111.00\",\"allowance\":\"111.00\",\"remark\":\"111\",\"is_hot\":\"0\",\"sort\":\"1\",\"itime\":\"1970-01-01 08:00:01\",\"utime\":\"1970-01-01 08:00:01\"},\"ids\":\"4\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735357295);
INSERT INTO `t_admin_log` VALUES (141, 1, 'admin', '/stock.php/auth/rule/edit/ids/103?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"172\",\"name\":\"carousel\",\"title\":\"轮播管理\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"103\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735369891);
INSERT INTO `t_admin_log` VALUES (142, 1, 'admin', '/stock.php/auth/rule/edit/ids/166?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"172\",\"name\":\"sys\",\"title\":\"支付账号\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"166\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735369945);
INSERT INTO `t_admin_log` VALUES (143, 1, 'admin', '/stock.php/carousel/del', '轮播管理 / 删除', '{\"action\":\"del\",\"ids\":\"2\",\"params\":\"\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735370394);
INSERT INTO `t_admin_log` VALUES (144, 1, 'admin', '/stock.php/carousel/add?dialog=1', '轮播管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"nihao\",\"picUrl\":\"1\",\"sort\":\"0\",\"itime\":\"2024-12-28 15:19:57\",\"utime\":\"2024-12-28 15:19:57\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735370404);
INSERT INTO `t_admin_log` VALUES (145, 1, 'admin', '/stock.php/sys/edit/ids/2?dialog=1', '支付账号 / 编辑', '{\"dialog\":\"1\",\"row\":{\"name\":\"支付宝\",\"pay_type\":\"1\",\"appid\":\"11\",\"appsecret\":\"111\",\"sort\":\"1\",\"type\":\"1\",\"itime\":\"1970-01-01 08:00:01\",\"utime\":\"1970-01-01 08:00:01\"},\"ids\":\"2\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735370599);
INSERT INTO `t_admin_log` VALUES (146, 1, 'admin', '/stock.php/sys/add?dialog=1', '支付账号 / 添加', '{\"dialog\":\"1\",\"row\":{\"name\":\"1\",\"pay_type\":\"3\",\"appid\":\"1\",\"appsecret\":\"1\",\"sort\":\"1\",\"itime\":\"2024-12-28 15:25:37\",\"utime\":\"2024-12-28 15:25:37\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735370747);
INSERT INTO `t_admin_log` VALUES (147, 1, 'admin', '/stock.php/sys/add?dialog=1', '支付账号 / 添加', '{\"dialog\":\"1\",\"row\":{\"name\":\"1\",\"pay_type\":\"1\",\"appid\":\"1\",\"appsecret\":\"1\",\"sort\":\"1\",\"itime\":\"2024-12-28 15:26:14\",\"utime\":\"2024-12-28 15:26:14\"}}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735370779);
INSERT INTO `t_admin_log` VALUES (148, 1, 'admin', '/stock.php/sys/edit/ids/3?dialog=1', '支付账号 / 编辑', '{\"dialog\":\"1\",\"row\":{\"name\":\"1\",\"appid\":\"1\",\"appsecret\":\"1\",\"sort\":\"1\",\"type\":\"2\",\"itime\":\"2024-12-28 15:26:14\",\"utime\":\"2024-12-28 15:26:14\"},\"ids\":\"3\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735370956);
INSERT INTO `t_admin_log` VALUES (149, 1, 'admin', '/stock.php/auth/rule/multi', '权限管理 / 菜单规则', '{\"action\":\"\",\"ids\":\"4\",\"params\":\"ismenu=0\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735371670);
INSERT INTO `t_admin_log` VALUES (150, 1, 'admin', '/stock.php/real/pass', '实名认证', '', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735375469);
INSERT INTO `t_admin_log` VALUES (151, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"10\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735376093);
INSERT INTO `t_admin_log` VALUES (152, 1, 'admin', '/stock.php/sign/nopass', '签到核对', '{\"ids\":\"10\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735376096);
INSERT INTO `t_admin_log` VALUES (153, 1, 'admin', '/stock.php/real/pass', '实名认证', '', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735376103);
INSERT INTO `t_admin_log` VALUES (154, 1, 'admin', '/stock.php/real/pass', '实名认证', '', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735377502);
INSERT INTO `t_admin_log` VALUES (155, 1, 'admin', '/stock.php/real/pass', '实名认证', '', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735377504);
INSERT INTO `t_admin_log` VALUES (156, 1, 'admin', '/stock.php/real/pass', '实名认证', '', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735377607);
INSERT INTO `t_admin_log` VALUES (157, 1, 'admin', '/stock.php/real/pass', '实名认证', '', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735377609);
INSERT INTO `t_admin_log` VALUES (158, 1, 'admin', '/stock.php/real/pass', '实名认证', '', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735377609);
INSERT INTO `t_admin_log` VALUES (159, 1, 'admin', '/stock.php/real/pass', '实名认证', '', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735377612);
INSERT INTO `t_admin_log` VALUES (160, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"10\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735377663);
INSERT INTO `t_admin_log` VALUES (161, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"10\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735377666);
INSERT INTO `t_admin_log` VALUES (162, 1, 'admin', '/stock.php/real/pass', '实名认证', '', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735377694);
INSERT INTO `t_admin_log` VALUES (163, 1, 'admin', '/stock.php/real/pass', '实名认证', '', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735377695);
INSERT INTO `t_admin_log` VALUES (164, 1, 'admin', '/stock.php/real/pass', '实名认证', '', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735377698);
INSERT INTO `t_admin_log` VALUES (165, 1, 'admin', '/stock.php/real/nopass', '实名认证', '{\"ids\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735378028);
INSERT INTO `t_admin_log` VALUES (166, 1, 'admin', '/stock.php/auth/rule/edit/ids/226?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"232\",\"name\":\"pay\",\"title\":\"支付管理\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"226\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735449339);
INSERT INTO `t_admin_log` VALUES (167, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"17\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735461805);
INSERT INTO `t_admin_log` VALUES (168, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"17\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735461805);
INSERT INTO `t_admin_log` VALUES (169, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"16\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735461809);
INSERT INTO `t_admin_log` VALUES (170, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"15\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735461810);
INSERT INTO `t_admin_log` VALUES (171, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"14\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735461811);
INSERT INTO `t_admin_log` VALUES (172, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"13\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735461813);
INSERT INTO `t_admin_log` VALUES (173, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"12\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735461814);
INSERT INTO `t_admin_log` VALUES (174, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735461815);
INSERT INTO `t_admin_log` VALUES (175, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"19\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735461857);
INSERT INTO `t_admin_log` VALUES (176, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"20\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735461859);
INSERT INTO `t_admin_log` VALUES (177, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"21\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735461860);
INSERT INTO `t_admin_log` VALUES (178, 1, 'admin', '/stock.php/real/pass', '实名认证', '{\"ids\":\"2\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735463262);
INSERT INTO `t_admin_log` VALUES (179, 1, 'admin', '/stock.php/real/pass', '实名认证', '{\"ids\":\"2\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735463282);
INSERT INTO `t_admin_log` VALUES (180, 1, 'admin', '/stock.php/index/login?url=/stock.php/pay?ref=addtabs', '登录', '{\"url\":\"\\/stock.php\\/pay?ref=addtabs\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\",\"captcha\":\"QV2K\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735530209);
INSERT INTO `t_admin_log` VALUES (181, 1, 'admin', '/stock.php/auth/rule/edit/ids/5?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"0\",\"name\":\"auth\",\"title\":\"权限管理\",\"url\":\"\",\"icon\":\"fa fa-group\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"50\",\"status\":\"normal\"},\"ids\":\"5\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735536919);
INSERT INTO `t_admin_log` VALUES (182, 1, 'admin', '/stock.php/auth/rule/edit/ids/140?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"0\",\"name\":\"main\",\"title\":\"用户中心\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"100\",\"status\":\"normal\"},\"ids\":\"140\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735536935);
INSERT INTO `t_admin_log` VALUES (183, 1, 'admin', '/stock.php/auth/rule/edit/ids/172?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"0\",\"name\":\"\\/\",\"title\":\"平台配置\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"80\",\"status\":\"normal\"},\"ids\":\"172\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735536954);
INSERT INTO `t_admin_log` VALUES (184, 1, 'admin', '/stock.php/auth/rule/edit/ids/232?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"0\",\"name\":\"\\/\",\"title\":\"交易中心\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"70\",\"status\":\"normal\"},\"ids\":\"232\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735536985);
INSERT INTO `t_admin_log` VALUES (185, 1, 'admin', '/stock.php/auth/rule/edit/ids/232?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"0\",\"name\":\"\\/bus\",\"title\":\"交易中心\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"70\",\"status\":\"normal\"},\"ids\":\"232\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735537000);
INSERT INTO `t_admin_log` VALUES (186, 1, 'admin', '/stock.php/auth/rule/edit/ids/233?dialog=1', '权限管理 / 菜单规则 / 编辑', '{\"dialog\":\"1\",\"__token__\":\"***\",\"row\":{\"ismenu\":\"1\",\"pid\":\"232\",\"name\":\"withdrawal\",\"title\":\"提现\",\"url\":\"\",\"icon\":\"fa fa-circle-o\",\"condition\":\"\",\"menutype\":\"addtabs\",\"extend\":\"\",\"remark\":\"\",\"weigh\":\"0\",\"status\":\"normal\"},\"ids\":\"233\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735549409);
INSERT INTO `t_admin_log` VALUES (187, 1, 'admin', '/stock.php/withdrawal/nopass', '提现', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735552137);
INSERT INTO `t_admin_log` VALUES (188, 1, 'admin', '/stock.php/withdrawal/pass', '提现', '{\"ids\":\"12\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735559693);
INSERT INTO `t_admin_log` VALUES (189, 1, 'admin', '/stock.php/withdrawal/pass', '提现', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735559879);
INSERT INTO `t_admin_log` VALUES (190, 1, 'admin', '/stock.php/withdrawal/pass', '提现', '{\"ids\":\"12\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735610926);
INSERT INTO `t_admin_log` VALUES (191, 1, 'admin', '/stock.php/withdrawal/pass', '提现', '{\"ids\":\"12\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735610932);
INSERT INTO `t_admin_log` VALUES (192, 1, 'admin', '/stock.php/real/pass', '实名认证', '{\"ids\":\"2\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735613775);
INSERT INTO `t_admin_log` VALUES (193, 1, 'admin', '/stock.php/real/pass', '实名认证', '{\"ids\":\"1\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735613787);
INSERT INTO `t_admin_log` VALUES (194, 1, 'admin', '/stock.php/real/pass', '实名认证', '{\"ids\":\"3\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735783705);
INSERT INTO `t_admin_log` VALUES (195, 1, 'admin', '/stock.php/real/pass', '实名认证', '{\"ids\":\"3\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735783708);
INSERT INTO `t_admin_log` VALUES (196, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"22\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735810015);
INSERT INTO `t_admin_log` VALUES (197, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"21\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735810088);
INSERT INTO `t_admin_log` VALUES (198, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"20\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735810092);
INSERT INTO `t_admin_log` VALUES (199, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"19\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735810093);
INSERT INTO `t_admin_log` VALUES (200, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"17\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735810093);
INSERT INTO `t_admin_log` VALUES (201, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"16\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735810094);
INSERT INTO `t_admin_log` VALUES (202, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"15\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735810095);
INSERT INTO `t_admin_log` VALUES (203, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"13\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735810101);
INSERT INTO `t_admin_log` VALUES (204, 2, 'root', '/stock.php/index/login?url=/stock.php/address?ref=addtabs&uid=1', '登录', '{\"url\":\"\\/stock.php\\/address?ref=addtabs&amp;uid=1\",\"__token__\":\"***\",\"username\":\"root\",\"password\":\"***\",\"captcha\":\"bi5r\",\"keeplogin\":\"1\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735811818);
INSERT INTO `t_admin_log` VALUES (205, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"14\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735812223);
INSERT INTO `t_admin_log` VALUES (206, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"13\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735812225);
INSERT INTO `t_admin_log` VALUES (207, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"19\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735812236);
INSERT INTO `t_admin_log` VALUES (208, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"17\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735812237);
INSERT INTO `t_admin_log` VALUES (209, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"12\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735812505);
INSERT INTO `t_admin_log` VALUES (210, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"13\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735812508);
INSERT INTO `t_admin_log` VALUES (211, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"14\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735812509);
INSERT INTO `t_admin_log` VALUES (212, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"14\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735812512);
INSERT INTO `t_admin_log` VALUES (213, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"15\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735812804);
INSERT INTO `t_admin_log` VALUES (214, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"11\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735812923);
INSERT INTO `t_admin_log` VALUES (215, 2, 'root', '/stock.php/real/pass', '实名认证', '{\"ids\":\"4\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813010);
INSERT INTO `t_admin_log` VALUES (216, 2, 'root', '/stock.php/real/pass', '实名认证', '{\"ids\":\"4\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813033);
INSERT INTO `t_admin_log` VALUES (217, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"14\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813039);
INSERT INTO `t_admin_log` VALUES (218, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"15\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813105);
INSERT INTO `t_admin_log` VALUES (219, 2, 'root', '/stock.php/product/add?dialog=1', '产品管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"name\":\"测试产品名字\",\"price\":\"2000\",\"day\":\"2\",\"day_income\":\"1\",\"allowance\":\"10000\",\"remark\":\"测试说明文本测试说明文本测试说明文本测试说明文本测试说明文本\",\"is_hot\":\"1\",\"sort\":\"1\",\"itime\":\"2025-01-02 18:19:04\",\"utime\":\"2025-01-02 18:19:04\"}}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813184);
INSERT INTO `t_admin_log` VALUES (220, 2, 'root', '/stock.php/product/add?dialog=1', '产品管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"name\":\"测试产品名字\",\"price\":\"2000\",\"day\":\"2\",\"day_income\":\"1\",\"allowance\":\"10000\",\"remark\":\"测试说明文本测试说明文本测试说明文本测试说明文本测试说明文本\",\"is_hot\":\"1\",\"sort\":\"1\",\"itime\":\"2025-01-02 18:19:04\",\"utime\":\"2025-01-02 18:19:04\"}}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813191);
INSERT INTO `t_admin_log` VALUES (221, 2, 'root', '/stock.php/product/add?dialog=1', '产品管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"name\":\"测试产品名字\",\"price\":\"2000\",\"day\":\"2\",\"day_income\":\"10\",\"allowance\":\"10000\",\"remark\":\"测试说明文本测试说明文本测试说明文本测试说明文本测试说明文本\",\"is_hot\":\"1\",\"sort\":\"1\",\"itime\":\"2025-01-02 18:19:04\",\"utime\":\"2025-01-02 18:19:04\"}}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813284);
INSERT INTO `t_admin_log` VALUES (222, 2, 'root', '/stock.php/product/add?dialog=1', '产品管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"name\":\"测试产品名字\",\"price\":\"2000\",\"day\":\"2\",\"day_income\":\"10\",\"allowance\":\"10000\",\"remark\":\"测试说明文本测试说明文本测试说明文本测试说明文本测试说明文本\",\"is_hot\":\"0\",\"sort\":\"1\",\"itime\":\"2025-01-02 18:19:04\",\"utime\":\"2025-01-02 18:19:04\"}}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813286);
INSERT INTO `t_admin_log` VALUES (223, 2, 'root', '/stock.php/product/add?dialog=1', '产品管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"name\":\"测试产品名字\",\"price\":\"2000\",\"day\":\"2\",\"day_income\":\"10\",\"allowance\":\"10000\",\"remark\":\"测试说明文本测试说明文本测试说明文本测试说明文本测试说明文本\",\"is_hot\":\"0\",\"sort\":\"6\",\"itime\":\"2025-01-02 18:19:04\",\"utime\":\"2025-01-02 18:19:04\"}}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813303);
INSERT INTO `t_admin_log` VALUES (224, 2, 'root', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813789);
INSERT INTO `t_admin_log` VALUES (225, 2, 'root', '/stock.php/carousel/edit/ids/3?dialog=1', '轮播管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"nihao\",\"picUrl\":\"\\/uploads\\/20250102\\/c2cc072b78c51877710a0ce31cfc4251.png\",\"sort\":\"0\",\"itime\":\"2024-12-28 15:19:57\",\"utime\":\"2024-12-28 15:19:57\"},\"ids\":\"3\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813791);
INSERT INTO `t_admin_log` VALUES (226, 2, 'root', '/stock.php/carousel/edit/ids/3?dialog=1', '轮播管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"nihao\",\"picUrl\":\"\\/uploads\\/20250102\\/c2cc072b78c51877710a0ce31cfc4251.png\",\"sort\":\"1\",\"itime\":\"2024-12-28 15:19:57\",\"utime\":\"2024-12-28 15:19:57\"},\"ids\":\"3\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813808);
INSERT INTO `t_admin_log` VALUES (227, 2, 'root', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813819);
INSERT INTO `t_admin_log` VALUES (228, 2, 'root', '/stock.php/carousel/add?dialog=1', '轮播管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"banner2\",\"picUrl\":\"\\/uploads\\/20250102\\/99d6dd86032e02d70c41191b61e2def5.webp\",\"sort\":\"2\",\"itime\":\"2025-01-02 18:30:09\",\"utime\":\"2025-01-02 18:30:09\"}}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735813824);
INSERT INTO `t_admin_log` VALUES (229, 1, 'admin', '/stock.php/product/edit/ids/5?dialog=1', '产品管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"name\":\"2333\",\"price\":\"1000.00\",\"day\":\"3\",\"day_income\":\"0.1\",\"allowance\":\"343.00\",\"remark\":\"\",\"is_hot\":\"0\",\"sort\":\"1\",\"itime\":\"2024-12-25 16:07:24\",\"utime\":\"2024-12-25 16:07:24\"},\"ids\":\"5\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735814366);
INSERT INTO `t_admin_log` VALUES (230, 2, 'root', '/stock.php/notice/add?dialog=1', '公告管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"测试公告标题\",\"content\":\"测试公告内容测试公告内容测试公告内容测试公告内容测试公告内容\",\"sort\":\"2\",\"itime\":\"2025-01-02 18:44:06\",\"utime\":\"2025-01-02 18:44:06\"}}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735814661);
INSERT INTO `t_admin_log` VALUES (231, 2, 'root', '/stock.php/product/add?dialog=1', '产品管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"name\":\"测试产品名字\",\"price\":\"100\",\"day\":\"2\",\"day_income\":\"1\",\"allowance\":\"3000\",\"remark\":\"测试产品说明文本测试产品说明文本测试产品说明文本测试产品说明文本测试产品说明文本\",\"is_hot\":\"1\",\"sort\":\"1\",\"itime\":\"2025-01-02 18:50:26\",\"utime\":\"2025-01-02 18:50:26\"}}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735815063);
INSERT INTO `t_admin_log` VALUES (232, 2, 'root', '/stock.php/notice/add?dialog=1', '公告管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"测试公告标题1111\",\"content\":\"测试公告标题1111测试公告标题1111测试公告标题1111测试公告标题1111测试公告标题1111\",\"sort\":\"1\",\"itime\":\"2025-01-02 18:52:19\",\"utime\":\"2025-01-02 18:52:19\"}}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735815152);
INSERT INTO `t_admin_log` VALUES (233, 1, 'admin', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"23\"}', '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735815279);
INSERT INTO `t_admin_log` VALUES (234, 2, 'root', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735815755);
INSERT INTO `t_admin_log` VALUES (235, 2, 'root', '/stock.php/news/add?dialog=1', '新闻管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"新闻标题11\",\"author\":\"新闻标题\",\"is_new\":\"1\",\"coverUrl\":\"\\/uploads\\/20250102\\/c2cc072b78c51877710a0ce31cfc4251.png\",\"content\":\"新闻标题11新闻标题11新闻标题11新闻标题11新闻标题11新闻标题11新闻标题11\",\"itime\":\"2025-01-02 19:02:20\",\"utime\":\"2025-01-02 19:02:20\"}}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735815761);
INSERT INTO `t_admin_log` VALUES (236, 2, 'root', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735815819);
INSERT INTO `t_admin_log` VALUES (237, 2, 'root', '/stock.php/news/add?dialog=1', '新闻管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"新闻标题22\",\"author\":\"22\",\"is_new\":\"0\",\"coverUrl\":\"\\/uploads\\/20250102\\/a6e359505ab7cb7a925f18f54e5fee83.png\",\"content\":\"新闻标题22新闻标题22新闻标题22新闻标题22新闻标题22\",\"itime\":\"2025-01-02 19:03:23\",\"utime\":\"2025-01-02 19:03:23\"}}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735815824);
INSERT INTO `t_admin_log` VALUES (238, 2, 'root', '/stock.php/product/edit/ids/6?dialog=1', '产品管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"name\":\"测试产品名字\",\"price\":\"100.00\",\"day\":\"1\",\"day_income\":\"1.00\",\"allowance\":\"3000.00\",\"remark\":\"测试产品说明文本测试产品说明文本测试产品说明文本测试产品说明文本测试产品说明文本\",\"is_hot\":\"1\",\"sort\":\"1\",\"itime\":\"2025-01-02 18:50:26\",\"utime\":\"2025-01-02 18:50:26\"},\"ids\":\"6\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735815931);
INSERT INTO `t_admin_log` VALUES (239, 2, 'root', '/stock.php/index/login?url=/stock.php/sign?ref=addtabs', '登录', '{\"url\":\"\\/stock.php\\/sign?ref=addtabs\",\"__token__\":\"***\",\"username\":\"root\",\"password\":\"***\",\"captcha\":\"ev6f\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735817066);
INSERT INTO `t_admin_log` VALUES (240, 0, 'Unknown', '/stock.php/index/login?url=/stock.php/sign?ref=addtabs', '', '{\"url\":\"\\/stock.php\\/sign?ref=addtabs\",\"__token__\":\"***\",\"username\":\"root\",\"password\":\"***\",\"captcha\":\"8038\",\"keeplogin\":\"1\"}', '192.168.5.62', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', 1735817202);
INSERT INTO `t_admin_log` VALUES (241, 2, 'root', '/stock.php/index/login?url=/stock.php/sign?ref=addtabs', '登录', '{\"url\":\"\\/stock.php\\/sign?ref=addtabs\",\"__token__\":\"***\",\"username\":\"root\",\"password\":\"***\",\"captcha\":\"sb5r\",\"keeplogin\":\"1\"}', '192.168.5.62', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', 1735817217);
INSERT INTO `t_admin_log` VALUES (242, 2, 'root', '/stock.php/product/edit/ids/4?dialog=1', '产品管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"name\":\"nihao\",\"price\":\"1000.00\",\"day\":\"1\",\"day_income\":\"111.00\",\"allowance\":\"111.00\",\"remark\":\"111\",\"limit_num\":\"5\",\"is_hot\":\"0\",\"sort\":\"1\",\"itime\":\"1970-01-01 08:00:01\",\"utime\":\"1970-01-01 08:00:01\"},\"ids\":\"4\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735818252);
INSERT INTO `t_admin_log` VALUES (243, 2, 'root', '/stock.php/real/nopass', '实名认证', '{\"ids\":\"5\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735821320);
INSERT INTO `t_admin_log` VALUES (244, 2, 'root', '/stock.php/real/pass', '实名认证', '{\"ids\":\"6\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735821673);
INSERT INTO `t_admin_log` VALUES (245, 2, 'root', '/stock.php/account/edit/ids/10000010?dialog=1', '用户资料 / 编辑', '{\"dialog\":\"1\",\"row\":{\"buy_product_money\":\"10\"},\"ids\":\"10000010\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735824371);
INSERT INTO `t_admin_log` VALUES (246, 2, 'root', '/stock.php/account/edit/ids/10000010?dialog=1', '用户资料 / 编辑', '{\"dialog\":\"1\",\"row\":{\"buy_product_money\":\"10\"},\"ids\":\"10000010\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735824395);
INSERT INTO `t_admin_log` VALUES (247, 2, 'root', '/stock.php/account/edit/ids/10000010?dialog=1', '用户资料 / 编辑', '{\"dialog\":\"1\",\"row\":{\"buy_product_money\":\"10\"},\"ids\":\"10000010\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735824469);
INSERT INTO `t_admin_log` VALUES (248, 2, 'root', '/stock.php/account/edit/ids/10000010?dialog=1', '用户资料 / 编辑', '{\"dialog\":\"1\",\"row\":{\"money\":\"10\"},\"ids\":\"10000010\"}', '192.168.5.150', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735824534);
INSERT INTO `t_admin_log` VALUES (249, 2, 'root', '/stock.php/index/login?url=/stock.php/real?ref=addtabs', '登录', '{\"url\":\"\\/stock.php\\/real?ref=addtabs\",\"__token__\":\"***\",\"username\":\"root\",\"password\":\"***\",\"captcha\":\"aewp\"}', '192.168.30.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735825931);
INSERT INTO `t_admin_log` VALUES (250, 2, 'root', '/stock.php/index/login?url=/stock.php/real?ref=addtabs', '登录', '{\"url\":\"\\/stock.php\\/real?ref=addtabs\",\"__token__\":\"***\",\"username\":\"root\",\"password\":\"***\",\"captcha\":\"dfnv\",\"keeplogin\":\"1\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735827176);
INSERT INTO `t_admin_log` VALUES (251, 2, 'root', '/stock.php/account/edit/ids/10000007?dialog=1', '用户资料 / 编辑', '{\"dialog\":\"1\",\"row\":{\"money\":\"10000\"},\"ids\":\"10000007\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735873669);
INSERT INTO `t_admin_log` VALUES (252, 0, 'Unknown', '/stock.php/index/login?url=/stock.php/sign?ref=addtabs', '', '{\"url\":\"\\/stock.php\\/sign?ref=addtabs\",\"__token__\":\"***\",\"username\":\"root\",\"password\":\"***\",\"captcha\":\"oryn\",\"keeplogin\":\"1\"}', '192.168.5.62', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', 1735874262);
INSERT INTO `t_admin_log` VALUES (253, 2, 'root', '/stock.php/index/login?url=/stock.php/sign?ref=addtabs', '登录', '{\"url\":\"\\/stock.php\\/sign?ref=addtabs\",\"__token__\":\"***\",\"username\":\"root\",\"password\":\"***\",\"captcha\":\"mhzx\",\"keeplogin\":\"1\"}', '192.168.5.62', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', 1735874267);
INSERT INTO `t_admin_log` VALUES (254, 2, 'root', '/stock.php/news/edit/ids/8?dialog=1', '新闻管理 / 编辑', '{\"dialog\":\"1\",\"row\":{\"title\":\"新闻标题11\",\"author\":\"新闻标题\",\"coverUrl\":\"\\/uploads\\/20250102\\/c2cc072b78c51877710a0ce31cfc4251.png\",\"is_new\":\"1\",\"content\":\"新闻标题11新闻标题11新闻标题11新闻标题11新闻标题11新闻标题11新闻标题11\",\"itime\":\"2025-01-02 19:02:20\",\"utime\":\"2025-01-02 19:02:20\"},\"ids\":\"8\"}', '192.168.5.62', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0', 1735874281);
INSERT INTO `t_admin_log` VALUES (255, 2, 'root', '/stock.php/ajax/upload', '', '{\"category\":\"\"}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735874726);
INSERT INTO `t_admin_log` VALUES (256, 2, 'root', '/stock.php/carousel/add?dialog=1', '轮播管理 / 添加', '{\"dialog\":\"1\",\"row\":{\"title\":\"banner3\",\"picUrl\":\"\\/uploads\\/20250103\\/11fc7be8553ceed7bf9226edbc0fe211.jpg\",\"sort\":\"0\",\"itime\":\"2025-01-03 11:25:15\",\"utime\":\"2025-01-03 11:25:15\"}}', '192.168.5.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735874727);
INSERT INTO `t_admin_log` VALUES (257, 2, 'root', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"29\"}', '192.168.30.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735876664);
INSERT INTO `t_admin_log` VALUES (258, 2, 'root', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"30\"}', '192.168.30.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735876664);
INSERT INTO `t_admin_log` VALUES (259, 2, 'root', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"31\"}', '192.168.30.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735876665);
INSERT INTO `t_admin_log` VALUES (260, 2, 'root', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"32\"}', '192.168.30.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735876667);
INSERT INTO `t_admin_log` VALUES (261, 2, 'root', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"33\"}', '192.168.30.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735876667);
INSERT INTO `t_admin_log` VALUES (262, 2, 'root', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"34\"}', '192.168.30.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735876669);
INSERT INTO `t_admin_log` VALUES (263, 2, 'root', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"35\"}', '192.168.30.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735876671);
INSERT INTO `t_admin_log` VALUES (264, 2, 'root', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"36\"}', '192.168.30.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735876672);
INSERT INTO `t_admin_log` VALUES (265, 2, 'root', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"37\"}', '192.168.30.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735876673);
INSERT INTO `t_admin_log` VALUES (266, 2, 'root', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"38\"}', '192.168.30.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735876677);
INSERT INTO `t_admin_log` VALUES (267, 2, 'root', '/stock.php/sign/pass', '签到核对', '{\"ids\":\"27\"}', '192.168.30.119', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 1735876844);
INSERT INTO `t_admin_log` VALUES (268, 0, 'Unknown', '/stock.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769875537);
INSERT INTO `t_admin_log` VALUES (269, 0, 'Unknown', '/stock.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769875556);
INSERT INTO `t_admin_log` VALUES (270, 0, 'Unknown', '/stock.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769875598);
INSERT INTO `t_admin_log` VALUES (271, 0, 'Unknown', '/stock.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769875641);
INSERT INTO `t_admin_log` VALUES (272, 1, 'admin', '/stock.php/index/login', '登录', '{\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1769875942);
INSERT INTO `t_admin_log` VALUES (273, 1, 'admin', '/stock.php/index/login?url=/stock.php/account?ref=addtabs', '登录', '{\"url\":\"\\/stock.php\\/account?ref=addtabs\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:83.0) Gecko/20100101 Firefox/83.0', 1769876015);
INSERT INTO `t_admin_log` VALUES (274, 1, 'admin', '/stock.php/index/login?url=/stock.php/account?ref=addtabs', '登录', '{\"url\":\"\\/stock.php\\/account?ref=addtabs\",\"__token__\":\"***\",\"username\":\"admin\",\"password\":\"***\"}', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1770119678);

-- ----------------------------
-- Table structure for t_area
-- ----------------------------
DROP TABLE IF EXISTS `t_area`;
CREATE TABLE `t_area`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `pid` int(10) NULL DEFAULT NULL COMMENT '父id',
  `shortname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '简称',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `mergename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '全称',
  `level` tinyint(4) NULL DEFAULT NULL COMMENT '层级:1=省,2=市,3=区/县',
  `pinyin` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拼音',
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '长途区号',
  `zip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮编',
  `first` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '首字母',
  `lng` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '经度',
  `lat` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '纬度',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '地区表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_area
-- ----------------------------

-- ----------------------------
-- Table structure for t_attachment
-- ----------------------------
DROP TABLE IF EXISTS `t_attachment`;
CREATE TABLE `t_attachment`  (
  `id` int(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '类别',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '管理员ID',
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '会员ID',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '物理路径',
  `imagewidth` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '宽度',
  `imageheight` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '高度',
  `imagetype` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '图片类型',
  `imageframes` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '图片帧数',
  `filename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '文件名称',
  `filesize` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '文件大小',
  `mimetype` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'mime类型',
  `extparam` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '透传数据',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建日期',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `uploadtime` bigint(16) NULL DEFAULT NULL COMMENT '上传时间',
  `storage` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'local' COMMENT '存储位置',
  `sha1` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '文件 sha1编码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '附件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_attachment
-- ----------------------------

-- ----------------------------
-- Table structure for t_auth_group
-- ----------------------------
DROP TABLE IF EXISTS `t_auth_group`;
CREATE TABLE `t_auth_group`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父组别',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '组名',
  `rules` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '规则ID',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '分组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_auth_group
-- ----------------------------
INSERT INTO `t_auth_group` VALUES (1, 0, 'Admin group', '*', 1491635035, 1491635035, 'normal');
INSERT INTO `t_auth_group` VALUES (2, 1, 'Second group', '13,14,16,15,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,40,41,42,43,44,45,46,47,48,49,50,55,56,57,58,59,60,61,62,63,64,65,1,9,10,11,7,6,8,2,4,5', 1491635035, 1491635035, 'normal');
INSERT INTO `t_auth_group` VALUES (3, 2, 'Third group', '1,4,9,10,11,13,14,15,16,17,40,41,42,43,44,45,46,47,48,49,50,55,56,57,58,59,60,61,62,63,64,65,5', 1491635035, 1491635035, 'normal');
INSERT INTO `t_auth_group` VALUES (4, 1, 'Second group 2', '1,4,13,14,15,16,17,55,56,57,58,59,60,61,62,63,64,65', 1491635035, 1491635035, 'normal');
INSERT INTO `t_auth_group` VALUES (5, 2, 'Third group 2', '1,2,6,7,8,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34', 1491635035, 1491635035, 'normal');

-- ----------------------------
-- Table structure for t_auth_group_access
-- ----------------------------
DROP TABLE IF EXISTS `t_auth_group_access`;
CREATE TABLE `t_auth_group_access`  (
  `uid` int(10) UNSIGNED NOT NULL COMMENT '会员ID',
  `group_id` int(10) UNSIGNED NOT NULL COMMENT '级别ID',
  UNIQUE INDEX `uid_group_id`(`uid`, `group_id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `group_id`(`group_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '权限分组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_auth_group_access
-- ----------------------------
INSERT INTO `t_auth_group_access` VALUES (1, 1);
INSERT INTO `t_auth_group_access` VALUES (2, 1);

-- ----------------------------
-- Table structure for t_auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_auth_rule`;
CREATE TABLE `t_auth_rule`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` enum('menu','file') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'file' COMMENT 'menu为菜单,file为权限节点',
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '规则名称',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '规则名称',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '图标',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '规则URL',
  `condition` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '条件',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
  `ismenu` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否为菜单',
  `menutype` enum('addtabs','blank','dialog','ajax') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '菜单类型',
  `extend` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '扩展属性',
  `py` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '拼音首字母',
  `pinyin` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '拼音',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NOT NULL DEFAULT 0 COMMENT '权重',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE,
  INDEX `weigh`(`weigh`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 239 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '节点表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_auth_rule
-- ----------------------------
INSERT INTO `t_auth_rule` VALUES (1, 'file', 0, 'dashboard', 'Dashboard', 'fa fa-dashboard', '', '', 'Dashboard tips', 0, NULL, '', 'kzt', 'kongzhitai', 1491635035, 1735299502, 143, 'normal');
INSERT INTO `t_auth_rule` VALUES (2, 'file', 0, 'general', 'General', 'fa fa-cogs', '', '', '', 0, NULL, '', 'cggl', 'changguiguanli', 1491635035, 1735121986, 137, 'normal');
INSERT INTO `t_auth_rule` VALUES (3, 'file', 0, 'category', 'Category', 'fa fa-leaf', '', '', 'Category tips', 0, NULL, '', 'flgl', 'fenleiguanli', 1491635035, 1491635035, 119, 'normal');
INSERT INTO `t_auth_rule` VALUES (4, 'file', 0, 'addon', 'Addon', 'fa fa-rocket', '', '', 'Addon tips', 0, NULL, '', 'cjgl', 'chajianguanli', 1491635035, 1735371670, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (5, 'file', 0, 'auth', '权限管理', 'fa fa-group', '', '', '', 1, 'addtabs', '', 'qxgl', 'quanxianguanli', 1491635035, 1735536919, 50, 'normal');
INSERT INTO `t_auth_rule` VALUES (6, 'file', 2, 'general/config', 'Config', 'fa fa-cog', '', '', 'Config tips', 0, NULL, '', 'xtpz', 'xitongpeizhi', 1491635035, 1735118460, 60, 'normal');
INSERT INTO `t_auth_rule` VALUES (7, 'file', 2, 'general/attachment', 'Attachment', 'fa fa-file-image-o', '', '', 'Attachment tips', 1, NULL, '', 'fjgl', 'fujianguanli', 1491635035, 1491635035, 53, 'normal');
INSERT INTO `t_auth_rule` VALUES (8, 'file', 2, 'general/profile', 'Profile', 'fa fa-user', '', '', '', 1, NULL, '', 'grzl', 'gerenziliao', 1491635035, 1491635035, 34, 'normal');
INSERT INTO `t_auth_rule` VALUES (9, 'file', 5, 'auth/admin', 'Admin', 'fa fa-user', '', '', 'Admin tips', 1, NULL, '', 'glygl', 'guanliyuanguanli', 1491635035, 1491635035, 118, 'normal');
INSERT INTO `t_auth_rule` VALUES (10, 'file', 5, 'auth/adminlog', 'Admin log', 'fa fa-list-alt', '', '', 'Admin log tips', 1, NULL, '', 'glyrz', 'guanliyuanrizhi', 1491635035, 1491635035, 113, 'normal');
INSERT INTO `t_auth_rule` VALUES (11, 'file', 5, 'auth/group', 'Group', 'fa fa-group', '', '', 'Group tips', 1, NULL, '', 'jsz', 'juesezu', 1491635035, 1491635035, 109, 'normal');
INSERT INTO `t_auth_rule` VALUES (12, 'file', 5, 'auth/rule', 'Rule', 'fa fa-bars', '', '', 'Rule tips', 1, NULL, '', 'cdgz', 'caidanguize', 1491635035, 1491635035, 104, 'normal');
INSERT INTO `t_auth_rule` VALUES (13, 'file', 1, 'dashboard/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 136, 'normal');
INSERT INTO `t_auth_rule` VALUES (14, 'file', 1, 'dashboard/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 135, 'normal');
INSERT INTO `t_auth_rule` VALUES (15, 'file', 1, 'dashboard/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 133, 'normal');
INSERT INTO `t_auth_rule` VALUES (16, 'file', 1, 'dashboard/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 134, 'normal');
INSERT INTO `t_auth_rule` VALUES (17, 'file', 1, 'dashboard/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 132, 'normal');
INSERT INTO `t_auth_rule` VALUES (18, 'file', 6, 'general/config/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 52, 'normal');
INSERT INTO `t_auth_rule` VALUES (19, 'file', 6, 'general/config/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 51, 'normal');
INSERT INTO `t_auth_rule` VALUES (20, 'file', 6, 'general/config/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 50, 'normal');
INSERT INTO `t_auth_rule` VALUES (21, 'file', 6, 'general/config/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 49, 'normal');
INSERT INTO `t_auth_rule` VALUES (22, 'file', 6, 'general/config/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 48, 'normal');
INSERT INTO `t_auth_rule` VALUES (23, 'file', 7, 'general/attachment/index', 'View', 'fa fa-circle-o', '', '', 'Attachment tips', 0, NULL, '', '', '', 1491635035, 1491635035, 59, 'normal');
INSERT INTO `t_auth_rule` VALUES (24, 'file', 7, 'general/attachment/select', 'Select attachment', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 58, 'normal');
INSERT INTO `t_auth_rule` VALUES (25, 'file', 7, 'general/attachment/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 57, 'normal');
INSERT INTO `t_auth_rule` VALUES (26, 'file', 7, 'general/attachment/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 56, 'normal');
INSERT INTO `t_auth_rule` VALUES (27, 'file', 7, 'general/attachment/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 55, 'normal');
INSERT INTO `t_auth_rule` VALUES (28, 'file', 7, 'general/attachment/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 54, 'normal');
INSERT INTO `t_auth_rule` VALUES (29, 'file', 8, 'general/profile/index', 'View', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 33, 'normal');
INSERT INTO `t_auth_rule` VALUES (30, 'file', 8, 'general/profile/update', 'Update profile', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 32, 'normal');
INSERT INTO `t_auth_rule` VALUES (31, 'file', 8, 'general/profile/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 31, 'normal');
INSERT INTO `t_auth_rule` VALUES (32, 'file', 8, 'general/profile/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 30, 'normal');
INSERT INTO `t_auth_rule` VALUES (33, 'file', 8, 'general/profile/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 29, 'normal');
INSERT INTO `t_auth_rule` VALUES (34, 'file', 8, 'general/profile/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 28, 'normal');
INSERT INTO `t_auth_rule` VALUES (35, 'file', 3, 'category/index', 'View', 'fa fa-circle-o', '', '', 'Category tips', 0, NULL, '', '', '', 1491635035, 1491635035, 142, 'normal');
INSERT INTO `t_auth_rule` VALUES (36, 'file', 3, 'category/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 141, 'normal');
INSERT INTO `t_auth_rule` VALUES (37, 'file', 3, 'category/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 140, 'normal');
INSERT INTO `t_auth_rule` VALUES (38, 'file', 3, 'category/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 139, 'normal');
INSERT INTO `t_auth_rule` VALUES (39, 'file', 3, 'category/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 138, 'normal');
INSERT INTO `t_auth_rule` VALUES (40, 'file', 9, 'auth/admin/index', 'View', 'fa fa-circle-o', '', '', 'Admin tips', 0, NULL, '', '', '', 1491635035, 1491635035, 117, 'normal');
INSERT INTO `t_auth_rule` VALUES (41, 'file', 9, 'auth/admin/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 116, 'normal');
INSERT INTO `t_auth_rule` VALUES (42, 'file', 9, 'auth/admin/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 115, 'normal');
INSERT INTO `t_auth_rule` VALUES (43, 'file', 9, 'auth/admin/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 114, 'normal');
INSERT INTO `t_auth_rule` VALUES (44, 'file', 10, 'auth/adminlog/index', 'View', 'fa fa-circle-o', '', '', 'Admin log tips', 0, NULL, '', '', '', 1491635035, 1491635035, 112, 'normal');
INSERT INTO `t_auth_rule` VALUES (45, 'file', 10, 'auth/adminlog/detail', 'Detail', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 111, 'normal');
INSERT INTO `t_auth_rule` VALUES (46, 'file', 10, 'auth/adminlog/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 110, 'normal');
INSERT INTO `t_auth_rule` VALUES (47, 'file', 11, 'auth/group/index', 'View', 'fa fa-circle-o', '', '', 'Group tips', 0, NULL, '', '', '', 1491635035, 1491635035, 108, 'normal');
INSERT INTO `t_auth_rule` VALUES (48, 'file', 11, 'auth/group/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 107, 'normal');
INSERT INTO `t_auth_rule` VALUES (49, 'file', 11, 'auth/group/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 106, 'normal');
INSERT INTO `t_auth_rule` VALUES (50, 'file', 11, 'auth/group/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 105, 'normal');
INSERT INTO `t_auth_rule` VALUES (51, 'file', 12, 'auth/rule/index', 'View', 'fa fa-circle-o', '', '', 'Rule tips', 0, NULL, '', '', '', 1491635035, 1491635035, 103, 'normal');
INSERT INTO `t_auth_rule` VALUES (52, 'file', 12, 'auth/rule/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 102, 'normal');
INSERT INTO `t_auth_rule` VALUES (53, 'file', 12, 'auth/rule/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 101, 'normal');
INSERT INTO `t_auth_rule` VALUES (54, 'file', 12, 'auth/rule/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 100, 'normal');
INSERT INTO `t_auth_rule` VALUES (55, 'file', 4, 'addon/index', 'View', 'fa fa-circle-o', '', '', 'Addon tips', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (56, 'file', 4, 'addon/add', 'Add', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (57, 'file', 4, 'addon/edit', 'Edit', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (58, 'file', 4, 'addon/del', 'Delete', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (59, 'file', 4, 'addon/downloaded', 'Local addon', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (60, 'file', 4, 'addon/state', 'Update state', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (63, 'file', 4, 'addon/config', 'Setting', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (64, 'file', 4, 'addon/refresh', 'Refresh', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (65, 'file', 4, 'addon/multi', 'Multi', 'fa fa-circle-o', '', '', '', 0, NULL, '', '', '', 1491635035, 1491635035, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (85, 'file', 172, 'news', '新闻管理', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'xwgl', 'xinwenguanli', 1735022037, 1735297389, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (86, 'file', 85, 'news/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735022037, 1735022037, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (87, 'file', 85, 'news/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735022037, 1735022037, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (88, 'file', 85, 'news/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735022037, 1735022037, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (89, 'file', 85, 'news/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735022037, 1735022037, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (90, 'file', 85, 'news/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735022037, 1735022037, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (91, 'file', 172, 'notice', '公告管理', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'gggl', 'gonggaoguanli', 1735118260, 1735299281, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (92, 'file', 91, 'notice/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735118260, 1735118260, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (93, 'file', 91, 'notice/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735118260, 1735118260, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (94, 'file', 91, 'notice/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735118260, 1735118260, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (95, 'file', 91, 'notice/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735118260, 1735118260, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (96, 'file', 91, 'notice/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735118260, 1735118260, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (97, 'file', 172, 'video', '视频管理', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'spgl', 'shipinguanli', 1735118779, 1735298363, 80, 'normal');
INSERT INTO `t_auth_rule` VALUES (98, 'file', 97, 'video/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735118779, 1735119701, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (99, 'file', 97, 'video/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735118779, 1735119701, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (100, 'file', 97, 'video/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735118779, 1735119701, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (101, 'file', 97, 'video/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735118779, 1735119701, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (102, 'file', 97, 'video/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735118779, 1735119701, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (103, 'file', 172, 'carousel', '轮播管理', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'lbgl', 'lunboguanli', 1735122766, 1735369891, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (104, 'file', 103, 'carousel/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735122766, 1735122766, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (105, 'file', 103, 'carousel/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735122766, 1735122766, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (106, 'file', 103, 'carousel/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735122766, 1735122766, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (107, 'file', 103, 'carousel/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735122766, 1735122766, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (108, 'file', 103, 'carousel/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735122766, 1735122766, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (110, 'file', 140, 'sign', '签到核对', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'qdhd', 'qiandaohedui', 1735122766, 1735300395, 90, 'normal');
INSERT INTO `t_auth_rule` VALUES (111, 'file', 103, 'sign/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735122766, 1735122766, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (112, 'file', 103, 'sign/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735122766, 1735122766, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (113, 'file', 103, 'sign/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735122766, 1735122766, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (114, 'file', 103, 'sign/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735122766, 1735122766, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (115, 'file', 103, 'sign/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735122766, 1735122766, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (116, 'file', 140, 'address', '收货地址', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'shdz', 'shouhuodizhi', 1735184817, 1735304106, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (117, 'file', 116, 'address/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (118, 'file', 116, 'address/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (119, 'file', 116, 'address/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (120, 'file', 116, 'address/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (121, 'file', 116, 'address/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (130, 'file', 140, 'bank', '银行卡号', 'fa fa-circle-o', '', '', '', 0, 'addtabs', '', 'yhkh', 'yinhangkahao', 1735184817, 1735305301, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (131, 'file', 116, 'bank/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (132, 'file', 116, 'bank/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (133, 'file', 116, 'bank/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (134, 'file', 116, 'bank/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (135, 'file', 116, 'bank/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (139, 'file', 140, 'account', '用户资料', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'yhzl', 'yonghuziliao', NULL, 1735302527, 100, 'normal');
INSERT INTO `t_auth_rule` VALUES (140, 'file', 0, 'main', '用户中心', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'yhzx', 'yonghuzhongxin', 1735191856, 1735536935, 100, 'normal');
INSERT INTO `t_auth_rule` VALUES (141, 'file', 140, 'account/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (142, 'file', 140, 'account/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (143, 'file', 140, 'account/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (144, 'file', 140, 'account/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (145, 'file', 140, 'account/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735184817, 1735184817, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (146, 'file', 172, 'product', '产品管理', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'cpgl', 'chanpinguanli', 1735193871, 1735299492, 1000, 'normal');
INSERT INTO `t_auth_rule` VALUES (147, 'file', 146, 'product/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735193871, 1735193871, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (148, 'file', 146, 'product/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735193871, 1735193871, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (149, 'file', 146, 'product/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735193871, 1735193871, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (150, 'file', 146, 'product/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735193871, 1735193871, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (151, 'file', 146, 'product/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735193871, 1735193871, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (160, 'file', 140, 'bill', '用户明细', 'fa fa-circle-o', '', '', '', 1, NULL, '', 'cp', 'chanpin', 1735193871, 1735193871, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (161, 'file', 140, 'bill/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735193871, 1735193871, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (162, 'file', 140, 'bill/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735193871, 1735193871, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (163, 'file', 140, 'bill/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735193871, 1735193871, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (164, 'file', 140, 'bill/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735193871, 1735193871, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (165, 'file', 140, 'bill/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735193871, 1735193871, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (166, 'file', 172, 'sys', '支付账号', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'zfzh', 'zhifuzhanghao', 1735207074, 1735369945, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (167, 'file', 166, 'sys/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735207074, 1735208995, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (168, 'file', 166, 'sys/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735207074, 1735208995, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (169, 'file', 166, 'sys/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735207074, 1735208995, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (170, 'file', 166, 'sys/del', '删除', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735207074, 1735208995, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (171, 'file', 166, 'sys/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735207074, 1735208995, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (172, 'file', 0, '/', '平台配置', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'ptpz', 'pingtaipeizhi', 1735297295, 1735536954, 80, 'normal');
INSERT INTO `t_auth_rule` VALUES (173, 'file', 140, 'real', '实名认证', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'smrz', 'shimingrenzheng', 1735309120, 1735309346, 95, 'normal');
INSERT INTO `t_auth_rule` VALUES (174, 'file', 173, 'real/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (175, 'file', 173, 'real/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (176, 'file', 173, 'real/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (177, 'file', 173, 'real/del', 'Del', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (178, 'file', 173, 'real/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (200, 'file', 140, 'userproduct', '产品购买信息', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'smrz', 'shimingrenzheng', 1735309120, 1735309346, 80, 'normal');
INSERT INTO `t_auth_rule` VALUES (201, 'file', 200, 'userproduct/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (202, 'file', 200, 'userproduct/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (203, 'file', 200, 'userproduct/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (204, 'file', 200, 'userproduct/del', 'Del', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (205, 'file', 200, 'userproduct/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (220, 'file', 140, 'user', '邀请数据', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'smrz', 'shimingrenzheng', 1735309120, 1735309346, 80, 'normal');
INSERT INTO `t_auth_rule` VALUES (221, 'file', 220, 'user/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (222, 'file', 220, 'user/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (223, 'file', 220, 'user/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (224, 'file', 220, 'user/del', 'Del', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (225, 'file', 220, 'user/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735309120, 1735309120, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (226, 'file', 232, 'pay', '充值', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'zfgl', 'zhifuguanli', 1735448626, 1735449339, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (227, 'file', 226, 'pay/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735448626, 1735448626, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (228, 'file', 226, 'pay/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735448626, 1735448626, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (229, 'file', 226, 'pay/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735448626, 1735448626, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (230, 'file', 226, 'pay/del', 'Del', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735448626, 1735448626, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (231, 'file', 226, 'pay/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735448626, 1735448626, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (232, 'file', 0, '/bus', '交易中心', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'jyzx', 'jiaoyizhongxin', NULL, 1735537000, 70, 'normal');
INSERT INTO `t_auth_rule` VALUES (233, 'file', 232, 'withdrawal', '提现', 'fa fa-circle-o', '', '', '', 1, 'addtabs', '', 'tx', 'tixian', 1735549345, 1735549409, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (234, 'file', 233, 'withdrawal/index', '查看', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'zk', 'zhakan', 1735549345, 1735549345, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (235, 'file', 233, 'withdrawal/add', '添加', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'tj', 'tianjia', 1735549345, 1735549345, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (236, 'file', 233, 'withdrawal/edit', '编辑', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'bj', 'bianji', 1735549345, 1735549345, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (237, 'file', 233, 'withdrawal/del', 'Del', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'sc', 'shanchu', 1735549345, 1735549345, 0, 'normal');
INSERT INTO `t_auth_rule` VALUES (238, 'file', 233, 'withdrawal/multi', '批量更新', 'fa fa-circle-o', '', '', '', 0, NULL, '', 'plgx', 'pilianggengxin', 1735549345, 1735549345, 0, 'normal');

-- ----------------------------
-- Table structure for t_bill_record
-- ----------------------------
DROP TABLE IF EXISTS `t_bill_record`;
CREATE TABLE `t_bill_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增字段',
  `uid` bigint(20) NULL DEFAULT 0 COMMENT 'uid',
  `money` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '价格',
  `money_type` int(11) NULL DEFAULT NULL COMMENT '1余额, 2 回报钱包, 3补助钱包, 4圆梦基金',
  `bill_unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '类型 sub-扣钱 add-价钱',
  `bill_type` int(11) NULL DEFAULT 0 COMMENT '类型 1-购买产品',
  `ext_id` int(11) NULL DEFAULT 0 COMMENT '扩张ID',
  `itime` int(11) NOT NULL COMMENT '创建时间, 存储内容的创建时间 (Unix 时间戳)',
  `utime` int(11) NOT NULL COMMENT '更新时间, 存储内容的最后更新时间 (Unix 时间戳)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户账单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_bill_record
-- ----------------------------

-- ----------------------------
-- Table structure for t_bind_bank_card
-- ----------------------------
DROP TABLE IF EXISTS `t_bind_bank_card`;
CREATE TABLE `t_bind_bank_card`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标记id',
  `uid` int(11) NOT NULL COMMENT '用户id',
  `pay_type` int(11) NULL DEFAULT 1 COMMENT '1-银行卡 2-支付宝',
  `realName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '姓名',
  `bankName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '银行名字',
  `bankCard` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '银行卡号',
  `alipay_card` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '支付宝账号',
  `type` int(11) NULL DEFAULT 1 COMMENT '1-创建 2-删除',
  `itime` int(11) NOT NULL COMMENT '创建时间',
  `utime` int(11) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '银行卡' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_bind_bank_card
-- ----------------------------

-- ----------------------------
-- Table structure for t_carousel
-- ----------------------------
DROP TABLE IF EXISTS `t_carousel`;
CREATE TABLE `t_carousel`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标记id',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标题',
  `picUrl` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '图片地址',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `type` int(11) NOT NULL DEFAULT 1 COMMENT '状态 1为启用 2为关闭',
  `itime` int(11) NOT NULL COMMENT '创建时间',
  `utime` int(11) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '广告信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_carousel
-- ----------------------------

-- ----------------------------
-- Table structure for t_category
-- ----------------------------
DROP TABLE IF EXISTS `t_category`;
CREATE TABLE `t_category`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父ID',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '栏目类型',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `flag` set('hot','index','recommend') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '图片',
  `keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '关键字',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '描述',
  `diyname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '自定义名称',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NOT NULL DEFAULT 0 COMMENT '权重',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `weigh`(`weigh`, `id`) USING BTREE,
  INDEX `pid`(`pid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_category
-- ----------------------------
INSERT INTO `t_category` VALUES (1, 0, 'page', '官方新闻', 'news', 'recommend', '/assets/img/qrcode.png', '', '', 'news', 1491635035, 1491635035, 1, 'normal');
INSERT INTO `t_category` VALUES (2, 0, 'page', '移动应用', 'mobileapp', 'hot', '/assets/img/qrcode.png', '', '', 'mobileapp', 1491635035, 1491635035, 2, 'normal');
INSERT INTO `t_category` VALUES (3, 2, 'page', '微信公众号', 'wechatpublic', 'index', '/assets/img/qrcode.png', '', '', 'wechatpublic', 1491635035, 1491635035, 3, 'normal');
INSERT INTO `t_category` VALUES (4, 2, 'page', 'Android开发', 'android', 'recommend', '/assets/img/qrcode.png', '', '', 'android', 1491635035, 1491635035, 4, 'normal');
INSERT INTO `t_category` VALUES (5, 0, 'page', '软件产品', 'software', 'recommend', '/assets/img/qrcode.png', '', '', 'software', 1491635035, 1491635035, 5, 'normal');
INSERT INTO `t_category` VALUES (6, 5, 'page', '网站建站', 'website', 'recommend', '/assets/img/qrcode.png', '', '', 'website', 1491635035, 1491635035, 6, 'normal');
INSERT INTO `t_category` VALUES (7, 5, 'page', '企业管理软件', 'company', 'index', '/assets/img/qrcode.png', '', '', 'company', 1491635035, 1491635035, 7, 'normal');
INSERT INTO `t_category` VALUES (8, 6, 'page', 'PC端', 'website-pc', 'recommend', '/assets/img/qrcode.png', '', '', 'website-pc', 1491635035, 1491635035, 8, 'normal');
INSERT INTO `t_category` VALUES (9, 6, 'page', '移动端', 'website-mobile', 'recommend', '/assets/img/qrcode.png', '', '', 'website-mobile', 1491635035, 1491635035, 9, 'normal');
INSERT INTO `t_category` VALUES (10, 7, 'page', 'CRM系统 ', 'company-crm', 'recommend', '/assets/img/qrcode.png', '', '', 'company-crm', 1491635035, 1491635035, 10, 'normal');
INSERT INTO `t_category` VALUES (11, 7, 'page', 'SASS平台软件', 'company-sass', 'recommend', '/assets/img/qrcode.png', '', '', 'company-sass', 1491635035, 1491635035, 11, 'normal');
INSERT INTO `t_category` VALUES (12, 0, 'test', '测试1', 'test1', 'recommend', '/assets/img/qrcode.png', '', '', 'test1', 1491635035, 1491635035, 12, 'normal');
INSERT INTO `t_category` VALUES (13, 0, 'test', '测试2', 'test2', 'recommend', '/assets/img/qrcode.png', '', '', 'test2', 1491635035, 1491635035, 13, 'normal');

-- ----------------------------
-- Table structure for t_city
-- ----------------------------
DROP TABLE IF EXISTS `t_city`;
CREATE TABLE `t_city`  (
  `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_id` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `type` tinyint(1) NOT NULL DEFAULT 2,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `class_parent_id`(`parent_id`) USING BTREE,
  INDEX `class_type`(`type`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 3409 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_city
-- ----------------------------
INSERT INTO `t_city` VALUES (2, 1, '北京', 1);
INSERT INTO `t_city` VALUES (3, 1, '安徽', 1);
INSERT INTO `t_city` VALUES (4, 1, '福建', 1);
INSERT INTO `t_city` VALUES (5, 1, '甘肃', 1);
INSERT INTO `t_city` VALUES (6, 1, '广东', 1);
INSERT INTO `t_city` VALUES (7, 1, '广西', 1);
INSERT INTO `t_city` VALUES (8, 1, '贵州', 1);
INSERT INTO `t_city` VALUES (9, 1, '海南', 1);
INSERT INTO `t_city` VALUES (10, 1, '河北', 1);
INSERT INTO `t_city` VALUES (11, 1, '河南', 1);
INSERT INTO `t_city` VALUES (12, 1, '黑龙江', 1);
INSERT INTO `t_city` VALUES (13, 1, '湖北', 1);
INSERT INTO `t_city` VALUES (14, 1, '湖南', 1);
INSERT INTO `t_city` VALUES (15, 1, '吉林', 1);
INSERT INTO `t_city` VALUES (16, 1, '江苏', 1);
INSERT INTO `t_city` VALUES (17, 1, '江西', 1);
INSERT INTO `t_city` VALUES (18, 1, '辽宁', 1);
INSERT INTO `t_city` VALUES (19, 1, '内蒙古', 1);
INSERT INTO `t_city` VALUES (20, 1, '宁夏', 1);
INSERT INTO `t_city` VALUES (21, 1, '青海', 1);
INSERT INTO `t_city` VALUES (22, 1, '山东', 1);
INSERT INTO `t_city` VALUES (23, 1, '山西', 1);
INSERT INTO `t_city` VALUES (24, 1, '陕西', 1);
INSERT INTO `t_city` VALUES (25, 1, '上海', 1);
INSERT INTO `t_city` VALUES (26, 1, '四川', 1);
INSERT INTO `t_city` VALUES (27, 1, '天津', 1);
INSERT INTO `t_city` VALUES (28, 1, '西藏', 1);
INSERT INTO `t_city` VALUES (29, 1, '新疆', 1);
INSERT INTO `t_city` VALUES (30, 1, '云南', 1);
INSERT INTO `t_city` VALUES (31, 1, '浙江', 1);
INSERT INTO `t_city` VALUES (32, 1, '重庆', 1);
INSERT INTO `t_city` VALUES (33, 1, '香港', 1);
INSERT INTO `t_city` VALUES (34, 1, '澳门', 1);
INSERT INTO `t_city` VALUES (35, 1, '台湾', 1);
INSERT INTO `t_city` VALUES (36, 3, '安庆', 2);
INSERT INTO `t_city` VALUES (37, 3, '蚌埠', 2);
INSERT INTO `t_city` VALUES (38, 3, '巢湖', 2);
INSERT INTO `t_city` VALUES (39, 3, '池州', 2);
INSERT INTO `t_city` VALUES (40, 3, '滁州', 2);
INSERT INTO `t_city` VALUES (41, 3, '阜阳', 2);
INSERT INTO `t_city` VALUES (42, 3, '淮北', 2);
INSERT INTO `t_city` VALUES (43, 3, '淮南', 2);
INSERT INTO `t_city` VALUES (44, 3, '黄山', 2);
INSERT INTO `t_city` VALUES (45, 3, '六安', 2);
INSERT INTO `t_city` VALUES (46, 3, '马鞍山', 2);
INSERT INTO `t_city` VALUES (47, 3, '宿州', 2);
INSERT INTO `t_city` VALUES (48, 3, '铜陵', 2);
INSERT INTO `t_city` VALUES (49, 3, '芜湖', 2);
INSERT INTO `t_city` VALUES (50, 3, '宣城', 2);
INSERT INTO `t_city` VALUES (51, 3, '亳州', 2);
INSERT INTO `t_city` VALUES (52, 2, '北京', 2);
INSERT INTO `t_city` VALUES (53, 4, '福州', 2);
INSERT INTO `t_city` VALUES (54, 4, '龙岩', 2);
INSERT INTO `t_city` VALUES (55, 4, '南平', 2);
INSERT INTO `t_city` VALUES (56, 4, '宁德', 2);
INSERT INTO `t_city` VALUES (57, 4, '莆田', 2);
INSERT INTO `t_city` VALUES (58, 4, '泉州', 2);
INSERT INTO `t_city` VALUES (59, 4, '三明', 2);
INSERT INTO `t_city` VALUES (60, 4, '厦门', 2);
INSERT INTO `t_city` VALUES (61, 4, '漳州', 2);
INSERT INTO `t_city` VALUES (62, 5, '兰州', 2);
INSERT INTO `t_city` VALUES (63, 5, '白银', 2);
INSERT INTO `t_city` VALUES (64, 5, '定西', 2);
INSERT INTO `t_city` VALUES (65, 5, '甘南', 2);
INSERT INTO `t_city` VALUES (66, 5, '嘉峪关', 2);
INSERT INTO `t_city` VALUES (67, 5, '金昌', 2);
INSERT INTO `t_city` VALUES (68, 5, '酒泉', 2);
INSERT INTO `t_city` VALUES (69, 5, '临夏', 2);
INSERT INTO `t_city` VALUES (70, 5, '陇南', 2);
INSERT INTO `t_city` VALUES (71, 5, '平凉', 2);
INSERT INTO `t_city` VALUES (72, 5, '庆阳', 2);
INSERT INTO `t_city` VALUES (73, 5, '天水', 2);
INSERT INTO `t_city` VALUES (74, 5, '武威', 2);
INSERT INTO `t_city` VALUES (75, 5, '张掖', 2);
INSERT INTO `t_city` VALUES (76, 6, '广州', 2);
INSERT INTO `t_city` VALUES (77, 6, '深圳', 2);
INSERT INTO `t_city` VALUES (78, 6, '潮州', 2);
INSERT INTO `t_city` VALUES (79, 6, '东莞', 2);
INSERT INTO `t_city` VALUES (80, 6, '佛山', 2);
INSERT INTO `t_city` VALUES (81, 6, '河源', 2);
INSERT INTO `t_city` VALUES (82, 6, '惠州', 2);
INSERT INTO `t_city` VALUES (83, 6, '江门', 2);
INSERT INTO `t_city` VALUES (84, 6, '揭阳', 2);
INSERT INTO `t_city` VALUES (85, 6, '茂名', 2);
INSERT INTO `t_city` VALUES (86, 6, '梅州', 2);
INSERT INTO `t_city` VALUES (87, 6, '清远', 2);
INSERT INTO `t_city` VALUES (88, 6, '汕头', 2);
INSERT INTO `t_city` VALUES (89, 6, '汕尾', 2);
INSERT INTO `t_city` VALUES (90, 6, '韶关', 2);
INSERT INTO `t_city` VALUES (91, 6, '阳江', 2);
INSERT INTO `t_city` VALUES (92, 6, '云浮', 2);
INSERT INTO `t_city` VALUES (93, 6, '湛江', 2);
INSERT INTO `t_city` VALUES (94, 6, '肇庆', 2);
INSERT INTO `t_city` VALUES (95, 6, '中山', 2);
INSERT INTO `t_city` VALUES (96, 6, '珠海', 2);
INSERT INTO `t_city` VALUES (97, 7, '南宁', 2);
INSERT INTO `t_city` VALUES (98, 7, '桂林', 2);
INSERT INTO `t_city` VALUES (99, 7, '百色', 2);
INSERT INTO `t_city` VALUES (100, 7, '北海', 2);
INSERT INTO `t_city` VALUES (101, 7, '崇左', 2);
INSERT INTO `t_city` VALUES (102, 7, '防城港', 2);
INSERT INTO `t_city` VALUES (103, 7, '贵港', 2);
INSERT INTO `t_city` VALUES (104, 7, '河池', 2);
INSERT INTO `t_city` VALUES (105, 7, '贺州', 2);
INSERT INTO `t_city` VALUES (106, 7, '来宾', 2);
INSERT INTO `t_city` VALUES (107, 7, '柳州', 2);
INSERT INTO `t_city` VALUES (108, 7, '钦州', 2);
INSERT INTO `t_city` VALUES (109, 7, '梧州', 2);
INSERT INTO `t_city` VALUES (110, 7, '玉林', 2);
INSERT INTO `t_city` VALUES (111, 8, '贵阳', 2);
INSERT INTO `t_city` VALUES (112, 8, '安顺', 2);
INSERT INTO `t_city` VALUES (113, 8, '毕节', 2);
INSERT INTO `t_city` VALUES (114, 8, '六盘水', 2);
INSERT INTO `t_city` VALUES (115, 8, '黔东南', 2);
INSERT INTO `t_city` VALUES (116, 8, '黔南', 2);
INSERT INTO `t_city` VALUES (117, 8, '黔西南', 2);
INSERT INTO `t_city` VALUES (118, 8, '铜仁', 2);
INSERT INTO `t_city` VALUES (119, 8, '遵义', 2);
INSERT INTO `t_city` VALUES (120, 9, '海口', 2);
INSERT INTO `t_city` VALUES (121, 9, '三亚', 2);
INSERT INTO `t_city` VALUES (122, 9, '白沙', 2);
INSERT INTO `t_city` VALUES (123, 9, '保亭', 2);
INSERT INTO `t_city` VALUES (124, 9, '昌江', 2);
INSERT INTO `t_city` VALUES (125, 9, '澄迈县', 2);
INSERT INTO `t_city` VALUES (126, 9, '定安县', 2);
INSERT INTO `t_city` VALUES (127, 9, '东方', 2);
INSERT INTO `t_city` VALUES (128, 9, '乐东', 2);
INSERT INTO `t_city` VALUES (129, 9, '临高县', 2);
INSERT INTO `t_city` VALUES (130, 9, '陵水', 2);
INSERT INTO `t_city` VALUES (131, 9, '琼海', 2);
INSERT INTO `t_city` VALUES (132, 9, '琼中', 2);
INSERT INTO `t_city` VALUES (133, 9, '屯昌县', 2);
INSERT INTO `t_city` VALUES (134, 9, '万宁', 2);
INSERT INTO `t_city` VALUES (135, 9, '文昌', 2);
INSERT INTO `t_city` VALUES (136, 9, '五指山', 2);
INSERT INTO `t_city` VALUES (137, 9, '儋州', 2);
INSERT INTO `t_city` VALUES (138, 10, '石家庄', 2);
INSERT INTO `t_city` VALUES (139, 10, '保定', 2);
INSERT INTO `t_city` VALUES (140, 10, '沧州', 2);
INSERT INTO `t_city` VALUES (141, 10, '承德', 2);
INSERT INTO `t_city` VALUES (142, 10, '邯郸', 2);
INSERT INTO `t_city` VALUES (143, 10, '衡水', 2);
INSERT INTO `t_city` VALUES (144, 10, '廊坊', 2);
INSERT INTO `t_city` VALUES (145, 10, '秦皇岛', 2);
INSERT INTO `t_city` VALUES (146, 10, '唐山', 2);
INSERT INTO `t_city` VALUES (147, 10, '邢台', 2);
INSERT INTO `t_city` VALUES (148, 10, '张家口', 2);
INSERT INTO `t_city` VALUES (149, 11, '郑州', 2);
INSERT INTO `t_city` VALUES (150, 11, '洛阳', 2);
INSERT INTO `t_city` VALUES (151, 11, '开封', 2);
INSERT INTO `t_city` VALUES (152, 11, '安阳', 2);
INSERT INTO `t_city` VALUES (153, 11, '鹤壁', 2);
INSERT INTO `t_city` VALUES (154, 11, '济源', 2);
INSERT INTO `t_city` VALUES (155, 11, '焦作', 2);
INSERT INTO `t_city` VALUES (156, 11, '南阳', 2);
INSERT INTO `t_city` VALUES (157, 11, '平顶山', 2);
INSERT INTO `t_city` VALUES (158, 11, '三门峡', 2);
INSERT INTO `t_city` VALUES (159, 11, '商丘', 2);
INSERT INTO `t_city` VALUES (160, 11, '新乡', 2);
INSERT INTO `t_city` VALUES (161, 11, '信阳', 2);
INSERT INTO `t_city` VALUES (162, 11, '许昌', 2);
INSERT INTO `t_city` VALUES (163, 11, '周口', 2);
INSERT INTO `t_city` VALUES (164, 11, '驻马店', 2);
INSERT INTO `t_city` VALUES (165, 11, '漯河', 2);
INSERT INTO `t_city` VALUES (166, 11, '濮阳', 2);
INSERT INTO `t_city` VALUES (167, 12, '哈尔滨', 2);
INSERT INTO `t_city` VALUES (168, 12, '大庆', 2);
INSERT INTO `t_city` VALUES (169, 12, '大兴安岭', 2);
INSERT INTO `t_city` VALUES (170, 12, '鹤岗', 2);
INSERT INTO `t_city` VALUES (171, 12, '黑河', 2);
INSERT INTO `t_city` VALUES (172, 12, '鸡西', 2);
INSERT INTO `t_city` VALUES (173, 12, '佳木斯', 2);
INSERT INTO `t_city` VALUES (174, 12, '牡丹江', 2);
INSERT INTO `t_city` VALUES (175, 12, '七台河', 2);
INSERT INTO `t_city` VALUES (176, 12, '齐齐哈尔', 2);
INSERT INTO `t_city` VALUES (177, 12, '双鸭山', 2);
INSERT INTO `t_city` VALUES (178, 12, '绥化', 2);
INSERT INTO `t_city` VALUES (179, 12, '伊春', 2);
INSERT INTO `t_city` VALUES (180, 13, '武汉', 2);
INSERT INTO `t_city` VALUES (181, 13, '仙桃', 2);
INSERT INTO `t_city` VALUES (182, 13, '鄂州', 2);
INSERT INTO `t_city` VALUES (183, 13, '黄冈', 2);
INSERT INTO `t_city` VALUES (184, 13, '黄石', 2);
INSERT INTO `t_city` VALUES (185, 13, '荆门', 2);
INSERT INTO `t_city` VALUES (186, 13, '荆州', 2);
INSERT INTO `t_city` VALUES (187, 13, '潜江', 2);
INSERT INTO `t_city` VALUES (188, 13, '神农架林区', 2);
INSERT INTO `t_city` VALUES (189, 13, '十堰', 2);
INSERT INTO `t_city` VALUES (190, 13, '随州', 2);
INSERT INTO `t_city` VALUES (191, 13, '天门', 2);
INSERT INTO `t_city` VALUES (192, 13, '咸宁', 2);
INSERT INTO `t_city` VALUES (193, 13, '襄樊', 2);
INSERT INTO `t_city` VALUES (194, 13, '孝感', 2);
INSERT INTO `t_city` VALUES (195, 13, '宜昌', 2);
INSERT INTO `t_city` VALUES (196, 13, '恩施', 2);
INSERT INTO `t_city` VALUES (197, 14, '长沙', 2);
INSERT INTO `t_city` VALUES (198, 14, '张家界', 2);
INSERT INTO `t_city` VALUES (199, 14, '常德', 2);
INSERT INTO `t_city` VALUES (200, 14, '郴州', 2);
INSERT INTO `t_city` VALUES (201, 14, '衡阳', 2);
INSERT INTO `t_city` VALUES (202, 14, '怀化', 2);
INSERT INTO `t_city` VALUES (203, 14, '娄底', 2);
INSERT INTO `t_city` VALUES (204, 14, '邵阳', 2);
INSERT INTO `t_city` VALUES (205, 14, '湘潭', 2);
INSERT INTO `t_city` VALUES (206, 14, '湘西', 2);
INSERT INTO `t_city` VALUES (207, 14, '益阳', 2);
INSERT INTO `t_city` VALUES (208, 14, '永州', 2);
INSERT INTO `t_city` VALUES (209, 14, '岳阳', 2);
INSERT INTO `t_city` VALUES (210, 14, '株洲', 2);
INSERT INTO `t_city` VALUES (211, 15, '长春', 2);
INSERT INTO `t_city` VALUES (212, 15, '吉林', 2);
INSERT INTO `t_city` VALUES (213, 15, '白城', 2);
INSERT INTO `t_city` VALUES (214, 15, '白山', 2);
INSERT INTO `t_city` VALUES (215, 15, '辽源', 2);
INSERT INTO `t_city` VALUES (216, 15, '四平', 2);
INSERT INTO `t_city` VALUES (217, 15, '松原', 2);
INSERT INTO `t_city` VALUES (218, 15, '通化', 2);
INSERT INTO `t_city` VALUES (219, 15, '延边', 2);
INSERT INTO `t_city` VALUES (220, 16, '南京', 2);
INSERT INTO `t_city` VALUES (221, 16, '苏州', 2);
INSERT INTO `t_city` VALUES (222, 16, '无锡', 2);
INSERT INTO `t_city` VALUES (223, 16, '常州', 2);
INSERT INTO `t_city` VALUES (224, 16, '淮安', 2);
INSERT INTO `t_city` VALUES (225, 16, '连云港', 2);
INSERT INTO `t_city` VALUES (226, 16, '南通', 2);
INSERT INTO `t_city` VALUES (227, 16, '宿迁', 2);
INSERT INTO `t_city` VALUES (228, 16, '泰州', 2);
INSERT INTO `t_city` VALUES (229, 16, '徐州', 2);
INSERT INTO `t_city` VALUES (230, 16, '盐城', 2);
INSERT INTO `t_city` VALUES (231, 16, '扬州', 2);
INSERT INTO `t_city` VALUES (232, 16, '镇江', 2);
INSERT INTO `t_city` VALUES (233, 17, '南昌', 2);
INSERT INTO `t_city` VALUES (234, 17, '抚州', 2);
INSERT INTO `t_city` VALUES (235, 17, '赣州', 2);
INSERT INTO `t_city` VALUES (236, 17, '吉安', 2);
INSERT INTO `t_city` VALUES (237, 17, '景德镇', 2);
INSERT INTO `t_city` VALUES (238, 17, '九江', 2);
INSERT INTO `t_city` VALUES (239, 17, '萍乡', 2);
INSERT INTO `t_city` VALUES (240, 17, '上饶', 2);
INSERT INTO `t_city` VALUES (241, 17, '新余', 2);
INSERT INTO `t_city` VALUES (242, 17, '宜春', 2);
INSERT INTO `t_city` VALUES (243, 17, '鹰潭', 2);
INSERT INTO `t_city` VALUES (244, 18, '沈阳', 2);
INSERT INTO `t_city` VALUES (245, 18, '大连', 2);
INSERT INTO `t_city` VALUES (246, 18, '鞍山', 2);
INSERT INTO `t_city` VALUES (247, 18, '本溪', 2);
INSERT INTO `t_city` VALUES (248, 18, '朝阳', 2);
INSERT INTO `t_city` VALUES (249, 18, '丹东', 2);
INSERT INTO `t_city` VALUES (250, 18, '抚顺', 2);
INSERT INTO `t_city` VALUES (251, 18, '阜新', 2);
INSERT INTO `t_city` VALUES (252, 18, '葫芦岛', 2);
INSERT INTO `t_city` VALUES (253, 18, '锦州', 2);
INSERT INTO `t_city` VALUES (254, 18, '辽阳', 2);
INSERT INTO `t_city` VALUES (255, 18, '盘锦', 2);
INSERT INTO `t_city` VALUES (256, 18, '铁岭', 2);
INSERT INTO `t_city` VALUES (257, 18, '营口', 2);
INSERT INTO `t_city` VALUES (258, 19, '呼和浩特', 2);
INSERT INTO `t_city` VALUES (259, 19, '阿拉善盟', 2);
INSERT INTO `t_city` VALUES (260, 19, '巴彦淖尔盟', 2);
INSERT INTO `t_city` VALUES (261, 19, '包头', 2);
INSERT INTO `t_city` VALUES (262, 19, '赤峰', 2);
INSERT INTO `t_city` VALUES (263, 19, '鄂尔多斯', 2);
INSERT INTO `t_city` VALUES (264, 19, '呼伦贝尔', 2);
INSERT INTO `t_city` VALUES (265, 19, '通辽', 2);
INSERT INTO `t_city` VALUES (266, 19, '乌海', 2);
INSERT INTO `t_city` VALUES (267, 19, '乌兰察布市', 2);
INSERT INTO `t_city` VALUES (268, 19, '锡林郭勒盟', 2);
INSERT INTO `t_city` VALUES (269, 19, '兴安盟', 2);
INSERT INTO `t_city` VALUES (270, 20, '银川', 2);
INSERT INTO `t_city` VALUES (271, 20, '固原', 2);
INSERT INTO `t_city` VALUES (272, 20, '石嘴山', 2);
INSERT INTO `t_city` VALUES (273, 20, '吴忠', 2);
INSERT INTO `t_city` VALUES (274, 20, '中卫', 2);
INSERT INTO `t_city` VALUES (275, 21, '西宁', 2);
INSERT INTO `t_city` VALUES (276, 21, '果洛', 2);
INSERT INTO `t_city` VALUES (277, 21, '海北', 2);
INSERT INTO `t_city` VALUES (278, 21, '海东', 2);
INSERT INTO `t_city` VALUES (279, 21, '海南', 2);
INSERT INTO `t_city` VALUES (280, 21, '海西', 2);
INSERT INTO `t_city` VALUES (281, 21, '黄南', 2);
INSERT INTO `t_city` VALUES (282, 21, '玉树', 2);
INSERT INTO `t_city` VALUES (283, 22, '济南', 2);
INSERT INTO `t_city` VALUES (284, 22, '青岛', 2);
INSERT INTO `t_city` VALUES (285, 22, '滨州', 2);
INSERT INTO `t_city` VALUES (286, 22, '德州', 2);
INSERT INTO `t_city` VALUES (287, 22, '东营', 2);
INSERT INTO `t_city` VALUES (288, 22, '菏泽', 2);
INSERT INTO `t_city` VALUES (289, 22, '济宁', 2);
INSERT INTO `t_city` VALUES (290, 22, '莱芜', 2);
INSERT INTO `t_city` VALUES (291, 22, '聊城', 2);
INSERT INTO `t_city` VALUES (292, 22, '临沂', 2);
INSERT INTO `t_city` VALUES (293, 22, '日照', 2);
INSERT INTO `t_city` VALUES (294, 22, '泰安', 2);
INSERT INTO `t_city` VALUES (295, 22, '威海', 2);
INSERT INTO `t_city` VALUES (296, 22, '潍坊', 2);
INSERT INTO `t_city` VALUES (297, 22, '烟台', 2);
INSERT INTO `t_city` VALUES (298, 22, '枣庄', 2);
INSERT INTO `t_city` VALUES (299, 22, '淄博', 2);
INSERT INTO `t_city` VALUES (300, 23, '太原', 2);
INSERT INTO `t_city` VALUES (301, 23, '长治', 2);
INSERT INTO `t_city` VALUES (302, 23, '大同', 2);
INSERT INTO `t_city` VALUES (303, 23, '晋城', 2);
INSERT INTO `t_city` VALUES (304, 23, '晋中', 2);
INSERT INTO `t_city` VALUES (305, 23, '临汾', 2);
INSERT INTO `t_city` VALUES (306, 23, '吕梁', 2);
INSERT INTO `t_city` VALUES (307, 23, '朔州', 2);
INSERT INTO `t_city` VALUES (308, 23, '忻州', 2);
INSERT INTO `t_city` VALUES (309, 23, '阳泉', 2);
INSERT INTO `t_city` VALUES (310, 23, '运城', 2);
INSERT INTO `t_city` VALUES (311, 24, '西安', 2);
INSERT INTO `t_city` VALUES (312, 24, '安康', 2);
INSERT INTO `t_city` VALUES (313, 24, '宝鸡', 2);
INSERT INTO `t_city` VALUES (314, 24, '汉中', 2);
INSERT INTO `t_city` VALUES (315, 24, '商洛', 2);
INSERT INTO `t_city` VALUES (316, 24, '铜川', 2);
INSERT INTO `t_city` VALUES (317, 24, '渭南', 2);
INSERT INTO `t_city` VALUES (318, 24, '咸阳', 2);
INSERT INTO `t_city` VALUES (319, 24, '延安', 2);
INSERT INTO `t_city` VALUES (320, 24, '榆林', 2);
INSERT INTO `t_city` VALUES (321, 25, '上海', 2);
INSERT INTO `t_city` VALUES (322, 26, '成都', 2);
INSERT INTO `t_city` VALUES (323, 26, '绵阳', 2);
INSERT INTO `t_city` VALUES (324, 26, '阿坝', 2);
INSERT INTO `t_city` VALUES (325, 26, '巴中', 2);
INSERT INTO `t_city` VALUES (326, 26, '达州', 2);
INSERT INTO `t_city` VALUES (327, 26, '德阳', 2);
INSERT INTO `t_city` VALUES (328, 26, '甘孜', 2);
INSERT INTO `t_city` VALUES (329, 26, '广安', 2);
INSERT INTO `t_city` VALUES (330, 26, '广元', 2);
INSERT INTO `t_city` VALUES (331, 26, '乐山', 2);
INSERT INTO `t_city` VALUES (332, 26, '凉山', 2);
INSERT INTO `t_city` VALUES (333, 26, '眉山', 2);
INSERT INTO `t_city` VALUES (334, 26, '南充', 2);
INSERT INTO `t_city` VALUES (335, 26, '内江', 2);
INSERT INTO `t_city` VALUES (336, 26, '攀枝花', 2);
INSERT INTO `t_city` VALUES (337, 26, '遂宁', 2);
INSERT INTO `t_city` VALUES (338, 26, '雅安', 2);
INSERT INTO `t_city` VALUES (339, 26, '宜宾', 2);
INSERT INTO `t_city` VALUES (340, 26, '资阳', 2);
INSERT INTO `t_city` VALUES (341, 26, '自贡', 2);
INSERT INTO `t_city` VALUES (342, 26, '泸州', 2);
INSERT INTO `t_city` VALUES (343, 27, '天津', 2);
INSERT INTO `t_city` VALUES (344, 28, '拉萨', 2);
INSERT INTO `t_city` VALUES (345, 28, '阿里', 2);
INSERT INTO `t_city` VALUES (346, 28, '昌都', 2);
INSERT INTO `t_city` VALUES (347, 28, '林芝', 2);
INSERT INTO `t_city` VALUES (348, 28, '那曲', 2);
INSERT INTO `t_city` VALUES (349, 28, '日喀则', 2);
INSERT INTO `t_city` VALUES (350, 28, '山南', 2);
INSERT INTO `t_city` VALUES (351, 29, '乌鲁木齐', 2);
INSERT INTO `t_city` VALUES (352, 29, '阿克苏', 2);
INSERT INTO `t_city` VALUES (353, 29, '阿拉尔', 2);
INSERT INTO `t_city` VALUES (354, 29, '巴音郭楞', 2);
INSERT INTO `t_city` VALUES (355, 29, '博尔塔拉', 2);
INSERT INTO `t_city` VALUES (356, 29, '昌吉', 2);
INSERT INTO `t_city` VALUES (357, 29, '哈密', 2);
INSERT INTO `t_city` VALUES (358, 29, '和田', 2);
INSERT INTO `t_city` VALUES (359, 29, '喀什', 2);
INSERT INTO `t_city` VALUES (360, 29, '克拉玛依', 2);
INSERT INTO `t_city` VALUES (361, 29, '克孜勒苏', 2);
INSERT INTO `t_city` VALUES (362, 29, '石河子', 2);
INSERT INTO `t_city` VALUES (363, 29, '图木舒克', 2);
INSERT INTO `t_city` VALUES (364, 29, '吐鲁番', 2);
INSERT INTO `t_city` VALUES (365, 29, '五家渠', 2);
INSERT INTO `t_city` VALUES (366, 29, '伊犁', 2);
INSERT INTO `t_city` VALUES (367, 30, '昆明', 2);
INSERT INTO `t_city` VALUES (368, 30, '怒江', 2);
INSERT INTO `t_city` VALUES (369, 30, '普洱', 2);
INSERT INTO `t_city` VALUES (370, 30, '丽江', 2);
INSERT INTO `t_city` VALUES (371, 30, '保山', 2);
INSERT INTO `t_city` VALUES (372, 30, '楚雄', 2);
INSERT INTO `t_city` VALUES (373, 30, '大理', 2);
INSERT INTO `t_city` VALUES (374, 30, '德宏', 2);
INSERT INTO `t_city` VALUES (375, 30, '迪庆', 2);
INSERT INTO `t_city` VALUES (376, 30, '红河', 2);
INSERT INTO `t_city` VALUES (377, 30, '临沧', 2);
INSERT INTO `t_city` VALUES (378, 30, '曲靖', 2);
INSERT INTO `t_city` VALUES (379, 30, '文山', 2);
INSERT INTO `t_city` VALUES (380, 30, '西双版纳', 2);
INSERT INTO `t_city` VALUES (381, 30, '玉溪', 2);
INSERT INTO `t_city` VALUES (382, 30, '昭通', 2);
INSERT INTO `t_city` VALUES (383, 31, '杭州', 2);
INSERT INTO `t_city` VALUES (384, 31, '湖州', 2);
INSERT INTO `t_city` VALUES (385, 31, '嘉兴', 2);
INSERT INTO `t_city` VALUES (386, 31, '金华', 2);
INSERT INTO `t_city` VALUES (387, 31, '丽水', 2);
INSERT INTO `t_city` VALUES (388, 31, '宁波', 2);
INSERT INTO `t_city` VALUES (389, 31, '绍兴', 2);
INSERT INTO `t_city` VALUES (390, 31, '台州', 2);
INSERT INTO `t_city` VALUES (391, 31, '温州', 2);
INSERT INTO `t_city` VALUES (392, 31, '舟山', 2);
INSERT INTO `t_city` VALUES (393, 31, '衢州', 2);
INSERT INTO `t_city` VALUES (394, 32, '重庆', 2);
INSERT INTO `t_city` VALUES (395, 33, '香港', 2);
INSERT INTO `t_city` VALUES (396, 34, '澳门', 2);
INSERT INTO `t_city` VALUES (397, 35, '台湾', 2);
INSERT INTO `t_city` VALUES (398, 36, '迎江区', 3);
INSERT INTO `t_city` VALUES (399, 36, '大观区', 3);
INSERT INTO `t_city` VALUES (400, 36, '宜秀区', 3);
INSERT INTO `t_city` VALUES (401, 36, '桐城市', 3);
INSERT INTO `t_city` VALUES (402, 36, '怀宁县', 3);
INSERT INTO `t_city` VALUES (403, 36, '枞阳县', 3);
INSERT INTO `t_city` VALUES (404, 36, '潜山县', 3);
INSERT INTO `t_city` VALUES (405, 36, '太湖县', 3);
INSERT INTO `t_city` VALUES (406, 36, '宿松县', 3);
INSERT INTO `t_city` VALUES (407, 36, '望江县', 3);
INSERT INTO `t_city` VALUES (408, 36, '岳西县', 3);
INSERT INTO `t_city` VALUES (409, 37, '中市区', 3);
INSERT INTO `t_city` VALUES (410, 37, '东市区', 3);
INSERT INTO `t_city` VALUES (411, 37, '西市区', 3);
INSERT INTO `t_city` VALUES (412, 37, '郊区', 3);
INSERT INTO `t_city` VALUES (413, 37, '怀远县', 3);
INSERT INTO `t_city` VALUES (414, 37, '五河县', 3);
INSERT INTO `t_city` VALUES (415, 37, '固镇县', 3);
INSERT INTO `t_city` VALUES (416, 38, '居巢区', 3);
INSERT INTO `t_city` VALUES (417, 38, '庐江县', 3);
INSERT INTO `t_city` VALUES (418, 38, '无为县', 3);
INSERT INTO `t_city` VALUES (419, 38, '含山县', 3);
INSERT INTO `t_city` VALUES (420, 38, '和县', 3);
INSERT INTO `t_city` VALUES (421, 39, '贵池区', 3);
INSERT INTO `t_city` VALUES (422, 39, '东至县', 3);
INSERT INTO `t_city` VALUES (423, 39, '石台县', 3);
INSERT INTO `t_city` VALUES (424, 39, '青阳县', 3);
INSERT INTO `t_city` VALUES (425, 40, '琅琊区', 3);
INSERT INTO `t_city` VALUES (426, 40, '南谯区', 3);
INSERT INTO `t_city` VALUES (427, 40, '天长市', 3);
INSERT INTO `t_city` VALUES (428, 40, '明光市', 3);
INSERT INTO `t_city` VALUES (429, 40, '来安县', 3);
INSERT INTO `t_city` VALUES (430, 40, '全椒县', 3);
INSERT INTO `t_city` VALUES (431, 40, '定远县', 3);
INSERT INTO `t_city` VALUES (432, 40, '凤阳县', 3);
INSERT INTO `t_city` VALUES (433, 41, '蚌山区', 3);
INSERT INTO `t_city` VALUES (434, 41, '龙子湖区', 3);
INSERT INTO `t_city` VALUES (435, 41, '禹会区', 3);
INSERT INTO `t_city` VALUES (436, 41, '淮上区', 3);
INSERT INTO `t_city` VALUES (437, 41, '颍州区', 3);
INSERT INTO `t_city` VALUES (438, 41, '颍东区', 3);
INSERT INTO `t_city` VALUES (439, 41, '颍泉区', 3);
INSERT INTO `t_city` VALUES (440, 41, '界首市', 3);
INSERT INTO `t_city` VALUES (441, 41, '临泉县', 3);
INSERT INTO `t_city` VALUES (442, 41, '太和县', 3);
INSERT INTO `t_city` VALUES (443, 41, '阜南县', 3);
INSERT INTO `t_city` VALUES (444, 41, '颖上县', 3);
INSERT INTO `t_city` VALUES (445, 42, '相山区', 3);
INSERT INTO `t_city` VALUES (446, 42, '杜集区', 3);
INSERT INTO `t_city` VALUES (447, 42, '烈山区', 3);
INSERT INTO `t_city` VALUES (448, 42, '濉溪县', 3);
INSERT INTO `t_city` VALUES (449, 43, '田家庵区', 3);
INSERT INTO `t_city` VALUES (450, 43, '大通区', 3);
INSERT INTO `t_city` VALUES (451, 43, '谢家集区', 3);
INSERT INTO `t_city` VALUES (452, 43, '八公山区', 3);
INSERT INTO `t_city` VALUES (453, 43, '潘集区', 3);
INSERT INTO `t_city` VALUES (454, 43, '凤台县', 3);
INSERT INTO `t_city` VALUES (455, 44, '屯溪区', 3);
INSERT INTO `t_city` VALUES (456, 44, '黄山区', 3);
INSERT INTO `t_city` VALUES (457, 44, '徽州区', 3);
INSERT INTO `t_city` VALUES (458, 44, '歙县', 3);
INSERT INTO `t_city` VALUES (459, 44, '休宁县', 3);
INSERT INTO `t_city` VALUES (460, 44, '黟县', 3);
INSERT INTO `t_city` VALUES (461, 44, '祁门县', 3);
INSERT INTO `t_city` VALUES (462, 45, '金安区', 3);
INSERT INTO `t_city` VALUES (463, 45, '裕安区', 3);
INSERT INTO `t_city` VALUES (464, 45, '寿县', 3);
INSERT INTO `t_city` VALUES (465, 45, '霍邱县', 3);
INSERT INTO `t_city` VALUES (466, 45, '舒城县', 3);
INSERT INTO `t_city` VALUES (467, 45, '金寨县', 3);
INSERT INTO `t_city` VALUES (468, 45, '霍山县', 3);
INSERT INTO `t_city` VALUES (469, 46, '雨山区', 3);
INSERT INTO `t_city` VALUES (470, 46, '花山区', 3);
INSERT INTO `t_city` VALUES (471, 46, '金家庄区', 3);
INSERT INTO `t_city` VALUES (472, 46, '当涂县', 3);
INSERT INTO `t_city` VALUES (473, 47, '埇桥区', 3);
INSERT INTO `t_city` VALUES (474, 47, '砀山县', 3);
INSERT INTO `t_city` VALUES (475, 47, '萧县', 3);
INSERT INTO `t_city` VALUES (476, 47, '灵璧县', 3);
INSERT INTO `t_city` VALUES (477, 47, '泗县', 3);
INSERT INTO `t_city` VALUES (478, 48, '铜官山区', 3);
INSERT INTO `t_city` VALUES (479, 48, '狮子山区', 3);
INSERT INTO `t_city` VALUES (480, 48, '郊区', 3);
INSERT INTO `t_city` VALUES (481, 48, '铜陵县', 3);
INSERT INTO `t_city` VALUES (482, 49, '镜湖区', 3);
INSERT INTO `t_city` VALUES (483, 49, '弋江区', 3);
INSERT INTO `t_city` VALUES (484, 49, '鸠江区', 3);
INSERT INTO `t_city` VALUES (485, 49, '三山区', 3);
INSERT INTO `t_city` VALUES (486, 49, '芜湖县', 3);
INSERT INTO `t_city` VALUES (487, 49, '繁昌县', 3);
INSERT INTO `t_city` VALUES (488, 49, '南陵县', 3);
INSERT INTO `t_city` VALUES (489, 50, '宣州区', 3);
INSERT INTO `t_city` VALUES (490, 50, '宁国市', 3);
INSERT INTO `t_city` VALUES (491, 50, '郎溪县', 3);
INSERT INTO `t_city` VALUES (492, 50, '广德县', 3);
INSERT INTO `t_city` VALUES (493, 50, '泾县', 3);
INSERT INTO `t_city` VALUES (494, 50, '绩溪县', 3);
INSERT INTO `t_city` VALUES (495, 50, '旌德县', 3);
INSERT INTO `t_city` VALUES (496, 51, '涡阳县', 3);
INSERT INTO `t_city` VALUES (497, 51, '蒙城县', 3);
INSERT INTO `t_city` VALUES (498, 51, '利辛县', 3);
INSERT INTO `t_city` VALUES (499, 51, '谯城区', 3);
INSERT INTO `t_city` VALUES (500, 52, '东城区', 3);
INSERT INTO `t_city` VALUES (501, 52, '西城区', 3);
INSERT INTO `t_city` VALUES (502, 52, '海淀区', 3);
INSERT INTO `t_city` VALUES (503, 52, '朝阳区', 3);
INSERT INTO `t_city` VALUES (504, 52, '崇文区', 3);
INSERT INTO `t_city` VALUES (505, 52, '宣武区', 3);
INSERT INTO `t_city` VALUES (506, 52, '丰台区', 3);
INSERT INTO `t_city` VALUES (507, 52, '石景山区', 3);
INSERT INTO `t_city` VALUES (508, 52, '房山区', 3);
INSERT INTO `t_city` VALUES (509, 52, '门头沟区', 3);
INSERT INTO `t_city` VALUES (510, 52, '通州区', 3);
INSERT INTO `t_city` VALUES (511, 52, '顺义区', 3);
INSERT INTO `t_city` VALUES (512, 52, '昌平区', 3);
INSERT INTO `t_city` VALUES (513, 52, '怀柔区', 3);
INSERT INTO `t_city` VALUES (514, 52, '平谷区', 3);
INSERT INTO `t_city` VALUES (515, 52, '大兴区', 3);
INSERT INTO `t_city` VALUES (516, 52, '密云县', 3);
INSERT INTO `t_city` VALUES (517, 52, '延庆县', 3);
INSERT INTO `t_city` VALUES (518, 53, '鼓楼区', 3);
INSERT INTO `t_city` VALUES (519, 53, '台江区', 3);
INSERT INTO `t_city` VALUES (520, 53, '仓山区', 3);
INSERT INTO `t_city` VALUES (521, 53, '马尾区', 3);
INSERT INTO `t_city` VALUES (522, 53, '晋安区', 3);
INSERT INTO `t_city` VALUES (523, 53, '福清市', 3);
INSERT INTO `t_city` VALUES (524, 53, '长乐市', 3);
INSERT INTO `t_city` VALUES (525, 53, '闽侯县', 3);
INSERT INTO `t_city` VALUES (526, 53, '连江县', 3);
INSERT INTO `t_city` VALUES (527, 53, '罗源县', 3);
INSERT INTO `t_city` VALUES (528, 53, '闽清县', 3);
INSERT INTO `t_city` VALUES (529, 53, '永泰县', 3);
INSERT INTO `t_city` VALUES (530, 53, '平潭县', 3);
INSERT INTO `t_city` VALUES (531, 54, '新罗区', 3);
INSERT INTO `t_city` VALUES (532, 54, '漳平市', 3);
INSERT INTO `t_city` VALUES (533, 54, '长汀县', 3);
INSERT INTO `t_city` VALUES (534, 54, '永定县', 3);
INSERT INTO `t_city` VALUES (535, 54, '上杭县', 3);
INSERT INTO `t_city` VALUES (536, 54, '武平县', 3);
INSERT INTO `t_city` VALUES (537, 54, '连城县', 3);
INSERT INTO `t_city` VALUES (538, 55, '延平区', 3);
INSERT INTO `t_city` VALUES (539, 55, '邵武市', 3);
INSERT INTO `t_city` VALUES (540, 55, '武夷山市', 3);
INSERT INTO `t_city` VALUES (541, 55, '建瓯市', 3);
INSERT INTO `t_city` VALUES (542, 55, '建阳市', 3);
INSERT INTO `t_city` VALUES (543, 55, '顺昌县', 3);
INSERT INTO `t_city` VALUES (544, 55, '浦城县', 3);
INSERT INTO `t_city` VALUES (545, 55, '光泽县', 3);
INSERT INTO `t_city` VALUES (546, 55, '松溪县', 3);
INSERT INTO `t_city` VALUES (547, 55, '政和县', 3);
INSERT INTO `t_city` VALUES (548, 56, '蕉城区', 3);
INSERT INTO `t_city` VALUES (549, 56, '福安市', 3);
INSERT INTO `t_city` VALUES (550, 56, '福鼎市', 3);
INSERT INTO `t_city` VALUES (551, 56, '霞浦县', 3);
INSERT INTO `t_city` VALUES (552, 56, '古田县', 3);
INSERT INTO `t_city` VALUES (553, 56, '屏南县', 3);
INSERT INTO `t_city` VALUES (554, 56, '寿宁县', 3);
INSERT INTO `t_city` VALUES (555, 56, '周宁县', 3);
INSERT INTO `t_city` VALUES (556, 56, '柘荣县', 3);
INSERT INTO `t_city` VALUES (557, 57, '城厢区', 3);
INSERT INTO `t_city` VALUES (558, 57, '涵江区', 3);
INSERT INTO `t_city` VALUES (559, 57, '荔城区', 3);
INSERT INTO `t_city` VALUES (560, 57, '秀屿区', 3);
INSERT INTO `t_city` VALUES (561, 57, '仙游县', 3);
INSERT INTO `t_city` VALUES (562, 58, '鲤城区', 3);
INSERT INTO `t_city` VALUES (563, 58, '丰泽区', 3);
INSERT INTO `t_city` VALUES (564, 58, '洛江区', 3);
INSERT INTO `t_city` VALUES (565, 58, '清濛开发区', 3);
INSERT INTO `t_city` VALUES (566, 58, '泉港区', 3);
INSERT INTO `t_city` VALUES (567, 58, '石狮市', 3);
INSERT INTO `t_city` VALUES (568, 58, '晋江市', 3);
INSERT INTO `t_city` VALUES (569, 58, '南安市', 3);
INSERT INTO `t_city` VALUES (570, 58, '惠安县', 3);
INSERT INTO `t_city` VALUES (571, 58, '安溪县', 3);
INSERT INTO `t_city` VALUES (572, 58, '永春县', 3);
INSERT INTO `t_city` VALUES (573, 58, '德化县', 3);
INSERT INTO `t_city` VALUES (574, 58, '金门县', 3);
INSERT INTO `t_city` VALUES (575, 59, '梅列区', 3);
INSERT INTO `t_city` VALUES (576, 59, '三元区', 3);
INSERT INTO `t_city` VALUES (577, 59, '永安市', 3);
INSERT INTO `t_city` VALUES (578, 59, '明溪县', 3);
INSERT INTO `t_city` VALUES (579, 59, '清流县', 3);
INSERT INTO `t_city` VALUES (580, 59, '宁化县', 3);
INSERT INTO `t_city` VALUES (581, 59, '大田县', 3);
INSERT INTO `t_city` VALUES (582, 59, '尤溪县', 3);
INSERT INTO `t_city` VALUES (583, 59, '沙县', 3);
INSERT INTO `t_city` VALUES (584, 59, '将乐县', 3);
INSERT INTO `t_city` VALUES (585, 59, '泰宁县', 3);
INSERT INTO `t_city` VALUES (586, 59, '建宁县', 3);
INSERT INTO `t_city` VALUES (587, 60, '思明区', 3);
INSERT INTO `t_city` VALUES (588, 60, '海沧区', 3);
INSERT INTO `t_city` VALUES (589, 60, '湖里区', 3);
INSERT INTO `t_city` VALUES (590, 60, '集美区', 3);
INSERT INTO `t_city` VALUES (591, 60, '同安区', 3);
INSERT INTO `t_city` VALUES (592, 60, '翔安区', 3);
INSERT INTO `t_city` VALUES (593, 61, '芗城区', 3);
INSERT INTO `t_city` VALUES (594, 61, '龙文区', 3);
INSERT INTO `t_city` VALUES (595, 61, '龙海市', 3);
INSERT INTO `t_city` VALUES (596, 61, '云霄县', 3);
INSERT INTO `t_city` VALUES (597, 61, '漳浦县', 3);
INSERT INTO `t_city` VALUES (598, 61, '诏安县', 3);
INSERT INTO `t_city` VALUES (599, 61, '长泰县', 3);
INSERT INTO `t_city` VALUES (600, 61, '东山县', 3);
INSERT INTO `t_city` VALUES (601, 61, '南靖县', 3);
INSERT INTO `t_city` VALUES (602, 61, '平和县', 3);
INSERT INTO `t_city` VALUES (603, 61, '华安县', 3);
INSERT INTO `t_city` VALUES (604, 62, '皋兰县', 3);
INSERT INTO `t_city` VALUES (605, 62, '城关区', 3);
INSERT INTO `t_city` VALUES (606, 62, '七里河区', 3);
INSERT INTO `t_city` VALUES (607, 62, '西固区', 3);
INSERT INTO `t_city` VALUES (608, 62, '安宁区', 3);
INSERT INTO `t_city` VALUES (609, 62, '红古区', 3);
INSERT INTO `t_city` VALUES (610, 62, '永登县', 3);
INSERT INTO `t_city` VALUES (611, 62, '榆中县', 3);
INSERT INTO `t_city` VALUES (612, 63, '白银区', 3);
INSERT INTO `t_city` VALUES (613, 63, '平川区', 3);
INSERT INTO `t_city` VALUES (614, 63, '会宁县', 3);
INSERT INTO `t_city` VALUES (615, 63, '景泰县', 3);
INSERT INTO `t_city` VALUES (616, 63, '靖远县', 3);
INSERT INTO `t_city` VALUES (617, 64, '临洮县', 3);
INSERT INTO `t_city` VALUES (618, 64, '陇西县', 3);
INSERT INTO `t_city` VALUES (619, 64, '通渭县', 3);
INSERT INTO `t_city` VALUES (620, 64, '渭源县', 3);
INSERT INTO `t_city` VALUES (621, 64, '漳县', 3);
INSERT INTO `t_city` VALUES (622, 64, '岷县', 3);
INSERT INTO `t_city` VALUES (623, 64, '安定区', 3);
INSERT INTO `t_city` VALUES (624, 64, '安定区', 3);
INSERT INTO `t_city` VALUES (625, 65, '合作市', 3);
INSERT INTO `t_city` VALUES (626, 65, '临潭县', 3);
INSERT INTO `t_city` VALUES (627, 65, '卓尼县', 3);
INSERT INTO `t_city` VALUES (628, 65, '舟曲县', 3);
INSERT INTO `t_city` VALUES (629, 65, '迭部县', 3);
INSERT INTO `t_city` VALUES (630, 65, '玛曲县', 3);
INSERT INTO `t_city` VALUES (631, 65, '碌曲县', 3);
INSERT INTO `t_city` VALUES (632, 65, '夏河县', 3);
INSERT INTO `t_city` VALUES (633, 66, '嘉峪关市', 3);
INSERT INTO `t_city` VALUES (634, 67, '金川区', 3);
INSERT INTO `t_city` VALUES (635, 67, '永昌县', 3);
INSERT INTO `t_city` VALUES (636, 68, '肃州区', 3);
INSERT INTO `t_city` VALUES (637, 68, '玉门市', 3);
INSERT INTO `t_city` VALUES (638, 68, '敦煌市', 3);
INSERT INTO `t_city` VALUES (639, 68, '金塔县', 3);
INSERT INTO `t_city` VALUES (640, 68, '瓜州县', 3);
INSERT INTO `t_city` VALUES (641, 68, '肃北', 3);
INSERT INTO `t_city` VALUES (642, 68, '阿克塞', 3);
INSERT INTO `t_city` VALUES (643, 69, '临夏市', 3);
INSERT INTO `t_city` VALUES (644, 69, '临夏县', 3);
INSERT INTO `t_city` VALUES (645, 69, '康乐县', 3);
INSERT INTO `t_city` VALUES (646, 69, '永靖县', 3);
INSERT INTO `t_city` VALUES (647, 69, '广河县', 3);
INSERT INTO `t_city` VALUES (648, 69, '和政县', 3);
INSERT INTO `t_city` VALUES (649, 69, '东乡族自治县', 3);
INSERT INTO `t_city` VALUES (650, 69, '积石山', 3);
INSERT INTO `t_city` VALUES (651, 70, '成县', 3);
INSERT INTO `t_city` VALUES (652, 70, '徽县', 3);
INSERT INTO `t_city` VALUES (653, 70, '康县', 3);
INSERT INTO `t_city` VALUES (654, 70, '礼县', 3);
INSERT INTO `t_city` VALUES (655, 70, '两当县', 3);
INSERT INTO `t_city` VALUES (656, 70, '文县', 3);
INSERT INTO `t_city` VALUES (657, 70, '西和县', 3);
INSERT INTO `t_city` VALUES (658, 70, '宕昌县', 3);
INSERT INTO `t_city` VALUES (659, 70, '武都区', 3);
INSERT INTO `t_city` VALUES (660, 71, '崇信县', 3);
INSERT INTO `t_city` VALUES (661, 71, '华亭县', 3);
INSERT INTO `t_city` VALUES (662, 71, '静宁县', 3);
INSERT INTO `t_city` VALUES (663, 71, '灵台县', 3);
INSERT INTO `t_city` VALUES (664, 71, '崆峒区', 3);
INSERT INTO `t_city` VALUES (665, 71, '庄浪县', 3);
INSERT INTO `t_city` VALUES (666, 71, '泾川县', 3);
INSERT INTO `t_city` VALUES (667, 72, '合水县', 3);
INSERT INTO `t_city` VALUES (668, 72, '华池县', 3);
INSERT INTO `t_city` VALUES (669, 72, '环县', 3);
INSERT INTO `t_city` VALUES (670, 72, '宁县', 3);
INSERT INTO `t_city` VALUES (671, 72, '庆城县', 3);
INSERT INTO `t_city` VALUES (672, 72, '西峰区', 3);
INSERT INTO `t_city` VALUES (673, 72, '镇原县', 3);
INSERT INTO `t_city` VALUES (674, 72, '正宁县', 3);
INSERT INTO `t_city` VALUES (675, 73, '甘谷县', 3);
INSERT INTO `t_city` VALUES (676, 73, '秦安县', 3);
INSERT INTO `t_city` VALUES (677, 73, '清水县', 3);
INSERT INTO `t_city` VALUES (678, 73, '秦州区', 3);
INSERT INTO `t_city` VALUES (679, 73, '麦积区', 3);
INSERT INTO `t_city` VALUES (680, 73, '武山县', 3);
INSERT INTO `t_city` VALUES (681, 73, '张家川', 3);
INSERT INTO `t_city` VALUES (682, 74, '古浪县', 3);
INSERT INTO `t_city` VALUES (683, 74, '民勤县', 3);
INSERT INTO `t_city` VALUES (684, 74, '天祝', 3);
INSERT INTO `t_city` VALUES (685, 74, '凉州区', 3);
INSERT INTO `t_city` VALUES (686, 75, '高台县', 3);
INSERT INTO `t_city` VALUES (687, 75, '临泽县', 3);
INSERT INTO `t_city` VALUES (688, 75, '民乐县', 3);
INSERT INTO `t_city` VALUES (689, 75, '山丹县', 3);
INSERT INTO `t_city` VALUES (690, 75, '肃南', 3);
INSERT INTO `t_city` VALUES (691, 75, '甘州区', 3);
INSERT INTO `t_city` VALUES (692, 76, '从化市', 3);
INSERT INTO `t_city` VALUES (693, 76, '天河区', 3);
INSERT INTO `t_city` VALUES (694, 76, '东山区', 3);
INSERT INTO `t_city` VALUES (695, 76, '白云区', 3);
INSERT INTO `t_city` VALUES (696, 76, '海珠区', 3);
INSERT INTO `t_city` VALUES (697, 76, '荔湾区', 3);
INSERT INTO `t_city` VALUES (698, 76, '越秀区', 3);
INSERT INTO `t_city` VALUES (699, 76, '黄埔区', 3);
INSERT INTO `t_city` VALUES (700, 76, '番禺区', 3);
INSERT INTO `t_city` VALUES (701, 76, '花都区', 3);
INSERT INTO `t_city` VALUES (702, 76, '增城区', 3);
INSERT INTO `t_city` VALUES (703, 76, '从化区', 3);
INSERT INTO `t_city` VALUES (704, 76, '市郊', 3);
INSERT INTO `t_city` VALUES (705, 77, '福田区', 3);
INSERT INTO `t_city` VALUES (706, 77, '罗湖区', 3);
INSERT INTO `t_city` VALUES (707, 77, '南山区', 3);
INSERT INTO `t_city` VALUES (708, 77, '宝安区', 3);
INSERT INTO `t_city` VALUES (709, 77, '龙岗区', 3);
INSERT INTO `t_city` VALUES (710, 77, '盐田区', 3);
INSERT INTO `t_city` VALUES (711, 78, '湘桥区', 3);
INSERT INTO `t_city` VALUES (712, 78, '潮安县', 3);
INSERT INTO `t_city` VALUES (713, 78, '饶平县', 3);
INSERT INTO `t_city` VALUES (714, 79, '南城区', 3);
INSERT INTO `t_city` VALUES (715, 79, '东城区', 3);
INSERT INTO `t_city` VALUES (716, 79, '万江区', 3);
INSERT INTO `t_city` VALUES (717, 79, '莞城区', 3);
INSERT INTO `t_city` VALUES (718, 79, '石龙镇', 3);
INSERT INTO `t_city` VALUES (719, 79, '虎门镇', 3);
INSERT INTO `t_city` VALUES (720, 79, '麻涌镇', 3);
INSERT INTO `t_city` VALUES (721, 79, '道滘镇', 3);
INSERT INTO `t_city` VALUES (722, 79, '石碣镇', 3);
INSERT INTO `t_city` VALUES (723, 79, '沙田镇', 3);
INSERT INTO `t_city` VALUES (724, 79, '望牛墩镇', 3);
INSERT INTO `t_city` VALUES (725, 79, '洪梅镇', 3);
INSERT INTO `t_city` VALUES (726, 79, '茶山镇', 3);
INSERT INTO `t_city` VALUES (727, 79, '寮步镇', 3);
INSERT INTO `t_city` VALUES (728, 79, '大岭山镇', 3);
INSERT INTO `t_city` VALUES (729, 79, '大朗镇', 3);
INSERT INTO `t_city` VALUES (730, 79, '黄江镇', 3);
INSERT INTO `t_city` VALUES (731, 79, '樟木头', 3);
INSERT INTO `t_city` VALUES (732, 79, '凤岗镇', 3);
INSERT INTO `t_city` VALUES (733, 79, '塘厦镇', 3);
INSERT INTO `t_city` VALUES (734, 79, '谢岗镇', 3);
INSERT INTO `t_city` VALUES (735, 79, '厚街镇', 3);
INSERT INTO `t_city` VALUES (736, 79, '清溪镇', 3);
INSERT INTO `t_city` VALUES (737, 79, '常平镇', 3);
INSERT INTO `t_city` VALUES (738, 79, '桥头镇', 3);
INSERT INTO `t_city` VALUES (739, 79, '横沥镇', 3);
INSERT INTO `t_city` VALUES (740, 79, '东坑镇', 3);
INSERT INTO `t_city` VALUES (741, 79, '企石镇', 3);
INSERT INTO `t_city` VALUES (742, 79, '石排镇', 3);
INSERT INTO `t_city` VALUES (743, 79, '长安镇', 3);
INSERT INTO `t_city` VALUES (744, 79, '中堂镇', 3);
INSERT INTO `t_city` VALUES (745, 79, '高埗镇', 3);
INSERT INTO `t_city` VALUES (746, 80, '禅城区', 3);
INSERT INTO `t_city` VALUES (747, 80, '南海区', 3);
INSERT INTO `t_city` VALUES (748, 80, '顺德区', 3);
INSERT INTO `t_city` VALUES (749, 80, '三水区', 3);
INSERT INTO `t_city` VALUES (750, 80, '高明区', 3);
INSERT INTO `t_city` VALUES (751, 81, '东源县', 3);
INSERT INTO `t_city` VALUES (752, 81, '和平县', 3);
INSERT INTO `t_city` VALUES (753, 81, '源城区', 3);
INSERT INTO `t_city` VALUES (754, 81, '连平县', 3);
INSERT INTO `t_city` VALUES (755, 81, '龙川县', 3);
INSERT INTO `t_city` VALUES (756, 81, '紫金县', 3);
INSERT INTO `t_city` VALUES (757, 82, '惠阳区', 3);
INSERT INTO `t_city` VALUES (758, 82, '惠城区', 3);
INSERT INTO `t_city` VALUES (759, 82, '大亚湾', 3);
INSERT INTO `t_city` VALUES (760, 82, '博罗县', 3);
INSERT INTO `t_city` VALUES (761, 82, '惠东县', 3);
INSERT INTO `t_city` VALUES (762, 82, '龙门县', 3);
INSERT INTO `t_city` VALUES (763, 83, '江海区', 3);
INSERT INTO `t_city` VALUES (764, 83, '蓬江区', 3);
INSERT INTO `t_city` VALUES (765, 83, '新会区', 3);
INSERT INTO `t_city` VALUES (766, 83, '台山市', 3);
INSERT INTO `t_city` VALUES (767, 83, '开平市', 3);
INSERT INTO `t_city` VALUES (768, 83, '鹤山市', 3);
INSERT INTO `t_city` VALUES (769, 83, '恩平市', 3);
INSERT INTO `t_city` VALUES (770, 84, '榕城区', 3);
INSERT INTO `t_city` VALUES (771, 84, '普宁市', 3);
INSERT INTO `t_city` VALUES (772, 84, '揭东县', 3);
INSERT INTO `t_city` VALUES (773, 84, '揭西县', 3);
INSERT INTO `t_city` VALUES (774, 84, '惠来县', 3);
INSERT INTO `t_city` VALUES (775, 85, '茂南区', 3);
INSERT INTO `t_city` VALUES (776, 85, '茂港区', 3);
INSERT INTO `t_city` VALUES (777, 85, '高州市', 3);
INSERT INTO `t_city` VALUES (778, 85, '化州市', 3);
INSERT INTO `t_city` VALUES (779, 85, '信宜市', 3);
INSERT INTO `t_city` VALUES (780, 85, '电白县', 3);
INSERT INTO `t_city` VALUES (781, 86, '梅县', 3);
INSERT INTO `t_city` VALUES (782, 86, '梅江区', 3);
INSERT INTO `t_city` VALUES (783, 86, '兴宁市', 3);
INSERT INTO `t_city` VALUES (784, 86, '大埔县', 3);
INSERT INTO `t_city` VALUES (785, 86, '丰顺县', 3);
INSERT INTO `t_city` VALUES (786, 86, '五华县', 3);
INSERT INTO `t_city` VALUES (787, 86, '平远县', 3);
INSERT INTO `t_city` VALUES (788, 86, '蕉岭县', 3);
INSERT INTO `t_city` VALUES (789, 87, '清城区', 3);
INSERT INTO `t_city` VALUES (790, 87, '英德市', 3);
INSERT INTO `t_city` VALUES (791, 87, '连州市', 3);
INSERT INTO `t_city` VALUES (792, 87, '佛冈县', 3);
INSERT INTO `t_city` VALUES (793, 87, '阳山县', 3);
INSERT INTO `t_city` VALUES (794, 87, '清新县', 3);
INSERT INTO `t_city` VALUES (795, 87, '连山', 3);
INSERT INTO `t_city` VALUES (796, 87, '连南', 3);
INSERT INTO `t_city` VALUES (797, 88, '南澳县', 3);
INSERT INTO `t_city` VALUES (798, 88, '潮阳区', 3);
INSERT INTO `t_city` VALUES (799, 88, '澄海区', 3);
INSERT INTO `t_city` VALUES (800, 88, '龙湖区', 3);
INSERT INTO `t_city` VALUES (801, 88, '金平区', 3);
INSERT INTO `t_city` VALUES (802, 88, '濠江区', 3);
INSERT INTO `t_city` VALUES (803, 88, '潮南区', 3);
INSERT INTO `t_city` VALUES (804, 89, '城区', 3);
INSERT INTO `t_city` VALUES (805, 89, '陆丰市', 3);
INSERT INTO `t_city` VALUES (806, 89, '海丰县', 3);
INSERT INTO `t_city` VALUES (807, 89, '陆河县', 3);
INSERT INTO `t_city` VALUES (808, 90, '曲江县', 3);
INSERT INTO `t_city` VALUES (809, 90, '浈江区', 3);
INSERT INTO `t_city` VALUES (810, 90, '武江区', 3);
INSERT INTO `t_city` VALUES (811, 90, '曲江区', 3);
INSERT INTO `t_city` VALUES (812, 90, '乐昌市', 3);
INSERT INTO `t_city` VALUES (813, 90, '南雄市', 3);
INSERT INTO `t_city` VALUES (814, 90, '始兴县', 3);
INSERT INTO `t_city` VALUES (815, 90, '仁化县', 3);
INSERT INTO `t_city` VALUES (816, 90, '翁源县', 3);
INSERT INTO `t_city` VALUES (817, 90, '新丰县', 3);
INSERT INTO `t_city` VALUES (818, 90, '乳源', 3);
INSERT INTO `t_city` VALUES (819, 91, '江城区', 3);
INSERT INTO `t_city` VALUES (820, 91, '阳春市', 3);
INSERT INTO `t_city` VALUES (821, 91, '阳西县', 3);
INSERT INTO `t_city` VALUES (822, 91, '阳东县', 3);
INSERT INTO `t_city` VALUES (823, 92, '云城区', 3);
INSERT INTO `t_city` VALUES (824, 92, '罗定市', 3);
INSERT INTO `t_city` VALUES (825, 92, '新兴县', 3);
INSERT INTO `t_city` VALUES (826, 92, '郁南县', 3);
INSERT INTO `t_city` VALUES (827, 92, '云安县', 3);
INSERT INTO `t_city` VALUES (828, 93, '赤坎区', 3);
INSERT INTO `t_city` VALUES (829, 93, '霞山区', 3);
INSERT INTO `t_city` VALUES (830, 93, '坡头区', 3);
INSERT INTO `t_city` VALUES (831, 93, '麻章区', 3);
INSERT INTO `t_city` VALUES (832, 93, '廉江市', 3);
INSERT INTO `t_city` VALUES (833, 93, '雷州市', 3);
INSERT INTO `t_city` VALUES (834, 93, '吴川市', 3);
INSERT INTO `t_city` VALUES (835, 93, '遂溪县', 3);
INSERT INTO `t_city` VALUES (836, 93, '徐闻县', 3);
INSERT INTO `t_city` VALUES (837, 94, '肇庆市', 3);
INSERT INTO `t_city` VALUES (838, 94, '高要市', 3);
INSERT INTO `t_city` VALUES (839, 94, '四会市', 3);
INSERT INTO `t_city` VALUES (840, 94, '广宁县', 3);
INSERT INTO `t_city` VALUES (841, 94, '怀集县', 3);
INSERT INTO `t_city` VALUES (842, 94, '封开县', 3);
INSERT INTO `t_city` VALUES (843, 94, '德庆县', 3);
INSERT INTO `t_city` VALUES (844, 95, '石岐街道', 3);
INSERT INTO `t_city` VALUES (845, 95, '东区街道', 3);
INSERT INTO `t_city` VALUES (846, 95, '西区街道', 3);
INSERT INTO `t_city` VALUES (847, 95, '环城街道', 3);
INSERT INTO `t_city` VALUES (848, 95, '中山港街道', 3);
INSERT INTO `t_city` VALUES (849, 95, '五桂山街道', 3);
INSERT INTO `t_city` VALUES (850, 96, '香洲区', 3);
INSERT INTO `t_city` VALUES (851, 96, '斗门区', 3);
INSERT INTO `t_city` VALUES (852, 96, '金湾区', 3);
INSERT INTO `t_city` VALUES (853, 97, '邕宁区', 3);
INSERT INTO `t_city` VALUES (854, 97, '青秀区', 3);
INSERT INTO `t_city` VALUES (855, 97, '兴宁区', 3);
INSERT INTO `t_city` VALUES (856, 97, '良庆区', 3);
INSERT INTO `t_city` VALUES (857, 97, '西乡塘区', 3);
INSERT INTO `t_city` VALUES (858, 97, '江南区', 3);
INSERT INTO `t_city` VALUES (859, 97, '武鸣县', 3);
INSERT INTO `t_city` VALUES (860, 97, '隆安县', 3);
INSERT INTO `t_city` VALUES (861, 97, '马山县', 3);
INSERT INTO `t_city` VALUES (862, 97, '上林县', 3);
INSERT INTO `t_city` VALUES (863, 97, '宾阳县', 3);
INSERT INTO `t_city` VALUES (864, 97, '横县', 3);
INSERT INTO `t_city` VALUES (865, 98, '秀峰区', 3);
INSERT INTO `t_city` VALUES (866, 98, '叠彩区', 3);
INSERT INTO `t_city` VALUES (867, 98, '象山区', 3);
INSERT INTO `t_city` VALUES (868, 98, '七星区', 3);
INSERT INTO `t_city` VALUES (869, 98, '雁山区', 3);
INSERT INTO `t_city` VALUES (870, 98, '阳朔县', 3);
INSERT INTO `t_city` VALUES (871, 98, '临桂县', 3);
INSERT INTO `t_city` VALUES (872, 98, '灵川县', 3);
INSERT INTO `t_city` VALUES (873, 98, '全州县', 3);
INSERT INTO `t_city` VALUES (874, 98, '平乐县', 3);
INSERT INTO `t_city` VALUES (875, 98, '兴安县', 3);
INSERT INTO `t_city` VALUES (876, 98, '灌阳县', 3);
INSERT INTO `t_city` VALUES (877, 98, '荔浦县', 3);
INSERT INTO `t_city` VALUES (878, 98, '资源县', 3);
INSERT INTO `t_city` VALUES (879, 98, '永福县', 3);
INSERT INTO `t_city` VALUES (880, 98, '龙胜', 3);
INSERT INTO `t_city` VALUES (881, 98, '恭城', 3);
INSERT INTO `t_city` VALUES (882, 99, '右江区', 3);
INSERT INTO `t_city` VALUES (883, 99, '凌云县', 3);
INSERT INTO `t_city` VALUES (884, 99, '平果县', 3);
INSERT INTO `t_city` VALUES (885, 99, '西林县', 3);
INSERT INTO `t_city` VALUES (886, 99, '乐业县', 3);
INSERT INTO `t_city` VALUES (887, 99, '德保县', 3);
INSERT INTO `t_city` VALUES (888, 99, '田林县', 3);
INSERT INTO `t_city` VALUES (889, 99, '田阳县', 3);
INSERT INTO `t_city` VALUES (890, 99, '靖西县', 3);
INSERT INTO `t_city` VALUES (891, 99, '田东县', 3);
INSERT INTO `t_city` VALUES (892, 99, '那坡县', 3);
INSERT INTO `t_city` VALUES (893, 99, '隆林', 3);
INSERT INTO `t_city` VALUES (894, 100, '海城区', 3);
INSERT INTO `t_city` VALUES (895, 100, '银海区', 3);
INSERT INTO `t_city` VALUES (896, 100, '铁山港区', 3);
INSERT INTO `t_city` VALUES (897, 100, '合浦县', 3);
INSERT INTO `t_city` VALUES (898, 101, '江州区', 3);
INSERT INTO `t_city` VALUES (899, 101, '凭祥市', 3);
INSERT INTO `t_city` VALUES (900, 101, '宁明县', 3);
INSERT INTO `t_city` VALUES (901, 101, '扶绥县', 3);
INSERT INTO `t_city` VALUES (902, 101, '龙州县', 3);
INSERT INTO `t_city` VALUES (903, 101, '大新县', 3);
INSERT INTO `t_city` VALUES (904, 101, '天等县', 3);
INSERT INTO `t_city` VALUES (905, 102, '港口区', 3);
INSERT INTO `t_city` VALUES (906, 102, '防城区', 3);
INSERT INTO `t_city` VALUES (907, 102, '东兴市', 3);
INSERT INTO `t_city` VALUES (908, 102, '上思县', 3);
INSERT INTO `t_city` VALUES (909, 103, '港北区', 3);
INSERT INTO `t_city` VALUES (910, 103, '港南区', 3);
INSERT INTO `t_city` VALUES (911, 103, '覃塘区', 3);
INSERT INTO `t_city` VALUES (912, 103, '桂平市', 3);
INSERT INTO `t_city` VALUES (913, 103, '平南县', 3);
INSERT INTO `t_city` VALUES (914, 104, '金城江区', 3);
INSERT INTO `t_city` VALUES (915, 104, '宜州市', 3);
INSERT INTO `t_city` VALUES (916, 104, '天峨县', 3);
INSERT INTO `t_city` VALUES (917, 104, '凤山县', 3);
INSERT INTO `t_city` VALUES (918, 104, '南丹县', 3);
INSERT INTO `t_city` VALUES (919, 104, '东兰县', 3);
INSERT INTO `t_city` VALUES (920, 104, '都安', 3);
INSERT INTO `t_city` VALUES (921, 104, '罗城', 3);
INSERT INTO `t_city` VALUES (922, 104, '巴马', 3);
INSERT INTO `t_city` VALUES (923, 104, '环江', 3);
INSERT INTO `t_city` VALUES (924, 104, '大化', 3);
INSERT INTO `t_city` VALUES (925, 105, '八步区', 3);
INSERT INTO `t_city` VALUES (926, 105, '钟山县', 3);
INSERT INTO `t_city` VALUES (927, 105, '昭平县', 3);
INSERT INTO `t_city` VALUES (928, 105, '富川', 3);
INSERT INTO `t_city` VALUES (929, 106, '兴宾区', 3);
INSERT INTO `t_city` VALUES (930, 106, '合山市', 3);
INSERT INTO `t_city` VALUES (931, 106, '象州县', 3);
INSERT INTO `t_city` VALUES (932, 106, '武宣县', 3);
INSERT INTO `t_city` VALUES (933, 106, '忻城县', 3);
INSERT INTO `t_city` VALUES (934, 106, '金秀', 3);
INSERT INTO `t_city` VALUES (935, 107, '城中区', 3);
INSERT INTO `t_city` VALUES (936, 107, '鱼峰区', 3);
INSERT INTO `t_city` VALUES (937, 107, '柳北区', 3);
INSERT INTO `t_city` VALUES (938, 107, '柳南区', 3);
INSERT INTO `t_city` VALUES (939, 107, '柳江县', 3);
INSERT INTO `t_city` VALUES (940, 107, '柳城县', 3);
INSERT INTO `t_city` VALUES (941, 107, '鹿寨县', 3);
INSERT INTO `t_city` VALUES (942, 107, '融安县', 3);
INSERT INTO `t_city` VALUES (943, 107, '融水', 3);
INSERT INTO `t_city` VALUES (944, 107, '三江', 3);
INSERT INTO `t_city` VALUES (945, 108, '钦南区', 3);
INSERT INTO `t_city` VALUES (946, 108, '钦北区', 3);
INSERT INTO `t_city` VALUES (947, 108, '灵山县', 3);
INSERT INTO `t_city` VALUES (948, 108, '浦北县', 3);
INSERT INTO `t_city` VALUES (949, 109, '万秀区', 3);
INSERT INTO `t_city` VALUES (950, 109, '蝶山区', 3);
INSERT INTO `t_city` VALUES (951, 109, '长洲区', 3);
INSERT INTO `t_city` VALUES (952, 109, '岑溪市', 3);
INSERT INTO `t_city` VALUES (953, 109, '苍梧县', 3);
INSERT INTO `t_city` VALUES (954, 109, '藤县', 3);
INSERT INTO `t_city` VALUES (955, 109, '蒙山县', 3);
INSERT INTO `t_city` VALUES (956, 110, '玉州区', 3);
INSERT INTO `t_city` VALUES (957, 110, '北流市', 3);
INSERT INTO `t_city` VALUES (958, 110, '容县', 3);
INSERT INTO `t_city` VALUES (959, 110, '陆川县', 3);
INSERT INTO `t_city` VALUES (960, 110, '博白县', 3);
INSERT INTO `t_city` VALUES (961, 110, '兴业县', 3);
INSERT INTO `t_city` VALUES (962, 111, '南明区', 3);
INSERT INTO `t_city` VALUES (963, 111, '云岩区', 3);
INSERT INTO `t_city` VALUES (964, 111, '花溪区', 3);
INSERT INTO `t_city` VALUES (965, 111, '乌当区', 3);
INSERT INTO `t_city` VALUES (966, 111, '白云区', 3);
INSERT INTO `t_city` VALUES (967, 111, '小河区', 3);
INSERT INTO `t_city` VALUES (968, 111, '金阳新区', 3);
INSERT INTO `t_city` VALUES (969, 111, '新天园区', 3);
INSERT INTO `t_city` VALUES (970, 111, '清镇市', 3);
INSERT INTO `t_city` VALUES (971, 111, '开阳县', 3);
INSERT INTO `t_city` VALUES (972, 111, '修文县', 3);
INSERT INTO `t_city` VALUES (973, 111, '息烽县', 3);
INSERT INTO `t_city` VALUES (974, 112, '西秀区', 3);
INSERT INTO `t_city` VALUES (975, 112, '关岭', 3);
INSERT INTO `t_city` VALUES (976, 112, '镇宁', 3);
INSERT INTO `t_city` VALUES (977, 112, '紫云', 3);
INSERT INTO `t_city` VALUES (978, 112, '平坝县', 3);
INSERT INTO `t_city` VALUES (979, 112, '普定县', 3);
INSERT INTO `t_city` VALUES (980, 113, '毕节市', 3);
INSERT INTO `t_city` VALUES (981, 113, '大方县', 3);
INSERT INTO `t_city` VALUES (982, 113, '黔西县', 3);
INSERT INTO `t_city` VALUES (983, 113, '金沙县', 3);
INSERT INTO `t_city` VALUES (984, 113, '织金县', 3);
INSERT INTO `t_city` VALUES (985, 113, '纳雍县', 3);
INSERT INTO `t_city` VALUES (986, 113, '赫章县', 3);
INSERT INTO `t_city` VALUES (987, 113, '威宁', 3);
INSERT INTO `t_city` VALUES (988, 114, '钟山区', 3);
INSERT INTO `t_city` VALUES (989, 114, '六枝特区', 3);
INSERT INTO `t_city` VALUES (990, 114, '水城县', 3);
INSERT INTO `t_city` VALUES (991, 114, '盘县', 3);
INSERT INTO `t_city` VALUES (992, 115, '凯里市', 3);
INSERT INTO `t_city` VALUES (993, 115, '黄平县', 3);
INSERT INTO `t_city` VALUES (994, 115, '施秉县', 3);
INSERT INTO `t_city` VALUES (995, 115, '三穗县', 3);
INSERT INTO `t_city` VALUES (996, 115, '镇远县', 3);
INSERT INTO `t_city` VALUES (997, 115, '岑巩县', 3);
INSERT INTO `t_city` VALUES (998, 115, '天柱县', 3);
INSERT INTO `t_city` VALUES (999, 115, '锦屏县', 3);
INSERT INTO `t_city` VALUES (1000, 115, '剑河县', 3);
INSERT INTO `t_city` VALUES (1001, 115, '台江县', 3);
INSERT INTO `t_city` VALUES (1002, 115, '黎平县', 3);
INSERT INTO `t_city` VALUES (1003, 115, '榕江县', 3);
INSERT INTO `t_city` VALUES (1004, 115, '从江县', 3);
INSERT INTO `t_city` VALUES (1005, 115, '雷山县', 3);
INSERT INTO `t_city` VALUES (1006, 115, '麻江县', 3);
INSERT INTO `t_city` VALUES (1007, 115, '丹寨县', 3);
INSERT INTO `t_city` VALUES (1008, 116, '都匀市', 3);
INSERT INTO `t_city` VALUES (1009, 116, '福泉市', 3);
INSERT INTO `t_city` VALUES (1010, 116, '荔波县', 3);
INSERT INTO `t_city` VALUES (1011, 116, '贵定县', 3);
INSERT INTO `t_city` VALUES (1012, 116, '瓮安县', 3);
INSERT INTO `t_city` VALUES (1013, 116, '独山县', 3);
INSERT INTO `t_city` VALUES (1014, 116, '平塘县', 3);
INSERT INTO `t_city` VALUES (1015, 116, '罗甸县', 3);
INSERT INTO `t_city` VALUES (1016, 116, '长顺县', 3);
INSERT INTO `t_city` VALUES (1017, 116, '龙里县', 3);
INSERT INTO `t_city` VALUES (1018, 116, '惠水县', 3);
INSERT INTO `t_city` VALUES (1019, 116, '三都', 3);
INSERT INTO `t_city` VALUES (1020, 117, '兴义市', 3);
INSERT INTO `t_city` VALUES (1021, 117, '兴仁县', 3);
INSERT INTO `t_city` VALUES (1022, 117, '普安县', 3);
INSERT INTO `t_city` VALUES (1023, 117, '晴隆县', 3);
INSERT INTO `t_city` VALUES (1024, 117, '贞丰县', 3);
INSERT INTO `t_city` VALUES (1025, 117, '望谟县', 3);
INSERT INTO `t_city` VALUES (1026, 117, '册亨县', 3);
INSERT INTO `t_city` VALUES (1027, 117, '安龙县', 3);
INSERT INTO `t_city` VALUES (1028, 118, '铜仁市', 3);
INSERT INTO `t_city` VALUES (1029, 118, '江口县', 3);
INSERT INTO `t_city` VALUES (1030, 118, '石阡县', 3);
INSERT INTO `t_city` VALUES (1031, 118, '思南县', 3);
INSERT INTO `t_city` VALUES (1032, 118, '德江县', 3);
INSERT INTO `t_city` VALUES (1033, 118, '玉屏', 3);
INSERT INTO `t_city` VALUES (1034, 118, '印江', 3);
INSERT INTO `t_city` VALUES (1035, 118, '沿河', 3);
INSERT INTO `t_city` VALUES (1036, 118, '松桃', 3);
INSERT INTO `t_city` VALUES (1037, 118, '万山特区', 3);
INSERT INTO `t_city` VALUES (1038, 119, '红花岗区', 3);
INSERT INTO `t_city` VALUES (1039, 119, '务川县', 3);
INSERT INTO `t_city` VALUES (1040, 119, '道真县', 3);
INSERT INTO `t_city` VALUES (1041, 119, '汇川区', 3);
INSERT INTO `t_city` VALUES (1042, 119, '赤水市', 3);
INSERT INTO `t_city` VALUES (1043, 119, '仁怀市', 3);
INSERT INTO `t_city` VALUES (1044, 119, '遵义县', 3);
INSERT INTO `t_city` VALUES (1045, 119, '桐梓县', 3);
INSERT INTO `t_city` VALUES (1046, 119, '绥阳县', 3);
INSERT INTO `t_city` VALUES (1047, 119, '正安县', 3);
INSERT INTO `t_city` VALUES (1048, 119, '凤冈县', 3);
INSERT INTO `t_city` VALUES (1049, 119, '湄潭县', 3);
INSERT INTO `t_city` VALUES (1050, 119, '余庆县', 3);
INSERT INTO `t_city` VALUES (1051, 119, '习水县', 3);
INSERT INTO `t_city` VALUES (1052, 119, '道真', 3);
INSERT INTO `t_city` VALUES (1053, 119, '务川', 3);
INSERT INTO `t_city` VALUES (1054, 120, '秀英区', 3);
INSERT INTO `t_city` VALUES (1055, 120, '龙华区', 3);
INSERT INTO `t_city` VALUES (1056, 120, '琼山区', 3);
INSERT INTO `t_city` VALUES (1057, 120, '美兰区', 3);
INSERT INTO `t_city` VALUES (1058, 137, '市区', 3);
INSERT INTO `t_city` VALUES (1059, 137, '洋浦开发区', 3);
INSERT INTO `t_city` VALUES (1060, 137, '那大镇', 3);
INSERT INTO `t_city` VALUES (1061, 137, '王五镇', 3);
INSERT INTO `t_city` VALUES (1062, 137, '雅星镇', 3);
INSERT INTO `t_city` VALUES (1063, 137, '大成镇', 3);
INSERT INTO `t_city` VALUES (1064, 137, '中和镇', 3);
INSERT INTO `t_city` VALUES (1065, 137, '峨蔓镇', 3);
INSERT INTO `t_city` VALUES (1066, 137, '南丰镇', 3);
INSERT INTO `t_city` VALUES (1067, 137, '白马井镇', 3);
INSERT INTO `t_city` VALUES (1068, 137, '兰洋镇', 3);
INSERT INTO `t_city` VALUES (1069, 137, '和庆镇', 3);
INSERT INTO `t_city` VALUES (1070, 137, '海头镇', 3);
INSERT INTO `t_city` VALUES (1071, 137, '排浦镇', 3);
INSERT INTO `t_city` VALUES (1072, 137, '东成镇', 3);
INSERT INTO `t_city` VALUES (1073, 137, '光村镇', 3);
INSERT INTO `t_city` VALUES (1074, 137, '木棠镇', 3);
INSERT INTO `t_city` VALUES (1075, 137, '新州镇', 3);
INSERT INTO `t_city` VALUES (1076, 137, '三都镇', 3);
INSERT INTO `t_city` VALUES (1077, 137, '其他', 3);
INSERT INTO `t_city` VALUES (1078, 138, '长安区', 3);
INSERT INTO `t_city` VALUES (1079, 138, '桥东区', 3);
INSERT INTO `t_city` VALUES (1080, 138, '桥西区', 3);
INSERT INTO `t_city` VALUES (1081, 138, '新华区', 3);
INSERT INTO `t_city` VALUES (1082, 138, '裕华区', 3);
INSERT INTO `t_city` VALUES (1083, 138, '井陉矿区', 3);
INSERT INTO `t_city` VALUES (1084, 138, '高新区', 3);
INSERT INTO `t_city` VALUES (1085, 138, '辛集市', 3);
INSERT INTO `t_city` VALUES (1086, 138, '藁城市', 3);
INSERT INTO `t_city` VALUES (1087, 138, '晋州市', 3);
INSERT INTO `t_city` VALUES (1088, 138, '新乐市', 3);
INSERT INTO `t_city` VALUES (1089, 138, '鹿泉市', 3);
INSERT INTO `t_city` VALUES (1090, 138, '井陉县', 3);
INSERT INTO `t_city` VALUES (1091, 138, '正定县', 3);
INSERT INTO `t_city` VALUES (1092, 138, '栾城县', 3);
INSERT INTO `t_city` VALUES (1093, 138, '行唐县', 3);
INSERT INTO `t_city` VALUES (1094, 138, '灵寿县', 3);
INSERT INTO `t_city` VALUES (1095, 138, '高邑县', 3);
INSERT INTO `t_city` VALUES (1096, 138, '深泽县', 3);
INSERT INTO `t_city` VALUES (1097, 138, '赞皇县', 3);
INSERT INTO `t_city` VALUES (1098, 138, '无极县', 3);
INSERT INTO `t_city` VALUES (1099, 138, '平山县', 3);
INSERT INTO `t_city` VALUES (1100, 138, '元氏县', 3);
INSERT INTO `t_city` VALUES (1101, 138, '赵县', 3);
INSERT INTO `t_city` VALUES (1102, 139, '新市区', 3);
INSERT INTO `t_city` VALUES (1103, 139, '南市区', 3);
INSERT INTO `t_city` VALUES (1104, 139, '北市区', 3);
INSERT INTO `t_city` VALUES (1105, 139, '涿州市', 3);
INSERT INTO `t_city` VALUES (1106, 139, '定州市', 3);
INSERT INTO `t_city` VALUES (1107, 139, '安国市', 3);
INSERT INTO `t_city` VALUES (1108, 139, '高碑店市', 3);
INSERT INTO `t_city` VALUES (1109, 139, '满城县', 3);
INSERT INTO `t_city` VALUES (1110, 139, '清苑县', 3);
INSERT INTO `t_city` VALUES (1111, 139, '涞水县', 3);
INSERT INTO `t_city` VALUES (1112, 139, '阜平县', 3);
INSERT INTO `t_city` VALUES (1113, 139, '徐水县', 3);
INSERT INTO `t_city` VALUES (1114, 139, '定兴县', 3);
INSERT INTO `t_city` VALUES (1115, 139, '唐县', 3);
INSERT INTO `t_city` VALUES (1116, 139, '高阳县', 3);
INSERT INTO `t_city` VALUES (1117, 139, '容城县', 3);
INSERT INTO `t_city` VALUES (1118, 139, '涞源县', 3);
INSERT INTO `t_city` VALUES (1119, 139, '望都县', 3);
INSERT INTO `t_city` VALUES (1120, 139, '安新县', 3);
INSERT INTO `t_city` VALUES (1121, 139, '易县', 3);
INSERT INTO `t_city` VALUES (1122, 139, '曲阳县', 3);
INSERT INTO `t_city` VALUES (1123, 139, '蠡县', 3);
INSERT INTO `t_city` VALUES (1124, 139, '顺平县', 3);
INSERT INTO `t_city` VALUES (1125, 139, '博野县', 3);
INSERT INTO `t_city` VALUES (1126, 139, '雄县', 3);
INSERT INTO `t_city` VALUES (1127, 140, '运河区', 3);
INSERT INTO `t_city` VALUES (1128, 140, '新华区', 3);
INSERT INTO `t_city` VALUES (1129, 140, '泊头市', 3);
INSERT INTO `t_city` VALUES (1130, 140, '任丘市', 3);
INSERT INTO `t_city` VALUES (1131, 140, '黄骅市', 3);
INSERT INTO `t_city` VALUES (1132, 140, '河间市', 3);
INSERT INTO `t_city` VALUES (1133, 140, '沧县', 3);
INSERT INTO `t_city` VALUES (1134, 140, '青县', 3);
INSERT INTO `t_city` VALUES (1135, 140, '东光县', 3);
INSERT INTO `t_city` VALUES (1136, 140, '海兴县', 3);
INSERT INTO `t_city` VALUES (1137, 140, '盐山县', 3);
INSERT INTO `t_city` VALUES (1138, 140, '肃宁县', 3);
INSERT INTO `t_city` VALUES (1139, 140, '南皮县', 3);
INSERT INTO `t_city` VALUES (1140, 140, '吴桥县', 3);
INSERT INTO `t_city` VALUES (1141, 140, '献县', 3);
INSERT INTO `t_city` VALUES (1142, 140, '孟村', 3);
INSERT INTO `t_city` VALUES (1143, 141, '双桥区', 3);
INSERT INTO `t_city` VALUES (1144, 141, '双滦区', 3);
INSERT INTO `t_city` VALUES (1145, 141, '鹰手营子矿区', 3);
INSERT INTO `t_city` VALUES (1146, 141, '承德县', 3);
INSERT INTO `t_city` VALUES (1147, 141, '兴隆县', 3);
INSERT INTO `t_city` VALUES (1148, 141, '平泉县', 3);
INSERT INTO `t_city` VALUES (1149, 141, '滦平县', 3);
INSERT INTO `t_city` VALUES (1150, 141, '隆化县', 3);
INSERT INTO `t_city` VALUES (1151, 141, '丰宁', 3);
INSERT INTO `t_city` VALUES (1152, 141, '宽城', 3);
INSERT INTO `t_city` VALUES (1153, 141, '围场', 3);
INSERT INTO `t_city` VALUES (1154, 142, '从台区', 3);
INSERT INTO `t_city` VALUES (1155, 142, '复兴区', 3);
INSERT INTO `t_city` VALUES (1156, 142, '邯山区', 3);
INSERT INTO `t_city` VALUES (1157, 142, '峰峰矿区', 3);
INSERT INTO `t_city` VALUES (1158, 142, '武安市', 3);
INSERT INTO `t_city` VALUES (1159, 142, '邯郸县', 3);
INSERT INTO `t_city` VALUES (1160, 142, '临漳县', 3);
INSERT INTO `t_city` VALUES (1161, 142, '成安县', 3);
INSERT INTO `t_city` VALUES (1162, 142, '大名县', 3);
INSERT INTO `t_city` VALUES (1163, 142, '涉县', 3);
INSERT INTO `t_city` VALUES (1164, 142, '磁县', 3);
INSERT INTO `t_city` VALUES (1165, 142, '肥乡县', 3);
INSERT INTO `t_city` VALUES (1166, 142, '永年县', 3);
INSERT INTO `t_city` VALUES (1167, 142, '邱县', 3);
INSERT INTO `t_city` VALUES (1168, 142, '鸡泽县', 3);
INSERT INTO `t_city` VALUES (1169, 142, '广平县', 3);
INSERT INTO `t_city` VALUES (1170, 142, '馆陶县', 3);
INSERT INTO `t_city` VALUES (1171, 142, '魏县', 3);
INSERT INTO `t_city` VALUES (1172, 142, '曲周县', 3);
INSERT INTO `t_city` VALUES (1173, 143, '桃城区', 3);
INSERT INTO `t_city` VALUES (1174, 143, '冀州市', 3);
INSERT INTO `t_city` VALUES (1175, 143, '深州市', 3);
INSERT INTO `t_city` VALUES (1176, 143, '枣强县', 3);
INSERT INTO `t_city` VALUES (1177, 143, '武邑县', 3);
INSERT INTO `t_city` VALUES (1178, 143, '武强县', 3);
INSERT INTO `t_city` VALUES (1179, 143, '饶阳县', 3);
INSERT INTO `t_city` VALUES (1180, 143, '安平县', 3);
INSERT INTO `t_city` VALUES (1181, 143, '故城县', 3);
INSERT INTO `t_city` VALUES (1182, 143, '景县', 3);
INSERT INTO `t_city` VALUES (1183, 143, '阜城县', 3);
INSERT INTO `t_city` VALUES (1184, 144, '安次区', 3);
INSERT INTO `t_city` VALUES (1185, 144, '广阳区', 3);
INSERT INTO `t_city` VALUES (1186, 144, '霸州市', 3);
INSERT INTO `t_city` VALUES (1187, 144, '三河市', 3);
INSERT INTO `t_city` VALUES (1188, 144, '固安县', 3);
INSERT INTO `t_city` VALUES (1189, 144, '永清县', 3);
INSERT INTO `t_city` VALUES (1190, 144, '香河县', 3);
INSERT INTO `t_city` VALUES (1191, 144, '大城县', 3);
INSERT INTO `t_city` VALUES (1192, 144, '文安县', 3);
INSERT INTO `t_city` VALUES (1193, 144, '大厂', 3);
INSERT INTO `t_city` VALUES (1194, 145, '海港区', 3);
INSERT INTO `t_city` VALUES (1195, 145, '山海关区', 3);
INSERT INTO `t_city` VALUES (1196, 145, '北戴河区', 3);
INSERT INTO `t_city` VALUES (1197, 145, '昌黎县', 3);
INSERT INTO `t_city` VALUES (1198, 145, '抚宁县', 3);
INSERT INTO `t_city` VALUES (1199, 145, '卢龙县', 3);
INSERT INTO `t_city` VALUES (1200, 145, '青龙', 3);
INSERT INTO `t_city` VALUES (1201, 146, '路北区', 3);
INSERT INTO `t_city` VALUES (1202, 146, '路南区', 3);
INSERT INTO `t_city` VALUES (1203, 146, '古冶区', 3);
INSERT INTO `t_city` VALUES (1204, 146, '开平区', 3);
INSERT INTO `t_city` VALUES (1205, 146, '丰南区', 3);
INSERT INTO `t_city` VALUES (1206, 146, '丰润区', 3);
INSERT INTO `t_city` VALUES (1207, 146, '遵化市', 3);
INSERT INTO `t_city` VALUES (1208, 146, '迁安市', 3);
INSERT INTO `t_city` VALUES (1209, 146, '滦县', 3);
INSERT INTO `t_city` VALUES (1210, 146, '滦南县', 3);
INSERT INTO `t_city` VALUES (1211, 146, '乐亭县', 3);
INSERT INTO `t_city` VALUES (1212, 146, '迁西县', 3);
INSERT INTO `t_city` VALUES (1213, 146, '玉田县', 3);
INSERT INTO `t_city` VALUES (1214, 146, '唐海县', 3);
INSERT INTO `t_city` VALUES (1215, 147, '桥东区', 3);
INSERT INTO `t_city` VALUES (1216, 147, '桥西区', 3);
INSERT INTO `t_city` VALUES (1217, 147, '南宫市', 3);
INSERT INTO `t_city` VALUES (1218, 147, '沙河市', 3);
INSERT INTO `t_city` VALUES (1219, 147, '邢台县', 3);
INSERT INTO `t_city` VALUES (1220, 147, '临城县', 3);
INSERT INTO `t_city` VALUES (1221, 147, '内丘县', 3);
INSERT INTO `t_city` VALUES (1222, 147, '柏乡县', 3);
INSERT INTO `t_city` VALUES (1223, 147, '隆尧县', 3);
INSERT INTO `t_city` VALUES (1224, 147, '任县', 3);
INSERT INTO `t_city` VALUES (1225, 147, '南和县', 3);
INSERT INTO `t_city` VALUES (1226, 147, '宁晋县', 3);
INSERT INTO `t_city` VALUES (1227, 147, '巨鹿县', 3);
INSERT INTO `t_city` VALUES (1228, 147, '新河县', 3);
INSERT INTO `t_city` VALUES (1229, 147, '广宗县', 3);
INSERT INTO `t_city` VALUES (1230, 147, '平乡县', 3);
INSERT INTO `t_city` VALUES (1231, 147, '威县', 3);
INSERT INTO `t_city` VALUES (1232, 147, '清河县', 3);
INSERT INTO `t_city` VALUES (1233, 147, '临西县', 3);
INSERT INTO `t_city` VALUES (1234, 148, '桥西区', 3);
INSERT INTO `t_city` VALUES (1235, 148, '桥东区', 3);
INSERT INTO `t_city` VALUES (1236, 148, '宣化区', 3);
INSERT INTO `t_city` VALUES (1237, 148, '下花园区', 3);
INSERT INTO `t_city` VALUES (1238, 148, '宣化县', 3);
INSERT INTO `t_city` VALUES (1239, 148, '张北县', 3);
INSERT INTO `t_city` VALUES (1240, 148, '康保县', 3);
INSERT INTO `t_city` VALUES (1241, 148, '沽源县', 3);
INSERT INTO `t_city` VALUES (1242, 148, '尚义县', 3);
INSERT INTO `t_city` VALUES (1243, 148, '蔚县', 3);
INSERT INTO `t_city` VALUES (1244, 148, '阳原县', 3);
INSERT INTO `t_city` VALUES (1245, 148, '怀安县', 3);
INSERT INTO `t_city` VALUES (1246, 148, '万全县', 3);
INSERT INTO `t_city` VALUES (1247, 148, '怀来县', 3);
INSERT INTO `t_city` VALUES (1248, 148, '涿鹿县', 3);
INSERT INTO `t_city` VALUES (1249, 148, '赤城县', 3);
INSERT INTO `t_city` VALUES (1250, 148, '崇礼县', 3);
INSERT INTO `t_city` VALUES (1251, 149, '金水区', 3);
INSERT INTO `t_city` VALUES (1252, 149, '邙山区', 3);
INSERT INTO `t_city` VALUES (1253, 149, '二七区', 3);
INSERT INTO `t_city` VALUES (1254, 149, '管城区', 3);
INSERT INTO `t_city` VALUES (1255, 149, '中原区', 3);
INSERT INTO `t_city` VALUES (1256, 149, '上街区', 3);
INSERT INTO `t_city` VALUES (1257, 149, '惠济区', 3);
INSERT INTO `t_city` VALUES (1258, 149, '郑东新区', 3);
INSERT INTO `t_city` VALUES (1259, 149, '经济技术开发区', 3);
INSERT INTO `t_city` VALUES (1260, 149, '高新开发区', 3);
INSERT INTO `t_city` VALUES (1261, 149, '出口加工区', 3);
INSERT INTO `t_city` VALUES (1262, 149, '巩义市', 3);
INSERT INTO `t_city` VALUES (1263, 149, '荥阳市', 3);
INSERT INTO `t_city` VALUES (1264, 149, '新密市', 3);
INSERT INTO `t_city` VALUES (1265, 149, '新郑市', 3);
INSERT INTO `t_city` VALUES (1266, 149, '登封市', 3);
INSERT INTO `t_city` VALUES (1267, 149, '中牟县', 3);
INSERT INTO `t_city` VALUES (1268, 150, '西工区', 3);
INSERT INTO `t_city` VALUES (1269, 150, '老城区', 3);
INSERT INTO `t_city` VALUES (1270, 150, '涧西区', 3);
INSERT INTO `t_city` VALUES (1271, 150, '瀍河回族区', 3);
INSERT INTO `t_city` VALUES (1272, 150, '洛龙区', 3);
INSERT INTO `t_city` VALUES (1273, 150, '吉利区', 3);
INSERT INTO `t_city` VALUES (1274, 150, '偃师市', 3);
INSERT INTO `t_city` VALUES (1275, 150, '孟津县', 3);
INSERT INTO `t_city` VALUES (1276, 150, '新安县', 3);
INSERT INTO `t_city` VALUES (1277, 150, '栾川县', 3);
INSERT INTO `t_city` VALUES (1278, 150, '嵩县', 3);
INSERT INTO `t_city` VALUES (1279, 150, '汝阳县', 3);
INSERT INTO `t_city` VALUES (1280, 150, '宜阳县', 3);
INSERT INTO `t_city` VALUES (1281, 150, '洛宁县', 3);
INSERT INTO `t_city` VALUES (1282, 150, '伊川县', 3);
INSERT INTO `t_city` VALUES (1283, 151, '鼓楼区', 3);
INSERT INTO `t_city` VALUES (1284, 151, '龙亭区', 3);
INSERT INTO `t_city` VALUES (1285, 151, '顺河回族区', 3);
INSERT INTO `t_city` VALUES (1286, 151, '金明区', 3);
INSERT INTO `t_city` VALUES (1287, 151, '禹王台区', 3);
INSERT INTO `t_city` VALUES (1288, 151, '杞县', 3);
INSERT INTO `t_city` VALUES (1289, 151, '通许县', 3);
INSERT INTO `t_city` VALUES (1290, 151, '尉氏县', 3);
INSERT INTO `t_city` VALUES (1291, 151, '开封县', 3);
INSERT INTO `t_city` VALUES (1292, 151, '兰考县', 3);
INSERT INTO `t_city` VALUES (1293, 152, '北关区', 3);
INSERT INTO `t_city` VALUES (1294, 152, '文峰区', 3);
INSERT INTO `t_city` VALUES (1295, 152, '殷都区', 3);
INSERT INTO `t_city` VALUES (1296, 152, '龙安区', 3);
INSERT INTO `t_city` VALUES (1297, 152, '林州市', 3);
INSERT INTO `t_city` VALUES (1298, 152, '安阳县', 3);
INSERT INTO `t_city` VALUES (1299, 152, '汤阴县', 3);
INSERT INTO `t_city` VALUES (1300, 152, '滑县', 3);
INSERT INTO `t_city` VALUES (1301, 152, '内黄县', 3);
INSERT INTO `t_city` VALUES (1302, 153, '淇滨区', 3);
INSERT INTO `t_city` VALUES (1303, 153, '山城区', 3);
INSERT INTO `t_city` VALUES (1304, 153, '鹤山区', 3);
INSERT INTO `t_city` VALUES (1305, 153, '浚县', 3);
INSERT INTO `t_city` VALUES (1306, 153, '淇县', 3);
INSERT INTO `t_city` VALUES (1307, 154, '济源市', 3);
INSERT INTO `t_city` VALUES (1308, 155, '解放区', 3);
INSERT INTO `t_city` VALUES (1309, 155, '中站区', 3);
INSERT INTO `t_city` VALUES (1310, 155, '马村区', 3);
INSERT INTO `t_city` VALUES (1311, 155, '山阳区', 3);
INSERT INTO `t_city` VALUES (1312, 155, '沁阳市', 3);
INSERT INTO `t_city` VALUES (1313, 155, '孟州市', 3);
INSERT INTO `t_city` VALUES (1314, 155, '修武县', 3);
INSERT INTO `t_city` VALUES (1315, 155, '博爱县', 3);
INSERT INTO `t_city` VALUES (1316, 155, '武陟县', 3);
INSERT INTO `t_city` VALUES (1317, 155, '温县', 3);
INSERT INTO `t_city` VALUES (1318, 156, '卧龙区', 3);
INSERT INTO `t_city` VALUES (1319, 156, '宛城区', 3);
INSERT INTO `t_city` VALUES (1320, 156, '邓州市', 3);
INSERT INTO `t_city` VALUES (1321, 156, '南召县', 3);
INSERT INTO `t_city` VALUES (1322, 156, '方城县', 3);
INSERT INTO `t_city` VALUES (1323, 156, '西峡县', 3);
INSERT INTO `t_city` VALUES (1324, 156, '镇平县', 3);
INSERT INTO `t_city` VALUES (1325, 156, '内乡县', 3);
INSERT INTO `t_city` VALUES (1326, 156, '淅川县', 3);
INSERT INTO `t_city` VALUES (1327, 156, '社旗县', 3);
INSERT INTO `t_city` VALUES (1328, 156, '唐河县', 3);
INSERT INTO `t_city` VALUES (1329, 156, '新野县', 3);
INSERT INTO `t_city` VALUES (1330, 156, '桐柏县', 3);
INSERT INTO `t_city` VALUES (1331, 157, '新华区', 3);
INSERT INTO `t_city` VALUES (1332, 157, '卫东区', 3);
INSERT INTO `t_city` VALUES (1333, 157, '湛河区', 3);
INSERT INTO `t_city` VALUES (1334, 157, '石龙区', 3);
INSERT INTO `t_city` VALUES (1335, 157, '舞钢市', 3);
INSERT INTO `t_city` VALUES (1336, 157, '汝州市', 3);
INSERT INTO `t_city` VALUES (1337, 157, '宝丰县', 3);
INSERT INTO `t_city` VALUES (1338, 157, '叶县', 3);
INSERT INTO `t_city` VALUES (1339, 157, '鲁山县', 3);
INSERT INTO `t_city` VALUES (1340, 157, '郏县', 3);
INSERT INTO `t_city` VALUES (1341, 158, '湖滨区', 3);
INSERT INTO `t_city` VALUES (1342, 158, '义马市', 3);
INSERT INTO `t_city` VALUES (1343, 158, '灵宝市', 3);
INSERT INTO `t_city` VALUES (1344, 158, '渑池县', 3);
INSERT INTO `t_city` VALUES (1345, 158, '陕县', 3);
INSERT INTO `t_city` VALUES (1346, 158, '卢氏县', 3);
INSERT INTO `t_city` VALUES (1347, 159, '梁园区', 3);
INSERT INTO `t_city` VALUES (1348, 159, '睢阳区', 3);
INSERT INTO `t_city` VALUES (1349, 159, '永城市', 3);
INSERT INTO `t_city` VALUES (1350, 159, '民权县', 3);
INSERT INTO `t_city` VALUES (1351, 159, '睢县', 3);
INSERT INTO `t_city` VALUES (1352, 159, '宁陵县', 3);
INSERT INTO `t_city` VALUES (1353, 159, '虞城县', 3);
INSERT INTO `t_city` VALUES (1354, 159, '柘城县', 3);
INSERT INTO `t_city` VALUES (1355, 159, '夏邑县', 3);
INSERT INTO `t_city` VALUES (1356, 160, '卫滨区', 3);
INSERT INTO `t_city` VALUES (1357, 160, '红旗区', 3);
INSERT INTO `t_city` VALUES (1358, 160, '凤泉区', 3);
INSERT INTO `t_city` VALUES (1359, 160, '牧野区', 3);
INSERT INTO `t_city` VALUES (1360, 160, '卫辉市', 3);
INSERT INTO `t_city` VALUES (1361, 160, '辉县市', 3);
INSERT INTO `t_city` VALUES (1362, 160, '新乡县', 3);
INSERT INTO `t_city` VALUES (1363, 160, '获嘉县', 3);
INSERT INTO `t_city` VALUES (1364, 160, '原阳县', 3);
INSERT INTO `t_city` VALUES (1365, 160, '延津县', 3);
INSERT INTO `t_city` VALUES (1366, 160, '封丘县', 3);
INSERT INTO `t_city` VALUES (1367, 160, '长垣县', 3);
INSERT INTO `t_city` VALUES (1368, 161, '浉河区', 3);
INSERT INTO `t_city` VALUES (1369, 161, '平桥区', 3);
INSERT INTO `t_city` VALUES (1370, 161, '罗山县', 3);
INSERT INTO `t_city` VALUES (1371, 161, '光山县', 3);
INSERT INTO `t_city` VALUES (1372, 161, '新县', 3);
INSERT INTO `t_city` VALUES (1373, 161, '商城县', 3);
INSERT INTO `t_city` VALUES (1374, 161, '固始县', 3);
INSERT INTO `t_city` VALUES (1375, 161, '潢川县', 3);
INSERT INTO `t_city` VALUES (1376, 161, '淮滨县', 3);
INSERT INTO `t_city` VALUES (1377, 161, '息县', 3);
INSERT INTO `t_city` VALUES (1378, 162, '魏都区', 3);
INSERT INTO `t_city` VALUES (1379, 162, '禹州市', 3);
INSERT INTO `t_city` VALUES (1380, 162, '长葛市', 3);
INSERT INTO `t_city` VALUES (1381, 162, '许昌县', 3);
INSERT INTO `t_city` VALUES (1382, 162, '鄢陵县', 3);
INSERT INTO `t_city` VALUES (1383, 162, '襄城县', 3);
INSERT INTO `t_city` VALUES (1384, 163, '川汇区', 3);
INSERT INTO `t_city` VALUES (1385, 163, '项城市', 3);
INSERT INTO `t_city` VALUES (1386, 163, '扶沟县', 3);
INSERT INTO `t_city` VALUES (1387, 163, '西华县', 3);
INSERT INTO `t_city` VALUES (1388, 163, '商水县', 3);
INSERT INTO `t_city` VALUES (1389, 163, '沈丘县', 3);
INSERT INTO `t_city` VALUES (1390, 163, '郸城县', 3);
INSERT INTO `t_city` VALUES (1391, 163, '淮阳县', 3);
INSERT INTO `t_city` VALUES (1392, 163, '太康县', 3);
INSERT INTO `t_city` VALUES (1393, 163, '鹿邑县', 3);
INSERT INTO `t_city` VALUES (1394, 164, '驿城区', 3);
INSERT INTO `t_city` VALUES (1395, 164, '西平县', 3);
INSERT INTO `t_city` VALUES (1396, 164, '上蔡县', 3);
INSERT INTO `t_city` VALUES (1397, 164, '平舆县', 3);
INSERT INTO `t_city` VALUES (1398, 164, '正阳县', 3);
INSERT INTO `t_city` VALUES (1399, 164, '确山县', 3);
INSERT INTO `t_city` VALUES (1400, 164, '泌阳县', 3);
INSERT INTO `t_city` VALUES (1401, 164, '汝南县', 3);
INSERT INTO `t_city` VALUES (1402, 164, '遂平县', 3);
INSERT INTO `t_city` VALUES (1403, 164, '新蔡县', 3);
INSERT INTO `t_city` VALUES (1404, 165, '郾城区', 3);
INSERT INTO `t_city` VALUES (1405, 165, '源汇区', 3);
INSERT INTO `t_city` VALUES (1406, 165, '召陵区', 3);
INSERT INTO `t_city` VALUES (1407, 165, '舞阳县', 3);
INSERT INTO `t_city` VALUES (1408, 165, '临颍县', 3);
INSERT INTO `t_city` VALUES (1409, 166, '华龙区', 3);
INSERT INTO `t_city` VALUES (1410, 166, '清丰县', 3);
INSERT INTO `t_city` VALUES (1411, 166, '南乐县', 3);
INSERT INTO `t_city` VALUES (1412, 166, '范县', 3);
INSERT INTO `t_city` VALUES (1413, 166, '台前县', 3);
INSERT INTO `t_city` VALUES (1414, 166, '濮阳县', 3);
INSERT INTO `t_city` VALUES (1415, 167, '道里区', 3);
INSERT INTO `t_city` VALUES (1416, 167, '南岗区', 3);
INSERT INTO `t_city` VALUES (1417, 167, '动力区', 3);
INSERT INTO `t_city` VALUES (1418, 167, '平房区', 3);
INSERT INTO `t_city` VALUES (1419, 167, '香坊区', 3);
INSERT INTO `t_city` VALUES (1420, 167, '太平区', 3);
INSERT INTO `t_city` VALUES (1421, 167, '道外区', 3);
INSERT INTO `t_city` VALUES (1422, 167, '阿城区', 3);
INSERT INTO `t_city` VALUES (1423, 167, '呼兰区', 3);
INSERT INTO `t_city` VALUES (1424, 167, '松北区', 3);
INSERT INTO `t_city` VALUES (1425, 167, '尚志市', 3);
INSERT INTO `t_city` VALUES (1426, 167, '双城市', 3);
INSERT INTO `t_city` VALUES (1427, 167, '五常市', 3);
INSERT INTO `t_city` VALUES (1428, 167, '方正县', 3);
INSERT INTO `t_city` VALUES (1429, 167, '宾县', 3);
INSERT INTO `t_city` VALUES (1430, 167, '依兰县', 3);
INSERT INTO `t_city` VALUES (1431, 167, '巴彦县', 3);
INSERT INTO `t_city` VALUES (1432, 167, '通河县', 3);
INSERT INTO `t_city` VALUES (1433, 167, '木兰县', 3);
INSERT INTO `t_city` VALUES (1434, 167, '延寿县', 3);
INSERT INTO `t_city` VALUES (1435, 168, '萨尔图区', 3);
INSERT INTO `t_city` VALUES (1436, 168, '红岗区', 3);
INSERT INTO `t_city` VALUES (1437, 168, '龙凤区', 3);
INSERT INTO `t_city` VALUES (1438, 168, '让胡路区', 3);
INSERT INTO `t_city` VALUES (1439, 168, '大同区', 3);
INSERT INTO `t_city` VALUES (1440, 168, '肇州县', 3);
INSERT INTO `t_city` VALUES (1441, 168, '肇源县', 3);
INSERT INTO `t_city` VALUES (1442, 168, '林甸县', 3);
INSERT INTO `t_city` VALUES (1443, 168, '杜尔伯特', 3);
INSERT INTO `t_city` VALUES (1444, 169, '呼玛县', 3);
INSERT INTO `t_city` VALUES (1445, 169, '漠河县', 3);
INSERT INTO `t_city` VALUES (1446, 169, '塔河县', 3);
INSERT INTO `t_city` VALUES (1447, 170, '兴山区', 3);
INSERT INTO `t_city` VALUES (1448, 170, '工农区', 3);
INSERT INTO `t_city` VALUES (1449, 170, '南山区', 3);
INSERT INTO `t_city` VALUES (1450, 170, '兴安区', 3);
INSERT INTO `t_city` VALUES (1451, 170, '向阳区', 3);
INSERT INTO `t_city` VALUES (1452, 170, '东山区', 3);
INSERT INTO `t_city` VALUES (1453, 170, '萝北县', 3);
INSERT INTO `t_city` VALUES (1454, 170, '绥滨县', 3);
INSERT INTO `t_city` VALUES (1455, 171, '爱辉区', 3);
INSERT INTO `t_city` VALUES (1456, 171, '五大连池市', 3);
INSERT INTO `t_city` VALUES (1457, 171, '北安市', 3);
INSERT INTO `t_city` VALUES (1458, 171, '嫩江县', 3);
INSERT INTO `t_city` VALUES (1459, 171, '逊克县', 3);
INSERT INTO `t_city` VALUES (1460, 171, '孙吴县', 3);
INSERT INTO `t_city` VALUES (1461, 172, '鸡冠区', 3);
INSERT INTO `t_city` VALUES (1462, 172, '恒山区', 3);
INSERT INTO `t_city` VALUES (1463, 172, '城子河区', 3);
INSERT INTO `t_city` VALUES (1464, 172, '滴道区', 3);
INSERT INTO `t_city` VALUES (1465, 172, '梨树区', 3);
INSERT INTO `t_city` VALUES (1466, 172, '虎林市', 3);
INSERT INTO `t_city` VALUES (1467, 172, '密山市', 3);
INSERT INTO `t_city` VALUES (1468, 172, '鸡东县', 3);
INSERT INTO `t_city` VALUES (1469, 173, '前进区', 3);
INSERT INTO `t_city` VALUES (1470, 173, '郊区', 3);
INSERT INTO `t_city` VALUES (1471, 173, '向阳区', 3);
INSERT INTO `t_city` VALUES (1472, 173, '东风区', 3);
INSERT INTO `t_city` VALUES (1473, 173, '同江市', 3);
INSERT INTO `t_city` VALUES (1474, 173, '富锦市', 3);
INSERT INTO `t_city` VALUES (1475, 173, '桦南县', 3);
INSERT INTO `t_city` VALUES (1476, 173, '桦川县', 3);
INSERT INTO `t_city` VALUES (1477, 173, '汤原县', 3);
INSERT INTO `t_city` VALUES (1478, 173, '抚远县', 3);
INSERT INTO `t_city` VALUES (1479, 174, '爱民区', 3);
INSERT INTO `t_city` VALUES (1480, 174, '东安区', 3);
INSERT INTO `t_city` VALUES (1481, 174, '阳明区', 3);
INSERT INTO `t_city` VALUES (1482, 174, '西安区', 3);
INSERT INTO `t_city` VALUES (1483, 174, '绥芬河市', 3);
INSERT INTO `t_city` VALUES (1484, 174, '海林市', 3);
INSERT INTO `t_city` VALUES (1485, 174, '宁安市', 3);
INSERT INTO `t_city` VALUES (1486, 174, '穆棱市', 3);
INSERT INTO `t_city` VALUES (1487, 174, '东宁县', 3);
INSERT INTO `t_city` VALUES (1488, 174, '林口县', 3);
INSERT INTO `t_city` VALUES (1489, 175, '桃山区', 3);
INSERT INTO `t_city` VALUES (1490, 175, '新兴区', 3);
INSERT INTO `t_city` VALUES (1491, 175, '茄子河区', 3);
INSERT INTO `t_city` VALUES (1492, 175, '勃利县', 3);
INSERT INTO `t_city` VALUES (1493, 176, '龙沙区', 3);
INSERT INTO `t_city` VALUES (1494, 176, '昂昂溪区', 3);
INSERT INTO `t_city` VALUES (1495, 176, '铁峰区', 3);
INSERT INTO `t_city` VALUES (1496, 176, '建华区', 3);
INSERT INTO `t_city` VALUES (1497, 176, '富拉尔基区', 3);
INSERT INTO `t_city` VALUES (1498, 176, '碾子山区', 3);
INSERT INTO `t_city` VALUES (1499, 176, '梅里斯达斡尔区', 3);
INSERT INTO `t_city` VALUES (1500, 176, '讷河市', 3);
INSERT INTO `t_city` VALUES (1501, 176, '龙江县', 3);
INSERT INTO `t_city` VALUES (1502, 176, '依安县', 3);
INSERT INTO `t_city` VALUES (1503, 176, '泰来县', 3);
INSERT INTO `t_city` VALUES (1504, 176, '甘南县', 3);
INSERT INTO `t_city` VALUES (1505, 176, '富裕县', 3);
INSERT INTO `t_city` VALUES (1506, 176, '克山县', 3);
INSERT INTO `t_city` VALUES (1507, 176, '克东县', 3);
INSERT INTO `t_city` VALUES (1508, 176, '拜泉县', 3);
INSERT INTO `t_city` VALUES (1509, 177, '尖山区', 3);
INSERT INTO `t_city` VALUES (1510, 177, '岭东区', 3);
INSERT INTO `t_city` VALUES (1511, 177, '四方台区', 3);
INSERT INTO `t_city` VALUES (1512, 177, '宝山区', 3);
INSERT INTO `t_city` VALUES (1513, 177, '集贤县', 3);
INSERT INTO `t_city` VALUES (1514, 177, '友谊县', 3);
INSERT INTO `t_city` VALUES (1515, 177, '宝清县', 3);
INSERT INTO `t_city` VALUES (1516, 177, '饶河县', 3);
INSERT INTO `t_city` VALUES (1517, 178, '北林区', 3);
INSERT INTO `t_city` VALUES (1518, 178, '安达市', 3);
INSERT INTO `t_city` VALUES (1519, 178, '肇东市', 3);
INSERT INTO `t_city` VALUES (1520, 178, '海伦市', 3);
INSERT INTO `t_city` VALUES (1521, 178, '望奎县', 3);
INSERT INTO `t_city` VALUES (1522, 178, '兰西县', 3);
INSERT INTO `t_city` VALUES (1523, 178, '青冈县', 3);
INSERT INTO `t_city` VALUES (1524, 178, '庆安县', 3);
INSERT INTO `t_city` VALUES (1525, 178, '明水县', 3);
INSERT INTO `t_city` VALUES (1526, 178, '绥棱县', 3);
INSERT INTO `t_city` VALUES (1527, 179, '伊春区', 3);
INSERT INTO `t_city` VALUES (1528, 179, '带岭区', 3);
INSERT INTO `t_city` VALUES (1529, 179, '南岔区', 3);
INSERT INTO `t_city` VALUES (1530, 179, '金山屯区', 3);
INSERT INTO `t_city` VALUES (1531, 179, '西林区', 3);
INSERT INTO `t_city` VALUES (1532, 179, '美溪区', 3);
INSERT INTO `t_city` VALUES (1533, 179, '乌马河区', 3);
INSERT INTO `t_city` VALUES (1534, 179, '翠峦区', 3);
INSERT INTO `t_city` VALUES (1535, 179, '友好区', 3);
INSERT INTO `t_city` VALUES (1536, 179, '上甘岭区', 3);
INSERT INTO `t_city` VALUES (1537, 179, '五营区', 3);
INSERT INTO `t_city` VALUES (1538, 179, '红星区', 3);
INSERT INTO `t_city` VALUES (1539, 179, '新青区', 3);
INSERT INTO `t_city` VALUES (1540, 179, '汤旺河区', 3);
INSERT INTO `t_city` VALUES (1541, 179, '乌伊岭区', 3);
INSERT INTO `t_city` VALUES (1542, 179, '铁力市', 3);
INSERT INTO `t_city` VALUES (1543, 179, '嘉荫县', 3);
INSERT INTO `t_city` VALUES (1544, 180, '江岸区', 3);
INSERT INTO `t_city` VALUES (1545, 180, '武昌区', 3);
INSERT INTO `t_city` VALUES (1546, 180, '江汉区', 3);
INSERT INTO `t_city` VALUES (1547, 180, '硚口区', 3);
INSERT INTO `t_city` VALUES (1548, 180, '汉阳区', 3);
INSERT INTO `t_city` VALUES (1549, 180, '青山区', 3);
INSERT INTO `t_city` VALUES (1550, 180, '洪山区', 3);
INSERT INTO `t_city` VALUES (1551, 180, '东西湖区', 3);
INSERT INTO `t_city` VALUES (1552, 180, '汉南区', 3);
INSERT INTO `t_city` VALUES (1553, 180, '蔡甸区', 3);
INSERT INTO `t_city` VALUES (1554, 180, '江夏区', 3);
INSERT INTO `t_city` VALUES (1555, 180, '黄陂区', 3);
INSERT INTO `t_city` VALUES (1556, 180, '新洲区', 3);
INSERT INTO `t_city` VALUES (1557, 180, '经济开发区', 3);
INSERT INTO `t_city` VALUES (1558, 181, '仙桃市', 3);
INSERT INTO `t_city` VALUES (1559, 182, '鄂城区', 3);
INSERT INTO `t_city` VALUES (1560, 182, '华容区', 3);
INSERT INTO `t_city` VALUES (1561, 182, '梁子湖区', 3);
INSERT INTO `t_city` VALUES (1562, 183, '黄州区', 3);
INSERT INTO `t_city` VALUES (1563, 183, '麻城市', 3);
INSERT INTO `t_city` VALUES (1564, 183, '武穴市', 3);
INSERT INTO `t_city` VALUES (1565, 183, '团风县', 3);
INSERT INTO `t_city` VALUES (1566, 183, '红安县', 3);
INSERT INTO `t_city` VALUES (1567, 183, '罗田县', 3);
INSERT INTO `t_city` VALUES (1568, 183, '英山县', 3);
INSERT INTO `t_city` VALUES (1569, 183, '浠水县', 3);
INSERT INTO `t_city` VALUES (1570, 183, '蕲春县', 3);
INSERT INTO `t_city` VALUES (1571, 183, '黄梅县', 3);
INSERT INTO `t_city` VALUES (1572, 184, '黄石港区', 3);
INSERT INTO `t_city` VALUES (1573, 184, '西塞山区', 3);
INSERT INTO `t_city` VALUES (1574, 184, '下陆区', 3);
INSERT INTO `t_city` VALUES (1575, 184, '铁山区', 3);
INSERT INTO `t_city` VALUES (1576, 184, '大冶市', 3);
INSERT INTO `t_city` VALUES (1577, 184, '阳新县', 3);
INSERT INTO `t_city` VALUES (1578, 185, '东宝区', 3);
INSERT INTO `t_city` VALUES (1579, 185, '掇刀区', 3);
INSERT INTO `t_city` VALUES (1580, 185, '钟祥市', 3);
INSERT INTO `t_city` VALUES (1581, 185, '京山县', 3);
INSERT INTO `t_city` VALUES (1582, 185, '沙洋县', 3);
INSERT INTO `t_city` VALUES (1583, 186, '沙市区', 3);
INSERT INTO `t_city` VALUES (1584, 186, '荆州区', 3);
INSERT INTO `t_city` VALUES (1585, 186, '石首市', 3);
INSERT INTO `t_city` VALUES (1586, 186, '洪湖市', 3);
INSERT INTO `t_city` VALUES (1587, 186, '松滋市', 3);
INSERT INTO `t_city` VALUES (1588, 186, '公安县', 3);
INSERT INTO `t_city` VALUES (1589, 186, '监利县', 3);
INSERT INTO `t_city` VALUES (1590, 186, '江陵县', 3);
INSERT INTO `t_city` VALUES (1591, 187, '潜江市', 3);
INSERT INTO `t_city` VALUES (1592, 188, '神农架林区', 3);
INSERT INTO `t_city` VALUES (1593, 189, '张湾区', 3);
INSERT INTO `t_city` VALUES (1594, 189, '茅箭区', 3);
INSERT INTO `t_city` VALUES (1595, 189, '丹江口市', 3);
INSERT INTO `t_city` VALUES (1596, 189, '郧县', 3);
INSERT INTO `t_city` VALUES (1597, 189, '郧西县', 3);
INSERT INTO `t_city` VALUES (1598, 189, '竹山县', 3);
INSERT INTO `t_city` VALUES (1599, 189, '竹溪县', 3);
INSERT INTO `t_city` VALUES (1600, 189, '房县', 3);
INSERT INTO `t_city` VALUES (1601, 190, '曾都区', 3);
INSERT INTO `t_city` VALUES (1602, 190, '广水市', 3);
INSERT INTO `t_city` VALUES (1603, 191, '天门市', 3);
INSERT INTO `t_city` VALUES (1604, 192, '咸安区', 3);
INSERT INTO `t_city` VALUES (1605, 192, '赤壁市', 3);
INSERT INTO `t_city` VALUES (1606, 192, '嘉鱼县', 3);
INSERT INTO `t_city` VALUES (1607, 192, '通城县', 3);
INSERT INTO `t_city` VALUES (1608, 192, '崇阳县', 3);
INSERT INTO `t_city` VALUES (1609, 192, '通山县', 3);
INSERT INTO `t_city` VALUES (1610, 193, '襄城区', 3);
INSERT INTO `t_city` VALUES (1611, 193, '樊城区', 3);
INSERT INTO `t_city` VALUES (1612, 193, '襄阳区', 3);
INSERT INTO `t_city` VALUES (1613, 193, '老河口市', 3);
INSERT INTO `t_city` VALUES (1614, 193, '枣阳市', 3);
INSERT INTO `t_city` VALUES (1615, 193, '宜城市', 3);
INSERT INTO `t_city` VALUES (1616, 193, '南漳县', 3);
INSERT INTO `t_city` VALUES (1617, 193, '谷城县', 3);
INSERT INTO `t_city` VALUES (1618, 193, '保康县', 3);
INSERT INTO `t_city` VALUES (1619, 194, '孝南区', 3);
INSERT INTO `t_city` VALUES (1620, 194, '应城市', 3);
INSERT INTO `t_city` VALUES (1621, 194, '安陆市', 3);
INSERT INTO `t_city` VALUES (1622, 194, '汉川市', 3);
INSERT INTO `t_city` VALUES (1623, 194, '孝昌县', 3);
INSERT INTO `t_city` VALUES (1624, 194, '大悟县', 3);
INSERT INTO `t_city` VALUES (1625, 194, '云梦县', 3);
INSERT INTO `t_city` VALUES (1626, 195, '长阳', 3);
INSERT INTO `t_city` VALUES (1627, 195, '五峰', 3);
INSERT INTO `t_city` VALUES (1628, 195, '西陵区', 3);
INSERT INTO `t_city` VALUES (1629, 195, '伍家岗区', 3);
INSERT INTO `t_city` VALUES (1630, 195, '点军区', 3);
INSERT INTO `t_city` VALUES (1631, 195, '猇亭区', 3);
INSERT INTO `t_city` VALUES (1632, 195, '夷陵区', 3);
INSERT INTO `t_city` VALUES (1633, 195, '宜都市', 3);
INSERT INTO `t_city` VALUES (1634, 195, '当阳市', 3);
INSERT INTO `t_city` VALUES (1635, 195, '枝江市', 3);
INSERT INTO `t_city` VALUES (1636, 195, '远安县', 3);
INSERT INTO `t_city` VALUES (1637, 195, '兴山县', 3);
INSERT INTO `t_city` VALUES (1638, 195, '秭归县', 3);
INSERT INTO `t_city` VALUES (1639, 196, '恩施市', 3);
INSERT INTO `t_city` VALUES (1640, 196, '利川市', 3);
INSERT INTO `t_city` VALUES (1641, 196, '建始县', 3);
INSERT INTO `t_city` VALUES (1642, 196, '巴东县', 3);
INSERT INTO `t_city` VALUES (1643, 196, '宣恩县', 3);
INSERT INTO `t_city` VALUES (1644, 196, '咸丰县', 3);
INSERT INTO `t_city` VALUES (1645, 196, '来凤县', 3);
INSERT INTO `t_city` VALUES (1646, 196, '鹤峰县', 3);
INSERT INTO `t_city` VALUES (1647, 197, '岳麓区', 3);
INSERT INTO `t_city` VALUES (1648, 197, '芙蓉区', 3);
INSERT INTO `t_city` VALUES (1649, 197, '天心区', 3);
INSERT INTO `t_city` VALUES (1650, 197, '开福区', 3);
INSERT INTO `t_city` VALUES (1651, 197, '雨花区', 3);
INSERT INTO `t_city` VALUES (1652, 197, '开发区', 3);
INSERT INTO `t_city` VALUES (1653, 197, '浏阳市', 3);
INSERT INTO `t_city` VALUES (1654, 197, '长沙县', 3);
INSERT INTO `t_city` VALUES (1655, 197, '望城县', 3);
INSERT INTO `t_city` VALUES (1656, 197, '宁乡县', 3);
INSERT INTO `t_city` VALUES (1657, 198, '永定区', 3);
INSERT INTO `t_city` VALUES (1658, 198, '武陵源区', 3);
INSERT INTO `t_city` VALUES (1659, 198, '慈利县', 3);
INSERT INTO `t_city` VALUES (1660, 198, '桑植县', 3);
INSERT INTO `t_city` VALUES (1661, 199, '武陵区', 3);
INSERT INTO `t_city` VALUES (1662, 199, '鼎城区', 3);
INSERT INTO `t_city` VALUES (1663, 199, '津市市', 3);
INSERT INTO `t_city` VALUES (1664, 199, '安乡县', 3);
INSERT INTO `t_city` VALUES (1665, 199, '汉寿县', 3);
INSERT INTO `t_city` VALUES (1666, 199, '澧县', 3);
INSERT INTO `t_city` VALUES (1667, 199, '临澧县', 3);
INSERT INTO `t_city` VALUES (1668, 199, '桃源县', 3);
INSERT INTO `t_city` VALUES (1669, 199, '石门县', 3);
INSERT INTO `t_city` VALUES (1670, 200, '北湖区', 3);
INSERT INTO `t_city` VALUES (1671, 200, '苏仙区', 3);
INSERT INTO `t_city` VALUES (1672, 200, '资兴市', 3);
INSERT INTO `t_city` VALUES (1673, 200, '桂阳县', 3);
INSERT INTO `t_city` VALUES (1674, 200, '宜章县', 3);
INSERT INTO `t_city` VALUES (1675, 200, '永兴县', 3);
INSERT INTO `t_city` VALUES (1676, 200, '嘉禾县', 3);
INSERT INTO `t_city` VALUES (1677, 200, '临武县', 3);
INSERT INTO `t_city` VALUES (1678, 200, '汝城县', 3);
INSERT INTO `t_city` VALUES (1679, 200, '桂东县', 3);
INSERT INTO `t_city` VALUES (1680, 200, '安仁县', 3);
INSERT INTO `t_city` VALUES (1681, 201, '雁峰区', 3);
INSERT INTO `t_city` VALUES (1682, 201, '珠晖区', 3);
INSERT INTO `t_city` VALUES (1683, 201, '石鼓区', 3);
INSERT INTO `t_city` VALUES (1684, 201, '蒸湘区', 3);
INSERT INTO `t_city` VALUES (1685, 201, '南岳区', 3);
INSERT INTO `t_city` VALUES (1686, 201, '耒阳市', 3);
INSERT INTO `t_city` VALUES (1687, 201, '常宁市', 3);
INSERT INTO `t_city` VALUES (1688, 201, '衡阳县', 3);
INSERT INTO `t_city` VALUES (1689, 201, '衡南县', 3);
INSERT INTO `t_city` VALUES (1690, 201, '衡山县', 3);
INSERT INTO `t_city` VALUES (1691, 201, '衡东县', 3);
INSERT INTO `t_city` VALUES (1692, 201, '祁东县', 3);
INSERT INTO `t_city` VALUES (1693, 202, '鹤城区', 3);
INSERT INTO `t_city` VALUES (1694, 202, '靖州', 3);
INSERT INTO `t_city` VALUES (1695, 202, '麻阳', 3);
INSERT INTO `t_city` VALUES (1696, 202, '通道', 3);
INSERT INTO `t_city` VALUES (1697, 202, '新晃', 3);
INSERT INTO `t_city` VALUES (1698, 202, '芷江', 3);
INSERT INTO `t_city` VALUES (1699, 202, '沅陵县', 3);
INSERT INTO `t_city` VALUES (1700, 202, '辰溪县', 3);
INSERT INTO `t_city` VALUES (1701, 202, '溆浦县', 3);
INSERT INTO `t_city` VALUES (1702, 202, '中方县', 3);
INSERT INTO `t_city` VALUES (1703, 202, '会同县', 3);
INSERT INTO `t_city` VALUES (1704, 202, '洪江市', 3);
INSERT INTO `t_city` VALUES (1705, 203, '娄星区', 3);
INSERT INTO `t_city` VALUES (1706, 203, '冷水江市', 3);
INSERT INTO `t_city` VALUES (1707, 203, '涟源市', 3);
INSERT INTO `t_city` VALUES (1708, 203, '双峰县', 3);
INSERT INTO `t_city` VALUES (1709, 203, '新化县', 3);
INSERT INTO `t_city` VALUES (1710, 204, '城步', 3);
INSERT INTO `t_city` VALUES (1711, 204, '双清区', 3);
INSERT INTO `t_city` VALUES (1712, 204, '大祥区', 3);
INSERT INTO `t_city` VALUES (1713, 204, '北塔区', 3);
INSERT INTO `t_city` VALUES (1714, 204, '武冈市', 3);
INSERT INTO `t_city` VALUES (1715, 204, '邵东县', 3);
INSERT INTO `t_city` VALUES (1716, 204, '新邵县', 3);
INSERT INTO `t_city` VALUES (1717, 204, '邵阳县', 3);
INSERT INTO `t_city` VALUES (1718, 204, '隆回县', 3);
INSERT INTO `t_city` VALUES (1719, 204, '洞口县', 3);
INSERT INTO `t_city` VALUES (1720, 204, '绥宁县', 3);
INSERT INTO `t_city` VALUES (1721, 204, '新宁县', 3);
INSERT INTO `t_city` VALUES (1722, 205, '岳塘区', 3);
INSERT INTO `t_city` VALUES (1723, 205, '雨湖区', 3);
INSERT INTO `t_city` VALUES (1724, 205, '湘乡市', 3);
INSERT INTO `t_city` VALUES (1725, 205, '韶山市', 3);
INSERT INTO `t_city` VALUES (1726, 205, '湘潭县', 3);
INSERT INTO `t_city` VALUES (1727, 206, '吉首市', 3);
INSERT INTO `t_city` VALUES (1728, 206, '泸溪县', 3);
INSERT INTO `t_city` VALUES (1729, 206, '凤凰县', 3);
INSERT INTO `t_city` VALUES (1730, 206, '花垣县', 3);
INSERT INTO `t_city` VALUES (1731, 206, '保靖县', 3);
INSERT INTO `t_city` VALUES (1732, 206, '古丈县', 3);
INSERT INTO `t_city` VALUES (1733, 206, '永顺县', 3);
INSERT INTO `t_city` VALUES (1734, 206, '龙山县', 3);
INSERT INTO `t_city` VALUES (1735, 207, '赫山区', 3);
INSERT INTO `t_city` VALUES (1736, 207, '资阳区', 3);
INSERT INTO `t_city` VALUES (1737, 207, '沅江市', 3);
INSERT INTO `t_city` VALUES (1738, 207, '南县', 3);
INSERT INTO `t_city` VALUES (1739, 207, '桃江县', 3);
INSERT INTO `t_city` VALUES (1740, 207, '安化县', 3);
INSERT INTO `t_city` VALUES (1741, 208, '江华', 3);
INSERT INTO `t_city` VALUES (1742, 208, '冷水滩区', 3);
INSERT INTO `t_city` VALUES (1743, 208, '零陵区', 3);
INSERT INTO `t_city` VALUES (1744, 208, '祁阳县', 3);
INSERT INTO `t_city` VALUES (1745, 208, '东安县', 3);
INSERT INTO `t_city` VALUES (1746, 208, '双牌县', 3);
INSERT INTO `t_city` VALUES (1747, 208, '道县', 3);
INSERT INTO `t_city` VALUES (1748, 208, '江永县', 3);
INSERT INTO `t_city` VALUES (1749, 208, '宁远县', 3);
INSERT INTO `t_city` VALUES (1750, 208, '蓝山县', 3);
INSERT INTO `t_city` VALUES (1751, 208, '新田县', 3);
INSERT INTO `t_city` VALUES (1752, 209, '岳阳楼区', 3);
INSERT INTO `t_city` VALUES (1753, 209, '君山区', 3);
INSERT INTO `t_city` VALUES (1754, 209, '云溪区', 3);
INSERT INTO `t_city` VALUES (1755, 209, '汨罗市', 3);
INSERT INTO `t_city` VALUES (1756, 209, '临湘市', 3);
INSERT INTO `t_city` VALUES (1757, 209, '岳阳县', 3);
INSERT INTO `t_city` VALUES (1758, 209, '华容县', 3);
INSERT INTO `t_city` VALUES (1759, 209, '湘阴县', 3);
INSERT INTO `t_city` VALUES (1760, 209, '平江县', 3);
INSERT INTO `t_city` VALUES (1761, 210, '天元区', 3);
INSERT INTO `t_city` VALUES (1762, 210, '荷塘区', 3);
INSERT INTO `t_city` VALUES (1763, 210, '芦淞区', 3);
INSERT INTO `t_city` VALUES (1764, 210, '石峰区', 3);
INSERT INTO `t_city` VALUES (1765, 210, '醴陵市', 3);
INSERT INTO `t_city` VALUES (1766, 210, '株洲县', 3);
INSERT INTO `t_city` VALUES (1767, 210, '攸县', 3);
INSERT INTO `t_city` VALUES (1768, 210, '茶陵县', 3);
INSERT INTO `t_city` VALUES (1769, 210, '炎陵县', 3);
INSERT INTO `t_city` VALUES (1770, 211, '朝阳区', 3);
INSERT INTO `t_city` VALUES (1771, 211, '宽城区', 3);
INSERT INTO `t_city` VALUES (1772, 211, '二道区', 3);
INSERT INTO `t_city` VALUES (1773, 211, '南关区', 3);
INSERT INTO `t_city` VALUES (1774, 211, '绿园区', 3);
INSERT INTO `t_city` VALUES (1775, 211, '双阳区', 3);
INSERT INTO `t_city` VALUES (1776, 211, '净月潭开发区', 3);
INSERT INTO `t_city` VALUES (1777, 211, '高新技术开发区', 3);
INSERT INTO `t_city` VALUES (1778, 211, '经济技术开发区', 3);
INSERT INTO `t_city` VALUES (1779, 211, '汽车产业开发区', 3);
INSERT INTO `t_city` VALUES (1780, 211, '德惠市', 3);
INSERT INTO `t_city` VALUES (1781, 211, '九台市', 3);
INSERT INTO `t_city` VALUES (1782, 211, '榆树市', 3);
INSERT INTO `t_city` VALUES (1783, 211, '农安县', 3);
INSERT INTO `t_city` VALUES (1784, 212, '船营区', 3);
INSERT INTO `t_city` VALUES (1785, 212, '昌邑区', 3);
INSERT INTO `t_city` VALUES (1786, 212, '龙潭区', 3);
INSERT INTO `t_city` VALUES (1787, 212, '丰满区', 3);
INSERT INTO `t_city` VALUES (1788, 212, '蛟河市', 3);
INSERT INTO `t_city` VALUES (1789, 212, '桦甸市', 3);
INSERT INTO `t_city` VALUES (1790, 212, '舒兰市', 3);
INSERT INTO `t_city` VALUES (1791, 212, '磐石市', 3);
INSERT INTO `t_city` VALUES (1792, 212, '永吉县', 3);
INSERT INTO `t_city` VALUES (1793, 213, '洮北区', 3);
INSERT INTO `t_city` VALUES (1794, 213, '洮南市', 3);
INSERT INTO `t_city` VALUES (1795, 213, '大安市', 3);
INSERT INTO `t_city` VALUES (1796, 213, '镇赉县', 3);
INSERT INTO `t_city` VALUES (1797, 213, '通榆县', 3);
INSERT INTO `t_city` VALUES (1798, 214, '江源区', 3);
INSERT INTO `t_city` VALUES (1799, 214, '八道江区', 3);
INSERT INTO `t_city` VALUES (1800, 214, '长白', 3);
INSERT INTO `t_city` VALUES (1801, 214, '临江市', 3);
INSERT INTO `t_city` VALUES (1802, 214, '抚松县', 3);
INSERT INTO `t_city` VALUES (1803, 214, '靖宇县', 3);
INSERT INTO `t_city` VALUES (1804, 215, '龙山区', 3);
INSERT INTO `t_city` VALUES (1805, 215, '西安区', 3);
INSERT INTO `t_city` VALUES (1806, 215, '东丰县', 3);
INSERT INTO `t_city` VALUES (1807, 215, '东辽县', 3);
INSERT INTO `t_city` VALUES (1808, 216, '铁西区', 3);
INSERT INTO `t_city` VALUES (1809, 216, '铁东区', 3);
INSERT INTO `t_city` VALUES (1810, 216, '伊通', 3);
INSERT INTO `t_city` VALUES (1811, 216, '公主岭市', 3);
INSERT INTO `t_city` VALUES (1812, 216, '双辽市', 3);
INSERT INTO `t_city` VALUES (1813, 216, '梨树县', 3);
INSERT INTO `t_city` VALUES (1814, 217, '前郭尔罗斯', 3);
INSERT INTO `t_city` VALUES (1815, 217, '宁江区', 3);
INSERT INTO `t_city` VALUES (1816, 217, '长岭县', 3);
INSERT INTO `t_city` VALUES (1817, 217, '乾安县', 3);
INSERT INTO `t_city` VALUES (1818, 217, '扶余县', 3);
INSERT INTO `t_city` VALUES (1819, 218, '东昌区', 3);
INSERT INTO `t_city` VALUES (1820, 218, '二道江区', 3);
INSERT INTO `t_city` VALUES (1821, 218, '梅河口市', 3);
INSERT INTO `t_city` VALUES (1822, 218, '集安市', 3);
INSERT INTO `t_city` VALUES (1823, 218, '通化县', 3);
INSERT INTO `t_city` VALUES (1824, 218, '辉南县', 3);
INSERT INTO `t_city` VALUES (1825, 218, '柳河县', 3);
INSERT INTO `t_city` VALUES (1826, 219, '延吉市', 3);
INSERT INTO `t_city` VALUES (1827, 219, '图们市', 3);
INSERT INTO `t_city` VALUES (1828, 219, '敦化市', 3);
INSERT INTO `t_city` VALUES (1829, 219, '珲春市', 3);
INSERT INTO `t_city` VALUES (1830, 219, '龙井市', 3);
INSERT INTO `t_city` VALUES (1831, 219, '和龙市', 3);
INSERT INTO `t_city` VALUES (1832, 219, '安图县', 3);
INSERT INTO `t_city` VALUES (1833, 219, '汪清县', 3);
INSERT INTO `t_city` VALUES (1834, 220, '玄武区', 3);
INSERT INTO `t_city` VALUES (1835, 220, '鼓楼区', 3);
INSERT INTO `t_city` VALUES (1836, 220, '白下区', 3);
INSERT INTO `t_city` VALUES (1837, 220, '建邺区', 3);
INSERT INTO `t_city` VALUES (1838, 220, '秦淮区', 3);
INSERT INTO `t_city` VALUES (1839, 220, '雨花台区', 3);
INSERT INTO `t_city` VALUES (1840, 220, '下关区', 3);
INSERT INTO `t_city` VALUES (1841, 220, '栖霞区', 3);
INSERT INTO `t_city` VALUES (1842, 220, '浦口区', 3);
INSERT INTO `t_city` VALUES (1843, 220, '江宁区', 3);
INSERT INTO `t_city` VALUES (1844, 220, '六合区', 3);
INSERT INTO `t_city` VALUES (1845, 220, '溧水县', 3);
INSERT INTO `t_city` VALUES (1846, 220, '高淳县', 3);
INSERT INTO `t_city` VALUES (1847, 221, '沧浪区', 3);
INSERT INTO `t_city` VALUES (1848, 221, '金阊区', 3);
INSERT INTO `t_city` VALUES (1849, 221, '平江区', 3);
INSERT INTO `t_city` VALUES (1850, 221, '虎丘区', 3);
INSERT INTO `t_city` VALUES (1851, 221, '吴中区', 3);
INSERT INTO `t_city` VALUES (1852, 221, '相城区', 3);
INSERT INTO `t_city` VALUES (1853, 221, '园区', 3);
INSERT INTO `t_city` VALUES (1854, 221, '新区', 3);
INSERT INTO `t_city` VALUES (1855, 221, '常熟市', 3);
INSERT INTO `t_city` VALUES (1856, 221, '张家港市', 3);
INSERT INTO `t_city` VALUES (1857, 221, '玉山镇', 3);
INSERT INTO `t_city` VALUES (1858, 221, '巴城镇', 3);
INSERT INTO `t_city` VALUES (1859, 221, '周市镇', 3);
INSERT INTO `t_city` VALUES (1860, 221, '陆家镇', 3);
INSERT INTO `t_city` VALUES (1861, 221, '花桥镇', 3);
INSERT INTO `t_city` VALUES (1862, 221, '淀山湖镇', 3);
INSERT INTO `t_city` VALUES (1863, 221, '张浦镇', 3);
INSERT INTO `t_city` VALUES (1864, 221, '周庄镇', 3);
INSERT INTO `t_city` VALUES (1865, 221, '千灯镇', 3);
INSERT INTO `t_city` VALUES (1866, 221, '锦溪镇', 3);
INSERT INTO `t_city` VALUES (1867, 221, '开发区', 3);
INSERT INTO `t_city` VALUES (1868, 221, '吴江市', 3);
INSERT INTO `t_city` VALUES (1869, 221, '太仓市', 3);
INSERT INTO `t_city` VALUES (1870, 222, '崇安区', 3);
INSERT INTO `t_city` VALUES (1871, 222, '北塘区', 3);
INSERT INTO `t_city` VALUES (1872, 222, '南长区', 3);
INSERT INTO `t_city` VALUES (1873, 222, '锡山区', 3);
INSERT INTO `t_city` VALUES (1874, 222, '惠山区', 3);
INSERT INTO `t_city` VALUES (1875, 222, '滨湖区', 3);
INSERT INTO `t_city` VALUES (1876, 222, '新区', 3);
INSERT INTO `t_city` VALUES (1877, 222, '江阴市', 3);
INSERT INTO `t_city` VALUES (1878, 222, '宜兴市', 3);
INSERT INTO `t_city` VALUES (1879, 223, '天宁区', 3);
INSERT INTO `t_city` VALUES (1880, 223, '钟楼区', 3);
INSERT INTO `t_city` VALUES (1881, 223, '戚墅堰区', 3);
INSERT INTO `t_city` VALUES (1882, 223, '郊区', 3);
INSERT INTO `t_city` VALUES (1883, 223, '新北区', 3);
INSERT INTO `t_city` VALUES (1884, 223, '武进区', 3);
INSERT INTO `t_city` VALUES (1885, 223, '溧阳市', 3);
INSERT INTO `t_city` VALUES (1886, 223, '金坛市', 3);
INSERT INTO `t_city` VALUES (1887, 224, '清河区', 3);
INSERT INTO `t_city` VALUES (1888, 224, '清浦区', 3);
INSERT INTO `t_city` VALUES (1889, 224, '楚州区', 3);
INSERT INTO `t_city` VALUES (1890, 224, '淮阴区', 3);
INSERT INTO `t_city` VALUES (1891, 224, '涟水县', 3);
INSERT INTO `t_city` VALUES (1892, 224, '洪泽县', 3);
INSERT INTO `t_city` VALUES (1893, 224, '盱眙县', 3);
INSERT INTO `t_city` VALUES (1894, 224, '金湖县', 3);
INSERT INTO `t_city` VALUES (1895, 225, '新浦区', 3);
INSERT INTO `t_city` VALUES (1896, 225, '连云区', 3);
INSERT INTO `t_city` VALUES (1897, 225, '海州区', 3);
INSERT INTO `t_city` VALUES (1898, 225, '赣榆县', 3);
INSERT INTO `t_city` VALUES (1899, 225, '东海县', 3);
INSERT INTO `t_city` VALUES (1900, 225, '灌云县', 3);
INSERT INTO `t_city` VALUES (1901, 225, '灌南县', 3);
INSERT INTO `t_city` VALUES (1902, 226, '崇川区', 3);
INSERT INTO `t_city` VALUES (1903, 226, '港闸区', 3);
INSERT INTO `t_city` VALUES (1904, 226, '经济开发区', 3);
INSERT INTO `t_city` VALUES (1905, 226, '启东市', 3);
INSERT INTO `t_city` VALUES (1906, 226, '如皋市', 3);
INSERT INTO `t_city` VALUES (1907, 226, '通州市', 3);
INSERT INTO `t_city` VALUES (1908, 226, '海门市', 3);
INSERT INTO `t_city` VALUES (1909, 226, '海安县', 3);
INSERT INTO `t_city` VALUES (1910, 226, '如东县', 3);
INSERT INTO `t_city` VALUES (1911, 227, '宿城区', 3);
INSERT INTO `t_city` VALUES (1912, 227, '宿豫区', 3);
INSERT INTO `t_city` VALUES (1913, 227, '宿豫县', 3);
INSERT INTO `t_city` VALUES (1914, 227, '沭阳县', 3);
INSERT INTO `t_city` VALUES (1915, 227, '泗阳县', 3);
INSERT INTO `t_city` VALUES (1916, 227, '泗洪县', 3);
INSERT INTO `t_city` VALUES (1917, 228, '海陵区', 3);
INSERT INTO `t_city` VALUES (1918, 228, '高港区', 3);
INSERT INTO `t_city` VALUES (1919, 228, '兴化市', 3);
INSERT INTO `t_city` VALUES (1920, 228, '靖江市', 3);
INSERT INTO `t_city` VALUES (1921, 228, '泰兴市', 3);
INSERT INTO `t_city` VALUES (1922, 228, '姜堰市', 3);
INSERT INTO `t_city` VALUES (1923, 229, '云龙区', 3);
INSERT INTO `t_city` VALUES (1924, 229, '鼓楼区', 3);
INSERT INTO `t_city` VALUES (1925, 229, '九里区', 3);
INSERT INTO `t_city` VALUES (1926, 229, '贾汪区', 3);
INSERT INTO `t_city` VALUES (1927, 229, '泉山区', 3);
INSERT INTO `t_city` VALUES (1928, 229, '新沂市', 3);
INSERT INTO `t_city` VALUES (1929, 229, '邳州市', 3);
INSERT INTO `t_city` VALUES (1930, 229, '丰县', 3);
INSERT INTO `t_city` VALUES (1931, 229, '沛县', 3);
INSERT INTO `t_city` VALUES (1932, 229, '铜山县', 3);
INSERT INTO `t_city` VALUES (1933, 229, '睢宁县', 3);
INSERT INTO `t_city` VALUES (1934, 230, '城区', 3);
INSERT INTO `t_city` VALUES (1935, 230, '亭湖区', 3);
INSERT INTO `t_city` VALUES (1936, 230, '盐都区', 3);
INSERT INTO `t_city` VALUES (1937, 230, '盐都县', 3);
INSERT INTO `t_city` VALUES (1938, 230, '东台市', 3);
INSERT INTO `t_city` VALUES (1939, 230, '大丰市', 3);
INSERT INTO `t_city` VALUES (1940, 230, '响水县', 3);
INSERT INTO `t_city` VALUES (1941, 230, '滨海县', 3);
INSERT INTO `t_city` VALUES (1942, 230, '阜宁县', 3);
INSERT INTO `t_city` VALUES (1943, 230, '射阳县', 3);
INSERT INTO `t_city` VALUES (1944, 230, '建湖县', 3);
INSERT INTO `t_city` VALUES (1945, 231, '广陵区', 3);
INSERT INTO `t_city` VALUES (1946, 231, '维扬区', 3);
INSERT INTO `t_city` VALUES (1947, 231, '邗江区', 3);
INSERT INTO `t_city` VALUES (1948, 231, '仪征市', 3);
INSERT INTO `t_city` VALUES (1949, 231, '高邮市', 3);
INSERT INTO `t_city` VALUES (1950, 231, '江都市', 3);
INSERT INTO `t_city` VALUES (1951, 231, '宝应县', 3);
INSERT INTO `t_city` VALUES (1952, 232, '京口区', 3);
INSERT INTO `t_city` VALUES (1953, 232, '润州区', 3);
INSERT INTO `t_city` VALUES (1954, 232, '丹徒区', 3);
INSERT INTO `t_city` VALUES (1955, 232, '丹阳市', 3);
INSERT INTO `t_city` VALUES (1956, 232, '扬中市', 3);
INSERT INTO `t_city` VALUES (1957, 232, '句容市', 3);
INSERT INTO `t_city` VALUES (1958, 233, '东湖区', 3);
INSERT INTO `t_city` VALUES (1959, 233, '西湖区', 3);
INSERT INTO `t_city` VALUES (1960, 233, '青云谱区', 3);
INSERT INTO `t_city` VALUES (1961, 233, '湾里区', 3);
INSERT INTO `t_city` VALUES (1962, 233, '青山湖区', 3);
INSERT INTO `t_city` VALUES (1963, 233, '红谷滩新区', 3);
INSERT INTO `t_city` VALUES (1964, 233, '昌北区', 3);
INSERT INTO `t_city` VALUES (1965, 233, '高新区', 3);
INSERT INTO `t_city` VALUES (1966, 233, '南昌县', 3);
INSERT INTO `t_city` VALUES (1967, 233, '新建县', 3);
INSERT INTO `t_city` VALUES (1968, 233, '安义县', 3);
INSERT INTO `t_city` VALUES (1969, 233, '进贤县', 3);
INSERT INTO `t_city` VALUES (1970, 234, '临川区', 3);
INSERT INTO `t_city` VALUES (1971, 234, '南城县', 3);
INSERT INTO `t_city` VALUES (1972, 234, '黎川县', 3);
INSERT INTO `t_city` VALUES (1973, 234, '南丰县', 3);
INSERT INTO `t_city` VALUES (1974, 234, '崇仁县', 3);
INSERT INTO `t_city` VALUES (1975, 234, '乐安县', 3);
INSERT INTO `t_city` VALUES (1976, 234, '宜黄县', 3);
INSERT INTO `t_city` VALUES (1977, 234, '金溪县', 3);
INSERT INTO `t_city` VALUES (1978, 234, '资溪县', 3);
INSERT INTO `t_city` VALUES (1979, 234, '东乡县', 3);
INSERT INTO `t_city` VALUES (1980, 234, '广昌县', 3);
INSERT INTO `t_city` VALUES (1981, 235, '章贡区', 3);
INSERT INTO `t_city` VALUES (1982, 235, '于都县', 3);
INSERT INTO `t_city` VALUES (1983, 235, '瑞金市', 3);
INSERT INTO `t_city` VALUES (1984, 235, '南康市', 3);
INSERT INTO `t_city` VALUES (1985, 235, '赣县', 3);
INSERT INTO `t_city` VALUES (1986, 235, '信丰县', 3);
INSERT INTO `t_city` VALUES (1987, 235, '大余县', 3);
INSERT INTO `t_city` VALUES (1988, 235, '上犹县', 3);
INSERT INTO `t_city` VALUES (1989, 235, '崇义县', 3);
INSERT INTO `t_city` VALUES (1990, 235, '安远县', 3);
INSERT INTO `t_city` VALUES (1991, 235, '龙南县', 3);
INSERT INTO `t_city` VALUES (1992, 235, '定南县', 3);
INSERT INTO `t_city` VALUES (1993, 235, '全南县', 3);
INSERT INTO `t_city` VALUES (1994, 235, '宁都县', 3);
INSERT INTO `t_city` VALUES (1995, 235, '兴国县', 3);
INSERT INTO `t_city` VALUES (1996, 235, '会昌县', 3);
INSERT INTO `t_city` VALUES (1997, 235, '寻乌县', 3);
INSERT INTO `t_city` VALUES (1998, 235, '石城县', 3);
INSERT INTO `t_city` VALUES (1999, 236, '安福县', 3);
INSERT INTO `t_city` VALUES (2000, 236, '吉州区', 3);
INSERT INTO `t_city` VALUES (2001, 236, '青原区', 3);
INSERT INTO `t_city` VALUES (2002, 236, '井冈山市', 3);
INSERT INTO `t_city` VALUES (2003, 236, '吉安县', 3);
INSERT INTO `t_city` VALUES (2004, 236, '吉水县', 3);
INSERT INTO `t_city` VALUES (2005, 236, '峡江县', 3);
INSERT INTO `t_city` VALUES (2006, 236, '新干县', 3);
INSERT INTO `t_city` VALUES (2007, 236, '永丰县', 3);
INSERT INTO `t_city` VALUES (2008, 236, '泰和县', 3);
INSERT INTO `t_city` VALUES (2009, 236, '遂川县', 3);
INSERT INTO `t_city` VALUES (2010, 236, '万安县', 3);
INSERT INTO `t_city` VALUES (2011, 236, '永新县', 3);
INSERT INTO `t_city` VALUES (2012, 237, '珠山区', 3);
INSERT INTO `t_city` VALUES (2013, 237, '昌江区', 3);
INSERT INTO `t_city` VALUES (2014, 237, '乐平市', 3);
INSERT INTO `t_city` VALUES (2015, 237, '浮梁县', 3);
INSERT INTO `t_city` VALUES (2016, 238, '浔阳区', 3);
INSERT INTO `t_city` VALUES (2017, 238, '庐山区', 3);
INSERT INTO `t_city` VALUES (2018, 238, '瑞昌市', 3);
INSERT INTO `t_city` VALUES (2019, 238, '九江县', 3);
INSERT INTO `t_city` VALUES (2020, 238, '武宁县', 3);
INSERT INTO `t_city` VALUES (2021, 238, '修水县', 3);
INSERT INTO `t_city` VALUES (2022, 238, '永修县', 3);
INSERT INTO `t_city` VALUES (2023, 238, '德安县', 3);
INSERT INTO `t_city` VALUES (2024, 238, '星子县', 3);
INSERT INTO `t_city` VALUES (2025, 238, '都昌县', 3);
INSERT INTO `t_city` VALUES (2026, 238, '湖口县', 3);
INSERT INTO `t_city` VALUES (2027, 238, '彭泽县', 3);
INSERT INTO `t_city` VALUES (2028, 239, '安源区', 3);
INSERT INTO `t_city` VALUES (2029, 239, '湘东区', 3);
INSERT INTO `t_city` VALUES (2030, 239, '莲花县', 3);
INSERT INTO `t_city` VALUES (2031, 239, '芦溪县', 3);
INSERT INTO `t_city` VALUES (2032, 239, '上栗县', 3);
INSERT INTO `t_city` VALUES (2033, 240, '信州区', 3);
INSERT INTO `t_city` VALUES (2034, 240, '德兴市', 3);
INSERT INTO `t_city` VALUES (2035, 240, '上饶县', 3);
INSERT INTO `t_city` VALUES (2036, 240, '广丰县', 3);
INSERT INTO `t_city` VALUES (2037, 240, '玉山县', 3);
INSERT INTO `t_city` VALUES (2038, 240, '铅山县', 3);
INSERT INTO `t_city` VALUES (2039, 240, '横峰县', 3);
INSERT INTO `t_city` VALUES (2040, 240, '弋阳县', 3);
INSERT INTO `t_city` VALUES (2041, 240, '余干县', 3);
INSERT INTO `t_city` VALUES (2042, 240, '波阳县', 3);
INSERT INTO `t_city` VALUES (2043, 240, '万年县', 3);
INSERT INTO `t_city` VALUES (2044, 240, '婺源县', 3);
INSERT INTO `t_city` VALUES (2045, 241, '渝水区', 3);
INSERT INTO `t_city` VALUES (2046, 241, '分宜县', 3);
INSERT INTO `t_city` VALUES (2047, 242, '袁州区', 3);
INSERT INTO `t_city` VALUES (2048, 242, '丰城市', 3);
INSERT INTO `t_city` VALUES (2049, 242, '樟树市', 3);
INSERT INTO `t_city` VALUES (2050, 242, '高安市', 3);
INSERT INTO `t_city` VALUES (2051, 242, '奉新县', 3);
INSERT INTO `t_city` VALUES (2052, 242, '万载县', 3);
INSERT INTO `t_city` VALUES (2053, 242, '上高县', 3);
INSERT INTO `t_city` VALUES (2054, 242, '宜丰县', 3);
INSERT INTO `t_city` VALUES (2055, 242, '靖安县', 3);
INSERT INTO `t_city` VALUES (2056, 242, '铜鼓县', 3);
INSERT INTO `t_city` VALUES (2057, 243, '月湖区', 3);
INSERT INTO `t_city` VALUES (2058, 243, '贵溪市', 3);
INSERT INTO `t_city` VALUES (2059, 243, '余江县', 3);
INSERT INTO `t_city` VALUES (2060, 244, '沈河区', 3);
INSERT INTO `t_city` VALUES (2061, 244, '皇姑区', 3);
INSERT INTO `t_city` VALUES (2062, 244, '和平区', 3);
INSERT INTO `t_city` VALUES (2063, 244, '大东区', 3);
INSERT INTO `t_city` VALUES (2064, 244, '铁西区', 3);
INSERT INTO `t_city` VALUES (2065, 244, '苏家屯区', 3);
INSERT INTO `t_city` VALUES (2066, 244, '东陵区', 3);
INSERT INTO `t_city` VALUES (2067, 244, '沈北新区', 3);
INSERT INTO `t_city` VALUES (2068, 244, '于洪区', 3);
INSERT INTO `t_city` VALUES (2069, 244, '浑南新区', 3);
INSERT INTO `t_city` VALUES (2070, 244, '新民市', 3);
INSERT INTO `t_city` VALUES (2071, 244, '辽中县', 3);
INSERT INTO `t_city` VALUES (2072, 244, '康平县', 3);
INSERT INTO `t_city` VALUES (2073, 244, '法库县', 3);
INSERT INTO `t_city` VALUES (2074, 245, '西岗区', 3);
INSERT INTO `t_city` VALUES (2075, 245, '中山区', 3);
INSERT INTO `t_city` VALUES (2076, 245, '沙河口区', 3);
INSERT INTO `t_city` VALUES (2077, 245, '甘井子区', 3);
INSERT INTO `t_city` VALUES (2078, 245, '旅顺口区', 3);
INSERT INTO `t_city` VALUES (2079, 245, '金州区', 3);
INSERT INTO `t_city` VALUES (2080, 245, '开发区', 3);
INSERT INTO `t_city` VALUES (2081, 245, '瓦房店市', 3);
INSERT INTO `t_city` VALUES (2082, 245, '普兰店市', 3);
INSERT INTO `t_city` VALUES (2083, 245, '庄河市', 3);
INSERT INTO `t_city` VALUES (2084, 245, '长海县', 3);
INSERT INTO `t_city` VALUES (2085, 246, '铁东区', 3);
INSERT INTO `t_city` VALUES (2086, 246, '铁西区', 3);
INSERT INTO `t_city` VALUES (2087, 246, '立山区', 3);
INSERT INTO `t_city` VALUES (2088, 246, '千山区', 3);
INSERT INTO `t_city` VALUES (2089, 246, '岫岩', 3);
INSERT INTO `t_city` VALUES (2090, 246, '海城市', 3);
INSERT INTO `t_city` VALUES (2091, 246, '台安县', 3);
INSERT INTO `t_city` VALUES (2092, 247, '本溪', 3);
INSERT INTO `t_city` VALUES (2093, 247, '平山区', 3);
INSERT INTO `t_city` VALUES (2094, 247, '明山区', 3);
INSERT INTO `t_city` VALUES (2095, 247, '溪湖区', 3);
INSERT INTO `t_city` VALUES (2096, 247, '南芬区', 3);
INSERT INTO `t_city` VALUES (2097, 247, '桓仁', 3);
INSERT INTO `t_city` VALUES (2098, 248, '双塔区', 3);
INSERT INTO `t_city` VALUES (2099, 248, '龙城区', 3);
INSERT INTO `t_city` VALUES (2100, 248, '喀喇沁左翼蒙古族自治县', 3);
INSERT INTO `t_city` VALUES (2101, 248, '北票市', 3);
INSERT INTO `t_city` VALUES (2102, 248, '凌源市', 3);
INSERT INTO `t_city` VALUES (2103, 248, '朝阳县', 3);
INSERT INTO `t_city` VALUES (2104, 248, '建平县', 3);
INSERT INTO `t_city` VALUES (2105, 249, '振兴区', 3);
INSERT INTO `t_city` VALUES (2106, 249, '元宝区', 3);
INSERT INTO `t_city` VALUES (2107, 249, '振安区', 3);
INSERT INTO `t_city` VALUES (2108, 249, '宽甸', 3);
INSERT INTO `t_city` VALUES (2109, 249, '东港市', 3);
INSERT INTO `t_city` VALUES (2110, 249, '凤城市', 3);
INSERT INTO `t_city` VALUES (2111, 250, '顺城区', 3);
INSERT INTO `t_city` VALUES (2112, 250, '新抚区', 3);
INSERT INTO `t_city` VALUES (2113, 250, '东洲区', 3);
INSERT INTO `t_city` VALUES (2114, 250, '望花区', 3);
INSERT INTO `t_city` VALUES (2115, 250, '清原', 3);
INSERT INTO `t_city` VALUES (2116, 250, '新宾', 3);
INSERT INTO `t_city` VALUES (2117, 250, '抚顺县', 3);
INSERT INTO `t_city` VALUES (2118, 251, '阜新', 3);
INSERT INTO `t_city` VALUES (2119, 251, '海州区', 3);
INSERT INTO `t_city` VALUES (2120, 251, '新邱区', 3);
INSERT INTO `t_city` VALUES (2121, 251, '太平区', 3);
INSERT INTO `t_city` VALUES (2122, 251, '清河门区', 3);
INSERT INTO `t_city` VALUES (2123, 251, '细河区', 3);
INSERT INTO `t_city` VALUES (2124, 251, '彰武县', 3);
INSERT INTO `t_city` VALUES (2125, 252, '龙港区', 3);
INSERT INTO `t_city` VALUES (2126, 252, '南票区', 3);
INSERT INTO `t_city` VALUES (2127, 252, '连山区', 3);
INSERT INTO `t_city` VALUES (2128, 252, '兴城市', 3);
INSERT INTO `t_city` VALUES (2129, 252, '绥中县', 3);
INSERT INTO `t_city` VALUES (2130, 252, '建昌县', 3);
INSERT INTO `t_city` VALUES (2131, 253, '太和区', 3);
INSERT INTO `t_city` VALUES (2132, 253, '古塔区', 3);
INSERT INTO `t_city` VALUES (2133, 253, '凌河区', 3);
INSERT INTO `t_city` VALUES (2134, 253, '凌海市', 3);
INSERT INTO `t_city` VALUES (2135, 253, '北镇市', 3);
INSERT INTO `t_city` VALUES (2136, 253, '黑山县', 3);
INSERT INTO `t_city` VALUES (2137, 253, '义县', 3);
INSERT INTO `t_city` VALUES (2138, 254, '白塔区', 3);
INSERT INTO `t_city` VALUES (2139, 254, '文圣区', 3);
INSERT INTO `t_city` VALUES (2140, 254, '宏伟区', 3);
INSERT INTO `t_city` VALUES (2141, 254, '太子河区', 3);
INSERT INTO `t_city` VALUES (2142, 254, '弓长岭区', 3);
INSERT INTO `t_city` VALUES (2143, 254, '灯塔市', 3);
INSERT INTO `t_city` VALUES (2144, 254, '辽阳县', 3);
INSERT INTO `t_city` VALUES (2145, 255, '双台子区', 3);
INSERT INTO `t_city` VALUES (2146, 255, '兴隆台区', 3);
INSERT INTO `t_city` VALUES (2147, 255, '大洼县', 3);
INSERT INTO `t_city` VALUES (2148, 255, '盘山县', 3);
INSERT INTO `t_city` VALUES (2149, 256, '银州区', 3);
INSERT INTO `t_city` VALUES (2150, 256, '清河区', 3);
INSERT INTO `t_city` VALUES (2151, 256, '调兵山市', 3);
INSERT INTO `t_city` VALUES (2152, 256, '开原市', 3);
INSERT INTO `t_city` VALUES (2153, 256, '铁岭县', 3);
INSERT INTO `t_city` VALUES (2154, 256, '西丰县', 3);
INSERT INTO `t_city` VALUES (2155, 256, '昌图县', 3);
INSERT INTO `t_city` VALUES (2156, 257, '站前区', 3);
INSERT INTO `t_city` VALUES (2157, 257, '西市区', 3);
INSERT INTO `t_city` VALUES (2158, 257, '鲅鱼圈区', 3);
INSERT INTO `t_city` VALUES (2159, 257, '老边区', 3);
INSERT INTO `t_city` VALUES (2160, 257, '盖州市', 3);
INSERT INTO `t_city` VALUES (2161, 257, '大石桥市', 3);
INSERT INTO `t_city` VALUES (2162, 258, '回民区', 3);
INSERT INTO `t_city` VALUES (2163, 258, '玉泉区', 3);
INSERT INTO `t_city` VALUES (2164, 258, '新城区', 3);
INSERT INTO `t_city` VALUES (2165, 258, '赛罕区', 3);
INSERT INTO `t_city` VALUES (2166, 258, '清水河县', 3);
INSERT INTO `t_city` VALUES (2167, 258, '土默特左旗', 3);
INSERT INTO `t_city` VALUES (2168, 258, '托克托县', 3);
INSERT INTO `t_city` VALUES (2169, 258, '和林格尔县', 3);
INSERT INTO `t_city` VALUES (2170, 258, '武川县', 3);
INSERT INTO `t_city` VALUES (2171, 259, '阿拉善左旗', 3);
INSERT INTO `t_city` VALUES (2172, 259, '阿拉善右旗', 3);
INSERT INTO `t_city` VALUES (2173, 259, '额济纳旗', 3);
INSERT INTO `t_city` VALUES (2174, 260, '临河区', 3);
INSERT INTO `t_city` VALUES (2175, 260, '五原县', 3);
INSERT INTO `t_city` VALUES (2176, 260, '磴口县', 3);
INSERT INTO `t_city` VALUES (2177, 260, '乌拉特前旗', 3);
INSERT INTO `t_city` VALUES (2178, 260, '乌拉特中旗', 3);
INSERT INTO `t_city` VALUES (2179, 260, '乌拉特后旗', 3);
INSERT INTO `t_city` VALUES (2180, 260, '杭锦后旗', 3);
INSERT INTO `t_city` VALUES (2181, 261, '昆都仑区', 3);
INSERT INTO `t_city` VALUES (2182, 261, '青山区', 3);
INSERT INTO `t_city` VALUES (2183, 261, '东河区', 3);
INSERT INTO `t_city` VALUES (2184, 261, '九原区', 3);
INSERT INTO `t_city` VALUES (2185, 261, '石拐区', 3);
INSERT INTO `t_city` VALUES (2186, 261, '白云矿区', 3);
INSERT INTO `t_city` VALUES (2187, 261, '土默特右旗', 3);
INSERT INTO `t_city` VALUES (2188, 261, '固阳县', 3);
INSERT INTO `t_city` VALUES (2189, 261, '达尔罕茂明安联合旗', 3);
INSERT INTO `t_city` VALUES (2190, 262, '红山区', 3);
INSERT INTO `t_city` VALUES (2191, 262, '元宝山区', 3);
INSERT INTO `t_city` VALUES (2192, 262, '松山区', 3);
INSERT INTO `t_city` VALUES (2193, 262, '阿鲁科尔沁旗', 3);
INSERT INTO `t_city` VALUES (2194, 262, '巴林左旗', 3);
INSERT INTO `t_city` VALUES (2195, 262, '巴林右旗', 3);
INSERT INTO `t_city` VALUES (2196, 262, '林西县', 3);
INSERT INTO `t_city` VALUES (2197, 262, '克什克腾旗', 3);
INSERT INTO `t_city` VALUES (2198, 262, '翁牛特旗', 3);
INSERT INTO `t_city` VALUES (2199, 262, '喀喇沁旗', 3);
INSERT INTO `t_city` VALUES (2200, 262, '宁城县', 3);
INSERT INTO `t_city` VALUES (2201, 262, '敖汉旗', 3);
INSERT INTO `t_city` VALUES (2202, 263, '东胜区', 3);
INSERT INTO `t_city` VALUES (2203, 263, '达拉特旗', 3);
INSERT INTO `t_city` VALUES (2204, 263, '准格尔旗', 3);
INSERT INTO `t_city` VALUES (2205, 263, '鄂托克前旗', 3);
INSERT INTO `t_city` VALUES (2206, 263, '鄂托克旗', 3);
INSERT INTO `t_city` VALUES (2207, 263, '杭锦旗', 3);
INSERT INTO `t_city` VALUES (2208, 263, '乌审旗', 3);
INSERT INTO `t_city` VALUES (2209, 263, '伊金霍洛旗', 3);
INSERT INTO `t_city` VALUES (2210, 264, '海拉尔区', 3);
INSERT INTO `t_city` VALUES (2211, 264, '莫力达瓦', 3);
INSERT INTO `t_city` VALUES (2212, 264, '满洲里市', 3);
INSERT INTO `t_city` VALUES (2213, 264, '牙克石市', 3);
INSERT INTO `t_city` VALUES (2214, 264, '扎兰屯市', 3);
INSERT INTO `t_city` VALUES (2215, 264, '额尔古纳市', 3);
INSERT INTO `t_city` VALUES (2216, 264, '根河市', 3);
INSERT INTO `t_city` VALUES (2217, 264, '阿荣旗', 3);
INSERT INTO `t_city` VALUES (2218, 264, '鄂伦春自治旗', 3);
INSERT INTO `t_city` VALUES (2219, 264, '鄂温克族自治旗', 3);
INSERT INTO `t_city` VALUES (2220, 264, '陈巴尔虎旗', 3);
INSERT INTO `t_city` VALUES (2221, 264, '新巴尔虎左旗', 3);
INSERT INTO `t_city` VALUES (2222, 264, '新巴尔虎右旗', 3);
INSERT INTO `t_city` VALUES (2223, 265, '科尔沁区', 3);
INSERT INTO `t_city` VALUES (2224, 265, '霍林郭勒市', 3);
INSERT INTO `t_city` VALUES (2225, 265, '科尔沁左翼中旗', 3);
INSERT INTO `t_city` VALUES (2226, 265, '科尔沁左翼后旗', 3);
INSERT INTO `t_city` VALUES (2227, 265, '开鲁县', 3);
INSERT INTO `t_city` VALUES (2228, 265, '库伦旗', 3);
INSERT INTO `t_city` VALUES (2229, 265, '奈曼旗', 3);
INSERT INTO `t_city` VALUES (2230, 265, '扎鲁特旗', 3);
INSERT INTO `t_city` VALUES (2231, 266, '海勃湾区', 3);
INSERT INTO `t_city` VALUES (2232, 266, '乌达区', 3);
INSERT INTO `t_city` VALUES (2233, 266, '海南区', 3);
INSERT INTO `t_city` VALUES (2234, 267, '化德县', 3);
INSERT INTO `t_city` VALUES (2235, 267, '集宁区', 3);
INSERT INTO `t_city` VALUES (2236, 267, '丰镇市', 3);
INSERT INTO `t_city` VALUES (2237, 267, '卓资县', 3);
INSERT INTO `t_city` VALUES (2238, 267, '商都县', 3);
INSERT INTO `t_city` VALUES (2239, 267, '兴和县', 3);
INSERT INTO `t_city` VALUES (2240, 267, '凉城县', 3);
INSERT INTO `t_city` VALUES (2241, 267, '察哈尔右翼前旗', 3);
INSERT INTO `t_city` VALUES (2242, 267, '察哈尔右翼中旗', 3);
INSERT INTO `t_city` VALUES (2243, 267, '察哈尔右翼后旗', 3);
INSERT INTO `t_city` VALUES (2244, 267, '四子王旗', 3);
INSERT INTO `t_city` VALUES (2245, 268, '二连浩特市', 3);
INSERT INTO `t_city` VALUES (2246, 268, '锡林浩特市', 3);
INSERT INTO `t_city` VALUES (2247, 268, '阿巴嘎旗', 3);
INSERT INTO `t_city` VALUES (2248, 268, '苏尼特左旗', 3);
INSERT INTO `t_city` VALUES (2249, 268, '苏尼特右旗', 3);
INSERT INTO `t_city` VALUES (2250, 268, '东乌珠穆沁旗', 3);
INSERT INTO `t_city` VALUES (2251, 268, '西乌珠穆沁旗', 3);
INSERT INTO `t_city` VALUES (2252, 268, '太仆寺旗', 3);
INSERT INTO `t_city` VALUES (2253, 268, '镶黄旗', 3);
INSERT INTO `t_city` VALUES (2254, 268, '正镶白旗', 3);
INSERT INTO `t_city` VALUES (2255, 268, '正蓝旗', 3);
INSERT INTO `t_city` VALUES (2256, 268, '多伦县', 3);
INSERT INTO `t_city` VALUES (2257, 269, '乌兰浩特市', 3);
INSERT INTO `t_city` VALUES (2258, 269, '阿尔山市', 3);
INSERT INTO `t_city` VALUES (2259, 269, '科尔沁右翼前旗', 3);
INSERT INTO `t_city` VALUES (2260, 269, '科尔沁右翼中旗', 3);
INSERT INTO `t_city` VALUES (2261, 269, '扎赉特旗', 3);
INSERT INTO `t_city` VALUES (2262, 269, '突泉县', 3);
INSERT INTO `t_city` VALUES (2263, 270, '西夏区', 3);
INSERT INTO `t_city` VALUES (2264, 270, '金凤区', 3);
INSERT INTO `t_city` VALUES (2265, 270, '兴庆区', 3);
INSERT INTO `t_city` VALUES (2266, 270, '灵武市', 3);
INSERT INTO `t_city` VALUES (2267, 270, '永宁县', 3);
INSERT INTO `t_city` VALUES (2268, 270, '贺兰县', 3);
INSERT INTO `t_city` VALUES (2269, 271, '原州区', 3);
INSERT INTO `t_city` VALUES (2270, 271, '海原县', 3);
INSERT INTO `t_city` VALUES (2271, 271, '西吉县', 3);
INSERT INTO `t_city` VALUES (2272, 271, '隆德县', 3);
INSERT INTO `t_city` VALUES (2273, 271, '泾源县', 3);
INSERT INTO `t_city` VALUES (2274, 271, '彭阳县', 3);
INSERT INTO `t_city` VALUES (2275, 272, '惠农县', 3);
INSERT INTO `t_city` VALUES (2276, 272, '大武口区', 3);
INSERT INTO `t_city` VALUES (2277, 272, '惠农区', 3);
INSERT INTO `t_city` VALUES (2278, 272, '陶乐县', 3);
INSERT INTO `t_city` VALUES (2279, 272, '平罗县', 3);
INSERT INTO `t_city` VALUES (2280, 273, '利通区', 3);
INSERT INTO `t_city` VALUES (2281, 273, '中卫县', 3);
INSERT INTO `t_city` VALUES (2282, 273, '青铜峡市', 3);
INSERT INTO `t_city` VALUES (2283, 273, '中宁县', 3);
INSERT INTO `t_city` VALUES (2284, 273, '盐池县', 3);
INSERT INTO `t_city` VALUES (2285, 273, '同心县', 3);
INSERT INTO `t_city` VALUES (2286, 274, '沙坡头区', 3);
INSERT INTO `t_city` VALUES (2287, 274, '海原县', 3);
INSERT INTO `t_city` VALUES (2288, 274, '中宁县', 3);
INSERT INTO `t_city` VALUES (2289, 275, '城中区', 3);
INSERT INTO `t_city` VALUES (2290, 275, '城东区', 3);
INSERT INTO `t_city` VALUES (2291, 275, '城西区', 3);
INSERT INTO `t_city` VALUES (2292, 275, '城北区', 3);
INSERT INTO `t_city` VALUES (2293, 275, '湟中县', 3);
INSERT INTO `t_city` VALUES (2294, 275, '湟源县', 3);
INSERT INTO `t_city` VALUES (2295, 275, '大通', 3);
INSERT INTO `t_city` VALUES (2296, 276, '玛沁县', 3);
INSERT INTO `t_city` VALUES (2297, 276, '班玛县', 3);
INSERT INTO `t_city` VALUES (2298, 276, '甘德县', 3);
INSERT INTO `t_city` VALUES (2299, 276, '达日县', 3);
INSERT INTO `t_city` VALUES (2300, 276, '久治县', 3);
INSERT INTO `t_city` VALUES (2301, 276, '玛多县', 3);
INSERT INTO `t_city` VALUES (2302, 277, '海晏县', 3);
INSERT INTO `t_city` VALUES (2303, 277, '祁连县', 3);
INSERT INTO `t_city` VALUES (2304, 277, '刚察县', 3);
INSERT INTO `t_city` VALUES (2305, 277, '门源', 3);
INSERT INTO `t_city` VALUES (2306, 278, '平安县', 3);
INSERT INTO `t_city` VALUES (2307, 278, '乐都县', 3);
INSERT INTO `t_city` VALUES (2308, 278, '民和', 3);
INSERT INTO `t_city` VALUES (2309, 278, '互助', 3);
INSERT INTO `t_city` VALUES (2310, 278, '化隆', 3);
INSERT INTO `t_city` VALUES (2311, 278, '循化', 3);
INSERT INTO `t_city` VALUES (2312, 279, '共和县', 3);
INSERT INTO `t_city` VALUES (2313, 279, '同德县', 3);
INSERT INTO `t_city` VALUES (2314, 279, '贵德县', 3);
INSERT INTO `t_city` VALUES (2315, 279, '兴海县', 3);
INSERT INTO `t_city` VALUES (2316, 279, '贵南县', 3);
INSERT INTO `t_city` VALUES (2317, 280, '德令哈市', 3);
INSERT INTO `t_city` VALUES (2318, 280, '格尔木市', 3);
INSERT INTO `t_city` VALUES (2319, 280, '乌兰县', 3);
INSERT INTO `t_city` VALUES (2320, 280, '都兰县', 3);
INSERT INTO `t_city` VALUES (2321, 280, '天峻县', 3);
INSERT INTO `t_city` VALUES (2322, 281, '同仁县', 3);
INSERT INTO `t_city` VALUES (2323, 281, '尖扎县', 3);
INSERT INTO `t_city` VALUES (2324, 281, '泽库县', 3);
INSERT INTO `t_city` VALUES (2325, 281, '河南蒙古族自治县', 3);
INSERT INTO `t_city` VALUES (2326, 282, '玉树县', 3);
INSERT INTO `t_city` VALUES (2327, 282, '杂多县', 3);
INSERT INTO `t_city` VALUES (2328, 282, '称多县', 3);
INSERT INTO `t_city` VALUES (2329, 282, '治多县', 3);
INSERT INTO `t_city` VALUES (2330, 282, '囊谦县', 3);
INSERT INTO `t_city` VALUES (2331, 282, '曲麻莱县', 3);
INSERT INTO `t_city` VALUES (2332, 283, '市中区', 3);
INSERT INTO `t_city` VALUES (2333, 283, '历下区', 3);
INSERT INTO `t_city` VALUES (2334, 283, '天桥区', 3);
INSERT INTO `t_city` VALUES (2335, 283, '槐荫区', 3);
INSERT INTO `t_city` VALUES (2336, 283, '历城区', 3);
INSERT INTO `t_city` VALUES (2337, 283, '长清区', 3);
INSERT INTO `t_city` VALUES (2338, 283, '章丘市', 3);
INSERT INTO `t_city` VALUES (2339, 283, '平阴县', 3);
INSERT INTO `t_city` VALUES (2340, 283, '济阳县', 3);
INSERT INTO `t_city` VALUES (2341, 283, '商河县', 3);
INSERT INTO `t_city` VALUES (2342, 284, '市南区', 3);
INSERT INTO `t_city` VALUES (2343, 284, '市北区', 3);
INSERT INTO `t_city` VALUES (2344, 284, '城阳区', 3);
INSERT INTO `t_city` VALUES (2345, 284, '四方区', 3);
INSERT INTO `t_city` VALUES (2346, 284, '李沧区', 3);
INSERT INTO `t_city` VALUES (2347, 284, '黄岛区', 3);
INSERT INTO `t_city` VALUES (2348, 284, '崂山区', 3);
INSERT INTO `t_city` VALUES (2349, 284, '胶州市', 3);
INSERT INTO `t_city` VALUES (2350, 284, '即墨市', 3);
INSERT INTO `t_city` VALUES (2351, 284, '平度市', 3);
INSERT INTO `t_city` VALUES (2352, 284, '胶南市', 3);
INSERT INTO `t_city` VALUES (2353, 284, '莱西市', 3);
INSERT INTO `t_city` VALUES (2354, 285, '滨城区', 3);
INSERT INTO `t_city` VALUES (2355, 285, '惠民县', 3);
INSERT INTO `t_city` VALUES (2356, 285, '阳信县', 3);
INSERT INTO `t_city` VALUES (2357, 285, '无棣县', 3);
INSERT INTO `t_city` VALUES (2358, 285, '沾化县', 3);
INSERT INTO `t_city` VALUES (2359, 285, '博兴县', 3);
INSERT INTO `t_city` VALUES (2360, 285, '邹平县', 3);
INSERT INTO `t_city` VALUES (2361, 286, '德城区', 3);
INSERT INTO `t_city` VALUES (2362, 286, '陵县', 3);
INSERT INTO `t_city` VALUES (2363, 286, '乐陵市', 3);
INSERT INTO `t_city` VALUES (2364, 286, '禹城市', 3);
INSERT INTO `t_city` VALUES (2365, 286, '宁津县', 3);
INSERT INTO `t_city` VALUES (2366, 286, '庆云县', 3);
INSERT INTO `t_city` VALUES (2367, 286, '临邑县', 3);
INSERT INTO `t_city` VALUES (2368, 286, '齐河县', 3);
INSERT INTO `t_city` VALUES (2369, 286, '平原县', 3);
INSERT INTO `t_city` VALUES (2370, 286, '夏津县', 3);
INSERT INTO `t_city` VALUES (2371, 286, '武城县', 3);
INSERT INTO `t_city` VALUES (2372, 287, '东营区', 3);
INSERT INTO `t_city` VALUES (2373, 287, '河口区', 3);
INSERT INTO `t_city` VALUES (2374, 287, '垦利县', 3);
INSERT INTO `t_city` VALUES (2375, 287, '利津县', 3);
INSERT INTO `t_city` VALUES (2376, 287, '广饶县', 3);
INSERT INTO `t_city` VALUES (2377, 288, '牡丹区', 3);
INSERT INTO `t_city` VALUES (2378, 288, '曹县', 3);
INSERT INTO `t_city` VALUES (2379, 288, '单县', 3);
INSERT INTO `t_city` VALUES (2380, 288, '成武县', 3);
INSERT INTO `t_city` VALUES (2381, 288, '巨野县', 3);
INSERT INTO `t_city` VALUES (2382, 288, '郓城县', 3);
INSERT INTO `t_city` VALUES (2383, 288, '鄄城县', 3);
INSERT INTO `t_city` VALUES (2384, 288, '定陶县', 3);
INSERT INTO `t_city` VALUES (2385, 288, '东明县', 3);
INSERT INTO `t_city` VALUES (2386, 289, '市中区', 3);
INSERT INTO `t_city` VALUES (2387, 289, '任城区', 3);
INSERT INTO `t_city` VALUES (2388, 289, '曲阜市', 3);
INSERT INTO `t_city` VALUES (2389, 289, '兖州市', 3);
INSERT INTO `t_city` VALUES (2390, 289, '邹城市', 3);
INSERT INTO `t_city` VALUES (2391, 289, '微山县', 3);
INSERT INTO `t_city` VALUES (2392, 289, '鱼台县', 3);
INSERT INTO `t_city` VALUES (2393, 289, '金乡县', 3);
INSERT INTO `t_city` VALUES (2394, 289, '嘉祥县', 3);
INSERT INTO `t_city` VALUES (2395, 289, '汶上县', 3);
INSERT INTO `t_city` VALUES (2396, 289, '泗水县', 3);
INSERT INTO `t_city` VALUES (2397, 289, '梁山县', 3);
INSERT INTO `t_city` VALUES (2398, 290, '莱城区', 3);
INSERT INTO `t_city` VALUES (2399, 290, '钢城区', 3);
INSERT INTO `t_city` VALUES (2400, 291, '东昌府区', 3);
INSERT INTO `t_city` VALUES (2401, 291, '临清市', 3);
INSERT INTO `t_city` VALUES (2402, 291, '阳谷县', 3);
INSERT INTO `t_city` VALUES (2403, 291, '莘县', 3);
INSERT INTO `t_city` VALUES (2404, 291, '茌平县', 3);
INSERT INTO `t_city` VALUES (2405, 291, '东阿县', 3);
INSERT INTO `t_city` VALUES (2406, 291, '冠县', 3);
INSERT INTO `t_city` VALUES (2407, 291, '高唐县', 3);
INSERT INTO `t_city` VALUES (2408, 292, '兰山区', 3);
INSERT INTO `t_city` VALUES (2409, 292, '罗庄区', 3);
INSERT INTO `t_city` VALUES (2410, 292, '河东区', 3);
INSERT INTO `t_city` VALUES (2411, 292, '沂南县', 3);
INSERT INTO `t_city` VALUES (2412, 292, '郯城县', 3);
INSERT INTO `t_city` VALUES (2413, 292, '沂水县', 3);
INSERT INTO `t_city` VALUES (2414, 292, '苍山县', 3);
INSERT INTO `t_city` VALUES (2415, 292, '费县', 3);
INSERT INTO `t_city` VALUES (2416, 292, '平邑县', 3);
INSERT INTO `t_city` VALUES (2417, 292, '莒南县', 3);
INSERT INTO `t_city` VALUES (2418, 292, '蒙阴县', 3);
INSERT INTO `t_city` VALUES (2419, 292, '临沭县', 3);
INSERT INTO `t_city` VALUES (2420, 293, '东港区', 3);
INSERT INTO `t_city` VALUES (2421, 293, '岚山区', 3);
INSERT INTO `t_city` VALUES (2422, 293, '五莲县', 3);
INSERT INTO `t_city` VALUES (2423, 293, '莒县', 3);
INSERT INTO `t_city` VALUES (2424, 294, '泰山区', 3);
INSERT INTO `t_city` VALUES (2425, 294, '岱岳区', 3);
INSERT INTO `t_city` VALUES (2426, 294, '新泰市', 3);
INSERT INTO `t_city` VALUES (2427, 294, '肥城市', 3);
INSERT INTO `t_city` VALUES (2428, 294, '宁阳县', 3);
INSERT INTO `t_city` VALUES (2429, 294, '东平县', 3);
INSERT INTO `t_city` VALUES (2430, 295, '荣成市', 3);
INSERT INTO `t_city` VALUES (2431, 295, '乳山市', 3);
INSERT INTO `t_city` VALUES (2432, 295, '环翠区', 3);
INSERT INTO `t_city` VALUES (2433, 295, '文登市', 3);
INSERT INTO `t_city` VALUES (2434, 296, '潍城区', 3);
INSERT INTO `t_city` VALUES (2435, 296, '寒亭区', 3);
INSERT INTO `t_city` VALUES (2436, 296, '坊子区', 3);
INSERT INTO `t_city` VALUES (2437, 296, '奎文区', 3);
INSERT INTO `t_city` VALUES (2438, 296, '青州市', 3);
INSERT INTO `t_city` VALUES (2439, 296, '诸城市', 3);
INSERT INTO `t_city` VALUES (2440, 296, '寿光市', 3);
INSERT INTO `t_city` VALUES (2441, 296, '安丘市', 3);
INSERT INTO `t_city` VALUES (2442, 296, '高密市', 3);
INSERT INTO `t_city` VALUES (2443, 296, '昌邑市', 3);
INSERT INTO `t_city` VALUES (2444, 296, '临朐县', 3);
INSERT INTO `t_city` VALUES (2445, 296, '昌乐县', 3);
INSERT INTO `t_city` VALUES (2446, 297, '芝罘区', 3);
INSERT INTO `t_city` VALUES (2447, 297, '福山区', 3);
INSERT INTO `t_city` VALUES (2448, 297, '牟平区', 3);
INSERT INTO `t_city` VALUES (2449, 297, '莱山区', 3);
INSERT INTO `t_city` VALUES (2450, 297, '开发区', 3);
INSERT INTO `t_city` VALUES (2451, 297, '龙口市', 3);
INSERT INTO `t_city` VALUES (2452, 297, '莱阳市', 3);
INSERT INTO `t_city` VALUES (2453, 297, '莱州市', 3);
INSERT INTO `t_city` VALUES (2454, 297, '蓬莱市', 3);
INSERT INTO `t_city` VALUES (2455, 297, '招远市', 3);
INSERT INTO `t_city` VALUES (2456, 297, '栖霞市', 3);
INSERT INTO `t_city` VALUES (2457, 297, '海阳市', 3);
INSERT INTO `t_city` VALUES (2458, 297, '长岛县', 3);
INSERT INTO `t_city` VALUES (2459, 298, '市中区', 3);
INSERT INTO `t_city` VALUES (2460, 298, '山亭区', 3);
INSERT INTO `t_city` VALUES (2461, 298, '峄城区', 3);
INSERT INTO `t_city` VALUES (2462, 298, '台儿庄区', 3);
INSERT INTO `t_city` VALUES (2463, 298, '薛城区', 3);
INSERT INTO `t_city` VALUES (2464, 298, '滕州市', 3);
INSERT INTO `t_city` VALUES (2465, 299, '张店区', 3);
INSERT INTO `t_city` VALUES (2466, 299, '临淄区', 3);
INSERT INTO `t_city` VALUES (2467, 299, '淄川区', 3);
INSERT INTO `t_city` VALUES (2468, 299, '博山区', 3);
INSERT INTO `t_city` VALUES (2469, 299, '周村区', 3);
INSERT INTO `t_city` VALUES (2470, 299, '桓台县', 3);
INSERT INTO `t_city` VALUES (2471, 299, '高青县', 3);
INSERT INTO `t_city` VALUES (2472, 299, '沂源县', 3);
INSERT INTO `t_city` VALUES (2473, 300, '杏花岭区', 3);
INSERT INTO `t_city` VALUES (2474, 300, '小店区', 3);
INSERT INTO `t_city` VALUES (2475, 300, '迎泽区', 3);
INSERT INTO `t_city` VALUES (2476, 300, '尖草坪区', 3);
INSERT INTO `t_city` VALUES (2477, 300, '万柏林区', 3);
INSERT INTO `t_city` VALUES (2478, 300, '晋源区', 3);
INSERT INTO `t_city` VALUES (2479, 300, '高新开发区', 3);
INSERT INTO `t_city` VALUES (2480, 300, '民营经济开发区', 3);
INSERT INTO `t_city` VALUES (2481, 300, '经济技术开发区', 3);
INSERT INTO `t_city` VALUES (2482, 300, '清徐县', 3);
INSERT INTO `t_city` VALUES (2483, 300, '阳曲县', 3);
INSERT INTO `t_city` VALUES (2484, 300, '娄烦县', 3);
INSERT INTO `t_city` VALUES (2485, 300, '古交市', 3);
INSERT INTO `t_city` VALUES (2486, 301, '城区', 3);
INSERT INTO `t_city` VALUES (2487, 301, '郊区', 3);
INSERT INTO `t_city` VALUES (2488, 301, '沁县', 3);
INSERT INTO `t_city` VALUES (2489, 301, '潞城市', 3);
INSERT INTO `t_city` VALUES (2490, 301, '长治县', 3);
INSERT INTO `t_city` VALUES (2491, 301, '襄垣县', 3);
INSERT INTO `t_city` VALUES (2492, 301, '屯留县', 3);
INSERT INTO `t_city` VALUES (2493, 301, '平顺县', 3);
INSERT INTO `t_city` VALUES (2494, 301, '黎城县', 3);
INSERT INTO `t_city` VALUES (2495, 301, '壶关县', 3);
INSERT INTO `t_city` VALUES (2496, 301, '长子县', 3);
INSERT INTO `t_city` VALUES (2497, 301, '武乡县', 3);
INSERT INTO `t_city` VALUES (2498, 301, '沁源县', 3);
INSERT INTO `t_city` VALUES (2499, 302, '城区', 3);
INSERT INTO `t_city` VALUES (2500, 302, '矿区', 3);
INSERT INTO `t_city` VALUES (2501, 302, '南郊区', 3);
INSERT INTO `t_city` VALUES (2502, 302, '新荣区', 3);
INSERT INTO `t_city` VALUES (2503, 302, '阳高县', 3);
INSERT INTO `t_city` VALUES (2504, 302, '天镇县', 3);
INSERT INTO `t_city` VALUES (2505, 302, '广灵县', 3);
INSERT INTO `t_city` VALUES (2506, 302, '灵丘县', 3);
INSERT INTO `t_city` VALUES (2507, 302, '浑源县', 3);
INSERT INTO `t_city` VALUES (2508, 302, '左云县', 3);
INSERT INTO `t_city` VALUES (2509, 302, '大同县', 3);
INSERT INTO `t_city` VALUES (2510, 303, '城区', 3);
INSERT INTO `t_city` VALUES (2511, 303, '高平市', 3);
INSERT INTO `t_city` VALUES (2512, 303, '沁水县', 3);
INSERT INTO `t_city` VALUES (2513, 303, '阳城县', 3);
INSERT INTO `t_city` VALUES (2514, 303, '陵川县', 3);
INSERT INTO `t_city` VALUES (2515, 303, '泽州县', 3);
INSERT INTO `t_city` VALUES (2516, 304, '榆次区', 3);
INSERT INTO `t_city` VALUES (2517, 304, '介休市', 3);
INSERT INTO `t_city` VALUES (2518, 304, '榆社县', 3);
INSERT INTO `t_city` VALUES (2519, 304, '左权县', 3);
INSERT INTO `t_city` VALUES (2520, 304, '和顺县', 3);
INSERT INTO `t_city` VALUES (2521, 304, '昔阳县', 3);
INSERT INTO `t_city` VALUES (2522, 304, '寿阳县', 3);
INSERT INTO `t_city` VALUES (2523, 304, '太谷县', 3);
INSERT INTO `t_city` VALUES (2524, 304, '祁县', 3);
INSERT INTO `t_city` VALUES (2525, 304, '平遥县', 3);
INSERT INTO `t_city` VALUES (2526, 304, '灵石县', 3);
INSERT INTO `t_city` VALUES (2527, 305, '尧都区', 3);
INSERT INTO `t_city` VALUES (2528, 305, '侯马市', 3);
INSERT INTO `t_city` VALUES (2529, 305, '霍州市', 3);
INSERT INTO `t_city` VALUES (2530, 305, '曲沃县', 3);
INSERT INTO `t_city` VALUES (2531, 305, '翼城县', 3);
INSERT INTO `t_city` VALUES (2532, 305, '襄汾县', 3);
INSERT INTO `t_city` VALUES (2533, 305, '洪洞县', 3);
INSERT INTO `t_city` VALUES (2534, 305, '吉县', 3);
INSERT INTO `t_city` VALUES (2535, 305, '安泽县', 3);
INSERT INTO `t_city` VALUES (2536, 305, '浮山县', 3);
INSERT INTO `t_city` VALUES (2537, 305, '古县', 3);
INSERT INTO `t_city` VALUES (2538, 305, '乡宁县', 3);
INSERT INTO `t_city` VALUES (2539, 305, '大宁县', 3);
INSERT INTO `t_city` VALUES (2540, 305, '隰县', 3);
INSERT INTO `t_city` VALUES (2541, 305, '永和县', 3);
INSERT INTO `t_city` VALUES (2542, 305, '蒲县', 3);
INSERT INTO `t_city` VALUES (2543, 305, '汾西县', 3);
INSERT INTO `t_city` VALUES (2544, 306, '离石市', 3);
INSERT INTO `t_city` VALUES (2545, 306, '离石区', 3);
INSERT INTO `t_city` VALUES (2546, 306, '孝义市', 3);
INSERT INTO `t_city` VALUES (2547, 306, '汾阳市', 3);
INSERT INTO `t_city` VALUES (2548, 306, '文水县', 3);
INSERT INTO `t_city` VALUES (2549, 306, '交城县', 3);
INSERT INTO `t_city` VALUES (2550, 306, '兴县', 3);
INSERT INTO `t_city` VALUES (2551, 306, '临县', 3);
INSERT INTO `t_city` VALUES (2552, 306, '柳林县', 3);
INSERT INTO `t_city` VALUES (2553, 306, '石楼县', 3);
INSERT INTO `t_city` VALUES (2554, 306, '岚县', 3);
INSERT INTO `t_city` VALUES (2555, 306, '方山县', 3);
INSERT INTO `t_city` VALUES (2556, 306, '中阳县', 3);
INSERT INTO `t_city` VALUES (2557, 306, '交口县', 3);
INSERT INTO `t_city` VALUES (2558, 307, '朔城区', 3);
INSERT INTO `t_city` VALUES (2559, 307, '平鲁区', 3);
INSERT INTO `t_city` VALUES (2560, 307, '山阴县', 3);
INSERT INTO `t_city` VALUES (2561, 307, '应县', 3);
INSERT INTO `t_city` VALUES (2562, 307, '右玉县', 3);
INSERT INTO `t_city` VALUES (2563, 307, '怀仁县', 3);
INSERT INTO `t_city` VALUES (2564, 308, '忻府区', 3);
INSERT INTO `t_city` VALUES (2565, 308, '原平市', 3);
INSERT INTO `t_city` VALUES (2566, 308, '定襄县', 3);
INSERT INTO `t_city` VALUES (2567, 308, '五台县', 3);
INSERT INTO `t_city` VALUES (2568, 308, '代县', 3);
INSERT INTO `t_city` VALUES (2569, 308, '繁峙县', 3);
INSERT INTO `t_city` VALUES (2570, 308, '宁武县', 3);
INSERT INTO `t_city` VALUES (2571, 308, '静乐县', 3);
INSERT INTO `t_city` VALUES (2572, 308, '神池县', 3);
INSERT INTO `t_city` VALUES (2573, 308, '五寨县', 3);
INSERT INTO `t_city` VALUES (2574, 308, '岢岚县', 3);
INSERT INTO `t_city` VALUES (2575, 308, '河曲县', 3);
INSERT INTO `t_city` VALUES (2576, 308, '保德县', 3);
INSERT INTO `t_city` VALUES (2577, 308, '偏关县', 3);
INSERT INTO `t_city` VALUES (2578, 309, '城区', 3);
INSERT INTO `t_city` VALUES (2579, 309, '矿区', 3);
INSERT INTO `t_city` VALUES (2580, 309, '郊区', 3);
INSERT INTO `t_city` VALUES (2581, 309, '平定县', 3);
INSERT INTO `t_city` VALUES (2582, 309, '盂县', 3);
INSERT INTO `t_city` VALUES (2583, 310, '盐湖区', 3);
INSERT INTO `t_city` VALUES (2584, 310, '永济市', 3);
INSERT INTO `t_city` VALUES (2585, 310, '河津市', 3);
INSERT INTO `t_city` VALUES (2586, 310, '临猗县', 3);
INSERT INTO `t_city` VALUES (2587, 310, '万荣县', 3);
INSERT INTO `t_city` VALUES (2588, 310, '闻喜县', 3);
INSERT INTO `t_city` VALUES (2589, 310, '稷山县', 3);
INSERT INTO `t_city` VALUES (2590, 310, '新绛县', 3);
INSERT INTO `t_city` VALUES (2591, 310, '绛县', 3);
INSERT INTO `t_city` VALUES (2592, 310, '垣曲县', 3);
INSERT INTO `t_city` VALUES (2593, 310, '夏县', 3);
INSERT INTO `t_city` VALUES (2594, 310, '平陆县', 3);
INSERT INTO `t_city` VALUES (2595, 310, '芮城县', 3);
INSERT INTO `t_city` VALUES (2596, 311, '莲湖区', 3);
INSERT INTO `t_city` VALUES (2597, 311, '新城区', 3);
INSERT INTO `t_city` VALUES (2598, 311, '碑林区', 3);
INSERT INTO `t_city` VALUES (2599, 311, '雁塔区', 3);
INSERT INTO `t_city` VALUES (2600, 311, '灞桥区', 3);
INSERT INTO `t_city` VALUES (2601, 311, '未央区', 3);
INSERT INTO `t_city` VALUES (2602, 311, '阎良区', 3);
INSERT INTO `t_city` VALUES (2603, 311, '临潼区', 3);
INSERT INTO `t_city` VALUES (2604, 311, '长安区', 3);
INSERT INTO `t_city` VALUES (2605, 311, '蓝田县', 3);
INSERT INTO `t_city` VALUES (2606, 311, '周至县', 3);
INSERT INTO `t_city` VALUES (2607, 311, '户县', 3);
INSERT INTO `t_city` VALUES (2608, 311, '高陵县', 3);
INSERT INTO `t_city` VALUES (2609, 312, '汉滨区', 3);
INSERT INTO `t_city` VALUES (2610, 312, '汉阴县', 3);
INSERT INTO `t_city` VALUES (2611, 312, '石泉县', 3);
INSERT INTO `t_city` VALUES (2612, 312, '宁陕县', 3);
INSERT INTO `t_city` VALUES (2613, 312, '紫阳县', 3);
INSERT INTO `t_city` VALUES (2614, 312, '岚皋县', 3);
INSERT INTO `t_city` VALUES (2615, 312, '平利县', 3);
INSERT INTO `t_city` VALUES (2616, 312, '镇坪县', 3);
INSERT INTO `t_city` VALUES (2617, 312, '旬阳县', 3);
INSERT INTO `t_city` VALUES (2618, 312, '白河县', 3);
INSERT INTO `t_city` VALUES (2619, 313, '陈仓区', 3);
INSERT INTO `t_city` VALUES (2620, 313, '渭滨区', 3);
INSERT INTO `t_city` VALUES (2621, 313, '金台区', 3);
INSERT INTO `t_city` VALUES (2622, 313, '凤翔县', 3);
INSERT INTO `t_city` VALUES (2623, 313, '岐山县', 3);
INSERT INTO `t_city` VALUES (2624, 313, '扶风县', 3);
INSERT INTO `t_city` VALUES (2625, 313, '眉县', 3);
INSERT INTO `t_city` VALUES (2626, 313, '陇县', 3);
INSERT INTO `t_city` VALUES (2627, 313, '千阳县', 3);
INSERT INTO `t_city` VALUES (2628, 313, '麟游县', 3);
INSERT INTO `t_city` VALUES (2629, 313, '凤县', 3);
INSERT INTO `t_city` VALUES (2630, 313, '太白县', 3);
INSERT INTO `t_city` VALUES (2631, 314, '汉台区', 3);
INSERT INTO `t_city` VALUES (2632, 314, '南郑县', 3);
INSERT INTO `t_city` VALUES (2633, 314, '城固县', 3);
INSERT INTO `t_city` VALUES (2634, 314, '洋县', 3);
INSERT INTO `t_city` VALUES (2635, 314, '西乡县', 3);
INSERT INTO `t_city` VALUES (2636, 314, '勉县', 3);
INSERT INTO `t_city` VALUES (2637, 314, '宁强县', 3);
INSERT INTO `t_city` VALUES (2638, 314, '略阳县', 3);
INSERT INTO `t_city` VALUES (2639, 314, '镇巴县', 3);
INSERT INTO `t_city` VALUES (2640, 314, '留坝县', 3);
INSERT INTO `t_city` VALUES (2641, 314, '佛坪县', 3);
INSERT INTO `t_city` VALUES (2642, 315, '商州区', 3);
INSERT INTO `t_city` VALUES (2643, 315, '洛南县', 3);
INSERT INTO `t_city` VALUES (2644, 315, '丹凤县', 3);
INSERT INTO `t_city` VALUES (2645, 315, '商南县', 3);
INSERT INTO `t_city` VALUES (2646, 315, '山阳县', 3);
INSERT INTO `t_city` VALUES (2647, 315, '镇安县', 3);
INSERT INTO `t_city` VALUES (2648, 315, '柞水县', 3);
INSERT INTO `t_city` VALUES (2649, 316, '耀州区', 3);
INSERT INTO `t_city` VALUES (2650, 316, '王益区', 3);
INSERT INTO `t_city` VALUES (2651, 316, '印台区', 3);
INSERT INTO `t_city` VALUES (2652, 316, '宜君县', 3);
INSERT INTO `t_city` VALUES (2653, 317, '临渭区', 3);
INSERT INTO `t_city` VALUES (2654, 317, '韩城市', 3);
INSERT INTO `t_city` VALUES (2655, 317, '华阴市', 3);
INSERT INTO `t_city` VALUES (2656, 317, '华县', 3);
INSERT INTO `t_city` VALUES (2657, 317, '潼关县', 3);
INSERT INTO `t_city` VALUES (2658, 317, '大荔县', 3);
INSERT INTO `t_city` VALUES (2659, 317, '合阳县', 3);
INSERT INTO `t_city` VALUES (2660, 317, '澄城县', 3);
INSERT INTO `t_city` VALUES (2661, 317, '蒲城县', 3);
INSERT INTO `t_city` VALUES (2662, 317, '白水县', 3);
INSERT INTO `t_city` VALUES (2663, 317, '富平县', 3);
INSERT INTO `t_city` VALUES (2664, 318, '秦都区', 3);
INSERT INTO `t_city` VALUES (2665, 318, '渭城区', 3);
INSERT INTO `t_city` VALUES (2666, 318, '杨陵区', 3);
INSERT INTO `t_city` VALUES (2667, 318, '兴平市', 3);
INSERT INTO `t_city` VALUES (2668, 318, '三原县', 3);
INSERT INTO `t_city` VALUES (2669, 318, '泾阳县', 3);
INSERT INTO `t_city` VALUES (2670, 318, '乾县', 3);
INSERT INTO `t_city` VALUES (2671, 318, '礼泉县', 3);
INSERT INTO `t_city` VALUES (2672, 318, '永寿县', 3);
INSERT INTO `t_city` VALUES (2673, 318, '彬县', 3);
INSERT INTO `t_city` VALUES (2674, 318, '长武县', 3);
INSERT INTO `t_city` VALUES (2675, 318, '旬邑县', 3);
INSERT INTO `t_city` VALUES (2676, 318, '淳化县', 3);
INSERT INTO `t_city` VALUES (2677, 318, '武功县', 3);
INSERT INTO `t_city` VALUES (2678, 319, '吴起县', 3);
INSERT INTO `t_city` VALUES (2679, 319, '宝塔区', 3);
INSERT INTO `t_city` VALUES (2680, 319, '延长县', 3);
INSERT INTO `t_city` VALUES (2681, 319, '延川县', 3);
INSERT INTO `t_city` VALUES (2682, 319, '子长县', 3);
INSERT INTO `t_city` VALUES (2683, 319, '安塞县', 3);
INSERT INTO `t_city` VALUES (2684, 319, '志丹县', 3);
INSERT INTO `t_city` VALUES (2685, 319, '甘泉县', 3);
INSERT INTO `t_city` VALUES (2686, 319, '富县', 3);
INSERT INTO `t_city` VALUES (2687, 319, '洛川县', 3);
INSERT INTO `t_city` VALUES (2688, 319, '宜川县', 3);
INSERT INTO `t_city` VALUES (2689, 319, '黄龙县', 3);
INSERT INTO `t_city` VALUES (2690, 319, '黄陵县', 3);
INSERT INTO `t_city` VALUES (2691, 320, '榆阳区', 3);
INSERT INTO `t_city` VALUES (2692, 320, '神木县', 3);
INSERT INTO `t_city` VALUES (2693, 320, '府谷县', 3);
INSERT INTO `t_city` VALUES (2694, 320, '横山县', 3);
INSERT INTO `t_city` VALUES (2695, 320, '靖边县', 3);
INSERT INTO `t_city` VALUES (2696, 320, '定边县', 3);
INSERT INTO `t_city` VALUES (2697, 320, '绥德县', 3);
INSERT INTO `t_city` VALUES (2698, 320, '米脂县', 3);
INSERT INTO `t_city` VALUES (2699, 320, '佳县', 3);
INSERT INTO `t_city` VALUES (2700, 320, '吴堡县', 3);
INSERT INTO `t_city` VALUES (2701, 320, '清涧县', 3);
INSERT INTO `t_city` VALUES (2702, 320, '子洲县', 3);
INSERT INTO `t_city` VALUES (2703, 321, '长宁区', 3);
INSERT INTO `t_city` VALUES (2704, 321, '闸北区', 3);
INSERT INTO `t_city` VALUES (2705, 321, '闵行区', 3);
INSERT INTO `t_city` VALUES (2706, 321, '徐汇区', 3);
INSERT INTO `t_city` VALUES (2707, 321, '浦东新区', 3);
INSERT INTO `t_city` VALUES (2708, 321, '杨浦区', 3);
INSERT INTO `t_city` VALUES (2709, 321, '普陀区', 3);
INSERT INTO `t_city` VALUES (2710, 321, '静安区', 3);
INSERT INTO `t_city` VALUES (2711, 321, '卢湾区', 3);
INSERT INTO `t_city` VALUES (2712, 321, '虹口区', 3);
INSERT INTO `t_city` VALUES (2713, 321, '黄浦区', 3);
INSERT INTO `t_city` VALUES (2714, 321, '南汇区', 3);
INSERT INTO `t_city` VALUES (2715, 321, '松江区', 3);
INSERT INTO `t_city` VALUES (2716, 321, '嘉定区', 3);
INSERT INTO `t_city` VALUES (2717, 321, '宝山区', 3);
INSERT INTO `t_city` VALUES (2718, 321, '青浦区', 3);
INSERT INTO `t_city` VALUES (2719, 321, '金山区', 3);
INSERT INTO `t_city` VALUES (2720, 321, '奉贤区', 3);
INSERT INTO `t_city` VALUES (2721, 321, '崇明县', 3);
INSERT INTO `t_city` VALUES (2722, 322, '青羊区', 3);
INSERT INTO `t_city` VALUES (2723, 322, '锦江区', 3);
INSERT INTO `t_city` VALUES (2724, 322, '金牛区', 3);
INSERT INTO `t_city` VALUES (2725, 322, '武侯区', 3);
INSERT INTO `t_city` VALUES (2726, 322, '成华区', 3);
INSERT INTO `t_city` VALUES (2727, 322, '龙泉驿区', 3);
INSERT INTO `t_city` VALUES (2728, 322, '青白江区', 3);
INSERT INTO `t_city` VALUES (2729, 322, '新都区', 3);
INSERT INTO `t_city` VALUES (2730, 322, '温江区', 3);
INSERT INTO `t_city` VALUES (2731, 322, '高新区', 3);
INSERT INTO `t_city` VALUES (2732, 322, '高新西区', 3);
INSERT INTO `t_city` VALUES (2733, 322, '都江堰市', 3);
INSERT INTO `t_city` VALUES (2734, 322, '彭州市', 3);
INSERT INTO `t_city` VALUES (2735, 322, '邛崃市', 3);
INSERT INTO `t_city` VALUES (2736, 322, '崇州市', 3);
INSERT INTO `t_city` VALUES (2737, 322, '金堂县', 3);
INSERT INTO `t_city` VALUES (2738, 322, '双流县', 3);
INSERT INTO `t_city` VALUES (2739, 322, '郫县', 3);
INSERT INTO `t_city` VALUES (2740, 322, '大邑县', 3);
INSERT INTO `t_city` VALUES (2741, 322, '蒲江县', 3);
INSERT INTO `t_city` VALUES (2742, 322, '新津县', 3);
INSERT INTO `t_city` VALUES (2743, 322, '都江堰市', 3);
INSERT INTO `t_city` VALUES (2744, 322, '彭州市', 3);
INSERT INTO `t_city` VALUES (2745, 322, '邛崃市', 3);
INSERT INTO `t_city` VALUES (2746, 322, '崇州市', 3);
INSERT INTO `t_city` VALUES (2747, 322, '金堂县', 3);
INSERT INTO `t_city` VALUES (2748, 322, '双流县', 3);
INSERT INTO `t_city` VALUES (2749, 322, '郫县', 3);
INSERT INTO `t_city` VALUES (2750, 322, '大邑县', 3);
INSERT INTO `t_city` VALUES (2751, 322, '蒲江县', 3);
INSERT INTO `t_city` VALUES (2752, 322, '新津县', 3);
INSERT INTO `t_city` VALUES (2753, 323, '涪城区', 3);
INSERT INTO `t_city` VALUES (2754, 323, '游仙区', 3);
INSERT INTO `t_city` VALUES (2755, 323, '江油市', 3);
INSERT INTO `t_city` VALUES (2756, 323, '盐亭县', 3);
INSERT INTO `t_city` VALUES (2757, 323, '三台县', 3);
INSERT INTO `t_city` VALUES (2758, 323, '平武县', 3);
INSERT INTO `t_city` VALUES (2759, 323, '安县', 3);
INSERT INTO `t_city` VALUES (2760, 323, '梓潼县', 3);
INSERT INTO `t_city` VALUES (2761, 323, '北川县', 3);
INSERT INTO `t_city` VALUES (2762, 324, '马尔康县', 3);
INSERT INTO `t_city` VALUES (2763, 324, '汶川县', 3);
INSERT INTO `t_city` VALUES (2764, 324, '理县', 3);
INSERT INTO `t_city` VALUES (2765, 324, '茂县', 3);
INSERT INTO `t_city` VALUES (2766, 324, '松潘县', 3);
INSERT INTO `t_city` VALUES (2767, 324, '九寨沟县', 3);
INSERT INTO `t_city` VALUES (2768, 324, '金川县', 3);
INSERT INTO `t_city` VALUES (2769, 324, '小金县', 3);
INSERT INTO `t_city` VALUES (2770, 324, '黑水县', 3);
INSERT INTO `t_city` VALUES (2771, 324, '壤塘县', 3);
INSERT INTO `t_city` VALUES (2772, 324, '阿坝县', 3);
INSERT INTO `t_city` VALUES (2773, 324, '若尔盖县', 3);
INSERT INTO `t_city` VALUES (2774, 324, '红原县', 3);
INSERT INTO `t_city` VALUES (2775, 325, '巴州区', 3);
INSERT INTO `t_city` VALUES (2776, 325, '通江县', 3);
INSERT INTO `t_city` VALUES (2777, 325, '南江县', 3);
INSERT INTO `t_city` VALUES (2778, 325, '平昌县', 3);
INSERT INTO `t_city` VALUES (2779, 326, '通川区', 3);
INSERT INTO `t_city` VALUES (2780, 326, '万源市', 3);
INSERT INTO `t_city` VALUES (2781, 326, '达县', 3);
INSERT INTO `t_city` VALUES (2782, 326, '宣汉县', 3);
INSERT INTO `t_city` VALUES (2783, 326, '开江县', 3);
INSERT INTO `t_city` VALUES (2784, 326, '大竹县', 3);
INSERT INTO `t_city` VALUES (2785, 326, '渠县', 3);
INSERT INTO `t_city` VALUES (2786, 327, '旌阳区', 3);
INSERT INTO `t_city` VALUES (2787, 327, '广汉市', 3);
INSERT INTO `t_city` VALUES (2788, 327, '什邡市', 3);
INSERT INTO `t_city` VALUES (2789, 327, '绵竹市', 3);
INSERT INTO `t_city` VALUES (2790, 327, '罗江县', 3);
INSERT INTO `t_city` VALUES (2791, 327, '中江县', 3);
INSERT INTO `t_city` VALUES (2792, 328, '康定县', 3);
INSERT INTO `t_city` VALUES (2793, 328, '丹巴县', 3);
INSERT INTO `t_city` VALUES (2794, 328, '泸定县', 3);
INSERT INTO `t_city` VALUES (2795, 328, '炉霍县', 3);
INSERT INTO `t_city` VALUES (2796, 328, '九龙县', 3);
INSERT INTO `t_city` VALUES (2797, 328, '甘孜县', 3);
INSERT INTO `t_city` VALUES (2798, 328, '雅江县', 3);
INSERT INTO `t_city` VALUES (2799, 328, '新龙县', 3);
INSERT INTO `t_city` VALUES (2800, 328, '道孚县', 3);
INSERT INTO `t_city` VALUES (2801, 328, '白玉县', 3);
INSERT INTO `t_city` VALUES (2802, 328, '理塘县', 3);
INSERT INTO `t_city` VALUES (2803, 328, '德格县', 3);
INSERT INTO `t_city` VALUES (2804, 328, '乡城县', 3);
INSERT INTO `t_city` VALUES (2805, 328, '石渠县', 3);
INSERT INTO `t_city` VALUES (2806, 328, '稻城县', 3);
INSERT INTO `t_city` VALUES (2807, 328, '色达县', 3);
INSERT INTO `t_city` VALUES (2808, 328, '巴塘县', 3);
INSERT INTO `t_city` VALUES (2809, 328, '得荣县', 3);
INSERT INTO `t_city` VALUES (2810, 329, '广安区', 3);
INSERT INTO `t_city` VALUES (2811, 329, '华蓥市', 3);
INSERT INTO `t_city` VALUES (2812, 329, '岳池县', 3);
INSERT INTO `t_city` VALUES (2813, 329, '武胜县', 3);
INSERT INTO `t_city` VALUES (2814, 329, '邻水县', 3);
INSERT INTO `t_city` VALUES (2815, 330, '利州区', 3);
INSERT INTO `t_city` VALUES (2816, 330, '元坝区', 3);
INSERT INTO `t_city` VALUES (2817, 330, '朝天区', 3);
INSERT INTO `t_city` VALUES (2818, 330, '旺苍县', 3);
INSERT INTO `t_city` VALUES (2819, 330, '青川县', 3);
INSERT INTO `t_city` VALUES (2820, 330, '剑阁县', 3);
INSERT INTO `t_city` VALUES (2821, 330, '苍溪县', 3);
INSERT INTO `t_city` VALUES (2822, 331, '峨眉山市', 3);
INSERT INTO `t_city` VALUES (2823, 331, '乐山市', 3);
INSERT INTO `t_city` VALUES (2824, 331, '犍为县', 3);
INSERT INTO `t_city` VALUES (2825, 331, '井研县', 3);
INSERT INTO `t_city` VALUES (2826, 331, '夹江县', 3);
INSERT INTO `t_city` VALUES (2827, 331, '沐川县', 3);
INSERT INTO `t_city` VALUES (2828, 331, '峨边', 3);
INSERT INTO `t_city` VALUES (2829, 331, '马边', 3);
INSERT INTO `t_city` VALUES (2830, 332, '西昌市', 3);
INSERT INTO `t_city` VALUES (2831, 332, '盐源县', 3);
INSERT INTO `t_city` VALUES (2832, 332, '德昌县', 3);
INSERT INTO `t_city` VALUES (2833, 332, '会理县', 3);
INSERT INTO `t_city` VALUES (2834, 332, '会东县', 3);
INSERT INTO `t_city` VALUES (2835, 332, '宁南县', 3);
INSERT INTO `t_city` VALUES (2836, 332, '普格县', 3);
INSERT INTO `t_city` VALUES (2837, 332, '布拖县', 3);
INSERT INTO `t_city` VALUES (2838, 332, '金阳县', 3);
INSERT INTO `t_city` VALUES (2839, 332, '昭觉县', 3);
INSERT INTO `t_city` VALUES (2840, 332, '喜德县', 3);
INSERT INTO `t_city` VALUES (2841, 332, '冕宁县', 3);
INSERT INTO `t_city` VALUES (2842, 332, '越西县', 3);
INSERT INTO `t_city` VALUES (2843, 332, '甘洛县', 3);
INSERT INTO `t_city` VALUES (2844, 332, '美姑县', 3);
INSERT INTO `t_city` VALUES (2845, 332, '雷波县', 3);
INSERT INTO `t_city` VALUES (2846, 332, '木里', 3);
INSERT INTO `t_city` VALUES (2847, 333, '东坡区', 3);
INSERT INTO `t_city` VALUES (2848, 333, '仁寿县', 3);
INSERT INTO `t_city` VALUES (2849, 333, '彭山县', 3);
INSERT INTO `t_city` VALUES (2850, 333, '洪雅县', 3);
INSERT INTO `t_city` VALUES (2851, 333, '丹棱县', 3);
INSERT INTO `t_city` VALUES (2852, 333, '青神县', 3);
INSERT INTO `t_city` VALUES (2853, 334, '阆中市', 3);
INSERT INTO `t_city` VALUES (2854, 334, '南部县', 3);
INSERT INTO `t_city` VALUES (2855, 334, '营山县', 3);
INSERT INTO `t_city` VALUES (2856, 334, '蓬安县', 3);
INSERT INTO `t_city` VALUES (2857, 334, '仪陇县', 3);
INSERT INTO `t_city` VALUES (2858, 334, '顺庆区', 3);
INSERT INTO `t_city` VALUES (2859, 334, '高坪区', 3);
INSERT INTO `t_city` VALUES (2860, 334, '嘉陵区', 3);
INSERT INTO `t_city` VALUES (2861, 334, '西充县', 3);
INSERT INTO `t_city` VALUES (2862, 335, '市中区', 3);
INSERT INTO `t_city` VALUES (2863, 335, '东兴区', 3);
INSERT INTO `t_city` VALUES (2864, 335, '威远县', 3);
INSERT INTO `t_city` VALUES (2865, 335, '资中县', 3);
INSERT INTO `t_city` VALUES (2866, 335, '隆昌县', 3);
INSERT INTO `t_city` VALUES (2867, 336, '东  区', 3);
INSERT INTO `t_city` VALUES (2868, 336, '西  区', 3);
INSERT INTO `t_city` VALUES (2869, 336, '仁和区', 3);
INSERT INTO `t_city` VALUES (2870, 336, '米易县', 3);
INSERT INTO `t_city` VALUES (2871, 336, '盐边县', 3);
INSERT INTO `t_city` VALUES (2872, 337, '船山区', 3);
INSERT INTO `t_city` VALUES (2873, 337, '安居区', 3);
INSERT INTO `t_city` VALUES (2874, 337, '蓬溪县', 3);
INSERT INTO `t_city` VALUES (2875, 337, '射洪县', 3);
INSERT INTO `t_city` VALUES (2876, 337, '大英县', 3);
INSERT INTO `t_city` VALUES (2877, 338, '雨城区', 3);
INSERT INTO `t_city` VALUES (2878, 338, '名山县', 3);
INSERT INTO `t_city` VALUES (2879, 338, '荥经县', 3);
INSERT INTO `t_city` VALUES (2880, 338, '汉源县', 3);
INSERT INTO `t_city` VALUES (2881, 338, '石棉县', 3);
INSERT INTO `t_city` VALUES (2882, 338, '天全县', 3);
INSERT INTO `t_city` VALUES (2883, 338, '芦山县', 3);
INSERT INTO `t_city` VALUES (2884, 338, '宝兴县', 3);
INSERT INTO `t_city` VALUES (2885, 339, '翠屏区', 3);
INSERT INTO `t_city` VALUES (2886, 339, '宜宾县', 3);
INSERT INTO `t_city` VALUES (2887, 339, '南溪县', 3);
INSERT INTO `t_city` VALUES (2888, 339, '江安县', 3);
INSERT INTO `t_city` VALUES (2889, 339, '长宁县', 3);
INSERT INTO `t_city` VALUES (2890, 339, '高县', 3);
INSERT INTO `t_city` VALUES (2891, 339, '珙县', 3);
INSERT INTO `t_city` VALUES (2892, 339, '筠连县', 3);
INSERT INTO `t_city` VALUES (2893, 339, '兴文县', 3);
INSERT INTO `t_city` VALUES (2894, 339, '屏山县', 3);
INSERT INTO `t_city` VALUES (2895, 340, '雁江区', 3);
INSERT INTO `t_city` VALUES (2896, 340, '简阳市', 3);
INSERT INTO `t_city` VALUES (2897, 340, '安岳县', 3);
INSERT INTO `t_city` VALUES (2898, 340, '乐至县', 3);
INSERT INTO `t_city` VALUES (2899, 341, '大安区', 3);
INSERT INTO `t_city` VALUES (2900, 341, '自流井区', 3);
INSERT INTO `t_city` VALUES (2901, 341, '贡井区', 3);
INSERT INTO `t_city` VALUES (2902, 341, '沿滩区', 3);
INSERT INTO `t_city` VALUES (2903, 341, '荣县', 3);
INSERT INTO `t_city` VALUES (2904, 341, '富顺县', 3);
INSERT INTO `t_city` VALUES (2905, 342, '江阳区', 3);
INSERT INTO `t_city` VALUES (2906, 342, '纳溪区', 3);
INSERT INTO `t_city` VALUES (2907, 342, '龙马潭区', 3);
INSERT INTO `t_city` VALUES (2908, 342, '泸县', 3);
INSERT INTO `t_city` VALUES (2909, 342, '合江县', 3);
INSERT INTO `t_city` VALUES (2910, 342, '叙永县', 3);
INSERT INTO `t_city` VALUES (2911, 342, '古蔺县', 3);
INSERT INTO `t_city` VALUES (2912, 343, '和平区', 3);
INSERT INTO `t_city` VALUES (2913, 343, '河西区', 3);
INSERT INTO `t_city` VALUES (2914, 343, '南开区', 3);
INSERT INTO `t_city` VALUES (2915, 343, '河北区', 3);
INSERT INTO `t_city` VALUES (2916, 343, '河东区', 3);
INSERT INTO `t_city` VALUES (2917, 343, '红桥区', 3);
INSERT INTO `t_city` VALUES (2918, 343, '东丽区', 3);
INSERT INTO `t_city` VALUES (2919, 343, '津南区', 3);
INSERT INTO `t_city` VALUES (2920, 343, '西青区', 3);
INSERT INTO `t_city` VALUES (2921, 343, '北辰区', 3);
INSERT INTO `t_city` VALUES (2922, 343, '塘沽区', 3);
INSERT INTO `t_city` VALUES (2923, 343, '汉沽区', 3);
INSERT INTO `t_city` VALUES (2924, 343, '大港区', 3);
INSERT INTO `t_city` VALUES (2925, 343, '武清区', 3);
INSERT INTO `t_city` VALUES (2926, 343, '宝坻区', 3);
INSERT INTO `t_city` VALUES (2927, 343, '经济开发区', 3);
INSERT INTO `t_city` VALUES (2928, 343, '宁河县', 3);
INSERT INTO `t_city` VALUES (2929, 343, '静海县', 3);
INSERT INTO `t_city` VALUES (2930, 343, '蓟县', 3);
INSERT INTO `t_city` VALUES (2931, 344, '城关区', 3);
INSERT INTO `t_city` VALUES (2932, 344, '林周县', 3);
INSERT INTO `t_city` VALUES (2933, 344, '当雄县', 3);
INSERT INTO `t_city` VALUES (2934, 344, '尼木县', 3);
INSERT INTO `t_city` VALUES (2935, 344, '曲水县', 3);
INSERT INTO `t_city` VALUES (2936, 344, '堆龙德庆县', 3);
INSERT INTO `t_city` VALUES (2937, 344, '达孜县', 3);
INSERT INTO `t_city` VALUES (2938, 344, '墨竹工卡县', 3);
INSERT INTO `t_city` VALUES (2939, 345, '噶尔县', 3);
INSERT INTO `t_city` VALUES (2940, 345, '普兰县', 3);
INSERT INTO `t_city` VALUES (2941, 345, '札达县', 3);
INSERT INTO `t_city` VALUES (2942, 345, '日土县', 3);
INSERT INTO `t_city` VALUES (2943, 345, '革吉县', 3);
INSERT INTO `t_city` VALUES (2944, 345, '改则县', 3);
INSERT INTO `t_city` VALUES (2945, 345, '措勤县', 3);
INSERT INTO `t_city` VALUES (2946, 346, '昌都县', 3);
INSERT INTO `t_city` VALUES (2947, 346, '江达县', 3);
INSERT INTO `t_city` VALUES (2948, 346, '贡觉县', 3);
INSERT INTO `t_city` VALUES (2949, 346, '类乌齐县', 3);
INSERT INTO `t_city` VALUES (2950, 346, '丁青县', 3);
INSERT INTO `t_city` VALUES (2951, 346, '察雅县', 3);
INSERT INTO `t_city` VALUES (2952, 346, '八宿县', 3);
INSERT INTO `t_city` VALUES (2953, 346, '左贡县', 3);
INSERT INTO `t_city` VALUES (2954, 346, '芒康县', 3);
INSERT INTO `t_city` VALUES (2955, 346, '洛隆县', 3);
INSERT INTO `t_city` VALUES (2956, 346, '边坝县', 3);
INSERT INTO `t_city` VALUES (2957, 347, '林芝县', 3);
INSERT INTO `t_city` VALUES (2958, 347, '工布江达县', 3);
INSERT INTO `t_city` VALUES (2959, 347, '米林县', 3);
INSERT INTO `t_city` VALUES (2960, 347, '墨脱县', 3);
INSERT INTO `t_city` VALUES (2961, 347, '波密县', 3);
INSERT INTO `t_city` VALUES (2962, 347, '察隅县', 3);
INSERT INTO `t_city` VALUES (2963, 347, '朗县', 3);
INSERT INTO `t_city` VALUES (2964, 348, '那曲县', 3);
INSERT INTO `t_city` VALUES (2965, 348, '嘉黎县', 3);
INSERT INTO `t_city` VALUES (2966, 348, '比如县', 3);
INSERT INTO `t_city` VALUES (2967, 348, '聂荣县', 3);
INSERT INTO `t_city` VALUES (2968, 348, '安多县', 3);
INSERT INTO `t_city` VALUES (2969, 348, '申扎县', 3);
INSERT INTO `t_city` VALUES (2970, 348, '索县', 3);
INSERT INTO `t_city` VALUES (2971, 348, '班戈县', 3);
INSERT INTO `t_city` VALUES (2972, 348, '巴青县', 3);
INSERT INTO `t_city` VALUES (2973, 348, '尼玛县', 3);
INSERT INTO `t_city` VALUES (2974, 349, '日喀则市', 3);
INSERT INTO `t_city` VALUES (2975, 349, '南木林县', 3);
INSERT INTO `t_city` VALUES (2976, 349, '江孜县', 3);
INSERT INTO `t_city` VALUES (2977, 349, '定日县', 3);
INSERT INTO `t_city` VALUES (2978, 349, '萨迦县', 3);
INSERT INTO `t_city` VALUES (2979, 349, '拉孜县', 3);
INSERT INTO `t_city` VALUES (2980, 349, '昂仁县', 3);
INSERT INTO `t_city` VALUES (2981, 349, '谢通门县', 3);
INSERT INTO `t_city` VALUES (2982, 349, '白朗县', 3);
INSERT INTO `t_city` VALUES (2983, 349, '仁布县', 3);
INSERT INTO `t_city` VALUES (2984, 349, '康马县', 3);
INSERT INTO `t_city` VALUES (2985, 349, '定结县', 3);
INSERT INTO `t_city` VALUES (2986, 349, '仲巴县', 3);
INSERT INTO `t_city` VALUES (2987, 349, '亚东县', 3);
INSERT INTO `t_city` VALUES (2988, 349, '吉隆县', 3);
INSERT INTO `t_city` VALUES (2989, 349, '聂拉木县', 3);
INSERT INTO `t_city` VALUES (2990, 349, '萨嘎县', 3);
INSERT INTO `t_city` VALUES (2991, 349, '岗巴县', 3);
INSERT INTO `t_city` VALUES (2992, 350, '乃东县', 3);
INSERT INTO `t_city` VALUES (2993, 350, '扎囊县', 3);
INSERT INTO `t_city` VALUES (2994, 350, '贡嘎县', 3);
INSERT INTO `t_city` VALUES (2995, 350, '桑日县', 3);
INSERT INTO `t_city` VALUES (2996, 350, '琼结县', 3);
INSERT INTO `t_city` VALUES (2997, 350, '曲松县', 3);
INSERT INTO `t_city` VALUES (2998, 350, '措美县', 3);
INSERT INTO `t_city` VALUES (2999, 350, '洛扎县', 3);
INSERT INTO `t_city` VALUES (3000, 350, '加查县', 3);
INSERT INTO `t_city` VALUES (3001, 350, '隆子县', 3);
INSERT INTO `t_city` VALUES (3002, 350, '错那县', 3);
INSERT INTO `t_city` VALUES (3003, 350, '浪卡子县', 3);
INSERT INTO `t_city` VALUES (3004, 351, '天山区', 3);
INSERT INTO `t_city` VALUES (3005, 351, '沙依巴克区', 3);
INSERT INTO `t_city` VALUES (3006, 351, '新市区', 3);
INSERT INTO `t_city` VALUES (3007, 351, '水磨沟区', 3);
INSERT INTO `t_city` VALUES (3008, 351, '头屯河区', 3);
INSERT INTO `t_city` VALUES (3009, 351, '达坂城区', 3);
INSERT INTO `t_city` VALUES (3010, 351, '米东区', 3);
INSERT INTO `t_city` VALUES (3011, 351, '乌鲁木齐县', 3);
INSERT INTO `t_city` VALUES (3012, 352, '阿克苏市', 3);
INSERT INTO `t_city` VALUES (3013, 352, '温宿县', 3);
INSERT INTO `t_city` VALUES (3014, 352, '库车县', 3);
INSERT INTO `t_city` VALUES (3015, 352, '沙雅县', 3);
INSERT INTO `t_city` VALUES (3016, 352, '新和县', 3);
INSERT INTO `t_city` VALUES (3017, 352, '拜城县', 3);
INSERT INTO `t_city` VALUES (3018, 352, '乌什县', 3);
INSERT INTO `t_city` VALUES (3019, 352, '阿瓦提县', 3);
INSERT INTO `t_city` VALUES (3020, 352, '柯坪县', 3);
INSERT INTO `t_city` VALUES (3021, 353, '阿拉尔市', 3);
INSERT INTO `t_city` VALUES (3022, 354, '库尔勒市', 3);
INSERT INTO `t_city` VALUES (3023, 354, '轮台县', 3);
INSERT INTO `t_city` VALUES (3024, 354, '尉犁县', 3);
INSERT INTO `t_city` VALUES (3025, 354, '若羌县', 3);
INSERT INTO `t_city` VALUES (3026, 354, '且末县', 3);
INSERT INTO `t_city` VALUES (3027, 354, '焉耆', 3);
INSERT INTO `t_city` VALUES (3028, 354, '和静县', 3);
INSERT INTO `t_city` VALUES (3029, 354, '和硕县', 3);
INSERT INTO `t_city` VALUES (3030, 354, '博湖县', 3);
INSERT INTO `t_city` VALUES (3031, 355, '博乐市', 3);
INSERT INTO `t_city` VALUES (3032, 355, '精河县', 3);
INSERT INTO `t_city` VALUES (3033, 355, '温泉县', 3);
INSERT INTO `t_city` VALUES (3034, 356, '呼图壁县', 3);
INSERT INTO `t_city` VALUES (3035, 356, '米泉市', 3);
INSERT INTO `t_city` VALUES (3036, 356, '昌吉市', 3);
INSERT INTO `t_city` VALUES (3037, 356, '阜康市', 3);
INSERT INTO `t_city` VALUES (3038, 356, '玛纳斯县', 3);
INSERT INTO `t_city` VALUES (3039, 356, '奇台县', 3);
INSERT INTO `t_city` VALUES (3040, 356, '吉木萨尔县', 3);
INSERT INTO `t_city` VALUES (3041, 356, '木垒', 3);
INSERT INTO `t_city` VALUES (3042, 357, '哈密市', 3);
INSERT INTO `t_city` VALUES (3043, 357, '伊吾县', 3);
INSERT INTO `t_city` VALUES (3044, 357, '巴里坤', 3);
INSERT INTO `t_city` VALUES (3045, 358, '和田市', 3);
INSERT INTO `t_city` VALUES (3046, 358, '和田县', 3);
INSERT INTO `t_city` VALUES (3047, 358, '墨玉县', 3);
INSERT INTO `t_city` VALUES (3048, 358, '皮山县', 3);
INSERT INTO `t_city` VALUES (3049, 358, '洛浦县', 3);
INSERT INTO `t_city` VALUES (3050, 358, '策勒县', 3);
INSERT INTO `t_city` VALUES (3051, 358, '于田县', 3);
INSERT INTO `t_city` VALUES (3052, 358, '民丰县', 3);
INSERT INTO `t_city` VALUES (3053, 359, '喀什市', 3);
INSERT INTO `t_city` VALUES (3054, 359, '疏附县', 3);
INSERT INTO `t_city` VALUES (3055, 359, '疏勒县', 3);
INSERT INTO `t_city` VALUES (3056, 359, '英吉沙县', 3);
INSERT INTO `t_city` VALUES (3057, 359, '泽普县', 3);
INSERT INTO `t_city` VALUES (3058, 359, '莎车县', 3);
INSERT INTO `t_city` VALUES (3059, 359, '叶城县', 3);
INSERT INTO `t_city` VALUES (3060, 359, '麦盖提县', 3);
INSERT INTO `t_city` VALUES (3061, 359, '岳普湖县', 3);
INSERT INTO `t_city` VALUES (3062, 359, '伽师县', 3);
INSERT INTO `t_city` VALUES (3063, 359, '巴楚县', 3);
INSERT INTO `t_city` VALUES (3064, 359, '塔什库尔干', 3);
INSERT INTO `t_city` VALUES (3065, 360, '克拉玛依市', 3);
INSERT INTO `t_city` VALUES (3066, 361, '阿图什市', 3);
INSERT INTO `t_city` VALUES (3067, 361, '阿克陶县', 3);
INSERT INTO `t_city` VALUES (3068, 361, '阿合奇县', 3);
INSERT INTO `t_city` VALUES (3069, 361, '乌恰县', 3);
INSERT INTO `t_city` VALUES (3070, 362, '石河子市', 3);
INSERT INTO `t_city` VALUES (3071, 363, '图木舒克市', 3);
INSERT INTO `t_city` VALUES (3072, 364, '吐鲁番市', 3);
INSERT INTO `t_city` VALUES (3073, 364, '鄯善县', 3);
INSERT INTO `t_city` VALUES (3074, 364, '托克逊县', 3);
INSERT INTO `t_city` VALUES (3075, 365, '五家渠市', 3);
INSERT INTO `t_city` VALUES (3076, 366, '阿勒泰市', 3);
INSERT INTO `t_city` VALUES (3077, 366, '布克赛尔', 3);
INSERT INTO `t_city` VALUES (3078, 366, '伊宁市', 3);
INSERT INTO `t_city` VALUES (3079, 366, '布尔津县', 3);
INSERT INTO `t_city` VALUES (3080, 366, '奎屯市', 3);
INSERT INTO `t_city` VALUES (3081, 366, '乌苏市', 3);
INSERT INTO `t_city` VALUES (3082, 366, '额敏县', 3);
INSERT INTO `t_city` VALUES (3083, 366, '富蕴县', 3);
INSERT INTO `t_city` VALUES (3084, 366, '伊宁县', 3);
INSERT INTO `t_city` VALUES (3085, 366, '福海县', 3);
INSERT INTO `t_city` VALUES (3086, 366, '霍城县', 3);
INSERT INTO `t_city` VALUES (3087, 366, '沙湾县', 3);
INSERT INTO `t_city` VALUES (3088, 366, '巩留县', 3);
INSERT INTO `t_city` VALUES (3089, 366, '哈巴河县', 3);
INSERT INTO `t_city` VALUES (3090, 366, '托里县', 3);
INSERT INTO `t_city` VALUES (3091, 366, '青河县', 3);
INSERT INTO `t_city` VALUES (3092, 366, '新源县', 3);
INSERT INTO `t_city` VALUES (3093, 366, '裕民县', 3);
INSERT INTO `t_city` VALUES (3094, 366, '和布克赛尔', 3);
INSERT INTO `t_city` VALUES (3095, 366, '吉木乃县', 3);
INSERT INTO `t_city` VALUES (3096, 366, '昭苏县', 3);
INSERT INTO `t_city` VALUES (3097, 366, '特克斯县', 3);
INSERT INTO `t_city` VALUES (3098, 366, '尼勒克县', 3);
INSERT INTO `t_city` VALUES (3099, 366, '察布查尔', 3);
INSERT INTO `t_city` VALUES (3100, 367, '盘龙区', 3);
INSERT INTO `t_city` VALUES (3101, 367, '五华区', 3);
INSERT INTO `t_city` VALUES (3102, 367, '官渡区', 3);
INSERT INTO `t_city` VALUES (3103, 367, '西山区', 3);
INSERT INTO `t_city` VALUES (3104, 367, '东川区', 3);
INSERT INTO `t_city` VALUES (3105, 367, '安宁市', 3);
INSERT INTO `t_city` VALUES (3106, 367, '呈贡县', 3);
INSERT INTO `t_city` VALUES (3107, 367, '晋宁县', 3);
INSERT INTO `t_city` VALUES (3108, 367, '富民县', 3);
INSERT INTO `t_city` VALUES (3109, 367, '宜良县', 3);
INSERT INTO `t_city` VALUES (3110, 367, '嵩明县', 3);
INSERT INTO `t_city` VALUES (3111, 367, '石林县', 3);
INSERT INTO `t_city` VALUES (3112, 367, '禄劝', 3);
INSERT INTO `t_city` VALUES (3113, 367, '寻甸', 3);
INSERT INTO `t_city` VALUES (3114, 368, '兰坪', 3);
INSERT INTO `t_city` VALUES (3115, 368, '泸水县', 3);
INSERT INTO `t_city` VALUES (3116, 368, '福贡县', 3);
INSERT INTO `t_city` VALUES (3117, 368, '贡山', 3);
INSERT INTO `t_city` VALUES (3118, 369, '宁洱', 3);
INSERT INTO `t_city` VALUES (3119, 369, '思茅区', 3);
INSERT INTO `t_city` VALUES (3120, 369, '墨江', 3);
INSERT INTO `t_city` VALUES (3121, 369, '景东', 3);
INSERT INTO `t_city` VALUES (3122, 369, '景谷', 3);
INSERT INTO `t_city` VALUES (3123, 369, '镇沅', 3);
INSERT INTO `t_city` VALUES (3124, 369, '江城', 3);
INSERT INTO `t_city` VALUES (3125, 369, '孟连', 3);
INSERT INTO `t_city` VALUES (3126, 369, '澜沧', 3);
INSERT INTO `t_city` VALUES (3127, 369, '西盟', 3);
INSERT INTO `t_city` VALUES (3128, 370, '古城区', 3);
INSERT INTO `t_city` VALUES (3129, 370, '宁蒗', 3);
INSERT INTO `t_city` VALUES (3130, 370, '玉龙', 3);
INSERT INTO `t_city` VALUES (3131, 370, '永胜县', 3);
INSERT INTO `t_city` VALUES (3132, 370, '华坪县', 3);
INSERT INTO `t_city` VALUES (3133, 371, '隆阳区', 3);
INSERT INTO `t_city` VALUES (3134, 371, '施甸县', 3);
INSERT INTO `t_city` VALUES (3135, 371, '腾冲县', 3);
INSERT INTO `t_city` VALUES (3136, 371, '龙陵县', 3);
INSERT INTO `t_city` VALUES (3137, 371, '昌宁县', 3);
INSERT INTO `t_city` VALUES (3138, 372, '楚雄市', 3);
INSERT INTO `t_city` VALUES (3139, 372, '双柏县', 3);
INSERT INTO `t_city` VALUES (3140, 372, '牟定县', 3);
INSERT INTO `t_city` VALUES (3141, 372, '南华县', 3);
INSERT INTO `t_city` VALUES (3142, 372, '姚安县', 3);
INSERT INTO `t_city` VALUES (3143, 372, '大姚县', 3);
INSERT INTO `t_city` VALUES (3144, 372, '永仁县', 3);
INSERT INTO `t_city` VALUES (3145, 372, '元谋县', 3);
INSERT INTO `t_city` VALUES (3146, 372, '武定县', 3);
INSERT INTO `t_city` VALUES (3147, 372, '禄丰县', 3);
INSERT INTO `t_city` VALUES (3148, 373, '大理市', 3);
INSERT INTO `t_city` VALUES (3149, 373, '祥云县', 3);
INSERT INTO `t_city` VALUES (3150, 373, '宾川县', 3);
INSERT INTO `t_city` VALUES (3151, 373, '弥渡县', 3);
INSERT INTO `t_city` VALUES (3152, 373, '永平县', 3);
INSERT INTO `t_city` VALUES (3153, 373, '云龙县', 3);
INSERT INTO `t_city` VALUES (3154, 373, '洱源县', 3);
INSERT INTO `t_city` VALUES (3155, 373, '剑川县', 3);
INSERT INTO `t_city` VALUES (3156, 373, '鹤庆县', 3);
INSERT INTO `t_city` VALUES (3157, 373, '漾濞', 3);
INSERT INTO `t_city` VALUES (3158, 373, '南涧', 3);
INSERT INTO `t_city` VALUES (3159, 373, '巍山', 3);
INSERT INTO `t_city` VALUES (3160, 374, '潞西市', 3);
INSERT INTO `t_city` VALUES (3161, 374, '瑞丽市', 3);
INSERT INTO `t_city` VALUES (3162, 374, '梁河县', 3);
INSERT INTO `t_city` VALUES (3163, 374, '盈江县', 3);
INSERT INTO `t_city` VALUES (3164, 374, '陇川县', 3);
INSERT INTO `t_city` VALUES (3165, 375, '香格里拉县', 3);
INSERT INTO `t_city` VALUES (3166, 375, '德钦县', 3);
INSERT INTO `t_city` VALUES (3167, 375, '维西', 3);
INSERT INTO `t_city` VALUES (3168, 376, '泸西县', 3);
INSERT INTO `t_city` VALUES (3169, 376, '蒙自县', 3);
INSERT INTO `t_city` VALUES (3170, 376, '个旧市', 3);
INSERT INTO `t_city` VALUES (3171, 376, '开远市', 3);
INSERT INTO `t_city` VALUES (3172, 376, '绿春县', 3);
INSERT INTO `t_city` VALUES (3173, 376, '建水县', 3);
INSERT INTO `t_city` VALUES (3174, 376, '石屏县', 3);
INSERT INTO `t_city` VALUES (3175, 376, '弥勒县', 3);
INSERT INTO `t_city` VALUES (3176, 376, '元阳县', 3);
INSERT INTO `t_city` VALUES (3177, 376, '红河县', 3);
INSERT INTO `t_city` VALUES (3178, 376, '金平', 3);
INSERT INTO `t_city` VALUES (3179, 376, '河口', 3);
INSERT INTO `t_city` VALUES (3180, 376, '屏边', 3);
INSERT INTO `t_city` VALUES (3181, 377, '临翔区', 3);
INSERT INTO `t_city` VALUES (3182, 377, '凤庆县', 3);
INSERT INTO `t_city` VALUES (3183, 377, '云县', 3);
INSERT INTO `t_city` VALUES (3184, 377, '永德县', 3);
INSERT INTO `t_city` VALUES (3185, 377, '镇康县', 3);
INSERT INTO `t_city` VALUES (3186, 377, '双江', 3);
INSERT INTO `t_city` VALUES (3187, 377, '耿马', 3);
INSERT INTO `t_city` VALUES (3188, 377, '沧源', 3);
INSERT INTO `t_city` VALUES (3189, 378, '麒麟区', 3);
INSERT INTO `t_city` VALUES (3190, 378, '宣威市', 3);
INSERT INTO `t_city` VALUES (3191, 378, '马龙县', 3);
INSERT INTO `t_city` VALUES (3192, 378, '陆良县', 3);
INSERT INTO `t_city` VALUES (3193, 378, '师宗县', 3);
INSERT INTO `t_city` VALUES (3194, 378, '罗平县', 3);
INSERT INTO `t_city` VALUES (3195, 378, '富源县', 3);
INSERT INTO `t_city` VALUES (3196, 378, '会泽县', 3);
INSERT INTO `t_city` VALUES (3197, 378, '沾益县', 3);
INSERT INTO `t_city` VALUES (3198, 379, '文山县', 3);
INSERT INTO `t_city` VALUES (3199, 379, '砚山县', 3);
INSERT INTO `t_city` VALUES (3200, 379, '西畴县', 3);
INSERT INTO `t_city` VALUES (3201, 379, '麻栗坡县', 3);
INSERT INTO `t_city` VALUES (3202, 379, '马关县', 3);
INSERT INTO `t_city` VALUES (3203, 379, '丘北县', 3);
INSERT INTO `t_city` VALUES (3204, 379, '广南县', 3);
INSERT INTO `t_city` VALUES (3205, 379, '富宁县', 3);
INSERT INTO `t_city` VALUES (3206, 380, '景洪市', 3);
INSERT INTO `t_city` VALUES (3207, 380, '勐海县', 3);
INSERT INTO `t_city` VALUES (3208, 380, '勐腊县', 3);
INSERT INTO `t_city` VALUES (3209, 381, '红塔区', 3);
INSERT INTO `t_city` VALUES (3210, 381, '江川县', 3);
INSERT INTO `t_city` VALUES (3211, 381, '澄江县', 3);
INSERT INTO `t_city` VALUES (3212, 381, '通海县', 3);
INSERT INTO `t_city` VALUES (3213, 381, '华宁县', 3);
INSERT INTO `t_city` VALUES (3214, 381, '易门县', 3);
INSERT INTO `t_city` VALUES (3215, 381, '峨山', 3);
INSERT INTO `t_city` VALUES (3216, 381, '新平', 3);
INSERT INTO `t_city` VALUES (3217, 381, '元江', 3);
INSERT INTO `t_city` VALUES (3218, 382, '昭阳区', 3);
INSERT INTO `t_city` VALUES (3219, 382, '鲁甸县', 3);
INSERT INTO `t_city` VALUES (3220, 382, '巧家县', 3);
INSERT INTO `t_city` VALUES (3221, 382, '盐津县', 3);
INSERT INTO `t_city` VALUES (3222, 382, '大关县', 3);
INSERT INTO `t_city` VALUES (3223, 382, '永善县', 3);
INSERT INTO `t_city` VALUES (3224, 382, '绥江县', 3);
INSERT INTO `t_city` VALUES (3225, 382, '镇雄县', 3);
INSERT INTO `t_city` VALUES (3226, 382, '彝良县', 3);
INSERT INTO `t_city` VALUES (3227, 382, '威信县', 3);
INSERT INTO `t_city` VALUES (3228, 382, '水富县', 3);
INSERT INTO `t_city` VALUES (3229, 383, '西湖区', 3);
INSERT INTO `t_city` VALUES (3230, 383, '上城区', 3);
INSERT INTO `t_city` VALUES (3231, 383, '下城区', 3);
INSERT INTO `t_city` VALUES (3232, 383, '拱墅区', 3);
INSERT INTO `t_city` VALUES (3233, 383, '滨江区', 3);
INSERT INTO `t_city` VALUES (3234, 383, '江干区', 3);
INSERT INTO `t_city` VALUES (3235, 383, '萧山区', 3);
INSERT INTO `t_city` VALUES (3236, 383, '余杭区', 3);
INSERT INTO `t_city` VALUES (3237, 383, '市郊', 3);
INSERT INTO `t_city` VALUES (3238, 383, '建德市', 3);
INSERT INTO `t_city` VALUES (3239, 383, '富阳市', 3);
INSERT INTO `t_city` VALUES (3240, 383, '临安市', 3);
INSERT INTO `t_city` VALUES (3241, 383, '桐庐县', 3);
INSERT INTO `t_city` VALUES (3242, 383, '淳安县', 3);
INSERT INTO `t_city` VALUES (3243, 384, '吴兴区', 3);
INSERT INTO `t_city` VALUES (3244, 384, '南浔区', 3);
INSERT INTO `t_city` VALUES (3245, 384, '德清县', 3);
INSERT INTO `t_city` VALUES (3246, 384, '长兴县', 3);
INSERT INTO `t_city` VALUES (3247, 384, '安吉县', 3);
INSERT INTO `t_city` VALUES (3248, 385, '南湖区', 3);
INSERT INTO `t_city` VALUES (3249, 385, '秀洲区', 3);
INSERT INTO `t_city` VALUES (3250, 385, '海宁市', 3);
INSERT INTO `t_city` VALUES (3251, 385, '嘉善县', 3);
INSERT INTO `t_city` VALUES (3252, 385, '平湖市', 3);
INSERT INTO `t_city` VALUES (3253, 385, '桐乡市', 3);
INSERT INTO `t_city` VALUES (3254, 385, '海盐县', 3);
INSERT INTO `t_city` VALUES (3255, 386, '婺城区', 3);
INSERT INTO `t_city` VALUES (3256, 386, '金东区', 3);
INSERT INTO `t_city` VALUES (3257, 386, '兰溪市', 3);
INSERT INTO `t_city` VALUES (3258, 386, '市区', 3);
INSERT INTO `t_city` VALUES (3259, 386, '佛堂镇', 3);
INSERT INTO `t_city` VALUES (3260, 386, '上溪镇', 3);
INSERT INTO `t_city` VALUES (3261, 386, '义亭镇', 3);
INSERT INTO `t_city` VALUES (3262, 386, '大陈镇', 3);
INSERT INTO `t_city` VALUES (3263, 386, '苏溪镇', 3);
INSERT INTO `t_city` VALUES (3264, 386, '赤岸镇', 3);
INSERT INTO `t_city` VALUES (3265, 386, '东阳市', 3);
INSERT INTO `t_city` VALUES (3266, 386, '永康市', 3);
INSERT INTO `t_city` VALUES (3267, 386, '武义县', 3);
INSERT INTO `t_city` VALUES (3268, 386, '浦江县', 3);
INSERT INTO `t_city` VALUES (3269, 386, '磐安县', 3);
INSERT INTO `t_city` VALUES (3270, 387, '莲都区', 3);
INSERT INTO `t_city` VALUES (3271, 387, '龙泉市', 3);
INSERT INTO `t_city` VALUES (3272, 387, '青田县', 3);
INSERT INTO `t_city` VALUES (3273, 387, '缙云县', 3);
INSERT INTO `t_city` VALUES (3274, 387, '遂昌县', 3);
INSERT INTO `t_city` VALUES (3275, 387, '松阳县', 3);
INSERT INTO `t_city` VALUES (3276, 387, '云和县', 3);
INSERT INTO `t_city` VALUES (3277, 387, '庆元县', 3);
INSERT INTO `t_city` VALUES (3278, 387, '景宁', 3);
INSERT INTO `t_city` VALUES (3279, 388, '海曙区', 3);
INSERT INTO `t_city` VALUES (3280, 388, '江东区', 3);
INSERT INTO `t_city` VALUES (3281, 388, '江北区', 3);
INSERT INTO `t_city` VALUES (3282, 388, '镇海区', 3);
INSERT INTO `t_city` VALUES (3283, 388, '北仑区', 3);
INSERT INTO `t_city` VALUES (3284, 388, '鄞州区', 3);
INSERT INTO `t_city` VALUES (3285, 388, '余姚市', 3);
INSERT INTO `t_city` VALUES (3286, 388, '慈溪市', 3);
INSERT INTO `t_city` VALUES (3287, 388, '奉化市', 3);
INSERT INTO `t_city` VALUES (3288, 388, '象山县', 3);
INSERT INTO `t_city` VALUES (3289, 388, '宁海县', 3);
INSERT INTO `t_city` VALUES (3290, 389, '越城区', 3);
INSERT INTO `t_city` VALUES (3291, 389, '上虞市', 3);
INSERT INTO `t_city` VALUES (3292, 389, '嵊州市', 3);
INSERT INTO `t_city` VALUES (3293, 389, '绍兴县', 3);
INSERT INTO `t_city` VALUES (3294, 389, '新昌县', 3);
INSERT INTO `t_city` VALUES (3295, 389, '诸暨市', 3);
INSERT INTO `t_city` VALUES (3296, 390, '椒江区', 3);
INSERT INTO `t_city` VALUES (3297, 390, '黄岩区', 3);
INSERT INTO `t_city` VALUES (3298, 390, '路桥区', 3);
INSERT INTO `t_city` VALUES (3299, 390, '温岭市', 3);
INSERT INTO `t_city` VALUES (3300, 390, '临海市', 3);
INSERT INTO `t_city` VALUES (3301, 390, '玉环县', 3);
INSERT INTO `t_city` VALUES (3302, 390, '三门县', 3);
INSERT INTO `t_city` VALUES (3303, 390, '天台县', 3);
INSERT INTO `t_city` VALUES (3304, 390, '仙居县', 3);
INSERT INTO `t_city` VALUES (3305, 391, '鹿城区', 3);
INSERT INTO `t_city` VALUES (3306, 391, '龙湾区', 3);
INSERT INTO `t_city` VALUES (3307, 391, '瓯海区', 3);
INSERT INTO `t_city` VALUES (3308, 391, '瑞安市', 3);
INSERT INTO `t_city` VALUES (3309, 391, '乐清市', 3);
INSERT INTO `t_city` VALUES (3310, 391, '洞头县', 3);
INSERT INTO `t_city` VALUES (3311, 391, '永嘉县', 3);
INSERT INTO `t_city` VALUES (3312, 391, '平阳县', 3);
INSERT INTO `t_city` VALUES (3313, 391, '苍南县', 3);
INSERT INTO `t_city` VALUES (3314, 391, '文成县', 3);
INSERT INTO `t_city` VALUES (3315, 391, '泰顺县', 3);
INSERT INTO `t_city` VALUES (3316, 392, '定海区', 3);
INSERT INTO `t_city` VALUES (3317, 392, '普陀区', 3);
INSERT INTO `t_city` VALUES (3318, 392, '岱山县', 3);
INSERT INTO `t_city` VALUES (3319, 392, '嵊泗县', 3);
INSERT INTO `t_city` VALUES (3320, 393, '衢州市', 3);
INSERT INTO `t_city` VALUES (3321, 393, '江山市', 3);
INSERT INTO `t_city` VALUES (3322, 393, '常山县', 3);
INSERT INTO `t_city` VALUES (3323, 393, '开化县', 3);
INSERT INTO `t_city` VALUES (3324, 393, '龙游县', 3);
INSERT INTO `t_city` VALUES (3325, 394, '合川区', 3);
INSERT INTO `t_city` VALUES (3326, 394, '江津区', 3);
INSERT INTO `t_city` VALUES (3327, 394, '南川区', 3);
INSERT INTO `t_city` VALUES (3328, 394, '永川区', 3);
INSERT INTO `t_city` VALUES (3329, 394, '南岸区', 3);
INSERT INTO `t_city` VALUES (3330, 394, '渝北区', 3);
INSERT INTO `t_city` VALUES (3331, 394, '万盛区', 3);
INSERT INTO `t_city` VALUES (3332, 394, '大渡口区', 3);
INSERT INTO `t_city` VALUES (3333, 394, '万州区', 3);
INSERT INTO `t_city` VALUES (3334, 394, '北碚区', 3);
INSERT INTO `t_city` VALUES (3335, 394, '沙坪坝区', 3);
INSERT INTO `t_city` VALUES (3336, 394, '巴南区', 3);
INSERT INTO `t_city` VALUES (3337, 394, '涪陵区', 3);
INSERT INTO `t_city` VALUES (3338, 394, '江北区', 3);
INSERT INTO `t_city` VALUES (3339, 394, '九龙坡区', 3);
INSERT INTO `t_city` VALUES (3340, 394, '渝中区', 3);
INSERT INTO `t_city` VALUES (3341, 394, '黔江开发区', 3);
INSERT INTO `t_city` VALUES (3342, 394, '长寿区', 3);
INSERT INTO `t_city` VALUES (3343, 394, '双桥区', 3);
INSERT INTO `t_city` VALUES (3344, 394, '綦江县', 3);
INSERT INTO `t_city` VALUES (3345, 394, '潼南县', 3);
INSERT INTO `t_city` VALUES (3346, 394, '铜梁县', 3);
INSERT INTO `t_city` VALUES (3347, 394, '大足县', 3);
INSERT INTO `t_city` VALUES (3348, 394, '荣昌县', 3);
INSERT INTO `t_city` VALUES (3349, 394, '璧山县', 3);
INSERT INTO `t_city` VALUES (3350, 394, '垫江县', 3);
INSERT INTO `t_city` VALUES (3351, 394, '武隆县', 3);
INSERT INTO `t_city` VALUES (3352, 394, '丰都县', 3);
INSERT INTO `t_city` VALUES (3353, 394, '城口县', 3);
INSERT INTO `t_city` VALUES (3354, 394, '梁平县', 3);
INSERT INTO `t_city` VALUES (3355, 394, '开县', 3);
INSERT INTO `t_city` VALUES (3356, 394, '巫溪县', 3);
INSERT INTO `t_city` VALUES (3357, 394, '巫山县', 3);
INSERT INTO `t_city` VALUES (3358, 394, '奉节县', 3);
INSERT INTO `t_city` VALUES (3359, 394, '云阳县', 3);
INSERT INTO `t_city` VALUES (3360, 394, '忠县', 3);
INSERT INTO `t_city` VALUES (3361, 394, '石柱', 3);
INSERT INTO `t_city` VALUES (3362, 394, '彭水', 3);
INSERT INTO `t_city` VALUES (3363, 394, '酉阳', 3);
INSERT INTO `t_city` VALUES (3364, 394, '秀山', 3);
INSERT INTO `t_city` VALUES (3365, 395, '沙田区', 3);
INSERT INTO `t_city` VALUES (3366, 395, '东区', 3);
INSERT INTO `t_city` VALUES (3367, 395, '观塘区', 3);
INSERT INTO `t_city` VALUES (3368, 395, '黄大仙区', 3);
INSERT INTO `t_city` VALUES (3369, 395, '九龙城区', 3);
INSERT INTO `t_city` VALUES (3370, 395, '屯门区', 3);
INSERT INTO `t_city` VALUES (3371, 395, '葵青区', 3);
INSERT INTO `t_city` VALUES (3372, 395, '元朗区', 3);
INSERT INTO `t_city` VALUES (3373, 395, '深水埗区', 3);
INSERT INTO `t_city` VALUES (3374, 395, '西贡区', 3);
INSERT INTO `t_city` VALUES (3375, 395, '大埔区', 3);
INSERT INTO `t_city` VALUES (3376, 395, '湾仔区', 3);
INSERT INTO `t_city` VALUES (3377, 395, '油尖旺区', 3);
INSERT INTO `t_city` VALUES (3378, 395, '北区', 3);
INSERT INTO `t_city` VALUES (3379, 395, '南区', 3);
INSERT INTO `t_city` VALUES (3380, 395, '荃湾区', 3);
INSERT INTO `t_city` VALUES (3381, 395, '中西区', 3);
INSERT INTO `t_city` VALUES (3382, 395, '离岛区', 3);
INSERT INTO `t_city` VALUES (3383, 396, '澳门', 3);
INSERT INTO `t_city` VALUES (3384, 397, '台北', 3);
INSERT INTO `t_city` VALUES (3385, 397, '高雄', 3);
INSERT INTO `t_city` VALUES (3386, 397, '基隆', 3);
INSERT INTO `t_city` VALUES (3387, 397, '台中', 3);
INSERT INTO `t_city` VALUES (3388, 397, '台南', 3);
INSERT INTO `t_city` VALUES (3389, 397, '新竹', 3);
INSERT INTO `t_city` VALUES (3390, 397, '嘉义', 3);
INSERT INTO `t_city` VALUES (3391, 397, '宜兰县', 3);
INSERT INTO `t_city` VALUES (3392, 397, '桃园县', 3);
INSERT INTO `t_city` VALUES (3393, 397, '苗栗县', 3);
INSERT INTO `t_city` VALUES (3394, 397, '彰化县', 3);
INSERT INTO `t_city` VALUES (3395, 397, '南投县', 3);
INSERT INTO `t_city` VALUES (3396, 397, '云林县', 3);
INSERT INTO `t_city` VALUES (3397, 397, '屏东县', 3);
INSERT INTO `t_city` VALUES (3398, 397, '台东县', 3);
INSERT INTO `t_city` VALUES (3399, 397, '花莲县', 3);
INSERT INTO `t_city` VALUES (3400, 397, '澎湖县', 3);
INSERT INTO `t_city` VALUES (3401, 3, '合肥', 2);
INSERT INTO `t_city` VALUES (3402, 3401, '庐阳区', 3);
INSERT INTO `t_city` VALUES (3403, 3401, '瑶海区', 3);
INSERT INTO `t_city` VALUES (3404, 3401, '蜀山区', 3);
INSERT INTO `t_city` VALUES (3405, 3401, '包河区', 3);
INSERT INTO `t_city` VALUES (3406, 3401, '长丰县', 3);
INSERT INTO `t_city` VALUES (3407, 3401, '肥东县', 3);
INSERT INTO `t_city` VALUES (3408, 3401, '肥西县', 3);

-- ----------------------------
-- Table structure for t_config
-- ----------------------------
DROP TABLE IF EXISTS `t_config`;
CREATE TABLE `t_config`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '变量名',
  `group` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '分组',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '变量标题',
  `tip` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '变量描述',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '类型:string,text,int,bool,array,datetime,date,file',
  `visible` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '可见条件',
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '变量值',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '变量字典数据',
  `rule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '验证规则',
  `extend` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '扩展属性',
  `setting` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '配置',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_config
-- ----------------------------
INSERT INTO `t_config` VALUES (1, 'name', 'basic', 'Site name', '请填写站点名称', 'string', '', 'stock', '', 'required', '', NULL);
INSERT INTO `t_config` VALUES (2, 'beian', 'basic', 'Beian', '粤ICP备15000000号-1', 'string', '', '', '', '', '', NULL);
INSERT INTO `t_config` VALUES (3, 'cdnurl', 'basic', 'Cdn url', '如果全站静态资源使用第三方云储存请配置该值', 'string', '', '', '', '', '', '');
INSERT INTO `t_config` VALUES (4, 'version', 'basic', 'Version', '如果静态资源有变动请重新配置该值', 'string', '', '1.0.115', '', 'required', '', NULL);
INSERT INTO `t_config` VALUES (5, 'timezone', 'basic', 'Timezone', '', 'string', '', 'Asia/Shanghai', '', 'required', '', NULL);
INSERT INTO `t_config` VALUES (6, 'forbiddenip', 'basic', 'Forbidden ip', '一行一条记录', 'text', '', '', '', '', '', NULL);
INSERT INTO `t_config` VALUES (7, 'languages', 'basic', 'Languages', '', 'array', '', '{\"backend\":\"zh-cn\",\"frontend\":\"zh-cn\"}', '', 'required', '', NULL);
INSERT INTO `t_config` VALUES (8, 'fixedpage', 'basic', 'Fixed page', '请输入左侧菜单栏存在的链接', 'string', '', 'dashboard', '', 'required', '', NULL);
INSERT INTO `t_config` VALUES (9, 'categorytype', 'dictionary', 'Category type', '', 'array', '', '{\"default\":\"Default\",\"page\":\"Page\",\"article\":\"Article\",\"test\":\"Test\"}', '', '', '', '');
INSERT INTO `t_config` VALUES (10, 'configgroup', 'dictionary', 'Config group', '', 'array', '', '{\"basic\":\"Basic\",\"email\":\"Email\",\"dictionary\":\"Dictionary\",\"user\":\"User\",\"example\":\"Example\"}', '', '', '', '');
INSERT INTO `t_config` VALUES (11, 'mail_type', 'email', 'Mail type', '选择邮件发送方式', 'select', '', '1', '[\"请选择\",\"SMTP\"]', '', '', '');
INSERT INTO `t_config` VALUES (12, 'mail_smtp_host', 'email', 'Mail smtp host', '错误的配置发送邮件会导致服务器超时', 'string', '', 'smtp.qq.com', '', '', '', '');
INSERT INTO `t_config` VALUES (13, 'mail_smtp_port', 'email', 'Mail smtp port', '(不加密默认25,SSL默认465,TLS默认587)', 'string', '', '465', '', '', '', '');
INSERT INTO `t_config` VALUES (14, 'mail_smtp_user', 'email', 'Mail smtp user', '（填写完整用户名）', 'string', '', '', '', '', '', '');
INSERT INTO `t_config` VALUES (15, 'mail_smtp_pass', 'email', 'Mail smtp password', '（填写您的密码或授权码）', 'password', '', '', '', '', '', '');
INSERT INTO `t_config` VALUES (16, 'mail_verify_type', 'email', 'Mail vertify type', '（SMTP验证方式[推荐SSL]）', 'select', '', '2', '[\"无\",\"TLS\",\"SSL\"]', '', '', '');
INSERT INTO `t_config` VALUES (17, 'mail_from', 'email', 'Mail from', '', 'string', '', '', '', '', '', '');
INSERT INTO `t_config` VALUES (18, 'attachmentcategory', 'dictionary', 'Attachment category', '', 'array', '', '{\"category1\":\"Category1\",\"category2\":\"Category2\",\"custom\":\"Custom\"}', '', '', '', '');

-- ----------------------------
-- Table structure for t_e_uid
-- ----------------------------
DROP TABLE IF EXISTS `t_e_uid`;
CREATE TABLE `t_e_uid`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `e_uid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户别名',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `e_uid`(`e_uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户映射表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_e_uid
-- ----------------------------

-- ----------------------------
-- Table structure for t_invite_rebate
-- ----------------------------
DROP TABLE IF EXISTS `t_invite_rebate`;
CREATE TABLE `t_invite_rebate`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增字段',
  `uid` bigint(20) NULL DEFAULT 0 COMMENT 'uid',
  `money` decimal(20, 2) NOT NULL COMMENT '产品价格',
  `itime` int(11) NOT NULL COMMENT '创建时间',
  `utime` int(11) NOT NULL COMMENT '更新时间',
  `num` int(11) NULL DEFAULT 0 COMMENT '数量',
  `day` date NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `invite_rebate_only`(`uid`, `num`, `day`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '邀请返利' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_invite_rebate
-- ----------------------------

-- ----------------------------
-- Table structure for t_invite_relation
-- ----------------------------
DROP TABLE IF EXISTS `t_invite_relation`;
CREATE TABLE `t_invite_relation`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标记id',
  `uid` int(11) NOT NULL COMMENT 'uid',
  `pid` int(11) NOT NULL COMMENT 'pid',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `invite_relation_only`(`uid`, `pid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '邀请映射' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_invite_relation
-- ----------------------------

-- ----------------------------
-- Table structure for t_news
-- ----------------------------
DROP TABLE IF EXISTS `t_news`;
CREATE TABLE `t_news`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标记id, 主键，自增字段',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题, 存储文章或内容的标题',
  `author` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '作者, 存储内容的作者',
  `coverUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '封面, 存储内容的封面图片URL, 默认为NULL',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容, 存储富文本格式的内容',
  `type` int(1) NOT NULL DEFAULT 1 COMMENT '状态, 1 为启用，2 为关闭',
  `itime` int(11) NOT NULL COMMENT '创建时间, 存储内容的创建时间 (Unix 时间戳)',
  `utime` int(11) NOT NULL COMMENT '更新时间, 存储内容的最后更新时间 (Unix 时间戳)',
  `deletetime` int(11) NULL DEFAULT NULL COMMENT '删除',
  `is_new` int(11) NULL DEFAULT 0 COMMENT '1-最新',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '新闻表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_news
-- ----------------------------

-- ----------------------------
-- Table structure for t_notice
-- ----------------------------
DROP TABLE IF EXISTS `t_notice`;
CREATE TABLE `t_notice`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标记id',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '内容',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态 1为启用 2为关闭',
  `itime` int(11) NOT NULL COMMENT '创建时间',
  `utime` int(11) NOT NULL COMMENT '更新时间',
  `uid` int(11) NULL DEFAULT 0 COMMENT '用户ID',
  `msg_type` int(11) NULL DEFAULT 0 COMMENT '消息类型',
  `is_read` int(11) NULL DEFAULT 0 COMMENT '1-已读',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_notice
-- ----------------------------

-- ----------------------------
-- Table structure for t_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `t_notice_read`;
CREATE TABLE `t_notice_read`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增字段',
  `uid` bigint(20) NULL DEFAULT 0 COMMENT 'uid',
  `notice_id` int(20) NULL DEFAULT 0 COMMENT '公告ID',
  `itime` int(11) NOT NULL COMMENT '创建时间',
  `utime` int(11) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `read_only`(`uid`, `notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '公告已读表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_notice_read
-- ----------------------------

-- ----------------------------
-- Table structure for t_pay
-- ----------------------------
DROP TABLE IF EXISTS `t_pay`;
CREATE TABLE `t_pay`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标记id',
  `uid` bigint(20) NOT NULL COMMENT '用户id',
  `otn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单号',
  `money` decimal(20, 2) NULL DEFAULT NULL COMMENT '充值金额',
  `pay_type` tinyint(4) NULL DEFAULT 0 COMMENT '支付渠道',
  `sys_id` int(11) NULL DEFAULT 0 COMMENT '支付ID',
  `type` int(11) NULL DEFAULT 1 COMMENT '1-待支付 2-成功 3-失败',
  `request` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求',
  `response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '响应',
  `itime` int(11) NULL DEFAULT 0,
  `utime` int(11) NULL DEFAULT 0,
  `paytime` int(11) NULL DEFAULT 0 COMMENT '支付时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `pay_only`(`otn`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '支付表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_pay
-- ----------------------------

-- ----------------------------
-- Table structure for t_pay_config
-- ----------------------------
DROP TABLE IF EXISTS `t_pay_config`;
CREATE TABLE `t_pay_config`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `payNo` int(11) NOT NULL DEFAULT 0 COMMENT '通道编号',
  `payname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '支付名称',
  `minMoney` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '单笔最小金额',
  `maxMoney` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '单笔最大金额',
  `appKey` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'appkey/商户号',
  `appSecret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Secret',
  `appPrivate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '私钥或appId',
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '备注',
  `payConfigType` tinyint(1) NOT NULL DEFAULT 1 COMMENT '支付类型: 1支付宝 2微信 3银行卡',
  `payType` tinyint(1) NOT NULL DEFAULT 1 COMMENT '启用类型: 1投资 2充值 3混合',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `agent_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '通道编码',
  `payUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '下单地址',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态:1启用 2关闭',
  `itime` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `utime` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_pay_type`(`payConfigType`, `payType`, `type`) USING BTREE,
  INDEX `idx_money_range`(`minMoney`, `maxMoney`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '支付配置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_pay_config
-- ----------------------------
INSERT INTO `t_pay_config` VALUES (1, 1, '微信通道01', 100.00, 1000.00, 'wx_merchant', 'secret', '', '测试微信通道01', 2, 2, 100, 'WX01', '', 1, 1770896223, 1770896223);
INSERT INTO `t_pay_config` VALUES (2, 2, '支付宝通道01', 100.00, 2000.00, 'ali_merchant', 'secret', '', '测试支付宝通道01', 1, 2, 100, 'ALI01', '', 1, 1770896223, 1770896223);
INSERT INTO `t_pay_config` VALUES (3, 3, '银联通道01', 100.00, 5000.00, 'bank_merchant', 'secret', '', '测试银联通道01', 3, 2, 100, 'BANK01', '', 1, 1770896223, 1770896223);

-- ----------------------------
-- Table structure for t_product
-- ----------------------------
DROP TABLE IF EXISTS `t_product`;
CREATE TABLE `t_product`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品名称',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '商品图片相对路径',
  `price` int(11) NOT NULL DEFAULT 0 COMMENT '商品价格（单位：分或积分，与你现有业务保持一致）',
  `points` int(11) NOT NULL DEFAULT 0 COMMENT '兑换所需积分',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '商品说明',
  `is_hot` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否热门：1-热门 0-否',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序值，越小越靠前',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：1-启用 2-关闭',
  `limit_num` int(11) NOT NULL DEFAULT 0 COMMENT '单用户购买/兑换限制数量，0表示不限制',
  `product_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '产品类型（与现有业务一致）',
  `day` int(11) NOT NULL DEFAULT 0 COMMENT '产品天数（如原理财产品用，可按需保留/忽略）',
  `day_income` int(11) NOT NULL DEFAULT 0 COMMENT '每日收益',
  `allowance` int(11) NOT NULL DEFAULT 0 COMMENT '产品补助',
  `month` int(11) NOT NULL DEFAULT 0 COMMENT '产品月数',
  `month_income` int(11) NOT NULL DEFAULT 0 COMMENT '每月补助',
  `itime` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间戳',
  `utime` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_type`(`type`) USING BTREE,
  INDEX `idx_is_hot`(`is_hot`) USING BTREE,
  INDEX `idx_sort`(`sort`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '积分商城商品表（t_product）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_product
-- ----------------------------

-- ----------------------------
-- Table structure for t_product0
-- ----------------------------
DROP TABLE IF EXISTS `t_product0`;
CREATE TABLE `t_product0`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增字段',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '产品名称',
  `price` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '产品价格',
  `day` int(11) NULL DEFAULT 0 COMMENT '产品天数',
  `day_income` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '每日收益',
  `allowance` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '产品补助',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '产品说明',
  `is_hot` int(1) NOT NULL DEFAULT 0 COMMENT '1-热门',
  `limit_num` int(11) NULL DEFAULT 0 COMMENT '限制份数',
  `sort` int(1) NULL DEFAULT 0 COMMENT '排序',
  `type` int(1) NOT NULL DEFAULT 1 COMMENT '状态, 1 为启用，2 为关闭',
  `itime` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间, 存储内容的创建时间 (Unix 时间戳)',
  `utime` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间, 存储内容的最后更新时间 (Unix 时间戳)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '产品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_product0
-- ----------------------------

-- ----------------------------
-- Table structure for t_real
-- ----------------------------
DROP TABLE IF EXISTS `t_real`;
CREATE TABLE `t_real`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) NOT NULL COMMENT '用户id',
  `realName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `IDCard` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `IDFrontUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证正面 国徽',
  `IDOppositeUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证反面 人像',
  `type` int(11) NULL DEFAULT 1 COMMENT '1-创建 2-通过 3-拒绝',
  `itime` int(11) NULL DEFAULT 0,
  `utime` int(11) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '实名认证' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_real
-- ----------------------------
INSERT INTO `t_real` VALUES (1, 3, '141', '370704199002031838', '/uploads/9dd51b01d40cebf4488d15ff2e02120383890454.jpg', '/uploads/37bf1e180c4c38f285770f66c2f96780c973d871.jpg', 1, 1770896018, 1770896018);

-- ----------------------------
-- Table structure for t_request_log
-- ----------------------------
DROP TABLE IF EXISTS `t_request_log`;
CREATE TABLE `t_request_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `uid` bigint(20) NOT NULL DEFAULT 0 COMMENT 'uid',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标题, 存储文章或内容的标题',
  `method` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '',
  `request` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求',
  `response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '响应',
  `itime` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间, 存储内容的创建时间 (Unix 时间戳)',
  `utime` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间, 存储内容的最后更新时间 (Unix 时间戳)',
  `status_code` int(11) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 340 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_request_log
-- ----------------------------
INSERT INTO `t_request_log` VALUES (1, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/14.0.3 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"accept-language\":[\"zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2\"],\"accept-encoding\":[\"gzip, deflate\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"content-length\":[\"41\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"connection\":[\"keep-alive\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/login\"]},\"body\":\"{\\\"account\\\":\\\"1\\\",\\\"password\\\":\\\"1\\\",\\\"code\\\":\\\"1\\\"}\"}', NULL, 1769870084, 0, 200);
INSERT INTO `t_request_log` VALUES (2, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"41\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1\\\",\\\"password\\\":\\\"2\\\",\\\"code\\\":\\\"3\\\"}\"}', NULL, 1769870117, 0, 200);
INSERT INTO `t_request_log` VALUES (3, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"30\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1\\\",\\\"password\\\":\\\"2\\\"}\"}', NULL, 1769871091, 0, 200);
INSERT INTO `t_request_log` VALUES (4, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"30\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1\\\",\\\"password\\\":\\\"2\\\"}\"}', '{\"code\":402,\"message\":\"\\u5bc6\\u7801\\u9519\\u8bef \\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\\u4eba\\u5458\"}', 1769871261, 1769871261, 200);
INSERT INTO `t_request_log` VALUES (5, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"86\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"18888888888\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', NULL, 1769872379, 0, 200);
INSERT INTO `t_request_log` VALUES (6, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"86\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"18888888888\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', NULL, 1769872617, 0, 200);
INSERT INTO `t_request_log` VALUES (7, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"86\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"18888888888\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769872794, 1769872794, 200);
INSERT INTO `t_request_log` VALUES (8, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"86\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"18888888888\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769872806, 1769872806, 200);
INSERT INTO `t_request_log` VALUES (9, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"86\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"18888888888\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769872807, 1769872807, 200);
INSERT INTO `t_request_log` VALUES (10, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"86\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"18888888888\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769872808, 1769872808, 200);
INSERT INTO `t_request_log` VALUES (11, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"86\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"18888888888\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769872809, 1769872809, 200);
INSERT INTO `t_request_log` VALUES (12, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"86\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"18888888888\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769872810, 1769872810, 200);
INSERT INTO `t_request_log` VALUES (13, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"86\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"18888888888\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769872811, 1769872811, 200);
INSERT INTO `t_request_log` VALUES (14, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"86\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"18888888888\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769872812, 1769872812, 200);
INSERT INTO `t_request_log` VALUES (15, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"86\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"18888888888\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769872813, 1769872813, 200);
INSERT INTO `t_request_log` VALUES (16, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"18888888888\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"1111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769872851, 1769872851, 200);
INSERT INTO `t_request_log` VALUES (17, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873102, 1769873102, 200);
INSERT INTO `t_request_log` VALUES (18, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873104, 1769873104, 200);
INSERT INTO `t_request_log` VALUES (19, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873109, 1769873109, 200);
INSERT INTO `t_request_log` VALUES (20, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873110, 1769873110, 200);
INSERT INTO `t_request_log` VALUES (21, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873111, 1769873111, 200);
INSERT INTO `t_request_log` VALUES (22, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873112, 1769873112, 200);
INSERT INTO `t_request_log` VALUES (23, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873113, 1769873113, 200);
INSERT INTO `t_request_log` VALUES (24, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873113, 1769873113, 200);
INSERT INTO `t_request_log` VALUES (25, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873114, 1769873114, 200);
INSERT INTO `t_request_log` VALUES (26, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873114, 1769873114, 200);
INSERT INTO `t_request_log` VALUES (27, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873115, 1769873115, 200);
INSERT INTO `t_request_log` VALUES (28, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873116, 1769873116, 200);
INSERT INTO `t_request_log` VALUES (29, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873116, 1769873116, 200);
INSERT INTO `t_request_log` VALUES (30, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873117, 1769873117, 200);
INSERT INTO `t_request_log` VALUES (31, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873118, 1769873118, 200);
INSERT INTO `t_request_log` VALUES (32, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"79\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873120, 1769873120, 200);
INSERT INTO `t_request_log` VALUES (33, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"82\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873206, 1769873206, 200);
INSERT INTO `t_request_log` VALUES (34, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"82\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"1111111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873207, 1769873207, 200);
INSERT INTO `t_request_log` VALUES (35, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"81\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"q11111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873220, 1769873220, 200);
INSERT INTO `t_request_log` VALUES (36, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"81\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"q11111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873221, 1769873221, 200);
INSERT INTO `t_request_log` VALUES (37, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"81\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"q11111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873222, 1769873222, 200);
INSERT INTO `t_request_log` VALUES (38, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"81\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"q11111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873223, 1769873223, 200);
INSERT INTO `t_request_log` VALUES (39, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"81\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"q11111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873223, 1769873223, 200);
INSERT INTO `t_request_log` VALUES (40, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"81\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"q11111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873223, 1769873223, 200);
INSERT INTO `t_request_log` VALUES (41, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"81\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"111111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873234, 1769873234, 200);
INSERT INTO `t_request_log` VALUES (42, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"81\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"111111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873235, 1769873235, 200);
INSERT INTO `t_request_log` VALUES (43, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"81\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"111111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873235, 1769873235, 200);
INSERT INTO `t_request_log` VALUES (44, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"81\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"111111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873236, 1769873236, 200);
INSERT INTO `t_request_log` VALUES (45, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"81\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"111111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873236, 1769873236, 200);
INSERT INTO `t_request_log` VALUES (46, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"81\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"111111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"1\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873347, 1769873347, 200);
INSERT INTO `t_request_log` VALUES (47, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"84\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873398, 1769873398, 200);
INSERT INTO `t_request_log` VALUES (48, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"84\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873403, 1769873403, 200);
INSERT INTO `t_request_log` VALUES (49, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"84\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873406, 1769873406, 200);
INSERT INTO `t_request_log` VALUES (50, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"84\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873407, 1769873407, 200);
INSERT INTO `t_request_log` VALUES (51, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"84\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873408, 1769873408, 200);
INSERT INTO `t_request_log` VALUES (52, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"84\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873409, 1769873409, 200);
INSERT INTO `t_request_log` VALUES (53, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"84\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873410, 1769873410, 200);
INSERT INTO `t_request_log` VALUES (54, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"84\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873411, 1769873411, 200);
INSERT INTO `t_request_log` VALUES (55, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"84\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873413, 1769873413, 200);
INSERT INTO `t_request_log` VALUES (56, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"84\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873415, 1769873415, 200);
INSERT INTO `t_request_log` VALUES (57, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"84\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873418, 1769873418, 200);
INSERT INTO `t_request_log` VALUES (58, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"84\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873422, 1769873422, 200);
INSERT INTO `t_request_log` VALUES (59, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"84\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769873425, 1769873425, 200);
INSERT INTO `t_request_log` VALUES (60, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u6ce8\\u518c\\u5931\\u8d25\"}', 1769873458, 1769873458, 200);
INSERT INTO `t_request_log` VALUES (61, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u6ce8\\u518c\\u5931\\u8d25\"}', 1769873479, 1769873479, 200);
INSERT INTO `t_request_log` VALUES (62, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u6ce8\\u518c\\u5931\\u8d25\"}', 1769873524, 1769873524, 200);
INSERT INTO `t_request_log` VALUES (63, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u6ce8\\u518c\\u5931\\u8d25\"}', 1769873542, 1769873542, 200);
INSERT INTO `t_request_log` VALUES (64, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u6ce8\\u518c\\u5931\\u8d25\"}', 1769873548, 1769873548, 200);
INSERT INTO `t_request_log` VALUES (65, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u6ce8\\u518c\\u5931\\u8d25\"}', 1769873552, 1769873552, 200);
INSERT INTO `t_request_log` VALUES (66, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u6ce8\\u518c\\u5931\\u8d25\"}', 1769873569, 1769873569, 200);
INSERT INTO `t_request_log` VALUES (67, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u6ce8\\u518c\\u5931\\u8d25\"}', 1769873584, 1769873584, 200);
INSERT INTO `t_request_log` VALUES (68, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u6ce8\\u518c\\u5931\\u8d25\"}', 1769873600, 1769873600, 200);
INSERT INTO `t_request_log` VALUES (69, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u6ce8\\u518c\\u5931\\u8d25\"}', 1769873746, 1769873746, 200);
INSERT INTO `t_request_log` VALUES (70, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u6ce8\\u518c\\u5931\\u8d25\"}', 1769873774, 1769873774, 200);
INSERT INTO `t_request_log` VALUES (71, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u6ce8\\u518c\\u5931\\u8d25\"}', 1769873821, 1769873821, 200);
INSERT INTO `t_request_log` VALUES (72, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"Setting unknown property: common\\\\models\\\\AccountInfo::last_login_time\"}', 1769873918, 1769873918, 200);
INSERT INTO `t_request_log` VALUES (73, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"Getting unknown property: common\\\\models\\\\AccountInfo::login_ip\"}', 1769873997, 1769873997, 200);
INSERT INTO `t_request_log` VALUES (74, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"Setting unknown property: common\\\\models\\\\AccountInfo::login_ip\"}', 1769874085, 1769874085, 200);
INSERT INTO `t_request_log` VALUES (75, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"Getting unknown property: common\\\\models\\\\AccountInfo::login_ip\"}', 1769874182, 1769874182, 200);
INSERT INTO `t_request_log` VALUES (76, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"Getting unknown property: common\\\\models\\\\AccountInfo::login_ip\"}', 1769874266, 1769874266, 200);
INSERT INTO `t_request_log` VALUES (77, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":\"212\",\"message\":\"Getting unknown property: common\\\\models\\\\AccountInfo::login_ip\"}', 1769874285, 1769874285, 200);
INSERT INTO `t_request_log` VALUES (78, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"87\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"qqq1111\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"WK7958\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"login_token\":\"MYoygThqMGtWs7RezWpukgtxMYH-G-td\",\"uid\":\"1\",\"e_uid\":\"\",\"invite_code\":\"qHUYMMZWSQ6IwkRT7MsH\",\"is_real\":\"0\"}}', 1769874582, 1769874582, 200);
INSERT INTO `t_request_log` VALUES (79, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"100\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"222222\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"qHUYMMZWSQ6IwkRT7MsH\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"login_token\":\"xNNGZkv3LSvG_86N88URKvjKYcwnePVM\",\"uid\":2,\"e_uid\":\"\",\"invite_code\":\"hSSBL9gU1Jg3mCBVE1k3\",\"is_real\":0}}', 1769875068, 1769875068, 200);
INSERT INTO `t_request_log` VALUES (80, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"86\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"333333\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"111111\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u9080\\u8bf7\\u7801\\u9519\\u8bef\\uff0c\\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\"}', 1769875240, 1769875240, 200);
INSERT INTO `t_request_log` VALUES (81, 0, '/register/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"100\"],\"sec-ch-ua-platform\":[\"\\\"Android\\\"\"],\"user-agent\":[\"Mozilla\\/5.0 (Linux; Android 6.0; Nexus 5 Build\\/MRA58N) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Mobile Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"sec-ch-ua-mobile\":[\"?1\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"333333\\\",\\\"password\\\":\\\"111111\\\",\\\"payPassword\\\":\\\"111111\\\",\\\"invite_code\\\":\\\"hSSBL9gU1Jg3mCBVE1k3\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"login_token\":\"m9-mZrJ1PswENDBqnuCl0nU5Ck1vFtXa\",\"uid\":3,\"e_uid\":\"\",\"invite_code\":\"AdjLdBwDAhKKSEJ7VIkR\",\"is_real\":0}}', 1769875250, 1769875250, 200);
INSERT INTO `t_request_log` VALUES (82, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"37\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"333\\\",\\\"password\\\":\\\"111111\\\"}\"}', '{\"code\":402,\"message\":\"\\u5bc6\\u7801\\u9519\\u8bef \\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\\u4eba\\u5458\"}', 1770120801, 1770120801, 200);
INSERT INTO `t_request_log` VALUES (83, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"37\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"333\\\",\\\"password\\\":\\\"111111\\\"}\"}', '{\"code\":402,\"message\":\"\\u5bc6\\u7801\\u9519\\u8bef \\u8bf7\\u8054\\u7cfb\\u5ba2\\u670d\\u4eba\\u5458\"}', 1770120807, 1770120807, 200);
INSERT INTO `t_request_log` VALUES (84, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"40\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"333333\\\",\\\"password\\\":\\\"111111\\\"}\"}', NULL, 1770120956, 0, 200);
INSERT INTO `t_request_log` VALUES (85, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"40\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"333333\\\",\\\"password\\\":\\\"111111\\\"}\"}', NULL, 1770121003, 0, 200);
INSERT INTO `t_request_log` VALUES (86, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"40\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"333333\\\",\\\"password\\\":\\\"111111\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"login_token\":\"fpcieqF8J4Lz-yj4NtWsQlIjDYt4w385\",\"uid\":3,\"e_uid\":\"\",\"invite_code\":\"AdjLdBwDAhKKSEJ7VIkR\",\"is_real\":0}}', 1770121048, 1770121048, 200);
INSERT INTO `t_request_log` VALUES (87, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"40\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"333333\\\",\\\"password\\\":\\\"111111\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"login_token\":\"fpcieqF8J4Lz-yj4NtWsQlIjDYt4w385\",\"uid\":3,\"e_uid\":\"\",\"invite_code\":\"AdjLdBwDAhKKSEJ7VIkR\",\"is_real\":0}}', 1770121104, 1770121104, 200);
INSERT INTO `t_request_log` VALUES (88, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"40\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"333333\\\",\\\"password\\\":\\\"111111\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"login_token\":\"YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\",\"uid\":3,\"e_uid\":\"\",\"invite_code\":\"AdjLdBwDAhKKSEJ7VIkR\",\"is_real\":0}}', 1770892517, 1770892517, 200);
INSERT INTO `t_request_log` VALUES (89, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770893927, 1770893927, 200);
INSERT INTO `t_request_log` VALUES (90, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770893961, 1770893961, 200);
INSERT INTO `t_request_log` VALUES (91, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894157, 1770894157, 200);
INSERT INTO `t_request_log` VALUES (92, 3, '/mall/points', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"points\":0,\"total_points\":0}}', 1770894221, 1770894221, 200);
INSERT INTO `t_request_log` VALUES (93, 3, '/mall/products?page=1&size=20', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894221, 1770894221, 200);
INSERT INTO `t_request_log` VALUES (94, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894279, 1770894279, 200);
INSERT INTO `t_request_log` VALUES (95, 3, '/sign-in/detail', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"0\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', NULL, 1770894280, 0, 200);
INSERT INTO `t_request_log` VALUES (96, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894300, 1770894300, 200);
INSERT INTO `t_request_log` VALUES (97, 3, '/mall/points', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"points\":0,\"total_points\":0}}', 1770894303, 1770894303, 200);
INSERT INTO `t_request_log` VALUES (98, 3, '/mall/products?page=1&size=20', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894303, 1770894303, 200);
INSERT INTO `t_request_log` VALUES (99, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894304, 1770894304, 200);
INSERT INTO `t_request_log` VALUES (100, 3, '/sign-in/detail', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"0\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', NULL, 1770894305, 0, 200);
INSERT INTO `t_request_log` VALUES (101, 3, '/sign-in/detail', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"0\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', NULL, 1770894318, 0, 200);
INSERT INTO `t_request_log` VALUES (102, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894352, 1770894352, 200);
INSERT INTO `t_request_log` VALUES (103, 3, '/help/data-management', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"100\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"name\\\":\\\"\\u5f20\\u5c0f\\u96ef\\\",\\\"id_number\\\":\\\"111\\\",\\\"projects\\\":\\\"111\\\",\\\"contribution\\\":\\\"221\\\",\\\"additional_notes\\\":\\\"21\\\"}\"}', NULL, 1770894361, 0, 200);
INSERT INTO `t_request_log` VALUES (104, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894381, 1770894381, 200);
INSERT INTO `t_request_log` VALUES (105, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894384, 1770894384, 200);
INSERT INTO `t_request_log` VALUES (106, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894384, 1770894384, 200);
INSERT INTO `t_request_log` VALUES (107, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894403, 1770894403, 200);
INSERT INTO `t_request_log` VALUES (108, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894403, 1770894403, 200);
INSERT INTO `t_request_log` VALUES (109, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894459, 1770894460, 200);
INSERT INTO `t_request_log` VALUES (110, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894460, 1770894460, 200);
INSERT INTO `t_request_log` VALUES (111, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894502, 1770894502, 200);
INSERT INTO `t_request_log` VALUES (112, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894502, 1770894502, 200);
INSERT INTO `t_request_log` VALUES (113, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894506, 1770894506, 200);
INSERT INTO `t_request_log` VALUES (114, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894506, 1770894506, 200);
INSERT INTO `t_request_log` VALUES (115, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894538, 1770894538, 200);
INSERT INTO `t_request_log` VALUES (116, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894538, 1770894538, 200);
INSERT INTO `t_request_log` VALUES (117, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894547, 1770894547, 200);
INSERT INTO `t_request_log` VALUES (118, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894548, 1770894548, 200);
INSERT INTO `t_request_log` VALUES (119, 3, '/help/data-management', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"97\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"name\\\":\\\"\\u5f20\\u5c0f\\u96ef\\\",\\\"id_number\\\":\\\"qw\\\",\\\"projects\\\":\\\"qw\\\",\\\"contribution\\\":\\\"qwqw\\\",\\\"additional_notes\\\":\\\"\\\"}\"}', NULL, 1770894555, 0, 200);
INSERT INTO `t_request_log` VALUES (120, 3, '/help/data-management', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"97\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"name\\\":\\\"\\u5f20\\u5c0f\\u96ef\\\",\\\"id_number\\\":\\\"qw\\\",\\\"projects\\\":\\\"qw\\\",\\\"contribution\\\":\\\"qwqw\\\",\\\"additional_notes\\\":\\\"\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u4fdd\\u5b58\\u5931\\u8d25\\uff0c\\u8bf7\\u7a0d\\u540e\\u91cd\\u8bd5\"}', 1770894583, 1770894583, 200);
INSERT INTO `t_request_log` VALUES (121, 3, '/help/data-management', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"97\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"name\\\":\\\"\\u5f20\\u5c0f\\u96ef\\\",\\\"id_number\\\":\\\"qw\\\",\\\"projects\\\":\\\"qw\\\",\\\"contribution\\\":\\\"qwqw\\\",\\\"additional_notes\\\":\\\"\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u4fdd\\u5b58\\u5931\\u8d25\\uff0c\\u8bf7\\u7a0d\\u540e\\u91cd\\u8bd5\"}', 1770894584, 1770894584, 200);
INSERT INTO `t_request_log` VALUES (122, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894604, 1770894604, 200);
INSERT INTO `t_request_log` VALUES (123, 3, '/mall/points', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"points\":0,\"total_points\":0}}', 1770894605, 1770894605, 200);
INSERT INTO `t_request_log` VALUES (124, 3, '/mall/products?page=1&size=20', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894605, 1770894605, 200);
INSERT INTO `t_request_log` VALUES (125, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894710, 1770894710, 200);
INSERT INTO `t_request_log` VALUES (126, 3, '/sign-in/detail', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"0\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', NULL, 1770894711, 0, 200);
INSERT INTO `t_request_log` VALUES (127, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894743, 1770894743, 200);
INSERT INTO `t_request_log` VALUES (128, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894744, 1770894744, 200);
INSERT INTO `t_request_log` VALUES (129, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894744, 1770894744, 200);
INSERT INTO `t_request_log` VALUES (130, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":0,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770894747, 1770894747, 200);
INSERT INTO `t_request_log` VALUES (131, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":0,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770894800, 1770894800, 200);
INSERT INTO `t_request_log` VALUES (132, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894801, 1770894801, 200);
INSERT INTO `t_request_log` VALUES (133, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894801, 1770894801, 200);
INSERT INTO `t_request_log` VALUES (134, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894802, 1770894802, 200);
INSERT INTO `t_request_log` VALUES (135, 3, '/help/data-management', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"93\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"name\\\":\\\"\\u5f20\\u5c0f\\u96ef\\\",\\\"id_number\\\":\\\"1\\\",\\\"projects\\\":\\\"1\\\",\\\"contribution\\\":\\\"1\\\",\\\"additional_notes\\\":\\\"1\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":null}', 1770894808, 1770894808, 200);
INSERT INTO `t_request_log` VALUES (136, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894808, 1770894808, 200);
INSERT INTO `t_request_log` VALUES (137, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894900, 1770894900, 200);
INSERT INTO `t_request_log` VALUES (138, 3, '/sign-in/detail', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"0\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', NULL, 1770894901, 0, 200);
INSERT INTO `t_request_log` VALUES (139, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894928, 1770894928, 200);
INSERT INTO `t_request_log` VALUES (140, 3, '/mall/points', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"points\":0,\"total_points\":0}}', 1770894936, 1770894936, 200);
INSERT INTO `t_request_log` VALUES (141, 3, '/mall/products?page=1&size=20', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894936, 1770894936, 200);
INSERT INTO `t_request_log` VALUES (142, 3, '/mall/points', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"points\":0,\"total_points\":0}}', 1770894948, 1770894948, 200);
INSERT INTO `t_request_log` VALUES (143, 3, '/mall/products?page=1&size=20', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894948, 1770894948, 200);
INSERT INTO `t_request_log` VALUES (144, 3, '/mall/points', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"points\":0,\"total_points\":0}}', 1770894979, 1770894979, 200);
INSERT INTO `t_request_log` VALUES (145, 3, '/mall/products?page=1&size=20', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894980, 1770894980, 200);
INSERT INTO `t_request_log` VALUES (146, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894984, 1770894984, 200);
INSERT INTO `t_request_log` VALUES (147, 3, '/help/data-management-latest', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"name\":\"\\u5f20\\u5c0f\\u96ef\",\"id_number\":\"1\",\"projects\":\"1\",\"contribution\":\"1.00\",\"additional_notes\":\"1\"}}', 1770894985, 1770894985, 200);
INSERT INTO `t_request_log` VALUES (148, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770894995, 1770894995, 200);
INSERT INTO `t_request_log` VALUES (149, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894996, 1770894996, 200);
INSERT INTO `t_request_log` VALUES (150, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770894996, 1770894996, 200);
INSERT INTO `t_request_log` VALUES (151, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":0,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770894997, 1770894997, 200);
INSERT INTO `t_request_log` VALUES (152, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":0,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770895042, 1770895042, 200);
INSERT INTO `t_request_log` VALUES (153, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895043, 1770895043, 200);
INSERT INTO `t_request_log` VALUES (154, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895043, 1770895043, 200);
INSERT INTO `t_request_log` VALUES (155, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895046, 1770895046, 200);
INSERT INTO `t_request_log` VALUES (156, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895110, 1770895110, 200);
INSERT INTO `t_request_log` VALUES (157, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895110, 1770895110, 200);
INSERT INTO `t_request_log` VALUES (158, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895111, 1770895111, 200);
INSERT INTO `t_request_log` VALUES (159, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895118, 1770895118, 200);
INSERT INTO `t_request_log` VALUES (160, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895118, 1770895118, 200);
INSERT INTO `t_request_log` VALUES (161, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895216, 1770895216, 200);
INSERT INTO `t_request_log` VALUES (162, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895216, 1770895216, 200);
INSERT INTO `t_request_log` VALUES (163, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895270, 1770895270, 200);
INSERT INTO `t_request_log` VALUES (164, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895270, 1770895270, 200);
INSERT INTO `t_request_log` VALUES (165, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895304, 1770895304, 200);
INSERT INTO `t_request_log` VALUES (166, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895304, 1770895304, 200);
INSERT INTO `t_request_log` VALUES (167, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895307, 1770895307, 200);
INSERT INTO `t_request_log` VALUES (168, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895307, 1770895307, 200);
INSERT INTO `t_request_log` VALUES (169, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895310, 1770895310, 200);
INSERT INTO `t_request_log` VALUES (170, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895315, 1770895315, 200);
INSERT INTO `t_request_log` VALUES (171, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895320, 1770895320, 200);
INSERT INTO `t_request_log` VALUES (172, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895320, 1770895320, 200);
INSERT INTO `t_request_log` VALUES (173, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895323, 1770895323, 200);
INSERT INTO `t_request_log` VALUES (174, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895323, 1770895323, 200);
INSERT INTO `t_request_log` VALUES (175, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895331, 1770895331, 200);
INSERT INTO `t_request_log` VALUES (176, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895331, 1770895331, 200);
INSERT INTO `t_request_log` VALUES (177, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895350, 1770895350, 200);
INSERT INTO `t_request_log` VALUES (178, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895350, 1770895350, 200);
INSERT INTO `t_request_log` VALUES (179, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895352, 1770895352, 200);
INSERT INTO `t_request_log` VALUES (180, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', NULL, 1770895354, 0, 200);
INSERT INTO `t_request_log` VALUES (181, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"alipay\\\"}\"}', NULL, 1770895357, 0, 200);
INSERT INTO `t_request_log` VALUES (182, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', NULL, 1770895390, 0, 200);
INSERT INTO `t_request_log` VALUES (183, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', NULL, 1770895442, 0, 200);
INSERT INTO `t_request_log` VALUES (184, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"alipay\\\"}\"}', NULL, 1770895444, 0, 200);
INSERT INTO `t_request_log` VALUES (185, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895447, 1770895447, 200);
INSERT INTO `t_request_log` VALUES (186, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895447, 1770895447, 200);
INSERT INTO `t_request_log` VALUES (187, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895454, 1770895454, 200);
INSERT INTO `t_request_log` VALUES (188, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895454, 1770895454, 200);
INSERT INTO `t_request_log` VALUES (189, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895457, 1770895457, 200);
INSERT INTO `t_request_log` VALUES (190, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', NULL, 1770895458, 0, 200);
INSERT INTO `t_request_log` VALUES (191, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895462, 1770895462, 200);
INSERT INTO `t_request_log` VALUES (192, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895462, 1770895462, 200);
INSERT INTO `t_request_log` VALUES (193, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895463, 1770895463, 200);
INSERT INTO `t_request_log` VALUES (194, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', NULL, 1770895465, 0, 200);
INSERT INTO `t_request_log` VALUES (195, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895528, 1770895528, 200);
INSERT INTO `t_request_log` VALUES (196, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895528, 1770895528, 200);
INSERT INTO `t_request_log` VALUES (197, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895530, 1770895530, 200);
INSERT INTO `t_request_log` VALUES (198, 3, '/wallet/transactions?year=2026&month=01&wallet_type=1', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[],\"count\":\"0\"}}', 1770895530, 1770895530, 200);
INSERT INTO `t_request_log` VALUES (199, 3, '/wallet/transactions?year=2024&month=01&wallet_type=1', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[],\"count\":\"0\"}}', 1770895536, 1770895536, 200);
INSERT INTO `t_request_log` VALUES (200, 3, '/wallet/transactions?year=2025&month=01&wallet_type=1', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[],\"count\":\"0\"}}', 1770895540, 1770895540, 200);
INSERT INTO `t_request_log` VALUES (201, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895634, 1770895634, 200);
INSERT INTO `t_request_log` VALUES (202, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895634, 1770895634, 200);
INSERT INTO `t_request_log` VALUES (203, 3, '/team/stats', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0}}', 1770895635, 1770895635, 200);
INSERT INTO `t_request_log` VALUES (204, 3, '/team/list?page=1&pageSize=10', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"list\":[],\"count\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0,\"reward\":[{\"key\":5,\"value\":88},{\"key\":10,\"value\":288},{\"key\":25,\"value\":888},{\"key\":50,\"value\":2088},{\"key\":100,\"value\":6888}]}}', 1770895636, 1770895636, 200);
INSERT INTO `t_request_log` VALUES (205, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895723, 1770895723, 200);
INSERT INTO `t_request_log` VALUES (206, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895723, 1770895723, 200);
INSERT INTO `t_request_log` VALUES (207, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":0,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770895724, 1770895724, 200);
INSERT INTO `t_request_log` VALUES (208, 3, '/upload/file', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"1217\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"multipart\\/form-data; boundary=----WebKitFormBoundaryCwT28wAiaXnM9BhP\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"filePath\":\"\\/uploads\\/377cb7cf3257f5fc4829260e8a3fa8b400468deb.jpg\",\"url\":\"\\/uploads\\/377cb7cf3257f5fc4829260e8a3fa8b400468deb.jpg\"}}', 1770895744, 1770895744, 200);
INSERT INTO `t_request_log` VALUES (209, 3, '/upload/file', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"1217\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"multipart\\/form-data; boundary=----WebKitFormBoundaryBSxU2jkq6BLICGem\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"filePath\":\"\\/uploads\\/98706f038d57e189f561a1a35019b645c81fdc2e.jpg\",\"url\":\"\\/uploads\\/98706f038d57e189f561a1a35019b645c81fdc2e.jpg\"}}', 1770895749, 1770895749, 200);
INSERT INTO `t_request_log` VALUES (210, 3, '/auth/identity', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"171\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"name\\\":\\\"1\\\",\\\"id_card\\\":\\\"1\\\",\\\"id_front_image\\\":\\\"\\/uploads\\/377cb7cf3257f5fc4829260e8a3fa8b400468deb.jpg\\\",\\\"id_back_image\\\":\\\"\\/uploads\\/98706f038d57e189f561a1a35019b645c81fdc2e.jpg\\\"}\"}', '{\"code\":201,\"message\":\"realName\\u53c2\\u6570\\u4e0d\\u8db3\"}', 1770895755, 1770895755, 200);
INSERT INTO `t_request_log` VALUES (211, 3, '/auth/identity', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"171\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"name\\\":\\\"1\\\",\\\"id_card\\\":\\\"1\\\",\\\"id_front_image\\\":\\\"\\/uploads\\/377cb7cf3257f5fc4829260e8a3fa8b400468deb.jpg\\\",\\\"id_back_image\\\":\\\"\\/uploads\\/98706f038d57e189f561a1a35019b645c81fdc2e.jpg\\\"}\"}', '{\"code\":201,\"message\":\"realName\\u53c2\\u6570\\u4e0d\\u8db3\"}', 1770895764, 1770895764, 200);
INSERT INTO `t_request_log` VALUES (212, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":0,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770895807, 1770895807, 200);
INSERT INTO `t_request_log` VALUES (213, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895808, 1770895808, 200);
INSERT INTO `t_request_log` VALUES (214, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895808, 1770895808, 200);
INSERT INTO `t_request_log` VALUES (215, 3, '/team/stats', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0}}', 1770895810, 1770895810, 200);
INSERT INTO `t_request_log` VALUES (216, 3, '/team/list?page=1&pageSize=10', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"list\":[],\"count\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0,\"reward\":[{\"key\":5,\"value\":88},{\"key\":10,\"value\":288},{\"key\":25,\"value\":888},{\"key\":50,\"value\":2088},{\"key\":100,\"value\":6888}]}}', 1770895810, 1770895810, 200);
INSERT INTO `t_request_log` VALUES (217, 3, '/team/stats', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"sec-ch-ua-platform\":[\"\\\"Windows\\\"\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"sec-ch-ua-mobile\":[\"?0\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0}}', 1770895880, 1770895880, 200);
INSERT INTO `t_request_log` VALUES (218, 3, '/team/list?page=1&pageSize=10', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"sec-ch-ua-platform\":[\"\\\"Windows\\\"\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/144.0.0.0 Safari\\/537.36\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"sec-ch-ua\":[\"\\\"Not(A:Brand\\\";v=\\\"8\\\", \\\"Chromium\\\";v=\\\"144\\\", \\\"Google Chrome\\\";v=\\\"144\\\"\"],\"sec-ch-ua-mobile\":[\"?0\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"list\":[],\"count\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0,\"reward\":[{\"key\":5,\"value\":88},{\"key\":10,\"value\":288},{\"key\":25,\"value\":888},{\"key\":50,\"value\":2088},{\"key\":100,\"value\":6888}]}}', 1770895880, 1770895880, 200);
INSERT INTO `t_request_log` VALUES (219, 3, '/team/stats', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0}}', 1770895890, 1770895890, 200);
INSERT INTO `t_request_log` VALUES (220, 3, '/team/list?page=1&pageSize=10', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"list\":[],\"count\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0,\"reward\":[{\"key\":5,\"value\":88},{\"key\":10,\"value\":288},{\"key\":25,\"value\":888},{\"key\":50,\"value\":2088},{\"key\":100,\"value\":6888}]}}', 1770895890, 1770895890, 200);
INSERT INTO `t_request_log` VALUES (221, 3, '/team/stats', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0}}', 1770895893, 1770895893, 200);
INSERT INTO `t_request_log` VALUES (222, 3, '/team/list?page=1&pageSize=10', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"list\":[],\"count\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0,\"reward\":[{\"key\":5,\"value\":88},{\"key\":10,\"value\":288},{\"key\":25,\"value\":888},{\"key\":50,\"value\":2088},{\"key\":100,\"value\":6888}]}}', 1770895893, 1770895893, 200);
INSERT INTO `t_request_log` VALUES (223, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895903, 1770895903, 200);
INSERT INTO `t_request_log` VALUES (224, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895903, 1770895903, 200);
INSERT INTO `t_request_log` VALUES (225, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895905, 1770895905, 200);
INSERT INTO `t_request_log` VALUES (226, 3, '/wallet/transactions?year=2026&month=01&wallet_type=1', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[],\"count\":\"0\"}}', 1770895905, 1770895905, 200);
INSERT INTO `t_request_log` VALUES (227, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895907, 1770895907, 200);
INSERT INTO `t_request_log` VALUES (228, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895907, 1770895907, 200);
INSERT INTO `t_request_log` VALUES (229, 3, '/team/stats', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0}}', 1770895908, 1770895908, 200);
INSERT INTO `t_request_log` VALUES (230, 3, '/team/list?page=1&pageSize=10', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"list\":[],\"count\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0,\"reward\":[{\"key\":5,\"value\":88},{\"key\":10,\"value\":288},{\"key\":25,\"value\":888},{\"key\":50,\"value\":2088},{\"key\":100,\"value\":6888}]}}', 1770895908, 1770895908, 200);
INSERT INTO `t_request_log` VALUES (231, 3, '/team/stats', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0}}', 1770895920, 1770895920, 200);
INSERT INTO `t_request_log` VALUES (232, 3, '/team/list?page=1&pageSize=10', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"list\":[],\"count\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0,\"reward\":[{\"key\":5,\"value\":88},{\"key\":10,\"value\":288},{\"key\":25,\"value\":888},{\"key\":50,\"value\":2088},{\"key\":100,\"value\":6888}]}}', 1770895920, 1770895920, 200);
INSERT INTO `t_request_log` VALUES (233, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895929, 1770895929, 200);
INSERT INTO `t_request_log` VALUES (234, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895929, 1770895929, 200);
INSERT INTO `t_request_log` VALUES (235, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895931, 1770895931, 200);
INSERT INTO `t_request_log` VALUES (236, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895934, 1770895934, 200);
INSERT INTO `t_request_log` VALUES (237, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895934, 1770895934, 200);
INSERT INTO `t_request_log` VALUES (238, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895935, 1770895935, 200);
INSERT INTO `t_request_log` VALUES (239, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', NULL, 1770895935, 0, 200);
INSERT INTO `t_request_log` VALUES (240, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', NULL, 1770895954, 0, 200);
INSERT INTO `t_request_log` VALUES (241, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', NULL, 1770895958, 0, 200);
INSERT INTO `t_request_log` VALUES (242, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895982, 1770895982, 200);
INSERT INTO `t_request_log` VALUES (243, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770895982, 1770895982, 200);
INSERT INTO `t_request_log` VALUES (244, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":0,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770895984, 1770895984, 200);
INSERT INTO `t_request_log` VALUES (245, 3, '/upload/file', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"1217\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"multipart\\/form-data; boundary=----WebKitFormBoundaryFlmD93GVkAJoOBFP\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"filePath\":\"\\/uploads\\/9dd51b01d40cebf4488d15ff2e02120383890454.jpg\",\"url\":\"\\/uploads\\/9dd51b01d40cebf4488d15ff2e02120383890454.jpg\"}}', 1770895989, 1770895989, 200);
INSERT INTO `t_request_log` VALUES (246, 3, '/upload/file', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"1217\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"multipart\\/form-data; boundary=----WebKitFormBoundaryYGV7ErEFBGEVAF38\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"filePath\":\"\\/uploads\\/37bf1e180c4c38f285770f66c2f96780c973d871.jpg\",\"url\":\"\\/uploads\\/37bf1e180c4c38f285770f66c2f96780c973d871.jpg\"}}', 1770895990, 1770895990, 200);
INSERT INTO `t_request_log` VALUES (247, 3, '/auth/identity', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"173\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"realName\\\":\\\"141\\\",\\\"IDCard\\\":\\\"11\\\",\\\"IDFrontUrl\\\":\\\"\\/uploads\\/9dd51b01d40cebf4488d15ff2e02120383890454.jpg\\\",\\\"IDOppositeUrl\\\":\\\"\\/uploads\\/37bf1e180c4c38f285770f66c2f96780c973d871.jpg\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u8eab\\u4efd\\u8bc1\\u53f7\\u7801\\u683c\\u5f0f\\u4e0d\\u6b63\\u786e\"}', 1770895994, 1770895994, 200);
INSERT INTO `t_request_log` VALUES (248, 3, '/auth/identity', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"190\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"realName\\\":\\\"141\\\",\\\"IDCard\\\":\\\"3707041990020215412\\\",\\\"IDFrontUrl\\\":\\\"\\/uploads\\/9dd51b01d40cebf4488d15ff2e02120383890454.jpg\\\",\\\"IDOppositeUrl\\\":\\\"\\/uploads\\/37bf1e180c4c38f285770f66c2f96780c973d871.jpg\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u8eab\\u4efd\\u8bc1\\u53f7\\u7801\\u683c\\u5f0f\\u4e0d\\u6b63\\u786e\"}', 1770896011, 1770896011, 200);
INSERT INTO `t_request_log` VALUES (249, 3, '/auth/identity', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"189\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"realName\\\":\\\"141\\\",\\\"IDCard\\\":\\\"370704199002031838\\\",\\\"IDFrontUrl\\\":\\\"\\/uploads\\/9dd51b01d40cebf4488d15ff2e02120383890454.jpg\\\",\\\"IDOppositeUrl\\\":\\\"\\/uploads\\/37bf1e180c4c38f285770f66c2f96780c973d871.jpg\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":null}', 1770896018, 1770896018, 200);
INSERT INTO `t_request_log` VALUES (250, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":1,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770896019, 1770896019, 200);
INSERT INTO `t_request_log` VALUES (251, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":1,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770896071, 1770896071, 200);
INSERT INTO `t_request_log` VALUES (252, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896079, 1770896079, 200);
INSERT INTO `t_request_log` VALUES (253, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896079, 1770896079, 200);
INSERT INTO `t_request_log` VALUES (254, 3, '/team/stats', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0}}', 1770896082, 1770896082, 200);
INSERT INTO `t_request_log` VALUES (255, 3, '/team/list?page=1&pageSize=10', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"buy_product_money\":\"0\",\"register_num\":\"0\",\"list\":[],\"count\":\"0\",\"one_num\":\"0\",\"two_num\":\"0\",\"three_num\":\"0\",\"other_num\":0,\"reward\":[{\"key\":5,\"value\":88},{\"key\":10,\"value\":288},{\"key\":25,\"value\":888},{\"key\":50,\"value\":2088},{\"key\":100,\"value\":6888}]}}', 1770896082, 1770896082, 200);
INSERT INTO `t_request_log` VALUES (256, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896083, 1770896083, 200);
INSERT INTO `t_request_log` VALUES (257, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896083, 1770896083, 200);
INSERT INTO `t_request_log` VALUES (258, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":1,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770896085, 1770896085, 200);
INSERT INTO `t_request_log` VALUES (259, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896086, 1770896086, 200);
INSERT INTO `t_request_log` VALUES (260, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896086, 1770896086, 200);
INSERT INTO `t_request_log` VALUES (261, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896089, 1770896089, 200);
INSERT INTO `t_request_log` VALUES (262, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896089, 1770896089, 200);
INSERT INTO `t_request_log` VALUES (263, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896117, 1770896117, 200);
INSERT INTO `t_request_log` VALUES (264, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896117, 1770896117, 200);
INSERT INTO `t_request_log` VALUES (265, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770896123, 1770896123, 200);
INSERT INTO `t_request_log` VALUES (266, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896125, 1770896125, 200);
INSERT INTO `t_request_log` VALUES (267, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896125, 1770896125, 200);
INSERT INTO `t_request_log` VALUES (268, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896151, 1770896151, 200);
INSERT INTO `t_request_log` VALUES (269, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896151, 1770896151, 200);
INSERT INTO `t_request_log` VALUES (270, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896195, 1770896195, 200);
INSERT INTO `t_request_log` VALUES (271, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896195, 1770896195, 200);
INSERT INTO `t_request_log` VALUES (272, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896197, 1770896197, 200);
INSERT INTO `t_request_log` VALUES (273, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', NULL, 1770896198, 0, 200);
INSERT INTO `t_request_log` VALUES (274, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[{\"id\":1,\"name\":\"\\u5fae\\u4fe1\\u901a\\u905301\",\"method\":\"wechat\",\"minMoney\":100,\"maxMoney\":1000,\"limitText\":\"\\u5355\\u7b14\\u4ea4\\u6613\\u9650\\u989d100~1000\"}]}', 1770896228, 1770896228, 200);
INSERT INTO `t_request_log` VALUES (275, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896231, 1770896231, 200);
INSERT INTO `t_request_log` VALUES (276, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896231, 1770896231, 200);
INSERT INTO `t_request_log` VALUES (277, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896234, 1770896234, 200);
INSERT INTO `t_request_log` VALUES (278, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"alipay\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[{\"id\":2,\"name\":\"\\u652f\\u4ed8\\u5b9d\\u901a\\u905301\",\"method\":\"alipay\",\"minMoney\":100,\"maxMoney\":2000,\"limitText\":\"\\u5355\\u7b14\\u4ea4\\u6613\\u9650\\u989d100~2000\"}]}', 1770896235, 1770896235, 200);
INSERT INTO `t_request_log` VALUES (279, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"alipay\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[{\"id\":2,\"name\":\"\\u652f\\u4ed8\\u5b9d\\u901a\\u905301\",\"method\":\"alipay\",\"minMoney\":100,\"maxMoney\":2000,\"limitText\":\"\\u5355\\u7b14\\u4ea4\\u6613\\u9650\\u989d100~2000\"}]}', 1770896237, 1770896237, 200);
INSERT INTO `t_request_log` VALUES (280, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"41\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"unionpay\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[{\"id\":3,\"name\":\"\\u94f6\\u8054\\u901a\\u905301\",\"method\":\"unionpay\",\"minMoney\":100,\"maxMoney\":5000,\"limitText\":\"\\u5355\\u7b14\\u4ea4\\u6613\\u9650\\u989d100~5000\"}]}', 1770896239, 1770896239, 200);
INSERT INTO `t_request_log` VALUES (281, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[{\"id\":1,\"name\":\"\\u5fae\\u4fe1\\u901a\\u905301\",\"method\":\"wechat\",\"minMoney\":100,\"maxMoney\":1000,\"limitText\":\"\\u5355\\u7b14\\u4ea4\\u6613\\u9650\\u989d100~1000\"}]}', 1770896243, 1770896243, 200);
INSERT INTO `t_request_log` VALUES (282, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"41\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":10000,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[]}', 1770896247, 1770896247, 200);
INSERT INTO `t_request_log` VALUES (283, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"41\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":10000,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[]}', 1770896250, 1770896250, 200);
INSERT INTO `t_request_log` VALUES (284, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"41\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":10000,\\\"paymentMethod\\\":\\\"alipay\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[]}', 1770896252, 1770896252, 200);
INSERT INTO `t_request_log` VALUES (285, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896254, 1770896254, 200);
INSERT INTO `t_request_log` VALUES (286, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896254, 1770896254, 200);
INSERT INTO `t_request_log` VALUES (287, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896255, 1770896255, 200);
INSERT INTO `t_request_log` VALUES (288, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[{\"id\":1,\"name\":\"\\u5fae\\u4fe1\\u901a\\u905301\",\"method\":\"wechat\",\"minMoney\":100,\"maxMoney\":1000,\"limitText\":\"\\u5355\\u7b14\\u4ea4\\u6613\\u9650\\u989d100~1000\"}]}', 1770896256, 1770896256, 200);
INSERT INTO `t_request_log` VALUES (289, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[{\"id\":1,\"name\":\"\\u5fae\\u4fe1\\u901a\\u905301\",\"method\":\"wechat\",\"minMoney\":100,\"maxMoney\":1000,\"limitText\":\"\\u5355\\u7b14\\u4ea4\\u6613\\u9650\\u989d100~1000\"}]}', 1770896260, 1770896260, 200);
INSERT INTO `t_request_log` VALUES (290, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":200,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[{\"id\":1,\"name\":\"\\u5fae\\u4fe1\\u901a\\u905301\",\"method\":\"wechat\",\"minMoney\":100,\"maxMoney\":1000,\"limitText\":\"\\u5355\\u7b14\\u4ea4\\u6613\\u9650\\u989d100~1000\"}]}', 1770896265, 1770896265, 200);
INSERT INTO `t_request_log` VALUES (291, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896288, 1770896288, 200);
INSERT INTO `t_request_log` VALUES (292, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896288, 1770896288, 200);
INSERT INTO `t_request_log` VALUES (293, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896289, 1770896289, 200);
INSERT INTO `t_request_log` VALUES (294, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896294, 1770896294, 200);
INSERT INTO `t_request_log` VALUES (295, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896294, 1770896294, 200);
INSERT INTO `t_request_log` VALUES (296, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896300, 1770896300, 200);
INSERT INTO `t_request_log` VALUES (297, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896300, 1770896300, 200);
INSERT INTO `t_request_log` VALUES (298, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896301, 1770896301, 200);
INSERT INTO `t_request_log` VALUES (299, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896305, 1770896305, 200);
INSERT INTO `t_request_log` VALUES (300, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896305, 1770896305, 200);
INSERT INTO `t_request_log` VALUES (301, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896307, 1770896307, 200);
INSERT INTO `t_request_log` VALUES (302, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896311, 1770896311, 200);
INSERT INTO `t_request_log` VALUES (303, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896312, 1770896312, 200);
INSERT INTO `t_request_log` VALUES (304, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896313, 1770896313, 200);
INSERT INTO `t_request_log` VALUES (305, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896360, 1770896360, 200);
INSERT INTO `t_request_log` VALUES (306, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896360, 1770896360, 200);
INSERT INTO `t_request_log` VALUES (307, 3, '/user/password', 'PUT', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"48\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"oldPassword\\\":\\\"111111\\\",\\\"newPassword\\\":\\\"1111111\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":null}', 1770896374, 1770896374, 200);
INSERT INTO `t_request_log` VALUES (308, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896375, 1770896375, 200);
INSERT INTO `t_request_log` VALUES (309, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896375, 1770896375, 200);
INSERT INTO `t_request_log` VALUES (310, 3, '/user/logout', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"0\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', NULL, 1770896382, 0, 200);
INSERT INTO `t_request_log` VALUES (311, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"41\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"333333\\\",\\\"password\\\":\\\"1111111\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"login_token\":\"YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\",\"uid\":3,\"e_uid\":\"\",\"invite_code\":\"AdjLdBwDAhKKSEJ7VIkR\",\"is_real\":1}}', 1770896414, 1770896414, 200);
INSERT INTO `t_request_log` VALUES (312, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770896414, 1770896414, 200);
INSERT INTO `t_request_log` VALUES (313, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896415, 1770896415, 200);
INSERT INTO `t_request_log` VALUES (314, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896415, 1770896415, 200);
INSERT INTO `t_request_log` VALUES (315, 3, '/user/logout', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"0\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', NULL, 1770896418, 0, 200);
INSERT INTO `t_request_log` VALUES (316, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"41\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"333333\\\",\\\"password\\\":\\\"1111111\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"login_token\":\"YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\",\"uid\":3,\"e_uid\":\"\",\"invite_code\":\"AdjLdBwDAhKKSEJ7VIkR\",\"is_real\":1}}', 1770896459, 1770896459, 200);
INSERT INTO `t_request_log` VALUES (317, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770896459, 1770896459, 200);
INSERT INTO `t_request_log` VALUES (318, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896460, 1770896460, 200);
INSERT INTO `t_request_log` VALUES (319, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896460, 1770896461, 200);
INSERT INTO `t_request_log` VALUES (320, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896469, 1770896469, 200);
INSERT INTO `t_request_log` VALUES (321, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[{\"id\":1,\"name\":\"\\u5fae\\u4fe1\\u901a\\u905301\",\"method\":\"wechat\",\"minMoney\":100,\"maxMoney\":1000,\"limitText\":\"\\u5355\\u7b14\\u4ea4\\u6613\\u9650\\u989d100~1000\"}]}', 1770896470, 1770896470, 200);
INSERT INTO `t_request_log` VALUES (322, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[{\"id\":1,\"name\":\"\\u5fae\\u4fe1\\u901a\\u905301\",\"method\":\"wechat\",\"minMoney\":100,\"maxMoney\":1000,\"limitText\":\"\\u5355\\u7b14\\u4ea4\\u6613\\u9650\\u989d100~1000\"}]}', 1770896473, 1770896473, 200);
INSERT INTO `t_request_log` VALUES (323, 3, '/wallet/payment-channels', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"39\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"amount\\\":100,\\\"paymentMethod\\\":\\\"wechat\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":[{\"id\":1,\"name\":\"\\u5fae\\u4fe1\\u901a\\u905301\",\"method\":\"wechat\",\"minMoney\":100,\"maxMoney\":1000,\"limitText\":\"\\u5355\\u7b14\\u4ea4\\u6613\\u9650\\u989d100~1000\"}]}', 1770896478, 1770896478, 200);
INSERT INTO `t_request_log` VALUES (324, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896506, 1770896506, 200);
INSERT INTO `t_request_log` VALUES (325, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896506, 1770896506, 200);
INSERT INTO `t_request_log` VALUES (326, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":1,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770896509, 1770896509, 200);
INSERT INTO `t_request_log` VALUES (327, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":1,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770896510, 1770896510, 200);
INSERT INTO `t_request_log` VALUES (328, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":1,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770896514, 1770896514, 200);
INSERT INTO `t_request_log` VALUES (329, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":1,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770896515, 1770896515, 200);
INSERT INTO `t_request_log` VALUES (330, 3, '/upload/file', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"10804\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"multipart\\/form-data; boundary=----WebKitFormBoundaryiBwyVyM8JC63mF3h\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"filePath\":\"\\/uploads\\/4e5e40e6b7cfbdf97b8d6330d92a680b4da88877.jpg\",\"url\":\"\\/uploads\\/4e5e40e6b7cfbdf97b8d6330d92a680b4da88877.jpg\"}}', 1770896527, 1770896527, 200);
INSERT INTO `t_request_log` VALUES (331, 3, '/upload/file', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"1217\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"multipart\\/form-data; boundary=----WebKitFormBoundaryY7AxlzbMQF5WQNTX\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"filePath\":\"\\/uploads\\/e3f68ca87c59211b5aee5818cc284b897fc27435.jpg\",\"url\":\"\\/uploads\\/e3f68ca87c59211b5aee5818cc284b897fc27435.jpg\"}}', 1770896528, 1770896528, 200);
INSERT INTO `t_request_log` VALUES (332, 3, '/auth/identity', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"191\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"realName\\\":\\\"1`1`2\\\",\\\"IDCard\\\":\\\"370704199002031838\\\",\\\"IDFrontUrl\\\":\\\"\\/uploads\\/4e5e40e6b7cfbdf97b8d6330d92a680b4da88877.jpg\\\",\\\"IDOppositeUrl\\\":\\\"\\/uploads\\/e3f68ca87c59211b5aee5818cc284b897fc27435.jpg\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u8be5\\u8eab\\u4efd\\u8bc1\\u5df2\\u63d0\\u4ea4\"}', 1770896536, 1770896536, 200);
INSERT INTO `t_request_log` VALUES (333, 3, '/auth/identity', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"191\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"realName\\\":\\\"1`1`2\\\",\\\"IDCard\\\":\\\"370704199002031838\\\",\\\"IDFrontUrl\\\":\\\"\\/uploads\\/4e5e40e6b7cfbdf97b8d6330d92a680b4da88877.jpg\\\",\\\"IDOppositeUrl\\\":\\\"\\/uploads\\/e3f68ca87c59211b5aee5818cc284b897fc27435.jpg\\\"}\"}', '{\"code\":\"212\",\"message\":\"\\u8be5\\u8eab\\u4efd\\u8bc1\\u5df2\\u63d0\\u4ea4\"}', 1770896539, 1770896539, 200);
INSERT INTO `t_request_log` VALUES (334, 3, '/auth/status', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"is_real\":1,\"has_realname\":false,\"realName\":\"\",\"IDCard\":\"\"}}', 1770896543, 1770896543, 200);
INSERT INTO `t_request_log` VALUES (335, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896555, 1770896555, 200);
INSERT INTO `t_request_log` VALUES (336, 3, '/wallet/info', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"balance\":0,\"rechargeBalance\":0,\"pendingAmount\":0}}', 1770896555, 1770896555, 200);
INSERT INTO `t_request_log` VALUES (337, 3, '/user/logout', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"0\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer YXxpdEE_CTQBbGiqH3ax3R644BJzClOs\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":null}', 1770896556, 1770896556, 200);
INSERT INTO `t_request_log` VALUES (338, 0, '/login/index', 'POST', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"content-length\":[\"41\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"content-type\":[\"application\\/json;charset=UTF-8\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"{\\\"account\\\":\\\"333333\\\",\\\"password\\\":\\\"1111111\\\"}\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"login_token\":\"xmtpFx_5noCTsSIoB7v-69gKZfEFtyhk\",\"uid\":3,\"e_uid\":\"\",\"invite_code\":\"AdjLdBwDAhKKSEJ7VIkR\",\"is_real\":1}}', 1770896566, 1770896566, 200);
INSERT INTO `t_request_log` VALUES (339, 0, '/news/list?page=1&size=3', 'GET', '{\"header\":{\"host\":[\"localhost:8080\"],\"connection\":[\"keep-alive\"],\"user-agent\":[\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Version\\/18.5 Mobile\\/15E148 Safari\\/604.1\"],\"accept\":[\"application\\/json, text\\/plain, *\\/*\"],\"authorization\":[\"Bearer xmtpFx_5noCTsSIoB7v-69gKZfEFtyhk\"],\"origin\":[\"http:\\/\\/192.168.199.174:3000\"],\"sec-fetch-site\":[\"cross-site\"],\"sec-fetch-mode\":[\"cors\"],\"sec-fetch-dest\":[\"empty\"],\"referer\":[\"http:\\/\\/192.168.199.174:3000\\/\"],\"accept-encoding\":[\"gzip, deflate, br, zstd\"],\"accept-language\":[\"zh,zh-CN;q=0.9\"]},\"body\":\"\"}', '{\"code\":200,\"message\":\"success\",\"data\":{\"list\":[]}}', 1770896566, 1770896566, 200);

-- ----------------------------
-- Table structure for t_send_sms_log
-- ----------------------------
DROP TABLE IF EXISTS `t_send_sms_log`;
CREATE TABLE `t_send_sms_log`  (
  `_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标记id',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号',
  `smsCode` int(11) NOT NULL COMMENT '验证码',
  `sendIp` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发送IP',
  `sendAgentID` bigint(20) NULL DEFAULT NULL COMMENT '发送账号ID',
  `type` tinyint(4) NOT NULL COMMENT '状态：1为成功可使用，2为已使用',
  `itime` bigint(20) NULL DEFAULT NULL COMMENT '创建时间（Unix时间戳）',
  `utime` bigint(20) NULL DEFAULT NULL COMMENT '更新时间（Unix时间戳）',
  PRIMARY KEY (`_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '短信日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_send_sms_log
-- ----------------------------

-- ----------------------------
-- Table structure for t_sign_in_record
-- ----------------------------
DROP TABLE IF EXISTS `t_sign_in_record`;
CREATE TABLE `t_sign_in_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标记id',
  `uid` int(11) NOT NULL DEFAULT 0 COMMENT '用户id',
  `img` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '签到地址',
  `dateDay` date NOT NULL COMMENT '签到日期',
  `continuousDay` int(11) NOT NULL DEFAULT 1 COMMENT '当前连续天数/累积天数',
  `rewardType` int(11) NOT NULL COMMENT '奖励类型',
  `rewardNumber` int(11) NOT NULL COMMENT '奖励数量',
  `signInType` tinyint(4) NOT NULL COMMENT '签到类型: 1为连续签到奖励, 2为累积天数奖励',
  `type` int(11) NOT NULL COMMENT '状态 1为申请下发 2下发成功 3为下发异常',
  `itime` int(11) NOT NULL COMMENT '创建时间',
  `utime` int(11) NOT NULL COMMENT '更新时间',
  `is_pay` tinyint(4) NULL DEFAULT 0 COMMENT '1-已支付',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sign_in_only`(`uid`, `signInType`, `dateDay`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户签到日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sign_in_record
-- ----------------------------

-- ----------------------------
-- Table structure for t_sign_in_reward
-- ----------------------------
DROP TABLE IF EXISTS `t_sign_in_reward`;
CREATE TABLE `t_sign_in_reward`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标记ID',
  `continuousDay` int(11) NOT NULL COMMENT '连续天数',
  `signInType` tinyint(4) NOT NULL COMMENT '签到类型: 1为连续签到奖励, 2为累积天数奖励',
  `rewardType` tinyint(4) NOT NULL COMMENT '奖励类型: 1余额, 2 回报钱包, 3补助钱包, 4圆梦基金',
  `rewardNumber` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '奖励数量',
  `rewardName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '奖励名字',
  `pic_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片地址',
  `type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态: 1为启用, 2为关闭',
  `itime` int(11) NOT NULL COMMENT '创建时间',
  `utime` int(11) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '签到奖励表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sign_in_reward
-- ----------------------------

-- ----------------------------
-- Table structure for t_sys
-- ----------------------------
DROP TABLE IF EXISTS `t_sys`;
CREATE TABLE `t_sys`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标记id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '名称',
  `pay_type` int(11) NOT NULL COMMENT '1-支付宝 2-微信 3-银行',
  `appid` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'appid',
  `appsecret` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT 'appsecret',
  `sort` int(11) NOT NULL COMMENT '排序',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态 1-启用 2-关闭',
  `itime` int(11) NOT NULL COMMENT '创建时间',
  `utime` int(11) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统账号' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys
-- ----------------------------

-- ----------------------------
-- Table structure for t_system_configure
-- ----------------------------
DROP TABLE IF EXISTS `t_system_configure`;
CREATE TABLE `t_system_configure`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标识id',
  `key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '唯一标识',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置value',
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `sort` int(11) NULL DEFAULT 0 COMMENT '排序',
  `itime` bigint(20) NOT NULL COMMENT '创建时间',
  `utime` bigint(20) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sys_conf_only`(`key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_system_configure
-- ----------------------------
INSERT INTO `t_system_configure` VALUES (1, '1', 'http://www.baidu.com', NULL, 0, 0, 0);
INSERT INTO `t_system_configure` VALUES (2, '2', '1', '首页福利开关 1-打开 2-关闭', 0, 0, 0);
INSERT INTO `t_system_configure` VALUES (3, '3', 'http://www.baidu.com', '优惠地址', 0, 0, 0);
INSERT INTO `t_system_configure` VALUES (4, 'sign_in_rule_1', '1. 每日签到积分50+基金补贴10000基金补贴，连续签到增加额基金补贴；', '签到说明1', 1, 1770893823, 1770893823);
INSERT INTO `t_system_configure` VALUES (5, 'sign_in_rule_2', '2. 每周7个自然日送基金补贴礼包，遇法定节假日可增加基金补贴礼包，且自然日需往后顺延到法定节假日相隔7天。', '签到说明2', 2, 1770893823, 1770893823);

-- ----------------------------
-- Table structure for t_system_log
-- ----------------------------
DROP TABLE IF EXISTS `t_system_log`;
CREATE TABLE `t_system_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level` int(11) NULL DEFAULT NULL,
  `category` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `log_time` float NULL DEFAULT NULL,
  `prefix` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 99 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_system_log
-- ----------------------------
INSERT INTO `t_system_log` VALUES (25, 1, 'yii\\db\\Exception', 1769870000, '[::1][-][-]', 'PDOException: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'account_type\' in \'where clause\' in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(431): yii\\db\\Command->queryInternal(\'fetch\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(287): yii\\db\\Command->queryOne()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(304): yii\\db\\Query->one(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\LoginController.php(163): yii\\db\\ActiveQuery->one()\n#6 [internal function]: backend\\controllers\\LoginController->actionIndex()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'login/index\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'account_type\' in \'where clause\'\nThe SQL being executed was: SELECT * FROM `t_account_info` WHERE (`account`=\'1\') AND (`password`=\'c4ca4238a0b923820dcc509a6f75849b\') AND (`account_type`=0) in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT * FROM `...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(431): yii\\db\\Command->queryInternal(\'fetch\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(287): yii\\db\\Command->queryOne()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(304): yii\\db\\Query->one(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\LoginController.php(163): yii\\db\\ActiveQuery->one()\n#6 [internal function]: backend\\controllers\\LoginController->actionIndex()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'login/index\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S22\n    [1] => 1054\n    [2] => Unknown column \'account_type\' in \'where clause\'\n)\n');
INSERT INTO `t_system_log` VALUES (26, 1, 'yii\\db\\Exception', 1769870000, '[::1][-][-]', 'PDOException: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'account_type\' in \'where clause\' in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(431): yii\\db\\Command->queryInternal(\'fetch\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(287): yii\\db\\Command->queryOne()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(304): yii\\db\\Query->one(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\LoginController.php(163): yii\\db\\ActiveQuery->one()\n#6 [internal function]: backend\\controllers\\LoginController->actionIndex()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'login/index\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'account_type\' in \'where clause\'\nThe SQL being executed was: SELECT * FROM `t_account_info` WHERE (`account`=\'1\') AND (`password`=\'c81e728d9d4c2f636f067f89cc14862c\') AND (`account_type`=0) in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT * FROM `...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(431): yii\\db\\Command->queryInternal(\'fetch\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(287): yii\\db\\Command->queryOne()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(304): yii\\db\\Query->one(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\LoginController.php(163): yii\\db\\ActiveQuery->one()\n#6 [internal function]: backend\\controllers\\LoginController->actionIndex()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'login/index\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S22\n    [1] => 1054\n    [2] => Unknown column \'account_type\' in \'where clause\'\n)\n');
INSERT INTO `t_system_log` VALUES (27, 1, 'yii\\db\\Exception', 1769870000, '[::1][-][-]', 'PDOException: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'account_type\' in \'where clause\' in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(431): yii\\db\\Command->queryInternal(\'fetch\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(287): yii\\db\\Command->queryOne()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(304): yii\\db\\Query->one(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\LoginController.php(163): yii\\db\\ActiveQuery->one()\n#6 [internal function]: backend\\controllers\\LoginController->actionIndex()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'login/index\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'account_type\' in \'where clause\'\nThe SQL being executed was: SELECT * FROM `t_account_info` WHERE (`account`=\'1\') AND (`password`=\'c81e728d9d4c2f636f067f89cc14862c\') AND (`account_type`=0) in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT * FROM `...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(431): yii\\db\\Command->queryInternal(\'fetch\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(287): yii\\db\\Command->queryOne()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(304): yii\\db\\Query->one(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\LoginController.php(163): yii\\db\\ActiveQuery->one()\n#6 [internal function]: backend\\controllers\\LoginController->actionIndex()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'login/index\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S22\n    [1] => 1054\n    [2] => Unknown column \'account_type\' in \'where clause\'\n)\n');
INSERT INTO `t_system_log` VALUES (28, 1, 'yii\\db\\Exception', 1769870000, '[::1][-][-]', 'PDOException: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'account_type\' in \'where clause\' in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(431): yii\\db\\Command->queryInternal(\'fetch\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(287): yii\\db\\Command->queryOne()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(304): yii\\db\\Query->one(NULL)\n#5 D:\\work\\pro\\backend\\common\\models\\AccountInfo.php(192): yii\\db\\ActiveQuery->one()\n#6 D:\\work\\pro\\backend\\backend\\controllers\\RegisterController.php(205): common\\models\\AccountInfo->RegisterAccount(\'18888888888\', \'111111\', \'1\', \'127.0.0.1\', \'\', \'\', \'111111\')\n#7 [internal function]: backend\\controllers\\RegisterController->actionIndex()\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'register/index\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#13 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#14 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#15 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'account_type\' in \'where clause\'\nThe SQL being executed was: SELECT * FROM `t_account_info` WHERE (`account`=\'18888888888\') AND (`account_type`=0) in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT * FROM `...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(431): yii\\db\\Command->queryInternal(\'fetch\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(287): yii\\db\\Command->queryOne()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(304): yii\\db\\Query->one(NULL)\n#5 D:\\work\\pro\\backend\\common\\models\\AccountInfo.php(192): yii\\db\\ActiveQuery->one()\n#6 D:\\work\\pro\\backend\\backend\\controllers\\RegisterController.php(205): common\\models\\AccountInfo->RegisterAccount(\'18888888888\', \'111111\', \'1\', \'127.0.0.1\', \'\', \'\', \'111111\')\n#7 [internal function]: backend\\controllers\\RegisterController->actionIndex()\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'register/index\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#13 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#14 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#15 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S22\n    [1] => 1054\n    [2] => Unknown column \'account_type\' in \'where clause\'\n)\n');
INSERT INTO `t_system_log` VALUES (29, 1, 'yii\\db\\Exception', 1769870000, '[::1][-][-]', 'PDOException: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_invite\' doesn\'t exist in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(431): yii\\db\\Command->queryInternal(\'fetch\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(287): yii\\db\\Command->queryOne()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(304): yii\\db\\Query->one(NULL)\n#5 D:\\work\\pro\\backend\\common\\models\\AccountInfo.php(209): yii\\db\\ActiveQuery->one()\n#6 D:\\work\\pro\\backend\\backend\\controllers\\RegisterController.php(205): common\\models\\AccountInfo->RegisterAccount(\'18888888888\', \'111111\', \'1\', \'127.0.0.1\', \'\', \'\', \'111111\')\n#7 [internal function]: backend\\controllers\\RegisterController->actionIndex()\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'register/index\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#13 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#14 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#15 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_invite\' doesn\'t exist\nThe SQL being executed was: SELECT * FROM `t_invite` WHERE `invite_code`=\'1\' in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT * FROM `...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(431): yii\\db\\Command->queryInternal(\'fetch\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(287): yii\\db\\Command->queryOne()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(304): yii\\db\\Query->one(NULL)\n#5 D:\\work\\pro\\backend\\common\\models\\AccountInfo.php(209): yii\\db\\ActiveQuery->one()\n#6 D:\\work\\pro\\backend\\backend\\controllers\\RegisterController.php(205): common\\models\\AccountInfo->RegisterAccount(\'18888888888\', \'111111\', \'1\', \'127.0.0.1\', \'\', \'\', \'111111\')\n#7 [internal function]: backend\\controllers\\RegisterController->actionIndex()\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'register/index\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#13 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#14 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#15 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S02\n    [1] => 1146\n    [2] => Table \'stock.t_invite\' doesn\'t exist\n)\n');
INSERT INTO `t_system_log` VALUES (30, 1, 'application', 1769870000, '[::1][-][-]', 'Setting unknown property: common\\models\\AccountInfo::last_login_time');
INSERT INTO `t_system_log` VALUES (31, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'\',\n        \'avatar\' => \'/uploads/2.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873458,\n        \'utime\' => 1769873458,\n        \'invite_code\' => \'a6mKf1tCD1wNq7r0Yv4D\',\n        \'last_login_time\' => 1769873458,\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Failed to save user\',\n]');
INSERT INTO `t_system_log` VALUES (32, 1, 'application', 1769870000, '[::1][-][-]', 'Setting unknown property: common\\models\\AccountInfo::last_login_time');
INSERT INTO `t_system_log` VALUES (33, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'\',\n        \'avatar\' => \'/uploads/2.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873479,\n        \'utime\' => 1769873479,\n        \'invite_code\' => \'I4nmXpZQ8pJ1PcFKBWau\',\n        \'last_login_time\' => 1769873479,\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Failed to save user\',\n]');
INSERT INTO `t_system_log` VALUES (34, 1, 'application', 1769870000, '[::1][-][-]', 'Setting unknown property: common\\models\\AccountInfo::last_login_time');
INSERT INTO `t_system_log` VALUES (35, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'\',\n        \'avatar\' => \'/uploads/1.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873524,\n        \'utime\' => 1769873524,\n        \'invite_code\' => \'9H2q1Z82hOke0BzLrljr\',\n        \'last_login_time\' => 1769873524,\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Failed to save user\',\n]');
INSERT INTO `t_system_log` VALUES (36, 1, 'application', 1769870000, '[::1][-][-]', 'Setting unknown property: common\\models\\AccountInfo::last_login_time');
INSERT INTO `t_system_log` VALUES (37, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'\',\n        \'avatar\' => \'/uploads/1.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873542,\n        \'utime\' => 1769873542,\n        \'invite_code\' => \'Y8e4oJY60KnbX6gvb0Cw\',\n        \'last_login_time\' => 1769873542,\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Failed to save user\',\n]');
INSERT INTO `t_system_log` VALUES (38, 1, 'application', 1769870000, '[::1][-][-]', 'Setting unknown property: common\\models\\AccountInfo::last_login_time');
INSERT INTO `t_system_log` VALUES (39, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'\',\n        \'avatar\' => \'/uploads/2.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873548,\n        \'utime\' => 1769873548,\n        \'invite_code\' => \'bG46prW5ynUHGkDhwlWo\',\n        \'last_login_time\' => 1769873548,\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Failed to save user\',\n]');
INSERT INTO `t_system_log` VALUES (40, 1, 'application', 1769870000, '[::1][-][-]', 'Setting unknown property: common\\models\\AccountInfo::last_login_time');
INSERT INTO `t_system_log` VALUES (41, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'\',\n        \'avatar\' => \'/uploads/2.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873552,\n        \'utime\' => 1769873552,\n        \'invite_code\' => \'xnBkeIpujDGA19XWrfcT\',\n        \'last_login_time\' => 1769873552,\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Failed to save user\',\n]');
INSERT INTO `t_system_log` VALUES (42, 1, 'application', 1769870000, '[::1][-][-]', 'Setting unknown property: common\\models\\AccountInfo::last_login_time');
INSERT INTO `t_system_log` VALUES (43, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'\',\n        \'avatar\' => \'/uploads/3.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873569,\n        \'utime\' => 1769873569,\n        \'invite_code\' => \'FsRPTxH389ttHE6lZ9lD\',\n        \'last_login_time\' => 1769873569,\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Failed to save user\',\n]');
INSERT INTO `t_system_log` VALUES (44, 1, 'application', 1769870000, '[::1][-][-]', 'Setting unknown property: common\\models\\AccountInfo::last_login_time');
INSERT INTO `t_system_log` VALUES (45, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'\',\n        \'avatar\' => \'/uploads/4.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873584,\n        \'utime\' => 1769873584,\n        \'invite_code\' => \'gbdXzvaVMRy9Rhy4q0Vs\',\n        \'last_login_time\' => 1769873584,\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Failed to save user\',\n]');
INSERT INTO `t_system_log` VALUES (46, 1, 'application', 1769870000, '[::1][-][-]', 'Setting unknown property: common\\models\\AccountInfo::last_login_time');
INSERT INTO `t_system_log` VALUES (47, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'\',\n        \'avatar\' => \'/uploads/3.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873600,\n        \'utime\' => 1769873600,\n        \'invite_code\' => \'RtpO8vGia063WTX8Uw1H\',\n        \'last_login_time\' => 1769873600,\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Failed to save user\',\n]');
INSERT INTO `t_system_log` VALUES (48, 1, 'application', 1769870000, '[::1][-][-]', 'Setting unknown property: common\\models\\AccountInfo::last_login_time');
INSERT INTO `t_system_log` VALUES (49, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'qqq1111\',\n        \'avatar\' => \'/uploads/3.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873746,\n        \'utime\' => 1769873746,\n        \'invite_code\' => \'56RA1p7ju73R1LDQHpPh\',\n        \'last_login_time\' => 1769873746,\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'注册失败\',\n]');
INSERT INTO `t_system_log` VALUES (50, 1, 'application', 1769870000, '[::1][-][-]', 'Setting unknown property: common\\models\\AccountInfo::last_login_time');
INSERT INTO `t_system_log` VALUES (51, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'qqq1111\',\n        \'avatar\' => \'/uploads/1.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873774,\n        \'utime\' => 1769873774,\n        \'invite_code\' => \'W9m23lFWjyJnQFgipajP\',\n        \'last_login_time\' => 1769873774,\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'注册失败\',\n]');
INSERT INTO `t_system_log` VALUES (52, 1, 'application', 1769870000, '[::1][-][-]', 'Setting unknown property: common\\models\\AccountInfo::last_login_time');
INSERT INTO `t_system_log` VALUES (53, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'qqq1111\',\n        \'avatar\' => \'/uploads/3.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873821,\n        \'utime\' => 1769873821,\n        \'invite_code\' => \'ShzFc7O9rBq8d1iO7wS1\',\n        \'last_login_time\' => 1769873821,\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'注册失败\',\n]');
INSERT INTO `t_system_log` VALUES (54, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'qqq1111\',\n        \'avatar\' => \'/uploads/1.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873918,\n        \'utime\' => 1769873918,\n        \'invite_code\' => \'25pzixQFNG5ZpONphRWX\',\n        \'last_login_time\' => 1769873918,\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Setting unknown property: common\\\\models\\\\AccountInfo::last_login_time\',\n]');
INSERT INTO `t_system_log` VALUES (55, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'qqq1111\',\n        \'avatar\' => \'/uploads/2.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769873997,\n        \'utime\' => 1769873997,\n        \'invite_code\' => \'DIyygbSzLjFmfSUPjVlA\',\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Getting unknown property: common\\\\models\\\\AccountInfo::login_ip\',\n]');
INSERT INTO `t_system_log` VALUES (56, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'qqq1111\',\n        \'avatar\' => \'/uploads/3.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'login_ip\' => \'127.0.0.1\',\n        \'itime\' => 1769874085,\n        \'utime\' => 1769874085,\n        \'invite_code\' => \'ftH4YdM3Fr9Fzz2MAVsA\',\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Setting unknown property: common\\\\models\\\\AccountInfo::login_ip\',\n]');
INSERT INTO `t_system_log` VALUES (57, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'qqq1111\',\n        \'avatar\' => \'/uploads/4.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769874182,\n        \'utime\' => 1769874182,\n        \'invite_code\' => \'3Xi3LQT4kqPS6W0g855J\',\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Getting unknown property: common\\\\models\\\\AccountInfo::login_ip\',\n]');
INSERT INTO `t_system_log` VALUES (58, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'qqq1111\',\n        \'avatar\' => \'/uploads/1.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769874266,\n        \'utime\' => 1769874266,\n        \'invite_code\' => \'gVT0Cb0piiT4942F2gyv\',\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Getting unknown property: common\\\\models\\\\AccountInfo::login_ip\',\n]');
INSERT INTO `t_system_log` VALUES (59, 1, 'err', 1769870000, '[::1][-][-]', '[\n    \'path\' => \'register\',\n    \'params\' => [\n        \'account\' => \'qqq1111\',\n        \'password\' => \'96e79218965eb72c92a549dd5a330112\',\n        \'nickname\' => \'qqq1111\',\n        \'avatar\' => \'/uploads/1.png\',\n        \'money\' => 0,\n        \'IDCard\' => \'\',\n        \'oneIncome\' => 0,\n        \'twoIncome\' => 0,\n        \'threeIncome\' => 0,\n        \'oneSharePeople\' => 0,\n        \'twoSharePeople\' => 0,\n        \'threeSharePeople\' => 0,\n        \'investAllMoney\' => 0,\n        \'RegisterIp\' => \'127.0.0.1\',\n        \'itime\' => 1769874285,\n        \'utime\' => 1769874285,\n        \'invite_code\' => \'pALig5LRQhtzSeEDu8zP\',\n        \'payPassword\' => \'96e79218965eb72c92a549dd5a330112\',\n    ],\n    \'msg\' => \'Getting unknown property: common\\\\models\\\\AccountInfo::login_ip\',\n]');
INSERT INTO `t_system_log` VALUES (60, 1, 'yii\\db\\Exception', 1770120000, '[::1][-][-]', 'PDOException: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'login_ip\' in \'field list\' in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1120): yii\\db\\Command->internalExecute(\'UPDATE `t_accou...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveRecord.php(336): yii\\db\\Command->execute()\n#3 D:\\work\\pro\\backend\\common\\models\\AccountInfo.php(202): yii\\db\\ActiveRecord::updateAll(Array, Array)\n#4 D:\\work\\pro\\backend\\backend\\controllers\\LoginController.php(169): common\\models\\AccountInfo->login(Object(common\\models\\AccountInfo), \'127.0.0.1\')\n#5 [internal function]: backend\\controllers\\LoginController->actionIndex()\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'login/index\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#11 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#12 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#13 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'login_ip\' in \'field list\'\nThe SQL being executed was: UPDATE `t_account_info` SET `login_ip`=\'127.0.0.1\', `last_login_time`=1770120956 WHERE `uid`=3 in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'UPDATE `t_accou...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1120): yii\\db\\Command->internalExecute(\'UPDATE `t_accou...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveRecord.php(336): yii\\db\\Command->execute()\n#3 D:\\work\\pro\\backend\\common\\models\\AccountInfo.php(202): yii\\db\\ActiveRecord::updateAll(Array, Array)\n#4 D:\\work\\pro\\backend\\backend\\controllers\\LoginController.php(169): common\\models\\AccountInfo->login(Object(common\\models\\AccountInfo), \'127.0.0.1\')\n#5 [internal function]: backend\\controllers\\LoginController->actionIndex()\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'login/index\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#11 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#12 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#13 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S22\n    [1] => 1054\n    [2] => Unknown column \'login_ip\' in \'field list\'\n)\n');
INSERT INTO `t_system_log` VALUES (61, 1, 'yii\\db\\Exception', 1770120000, '[::1][-][-]', 'PDOException: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'last_login_time\' in \'field list\' in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1120): yii\\db\\Command->internalExecute(\'UPDATE `t_accou...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveRecord.php(336): yii\\db\\Command->execute()\n#3 D:\\work\\pro\\backend\\common\\models\\AccountInfo.php(202): yii\\db\\ActiveRecord::updateAll(Array, Array)\n#4 D:\\work\\pro\\backend\\backend\\controllers\\LoginController.php(169): common\\models\\AccountInfo->login(Object(common\\models\\AccountInfo), \'127.0.0.1\')\n#5 [internal function]: backend\\controllers\\LoginController->actionIndex()\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'login/index\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#11 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#12 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#13 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S22]: Column not found: 1054 Unknown column \'last_login_time\' in \'field list\'\nThe SQL being executed was: UPDATE `t_account_info` SET `login_ip`=\'127.0.0.1\', `last_login_time`=1770121003 WHERE `uid`=3 in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'UPDATE `t_accou...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1120): yii\\db\\Command->internalExecute(\'UPDATE `t_accou...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveRecord.php(336): yii\\db\\Command->execute()\n#3 D:\\work\\pro\\backend\\common\\models\\AccountInfo.php(202): yii\\db\\ActiveRecord::updateAll(Array, Array)\n#4 D:\\work\\pro\\backend\\backend\\controllers\\LoginController.php(169): common\\models\\AccountInfo->login(Object(common\\models\\AccountInfo), \'127.0.0.1\')\n#5 [internal function]: backend\\controllers\\LoginController->actionIndex()\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'index\', Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'login/index\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#11 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#12 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#13 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S22\n    [1] => 1054\n    [2] => Unknown column \'last_login_time\' in \'field list\'\n)\n');
INSERT INTO `t_system_log` VALUES (62, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (63, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (64, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (65, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (66, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (67, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (68, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (69, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (70, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (71, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (72, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (73, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (74, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (75, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (76, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (77, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'info\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/info\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (78, 1, 'yii\\base\\UnknownPropertyException', 1770890000, '[::1][-][-]', 'yii\\base\\UnknownPropertyException: Getting unknown property: common\\models\\AccountInfo::account_type in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:154\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(296): yii\\base\\Component->__get(\'account_type\')\n#1 D:\\work\\pro\\backend\\common\\components\\ApiBearerAuth.php(47): yii\\db\\BaseActiveRecord->__get(\'account_type\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\filters\\auth\\AuthMethod.php(59): common\\components\\ApiBearerAuth->authenticate(Object(yii\\web\\User), Object(yii\\web\\Request), Object(yii\\web\\Response))\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\ActionFilter.php(77): yii\\filters\\auth\\AuthMethod->beforeAction(Object(yii\\base\\InlineAction))\n#4 [internal function]: yii\\base\\ActionFilter->beforeFilter(Object(yii\\base\\ActionEvent))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php(633): call_user_func(Array, Object(yii\\base\\ActionEvent))\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(297): yii\\base\\Component->trigger(\'beforeAction\', Object(yii\\base\\ActionEvent))\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Controller.php(219): yii\\base\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(176): yii\\web\\Controller->beforeAction(Object(yii\\base\\InlineAction))\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'detail\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'sign-in/detail\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}');
INSERT INTO `t_system_log` VALUES (79, 1, 'yii\\db\\Exception', 1770890000, '[::1][3][-]', 'PDOException: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_user_sign_in\' doesn\'t exist in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT COUNT(*)...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(443): yii\\db\\Command->queryInternal(\'fetchColumn\', 0)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(497): yii\\db\\Command->queryScalar()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(352): yii\\db\\Query->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(368): yii\\db\\ActiveQuery->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#6 D:\\work\\pro\\backend\\common\\models\\UserSignIn.php(40): yii\\db\\Query->count()\n#7 D:\\work\\pro\\backend\\backend\\controllers\\SignInController.php(209): common\\models\\UserSignIn->getCount(3)\n#8 [internal function]: backend\\controllers\\SignInController->actionDetail()\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'detail\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'sign-in/detail\', Array)\n#13 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#14 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#15 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#16 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_user_sign_in\' doesn\'t exist\nThe SQL being executed was: SELECT COUNT(*) FROM `t_user_sign_in` WHERE `uid` = 3 in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT COUNT(*)...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT COUNT(*)...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(443): yii\\db\\Command->queryInternal(\'fetchColumn\', 0)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(497): yii\\db\\Command->queryScalar()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(352): yii\\db\\Query->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(368): yii\\db\\ActiveQuery->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#6 D:\\work\\pro\\backend\\common\\models\\UserSignIn.php(40): yii\\db\\Query->count()\n#7 D:\\work\\pro\\backend\\backend\\controllers\\SignInController.php(209): common\\models\\UserSignIn->getCount(3)\n#8 [internal function]: backend\\controllers\\SignInController->actionDetail()\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'detail\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'sign-in/detail\', Array)\n#13 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#14 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#15 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#16 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S02\n    [1] => 1146\n    [2] => Table \'stock.t_user_sign_in\' doesn\'t exist\n)\n');
INSERT INTO `t_system_log` VALUES (80, 1, 'yii\\db\\Exception', 1770890000, '[::1][3][-]', 'PDOException: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_user_sign_in\' doesn\'t exist in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT COUNT(*)...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(443): yii\\db\\Command->queryInternal(\'fetchColumn\', 0)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(497): yii\\db\\Command->queryScalar()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(352): yii\\db\\Query->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(368): yii\\db\\ActiveQuery->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#6 D:\\work\\pro\\backend\\common\\models\\UserSignIn.php(40): yii\\db\\Query->count()\n#7 D:\\work\\pro\\backend\\backend\\controllers\\SignInController.php(209): common\\models\\UserSignIn->getCount(3)\n#8 [internal function]: backend\\controllers\\SignInController->actionDetail()\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'detail\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'sign-in/detail\', Array)\n#13 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#14 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#15 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#16 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_user_sign_in\' doesn\'t exist\nThe SQL being executed was: SELECT COUNT(*) FROM `t_user_sign_in` WHERE `uid` = 3 in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT COUNT(*)...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT COUNT(*)...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(443): yii\\db\\Command->queryInternal(\'fetchColumn\', 0)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(497): yii\\db\\Command->queryScalar()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(352): yii\\db\\Query->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(368): yii\\db\\ActiveQuery->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#6 D:\\work\\pro\\backend\\common\\models\\UserSignIn.php(40): yii\\db\\Query->count()\n#7 D:\\work\\pro\\backend\\backend\\controllers\\SignInController.php(209): common\\models\\UserSignIn->getCount(3)\n#8 [internal function]: backend\\controllers\\SignInController->actionDetail()\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'detail\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'sign-in/detail\', Array)\n#13 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#14 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#15 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#16 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S02\n    [1] => 1146\n    [2] => Table \'stock.t_user_sign_in\' doesn\'t exist\n)\n');
INSERT INTO `t_system_log` VALUES (81, 1, 'yii\\db\\Exception', 1770890000, '[::1][3][-]', 'PDOException: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_user_sign_in\' doesn\'t exist in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT COUNT(*)...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(443): yii\\db\\Command->queryInternal(\'fetchColumn\', 0)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(497): yii\\db\\Command->queryScalar()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(352): yii\\db\\Query->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(368): yii\\db\\ActiveQuery->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#6 D:\\work\\pro\\backend\\common\\models\\UserSignIn.php(40): yii\\db\\Query->count()\n#7 D:\\work\\pro\\backend\\backend\\controllers\\SignInController.php(209): common\\models\\UserSignIn->getCount(3)\n#8 [internal function]: backend\\controllers\\SignInController->actionDetail()\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'detail\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'sign-in/detail\', Array)\n#13 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#14 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#15 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#16 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_user_sign_in\' doesn\'t exist\nThe SQL being executed was: SELECT COUNT(*) FROM `t_user_sign_in` WHERE `uid` = 3 in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT COUNT(*)...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT COUNT(*)...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(443): yii\\db\\Command->queryInternal(\'fetchColumn\', 0)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(497): yii\\db\\Command->queryScalar()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(352): yii\\db\\Query->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(368): yii\\db\\ActiveQuery->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#6 D:\\work\\pro\\backend\\common\\models\\UserSignIn.php(40): yii\\db\\Query->count()\n#7 D:\\work\\pro\\backend\\backend\\controllers\\SignInController.php(209): common\\models\\UserSignIn->getCount(3)\n#8 [internal function]: backend\\controllers\\SignInController->actionDetail()\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'detail\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'sign-in/detail\', Array)\n#13 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#14 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#15 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#16 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S02\n    [1] => 1146\n    [2] => Table \'stock.t_user_sign_in\' doesn\'t exist\n)\n');
INSERT INTO `t_system_log` VALUES (82, 1, 'yii\\base\\InvalidConfigException', 1770890000, '[::1][3][-]', 'yii\\base\\InvalidConfigException: The table does not exist: {{t_user_data_management}} in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveRecord.php:442\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveRecord.php(473): yii\\db\\ActiveRecord::getTableSchema()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(498): yii\\db\\ActiveRecord->attributes()\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(313): yii\\db\\BaseActiveRecord->hasAttribute(\'attributes\')\n#3 D:\\work\\pro\\backend\\common\\models\\UserDataManagement.php(76): yii\\db\\BaseActiveRecord->__set(\'attributes\', Array)\n#4 D:\\work\\pro\\backend\\backend\\controllers\\HelpController.php(94): common\\models\\UserDataManagement->addRecord(3, \'\\xE5\\xBC\\xA0\\xE5\\xB0\\x8F\\xE9\\x9B\\xAF\', \'111\', \'111\', \'221\', \'21\')\n#5 [internal function]: backend\\controllers\\HelpController->actionDataManagement()\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'data-management\', Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'help/data-manag...\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#11 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#12 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#13 {main}');
INSERT INTO `t_system_log` VALUES (83, 1, 'yii\\base\\InvalidConfigException', 1770890000, '[::1][3][-]', 'yii\\base\\InvalidConfigException: The table does not exist: {{t_user_data_management}} in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveRecord.php:442\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveRecord.php(473): yii\\db\\ActiveRecord::getTableSchema()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(498): yii\\db\\ActiveRecord->attributes()\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\BaseActiveRecord.php(313): yii\\db\\BaseActiveRecord->hasAttribute(\'attributes\')\n#3 D:\\work\\pro\\backend\\common\\models\\UserDataManagement.php(76): yii\\db\\BaseActiveRecord->__set(\'attributes\', Array)\n#4 D:\\work\\pro\\backend\\backend\\controllers\\HelpController.php(94): common\\models\\UserDataManagement->addRecord(3, \'\\xE5\\xBC\\xA0\\xE5\\xB0\\x8F\\xE9\\x9B\\xAF\', \'qw\', \'qw\', \'qwqw\', \'\')\n#5 [internal function]: backend\\controllers\\HelpController->actionDataManagement()\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'data-management\', Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'help/data-manag...\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#11 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#12 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#13 {main}');
INSERT INTO `t_system_log` VALUES (84, 1, 'yii\\db\\Exception', 1770890000, '[::1][3][-]', 'PDOException: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_user_sign_in\' doesn\'t exist in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT COUNT(*)...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(443): yii\\db\\Command->queryInternal(\'fetchColumn\', 0)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(497): yii\\db\\Command->queryScalar()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(352): yii\\db\\Query->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(368): yii\\db\\ActiveQuery->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#6 D:\\work\\pro\\backend\\common\\models\\UserSignIn.php(40): yii\\db\\Query->count()\n#7 D:\\work\\pro\\backend\\backend\\controllers\\SignInController.php(209): common\\models\\UserSignIn->getCount(3)\n#8 [internal function]: backend\\controllers\\SignInController->actionDetail()\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'detail\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'sign-in/detail\', Array)\n#13 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#14 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#15 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#16 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_user_sign_in\' doesn\'t exist\nThe SQL being executed was: SELECT COUNT(*) FROM `t_user_sign_in` WHERE `uid` = 3 in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT COUNT(*)...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT COUNT(*)...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(443): yii\\db\\Command->queryInternal(\'fetchColumn\', 0)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(497): yii\\db\\Command->queryScalar()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(352): yii\\db\\Query->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(368): yii\\db\\ActiveQuery->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#6 D:\\work\\pro\\backend\\common\\models\\UserSignIn.php(40): yii\\db\\Query->count()\n#7 D:\\work\\pro\\backend\\backend\\controllers\\SignInController.php(209): common\\models\\UserSignIn->getCount(3)\n#8 [internal function]: backend\\controllers\\SignInController->actionDetail()\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'detail\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'sign-in/detail\', Array)\n#13 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#14 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#15 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#16 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S02\n    [1] => 1146\n    [2] => Table \'stock.t_user_sign_in\' doesn\'t exist\n)\n');
INSERT INTO `t_system_log` VALUES (85, 1, 'yii\\db\\Exception', 1770890000, '[::1][3][-]', 'PDOException: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_user_sign_in\' doesn\'t exist in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT COUNT(*)...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(443): yii\\db\\Command->queryInternal(\'fetchColumn\', 0)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(497): yii\\db\\Command->queryScalar()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(352): yii\\db\\Query->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(368): yii\\db\\ActiveQuery->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#6 D:\\work\\pro\\backend\\common\\models\\UserSignIn.php(40): yii\\db\\Query->count()\n#7 D:\\work\\pro\\backend\\backend\\controllers\\SignInController.php(209): common\\models\\UserSignIn->getCount(3)\n#8 [internal function]: backend\\controllers\\SignInController->actionDetail()\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'detail\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'sign-in/detail\', Array)\n#13 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#14 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#15 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#16 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_user_sign_in\' doesn\'t exist\nThe SQL being executed was: SELECT COUNT(*) FROM `t_user_sign_in` WHERE `uid` = 3 in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT COUNT(*)...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT COUNT(*)...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(443): yii\\db\\Command->queryInternal(\'fetchColumn\', 0)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(497): yii\\db\\Command->queryScalar()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(352): yii\\db\\Query->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(368): yii\\db\\ActiveQuery->queryScalar(\'COUNT(*)\', Object(yii\\db\\Connection))\n#6 D:\\work\\pro\\backend\\common\\models\\UserSignIn.php(40): yii\\db\\Query->count()\n#7 D:\\work\\pro\\backend\\backend\\controllers\\SignInController.php(209): common\\models\\UserSignIn->getCount(3)\n#8 [internal function]: backend\\controllers\\SignInController->actionDetail()\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'detail\', Array)\n#12 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'sign-in/detail\', Array)\n#13 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#14 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#15 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#16 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S02\n    [1] => 1146\n    [2] => Table \'stock.t_user_sign_in\' doesn\'t exist\n)\n');
INSERT INTO `t_system_log` VALUES (86, 1, 'yii\\base\\UnknownMethodException', 1770900000, '[::1][3][-]', 'yii\\base\\UnknownMethodException: Calling unknown method: common\\models\\PayConfig::getRedisCacheOperation() in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:300\nStack trace:\n#0 D:\\work\\pro\\backend\\common\\models\\PayConfig.php(197): yii\\base\\Component->__call(\'getRedisCacheOp...\', Array)\n#1 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(263): common\\models\\PayConfig->getClientPayConfigList(1, 50, 100, 2, Array, NULL, 2)\n#2 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#8 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#9 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#10 {main}');
INSERT INTO `t_system_log` VALUES (87, 1, 'yii\\base\\UnknownMethodException', 1770900000, '[::1][3][-]', 'yii\\base\\UnknownMethodException: Calling unknown method: common\\models\\PayConfig::getRedisCacheOperation() in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:300\nStack trace:\n#0 D:\\work\\pro\\backend\\common\\models\\PayConfig.php(197): yii\\base\\Component->__call(\'getRedisCacheOp...\', Array)\n#1 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(263): common\\models\\PayConfig->getClientPayConfigList(1, 50, 100, 1, Array, NULL, 2)\n#2 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#8 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#9 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#10 {main}');
INSERT INTO `t_system_log` VALUES (88, 1, 'yii\\base\\UnknownMethodException', 1770900000, '[::1][3][-]', 'yii\\base\\UnknownMethodException: Calling unknown method: common\\models\\PayConfig::getRedisCacheOperation() in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:300\nStack trace:\n#0 D:\\work\\pro\\backend\\common\\models\\PayConfig.php(197): yii\\base\\Component->__call(\'getRedisCacheOp...\', Array)\n#1 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(263): common\\models\\PayConfig->getClientPayConfigList(1, 50, 100, 2, Array, NULL, 2)\n#2 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#8 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#9 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#10 {main}');
INSERT INTO `t_system_log` VALUES (89, 1, 'yii\\base\\UnknownMethodException', 1770900000, '[::1][3][-]', 'yii\\base\\UnknownMethodException: Calling unknown method: common\\models\\PayConfig::getRedisCacheOperation() in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:300\nStack trace:\n#0 D:\\work\\pro\\backend\\common\\models\\PayConfig.php(197): yii\\base\\Component->__call(\'getRedisCacheOp...\', Array)\n#1 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(263): common\\models\\PayConfig->getClientPayConfigList(1, 50, 100, 2, Array, NULL, 2)\n#2 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#8 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#9 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#10 {main}');
INSERT INTO `t_system_log` VALUES (90, 1, 'yii\\base\\UnknownMethodException', 1770900000, '[::1][3][-]', 'yii\\base\\UnknownMethodException: Calling unknown method: common\\models\\PayConfig::getRedisCacheOperation() in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:300\nStack trace:\n#0 D:\\work\\pro\\backend\\common\\models\\PayConfig.php(197): yii\\base\\Component->__call(\'getRedisCacheOp...\', Array)\n#1 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(263): common\\models\\PayConfig->getClientPayConfigList(1, 50, 100, 1, Array, NULL, 2)\n#2 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#8 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#9 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#10 {main}');
INSERT INTO `t_system_log` VALUES (91, 1, 'yii\\base\\UnknownMethodException', 1770900000, '[::1][3][-]', 'yii\\base\\UnknownMethodException: Calling unknown method: common\\models\\PayConfig::getRedisCacheOperation() in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:300\nStack trace:\n#0 D:\\work\\pro\\backend\\common\\models\\PayConfig.php(197): yii\\base\\Component->__call(\'getRedisCacheOp...\', Array)\n#1 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(263): common\\models\\PayConfig->getClientPayConfigList(1, 50, 100, 2, Array, NULL, 2)\n#2 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#8 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#9 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#10 {main}');
INSERT INTO `t_system_log` VALUES (92, 1, 'yii\\base\\UnknownMethodException', 1770900000, '[::1][3][-]', 'yii\\base\\UnknownMethodException: Calling unknown method: common\\models\\PayConfig::getRedisCacheOperation() in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Component.php:300\nStack trace:\n#0 D:\\work\\pro\\backend\\common\\models\\PayConfig.php(197): yii\\base\\Component->__call(\'getRedisCacheOp...\', Array)\n#1 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(263): common\\models\\PayConfig->getClientPayConfigList(1, 50, 100, 2, Array, NULL, 2)\n#2 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#6 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#8 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#9 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#10 {main}');
INSERT INTO `t_system_log` VALUES (93, 1, 'yii\\db\\Exception', 1770900000, '[::1][3][-]', 'PDOException: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_pay_config\' doesn\'t exist in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(417): yii\\db\\Command->queryInternal(\'fetchAll\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(249): yii\\db\\Command->queryAll()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(133): yii\\db\\Query->all(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(277): yii\\db\\ActiveQuery->all()\n#6 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_pay_config\' doesn\'t exist\nThe SQL being executed was: SELECT * FROM `t_pay_config` WHERE ((`type`=1) AND (`payConfigType`=2)) AND (`minMoney` <= 100) AND (`maxMoney` >= 100) AND ((`payType`=2) OR (`payType`=3)) ORDER BY `sort` DESC in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT * FROM `...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(417): yii\\db\\Command->queryInternal(\'fetchAll\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(249): yii\\db\\Command->queryAll()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(133): yii\\db\\Query->all(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(277): yii\\db\\ActiveQuery->all()\n#6 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S02\n    [1] => 1146\n    [2] => Table \'stock.t_pay_config\' doesn\'t exist\n)\n');
INSERT INTO `t_system_log` VALUES (94, 1, 'yii\\db\\Exception', 1770900000, '[::1][3][-]', 'PDOException: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_pay_config\' doesn\'t exist in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(417): yii\\db\\Command->queryInternal(\'fetchAll\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(249): yii\\db\\Command->queryAll()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(133): yii\\db\\Query->all(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(277): yii\\db\\ActiveQuery->all()\n#6 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_pay_config\' doesn\'t exist\nThe SQL being executed was: SELECT * FROM `t_pay_config` WHERE ((`type`=1) AND (`payConfigType`=2)) AND (`minMoney` <= 100) AND (`maxMoney` >= 100) AND ((`payType`=2) OR (`payType`=3)) ORDER BY `sort` DESC in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT * FROM `...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(417): yii\\db\\Command->queryInternal(\'fetchAll\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(249): yii\\db\\Command->queryAll()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(133): yii\\db\\Query->all(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(277): yii\\db\\ActiveQuery->all()\n#6 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S02\n    [1] => 1146\n    [2] => Table \'stock.t_pay_config\' doesn\'t exist\n)\n');
INSERT INTO `t_system_log` VALUES (95, 1, 'yii\\db\\Exception', 1770900000, '[::1][3][-]', 'PDOException: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_pay_config\' doesn\'t exist in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(417): yii\\db\\Command->queryInternal(\'fetchAll\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(249): yii\\db\\Command->queryAll()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(133): yii\\db\\Query->all(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(277): yii\\db\\ActiveQuery->all()\n#6 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_pay_config\' doesn\'t exist\nThe SQL being executed was: SELECT * FROM `t_pay_config` WHERE ((`type`=1) AND (`payConfigType`=2)) AND (`minMoney` <= 100) AND (`maxMoney` >= 100) AND ((`payType`=2) OR (`payType`=3)) ORDER BY `sort` DESC in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT * FROM `...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(417): yii\\db\\Command->queryInternal(\'fetchAll\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(249): yii\\db\\Command->queryAll()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(133): yii\\db\\Query->all(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(277): yii\\db\\ActiveQuery->all()\n#6 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S02\n    [1] => 1146\n    [2] => Table \'stock.t_pay_config\' doesn\'t exist\n)\n');
INSERT INTO `t_system_log` VALUES (96, 1, 'yii\\db\\Exception', 1770900000, '[::1][3][-]', 'PDOException: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_pay_config\' doesn\'t exist in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php:1320\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1320): PDOStatement->execute()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(417): yii\\db\\Command->queryInternal(\'fetchAll\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(249): yii\\db\\Command->queryAll()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(133): yii\\db\\Query->all(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(277): yii\\db\\ActiveQuery->all()\n#6 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\n\nNext yii\\db\\Exception: SQLSTATE[42S02]: Base table or view not found: 1146 Table \'stock.t_pay_config\' doesn\'t exist\nThe SQL being executed was: SELECT * FROM `t_pay_config` WHERE ((`type`=1) AND (`payConfigType`=2)) AND (`minMoney` <= 100) AND (`maxMoney` >= 100) AND ((`payType`=2) OR (`payType`=3)) ORDER BY `sort` DESC in D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Schema.php:676\nStack trace:\n#0 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1325): yii\\db\\Schema->convertException(Object(PDOException), \'SELECT * FROM `...\')\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(1186): yii\\db\\Command->internalExecute(\'SELECT * FROM `...\')\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Command.php(417): yii\\db\\Command->queryInternal(\'fetchAll\', NULL)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\Query.php(249): yii\\db\\Command->queryAll()\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\db\\ActiveQuery.php(133): yii\\db\\Query->all(NULL)\n#5 D:\\work\\pro\\backend\\backend\\controllers\\WalletController.php(277): yii\\db\\ActiveQuery->all()\n#6 [internal function]: backend\\controllers\\WalletController->actionPaymentChannels()\n#7 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#8 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#9 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'payment-channel...\', Array)\n#10 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'wallet/payment-...\', Array)\n#11 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#12 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#13 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#14 {main}\r\nAdditional Information:\r\nArray\n(\n    [0] => 42S02\n    [1] => 1146\n    [2] => Table \'stock.t_pay_config\' doesn\'t exist\n)\n');
INSERT INTO `t_system_log` VALUES (97, 1, 'Error', 1770900000, '[::1][3][-]', 'Error: Call to undefined method common\\helpers\\RedisHelper::deleteTokenByUid() in D:\\work\\pro\\backend\\backend\\controllers\\UserController.php:153\nStack trace:\n#0 [internal function]: backend\\controllers\\UserController->actionLogout()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'logout\', Array)\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'user/logout\', Array)\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#6 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#7 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#8 {main}');
INSERT INTO `t_system_log` VALUES (98, 1, 'Error', 1770900000, '[::1][3][-]', 'Error: Call to undefined method common\\helpers\\RedisHelper::deleteTokenByUid() in D:\\work\\pro\\backend\\backend\\controllers\\UserController.php:153\nStack trace:\n#0 [internal function]: backend\\controllers\\UserController->actionLogout()\n#1 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\InlineAction.php(57): call_user_func_array(Array, Array)\n#2 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Controller.php(178): yii\\base\\InlineAction->runWithParams(Array)\n#3 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Module.php(552): yii\\base\\Controller->runAction(\'logout\', Array)\n#4 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\web\\Application.php(103): yii\\base\\Module->runAction(\'user/logout\', Array)\n#5 D:\\work\\pro\\backend\\vendor\\yiisoft\\yii2\\base\\Application.php(384): yii\\web\\Application->handleRequest(Object(yii\\web\\Request))\n#6 D:\\work\\pro\\backend\\backend\\web\\index.php(18): yii\\base\\Application->run()\n#7 D:\\work\\pro\\backend\\backend\\web\\router.php(14): require(\'D:\\\\work\\\\pro\\\\bac...\')\n#8 {main}');

-- ----------------------------
-- Table structure for t_test
-- ----------------------------
DROP TABLE IF EXISTS `t_test`;
CREATE TABLE `t_test`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int(10) NULL DEFAULT 0 COMMENT '会员ID',
  `admin_id` int(10) NULL DEFAULT 0 COMMENT '管理员ID',
  `category_id` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '分类ID(单选)',
  `category_ids` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '分类ID(多选)',
  `tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '标签',
  `week` enum('monday','tuesday','wednesday') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '星期(单选):monday=星期一,tuesday=星期二,wednesday=星期三',
  `flag` set('hot','index','recommend') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '标志(多选):hot=热门,index=首页,recommend=推荐',
  `genderdata` enum('male','female') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'male' COMMENT '性别(单选):male=男,female=女',
  `hobbydata` set('music','reading','swimming') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '爱好(多选):music=音乐,reading=读书,swimming=游泳',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '内容',
  `image` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '图片',
  `images` varchar(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '图片组',
  `attachfile` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '附件',
  `keywords` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '关键字',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '描述',
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '省市',
  `array` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '数组:value=值',
  `json` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '配置:key=名称,value=值',
  `multiplejson` varchar(1500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '二维数组:title=标题,intro=介绍,author=作者,age=年龄',
  `price` decimal(10, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '价格',
  `views` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '点击',
  `workrange` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '时间区间',
  `startdate` date NULL DEFAULT NULL COMMENT '开始日期',
  `activitytime` datetime NULL DEFAULT NULL COMMENT '活动时间(datetime)',
  `year` year NULL DEFAULT NULL COMMENT '年',
  `times` time NULL DEFAULT NULL COMMENT '时间',
  `refreshtime` bigint(16) NULL DEFAULT NULL COMMENT '刷新时间',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `deletetime` bigint(16) NULL DEFAULT NULL COMMENT '删除时间',
  `weigh` int(10) NULL DEFAULT 0 COMMENT '权重',
  `switch` tinyint(1) NULL DEFAULT 0 COMMENT '开关',
  `status` enum('normal','hidden') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'normal' COMMENT '状态',
  `state` enum('0','1','2') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '1' COMMENT '状态值:0=禁用,1=正常,2=推荐',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '测试表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_test
-- ----------------------------
INSERT INTO `t_test` VALUES (1, 1, 1, 12, '12,13', '互联网,计算机', 'monday', 'hot,index', 'male', 'music,reading', '我是一篇测试文章', '<p>我是测试内容</p>', '/assets/img/avatar.png', '/assets/img/avatar.png,/assets/img/qrcode.png', '/assets/img/avatar.png', '关键字', '我是一篇测试文章描述，内容过多时将自动隐藏', '广西壮族自治区/百色市/平果县', '[\"a\",\"b\"]', '{\"a\":\"1\",\"b\":\"2\"}', '[{\"title\":\"标题一\",\"intro\":\"介绍一\",\"author\":\"小明\",\"age\":\"21\"}]', 0.00, 0, '2020-10-01 00:00:00 - 2021-10-31 23:59:59', '2017-07-10', '2017-07-10 18:24:45', 2017, '18:24:45', 1491635035, 1491635035, 1491635035, NULL, 0, 1, 'normal', '1');

-- ----------------------------
-- Table structure for t_user_data_management
-- ----------------------------
DROP TABLE IF EXISTS `t_user_data_management`;
CREATE TABLE `t_user_data_management`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) NOT NULL COMMENT '用户ID',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
  `id_number` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '身份证号',
  `projects` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '曾参加的项目',
  `contribution` decimal(16, 2) NULL DEFAULT NULL COMMENT '业绩贡献总资产',
  `additional_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '补充说明',
  `itime` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `utime` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_data_management_uid`(`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户资料信息管理表单记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user_data_management
-- ----------------------------
INSERT INTO `t_user_data_management` VALUES (1, 3, '张小雯', '1', '1', 1.00, '1', 1770894808, 1770894808);

-- ----------------------------
-- Table structure for t_user_fund_month
-- ----------------------------
DROP TABLE IF EXISTS `t_user_fund_month`;
CREATE TABLE `t_user_fund_month`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增字段',
  `uid` bigint(20) NULL DEFAULT 0 COMMENT 'uid',
  `income` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '收益',
  `day` date NULL DEFAULT NULL COMMENT '每天',
  `itime` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `utime` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_fund_month_only`(`uid`, `day`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户圆梦基金每月' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user_fund_month
-- ----------------------------

-- ----------------------------
-- Table structure for t_user_product
-- ----------------------------
DROP TABLE IF EXISTS `t_user_product`;
CREATE TABLE `t_user_product`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增字段',
  `uid` bigint(20) NULL DEFAULT 0 COMMENT 'uid',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '产品名称',
  `price` decimal(20, 2) NOT NULL COMMENT '产品价格',
  `day` int(11) NULL DEFAULT 0 COMMENT '产品天数',
  `day_income` decimal(20, 2) NOT NULL COMMENT '每日收益',
  `total_income` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '预计累计总收益',
  `allowance` decimal(20, 2) NULL DEFAULT NULL COMMENT '产品补助',
  `num` int(11) NULL DEFAULT 0 COMMENT '产品数量',
  `total_price` decimal(20, 2) NOT NULL COMMENT '产品总价',
  `type` tinyint(1) NULL DEFAULT 1 COMMENT '状态 1-默认 2-已完成',
  `itime` int(11) NOT NULL COMMENT '创建时间',
  `utime` int(11) NOT NULL COMMENT '更新时间',
  `end_time` int(11) NULL DEFAULT NULL COMMENT '到期时间',
  `income_price` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '收益价格',
  `product_id` int(11) NULL DEFAULT 0 COMMENT '产品ID',
  `two_day_allowance` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '第二天补助',
  `two_day_type` tinyint(1) NULL DEFAULT 0 COMMENT '1-已领取',
  `register_date` date NULL DEFAULT NULL COMMENT '注册日期',
  `oneLevel` bigint(20) NULL DEFAULT 0 COMMENT '上级uid',
  `total_pay_back` decimal(20, 2) NULL DEFAULT 0.00 COMMENT '总返利',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户产品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user_product
-- ----------------------------

-- ----------------------------
-- Table structure for t_user_product_income
-- ----------------------------
DROP TABLE IF EXISTS `t_user_product_income`;
CREATE TABLE `t_user_product_income`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增字段',
  `uid` bigint(20) NULL DEFAULT 0 COMMENT 'uid',
  `user_product_id` int(20) NULL DEFAULT 0 COMMENT '用户产品ID',
  `product_id` int(20) NULL DEFAULT 0 COMMENT '产品ID',
  `income` decimal(20, 2) NOT NULL DEFAULT 0.00 COMMENT '收益',
  `day` date NULL DEFAULT NULL COMMENT '每天',
  `itime` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `utime` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `income_only`(`uid`, `user_product_id`, `day`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户产品收益表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user_product_income
-- ----------------------------

-- ----------------------------
-- Table structure for t_version
-- ----------------------------
DROP TABLE IF EXISTS `t_version`;
CREATE TABLE `t_version`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `oldversion` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '旧版本号',
  `newversion` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '新版本号',
  `packagesize` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '包大小',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '升级内容',
  `downloadurl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '下载地址',
  `enforce` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '强制更新',
  `createtime` bigint(16) NULL DEFAULT NULL COMMENT '创建时间',
  `updatetime` bigint(16) NULL DEFAULT NULL COMMENT '更新时间',
  `weigh` int(10) NOT NULL DEFAULT 0 COMMENT '权重',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '版本表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_version
-- ----------------------------

-- ----------------------------
-- Table structure for t_video
-- ----------------------------
DROP TABLE IF EXISTS `t_video`;
CREATE TABLE `t_video`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '标记id, 主键，自增字段',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题, 存储文章或内容的标题',
  `coverUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '封面, 存储内容的封面图片URL, 默认为NULL',
  `video_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '视频地址',
  `video_duration` int(11) NOT NULL COMMENT '视频时长',
  `type` int(1) NOT NULL DEFAULT 1 COMMENT '状态, 1 为启用，2 为关闭',
  `itime` int(11) NOT NULL COMMENT '创建时间, 存储内容的创建时间 (Unix 时间戳)',
  `utime` int(11) NOT NULL COMMENT '更新时间, 存储内容的最后更新时间 (Unix 时间戳)',
  `is_hot` tinyint(1) NULL DEFAULT 1 COMMENT '1-默认 2-最热',
  `is_new` tinyint(1) NULL DEFAULT 1 COMMENT '1-默认 2-最新',
  `sort` int(11) NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '视频表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_video
-- ----------------------------

-- ----------------------------
-- Table structure for t_vip_login_info
-- ----------------------------
DROP TABLE IF EXISTS `t_vip_login_info`;
CREATE TABLE `t_vip_login_info`  (
  `vip_id` int(11) NOT NULL COMMENT 'Vip ID',
  `login_type` int(11) NOT NULL COMMENT 'Login Type',
  `last_logout` datetime NULL DEFAULT NULL COMMENT 'Last Logout',
  `login_count` int(11) NULL DEFAULT 0 COMMENT 'Login Count',
  `itime` int(11) NOT NULL COMMENT 'Itime',
  `utime` int(11) NOT NULL COMMENT 'Utime',
  PRIMARY KEY (`vip_id`) USING BTREE,
  UNIQUE INDEX `vip_login_only`(`vip_id`, `login_type`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'vip登录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_vip_login_info
-- ----------------------------

-- ----------------------------
-- Table structure for t_withdrawal
-- ----------------------------
DROP TABLE IF EXISTS `t_withdrawal`;
CREATE TABLE `t_withdrawal`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '标记id',
  `uid` bigint(20) UNSIGNED NOT NULL COMMENT '用户id',
  `otn` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '订单号',
  `money` decimal(10, 2) NOT NULL COMMENT '金额',
  `card_id` bigint(20) UNSIGNED NOT NULL COMMENT '订单id',
  `type` tinyint(3) UNSIGNED NOT NULL COMMENT '订单状态 。1申请中 。2余额扣除失败 。3等审核确认代付 。4代付失败,查看原因。5代付中 。6成功 。7代付失败 。8取消',
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ip',
  `itime` bigint(20) UNSIGNED NOT NULL COMMENT '创建时间戳',
  `utime` bigint(20) UNSIGNED NOT NULL COMMENT '更新时间戳',
  `pay_time` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '代付时间',
  `pay_type` int(11) NULL DEFAULT 1 COMMENT '1-银行卡 2-支付宝',
  `realName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
  `bankName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '银行名字',
  `bankCard` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '银行卡号',
  `alipay_card` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '支付宝账号',
  `request` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `err` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `withdrawal_only`(`otn`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '交易记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_withdrawal
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
