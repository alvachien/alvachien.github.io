---
layout: post
title: Andriod？Andriod!
date: 2010-05-09 21:06
author: alvachien
comments: true
tags: [Andriod, HTC, Symbian]
categories: [IT业内, 技术Tips]
---
终于逃离了Symbian，终于丢掉了Nokia，在偶的E71华丽地以自由落体的方式亲吻了地板之后。当然，Nokia的做工是让人折服的，这样的蹂躏之下，依然只是外伤，内部完好无损。

无论如何，偶抓住了这个机会，向LD报批了预算，兴冲冲的去了不夜城，又。用E71换来一叠钞票之后，偶又加上更厚的一叠抱回了这台HTC Desire。为啥不是Nexus One？一来它太贵，二来，HTC Sync可以完美Synchronize Outlook，而Nexus One却不行。整天用Outlook的人，不用Outlook来zhuangbility怎么行？摩托的Milestone也很不错，可惜是全键盘，E71的全键盘经历告诉偶，全键盘通常需要更高的Zhuangbility才能掌控，偶的火候还不到。

事实证明，入门一个新系统需要付出代价，Andriod也不例外。

首先，HTC的ROM不能跨区域刷，除非是Gold Card。这个Gold Card是依赖于MicroSD卡的CID。面对两份迥异的网络教程，偶付出的代价是：偶破坏了Windows 7隐藏分区的引导扇区（并成功的与Windows系统盘互换盘符！！！）！原因是HTC Sync在Sync模式下会自动Close Connection，而直接写Hex Value到Disk Image是非常恐怖的，尤其是选错了Disk的话！

修复Windows 7是个很累的过程，因为没有启动盘。首先，偶用Vista的安装光盘启动安装系统，以核实Windows 7其它分区一切正常。然后，着手做USB启动盘。
尝试一：Format格式为FAT32，复制Windows 7安装文件，USB Boot失败；
尝试二：手头没有Windows 7的ISO，只能下载了一个PE Loader版本的ISO。又下载了UltraISO，修改U盘的写入方式为USB-ZIP+。USB Boot成功，启动PE后，找不到路径修复，但用Disk Genius修复盘符成功，删除隐藏的系统分区成功。
尝试三：用Windows 7的所有安装文件覆盖U盘文件，保持U盘写入方式。USB Boot成功，直接进入Windows 7 Repair模式，Windows 7自动识别问题，成功恢复。

继续更新ROM，这次成功选对Device进行字节修改，启动RUU更新程序，错误：CID校验失败。不得不重头开始搞Goldcard.img，再次写入Device，心惊胆战的启动RUU，噼里啪啦的几度重新启动后，ROM更新成功。。。

终于，坐下来，开始享受崭新的Andriod旅程，root权限，XDA论坛，嚯嚯。。。

是为之记。
Alva Chien
2010.05.09
