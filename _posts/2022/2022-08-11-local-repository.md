---
layout: post
title:  "Maven浅窥四：将本地archetype添加到Repository"
date:   2022-08-11 21:41:17 +0800
tags: [Maven]
categories: [技术Tips]
---

将本地的archetyp安装到本地的Repository：
```cmd
mvn clean install archetype:update-local-catalog
```

一个例子，将Github的[Olingo JPA Processor](https://github.com/SAP/olingo-jpa-processor-v4)，先Clone到本地，通过命令行跳转到指定目录：
```cmd
cd git\olingo-jpa-processor-v4\jpa-archetype\odata-jpa-archetype-spring
```

然后执行上述命令：
```cmd
mvn clean install archetype:update-local-catalog
```

然而，这时去检查.m2目录下的`archetype-catalog.xml`，会发现，该文件并未生成。

这时需要跳转到项目个根目录：    
```cmd
cd git\olingo-jpa-processor-v4\jpa-archetype
```

然后更新：

```cmd
mvn archetype:crawl
```
