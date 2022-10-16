---
layout: post
title:  "创建基于Spring Boot的OData Web API - Library API, Part I：业务场景和存储层设计"
date:   2022-07-24 16:04:17 +0800
tags: [OData, Web API, Spring, Olingo]
categories: [技术Tips]
---

两三年前，当我开始熟悉.Net Core和基于ASP.NET Core的OData API时，曾经通过实现一个项目的方式来锻炼自己，而且写过一系列文档来详细讲述自己的实现步骤：   
- 第一篇 [Part I:  业务场景和存储层设计]({% post_url 2019/2019-11-03-ODataBasedAPI1 %}) 
- 第二篇 [Part II:  开发环境及项目设置]({% post_url 2019/2019-11-04-ODataBasedAPI2 %}) 
- 第三篇 [Part III:  Model类]({% post_url 2019/2019-11-06-ODataBasedAPI3 %}) 
- 第四篇 [Part IV: Data Context]({% post_url 2019/2019-11-07-ODataBasedAPI4 %})
- 第五篇 [Part V: Controller]({% post_url 2020/2020-07-03-ODataBasedAPI5 %}) 
- 第六篇 [Part VI: 为Controller添加CRUD]({% post_url 2020/2020-07-04-ODataBasedAPI6 %}) 
- 第七篇 [Part VII: 用Postman测试]({% post_url 2020/2020-07-05-ODataBasedAPI7 %}) 
- 第八篇 [Part VIII: Unit Test准备]({% post_url 2020/2020-07-06-ODataBasedAPI8 %}) 
- 第九篇 [Part IX: Angular程序环境准备]({% post_url 2020/2020-07-14-ODataBasedAPI9 %})
- 第十篇 [Part X: 完善Angular程序]({% post_url 2020/2020-07-15-ODataBasedAPI10 %})
- 第十一篇 [Part XI: 为API添加CORS支持]({% post_url 2020/2020-07-16-ODataBasedAPI11 %})
- 第十二篇 [Part XII, Angular程序的List和Detail页面]({% post_url 2020/2020-07-19-ODataBasedAPI12 %})

这次，开始学习Spring Boot，打算效仿一下当年的自己，也准备通过实现一个项目加一系列文档的方式来记录下进程。

## 业务场景 Business Scenario

> 书中只有颜如玉，书中只有黄金屋。


读书，是一个爱好，变成了我们人生的一份，也变成了一种生活态度。看电影，也是一样。  
一个系统来保存当前的藏书，也是必须的。如果能保存读书笔记或观影记录，那是更好的了。当然，虽然冠以Library的标题，并非做一个图书馆系统，只是一个简单的家用的藏书记录。

所以，从业务场景来看，或者直接了当地从我们买书、藏书的过程来看，以下功能点是必须的：

- 图书。分门别类、结构化的图书记录；
- 影视作品。结构化的影视作品记录；
- 人物。这里的人物是指：图书的作者、译者；影视作品中的各类司职。


Library Builder，就是符合上述业务场景的。它是一个用来创建、维护、浏览、测试和巩固各种图书和影视作品的Web App。而Library Builder API是服务于其需求的API。

它包含这么几种类型的对象：   
- Book。图书。
- Person。人物。
- Organization。组织。

## 存储层设计 Database table design

### 图书 Book

```sql
CREATE TABLE [Book] (
    [ID]            INT            IDENTITY (1, 1) NOT NULL,
    [native_name]   NVARCHAR(200)  NOT NULL,
    [chinese_name]  NVARCHAR(200)  NULL,
    [Detail]        NVARCHAR(200)  NULL,
    [CreatedAt]     DATETIME       DEFAULT (getdate()) NULL,
    [ModifiedAt]    DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);
```

### 人物 Person

```sql
CREATE TABLE [Person] (
    [ID]            INT            IDENTITY (1, 1) NOT NULL,
    [native_name]   NVARCHAR(200)  NOT NULL,
    [chinese_name]  NVARCHAR(200)  NULL,
    [Detail]        NVARCHAR(200)  NULL,
    [CreatedAt]     DATETIME       DEFAULT (getdate()) NULL,
    [ModifiedAt]    DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);
```

## 开发环境 Development Environment

开发环境基于Spring Boot:  

- [Spring Boot](https://spring.io/projects/spring-boot)
- [Apache Olingo](https://olingo.apache.org/)
- [OpenJava SDK, Microsoft Build](https://www.microsoft.com/openjdk)
- [SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-2019)
- [SQL Server JDBC Driver](https://docs.microsoft.com/en-us/sql/connect/jdbc/download-microsoft-jdbc-driver-for-sql-server)


POM文件如下：   

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>2.7.2</version>
		<relativePath/> <!-- lookup parent from repository -->
	</parent>
	<groupId>com.alvachien</groupId>
	<artifactId>library</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<name>Library</name>
	<description>Demo project for Spring Boot</description>
	<properties>
		<java.version>11</java.version>
		<olingo.version>4.9.0</olingo.version>
	</properties>
	<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-data-jpa</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>

		<dependency>
			<groupId>com.microsoft.sqlserver</groupId>
			<artifactId>mssql-jdbc</artifactId>
			<version>10.2.1.jre11</version>
			<scope>runtime</scope>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>
		<dependency>
			<groupId>org.apache.olingo</groupId>
			<artifactId>odata-commons-api</artifactId>
			<version>${olingo.version}</version>
		</dependency>
		<dependency>
			<groupId>org.apache.olingo</groupId>
			<artifactId>odata-commons-core</artifactId>
			<version>${olingo.version}</version>
		</dependency>
		<dependency>
			<groupId>org.apache.olingo</groupId>
			<artifactId>odata-server-api</artifactId>
			<version>${olingo.version}</version>
			<scope>compile</scope>
		</dependency>
		<dependency>
			<groupId>org.apache.olingo</groupId>
			<artifactId>odata-server-core</artifactId>
			<version>${olingo.version}</version>
			<scope>runtime</scope>
		</dependency>
	</dependencies>

	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>
</project>

```

## 源代码 Source Repo

源代码的Repository：<https://github.com/alvachien/libraryapi>

