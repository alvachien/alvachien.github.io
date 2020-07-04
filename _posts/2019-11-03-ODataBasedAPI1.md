---
layout: post
title:  "创建基于OData的Web API - Knowledge Builder API, Part I：Business Scenario"
date:   2019-11-03 16:04:17 +0800
tags: [OData, Web API, Knowledge Builder, ASP.NET Core]
categories: [技术Tips]
---

#### 背景概要

在.NET Core 刚刚1.0 RC的时候，我就给OData团队创建过Issue让他们支持ASP.NET Core，然而没有任何有意义的答复。

[Roadmap for ASP.NET Core 1.0 RC2? ](https://github.com/OData/WebApi/issues/744)


接着，在.NET Core 1.0刚刚发布的时候，又给他们创建了另外一个Issue，虽然被他们列为P1，但是已经没有下文：

[Roadmap for OData WebAPI run on ASP.NET Core 1.0](https://github.com/OData/WebApi/issues/772)


然后在.NET Core 2.0 Preview版本发布的时候，我继续给OData 团队提Issue：

[[vNext] Even ASP.NET Core 2 Preview 1 announced, OData WebAPI vNext still no updates](https://github.com/OData/WebApi/issues/975)


最终，在OData 7.0的时候，OData发布了基于ASP.NET Core的支持。

经过这么长时间的测试和迭代，我想，是时候创建一个基于OData的Web API。


不幸的是，OData再次走在ASP.NET Core 后面: [Issue](https://github.com/OData/WebApi/issues/1748)，~~所以这个例子只能使用ASP.NET Core 2.2~~。　

所幸的是，自从7.3.0-beta开始支持.NETCore 3.0（更新日期：2019.12.11），~~后续的博客中使用了该Beta版本以及更高版本~~。

更新于2020.07.01： 使用了OData WebAPI 7.4.1。


#### Part I: Business Scenario


Knowledge Builder是个用来创建、维护、浏览知识点的Web App，Knowledge Builder API是服务于其需求的API。

它包含这么几种类型的对象：
- Knowledge Item。知识点。
- Question Bank Item。题库项。

##### Knowledge Item 知识点

简单来说，Knowlege Item是个复杂文本，外加一些额外的属性。

就常见的语数英而言，Knowledge本身要支持各种特殊符号，而且需要支付各种数学公式、数学图形等。

这里Content Type只是个占位符。

数据库表定义如下(基于T-SQL)：

```sql
CREATE TABLE [KnowledgeItem] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [ContentType] SMALLINT       NULL,
    [Title]       NVARCHAR (50)  NOT NULL,
    [Content]     NVARCHAR (MAX) NOT NULL,
    [Tags]        NCHAR (100)    NULL,
    [CreatedAt]   DATETIME       DEFAULT (getdate()) NULL,
    [ModifiedAt]  DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

```

##### Question Bank Item 题库项

题库项是基于Knowledge Item的。

题库项的类型：
- 问答题
- 选择题 （题干和选择项目）
- 阅读理解（使用层次结构达到）

数据库表定义如下(基于T-SQL)：

```sql
CREATE TABLE [QuestionBankItem] (
    [ID]                INT            IDENTITY (1, 1) NOT NULL,
    [KnowledgeItem]     INT            NULL,
    [ParentID]          INT            NULL,
    [QBType]            INT            NOT NULL,
    [Content]           NVARCHAR (MAX) NOT NULL,
    [CreatedAt]         DATETIME       DEFAULT (getdate()) NULL,
    [ModifiedAt]        DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_QBITEM_KITEM] FOREIGN KEY ([KnowledgeItem]) REFERENCES KnowledgeItem ([ID]) ON DELETE SET NULL
);

CREATE TABLE [QuestionBankSubItem] (
    [ItemID]            INT            NOT NULL,
    [SubID]             NVARCHAR(20)   NOT NULL,
    [Content]           NVARCHAR (MAX) NOT NULL,
    [CreatedAt]         DATETIME       DEFAULT (getdate()) NULL,
    [ModifiedAt]        DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY ([ItemID] ASC, [SubID] ASC),
    CONSTRAINT [FK_QBSUBITEM_QBITEM] FOREIGN KEY ([ItemID]) REFERENCES QuestionBankItem ([ID]) ON DELETE CASCADE ON UPDATE CASCADE 
);
```

下一篇介绍如何设置Project：[Part II:  Project setup]({% post_url 2019-11-04-ODataBasedAPI2 %})

项目Repo： <https://github.com/alvachien/knowledgebuilderapi>


是为之记。   
Alva Chien   
2019.11.03   
Updated on 2020.07.01

