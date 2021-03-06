---
layout: post
title: 依旧恶心的iTunes，还是超烂的Safari
date: 2008-04-07 12:13
author: alvachien
comments: true
tags: [Apple, iTunes, Safari]
categories: [IT业内, 技术Tips]
---
自从白得了一个iPod Touch以后，俺不得不再次用上了Apple的iTunes，不过这次俺学了个乖，不再给Apple做免费测试，为了兼容iTunes，我不得不额外做了个镜像音乐路径来专供iTunes用。


既然用上了Apple的软件，那就意味着承受折磨，这个是我在启用iPod Touch之前就做好的心理预期。虽然我对它的UI设计（硬件和软件上）始终挑大拇指。然而，Apple的软件依旧毫不例外的打破我的心理承受底限。


首先，iTunes的安装依旧强奸犯似的给机器上装上QuickTime，没有任何快捷方式的选项，鉴于我前面一批文章已经批过这个问题，这里不再详细探讨。其次，启动了众多莫名奇妙的后台进程，启动一个iTunes要附带5~7个后台进程！而且现在的Apple变本加厉、自说自话地在系统中加入两个Services。再次，看看都是些什么进程以及什么Services吧：


![TaskManager_iTunes](/assets/uploads/2010/10/TaskManager_iTunes.gif)


其中：distnoted.exe, AppleMobileDeviceHelper.exe, iPodService.exe, iTunes.exe以及iTunesHelper.exe，这还不算上启动iTunes会启动的一个Software Update Check的进程。如果没有Disable掉Apple Mobile Device服务的话，会再启动一个AppleMobileDeviceService.exe。


两个Services：“Apple Mobile Device”以及“iPod服务”。
![Service_ITunes](/assets/uploads/2010/10/Service_ITunes.gif)


行文及此，我很想问问Apple的那些软件工程师，就一个破媒体播放软件而已，至于在系统这么多进程和Services吗？


当然，Apple肯定不屑于我的质疑，而我也深深的了解Apple的成功之处只在于它产品的UI设计以及它的行销功力，而绝非它的软件。


还得提一下Safari，Apple的广告是“最快的浏览器”，而国内的媒体更是跟它推波助澜的做了一些评测。所以当iTunes的Software Update中出现Safari时，我还是很不厚道下载下来试一下，尽管很反感这种强制牛头不对马嘴(iTunes是一个媒体播放器，Safari是浏览器)的软件推送方式。


本着随便试试的心态，我访问了两个网站：[www.microsoft.com](https://www.microsoft.com)和[news.sina.com.cn](https://news.sina.com.cn)。前者，Safari挣扎了15秒之后依旧无法显示，作为对比，清空Temporary Internet Files后的IE8 Beta1 打开这个网站用了1秒多；而访问后者则直接Crash掉了，连重试的机会都没给我。写这篇article的时候我才觉得可惜的是，当我用比安装Safari快10倍的速度卸载Safari时，竟然没想起来抓个图先。


至于Safari更加强暴的只能选择Google和Yahoo作为Search Engine之类的问题，俺就不在评论了。


于是，很瓜山的去跟一个很Fan Apple的同事聊这个，她回我：“Safari的界面很漂亮呀。我从来不上Sina的”。
