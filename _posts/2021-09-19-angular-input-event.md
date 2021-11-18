---
layout: post
title:  Angular中Input输入值修改的监听
date:   2021-09-19 09:09:17 +0800
tags: [Angular,typescript]
categories: [技术Tips]
---

HTML中Input的值发生变化，应用程序需要对其作出响应。当然有些值修改可以在整张表单提交时才作出响应，但大部分的应用需要当场作出响应，譬如：   

- 输入值发生变化时，立刻对其最有效性校验；
- 某些表示实时预览效果的输入值。表示字体大小、字体颜色的输入框，值发生变化时候，需要及时呈现预览效果；

有以下几种办法在Angular中实现对值修改的监听：   
1. 通过Form以及field层面valueChanges；
2. 通过(ngModelChange)回调函数；

```typescript
this.form.valueChangs.subscribe({
    value => {
        // Value contains all values of the whole form
    },
    error => {
        // Error occurs
    }
})
```

```typescript
this.form.get('formName').valueChanges.subscribe({
    value => {
        // Value contains only the value from 'formName'
    },
    error => {
        // Error occurs
    }
})
```

```html
<input type="number" [ngModel]="value1" (ngModelChange)="onValueChange($event)">
```

```typescript
onValueChange(event) {
    // Value changes
}
```

