---
layout: post
title: "[WPF] TreeViewItem, DataGridRow的UI因Field而异的解决方法"
date: 2010-10-14 23:42
author: alvachien
comments: true
tags: [Microsoft.NET, Windows Platform, WPF]
categories: [技术Tips]
---
这个一个很拗口的标题，其实，我需要的是一个很简单的功能。为了把这个需求解释清楚，用一个小的案例说明：

用DataGrid绑定Customers表，按照常识，Customer会有不同的Priority，那么UI需要因Priority不同而表现各异。比如High的Customer,应该是粗体，而Low的Customer，颜色就是Gray。

问题来了，WPF提供了完善的Style, Setter来控制UI控件的Property，但，因为UI控件Binding到具体的Object，而Priority是Object的属性，而不是UI控件的Field，所以下面这段常用的Style无效(这段Code用来控制加粗选中的TreeViewItem)。

```XML
<TreeView.ItemContainerStyle>
        <Style TargetType="{x:Type TreeViewItem}">
                <Setter Property="IsExpanded" Value="{Binding IsExpanded, Mode=TwoWay}">
                <Setter Property="IsSelected" Value="{Binding IsSelected, Mode=TwoWay}" >
                <Setter Property="FontWeight" Value="Normal" >
                <Style.Triggers>
                        <Trigger Property="IsSelected" Value="True">
                                <Setter Property="FontWeight" Value="Bold">
                        </Trigger>
                </Style.Triggers>
        </Style>
</TreeView.ItemContainerStyle>
```


在MSDN Forum上溜达了一圈，因为对这个问题的描述很难，所以没有找到有效的Post。无奈，只得仔细看DataGridRow和TreeViewItem的文档，没想到，“踏破铁鞋无觅处得来全不费工夫”:

TreeViewItem定义了Properties: ItemContainerStyle, ItemContainerStyleSelector；
DataGrid定义了Properties: RowStyle, RowStyleSelector;
DataGridRow定义了RowDetailTemplate, RowDetailTemplateSelector;

由此衍生去StyleSelector和DataTemplateSelector两个Class。至于怎么从这两个类去派生，怎么写对应的XAML，不值一哂，更何况MSDN还有个强大的搜索框。

是为之记。
Alva Chien
2010.10.14
