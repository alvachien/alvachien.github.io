---
layout: post
title:  Typescript Tips
date:   2021-09-11 18:09:17 +0800
tags: [typescript]
categories: [技术Tips]
---

许久没碰的Angular程序，重新编译一遍，却遇到下列错误：

```log
-error TS7053: Element implicitly has an 'any' type because expression of type 'string' can't be used to index type '{ desp: string; validFrom: string; validTo: string; countOfFactLow: string; countOfFactHigh: string; 
timeStart: string; timeEnd: string; daysFrom: string; daysTo: string; point: string; edit: string; }'.
```

其中，出问题的代码如下：   
```typescript
  dataSchema = {
    // ruleType: AwardRuleTypeEnum = AwardRuleTypeEnum.GoToBedTime;
    // 'targetUser': 'text',
    'desp': 'text',
    'validFrom': 'date',
    'validTo': 'date',
    'countOfFactLow': 'number',
    'countOfFactHigh': 'number',
    // 'doneOfFact': 'boolean',
    'timeStart': 'number',
    'timeEnd': 'number',
    'daysFrom': 'number',
    'daysTo': 'number',
    'point': 'number',
    'edit': 'edit',
  };
```

然后在HTML中使用：   

```html
<div [ngSwitch]="dataSchema[col]" *ngIf="element.isEdit">
    <div class="btn-edit" *ngSwitchCase="'edit'">
    <button (click)="element.isEdit = !element.isEdit">Done</button>
    </div>
    <mat-form-field *ngSwitchCase="'date'" appearance="fill">
    <mat-label>Choose a date</mat-label>
    <input matInput [matDatepicker]="picker" [(ngModel)]="element[col]">
    <mat-datepicker-toggle matSuffix [for]="picker"></mat-datepicker-toggle>
    <mat-datepicker #picker></mat-datepicker>
    </mat-form-field>
    <mat-form-field *ngSwitchDefault>
    <mat-label>{{col}}</mat-label>
    <input [type]="dataSchema[col]" matInput [(ngModel)]="element[col]">
    </mat-form-field>
</div>
```



参考了Stackoverflow的一个问题：[Link](https://stackoverflow.com/questions/57438198/typescript-element-implicitly-has-an-any-type-because-expression-of-type-st)

将代码修改为：   

```javascript
  dataSchema: { [key: string]: any } = {
    // ruleType: AwardRuleTypeEnum = AwardRuleTypeEnum.GoToBedTime;
    // 'targetUser': 'text',
    'desp': 'text',
    'validFrom': 'date',
    'validTo': 'date',
    'countOfFactLow': 'number',
    'countOfFactHigh': 'number',
    // 'doneOfFact': 'boolean',
    'timeStart': 'number',
    'timeEnd': 'number',
    'daysFrom': 'number',
    'daysTo': 'number',
    'point': 'number',
    'edit': 'edit',
  };
```

搞定~

