---
layout: post
title:  创建基于OData的Web API - Knowledge Builder API, Part IV, Controller
date:   2019-11-06 22:22:22 +0800
tags: [OData, Web API]
categories: [技术Tips]
---

基于上一篇 [Part III:  Model]({% post_url 2019-11-06-ODataBasedAPIIII %}) ，新创建的OData Service已经能够正常显示metadata和读所有记录了，但是最基本的创建，读取单个，修改单个功能还没有。


本篇就在上一篇的基础上，增强Controller使之能涵盖CRUD的全部功能。


1. 对于Create操作，通常映射到POST方法，在KnowledgesController中加入如下方法
```C#
    // POST: /Knowledges
    /// <summary>
    /// Support for creating knowledge
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

        _context.Knowledges.Add(knowledge);
        await _context.SaveChangesAsync();

        return Created(knowledge);
    }
```

注意，因为创建Knowledge必须保证数据的完整性（Model中使用Annotation），所以这里需要判断ModelState。

在Debug语境下，程序会输出所有错误信息。
 

2. 对于Update操作，对应于PUT方法，则加入如下方法，
```C#
    // PUT: /Knowledges/5
    /// <summary>
    /// Support for updating Knowledges
    /// </summary>
    public async Task<IActionResult> Put([FromODataUri] int key, [FromBody] Knowledge update)
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
            if (!_context.Knowledges.Any(p => p.ID == key))
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
 

3. 对于Delete操作，对应于DELETE方法，则加入：
```C#
    // DELETE: /Knowledges/5
    /// <summary>
    /// Support for deleting knowledge by key.
    /// </summary>
    public async Task<IActionResult> Delete([FromODataUri] int key)
    {
        var knowledge = await _context.Knowledges.FindAsync(key);
        if (knowledge == null)
        {
            return NotFound();
        }

        _context.Knowledges.Remove(knowledge);
        await _context.SaveChangesAsync();

        return StatusCode(204); // HttpStatusCode.NoContent
    }
```

4. 另外一种Update方法，即HTTP PATCH，
```C#
    // PATCH: /Knowleges
    /// <summary>
    /// Support for partial updates of knowledges
    /// </summary>
    public async Task<IActionResult> Patch([FromODataUri] int key, [FromBody] Delta<Knowledge> knowledge)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var entity = await _context.Knowledges.FindAsync(key);
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
            if (!_context.Knowledges.Any(p => p.ID == key))
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

5. 单个读，同样对应于HTTP GET操作，不同的是，它需要指定Key。
```C#
    /// GET: /Knowledges(:id)
    /// <summary>
    /// Adds support for getting a knowledge by key, for example:
    /// 
    /// GET /Knowledges(1)
    /// </summary>
    /// <param name="key">The key of the Knowledge required</param>
    /// <returns>The Knowledge</returns>
    [EnableQuery]
    public SingleResult<Knowledge> Get([FromODataUri] int key)
    {
        return SingleResult.Create(_context.Knowledges.Where(p => p.ID == key));
    }
```

6. 至此，这个Controller已经支持了CRUD操作，可以打开Postman等操作进行测试了。

同时，可以参阅OData官方文档关于Query Data的方法，使用OData强大的数据检索功能进行读取测试。

 

是为之记。   
Alva Chien   
2019.11.19


