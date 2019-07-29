---
layout: post
title: "jQuery vs Angular JS: 遍历数组"
date: 2015-07-02 22:51
author: alvachien
comments: true
categories: [Angular JS, foreach, jQuery, Web Development, 技术Tips]
---
jQuery中遍历数组，通常的方法是$.each; 语法：
<code>$(selector).each(function(index,element))</code>
<code>$.each(arData, function(idx, obj) {
// ....
// process on obj...
});</code>
如果要中断遍历，即类似for循环中的break，可以在function中使用：
<code>return false;</code>

Angular JS中，通常的方法是Angular.forEach。实例代码：
<code>if (angular.isArray(arData)) {
angular.forEach(arData, function(obj){
// process on obj...
});
}</code>
可惜的是，该方法无法中断遍历。

是为之记。
Alva Chien
2015.7.2
