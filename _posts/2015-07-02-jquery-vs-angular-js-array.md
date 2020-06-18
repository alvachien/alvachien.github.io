---
layout: post
title: "jQuery vs Angular JS: 遍历数组"
date: 2015-07-02 22:51
author: alvachien
comments: true
tags: [Angular JS, foreach, jQuery, Web Development]
categories: [技术Tips]
---
jQuery中遍历数组，通常的方法是$.each; 语法：

```javascript
$(selector).each(function(index,element))
```

```javascript
$.each(arData, function(idx, obj) {
// ....
// process on obj...
});
```

如果要中断遍历，即类似for循环中的break，可以在function中使用：

```javascript
return false;
```

Angular JS中，通常的方法是Angular.forEach。实例代码：

```javascript
if (angular.isArray(arData)) {
    angular.forEach(arData, function(obj){
    // process on obj...
    });
}
```

可惜的是，该方法无法中断遍历。



是为之记。

Alva Chien

2015.7.2
