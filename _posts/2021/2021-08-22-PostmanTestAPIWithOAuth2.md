---
layout: post
title:  "使用Postman测试OAuth2.0保护的Web API"
date:   2021-08-22 17:56:22 +0800
tags: [Identity Server, Postman, OAuth 2.0]
categories: [技术Tips]
---

本文中，使用Duede Identity Server作为OAuth 2.0的Issuer。换言之，要测试的Web API，通过该Server进行校验。

### 对Identity Server的设置

首先，需要增加Identity Server的一个Client：
- Grant Type：Password
- Client ID/Client Secret

```c#
    new Client
    {
        ClientId = "Postman",
        ClientName = "Postman client",
        // AllowAccessTokensViaBrowser = true,
        RequireConsent = false,
        RedirectUris = { "https://www.getpostman.com/oauth2/callback" },
        // RedirectUris = { "https://oauth.pstmn.io/v1/callback" },
        PostLogoutRedirectUris = { "https://www.getpostman.com" },
        AllowedCorsOrigins = { "https://www.getpostman.com" },
        EnableLocalLogin = true,

        AllowedGrantTypes = new []
        {
            GrantType.ResourceOwnerPassword
        },
        ClientSecrets = { new Secret("Postman".Sha256()) },
        ClientUri = null,
        AllowOfflineAccess = true,
        Enabled = true,
        AllowedScopes = new []
        {
            StandardScopes.OpenId,
            StandardScopes.Profile,
            StandardScopes.Email,
            // StandardScopes.OfflineAccess,
        }
    }
```


注意，如果Identity Server是ASP.NET Core Identity，那么需要注册一个真正专用的User。


### 对Web API的设置

对Web API无需额外的设置，除非需要针对Test Mode下做一些特别的设置。

本文中，对Web API特别设置并未涉及。


### 对Postman的设置

首先，需要设置Variable，无论是Global Variable还是Collection Variable。
- IdServerToken： Access  Token
- IdServerToken_CreatedAt: Create at timepoint
- IdServerToken_ExpiresIn: Expire in timepoint
- IdServerToken_Url:URL to Identity Server
- IdServerToken_ClientId: Client ID (same as Client)
- IdServerToken_ClientSecret:Client Secret
- IdServerToken_UserName: User name
- IdServerToken_Password: Password

然后，设置Request上（也可以是Collection）的Authorization页面：   

![Authorization](/assets/uploads/2021/08/Postman1.jpg)

自动化这个流程需要一些额外的代码（上述Request或Collection的Pre-request Script）：

```javascript
var tokenCreatedAt = pm.collectionVariables.get("IdServerToken_CreatedAt");

if (!tokenCreatedAt) {
    tokenCreatedAt = new Date(new Date().setDate(new Date().getDate() - 1))
}

var tokenExpiresIn = pm.collectionVariables.get("IdServerToken_ExpiresIn");

if (!tokenExpiresIn) {
    tokenExpiresIn = 3600;
}

var tokenCreatedTime = (new Date() - Date.parse(tokenCreatedAt))

if (tokenCreatedTime >= tokenExpiresIn) {

    pm.sendRequest({
        url: pm.variables.get("IdServerToken_Url"),
        method: 'POST',
        header: {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {
            mode: 'urlencoded',
            urlencoded: [{
                    key: "client_id",
                    value: pm.collectionVariables.get("IdServerToken_ClientId"),
                    disabled: false
                },
                {
                    key: "client_secret",
                    value: pm.collectionVariables.get("IdServerToken_ClientSecret"),
                    disabled: false
                },
                {
                    key: "scope",
                    value: "api.hih",
                    disabled: false
                },
                {
                    key: "grant_type",
                    value: "password",
                    disabled: false
                },
                {
                    key: "username",
                    value: pm.collectionVariables.get("IdServerToken_UserName"),
                    disabled: false
                },
                {
                    key: "password",
                    value: pm.collectionVariables.get("IdServerToken_Password"),
                    disabled: false
                }
            ]
        }
    }, function(error, response) {
       
        pm.collectionVariables.set("IdServerToken_CreatedAt", new Date());
        pm.collectionVariables.set("IdServerToken", response.json().access_token);

        var expiresIn = response.json().expires_in;
        
        if (expiresIn) {
            tokenExpiresIn = expiresIn * 1000;
        }
        
        pm.collectionVariables.set("IdServerToken_ExpiresIn", tokenExpiresIn);
    });
}

```

是为之记。   
Alva Chien    
2021.08.22
