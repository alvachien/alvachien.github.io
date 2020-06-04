---
layout: post
title: "SAPUI5 学习笔记I: 自己搭建SAPUI5的开发环境"
date: 2014-03-29 12:03
author: alvachien
comments: true
categories: [Eclipse, HTML5, SAP, SAP, SAPUI5, Visual Studio]
---
我司是一个严格控制访问权限的公司：内部Server不通过VPN很难访问，就连Exchange Server权限管理都比Microsoft等严格得多：即便Activate Sync开放出来，即便BYOD (Bring Your Own Device)，也不允许unathorized的device进行直连——仅允许Apple和Samsung的Device才可以。

闲言少叙，回归SAPUI 5学习的正题。工欲善其事，必先利其器。要学习SAPUI5，没有对应的IDE无疑是痴人说梦。Visual Studio Express无疑是我个人理想的选择，毕竟这个IDE用了这么多年了。然而我司却选择了Eclipse，好吧，那就转用Eclipse算了。

**Step 1**. 安装Eclipse
http://www.eclipse.org/downloads/
Eclipse的版本也挺搞的。Eclipse 3.7称为Indigo；Eclipse 4.2称为Juno；Eclipse 4.3称为Kelper。
这里需要额外强调的是，需要安装Eclipse for Java EE，否则后续的的安装会复杂一些。

**Step 2**. 安装SAPUI5的plugin
https://tools.hana.ondemand.com/#sapui5
最重要的信息是，使用 [Eclipse Kepler (4.3)](https://tools.hana.ondemand.com/kepler) [Eclipse Juno (4.2)](https://tools.hana.ondemand.com/juno) 来安装该Plugin;

**Step 3**. 官方的SDK文档： https://sapui5.hana.ondemand.com/sdk
SCN对应的论坛： http://scn.sap.com/community/developer-center/front-end

**Step 4**. 安装TomCat
http://tomcat.apache.org/download-70.cgi
跟Visual Studio Express只带了IIS Express不同，为了能本地测试，Apache Tomcat是必须的。

由此四步，可以用该开发环境来创建无需连接SAP Backend系统的UI5程序。作为UI层面的测试环境还是很成熟的——毕竟准备点mocked的JSON数据还是很方便的。

是为之记。
Alva Chien
2014.3.29
