---
layout: post
title:  创建基于OData的Web API - Knowledge Builder API, Part II,Project Setup
date:   2019-11-04 16:19:17 +0800
tags: [OData, Web API]
categories: [技术Tips]
---
本篇为Part II：Project Setup
查看第一篇 [Part I:  Business Scenario]({% post_url 2019-11-03-ODataBasedAPII.md %}) 


## 第一步，准备步骤
### 准备步骤一，准备步骤。

准备步骤一，下载.NET Core 2.2 SDK；

官方网址是：[https://dot.net](https://dot.net) (貌似会redirect去[https://dotnet.microsoft.com/](https://dotnet.microsoft.com/) ），选择Download .NET Core 2.2 SDK，并正确安装。


### 准备步骤二，下载SQL Server 2017 Express；

SQL Server的官方网址是：[https://www.microsoft.com/en-us/sql-server/](https://www.microsoft.com/en-us/sql-server/)
数据库的选择因人而异，这里选择MS免费的SQL Server Express。虽然也有SQL Server 2019 Preview版本，但考虑Preview版本不是RC版本，稳定性上，不建议选择。

MySQL是另外一个选择。但是选择SQL Server Express 的优点是官方指代的Library就够用了。

注意，安装数据库时候，默认安装一个instance。

 

### 准备步骤三，下载Visual Studio Community OR Visual Studio Express

个人推荐Visual Studio Code。

虽然Visual Studio Community应该更合适，但是考虑到熟悉命令行显然更便于将来切换到non-Windows平台上。

另外，Visual Studio Community 2017的臭名昭著的卸载问题，也是放弃其的一个原因。

 

## 第二步，创建Project

ASP.NET Core 官方的Tutorial文档：https://docs.microsoft.com/en-us/aspnet/core/tutorials/first-web-api?view=aspnetcore-3.0&tabs=visual-studio-code

EF Core官方Tutorial：https://docs.microsoft.com/en-us/ef/core/get-started/?tabs=netcore-cli

OData官方Getting Started：https://docs.microsoft.com/en-us/odata/webapi/netcore

本文列出的创建步骤综合考虑了上述三大文档，得出整个项目设置流程如下命令（逐一执行）。

```powershell
mkdir KnowledgeBuilderAPI
cd KnowledgeBuilderAPI
dotnet new sln
dotnet new webapi -o KnowledgeBuilderAPI
cd KnowledgeBuilderAPI
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.InMemory
dotnet add package Microsoft.AspNetCore.OData --version 7.3.0-beta
cd ..
dotnet sln add ./KnowledgeBuilderAPI/KnowledgeBuilderAPI.csproj
mkdir KnowledgeBuilderAPI.Test
cd KnowledgeBuilderAPI.Test
dotnet new xunit
dotnet add reference ../KnowledgeBuilderAPI/KnowledgeBuilderAPI.csproj
cd ..
dotnet sln add ./KnowledgeBuilderAPI.Test/KnowledgeBuilderAPI.Test.csproj
code -r ../KnowledgeBuilderAPI
```

注意， 上述步骤只适用.NET Core 3.0和OData 7.3.0 Beta。因为OData 之前的版本 (7.3.0以前的版本）不支持.NET Core 3.0 (Routing)，在.NETCore 2.2版本下，两个csproj文件分别为：

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>netcoreapp2.2</TargetFramework>
    <AspNetCoreHostingModel>InProcess</AspNetCoreHostingModel>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.AspNetCore.App" />
    <PackageReference Include="Microsoft.AspNetCore.Razor.Design" Version="2.2.0" PrivateAssets="All" />
    <PackageReference Include="Microsoft.AspNetCore.OData" Version="7.2.2" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.InMemory" Version="2.2.0" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="2.2.0" />
  </ItemGroup>
</Project>
```


Test project如下：

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">

  <PropertyGroup>
    <TargetFramework>netcoreapp2.2</TargetFramework>

    <IsPackable>false</IsPackable>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.AspNetCore.App" />
    <PackageReference Include="Microsoft.AspNetCore.Mvc.Testing" Version="2.2.0" />
    <PackageReference Include="xunit" Version="2.4.1" />
    <PackageReference Include="xunit.runner.visualstudio" Version="2.4.1" />
  </ItemGroup>

  <ItemGroup>
    <ProjectReference Include="..\knowledgebuilderapi\knowledgebuilderapi.csproj" />
  </ItemGroup>

</Project>
```
 

## 第三步，针对开发环境，使用Secret Manager tool

执行命令：
```powershell
dotnet user-secrets init
```

这条命令会在当前目录下的项目文件(*.csproj)中加入一条。

```xml
<PropertyGroup>
  <UserSecretsId>xxxxxxxxxx</UserSecretsId>
</PropertyGroup>
```

同时，可以查看文件：

%APPDATA%\Microsoft\UserSecrets\<user_secrets_id>\secrets.json
通过命令往其中增加内容，对这个项目来说，是增加Connection String。

```powershell
dotnet user-secrets set "KnwoledgeBuilderAPI:ConnectionString" "Server=.\SQLEXPRESS;Database=knowledgebuilder;Trusted_Connection=True;"
```

如果想要删除该Connection String，调用命令：

```powershell
dotnet user-secrets remove
```

另外两个有用的命令是：
list - 显示当前所有值

```powershell
dotnet user-secrets list
```

clear - 清除所有☞
```powershell
dotnet user-secrets clear
```

至此，一个粗略的项目框架已经ready，可以跑

```powershell
dotnet run
```

来运行了，也可以使用

```powershell
dotnet test
```

来测试。

 

下一篇将讲述如何开发Model。


是为之记。
Alva Chien
2019.11.04

