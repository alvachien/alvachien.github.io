---
layout: post
title:  "创建基于OData的Web API - Knowledge Builder API, Part IX, Angular程序环境准备"
date:   2020-07-14 21:16:22 +0800
tags: [Angular, Knowledge Builder, OData]
categories: [技术Tips]
---

基于前几篇的基础，尤其是[《用Postman测试》]({% post_url 2020-07-05-ODataBasedAPI7 %})，Knowledge Builder API已经可以使用了。

用[Angular](https://www.angular.io) 写一个简单的Web程序是一个很好的想法。本篇介绍Angular程序的环境准备。


本篇中使用Angular 10。



步骤一，搭建Angular环境，推荐使用Angular-CLI。

首先全局安装Anglar CLI。

```powershell
npm install -global @angular/cli
```

步骤二，然后在相应的文件夹下，使用Angular CLI来搭建。

```powershell
ng new knowledgebuilder
```

选择对应的Style的语言，譬如Less或SCSS。同时，选择支持Router。


步骤三，加入Material库。

```powershell
ng add @angular/material
```

步骤四，测试该Angular程序。

```powershell
ng serve -o
```

一些常见的问题，由于众所周知的长城问题，npm的安装通常不会很顺利。建议使用taobao的良心mirror。


在文件夹下创建.npmrc文件 （如果想在Windows系统影响该用户所有的npm，则可以将该文件放置在登陆user的文件夹下）。

```powershell
New-Item .npmrc
```

在该文件中设置：

```ini
sass_binary_site="https://npm.taobao.org/mirrors/node-sass/"
phantomjs_cdnurl="http://cnpmjs.org/downloads"
electron_mirror="https://npm.taobao.org/mirrors/electron/"
sqlite3_binary_host_mirror="https://foxgis.oss-cn-shanghai.aliyuncs.com/"
profiler_binary_host_mirror="https://npm.taobao.org/mirrors/node-inspector/"
chromedriver_cdnurl="https://cdn.npm.taobao.org/dist/chromedriver"
```


是为之记。   
Alva Chien    
2020.07.14 