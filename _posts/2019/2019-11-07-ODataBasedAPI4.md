---
layout: post
title:  "创建基于OData的Web API - Knowledge Builder API, Part IV, Data Context"
date:   2019-11-07 21:22:22 +0800
tags: [OData, Web API, Knowledge Builder]
categories: [技术Tips]
---

本系列之前的文章：

- 第一篇 [Part I:  业务场景和存储层设计]({% post_url 2019/2019-11-03-ODataBasedAPI1 %}) 

- 第二篇 [Part II:  开发环境及项目设置]({% post_url 2019/2019-11-04-ODataBasedAPI2 %}) 

- 第三篇 [Part III:  Model类]({% post_url 2019/2019-11-06-ODataBasedAPI3 %}) 


本篇介绍创建Data Context。


因为支持Unit Test，DataContext引入了额外的Property：TestingMode。

- 普通模式下，API后面链接着SQL Server，所有有些Default Value是T-SQL专属的。
- Unit Test模式下，API后面链接着SQL Lite(因为该数据库支持In Memory模)，但是其某些Default Value是SQL Lite特有的。


同时，因为QuestionBankSubItem有多个Key，   

```C#
    entity.HasKey(e => new { e.ItemID, e.SubID });
```


所以，DataContext的代码如下：

```C#
using System;
using Microsoft.EntityFrameworkCore;

namespace knowledgebuilderapi
{
    public class kbdataContext : DbContext
    {
        public kbdataContext(DbContextOptions<kbdataContext> options) : base(options)
        {
            TestingMode = false;
        }

        public kbdataContext(DbContextOptions<kbdataContext> options, bool testingMode = false) : base(options)
        {
            TestingMode = testingMode;
        }

        // Testing mode
        public Boolean TestingMode { get; private set; }

        public DbSet<KnowledgeItem> KnowledgeItems { get; set; }
        public DbSet<ExerciseItem> ExerciseItems { get; set; }
        public DbSet<ExerciseItemAnswer> ExerciseItemAnswers { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<KnowledgeItem>(entity =>
            {
                if (!TestingMode)
                {
                    entity.Property(b => b.CreatedAt)
                        .HasDefaultValueSql("GETDATE()");
                    entity.Property(b => b.ModifiedAt)
                        .HasDefaultValueSql("GETDATE()");
                }
                else
                {
                    entity.Property(b => b.CreatedAt)
                        .HasDefaultValueSql("CURRENT_DATE");
                    entity.Property(b => b.ModifiedAt)
                        .HasDefaultValueSql("CURRENT_DATE");
                }
                entity.Property(b => b.Category)
                    .HasConversion(
                        v => (Int16)v,
                        v => (KnowledgeItemCategory)v);
            });

            modelBuilder.Entity<ExerciseItem>(entity =>
            {
                if (!TestingMode)
                {
                    entity.Property(b => b.CreatedAt)
                        .HasDefaultValueSql("GETDATE()");
                    entity.Property(b => b.ModifiedAt)
                        .HasDefaultValueSql("GETDATE()");
                }
                else
                {
                    entity.Property(b => b.CreatedAt)
                        .HasDefaultValueSql("CURRENT_DATE");
                    entity.Property(b => b.ModifiedAt)
                        .HasDefaultValueSql("CURRENT_DATE");
                }

                entity.HasOne(d => d.CurrentKnowledgeItem)
                    .WithMany(p => p.Exercises)
                    .HasForeignKey(d => d.KnowledgeItemID)
                    .OnDelete(DeleteBehavior.SetNull)
                    .HasConstraintName("FK_EXECITEM_KITEM");
            });

            modelBuilder.Entity<ExerciseItemAnswer>(entity =>
            {
                entity.HasKey(e => new { e.ItemID });

                entity.HasOne(d => d.ExerciseItem)
                    .WithOne(p => p.Answer)
                    .HasForeignKey<ExerciseItem>(prop => prop.ID)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK_EXECAWR_EXECITEM");
            });
        }
    }
}
```

下一篇：[创建Controller]({% post_url 2020/2020-07-03-ODataBasedAPI5 %})


是为之记。   
Alva Chien   
2019.11.07   
更新于2020.12.17   

