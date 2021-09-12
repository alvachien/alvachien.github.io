---
layout: post
title:  CSS Tips - 使得控件居中
date:   2021-09-12 23:09:17 +0800
tags: [javascript,css]
categories: [技术Tips]
---

HTML页面中，将子控件居中显示是一个常见的需求。

方法一，对文字、图片、按钮等进行**水平居中**

```css
text-align: center;
```

方法二，对任意控件设置为水平居中

```css
.parent {
    overflow: hidden;
    // Following setting just for testing
    width: 500px;
    height: 200px;
    background-color: #f98769;
}
.child {
    margin: 50px auto;
    // Following setting just for testing
    width: 100px;
    height: 100px;
    background-color: #ff0000;
}
```

方法三，对文字进行“垂直居中”

```css
line-height: height;
```

方法四，使用表格来设置水平居中和垂直居中

设置td和th的属性：

```css
td th {
    align: center;
    valign: middle;
}
```

方法五，弹性布局下的水平居中和垂直居中

```css
.parent {
    display: flex;
    justify-content: center;
    align-items: center;
}
.child {
    display: flex;
    flex-direction: column;
    justify-content: center;
}
```

方法六，使用table-cell来设置水平居中和垂直居中

```css
.parent {
    display: table-cell;
    vertical-align: middle;
    text-align: center;
}
.child {
    display: inline-block;
}
```

方法七，通过设置子控件的位置来设置水平居中和垂直居中

```css
.parent {
    position: relative;
}
.child {
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
}
```

方法八，通过:before来设置垂直居中

```css
.parent {
    position: relative;
}
.parent :before {
    display: inline-block;
    height: 100%;
    width: 1%;
    vertical-align: middle;
}
.child {
    display: inline-block;
    vertical-align: middle;
}
```


