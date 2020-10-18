---
layout: post
title:  "设置Angular程序，ng serve启用Https"
date:   2020-10-17 18:47:20 +0800
tags: [Angular,Https]
categories: [技术Tips]
---

设置Angular程序的ng serve启用HTTPS的步骤：

1. Clone Github [repo](https://github.com/RubenVermeulen/generate-trusted-ssl-certificate.git)

```powershell
git clone https://github.com/RubenVermeulen/generate-trusted-ssl-certificate.git --depth=1
```

2. Open PowerShell or Command Prompt, run scripts below:
```powershell
cd generate-trusted-ssl-certificate
bash generate.sh
```

3. Import the cert file by double click the generated crt file.

MUST move to the 'Trusted certification' folder.

4. Set script to run 'ng serve' to support SSL:

```powershell
ng serve --ssl true -o --sslKey ssl/server.key --sslCert ssl/server.crt
```

是为之记。    
Alva Chien   
2020.10.17   

