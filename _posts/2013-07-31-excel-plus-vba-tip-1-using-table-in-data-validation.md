---
layout: post
title: "Excel plus VBA Tip 1: Using Table in Data Validation"
date: 2013-07-31 12:54
author: alvachien
comments: true
categories: [Excel, Microsoft, Office, VBA, Windows Platform]
---
在Excel定义Table或是使用Table Style (Styles Group中的Format as Table按钮)时，Excel会自动为该Table命名，从Table1， Table2开始。在Name Manager会看到对应的Table。一切看起来很完美，不是么？但注意，Table Name没有对应的Refer To，这点区别于自定义的Name，同时，在选择Table时，只有不包括Header的内容才算Table。除此之外，还有两个大问题：

- 虽然该Table Name显示在Name Manager Dialog中，VBA代码却无法直接用Name的方式读取，即ActiveWorkbook的Names找不到对应的名字。这个问题限于时间原因，来不及研究根本原因，但我怀疑应该跟Conver To Range休戚相关。Conver To Range在选择Table的Context Menu\Table子菜单中。- 在Data Validation框中，Source输入框中也无法直接使用Table Name+Column的语法，如Table1[Header1]，尽管Excel本身已经解析出来对应的Range。解决这个问题我想到的办法是，**重新Define Name，并定义其Refer To指定Table Name（或加Header名称）**。在Data Validation中使用新的Name就可以了。通过搜索引擎找到另外一个办法是使用INDIRECT函数，即Source输入框中使用 **INDIRECT("Table1[Header1]")**

Microsoft官方Office 2010关于Table Name的说明页：&lt;Using structured references with Excel tables&gt;, Link: <a href="http://office.microsoft.com/en-us/excel-help/using-structured-references-with-excel-tables-HA010342999.aspx?CTT=1">http://office.microsoft.com/en-us/excel-help/using-structured-references-with-excel-tables-HA010342999.aspx?CTT=1</a>

是为之记。
Alva Chien
2013.7.31

&nbsp;
