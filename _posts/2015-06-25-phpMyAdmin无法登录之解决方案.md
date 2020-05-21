---
layout: post
title: phpMyAdmin无法登录之解决方案
date: 2015-06-25 20:42
author: alvachien
comments: true
categories: [MySql, PHP, phpMyAdmin, Web Development, 技术Tips]
---
登录phpMyAdmin，一直有个user没有设置密码的警告，于是把root的密码给修改掉了，然后，再登录phpMyAdmin，一个华丽丽的错误显示在屏幕上：
```log
#1045 - Access denied for user 'root'@'localhost' (using password: NO)
```

反复登录，然而错误坚挺依旧。于是，万能的搜索引擎开动了，最后解决方案如下：
- 打开PHPMyAdmin的安装目录；
- 打开config.inc.php文件，修改以下几行：

```ini
/* Authentication type */
$cfg['Servers'][$i]['verbose'] = 'mysql';
//$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['auth_type'] = 'config';
$cfg['Servers'][$i]['user'] = 'root'; /* 修改*/
$cfg['Servers'][$i]['password'] = ''; /* 修改*/
/* Server parameters */
$cfg['Servers'][$i]['host'] = '127.0.0.1';
$cfg['Servers'][$i]['connect_type'] = 'tcp';
$cfg['Servers'][$i]['compress'] = false;
/* Select mysql if your server does not have mysqli */
$cfg['Servers'][$i]['extension'] = 'mysqli';
$cfg['Servers'][$i]['AllowNoPassword'] = true; /* 修改*/
```

是为之记。

Alva Chien

2015.6.25
