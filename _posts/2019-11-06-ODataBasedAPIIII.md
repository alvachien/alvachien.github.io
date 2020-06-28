---
layout: post
title:  创建基于OData的Web API - Knowledge Builder API, Part III, Model
date:   2019-11-06 22:22:22 +0800
tags: [OData, Web API]
categories: [技术Tips]
---

在前两篇文章查看第一篇 [Part I:  Business Scenario]({% post_url 2019-11-03-ODataBasedAPII %}) 
和第二篇 [Part II:  Project setup]({% post_url 2019-11-04-ODataBasedAPIII %}) 
后，可以开始真正Model的创建。

步骤如下：

1. 创建Models文件夹，并在该文件夹中加入一个数个Class。

Knowledge Category定义，代码如下：

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
        public DateTime ModifiedAt { get; set; }
    }
}
```

Knowledge的Model，代码如下：

```C#
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace knowledgebuilderapi.Models
{
    [Table("Knowledge")]
    public class Knowledge : BaseModel
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
    }
}
```

最后加入DataContext，代码如下：

```C#
using System;
using Microsoft.EntityFrameworkCore;

namespace knowledgebuilderapi.Models
{
    public class kbdataContext : DbContext
    {
        public kbdataContext(DbContextOptions<kbdataContext> options) : base(options)
        { }

        public DbSet<Knowledge> Knowledges { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Knowledge>()
                .Property(b => b.CreatedAt)
                .HasDefaultValueSql("getdate()");
            modelBuilder.Entity<Knowledge>()
                .Property(b => b.ModifiedAt)
                .HasDefaultValueSql("getdate()");
            modelBuilder.Entity<Knowledge>()
                .Property(e => e.Category)
                .HasConversion(
                    v => (Int16)v,
                    v => (KnowledgeCategory)v);
        }
    }
}
```

2. 如果Controller文件夹尚未创建，则创建一个，并在其中创建Knowledges的Controller

注意，由OData的命名规范来说，Controller的名字必须由*entityset*名字+Controller构成。参考文档：https://docs.microsoft.com/en-us/odata/webapi/built-in-routing-conventions

所以，如果在Edm的Model中定义了Knowledge，那么就需要定义KnowledgeController，

如果在Edm的Model中定义了Knowledges，那么就需要定义KnowledgesController。

完整代码如下：

```C#
using System;
using Microsoft.AspNet.OData;
using Microsoft.EntityFrameworkCore;
using knowledgebuilderapi.Models;
using System.Linq;

namespace knowledgesbuilderapi.Controllers {
    public class KnowledgesController : ODataController {
        private readonly kbdataContext _context;

        public KnowledgesController(kbdataContext context)
        {
            _context = context;
        }

        [EnableQuery]
        public IQueryable<Knowledge> Get()
        {
            return _context.Knowledges;
        }
    }
}
```

3. 修改Startup

代码如下：
```C#
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNet.OData.Extensions;
using Microsoft.AspNet.OData.Builder;
using Microsoft.AspNet.OData.Batch;
using knowledgebuilderapi.Models;
using Microsoft.AspNetCore.Routing;

namespace knowledgebuilderapi
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }
        public string ConnectionString { get; private set; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            this.ConnectionString = Configuration["KBAPI.ConnectionString"];

            services.AddDbContext<kbdataContext>(options =>
                options.UseSqlServer(this.ConnectionString));

            services.AddMvc(action => {
                action.EnableEndpointRouting = false;
            }).SetCompatibilityVersion(CompatibilityVersion.Version_2_2);
            services.AddOData();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();

            ODataModelBuilder modelBuilder = new ODataConventionModelBuilder(app.ApplicationServices);
            modelBuilder.EntitySet<Knowledge>("Knowledges");
            modelBuilder.Namespace = typeof(Knowledge).Namespace;

            var model = modelBuilder.GetEdmModel();
            app.UseODataBatching();

            app.UseMvc(routeBuilder =>
                {
                    // and this line to enable OData query option, for example $filter
                    routeBuilder.Select().Expand().Filter().OrderBy().MaxTop(100).Count();

                    routeBuilder.MapODataServiceRoute("ODataRoute", "odata", model);
                });
        }
    }
}
```

4. 在项目的根目录下执行
```powershell
cd knowledgebuilderapi
dotnet run
```

5. 测试
打开浏览器，访问 http://localhost:5000/odata/$metadata

会成功拿到一下文件：
```xml
<edmx:Edmx xmlns:edmx="http://docs.oasis-open.org/odata/ns/edmx" Version="4.0">
    <edmx:DataServices>
        <Schema xmlns="http://docs.oasis-open.org/odata/ns/edm" Namespace="knowledgebuilderapi.Models">
            <EntityType Name="Knowledge">
                <Key>
                    <PropertyRef Name="ID"/>
                </Key>
                <Property Name="ID" Type="Edm.Int32" Nullable="false"/>
                <Property Name="Category" Type="knowledgebuilderapi.Models.KnowledgeCategory" Nullable="false"/>
                <Property Name="Title" Type="Edm.String" Nullable="false" MaxLength="50"/>
                <Property Name="Content" Type="Edm.String" Nullable="false"/>
                <Property Name="Tags" Type="Edm.String"/>
                <Property Name="CreatedAt" Type="Edm.DateTimeOffset" Nullable="false"/>
                <Property Name="ModifiedAt" Type="Edm.DateTimeOffset" Nullable="false"/>
            </EntityType>
            <EnumType Name="KnowledgeCategory" UnderlyingType="Edm.Int16">
                <Member Name="Concept" Value="0"/>
                <Member Name="Formula" Value="1"/>
            </EnumType>
            <EntityContainer Name="Container">
                <EntitySet Name="Knowledges" EntityType="knowledgebuilderapi.Models.Knowledge">
                    <Annotation Term="Org.OData.Core.V1.OptimisticConcurrency">
                        <Collection>
                            <PropertyPath>Title</PropertyPath>
                        </Collection>
                    </Annotation>
                </EntitySet>
            </EntityContainer>
        </Schema>
    </edmx:DataServices>
</edmx:Edmx>
```

6. 数据库层面校验

如果数据库Connection String已经被正确维护在“KBAPI.ConnectionString”上的话，打开链接： ~/odata/Knowledges 将会看到数据。


是为之记。   
Alva Chien   
2019.11.06

