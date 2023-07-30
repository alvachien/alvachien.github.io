---
layout: post
title:  "Windows平台搭建C语言开发环境（基于GCC）"
date:   2023-07-30 10:12:21 +0800
tags: [Windows,开发环境,GCC]
categories: [随心随笔,读书笔记]
---

看到一本《啊哈C语言！》的编程科普的图书，便想着如何帮着娃们入门编程这么课——毕竟C语言是编程语言的鼻祖，入下门还是很值得。

要学习编程，总归要搭建开发环境的。《啊哈》这本书提供了卡通版的编译器。但是，这显然不符合我的要求——万一入门不够，需要进阶呢？

于是开始着手搭建自己理想的Windows平台的C语音开发环境。显然，Visual Studio Community是另外一个可选项，但是微软一贯的尿性，免费的Tools糅杂了自家的广告，更难受的是，Visual Studio Community并不符合C语言标准。于是剩下的选择就是：GCC编译器加一个流行的代码编辑器（Visual Studio Code）。

Visual Studio Code随处可见，随处可以下载。那GCC编译器呢？

随便一搜，就看到Mingw-w64是GCC在Windows的实现。   
[Mingw-w64](https://www.mingw-w64.org/)

可是，当打开其[downloads页面](https://www.mingw-w64.org/downloads/)，首先出现的一系列的ToolsChain。   

![Mingw-w64 downloads](/assets/uploads/2023/07/mingw-download.jpg)


到处扫盲式的收缩了一遍，发现一般选择两个选项：
- MingW-W64-builds, [Github linkage](https://github.com/niXman/mingw-builds-binaries/releases)，能不能顺利下载，全靠当前机器与Github的链接的可靠程度；
- MSYS2, [linkage](https://www.msys2.org/)。这是个工具集，不过这个工具包国内有很多mirror，譬如[Index of /msys2/ | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/msys2/)

MSYS2的安装很简单：
- 运行下载的Exe到结束； 
- 默认会打开一个`UCRT64`的环境。这里的UCRT指的是环境——支持的C的运行时库和C++运行时库。    
![Enviroments](/assets/uploads/2023/07/msys2_env.jpg)
- 这时还需要额外运行命令（在上面打开的环境里面）：
> pacman -S mingw-w64-ucrt-x86_64-gcc
`pacman`是MSYS2依赖的一个包安装器。 通常，这里下载和会比较快。万一不快的，需要去`\etc\pacman.d`文件夹修改mirror地址（三个文件：`mirrorlist.msys`，`mirrorlist.mingw32`, `mirrorlist.mingw64`），使用上述清华的镜像地址。

完成之后，在系统Path添加gcc：`{install_dir}\msys64\ucrt64\bin`。 这里跟网上查到的不同，需要注意一下。

搞定了GCC之后，轮到Visual Studio Code了，安装`C/C++ Extension Pack`，微软官方出品。

先写到这里。

是为之记。   
Alva Chien    
2023.7.30   