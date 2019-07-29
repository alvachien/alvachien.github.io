---
layout: post
title: How to install Photoshop CS3 on Vista 64bit
date: 2007-09-12 17:43
author: alvachien
comments: true
categories: [64bit, Photoshop, Photoshop, Vista, Windows Platform, 技术Tips]
---
<div>
<h2>Adobe Creative Suite 3 application installer closes with error code 2739 in Windows Vista</h2>
<div>
<h3>Issue</h3>
When you install Adobe Creative Suite 3 or a stand-alone Creative Suite 3 application in Windows Vista, one or more of the following occur:
<ul>
	<li>After you launch the Setup.exe file, the application returns the error message, "This software cannot be installed because JScript is not properly registered. Please repair JScript and then restart the installer"</li>
	<li>The installer quits without an error message, though Setup.exe appears in the Task Manager.</li>
	<li>You receive the error message, "Setup has encountered an error and needs to close. Error Code: 2739."</li>
	<li>Installer log displays the error message, "Error 2739: Could not access JavaScript runtime for custom action"  </li>
</ul>
 
<div>
<h3>Solution</h3>
<strong><em>Disclaimer:</em></strong> This procedure involves editing the Windows registry. Adobe doesn't support editing the registry, which contains critical system and application information. For information on the Windows Registry Editor, see the documentation for Windows or contact Microsoft Technical Support.<strong>Manually register the jscript.dll file.</strong>On Windows Vista32:
<ol>
	<li>Choose Start &gt; All Programs &gt; Accessories.</li>
	<li>Right-click the Command icon, choose Run As Administrator, and authenticate.</li>
	<li>Navigate to Windows\System32.</li>
	<li>At the prompt, type <strong>regsvr32 jscript.dll</strong> and press Enter.</li>
	<li>When a dialog box with the message "DllRegisterServer in jscript.dll succeeded" appears, click OK.</li>
</ol>
On Windows Vista64:
<ol>
	<li>Choose Start &gt; All Programs &gt; Accessories.</li>
	<li>Right-click the Command icon, choose Run As Administrator, and authenticate.</li>
	<li>Navigate to Windows\SysWow64.</li>
	<li>At the prompt, type <strong>regsvr32 jscript.dll</strong> and press Enter.</li>
	<li>When a dialog box with the message "DllRegisterServer in jscript.dll succeeded" appears, click OK.  </li>
</ol>
 
<h3>TechNote Details</h3>
<table cellspacing="0" cellpadding="5">
<tbody>
<tr>
<td>Last Update:</td>
<td>07-09-2007</td>
</tr>
<tr>
<td>ID:</td>
<td>kb401521</td>
</tr>
<tr>
<td>OS:</td>
<td>
<ul>
	<li>Windows Vista</li>
</ul>
</td>
</tr>
<tr>
<td>Permanent Link:</td>
<td><a href="http://www.adobe.com/go/kb401521"><span style="color: #004477;">http://www.adobe.com/go/kb401521</span></a></td>
</tr>
<tr>
<td> </td>
<td> </td>
</tr>
</tbody>
</table>
</div>
</div>
</div>
