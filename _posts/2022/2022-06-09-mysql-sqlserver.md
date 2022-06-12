---
layout: post
title:  My SQL 转SQL Server的一些常见问题
date:   2022-06-09 16:09:27 +0800
tags: [MySQL, SQL Server]
categories: [技术Tips]
---

学习JDBC的时候，课程上用了MySQL，但是我的机器只装了SQL Server Express，懒得再装一个MySQL，于是打算把MySQL用的Script稍加修改变成T-SQL可用的：

- 数据类型: int, smallint
MySQL支持定义int, smallint的时候指定长度。而T-SQL不支持。
解决方法：移除int, smallint的长度即可。


- 数据类型：mediumtext, mediumblob
MySQL支持类型mediumtext, meidumblob，但是T-SQL不支持。
解决方法：将mediumtext其转为text, 而mediumblob转为image或varbinary(max)都可以。

- 标识符： “`”
MySQL默认的标识符为“`”，而T-SQL中一般使用"[]"来表示。
这里直接进行文本替换会有麻烦，可以直接将“`”删除。

- 转义符：“\”
MySQL默认使用“\"作为”'"的转义符，而T-SQL一般使用”'"。

```sql
select 'test ''test''' as column_text from DUMMY
```

- T-SQL的插入限制

当使用T-SQL的INSERT语句一下子插入很多行的时候，会遇到错误：

```log
The number of row value expressions in the INSERT statement exceeds the maximum allowed number of 1000 row values.
```

解决方法：
```sql
INSERT table(col1, col2) 
SELECT * FROM 
values (
-- It support more than 1000 rows    
) AS t(col1, col2)
```

