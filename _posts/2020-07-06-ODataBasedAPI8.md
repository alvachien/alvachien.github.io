---
layout: post
title:  "创建基于OData的Web API - Knowledge Builder API, Part VIII, Unit Test准备"
date:   2020-07-06 23:17:22 +0800
tags: [OData, Web API, Knowledge Builder, Unit Test]
categories: [技术Tips]
---


本系列之前的文章：

- 第一篇 [Part I:  业务场景和存储层设计]({% post_url 2019-11-03-ODataBasedAPI1 %}) 

- 第二篇 [Part II:  开发环境及项目设置]({% post_url 2019-11-04-ODataBasedAPI2 %}) 

- 第三篇 [Part III:  Model类]({% post_url 2019-11-06-ODataBasedAPI3 %}) 

- 第四篇 [Part IV: Data Context]({% post_url 2019-11-07-ODataBasedAPI4 %})

- 第五篇 [Part V: Controller]({% post_url 2020-07-03-ODataBasedAPI5 %}) 

- 第六篇 [Part VI: 为Controller添加CRUD]({% post_url 2020-07-04-ODataBasedAPI6 %}) 

- 第七篇 [Part VII: 用Postman测试]({% post_url 2020-07-05-ODataBasedAPI7 %}) 


对已经用Postman对该API的手动测试的项目来说，下一步就是用自动化测试来保障产品质量了。


基于第二篇[Project_Setup]({% post_url 2019-11-04-ODataBasedAPI2 %})，已经有了一个Test的项目：KnowledgeBuilderAPI.Test。


#### 步骤一 隔离数据库操作

准备一个Fixture的类来隔离数据库操作，封装SQLite相关的操作。

其目的在于，如果需要使用别的数据库，可以创建类似的Class来取代。

注意，这里把数据Table和View的创建放在DataSetUtility（稍后介绍）中，虽然导致DataSetUtility也需要注意涵盖数据库版本不同，但是这是为了保证该DatabaseFixture的独立性。


```C#
    public class SqliteDatabaseFixture : IDisposable
    {
        public SqliteDatabaseFixture()
        {
            // Open connections
            DBConnection = new SqliteConnection("DataSource=:memory:");
            DBConnection.Open();

            try
            {
                // Create the schema in the database
                var context = GetCurrentDataContext();
                if (!context.Database.IsSqlite()
                    || context.Database.IsSqlServer())
                {
                    throw new Exception("Faield!");
                }

                // Create tables and views
                DataSetupUtility.CreateDatabaseTables(context.Database);
                DataSetupUtility.CreateDatabaseViews(context.Database);

                context.Database.EnsureCreated();

                // Setup the tables
                // Create initial values

                context.Dispose();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
                // Error occurred
            }
            finally
            {
            }
        }

        public void Dispose()
        {
            if (DBConnection != null)
            {
                DBConnection.Close();
                DBConnection = null;
            }
        }

        protected SqliteConnection DBConnection { get; private set; }

        public kbdataContext GetCurrentDataContext()
        {
            var options = new DbContextOptionsBuilder<kbdataContext>()
                .UseSqlite(DBConnection, action =>
                {
                    action.UseRelationalNulls();
                })
                .UseQueryTrackingBehavior(QueryTrackingBehavior.TrackAll)
                .EnableSensitiveDataLogging()
                .Options;

            var context = new kbdataContext(options, true);
            return context;
        }
    }
```

#### 步骤二 数据准备

封装另外一个类来准备数据。

```C#
    public sealed class DataSetupUtility
    {
        #region Create tables and Views
        public static void CreateDatabaseTables(DatabaseFacade database)
        {
            database.ExecuteSqlRaw(@"CREATE TABLE KnowledgeItem (
                ID INTEGER PRIMARY KEY AUTOINCREMENT,
                ContentType SMALLINT       NULL,
                Title       NVARCHAR(50)  NOT NULL,
                Content     TEXT NOT NULL,
                Tags        NVARCHAR(100)    NULL,
                CreatedAt   DATETIME    NULL   DEFAULT CURRENT_DATE,
                ModifiedAt  DATETIME    NULL   DEFAULT CURRENT_DATE )"
            );

            database.ExecuteSqlRaw(@"CREATE TABLE ExerciseItem (
                ID INTEGER PRIMARY KEY AUTOINCREMENT,
                KnowledgeItem     INT            NULL,
                ParentID          INT            NULL,
                ExerciseType      INT            NOT NULL,
                Content           TEXT NOT NULL,
                CreatedAt   DATETIME    NULL   DEFAULT CURRENT_DATE,
                ModifiedAt  DATETIME    NULL   DEFAULT CURRENT_DATE,    
                CONSTRAINT FK_EXECITEM_KITEM FOREIGN KEY (KnowledgeItem) REFERENCES KnowledgeItem (ID) ON DELETE SET NULL )"
            );

            database.ExecuteSqlRaw(@"CREATE TABLE ExerciseItemAnswer (
                ItemID            INTERGER PRIMARY KEY,
                Content           TEXT NOT NULL,
                CreatedAt   DATETIME    NULL   DEFAULT CURRENT_DATE,
                ModifiedAt  DATETIME    NULL   DEFAULT CURRENT_DATE,    
                CONSTRAINT FK_EXECAWR_EXECITEM FOREIGN KEY (ItemID) REFERENCES ExerciseItem (ID) ON DELETE CASCADE ON UPDATE CASCADE )"
            );
        }

        public static void CreateDatabaseViews(DatabaseFacade database)
        {
            // Nothing
        }
        #endregion

        internal static void DeleteKnowledgeItem(kbdataContext context, int kid)
        {
            context.Database.ExecuteSqlRaw("DELETE FROM KnowledgeItem WHERE ID = " + kid.ToString());
        }
    }
```

#### 步骤三 创建Test的Collection

创建一个Unit Tests的文件夹。并在文件夹类添加一个Test Collection的类。该类的目的是为了使得整个Unit Test能够串行化。

串行化的目的是降低Controller Test之间的耦合度。


```C#
    [CollectionDefinition("KBAPI_UnitTests#1")]
    public class UnitTestCollection : ICollectionFixture<SqliteDatabaseFixture>
    {
        // This class has no code, and is never created. Its purpose is simply
        // to be the place to apply [CollectionDefinition] and all the
        // ICollectionFixture<> interfaces.
    }
```

#### 步骤四 编写第一个Unit Test类

编写Knowledge Item Controller的Unit Test，这里只有简单的Create，Delete和GET。

```C#
    [Collection("KBAPI_UnitTests#1")]
    public class KnowledgeItemsControllerTest : IDisposable
    {
        SqliteDatabaseFixture fixture = null;
        private List<Int32> objectsCreated = new List<Int32>();

        public KnowledgeItemsControllerTest(SqliteDatabaseFixture fixture)
        {
            this.fixture = fixture;
        }

        public void Dispose()
        {
            CleanupCreatedEntries();
        }

        [Fact]
        public async Task TestCase1()
        {
            var context = this.fixture.GetCurrentDataContext();
            KnowledgeItemsController control = new KnowledgeItemsController(context);

            // Step 1. Read all - 0
            var rsts = control.Get();
            var rstscnt = await rsts.CountAsync();
            Assert.Equal(0, rstscnt);

            // Step 2. Create one know ledge item
            var ki = new KnowledgeItem()
            {
                Category = KnowledgeItemCategory.Concept,
                Title = "Test 1",
                Content  = "Test 1 Content",
            };
            var rst = await control.Post(ki);
            Assert.NotNull(rst);
            var rst2 = Assert.IsType<CreatedODataResult<KnowledgeItem>>(rst);
            Assert.Equal(rst2.Entity.Title, ki.Title);
            Assert.Equal(rst2.Entity.Content, ki.Content);
            var firstid = rst2.Entity.ID;
            Assert.True(firstid > 0);
            objectsCreated.Add(firstid);

            // Step 3. Read all - 1
            rsts = control.Get();
            rstscnt = await rsts.CountAsync();
            Assert.Equal(1, rstscnt);

            // Step 5. Delete
            rst = await control.Delete(firstid);

            rsts = control.Get();
            rstscnt = await rsts.CountAsync();
            Assert.Equal(0, rstscnt);

            //// Step 9. Read it again via OData way
            //var httpContext = new DefaultHttpContext(); // or mock a `HttpContext`
            //httpContext.Request.Path = "/api/KnowledgeItems";
            //httpContext.Request.QueryString = new QueryString("?$select=ID, Title");
            //httpContext.Request.Method = "GET";
            //var routeData = new RouteData();
            //routeData.Values.Add("odataPath", "KnowledgeItems");
            //routeData.Values.Add("action", "GET");

            //// Controller needs a controller context 
            //var controllerContext = new ControllerContext()
            //{
            //    RouteData = routeData,
            //    HttpContext = httpContext,
            //};
            //// Assign context to controller
            //control = new KnowledgeItemsController(context)
            //{
            //    ControllerContext = controllerContext,
            //};
            //rsts = control.Get();
            //Assert.NotNull(rsts);

            await context.DisposeAsync();
        }

        private void CleanupCreatedEntries()
        {
            if (objectsCreated.Count > 0)
            {
                var context = this.fixture.GetCurrentDataContext();
                foreach (var kid in objectsCreated)
                    DataSetupUtility.DeleteKnowledgeItem(context, kid);

                objectsCreated.Clear();
                context.SaveChanges();
            }
        }
    }
```

这时，通过Visual Studio的Test Explorer可以进行Unit Test测试了。


是为之记。   
Alva Chien   
2020.07.06   

