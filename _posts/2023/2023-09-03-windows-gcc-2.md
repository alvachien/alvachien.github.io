---
layout: post
title:  "Windows平台搭建C语言开发环境（基于GCC）"
date:   2023-09-03 10:12:21 +0800
tags: [Windows,开发环境,GCC]
categories: [随心随笔,读书笔记]
---

这篇是[《Windows平台搭建C语言开发环境（基于GCC）》]({% post_url 2023/2023-07-30-windows-gcc %}) 的续篇。

本篇依旧依赖于`MSYS2`。

安装`MSYS2`需要注意的是：     
- 安装目录问题。默认情况下，MSYS2是使用系统盘，这个会给系统盘的容量带来压力，尤其是其会安装额外的Toolchain。    
- 意外的发现。[校园网联合镜像站](https://mirrors.cernet.edu.cn/)，真的是个好聚合网站。譬如可以直接下载Powershell，如果直接下载的话，可能因为文件较大而失败，现在可以选择一个大学的镜像网站（南京大学或上海交通大学都可以）。     
- 镜像设置，并非上篇上所说的三个文件，而是按需修改，通常是四个文件：`mirrorlist.msys`, `mirrorlist.mingw32`, `mirrorlist.mingw64`和`mirrorlist.ucrt64`。这么妖娆的设置是因为每个设置文件的网站URL都是不一样的！    

按照其他工具：    
- 更新`pacman`本身    
    > pacman -Syu    

    与`npm`类似，`pacman`自身也需要更新。

- 安装`mingw-w64-x86_64-toolchain` 或者：
    > pacman -S --needed base-devel mingw-w64-x86_64-toolchain    

    此步骤安装所有需要的（也可以在交互式命令行选择安装）所有必须的工具。    
    ![Toolchain](/assets/uploads/2023/09/2023-09-03-01.jpg)     


- 分别安装`GCC`, `GDB`和`CMake`
    > pacman -S mingw-w64-ucrt-x86_64-gcc   
    > pacman -S mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-ninja   

注意，这里安装的是现在流行的`CMake`，尽管这个名字容易跟之前`Make`混淆。
    - CMake [官网](https://cmake.org/)     
    - 如果想学习CMake，官方文档不靠谱，推荐[<CMake Cook Book>](https://www.bookstack.cn/read/CMake-Cookbook/README.md)和[<Modern CMake for Cpp>](https://github.com/xiaoweiChen/Modern-CMake-for-Cpp/releases)这两本书。   

另外，罗列下`pacman`常用的命令：
    pacman -Sy 更新软件包数据 
    pacman -Syu 更新所有 
    pacman -Ss xx 查询软件xx的信息 
    pacman -S xx 安装软件xx
    pacman -R xx 删除软件xx

配置Visual Studio Code：    
- Extension: CMake Tools     
    ![CMake Tools](/assets/uploads/2023/09/2023-09-03-02.jpg)     
- 配置Compiler路径    
    打开VSCode的Preference，搜索`C/C++`：    
    ![Compiler](/assets/uploads/2023/09/2023-09-03-03.jpg)     
- 配置CMake   
    打开VSCode的Preference，搜索`CMake`。如果上面的Compiler配置完成，系统会自动推荐CMake的配置。    

开发流程：
1. 新建一个项目文件夹。
2. 使用VSCode打开该文件夹。
3. 新建`src`子文件夹，并在其中添加`*.c`源代码。
4. 新建`CMakeLists.txt`文件(这里只添加一个文件`hello.c`并制定最后生成的文件为`helloworld`)：
```txt
cmake_minimum_required(VERSION 3.5)
 
# 设置项目名称
project(01-start)
 
# 添加源代码文件
add_executable(helloworld src/hello.c)
```
5. 右击`CMakeLists.txt`，可以执行相关命令。
6. 在VSCode的底部，可以执行`run`和`debug`指令。    
![Run](/assets/uploads/2023/09/2023-09-03-04.jpg)     

是为之记。   
Alva Chien    
2023.9.3   
