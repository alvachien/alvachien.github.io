---
layout: post
title:  "创建基于OData的Web API - Knowledge Builder API, Part XI, 添加CORS"
date:   2020-07-16 22:26:22 +0800
tags: [Angular, Knowledge Builder, OData]
categories: [技术Tips]
---

上一篇[《完善Angular程序》]({% post_url 2020-07-15-ODataBasedAPI10 %})，遇到了Angular程序没法正常访问API的问题，这时候就需要修改API，让它能接受Angular 程序，Knowledge Builder，的访问。


首先，在Startup.cs中，在ConfigureServices中，定义了一个名叫TEST的CORS Policy，并在该Policy指明接受端口4200：   

```C#
    services.AddCors(options =>
    {
        options.AddPolicy("TEST", builder =>
        {
            builder.WithOrigins("http://localhost:4200")
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowCredentials();
        });
    });
```

这里接受了4200端口，因为Knowledge Builder程序默认使用了4200端口。


在angular.json中，可以修改Angular 程序的端口为4201，这时候，上述函数中的端口也要相应的修改为4201：    

```json
    "serve": {
        "builder": "@angular-devkit/build-angular:dev-server",
        "options": {
            "browserTarget": "knowledgebuilder:build",
            "port": 4201,
            "host": "localhost"
        },
        "configurations": {
            "production": {
                "browserTarget": "knowledgebuilder:build:production"
            }
        }
    },
```

然后，在Startup.cs中，继续修改Configure函数：    

```C#
    app.UseCors("TEST");
```

这时候，再次运行Knowledge Builder程序，API已经可以访问了。


下一篇将完善List View，使得页面能够从API获取真实数据。


是为之记。   
Alva Chien    
2020.07.16
