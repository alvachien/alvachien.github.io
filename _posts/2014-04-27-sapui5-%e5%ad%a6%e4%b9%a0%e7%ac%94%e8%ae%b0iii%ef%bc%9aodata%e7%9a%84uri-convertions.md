---
layout: post
title: SAPUI5 学习笔记III：oData的URI Convertions
date: 2014-04-27 21:45
author: alvachien
comments: true
categories: [Microsoft, oData, SAP, SAP, SAPUI5]
---
虽然SAPUI5支持N种Model，但在SAP的产品开发中，最常见的是oData。关于oData(Open Data Protocol)，是Microsoft发布的一种旨在标准化网页程序数据交换标准化的开源协议，oData被.Net框架中的WCF原生支持。具体可以参考：http://www.odata.org/。

撇开oData那些纷繁冗杂的术语和架构，对SAPUI5来说，最直接的问题就是，作为一个oData Service的Consumer，只能使用oData Service？

要回答这个问题，首先得明白一点，oData是基于AtomPub和REST的，其中Atom用来数据封装格式，而对oData的访问都是基于REST所定义的五种HTTP Method，即GET, POST， PUT, DELETE和PATCH。

而基础的oData使用则主要集中在URI上，以下是常用的几个URI Convertions (http://www.odata.org/documentation/odata-version-2-0/uri-conventions/)
<ol>
	<li>$count: 只返回数目；</li>
	<li>$inlinecount: （Acceptable values: allpages和none）除了返回指定的entity之外附带返回数量，因为entity可能通过$top等进行了过滤。如：<a style="color: #dd4814;" href="http://services.odata.org/OData/OData.svc/Products?$inlinecount=allpages&amp;$top=10&amp;$filter=Price%20gt%20200">http://services.odata.org/OData/OData.svc/Products?$inlinecount=allpages&amp;$top=10&amp;$filter=Price gt 200</a>  返回前十个价格大于200的Product并返回所有价格超过200的Product数量.</li>
	<li>$top和$skip：分页的模拟，如<a style="color: #dd4814;" href="http://services.odata.org/OData/OData.svc/Products?$skip=2&amp;$top=2&amp;$orderby=Rating">http://services.odata.org/OData/OData.svc/Products?$skip=2&amp;$top=2</a> 返回第三个和第四个Product——即skip掉前面两个再取2个。</li>
	<li>$format：返回格式，常用的是Atom+XML和JSON。</li>
	<li>$orderby: 指定排序的property。</li>
	<li>$filter: 用来做过滤——即搜索。</li>
	<li>$expand: 将有association关系的entity一同取出。注意，这种方式可能会性能有较大影响。</li>
</ol>
是为之记。
Alva Chien
2014.4.26
