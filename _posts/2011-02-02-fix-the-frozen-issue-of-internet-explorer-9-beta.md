---
layout: post
title: Fix the Frozen issue of Internet Explorer 9 Beta 
date: 2011-02-02 13:14
author: alvachien
comments: true
categories: [IE, Windows Platform, 技术Tips]
---
<p>Download URL for IE9 Beta: http://windows.microsoft.com/ie9</p>
<p>It's frequently frozen during running IE9 beta, from my test, this case occurred during switching the tabs. It's very unacceptable for this big issue of usability. So, I have to find the way out to get the IE9 runs smoothly. After several hours research, here comes the way to fix it:</p>
<p>1. Running IE9 without addons. On Windows 7 platform, 'Start' menu, 'All Programs', choose 'Accessories', then 'System Tools', 'Internet Explorer (No Add-ons) '. Or, professional way, input 'iexplore.exe -extoff' in Run command box directly.</p>
<p>2. Switch off the GPU rendering, lower performance but more stable. In 'Internet Options ' dialog (the command line to lauch it directly: inetcpl.cpl), switch off the check box: 'Use software rendering instead of GPU rendering' in 'Advance' tab.</p>
<p>It should works fine according to my experience.</p>
<p>Alva Chien<br />
2011.02.02</p>

