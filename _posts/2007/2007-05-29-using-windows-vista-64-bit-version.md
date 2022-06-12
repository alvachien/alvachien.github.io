---
layout: post
title: Using Windows Vista 64-bit Version
date: 2007-05-29 17:05
author: alvachien
comments: true
tags: [64bit, C++, Vista, Windows, Windows Platform]
categories: [技术Tips]
---
Finally, I got the 64-bit Windows Vista Home Premium to instead of the unactived version, and it's great that the new OS supports 4G memory very well.
 
However, there comes lots of other issues I have met:
1. Concerning the language input, only Microsoft ships the 64-bit version PinYin method.
2. Internet Explorer 64-bit should be the most pure and safe web browser, because lots of web controls can't fit the capability with this version, for example, the most used control - Adobe Flash Player can not run on that.
3. Windows Media Player 11 which shiped with Vista looks strange, it can not set the advanced options while the lower version of WMP do support.
4. The drivers are limited, of course, the biggest producer, such as Intel, nVidia has released their own 64bit Vista solution. In fact, the drivers which support Vista is significant less than Windows XP, and 64-bit OS make thing worst.
5. Some applications didn't support Vista at all, even Microsoft Visual Studio 2005 and SQL Server 2005. Fortunately, Microsoft offers the service package to fit it. But it is quite different with the other products, for example, nVidia PureVideo Decoder is a powerful decode which will enable the PureVideo of nVidia graphics cards when playing HD solution video files, but the decoder do not support Vista. Of course, some games will be refuse to install or run for they can not recognize the DirextX 10.
6. The key point, performance issues. From my own test, lots of application supports 64-bit Vista, but all run on WOW64 - a new technology offered by Microsoft to run Win32 application upon x64 or IA64 OS, it is obvious the performance will lost for the transportion. I didn't read out the official paper from Microsoft, but a third party report says, the performance lost is limited, and can be omitted with compared to Windows XP, and this third party test upon the wide-used softwares, such as Microsoft Office, Adobe Photoshop. For my point of view, this result is acceptable but still need enhancement.
7. For my own applications, they all fall into the hell. Because a CPU-neutral .NET application run on 64-bit OS, the OS will start a 64-bit address space, unfortunately, I realize the IO part using C++ under Win32 solution. The 64-bit address space can not load a Win32 module and vice versa. It seems I need hard work to do.
 
As a conclusion, it will need another 2-3 years then 64-bit can be populars.

