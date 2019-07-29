---
layout: post
title: Enabling PHP Debugging in PDT (Using XDebug)
date: 2015-05-16 21:25
author: alvachien
comments: true
categories: [Eclipse, PDT, PHP, Web Development, XDebug]
---
First of all, read the official document provided by Eclipse: http://wiki.eclipse.org/Debugging_using_XDebug

Then, download the XDebug binaries, Link: http://xdebug.org/download.php

There are lots of choice actually. Therefore, you need run phpinfo() to ensure your PHP version first. As the snapshot shows below, it is a 32-bit (X86), built with MSVC11 (Visual C++ 2012). The TS/NTS choice depends on the 'Thread Safety" of the PHP again.

<a href="http://www.alvachien.com/alvablog/wp-content/uploads/2015/05/PhpInfo.jpg"><img class="alignnone size-full wp-image-1778" src="http://www.alvachien.com/alvablog/wp-content/uploads/2015/05/PhpInfo.jpg" alt="PhpInfo" width="935" height="216" /></a>

After you get the binary file of XDebug, in this case, the DLL file. Copy it the "ext" folder of you PHP installation.

The next step is, enable the extension in the PHP.ini. And restart the Apache server to make it work.

Add the following part:

[XDebug]
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_port=9000

Then, go to set the PDT.

是为之记。
Alva Chien
2015.5.16
