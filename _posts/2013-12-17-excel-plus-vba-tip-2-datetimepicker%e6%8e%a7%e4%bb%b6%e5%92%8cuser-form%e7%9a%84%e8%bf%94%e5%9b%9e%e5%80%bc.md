---
layout: post
title: "Excel plus VBA Tip 2: DateTimePicker控件和User Form的返回值"
date: 2013-12-17 19:57
author: alvachien
comments: true
categories: [Office, VBA, Windows Platform, 技术Tips]
---
虽然一直想得很美好，把技术相关的Blog放到CSDN上（<a title="Write Ideas Down, Together With Skills" href="http://blog.csdn.net/alvachien" target="_blank">Write Ideas Down，Together With Skills</a>），把随笔等文章放在个人网站上。然而，事实总是很残酷，总有些想法在一边起了个头，却在另外一边掺了一腿。这里说的是，我先是写了一篇<a title="Excel plus VBA Tip 1: Using Table in Data Validation" href="http://www.alvachien.com/alvablog/?p=1416" target="_blank">Excel plus VBA Tip 1: Using Table in Data Validation</a>，又写了一篇<a title="[Office] VBA Practice" href="http://blog.csdn.net/alvachien/article/details/17267197" target="_blank">[Office] VBA Practice</a>，然后，当我想写第三篇的时候，我凌乱了，伴随着我这些天感冒的涕零。

所以，这篇纯粹是CSDN上那篇文字的翻版，以为统一。
### 使用DateTimePicker控件

VBA中默认的User Form的Toolbox中的控件并不包含DateTimePicker，是接受时间相关数据的输入，在Toolbox上右击“Additional Controls”，在弹出的对话框中选择“Microsoft Date and Time Picker Control 6.0”

<img alt="" src="http://g.hiphotos.bdimg.com/album/s%3D550%3Bq%3D90%3Bc%3Dxiangce%2C100%2C100/sign=5ed5d69fbe3eb13540c7b7be9625d9ee/18d8bc3eb13533fa5c546959aad3fd1f40345be3.jpg?referer=0cc4c1b319d5ad6ef3ee50daa5a1&amp;x=.jpg" />

### User Form的返回值
默认情况下，User Form并没有返回值（有意思的是，MsgBox倒是有返回值），那如何判断弹出的对话框是被点击了OK按钮还是Cancel按钮呢？

一个简单的方法是，

(1) 在User Form的Module中定义全局变量
```vb
Public ClickedByOK As Boolean
```

(2) 在对应的按钮响应方法中设置该变量

```vb
Private Sub btnCancel_Click()

    ClickedByOK = False

    Me.Hide

End Sub

Private Sub btnOK_Click()

    ClickedByOK = True

    Me.Hide

End Sub
```

(3) 在窗口结束后判断该变量的值
```vb
<Dim dlg As New dlgRememberItem

dlg.Show

If dlg.ClickedByOK = False Then

    Exit Sub

End If
```

### 处理时间相关数据
因为VBA只提供了一个简单的Date 数据类型，这无疑给时间相关数据的处理带来了复杂度；

一个非常好的VBA中处理时间数据的资源： <a title="http://dmcritchie.mvps.org/excel/datetime.htm" href="http://dmcritchie.mvps.org/excel/datetime.htm" target="_blank">http://dmcritchie.mvps.org/excel/datetime.htm</a>

是为之记。
Alva Chien
2013.12.11于CSDN
2013.12.17
