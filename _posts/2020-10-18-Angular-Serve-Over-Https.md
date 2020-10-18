---
layout: post
title:  "Identity Server的Login之后的redirection不能正常工作"
date:   2020-10-18 11:47:20 +0800
tags: [IdentityServer,Login,Redirection]
categories: [技术Tips]
---

Chrome和Edge不停地升级，不停地修改页面行为。这导致的结果就是，即便项目什么都没改，却莫名其妙地不能正常工作呢。

以前，项目为了让Web Application支持多浏览器，痛斥Internet Explorer各种妖异的行径。也许，将来，为了让Web Application能够平滑地支持多浏览器，必须对各种浏览器最新版本加以控制了。

问题的表象是，在Identity Server成功登陆后，不能redirection回原来的页面。

Github Issue 见 [Link](https://github.com/IdentityServer/IdentityServer4/issues/4795)

Stackoverflow discussion 见 [Link](https://stackoverflow.com/questions/60757016/identity-server-4-post-login-redirect-not-working-in-chrome-only)

问题的本源当然还是因为Same-site的支持：

对.Net Core API的程序，可以配置：

```csharp
builder.Services.ConfigureExternalCookie(options =>
	{
		options.Cookie.IsEssential = true;
		options.Cookie.SameSite = (SameSiteMode)(-1); //SameSiteMode.Unspecified in .NET Core 3.1
	});
		
builder.Services.ConfigureApplicationCookie(options =>
	{
		options.Cookie.IsEssential = true;
		options.Cookie.SameSite = (SameSiteMode)(-1); //SameSiteMode.Unspecified in .NET Core 3.1
	});
```


是为之记。    
Alva Chien   
2020.10.18   

