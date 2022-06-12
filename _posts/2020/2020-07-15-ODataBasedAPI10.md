---
layout: post
title:  "创建基于OData的Web API - Knowledge Builder API, Part X, 完善Angular程序"
date:   2020-07-15 14:16:22 +0800
tags: [Angular, Knowledge Builder, OData]
categories: [技术Tips]
---


本系列之前的文章：

- 第一篇 [Part I:  业务场景和存储层设计]({% post_url 2019-11-03-ODataBasedAPI1 %}) 

- 第二篇 [Part II:  开发环境及项目设置]({% post_url 2019-11-04-ODataBasedAPI2 %}) 

- 第三篇 [Part III:  Model类]({% post_url 2019-11-06-ODataBasedAPI3 %}) 

- 第四篇 [Part IV: Data Context]({% post_url 2019-11-07-ODataBasedAPI4 %})

- 第五篇 [Part V: Controller]({% post_url 2020-07-03-ODataBasedAPI5 %}) 

- 第六篇 [Part VI: 为Controller添加CRUD]({% post_url 2020-07-04-ODataBasedAPI6 %}) 

- 第七篇 [Part VII: 用Postman测试]({% post_url 2020-07-05-ODataBasedAPI7 %}) 

- 第八篇 [Part VIII: Unit Test准备]({% post_url 2020-07-06-ODataBasedAPI8 %}) 

- 第九篇 [Part IX: Angular程序环境准备]({% post_url 2020-07-14-ODataBasedAPI9 %})

有了上一篇的基础，可以增强这个Angular程序让它能真正访问之前创建的Knowledge Builder API了。


### 步骤一、添加Module


增加几个Module，分别对于Welcome，Knowledge Item和Question Bank Item。

```powershell
ng g m pages\Welcome --routing
ng g m pages\KnowledgeItems --routing
ng g m pages\QuestionBankItems --routing
```

执行完指令后，src文件夹下会多出一个pages的子文件夹。

### 步骤二、添加Components

现在，在刚刚创建文件夹下添加对应的底层component。

如果执行下面这条指令，它会在src\pages\welcome文件夹下又创建一个welcome的文件夹。     

```powershell
ng g c pages\welcome\Welcome -m pages\welcome\Welcome
```

所以，修正该指令：    

```powershell
ng g c pages\Welcome -m pages\welcome\Welcome
```

现在，该WelcomeComponent与WelcomeModule在同一层了。

类似地，可以加入其它两个底层component：  

```powershell
ng g c pages\KnowledgeItems -m pages\knowledge-items

ng g c pages\QuestionBankItems -m pages\question-bank-items

```

### 步骤三、创建List和Detail页面

如果把KnowledgeItemsComponent和QuestionBankItemsComponent分别用于List View来展示Knowledge Items和Question Bank Items的话，那么还需要创建单个的Knowledge Item以及Question Bank Item的编辑和查看页面。

创建KnowledgeItemDetailComponent来实现对Knowledge Item的Create，Display和Update:   
```powershell
ng g c pages\knowledge-items\KnowledgeItemDetail -m pages\knowledge-items
```

类似的，创建QuestionBankItemDetailComponent。    
```powershell
ng g c pages\question-bank-items\QuestionBankItemDetail -m pages\question-bank-items
```

上述指令会分别创建Detail的文件夹，为了简化import操作，可以在新创建的文件夹下定义index.ts来export定义：    

```typescript
export * from './knowledge-item-detail.component';
```


### 步骤四、更新Routing

这里需要更新Module的Routes。

对于Knowledge Items Module，它的routes定义如下：    

```typescript
const routes: Routes = [
  { path: '', component: KnowledgeItemsComponent },
  { path: 'create', component: KnowledgeItemDetailComponent },
  { path: 'display/:id', component: KnowledgeItemDetailComponent },
  { path: 'edit/:id', component: KnowledgeItemDetailComponent },
];
```

上述定义既定义了List View（默认Component），也定义了Create, Display和Edit的跳转。

类似地，可以定义Question Bank Item的Routes：    

```typescript
const routes: Routes = [
  { path: '', component: QuestionBankItemsComponent },
  { path: 'create', component: QuestionBankItemDetailComponent },
  { path: 'display/:id', component: QuestionBankItemDetailComponent },
  { path: 'edit/:id', component: QuestionBankItemDetailComponent },
];
```

同时，需要在Root Module的routes定义：    

```typescript
const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: '/welcome' },
  { path: 'welcome', loadChildren: () => import('./pages/welcome/welcome.module').then(m => m.WelcomeModule) },
  {
    path: 'knowledge-item',
    loadChildren: () => import('./pages/knowledge-items/knowledge-items.module').then(m => m.KnowledgeItemsModule),
  },
  {
    path: 'question-bank-item',
    loadChildren: () => import('./pages/question-bank-items/question-bank-items.module').then(m => m.QuestionBankItemsModule),
  },
];
```

需要确保Routing Module都已经被import进各自的Module。


### 步骤五、创建Service来负责前后台通讯

接下来，定义Service来，主要用于前后台通讯。

```powershell
ng g service services\OData
```

上述命令将创建一个service文件夹，并在其中生成odataservice.ts的文件。

在真正让service工作之前，添加代码来获取Knowledge Builder API的OData metadata。   

```typescript
@Injectable({
  providedIn: 'root'
})
export class ODataService {
  apiUrl = `https://localhost:44355/odata/`;

  constructor(private http: HttpClient,
    ) { }

  public getMetadata(): Observable<any> {
    let headers: HttpHeaders = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json')
              .append('Accept', 'application/json');

    // let params: HttpParams = new HttpParams();
    // params = params.append('$count', 'true');
    return this.http.get(`${this.apiUrl}$metadata`, {
        headers,
        // params,
      })
      .pipe(map((response: HttpResponse<any>) => {
        const rjs: any = response as any;
        return rjs;
      }),
      catchError((error: HttpErrorResponse) => {

        return throwError(error.statusText + '; ' + error.error + '; ' + error.message);
      }));
  }
}
```

这里的URL取决于API project的配置。


### 步骤六、调用新建的Service

要使得页面能够调用新建的ODataService，需要将该Service注册到根Module。

```typescript
@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    HttpClientModule,
    MaterialModulesModule,
  ],
  providers: [ODataService],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

然后在页面中就可以调用了。当然，基于Dependence Injection的原理，需要在页面的Constructor加入dependence。

试着在Welcome页面中加入调用。   

```typescript
export class WelcomeComponent implements OnInit {

  constructor(private odataSrv: ODataService) {
    console.log('Entering WelcomeComponent constructor');
  }

  ngOnInit(): void {
    console.log('Entering WelcomeComponent ngOnInit');

    this.odataSrv.getMetadata().subscribe({
      next: val => {
        console.log(val);
      },
      error: err => {
        console.error(err);
      },
    });
  }
}

```



### 步骤七、貌似可以联调

到目前为止，Service已经创建，页面都已经创建，并已经调用API了。

然而，执行如下命令，   
```powershell
ng serve -o
```

页面并未加载成功，Console的log如下：  

```log
Access to XMLHttpRequest at 'https://localhost:44355/odata/$metadata' from origin 'http://localhost:4200' has been blocked by CORS policy: 
  Response to preflight request doesn't pass access control check: No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

简单来说，API并没有启用CORS，所以，调用失败。

那么，如果修正API呢？


是为之记。   
Alva Chien    
2020.07.15



