---
layout: post
title:  "创建基于OData的Web API - Knowledge Builder API, Part VII, 用Postman测试"
date:   2020-07-05 20:17:22 +0800
tags: [OData, Web API, Knowledge Builder, Postman]
categories: [技术Tips]
---

本系列之前的文章：

- 第一篇 [Part I:  业务场景和存储层设计]({% post_url 2019/2019-11-03-ODataBasedAPI1 %}) 

- 第二篇 [Part II:  开发环境及项目设置]({% post_url 2019/2019-11-04-ODataBasedAPI2 %}) 

- 第三篇 [Part III:  Model类]({% post_url 2019/2019-11-06-ODataBasedAPI3 %}) 

- 第四篇 [Part IV: Data Context]({% post_url 2019/2019-11-07-ODataBasedAPI4 %})

- 第五篇 [Part V: Controller]({% post_url 2020/2020-07-03-ODataBasedAPI5 %}) 

- 第六篇 [Part VI: 为Controller添加CRUD]({% post_url 2020/2020-07-04-ODataBasedAPI6 %}) 


在之前的基础上，可以对该OData API的几个Entity进行测试了。


这里，使用了[Postman](https://www.postman.com/)。


建议对该API的所有测试加入一个独立的Collection。


对于Knowledge Item，测试创建 （HTTP POST），使用如下资料，并获得Status 201 Created：

![Pic](/assets/uploads/2020/07/odata_post.JPG)


对Knowledge Item，测试GET拿到所有Knowledge Item，这时候会有一条（刚刚创建的那条）。

![Pic](/assets/uploads/2020/07/odata_get.JPG)


测试修改（HTTP PUT），更新刚刚创建的那条，把Content修改。

![Pic](/assets/uploads/2020/07/odata_put.JPG)

这时候，试试再次GET，对应的Content已经被修改：

![Pic](/assets/uploads/2020/07/odata_get2.JPG)


测试第二种修改方式（HTTP PATCH），再次更新CONTENT：

![Pic](/assets/uploads/2020/07/odata_patch.JPG)


第三次GET，对应的Content已经被修改：

![Pic](/assets/uploads/2020/07/odata_get3.JPG)


最后，删除该条记录（HTTP DELETE）：

![Pic](/assets/uploads/2020/07/odata_delete.JPG)

第四次GET，对应的Content已经被修改：

![Pic](/assets/uploads/2020/07/odata_get4.JPG)


这次，Postman的Collection应该有五条测试记录：

![Pic](/assets/uploads/2020/07/odata_postman_collection.JPG)


同时，使用OData Query来体现OData的强大：

![Pic](/assets/uploads/2020/07/odata_get5.JPG)

下一篇要开始介绍Unit Test了。


是为之记。   
Alva Chien    
2020.07.05   
更新于2020.12.17   
