---
layout: post
title: "Excel plus VBA Tip 3: Outlook中Recurrence Pattern的Exception"
date: 2013-12-20 18:35
author: alvachien
comments: true
categories: [Excel, Microsoft, Office, Outlook, VBA, Windows Platform, 技术Tips]
---
想起来写个Outlook的Macro是因为年纪渐渐大，记忆力越来越不够用，于是考虑用艾宾浩斯记忆曲线来加强一下自己的记忆。跟之前写过的那些“复杂”的Excel Macro相比较，Outlook的Macro更具有挑战性——可以有多个Excel的Instance，但只有一个Outlook的Instance。

作为开发工作的前期准备，必须找到Outlook Object Model。其中最重要的两个Object分别是AppointmentItem(包括了Appointment和Meeting)和TaskItem：

- AppointmentItem Members in MSDN (Version Office 2010)：http://msdn.microsoft.com/en-us/library/office/ff869026(v=office.14).aspx
- TaskItem Members in MSDN (Version Office 2010): http://msdn.microsoft.com/en-us/library/office/ff867891(v=office.14).aspx

其次，找到一些对应关系。Office界面的Text跟Member名称可能并不Match：
- Priority (UI) mapping  to Importance。（OlImportance Enumeration)
- Private, High Importance and Low Importance, mapping to Sensitivity (OlSensitivity Enumeration)

再次，对于Recurrence，则是通过RecurrencePattern支持：
- Method GetRecurrencePattern会返回AppointmentItem或TaskItem上的Recurrence Pattern，如果尚未定义，就会返回一个新的empty Recurrence以供编辑；RecurrencePattern Members in MSDN: http://msdn.microsoft.com/en-us/library/office/ff869260(v=office.14).aspx
- Method GetOccurrence返回指定日期的AppointmentItem.
- Prority RecurrenceType则由OlRecurrenceType Enumeration控制；
- Prority Exceptions http://msdn.microsoft.com/en-us/library/office/ff869544(v=office.14).aspx 控制了该Recurrence Pattern上的Exception列表。具体的Exception同样由Exception Object http://msdn.microsoft.com/en-us/library/office/ff862466(v=office.14).aspx 呈现。

最后，值得注意的是:

- RecurrencePattern 在TaskItem和AppointmentItem上是不同的--AppointmentItem有Series的概念，而TaskItem没有。换言之，TaskItem定义Recurrence Pattern会创建一堆独立的Task Item。这也是GetOccurrence只能返回AppointmentItem的原因。
- 创建RecurrencePattern的Exception时，必须保证新的不能在同一个自然日里面。

是为之记。
Alva Chien
2013.12.16 - 2013.12.20
