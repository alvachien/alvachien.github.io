---
layout: post
title: "Solve the issues on AngularJS: [$injector:modulerr]"
date: 2015-06-19 23:29
author: alvachien
comments: true
categories: [AngularJS, JavaScript, Web Development]
---
按照现有的Angular JS的教程，即便最简单的controller定义都会遇到[$injector:modulerr]的错误。万能的搜索引擎告诉我，这种问题只出现在AngularJS 1.3版本之后，换言之，这是版本1.2到1.2的break update。

解决方案：

var app = angular.module('aApp', []);

替换为：

var app = angular.module('aApp', ["ngRoute"]);

注意的是，需要include Angular-router.js。

是为之记。
Alva Chien
2015.6.19
