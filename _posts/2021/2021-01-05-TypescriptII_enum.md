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


~~有了这个基础，对于最常见的enum从数值转字符串或者从字符串转数值的问题就迎刃而解了。~~

然而，即便有了上述基础，对字符串直接转换enum还是碰到问题(以下示例代码源自Stackoverflow，[原始链接](https://stackoverflow.com/questions/17380845/how-do-i-convert-a-string-to-enum-in-typescript))：

```typescript
let typedEnum1: Enum1 = Enum1.case1;
let typedEnum1String: keyof typeof Enum1 = "case1";

// Error "case3 is not assignable ..." (indexing using Color["case3"] will return undefined runtime)
typedEnum1String = "case3";

// Error "Type 'string' is not assignable ..." (indexing works runtime)
let letEnum1String = "case3";
typedEnum1String = letEnum1String;

// Works fine
typedEnum1String = "case2";

// Works fine
const constEnum1String = "case2";
typedEnum1String = constEnum1String

// Works fine
letEnum1String = "case2";
typedEnum1String = letEnum1String as keyof typeof Enum1;

typedEnum1 = Color[typedEnum1String];
```

所以，有一个string，转化为对应的enum：

```typescript
    if (isNaN(+enumString)) {
        enumValue = Enum1[enumString as keyof typeof Enum1];
    } else {
        enumValue = Enum1[+enumString];
    }
```


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

