---
layout: post
title:  "创建基于OData的Web API - Knowledge Builder API, Part III, Model类"
date:   2019-11-06 22:22:22 +0800
tags: [OData, Web API, Knowledge Builder]
categories: [技术Tips]
---

本系列之前的文章：

- 第一篇 [Part I:  业务场景和存储层设计]({% post_url 2019/2019-11-03-ODataBasedAPI1 %}) 

- 第二篇 [Part II:  开发环境及项目设置]({% post_url 2019/2019-11-04-ODataBasedAPI2 %}) 


基于前面两篇的基础后，可以开始真正Model的创建。


步骤如下：

1. Knowledge Item Category 和 Exercise Item Type

虽然在本示例中，Knowledge Item Category和Exercise Item Type都只是占位符，但是将其先定义下来，不失为一个好办法。

创建Models文件夹，并在该文件夹中加入Knowledge Item Category与Exercise Item Type的定义，代码如下：

```C#
using System;

namespace knowledgebuilderapi.Models {
    public enum KnowledgeItemCategory: Int16 {
        Concept     = 0,
        Formula     = 1,
    }

    public enum ExerciseItemType: Int16 {
        Question        = 0,
        SingleChoice    = 1,
        MultipleChoice  = 2,
        ShortAnswer     = 3,
        EssayQuestions  = 4,
    }
}
```


基类BaseModel，代码如下：

```C#
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace knowledgebuilderapi.Models {
    public abstract class BaseModel {

        [Column("CreatedAt")]
        public DateTime CreatedAt { get; set; }
        [Column("ModifiedAt")]
        public DateTime? ModifiedAt { get; set; }
    }
}
```

2. Knowledge Item的Model，代码如下：

值得注意的是，其加入对Question Bank Item的关联。

```C#
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace knowledgebuilderapi.Models
{
    [Table("KnowledgeItem")]
    public sealed class KnowledgeItem : BaseModel
    {
        [Key]
        public Int32 ID { get; set; }

        [Required]
        [Column("ContentType")]
        public KnowledgeItemCategory Category { get;set; }

        [Required]
        [MaxLength(50)]
        [ConcurrencyCheck]
        [Column("Title", TypeName = "NVARCHAR(50)")]
        public string Title { get;set; }

        [Required]
        [Column("Content")]
        public string Content { get;set; }
        [Column("Tags")]
        public string Tags { get; set; }

        public ICollection<ExerciseItem> Exercises { get; set; }
    }
}
```

3. Exercise Item的Model

代码如下：

```C#
namespace knowledgebuilderapi.Models
{
    [Table("ExerciseItem")]
    public sealed class ExerciseItem : BaseModel
    {
        [Key]
        public Int32 ID { get; set; }

        [Column("KnowledgeItem", TypeName = "INT")]
        public Int32? KnowledgeItemID { get; set; }

        [Required]
        [Column("ExerciseType", TypeName = "INT")]
        public ExerciseItemType ExerciseType { get; set; }

        [Required]
        [Column("Content", TypeName = "TEXT")]
        public string Content { get; set; }

        public KnowledgeItem CurrentKnowledgeItem { get; set; }
        public ExerciseItemAnswer Answer { get; set; }
    }


    [Table("ExerciseItemAnswer")]
    public sealed class ExerciseItemAnswer : BaseModel
    {
        [Key]
        [Column("ItemID", TypeName = "INT")]
        public Int32 ItemID { get; set; }

        [Required]
        [Column("Content", TypeName = "TEXT")]
        public string Content { get; set; }

        public ExerciseItem ExerciseItem { get; set; }
    }
}
```

下一篇：[实现DataContext]({% post_url 2019/2019-11-07-ODataBasedAPI4 %})。


项目Github Repo ： [Link](https://github.com/alvachien/knowledgebuilderapi)


是为之记。   
Alva Chien   
完成于 2019.11.06   
更新于 2020.12.17   

