---
layout: post
title:  "创建基于OData的Web API - Knowledge Builder API, Part I：业务场景和存储层设计"
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

更新于2020.07.01：使用了OData WebAPI 7.4.1。   
更新于2020.12.17：使用了OData WebAPI 7.5.2。   


### 业务场景 Business Scenario


自孩提起，我们就听到这个传承至今的谚语：   
> 活到老学到老!

学习，变成了我们人生的一份，也变成了一种生活态度。那么，有了态度，加上点办法就能让学习的过程更加顺畅和有动力。   


所以，从业务场景来看，或者直接了当地从我们学习的过程来看，以下功能点是必须的：

- 学习笔记。分门别类、结构化的学习笔记系统；
- 练习题库。没有练习的学习，是不可能有效果的；
- 错题记录（对应的实现并未包含在这个Blog系列里面，因为这个牵扯到）。只做题不纠正只会重复犯错。
- 练习题参考答案。没有答案的练习题是不完整的。


Knowledge Builder，就是符合上述业务场景的。它是一个用来创建、维护、浏览、测试和巩固知识点（Knowledge Items）的Web App。而Knowledge Builder API是服务于其需求的API。

它包含这么几种类型的对象：   
- Knowledge Item。知识点。
- Exercise Item。题库项。

#### Knowledge Item 知识点


##### Item Category 知识点类型

知识点是有类型的。简单易懂的来说，就常见的语数英。

再细致一点，语数英也是分年级的。高等数学与初等属性的知识点的深度可能完全不同。


##### Item Content 知识点内容 

从内容上看，Knowledge Item本身要支持各种特殊符号，而且需要支付各种数学公式、数学图形等。


Knowledge Item还需要支持音频和视频格式，来应对更广泛的学科。


所以，Markdown格式不失为当下不错的选择。


#### Exercise Item 题库项

题库项是可以基于Knowledge Item，但是也可以跟Knowledge Item没有关联。

题库项的类型：   
- 问答题
- 选择题 （题干和选择项目）
- 阅读理解（使用层次结构达到）


### 存储层设计 Database table design

#### Knowledge Item 知识点

从存储层的维度来看，Knowlege Item核心部分是个复杂文本，外加一些额外的属性。

为了简单起见，这个系列的Blog中不涉及Category，并且Content Type也仅仅作为个占位符。

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

#### Exercise Item 题库项

题库项的类型：
- 问答题
- 选择题 （题干和选择项目）
- 阅读理解（使用层次结构达到）

数据库表定义如下(基于T-SQL)：

```sql
CREATE TABLE [ExerciseItem] (
    [ID]                INT            IDENTITY (1, 1) NOT NULL,
    [KnowledgeItem]     INT            NULL,
    [ParentID]          INT            NULL,
    [ExerciseType]      INT            NOT NULL,
    [Content]           NVARCHAR (MAX) NOT NULL,
    [CreatedAt]         DATETIME       DEFAULT (getdate()) NULL,
    [ModifiedAt]        DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_EXECITEM_KITEM] FOREIGN KEY ([KnowledgeItem]) REFERENCES KnowledgeItem ([ID]) ON DELETE SET NULL
);

CREATE TABLE [ExerciseItemAnswer] (
    [ItemID]            INT            NOT NULL,
    [Content]           NVARCHAR (MAX) NOT NULL,
    [CreatedAt]         DATETIME       DEFAULT (getdate()) NULL,
    [ModifiedAt]        DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY ([ItemID] ASC),
    CONSTRAINT [FK_EXECAWR_EXECITEM] FOREIGN KEY ([ItemID]) REFERENCES ExerciseItem ([ID]) ON DELETE CASCADE ON UPDATE CASCADE 
);
```

下一篇介绍如何设置Project：[Part II:  Project setup]({% post_url 2019-11-04-ODataBasedAPI2 %})


项目Repo： <https://github.com/alvachien/knowledgebuilderapi>


是为之记。   
Alva Chien   
2019.11.03   
Updated on 2020.07.01   
Updated on 2020.12.17    

