---
layout: post
title:  创建基于OData的Web API - Knowledge Builder API, Part III, Model
date:   2019-11-06 22:22:22 +0800
tags: [OData, Web API]
categories: [技术Tips]
---

在前两篇文章查看第一篇 [Part I:  Business Scenario]({% post_url 2019-11-03-ODataBasedAPI1 %}) 
和第二篇 [Part II:  Project setup]({% post_url 2019-11-04-ODataBasedAPI2 %}) 后，可以开始真正Model的创建。

步骤如下：

1. 创建Models文件夹，并在该文件夹中加入Knowledge Category定义，代码如下：

```C#
using System;

namespace knowledgebuilderapi.Models {
    public enum KnowledgeCategory: Int16 {
        Concept     = 0,
        Formula     = 1,
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
        public KnowledgeCategory Category { get;set; }
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

        public ICollection<QuestionBankItem> QuestionBankItems { get; set; }
    }
}
```

3. Question Bank Item的Model

代码如下：

```C#
namespace knowledgebuilderapi.Models
{
    [Table("QuestionBankItem")]
    public sealed class QuestionBankItem : BaseModel
    {
        [Key]
        public Int32 ID { get; set; }

        [Column("KnowledgeItem", TypeName = "INT")]
        public Int32? KnowledgeItemID { get; set; }

        [Column("ParentID", TypeName = "INT")]
        public Int32? ParentID { get; set; }

        [Required]
        [Column("QBType", TypeName = "INT")]
        public Int32 QBType { get; set; }

        [Required]
        [Column("Content", TypeName = "TEXT")]
        public string Content { get; set; }

        public KnowledgeItem CurrentKnowledgeItem { get; set; }

        public ICollection<QuestionBankSubItem> SubItems { get; set; }
    }


    [Table("QuestionBankSubItem")]
    public sealed class QuestionBankSubItem
    {
        [Required]
        [Column("ItemID", TypeName = "INT")]
        public Int32 ItemID { get; set; }

        [Required]
        [Column("SubID", TypeName = "NVARCHAR(20)")]
        [StringLength(20)]
        public String SubID { get; set; }

        [Required]
        [Column("QBType", TypeName = "INT")]
        public Int32 QBType { get; set; }

        [Required]
        [Column("Content", TypeName = "TEXT")]
        public string Content { get; set; }

        public QuestionBankItem CurrentQuestionBankItem { get; set; }
    }
}
```



是为之记。   
Alva Chien   
2019.11.06

