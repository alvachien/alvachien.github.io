---
layout: post
title:  创建基于OData的Web API - Knowledge Builder API, Part V, Controller
date:   2020-07-03 22:22:22 +0800
tags: [OData, Web API]
categories: [技术Tips]
---

基于上两篇 [Part III: Model]({% post_url 2019-11-06-ODataBasedAPI3 %}) 和[Part IV: Data Context]({% post_url 2019-11-07-ODataBasedAPI4 %})，Project已经有了Model和Data Context，现在该创建Controller了。


如果Controller文件夹尚未创建，则创建一个，并在其中创建Knowledges的Controller

注意，由OData的命名规范来说，Controller的名字必须由*entityset*名字+Controller构成。参考[文档](https://docs.microsoft.com/en-us/odata/webapi/built-in-routing-conventions)


所以：

- 如果在Edm中定义了KnowledgeItem，那么就需要定义KnowledgeItemController，
- 如果在Edm中定义了KnowledgeItems，那么就需要定义KnowledgeItemsController。


完整代码如下：

```C#
using System;
using Microsoft.AspNet.OData;
using Microsoft.EntityFrameworkCore;
using knowledgebuilderapi.Models;
using System.Linq;

namespace knowledgesbuilderapi.Controllers {
    public class KnowledgeItemsController : ODataController {
        private readonly kbdataContext _context;

        public KnowledgeItemsController(kbdataContext context)
        {
            _context = context;
        }

        [EnableQuery]
        public IQueryable<KnowledgeItem> Get()
        {
            return _context.KnowledgeItems;
        }
    }
}
```

Question Bank Item的Controller   

```C#
   public class QuestionBankItemsController : ODataController
    {
        private readonly kbdataContext _context;

        public QuestionBankItemsController(kbdataContext context)
        {
            _context = context;
        }

        /// GET: /Knowledges
        /// <summary>
        /// Adds support for getting knowledges, for example:
        /// 
        /// GET /Knowledges
        /// GET /Knowledges?$filter=Name eq 'Windows 95'
        /// GET /Knowledges?
        /// 
        /// <remarks>
        [EnableQuery]
        public IQueryable<QuestionBankItem> Get()
        {
            return _context.QuestionBankItems;
        }
    }
```

Question Bank Sub Item的Controller源码：   

```C#
    public class QuestionBankSubItemsController : ODataController
    {
        private readonly kbdataContext _context;

        public QuestionBankSubItemsController(kbdataContext context)
        {
            _context = context;
        }

        /// GET: /Knowledges
        /// <summary>
        /// Adds support for getting knowledges, for example:
        /// 
        /// GET /Knowledges
        /// GET /Knowledges?$filter=Name eq 'Windows 95'
        /// GET /Knowledges?
        /// 
        /// <remarks>
        [EnableQuery]
        public IQueryable<QuestionBankSubItem> Get()
        {
            return _context.QuestionBankSubItems;
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
            modelBuilder.EntitySet<KnowledgeItem>("KnowledgeItems");
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

打开浏览器，访问 <http://localhost:5000/odata/$metadata>

会成功拿到一下文件，这里注意QuestionBankSubItem被定义成ComplexType，因为这两个Controller没有从OData的Edm中暴露：

```xml
<edmx:Edmx xmlns:edmx="http://docs.oasis-open.org/odata/ns/edmx" Version="4.0">
	<edmx:DataServices>
		<Schema xmlns="http://docs.oasis-open.org/odata/ns/edm" Namespace="knowledgebuilderapi.Models">
			<EntityType Name="KnowledgeItem">
				<Key>
					<PropertyRef Name="ID"/>
				</Key>
				<Property Name="ID" Type="Edm.Int32" Nullable="false"/>
				<Property Name="Category" Type="knowledgebuilderapi.Models.KnowledgeCategory" Nullable="false"/>
				<Property Name="Title" Type="Edm.String" Nullable="false" MaxLength="50"/>
				<Property Name="Content" Type="Edm.String" Nullable="false"/>
				<Property Name="Tags" Type="Edm.String"/>
				<Property Name="CreatedAt" Type="Edm.DateTimeOffset"/>
				<Property Name="ModifiedAt" Type="Edm.DateTimeOffset"/>
				<NavigationProperty Name="QuestionBankItems" Type="Collection(knowledgebuilderapi.Models.QuestionBankItem)"/>
			</EntityType>
			<EntityType Name="QuestionBankItem">
				<Key>
					<PropertyRef Name="ID"/>
				</Key>
				<Property Name="ID" Type="Edm.Int32" Nullable="false"/>
				<Property Name="KnowledgeItemID" Type="Edm.Int32"/>
				<Property Name="ParentID" Type="Edm.Int32"/>
				<Property Name="QBType" Type="Edm.Int32" Nullable="false"/>
				<Property Name="Content" Type="Edm.String" Nullable="false"/>
				<Property Name="SubItems" Type="Collection(knowledgebuilderapi.Models.QuestionBankSubItem)"/>
				<Property Name="CreatedAt" Type="Edm.DateTimeOffset"/>
				<Property Name="ModifiedAt" Type="Edm.DateTimeOffset"/>
				<NavigationProperty Name="CurrentKnowledgeItem" Type="knowledgebuilderapi.Models.KnowledgeItem">
					<ReferentialConstraint Property="KnowledgeItemID" ReferencedProperty="ID"/>
				</NavigationProperty>
			</EntityType>
			<ComplexType Name="QuestionBankSubItem">
				<Property Name="ItemID" Type="Edm.Int32" Nullable="false"/>
				<Property Name="SubID" Type="Edm.String" Nullable="false"/>
				<Property Name="QBType" Type="Edm.Int32" Nullable="false"/>
				<Property Name="Content" Type="Edm.String" Nullable="false"/>
				<NavigationProperty Name="CurrentQuestionBankItem" Type="knowledgebuilderapi.Models.QuestionBankItem"/>
			</ComplexType>
			<EnumType Name="KnowledgeCategory" UnderlyingType="Edm.Int16" IsFlags="true">
				<Member Name="Concept" Value="0"/>
				<Member Name="Formula" Value="1"/>
			</EnumType>
			<EntityContainer Name="Container">
				<EntitySet Name="KnowledgeItems" EntityType="knowledgebuilderapi.Models.KnowledgeItem">
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


修改Startup，增加Edm的定义：   
```C#
    modelBuilder.EntitySet<QuestionBankItem>("QuestionBankItems");
    modelBuilder.EntitySet<QuestionBankSubItem>("QuestionBankSubItems");
```


这时候，再取`$metadata`，会遇到以下错误:
> Exception thrown: 'System.InvalidOperationException' in Microsoft.AspNetCore.OData.dll
An exception of type 'System.InvalidOperationException' occurred in Microsoft.AspNetCore.OData.dll but was not handled in user code
The entity set 'QuestionBankSubItems' is based on type 'knowledgebuilderapi.Models.QuestionBankSubItem' that has no keys defined.


要修正这个，需要在Model QuestionBankSubItem中增加Key的定义：

```C#
    [Table("QuestionBankSubItem")]
    public sealed class QuestionBankSubItem
    {
        [Key]
        [Column("ItemID", TypeName = "INT")]
        public Int32 ItemID { get; set; }

        [Key]
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
```

得到最新的XML文件是：

```xml
<edmx:Edmx xmlns:edmx="http://docs.oasis-open.org/odata/ns/edmx" Version="4.0">
	<edmx:DataServices>
		<Schema xmlns="http://docs.oasis-open.org/odata/ns/edm" Namespace="knowledgebuilderapi.Models">
			<EntityType Name="KnowledgeItem">
				<Key>
					<PropertyRef Name="ID"/>
				</Key>
				<Property Name="ID" Type="Edm.Int32" Nullable="false"/>
				<Property Name="Category" Type="knowledgebuilderapi.Models.KnowledgeCategory" Nullable="false"/>
				<Property Name="Title" Type="Edm.String" Nullable="false" MaxLength="50"/>
				<Property Name="Content" Type="Edm.String" Nullable="false"/>
				<Property Name="Tags" Type="Edm.String"/>
				<Property Name="CreatedAt" Type="Edm.DateTimeOffset"/>
				<Property Name="ModifiedAt" Type="Edm.DateTimeOffset"/>
				<NavigationProperty Name="QuestionBankItems" Type="Collection(knowledgebuilderapi.Models.QuestionBankItem)"/>
			</EntityType>
			<EntityType Name="QuestionBankItem">
				<Key>
					<PropertyRef Name="ID"/>
				</Key>
				<Property Name="ID" Type="Edm.Int32" Nullable="false"/>
				<Property Name="KnowledgeItemID" Type="Edm.Int32"/>
				<Property Name="ParentID" Type="Edm.Int32"/>
				<Property Name="QBType" Type="Edm.Int32" Nullable="false"/>
				<Property Name="Content" Type="Edm.String" Nullable="false"/>
				<Property Name="CreatedAt" Type="Edm.DateTimeOffset"/>
				<Property Name="ModifiedAt" Type="Edm.DateTimeOffset"/>
				<NavigationProperty Name="CurrentKnowledgeItem" Type="knowledgebuilderapi.Models.KnowledgeItem">
					<ReferentialConstraint Property="KnowledgeItemID" ReferencedProperty="ID"/>
				</NavigationProperty>
				<NavigationProperty Name="SubItems" Type="Collection(knowledgebuilderapi.Models.QuestionBankSubItem)"/>
			</EntityType>
			<EntityType Name="QuestionBankSubItem">
				<Key>
					<PropertyRef Name="ItemID"/>
					<PropertyRef Name="SubID"/>
				</Key>
				<Property Name="ItemID" Type="Edm.Int32" Nullable="false"/>
				<Property Name="SubID" Type="Edm.String" Nullable="false"/>
				<Property Name="QBType" Type="Edm.Int32" Nullable="false"/>
				<Property Name="Content" Type="Edm.String" Nullable="false"/>
				<NavigationProperty Name="CurrentQuestionBankItem" Type="knowledgebuilderapi.Models.QuestionBankItem"/>
			</EntityType>
			<EnumType Name="KnowledgeCategory" UnderlyingType="Edm.Int16" IsFlags="true">
				<Member Name="Concept" Value="0"/>
				<Member Name="Formula" Value="1"/>
			</EnumType>
			<EntityContainer Name="Container">
				<EntitySet Name="KnowledgeItems" EntityType="knowledgebuilderapi.Models.KnowledgeItem">
					<NavigationPropertyBinding Path="QuestionBankItems" Target="QuestionBankItems"/>
					<Annotation Term="Org.OData.Core.V1.OptimisticConcurrency">
						<Collection>
							<PropertyPath>Title</PropertyPath>
						</Collection>
					</Annotation>
				</EntitySet>
				<EntitySet Name="QuestionBankItems" EntityType="knowledgebuilderapi.Models.QuestionBankItem">
					<NavigationPropertyBinding Path="CurrentKnowledgeItem" Target="KnowledgeItems"/>
					<NavigationPropertyBinding Path="SubItems" Target="QuestionBankSubItems"/>
				</EntitySet>
				<EntitySet Name="QuestionBankSubItems" EntityType="knowledgebuilderapi.Models.QuestionBankSubItem">
					<NavigationPropertyBinding Path="CurrentQuestionBankItem" Target="QuestionBankItems"/>
				</EntitySet>
			</EntityContainer>
		</Schema>
	</edmx:DataServices>
</edmx:Edmx>
```



6. 数据库层面校验

如果数据库Connection String已经被正确维护在“KBAPI.ConnectionString”上的话，可以打开数据库查看数据库表的定义。


下一篇将[增加CRUD的支持]({% post_url 2020-07-04-ODataBasedAPI6 %})
 

是为之记。   
Alva Chien   
2020.07.03

