---
layout: post
title: 当Flickr又无法访问时
date: 2014-08-03 20:43
author: alvachien
comments: true
tags: [Flickr, Windows Platform]
categories: [技术Tips, 红圈白炮]
---
最近好懒。懒得拍照，懒得Photoshop处理照片，懒得上传照片到Flickr，懒得备份照片到Baidu，所以，当发现Flickr又无法登陆时，才又愣了一下：感情又到了Flickr无法访问的时候了。

当Flickr无法访问，通常都是，呃，绝大多数情况都是，被和谐了，具体原因么，就不追究了，这里只谈解决方法。

首先，ping一下当前www.flickr.com，看看你得到的IP地址是啥，然后，Google一下。。。呃，算了，还是Baidu一下靠谱一点。写这篇文章的时候，flickr的IP是69.147.76.173。如果ping的结果不是这个IP或者baidu出来的那个地址，那么，极有可能是DNS被污染了。然后，问题就变得很简单：在hosts中加入IP解析即可。

当拿到了flickr官网的IP地址，那么，应该能够登陆flickr了，除了，照片毫无例外依旧是红通通的叉叉。但是不要紧，访问下述地址：https://www.flickr.com/help/test
可以拿到flickr几大服务器的地址，然后，依样画葫芦地收入hosts中即可。

值得提醒一下的是，host中需要填写www.flickr.com而不是flickr.com。

hosts文件地址(Windows)：C:\WINDOWS\system32\drivers\etc

是为之记。
Alva Chien
2014.8.3
