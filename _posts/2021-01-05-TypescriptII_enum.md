---
layout: post
title:  Typescript II Enums
date:   2021-01-05 14:09:17 +0800
tags: [rxjs, typescript]
categories: [技术Tips]
---

根据enum的官方文档，[link](https://www.typescriptlang.org/docs/handbook/enums.html#numeric-enums), Typescript的enum分为numeric enum和string enum两类。

## Numeric enum

一般来说，numeric enum最为常见，这也是Typescript率先支持的类型。

```typescript
enum Enum1{
    case1,
    case2
}
```

生成的Javascript代码如下：   
```javascript
var Enum1;
(function (Enum1) {
    Enum1[Enum1["case1"] = 0] = "case1";
    Enum1[Enum1["case2"] = 1] = "case2";
})(Enum1 || (Enum1 = {}));
```

从生成的Javascript看，Enum就是就是一个普通的Javascript object，将enum中定义的名称和值（这里是数值）都定义为property了，并将值和名称相互赋值。


```javascript
Enum1["case1"] // 0
Enum1["case2"] // 1
Enum1[0] // 'case1'
Enum1[1] // 'case2'
```

至于手动对enum的项赋值而不是编译时自动赋值，并不影响其编译效果和运行结果。


有了这个基础，对于最常见的enum从数值转字符串或者从字符串转数值的问题就迎刃而解了。


## string enum

跟numeric enum类似，先看看string enum的定义以及其生成的javascript

```typescript
export enum ExerciseItemType {
    Question = 'Question',
    SingleChoice = 'Single Choice',
    MultipleChoice = 'Multiple Choices',
    ShortAnswer = 'Short Answer',
    EssayQuestions = 'Essay Questions',
}
```

```javascript
var ExerciseItemType;
(function (ExerciseItemType) {
    ExerciseItemType["Question"] = "Question";
    ExerciseItemType["SingleChoice"] = "Single Choice";
    ExerciseItemType["MultipleChoice"] = "Multiple Choices";
    ExerciseItemType["ShortAnswer"] = "Short Answer";
    ExerciseItemType["EssayQuestions"] = "Essay Questions";
})(ExerciseItemType || (ExerciseItemType = {}));
```

跟numeric的双向property定义不同，这里的定义只有单向的。

