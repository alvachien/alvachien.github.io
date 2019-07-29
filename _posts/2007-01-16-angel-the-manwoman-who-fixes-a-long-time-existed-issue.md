---
layout: post
title: Angel_The man/woman who fixes a long-time existed issue
date: 2007-01-16 16:50
author: alvachien
comments: true
categories: [C++, Microsoft.NET, Windows Platform, 技术Tips]
---
After I decide to reinstall the OS system to get rid of the strange problem which occurred only video file playback with the new Graphics Card (Nvidia GeForce 7600 GS, AGP 8X), it takes about 1 hours to do the preparation. And I could not find out the English OS disc, so I have to choose Chinese version as an instead. 
 
After the new OS installation is completed, install the Graphics driver, the latest version from the official site, restart, test it. Dumps again. Remove the driver, choose a older one, which is shipped with the product CD, but the issue is appeared still. 
 
Then, search it out via BaiDu.com in Chinese description, no directly answer; search it around the producer's web site, still no answer. Go to Microsoft's update site, for some all-known reasons, it refused to offer me an opportunity to get the customize update. Disappointed! But suddenly an idea is shot at my mind, that is install the motherboard's driver! 
 
Make every possible efforts, I choose to try it, reboot the OS as usual. Then, the unbelievable result comes! It works. When the video play back works properly, I can not help laughing and cheering! To make it sure, I download some HD files from Microsoft site for testing : <a href="http://www.microsoft.com/windows/windowsmedia/musicandvideo/hdvideo/contentshowcase.aspx">http://www.microsoft.com/windows/windowsmedia/musicandvideo/hdvideo/contentshowcase.aspx</a>
 
I also solve a software issue meaning while, that is, calling an external DLL in .NET framework always get a crash, check all the codes are fine, but however, I find the way to solve it. First, for the DLL built with C++, the exported function always be changed via extension, so using <span style="color: #0000ff;">'extern "C" {}' syntax to correct it. Second, if the DLL dependence on the other DLLs, make sure the dependence DLL are located on the searchable paths.
 
The last thing need to celebrate is the NFS 9 (Most wanted) has been installed successfully. It also a reason why I choose to reinstall the OS. It is so strange that the setup of NFS 9 will failed always, even I have copied all the files into the hard disc. And I checked the install file, I found the file content is CRC validation error. Now in the newly installed OS, it has been installed successfully. And I got the English version of NFS 9 finally, that also means I can run it in my XBOX 360 even I can't read out the Japanese character at all.
 
So great, right? 
