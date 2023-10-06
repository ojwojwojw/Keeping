CREATE TABLE `Account` (
	`id`	bigint	NOT NULL,
	`member_key`	varchar(255)	NOT NULL,
	`account_number`	char(18)	NOT NULL,
	`auth_password`	longtext	NOT NULL,
	`balance`	bigint	NOT NULL,
	`active`	boolean	NOT NULL,
	`created_date`	timestamp	NOT NULL,
	`last_modified_date`	timestamp	NOT NULL
);

CREATE TABLE `AccountHistory` (
	`id`	bigint	NOT NULL,
	`account_id`	bigint	NOT NULL,
	`store_name`	varchar(200)	NOT NULL,
	`type`	boolean	NOT NULL,
	`money`	bigint	NOT NULL,
	`balance`	bigint	NOT NULL,
	`remain`	bigint	NOT NULL,
	`large_category`	varchar(30)	NOT NULL,
	`detailed`	boolean	NOT NULL,
	`address`	longtext	NOT NULL,
	`latitude`	double	NULL,
	`longitude`	double	NULL,
	`created_date`	timestamp	NOT NULL,
	`last_modified_date`	timestamp	NOT NULL
);

CREATE TABLE `PiggyAccount` (
	`id`	bigint	NOT NULL,
	`child_key`	varchar(255)	NOT NULL,
	`account_number`	char(18)	NOT NULL,
	`content`	varchar(150)	NOT NULL,
	`goal_money`	bigint	NOT NULL,
	`balance`	bigint	NOT NULL,
	`upload_image`	longtext	NOT NULL,
	`saved_image`	longtext	NOT NULL,
	`completed`	varchar(10)	NOT NULL,
	`active`	varchar(10)	NOT NULL,
	`created_date`	timestamp	NOT NULL,
	`last_modified_date`	timestamp	NOT NULL
);

CREATE TABLE `PiggyHistory` (
	`id`	bigint	NOT NULL,
	`piggy_id`	bigint	NOT NULL,
	`name`	varchar(200)	NOT NULL,
	`money`	bigint	NOT NULL,
	`balance`	bigint	NOT NULL,
	`created_date`	timestamp	NOT NULL,
	`last_modified_date`	timestamp	NOT NULL
);

CREATE TABLE `Question` (
	`id`	bigint	NOT NULL,
	`parent_key`	varchar(255)	NOT NULL,
	`child_key`	varchar(255)	NOT NULL,
	`content`	longtext	NULL,
	`is_created`	boolean	NOT NULL,
	`parent_answer`	longtext	NULL,
	`child_answer`	longtext	NULL,
	`scheduled_time`	timestamp	NOT NULL,
	`created_date`	timestamp	NOT NULL,
	`last_modified_date`	timestamp	NOT NULL
);

CREATE TABLE `AccountDetail` (
	`id`	bigint	NOT NULL,
	`account_history_id`	bigint	NOT NULL,
	`content`	longtext	NOT NULL,
	`money`	bigint	NOT NULL,
	`small_category`	varchar(30)	NOT NULL,
	`created_date`	timestamp	NOT NULL,
	`last_modified_date`	timestamp	NOT NULL
);

CREATE TABLE `Mission` (
	`mission_id`	bigint	NOT NULL,
	`child_key`	varchar(255)	NOT NULL,
	`todo`	longtext	NOT NULL,
	`money`	bigint	NOT NULL,
	`cheeringMessage`	varchar(300)	NULL,
	`childRequestComment`	varchar(300)	NULL,
	`finishedComment`	varchar(300)	NULL,
	`type`	varchar(20)	NULL,
	`start_date`	Date	NULL,
	`end_date`	Date	NULL,
	`completed`	varchar(10)	NOT NULL,
	`created_date`	timestamp	NOT NULL,
	`last_modified_date`	timestamp	NOT NULL
);

CREATE TABLE `Member` (
	`member_id`	bigint	NOT NULL,
	`member_key`	varchar(255)	NOT NULL,
	`login_id`	varchar(20)	NOT NULL,
	`encryption_pw`	varchar(25)	NOT NULL,
	`name`	varchar(20)	NOT NULL,
	`phone`	varchar(13)	NOT NULL,
	`birth`	timestamp	NOT NULL,
	`profile_image`	longtext	NULL,
	`fcm_token`	longtext	NULL,
	`active`	boolean	NOT NULL,
	`created_date`	timestamp	NOT NULL,
	`last_modified_date`	timestamp	NULL
);

CREATE TABLE `Parent` (
	`parent_id`	bigint	NOT NULL,
	`member_id`	bigint	NOT NULL
);

CREATE TABLE `Child` (
	`child_id`	bigint	NOT NULL,
	`member_id`	bigint	NOT NULL,
	`question_time`	timestamp	NULL
);

CREATE TABLE `Link` (
	`link_id`	bigint	NOT NULL,
	`parent_id`	bigint	NOT NULL,
	`child_id`	bigint	NOT NULL
);

CREATE TABLE `Noti` (
	`noti_id`	bigint	NOT NULL,
	`member_key`	varchar(255)	NOT NULL,
	`fcm_token`	varchar(255)	NOT NULL,
	`title`	varchar(255)	NOT NULL,
	`content`	varchar(255)	NOT NULL,
	`type`	varchar(20)	NOT NULL,
	`created_date`	timestamp	NOT NULL,
	`last_modified_date`	timestamp	NOT NULL
);

CREATE TABLE `Allowance` (
	`id`	bigint	NOT NULL,
	`childKey`	varchar(255)	NOT NULL,
	`content`	longtext	NOT NULL,
	`money`	int	NOT NULL,
	`approve`	varchar(20)	NOT NULL,
	`created_date`	timestamp	NOT NULL,
	`last_modified_date`	timestamp	NOT NULL
);

CREATE TABLE `Online` (
	`id`	bigint	NOT NULL,
	`childKey`	varchar(255)	NOT NULL,
	`product_name`	longtext	NOT NULL,
	`url`	longtext	NOT NULL,
	`content`	longtext	NOT NULL,
	`total_money`	int	NOT NULL,
	`child_money`	int	NOT NULL,
	`comment`	longtext	NULL,
	`approve`	varchar(20)	NOT NULL,
	`created_date`	timestamp	NOT NULL,
	`last_modified_date`	timestamp	NOT NULL
);

CREATE TABLE `Comment` (
	`id`	bigint	NOT NULL,
	`question_id`	bigint	NOT NULL,
	`member_key`	varchar(255)	NOT NULL,
	`content`	longtext	NOT NULL,
	`is_active`	boolean	NOT NULL,
	`created_date`	timestamp	NULL,
	`last_modified_date`	timestamp	NULL
);

CREATE TABLE `RegularAllowance` (
	`id`	bigint	NOT NULL,
	`parent_key`	varchar(255)	NOT NULL,
	`child_key`	varchar(255)	NOT NULL,
	`money`	bigint	NOT NULL,
	`day`	int	NOT NULL,
	`created_date`	timestamp	NOT NULL,
	`last_modified_date`	timestamp	NOT NULL
);

ALTER TABLE `Account` ADD CONSTRAINT `PK_ACCOUNT` PRIMARY KEY (
	`id`
);

ALTER TABLE `AccountHistory` ADD CONSTRAINT `PK_ACCOUNTHISTORY` PRIMARY KEY (
	`id`
);

ALTER TABLE `PiggyAccount` ADD CONSTRAINT `PK_PIGGYACCOUNT` PRIMARY KEY (
	`id`
);

ALTER TABLE `PiggyHistory` ADD CONSTRAINT `PK_PIGGYHISTORY` PRIMARY KEY (
	`id`
);

ALTER TABLE `Question` ADD CONSTRAINT `PK_QUESTION` PRIMARY KEY (
	`id`
);

ALTER TABLE `AccountDetail` ADD CONSTRAINT `PK_ACCOUNTDETAIL` PRIMARY KEY (
	`id`
);

ALTER TABLE `Mission` ADD CONSTRAINT `PK_MISSION` PRIMARY KEY (
	`mission_id`
);

ALTER TABLE `Member` ADD CONSTRAINT `PK_MEMBER` PRIMARY KEY (
	`member_id`
);

ALTER TABLE `Parent` ADD CONSTRAINT `PK_PARENT` PRIMARY KEY (
	`parent_id`
);

ALTER TABLE `Child` ADD CONSTRAINT `PK_CHILD` PRIMARY KEY (
	`child_id`
);

ALTER TABLE `Link` ADD CONSTRAINT `PK_LINK` PRIMARY KEY (
	`link_id`
);

ALTER TABLE `Noti` ADD CONSTRAINT `PK_NOTI` PRIMARY KEY (
	`noti_id`
);

ALTER TABLE `Allowance` ADD CONSTRAINT `PK_ALLOWANCE` PRIMARY KEY (
	`id`
);

ALTER TABLE `Online` ADD CONSTRAINT `PK_ONLINE` PRIMARY KEY (
	`id`
);

ALTER TABLE `Comment` ADD CONSTRAINT `PK_COMMENT` PRIMARY KEY (
	`id`
);

ALTER TABLE `RegularAllowance` ADD CONSTRAINT `PK_REGULARALLOWANCE` PRIMARY KEY (
	`id`
);

