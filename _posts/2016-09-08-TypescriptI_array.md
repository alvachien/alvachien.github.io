---
layout: post
title:  Typescript I 遍历Array的方法
date:   2016-09-08 22:09:17 +0800
tags: [rxjs, typescript]
categories: [技术Tips]
---

Typescript的官方文档 Iterators and Geneators [Link](https://www.typescriptlang.org/docs/handbook/iterators-and-generators.html)


## 方法一、for..of

这个貌似是最常用的方法，angular 2中HTML语法绑定也是要的这种语法。

```typescript
let someArray = [1, "string", false];

for (let entry of someArray) {
    console.log(entry); // 1, "string", false
}
```


## 方法二、for循环

for循环其实是标准的C风格语法。

```typescript
let someArray = [1, "string", false];

for (var i = 0; i < someArray.length; i ++) {
    console.log(someArray[i]); // 1, "string", false
}
```

## 方法三、for..in

官方文档上强调了for…in和for…of的区别：

```typescript
let list = [4, 5, 6];

for (let i in list) {
   console.log(i); // "0", "1", "2",
}

for (let i of list) {
   console.log(i); // "4", "5", "6"
}
```

## 方法四、forEach

forEach其实是JavaScript的循环语法，TypeScript作为JavaScript的语法超集，当然默认也是支持的。

```typescript
let list = [4, 5, 6];
list.forEach((val, idx, array) => {
    // val: 当前值
    // idx：当前index
    // array: Array
});
```

## 方法五、every和some

every和some也都是JavaScript的循环语法，TypeScript作为JavaScript的语法超集，当然默认也是支持的。因为forEach在iteration中是无法返回的，所以可以使用every和some来取代forEach。

```typescript
let list = [4, 5, 6];
list.every((val, idx, array) => {
    // val: 当前值
    // idx：当前index
    // array: Array
    return true; // Continues
    // Return false will quit the iteration
});
```

是为之记。   
Alva Chien   
2016.9.8
