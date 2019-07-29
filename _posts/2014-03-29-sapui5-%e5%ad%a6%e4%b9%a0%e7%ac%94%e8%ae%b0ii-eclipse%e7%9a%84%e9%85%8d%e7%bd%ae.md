---
layout: post
title: "SAPUI5 学习笔记II: Eclipse的配置"
date: 2014-03-29 14:25
author: alvachien
comments: true
categories: [Eclipse, SAP, SAP, SAPUI5, TomCat, Web Development]
---
罗列一下自己碰到的Eclipse配置，以为后续：

1. Line Number
默认情况下，Eclipse的JavaScript Editor不显示Line Number。只需要在Editor前端右键——选择Show Line Numbers即可：

[caption id="" align="alignnone" width="364"]<img alt="右键菜单" src="http://c.hiphotos.bdimg.com/album/s%3D550%3Bq%3D90%3Bc%3Dxiangce%2C100%2C100/sign=06a1dececebf6c81f3372ced8c05c008/d058ccbf6c81800a83fbb3a8b33533fa828b477d.jpg?referer=4e1c8802a6c27d1efc310ef4a113&amp;x=.jpg" width="364" height="294" /> 右键菜单[/caption]

2. Web Browser
默认情况下，Eclipse使用Internal Web Browser。这对Web程序的调试其实没啥好处。所以，通常，需要切换到external的Web Browser。在Preference的Popup中：

[caption id="" align="alignnone" width="550"]<img alt="Web Browser" src="http://f.hiphotos.bdimg.com/album/s%3D550%3Bq%3D90%3Bc%3Dxiangce%2C100%2C100/sign=6b73196192529822013339c6e7f10af6/08f790529822720e21a3c75c79cb0a46f21fab22.jpg?referer=d6a2a2879113b07ee4aa643815e0&amp;x=.jpg" width="550" height="508" /> Web Browser[/caption]

3. TomCat Server
对Java EE版本的Eclipse来说，Server页面已经提供了TomCat的支持，只需要安装TomCat，并创建本地server即可。对Eclipse Standard版本来说，需要一部额外的操作：安装Eclipse Tomcat plugin!
(3.1) 安装Eclipse Tomcat Plugin
URL: http://www.eclipsetotale.com/tomcatPlugin.html
注意，在支持UAC的Windows 版本上，还需要额外留意——尤其当Eclipse被安装的Program Files文件夹的时候。该Plugin安装不会报错但实际已经错误了。参考: http://eclipse.dzone.com/articles/eclipse-plugin-installation
(3.2) 安装TomCat
URL：http://tomcat.apache.org/
在这里可以找到TomCat的最新版本，然后，安装之。

<span style="line-height: 1.5;">是为之记。
</span>Alva Chien
2014.3.29
