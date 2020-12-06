---
layout: post
title:  "JDBC Driver to SQL Server Express, Part II"
date:   2020-12-05 23:44:22 +0800
tags: [Java, SQL Server]
categories: [技术Tips]
---

基于前一篇[《JDBC Driver to SQL Server Express》]({% post_url 2020-11-28-JDBC_SQLServer %})，已经可以尝试使用SQL Server Express了。


## SQLServerDriver VS DriverManager VS DataSource

Based on [Working with a connection](https://docs.microsoft.com/en-us/sql/connect/jdbc/working-with-a-connection) in SQL Server documentation:


Connect SQL Server Express via DriverManager,

```java
Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");  
String connectionUrl = "jdbc:sqlserver://localhost;database=AdventureWorks;integratedSecurity=true;"  
Connection con = DriverManager.getConnection(connectionUrl);
```

Connect SQL Server Express via SQLServerDriver,

```java
Driver d = (Driver) Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver").newInstance();  
String connectionUrl = "jdbc:sqlserver://localhost;database=AdventureWorks;integratedSecurity=true;"  
Connection con = d.connect(connectionUrl, new Properties());
```


Connect SQL Server Express via SQLServerDataSource: 

```java
SQLServerDataSource ds = new SQLServerDataSource();  
ds.setUser("MyUserName");  
ds.setPassword("*****");  
ds.setServerName("localhost");  
ds.setPortNumber(1433);
ds.setDatabaseName("AdventureWorks");  
Connection con = ds.getConnection();
```

除了使用Name/Password之外，还可以使用Integrated Security来登陆(注意，需要额外配置才能正常工作，查阅下面内容）：   


```java
ds.setIntegratedSecurity(true);
ds.setServerName("STUDYPC_201603\\SQLEXPRESS");  
ds.setDatabaseName(jdbcDatabase);
```


## TCP/IP 

SQL Server的JDBC Driver需要TCP/IP。

基于[Trouble Shooting](https://docs.microsoft.com/en-us/sql/connect/jdbc/troubleshooting-connectivity)，TCP/IP必须配置。   

> The Microsoft JDBC Driver for SQL Server requires that TCP/IP be installed and running to communicate with your SQL Server database. You can use the SQL Server Configuration Manager to verify which network library protocols are installed.

打开TCP/IP，需要SQL Server Configuration Manager。

而基于[文档](https://docs.microsoft.com/en-us/sql/relational-databases/sql-server-configuration-manager)，新的SQL Server Configuration Manager并没有额外的程序，而是提供了一系列的MSC文件。

|Version|Path|
|--|--|
|SQL Server 2019|C:\Windows\SysWOW64\SQLServerManager15.msc|
|SQL Server 2017|C:\Windows\SysWOW64\SQLServerManager14.msc|
|SQL Server 2016|C:\Windows\SysWOW64\SQLServerManager13.msc|
|SQL Server 2014 (12.x)|C:\Windows\SysWOW64\SQLServerManager12.msc|
|SQL Server 2012 (11.x)|C:\Windows\SysWOW64\SQLServerManager11.msc|

打开MSC文件，即可进行相应的配置。


## Integrated Security

SQL Server的Logon可以基于Windows是认证。这时不需要输入用户名和密码。这个在开发环境还是相当好用的，不需要额外配置开发环境的用户名和密码，更不需要将这些信息存储下来(如app.properties等等)。因为这些信息上传git的时候很麻烦。


然而，直接设置Integrated Security并不能正常工作。根本原因是JDK的路径下找不到mssql-jdbc-auth-xxx.dll（xxx是版本号）。


如果SQL Server Driver是Maven下安装的，那么上述DLL并不存在。换言之，上述DLL并不属于JAR的一部分。打开Maven的Repository目录并没有DLL：
> .m2\repository\com\microsoft\sqlserver\mssql-jdbc\8.4.1.jre11

这时，只能去官方去下载[Link](https://docs.microsoft.com/en-us/sql/connect/jdbc/download-microsoft-jdbc-driver-for-sql-server?view=sql-server-ver15#using-the-jdbc-driver-with-maven-central)


然后复制上述DLL到*JAVA_HOME\bin*下。

## 示例Repo


示例Repo见：[https://github.com/alvachien/learning-notes/tree/master/spring-tutorial/fifth-example](https://github.com/alvachien/learning-notes/tree/master/spring-tutorial/fifth-example)



