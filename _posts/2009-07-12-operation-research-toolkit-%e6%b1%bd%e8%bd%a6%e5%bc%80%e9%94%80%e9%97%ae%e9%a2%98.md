---
layout: post
title: "Operation Research Toolkit: 汽车开销问题"
date: 2009-07-12 15:39
author: alvachien
comments: true
categories: [Windows Platform, 技术Tips, 随心随笔]
---
一直想写个Toolkit来应用Operation Research中那些不错的方法。迫于LD要求，首先付之行动的便是汽车开销问题。本以为，写个算法应该不太难，真正动手的时候才发现：写个可以重用的算法就非常难，尤其是基于图这个结构。

在Codeproject, Codeguru上找了一圈，始终没有自己满意的图的C#实现，只能自己操刀写一个，竟然耗费了偶整整一个礼拜的业余时间，才写出来一个全Template实现的图（基于C#）。敬请各位大师斧正：<a href="http://blog.csdn.net/alvachien/archive/2009/07/12/4342356.aspx">http://blog.csdn.net/alvachien/archive/2009/07/12/4342356.aspx</a>。 写完了才发现，居然用了模板的模板，GOD！

<a href="http://www.alvachien.com/alvablog/wp-content/uploads/2010/10/OTR_1.jpg"><img class="alignnone size-full wp-image-534" title="OTR_1" src="http://www.alvachien.com/alvablog/wp-content/uploads/2010/10/OTR_1.jpg" alt="" width="578" height="559" /></a>

Note: 偶只贴了Dijkstra算法，这个算法要求权重大于0，这个也基于汽车开销必然大于0的现实。汽车开销小于0的大师请绕行！

是为之记。
Alva Chien
2009.7.12
