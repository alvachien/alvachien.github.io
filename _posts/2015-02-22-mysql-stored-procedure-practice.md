---
layout: post
title: MySQL Stored Procedure Practice
date: 2015-02-22 15:51
author: alvachien
comments: true
categories: [MariaDB, MySql, PHP, Web Development]
---
使用MySQL的几点心得。

(1) 如果在MySQL的table定义Column为AI，则需要获取新生成的ID，或者需要根据新生成的ID执行对应的View。MySQL定义了LAST_INSERT_ID()方法来获取新生成的ID。

(2) MySql 的出错处理。通过定义DECLARE CONTINUE HANDLER FOR SQLEXCEPTION是实现。该方法对MySQL的版本有依赖。MariaDB需要版本10以上才支持。

一个示例Stored Procedure如下：

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CREATE_LEARNCATEGORY`(
IN parid int(11),
IN ctgyname varchar(45),
IN cmt varchar(150))
BEGIN
-- Declare exception handler for failed insert
DECLARE code CHAR(5) DEFAULT '00000';
DECLARE msg TEXT;
DECLARE rows INT;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1
code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
END;

-- Check the existence of the user
IF EXISTS(SELECT 1 FROM t_learn_ctgy WHERE id = parid) THEN
INSERT INTO `t_learn_ctg` (`PARENT_ID`, `NAME`, `COMMENT`)
VALUES (parid, ctgyname, cmt);
ELSE
SET msg = 'Invalid Parent ID!';
SET code = '00001';
END IF;

SELECT code, msg, LAST_INSERT_ID();
END$$
DELIMITER ;

是为之记。
Alva Chien
2015.2.22
