---
layout: post
title: MacBook Air安装Windows 8虚拟机实录
date: 2013-11-18 14:44
author: alvachien
comments: true
categories: [Google, MacBook Air, Microsoft, Windows 8, 技术Tips, 虚拟机]
---
打算给MacBook Air安装Windows 8的虚拟机的需求来自MacBook Air的主人坚持使用着她的Thinkpad T400。尤其在双十一来临之际，MacBook Air的主人更是抱着T400寸步不离。询问为啥不能给MacBook Air一个春天，得到的答复是，“太麻烦了，Word程序中很多常用的功能还需要花时间找”，顿了一下，又道，“还有，淘宝的插件虽然安装了，总是有问题。另外，网上银行根本不支持Mac。”花了点时间查了查，广受赞誉的招商银行专业版确实不支持Mac系统，更别提各种证券交易软件了。

想在MBA上装个虚拟机，是源于一个同事的启发和双十一的冲击。受同事的启发，是基于他的成功安装Windows虚拟机的案例。否则，以我对于Mac的理解，肯定又是Boot Camp地干活。去年的这个时候，刚刚在别人的MBA装过双系统。受双十一的冲击，是Microsoft天猫官方旗舰店当天放出了Windows 8正版特价的信息。而之所以双十一当天跑到逛微软的天猫店，则因为一个星期前，我的Microsoft Wireless Mouse 5000的胶条断裂了，所以打算趁着双十一特价的时候看看能否买到同款的鼠标，结果鼠标没买到，到了买了特价的正版操作系统。

<strong>遇到的第一个问题是，用哪款虚拟机</strong>。Parallels Desktop和VMWare Fusion是Mac平台上比较常用的两种虚拟机，决定跟着同事的成功案例走——使用Parallels Desktop。于是安装Parallels Desktop 9，居然直接支持USB安装虚拟操作系统。于是找来专门准备的Windows 8 USB安装盘，看着Windows 8特有的四格蓝色徽标浮现在窗口中央，也看着这个画面定格在收集信息阶段，一条错误信息显示在Windows安装界面，依稀能分辨“没有可用的”，后面的字体无论如何看不清了。于是Google "Windows 8.1 没有可用的"，没有收获；再去Google “Parallels Windows 8 Installation Fail”，已经没有收获。最要命的是，Parallels Desktop居然没有机会让窗口全屏——起码在安装阶段没有。于是，果断切换VMWare Fusion。

VMWare Fusion自身的安装也顺利，然后，就遇到了<strong>第二个问题，VMWare Fusion 5不支持USB安装Windows，再者，MBA没有光驱</strong>。只剩下最后华山一条路了，找个ISO来启动安装。于是跑到Microsoft官网上下载了Windows 8，再制作成ISO (Windows安装工具自动支持该功能)。然后在启动Fusion 5，Load ISO，安装开始，然后戛然而止。

这次，<strong>遇到的问题与Parallels Desktop遇到的一样，不过Fusion 5全屏的方式，让我可以在MBA 11寸屏幕上看清楚那条错误信息“没有可用的映像”</strong>。然后，万能的搜索引擎出马，在Microsoft的官方论坛找到了根源（<a href="http://social.technet.microsoft.com/Forums/en-US/6a73eca4-904f-4089-815a-40cd6c2ab354/windows-server-2012vm?forum=winserver8zhcn">http://social.technet.microsoft.com/Forums/en-US/6a73eca4-904f-4089-815a-40cd6c2ab354/windows-server-2012vm?forum=winserver8zhcn</a>）：虚拟机的BIOS设置问题，需要将BIOS中软盘disable掉，同时调整booting device。接着，我就遇到<strong>另外一个问题——怎么按下F2</strong>？

MacBook Air上，F2作为系统快捷键分配给了亮度调节，于是每次Fusion 5重新启动，按下F2都是调节屏幕亮度。这个发现一度让我很崩溃——为啥Thinkpad之流都需要Fn加指定键才能作为快捷键，而到了Mac系统就都反了呢？抱着死马当做活马医的精神，按着Fn+F2，居然真的进了BIOS设置页面。果然，设置完对应的项后，Windows安装程序终于不在卡在找不到映像的问题上了，因为它卡在密钥上了。当我喜滋滋地输入那300CNY买来的密钥时，一个弹出窗口在磨蹭了5秒左右之后，华丽丽弹了出来“输入的产品密钥与用于安装的任何可用Windows映像都不匹配”。于是，我的<strong>下一个问题是，密钥出了什么问题？</strong>

这回懒得再去麻烦强大的搜索引擎，直接去了买密钥的订单，打开商品页面，一行一直都在却仿似第一次被我留意的文字让我连骂人的力气都没有了——“本产品为升级安装包，仅限从Windows XP/Windows Vista/Windows 7升级为Windows 8，完成后可以再免费升级至Windows 8.1”。所以说，密钥没有问题，问题在于，我<strong>去哪里弄一个Windows XP/Vista/7的安装ISO映像？</strong>

这个问题对我这个安装操作系统多达数十次的IT从业男来说，有点小儿科了。于是，第一反应，找个UltraISO制作一张“可引导光盘”，手头上有张现成的、正版的Windows Vista随机安装盘。UltraISO制作可引导光盘时，弹出一个选择引导文件界面，选择了Vista安装光盘中的boot文件夹，然后复制黏贴了光盘中所有文件——因为该光盘历史悠久，可怜我的光驱吱吱呀呀了很长一段时间才完成任务。当我兴冲冲地拿着该ISO开始重新安装时，随着"Windows Loading Files..."，VMWare Fusion直接扔给我一个虚拟机遇到错误，需要关闭的信息。如同被针刺了一下似的，我一下子反应过来——引导文件错了。<strong>那，可引导光盘要怎么做才对？</strong>

再次打开UltraISO，直接从光盘提取引导文件，并简直assign到新的引导光盘上。同时，不再复制光盘文件，而是直接复制整张光盘。光驱再次发出一连串的惨叫声之后，整个ISO制作完成。回到Fusion 5，继续安装，这次，终于一切顺利的安装完成。然后，准备升级Windows 8。找出原先下载的Windows 8 ISO，再看看空白的Vista系统，只能摇摇头，叹口气，继续从微软官网下载安装包。好在这次一切顺利，密钥验证通过，Windows 8激活成功。接着升级Windows 8.1，然后，华丽丽的“升级8.1失败，系统回滚到原来的版本”。那为啥升级8.1失败呢？

于是，我带着这个新的问题，睡觉去了。

是为之记。
Alva Chien
2013.11.17-2013.11.18
