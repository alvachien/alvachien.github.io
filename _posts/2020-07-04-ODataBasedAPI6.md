---
layout: post
title:  "创建基于OData的Web API - Knowledge Builder API, Part VI, 为Controller添加CRUD"
date:   2020-07-04 12:02:22 +0800
tags: [OData, Web API, Knowledge Builder]
categories: [技术Tips]
---

本篇就在[上一篇《Controller》]({% post_url 2020-07-03-ODataBasedAPI5 %}) 的基础上，增强Controller使之能涵盖CRUD的全部功能。


以下代码只针对KnowledgeItemsController。

1. 支持Create操作，通常映射到POST方法。

在KnowledgeItemsController中加入如下方法

```C#
    // POST: /KnowledgeItems
    /// <summary>
    /// Support for creating knowledge item
    /// </summary>
    public async Task<IActionResult> Post([FromBody] Knowledge knowledge)
    {
        if (!ModelState.IsValid)
        {
            foreach (var value in ModelState.Values)
            {
                foreach(var err in value.Errors) 
                {
                    System.Diagnostics.Debug.WriteLine(err.Exception?.Message);
                }
            }

            return BadRequest();
        }

        _context.KnowledgeItems.Add(knowledge);
        await _context.SaveChangesAsync();

        return Created(knowledge);
    }
```

注意，因为创建KnowledgeItem必须保证数据的完整性（Model中使用Annotation），所以这里需要判断ModelState。


在Debug语境下，程序会输出所有错误信息。
 

2. 对于Update操作，对应于PUT方法。

加入如下方法：

```C#
    // PUT: /KnowledgeItems/5
    /// <summary>
    /// Support for updating Knowledge items
    /// </summary>
    public async Task<IActionResult> Put([FromODataUri] int key, [FromBody] KnowledgeItem update)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        if (key != update.ID)
        {
            return BadRequest();
        }

        _context.Entry(update).State = EntityState.Modified;
        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!_context.KnowledgeItems.Any(p => p.ID == key))
            {
                return NotFound();
            }
            else
            {
                throw;
            }
        }

        return Updated(update);
    }
```

这里省略了与Create操作中一样的错误输出信息。


3. 对于Delete操作，对应于DELETE方法。

加入对应方法：   

```C#
    // DELETE: /KnowledgeItems/5
    /// <summary>
    /// Support for deleting knowledge item by key.
    /// </summary>
    public async Task<IActionResult> Delete([FromODataUri] int key)
    {
        var knowledge = await _context.KnowledgeItems.FindAsync(key);
        if (knowledge == null)
        {
            return NotFound();
        }

        _context.KnowledgeItems.Remove(knowledge);
        await _context.SaveChangesAsync();

        return StatusCode(204); // HttpStatusCode.NoContent
    }
```


4. 另外一种Update方法，即HTTP PATCH。   

加入对应方法：

```C#
    // PATCH: /KnowlegeItems
    /// <summary>
    /// Support for partial updates of knowledge items
    /// </summary>
    public async Task<IActionResult> Patch([FromODataUri] int key, [FromBody] Delta<KnowledgeItem> knowledge)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var entity = await _context.KnowledgeItems.FindAsync(key);
        if (entity == null)
        {
            return NotFound();
        }

        knowledge.Patch(entity);

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!_context.KnowledgeItems.Any(p => p.ID == key))
            {
                return NotFound();
            }
            else
            {
                throw;
            }
        }

        return Updated(entity);
    }
```

5. 单个读，同样对应于HTTP GET操作。

跟之前的GET方法不同的是，它需要指定Key。

```C#
    /// GET: /KnowledgeItems(:id)
    /// <summary>
    /// Adds support for getting a knowledge item by key, for example:
    /// 
    /// GET /Knowledges(1)
    /// </summary>
    /// <param name="key">The key of the Knowledge item required</param>
    /// <returns>The Knowledge Item</returns>
    [EnableQuery]
    public SingleResult<KnowledgeItem> Get([FromODataUri] int key)
    {
        return SingleResult.Create(_context.KnowledgeItems.Where(p => p.ID == key));
    }
```

6. 测试。

至此，这个Controller已经支持了CRUD操作，可以打开Postman等操作进行测试了。


同时，可以参阅OData官方文档关于Query Data的方法，使用OData强大的数据检索功能进行读取测试。


项目Repo： <https://github.com/alvachien/knowledgebuilderapi>



是为之记。   
Alva Chien   
2020.07.04

