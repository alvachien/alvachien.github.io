---
layout: post
title: How to install Photoshop CS3 on Vista 64bit
date: 2007-09-12 17:43
author: alvachien
comments: true
tags: [64bit, Photoshop, Vista, Windows Platform]
categories: [技术Tips]
---
### Adobe Creative Suite 3 application installer closes with error code 2739 in Windows Vista

#### Issue
When you install Adobe Creative Suite 3 or a stand-alone Creative Suite 3 application in Windows Vista, one or more of the following occur:

- After you launch the Setup.exe file, the application returns the error message, "This software cannot be installed because JScript is not properly registered. Please repair JScript and then restart the installer"
- The installer quits without an error message, though Setup.exe appears in the Task Manager.
- You receive the error message, "Setup has encountered an error and needs to close. Error Code: 2739."
- Installer log displays the error message, "Error 2739: Could not access JavaScript runtime for custom action"  
 

#### Solution
**Disclaimer:** This procedure involves editing the Windows registry. Adobe doesn't support editing the registry, which contains critical system and application information. For information on the Windows Registry Editor, see the documentation for Windows or contact Microsoft Technical Support.**Manually register the jscript.dll file.**On Windows Vista32:

- Choose Start &gt; All Programs &gt; Accessories.
- Right-click the Command icon, choose Run As Administrator, and authenticate.
- Navigate to Windows\System32.
- At the prompt, type **regsvr32 jscript.dll** and press Enter.
- When a dialog box with the message "DllRegisterServer in jscript.dll succeeded" appears, click OK.

On Windows Vista64:
- Choose Start &gt; All Programs &gt; Accessories.
- Right-click the Command icon, choose Run As Administrator, and authenticate.
- Navigate to Windows\SysWow64.
- At the prompt, type **regsvr32 jscript.dll** and press Enter.
- When a dialog box with the message "DllRegisterServer in jscript.dll succeeded" appears, click OK.  
 
#### TechNote Details
|Name|Value|
|---|---|
|Last Updaed:|07-09-2007|
|ID:|kb401521|
|OS:|Windows Vista|
|Permanent Link:|[Link](https://www.adobe.com/go/kb401521)|

