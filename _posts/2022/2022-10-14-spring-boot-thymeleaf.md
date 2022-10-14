---
layout: post
title:  "Step by Step Tutorial for Spring Boot and Thymeleaf: Part I"
date:   2022-10-09 21:40:04 +0800
tags: [Web API, Java, Spring, Spring Boot, OAuth]
categories: [技术Tips]
---

学习Spring MVC，也想学习一下Thymeleaf模板，于是，将整个过程记录下来，作为一个Step by Step的Tutorial教程吧。


## 开发环境
- 数据库
本案例中使用Microsoft SQL Server Express。呃，主要原因就是，当前我的电脑上已经安装有（随着Visual Studio安装的），就懒得再去安装额外的数据库系统了。   

如果没有安装SQL Server Express，可以去[SQL Server官网](https://www.microsoft.com/sqlserver)去下载，Express版本是免费的。
- Java SDK，版本选择了11（最新的一个LTS版本）。
- IDE: VS Code，自行下载。
- 版本管理，毫无疑问：Git。
- Maven的下载安装，详见[Apache Maven 官网](https://maven.apache.org/)


## 创建程序

打开[Spring Initalizer](https://start.spring.io/)来创建初始程序：

![初始化程序](/assets/uploads/2022/10/spring-boot-thymeleaf.png)

下载压缩包，将该包解压到对应的目录下。

## 更新POM

参考[《JDBC Driver to SQL Server Express》]({% post_url 2020-11-28-JDBC_SQLServer %})，POM文件需要更新以支持SQL Server。

```xml
<dependency>
    <groupId>com.microsoft.sqlserver</groupId>
    <artifactId>mssql-jdbc</artifactId>
    <version>10.2.1.jre11</version>
    <scope>runtime</scope>
</dependency>
```
