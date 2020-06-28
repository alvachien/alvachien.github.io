---
layout: post
title:  "OData UPDATE/PATCH不返回更新后的结果"
date:   2020-06-20 16:30:27 +0800
tags: [OData]
categories: [技术Tips]
---

OData的Controller影响HTTP verb中UPDATE和Patch时候，如果使用Updated(entity)的写法，则该Request只返回status code，并不会返回更新后的结果。

示例代码如下：

```C#
    [Authorize]
    public async Task<IActionResult> Patch([FromODataUri] int key, [FromBody] Delta<FinanceAccount> coll)
    {
        if (!ModelState.IsValid)
        {
            // Error handling
        }

        var entity = await _context.FinanceAccount.FindAsync(key);
        if (entity == null)
        {
            return NotFound();
        }

        // Patch it
        coll.Patch(entity);

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!_context.FinanceAccount.Any(p => p.ID == key))
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

其实这并非OData API本身的问题，是调用者必须在header中显式要求:

```typescript
    let headers: HttpHeaders = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json')
      .append('Accept', 'application/json')
      .append('Prefer', 'return=representation');
```

是为之记。   
Alva Chien   
2020.06.20
