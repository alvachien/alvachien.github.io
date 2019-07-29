---
layout: post
title: "Visual C# 2010 Express 切换Configuration和Platform: Debug/Release, Any CPU/X86/X64/Itanium"
date: 2011-05-31 22:52
author: alvachien
comments: true
categories: [Visual C# Express, Visual Studio, Windows Platform, 技术Tips]
---
一直没注意Visual C# Express(以下简称VCSE)默认并不提供切换Configuration和Platform的功能。具体来说，VCSE会默认生成Release版本当按F6来启动Build，而按F5或者F10等启动Debug时则默认会生成Debug版本。至于Platform则根据当前Active的Platform来自动执行。

VCSE的这种Behavior对用VCE创建的Project来说是满足需求的，但是对其它版本生成的Project文件（对VCSE来说，这里的Project都是C#的Project）来说则比较讨厌。用我自己的例子来说，我用Visual Studio Professional生成的Solution如果默认的Active的Configuration是Debug版本的话，用VCSE打开的话，我发现没有机会生成Release版本了。

做了一番调研之后，欣喜的发现，VCSE其实还是支持切换Configuration和Platform，只是默认隐藏了。要显示跟Visual Studio Professional中那样的很方便切换Configuration和Platform的Combobox，只需要一个步骤，在菜单Tools/Settings下，切换到Expert Settings就可以了。

[caption id="attachment_1090" align="alignnone" width="557" caption="Setting-&gt;&#39;Expert Setting&#39;"]<a href="http://www.alvachien.com/alvablog/wp-content/uploads/2011/05/VCSE_1.jpg"><img class="size-full wp-image-1090" title="Setting" src="http://www.alvachien.com/alvablog/wp-content/uploads/2011/05/VCSE_1.jpg" alt="Setting" width="557" height="172" /></a>[/caption]

在网上看到有人说，还必须打开如下图Options中的选项Projects and Solutions\General页面中的'Show advanced build configurations' (要看到这个页面，必须选择左下角的Show all settings)，我测试了一下，<strong>这个选项不是必须的</strong>。在Basic Settings情况下，即使选择这个选项也没用；在Expert Settings中，这个选项不被勾选也一样生效。

[caption id="attachment_1091" align="alignnone" width="757" caption="Options"]<a href="http://www.alvachien.com/alvablog/wp-content/uploads/2011/05/VCSE_2.jpg"><img class="size-full wp-image-1091" title="Options" src="http://www.alvachien.com/alvablog/wp-content/uploads/2011/05/VCSE_2.jpg" alt="Options" width="757" height="440" /></a>[/caption]

是为之记。
Alva Chien
2011.05.31
