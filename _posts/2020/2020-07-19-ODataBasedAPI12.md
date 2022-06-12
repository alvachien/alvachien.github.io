---
layout: post
title:  "创建基于OData的Web API - Knowledge Builder API, Part XII, Angular程序的List和Detail页面"
date:   2020-07-19 23:56:22 +0800
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

- 第十篇 [Part X: 完善Angular程序]({% post_url 2020-07-15-ODataBasedAPI10 %})

- 第十一篇 [Part XI: 为API添加CORS支持]({% post_url 2020-07-16-ODataBasedAPI11 %})


这时候Angular程序可以正常访问我们的Knowledge Builder API。


本篇将继续增强Angular程序，为其添加List页面和Detail页面。    
- List页面显示一个集合；
- Detail页面用来支持：创建、修改和显示；


限于篇幅，这里只描述Knowledge Item的List页面和Detail页面（仅创建部分）。相应的，可以为Question Bank Item实现List页面和Detail页面。


首先，List页面的Html中定义Table控件：   

```html
<mat-toolbar-row>
  <span>Knowledge Items</span>
  <span class="example-spacer"></span>
  <section>
    <div class="example-button-row">
      <a mat-stroked-button routerLink="create">CREATE</a>
    </div>
  </section>
</mat-toolbar-row>

<div class="example-container mat-elevation-z8">
  <div class="example-loading-shade" *ngIf="isLoadingResults">
    <mat-progress-spinner *ngIf="isLoadingResults"></mat-progress-spinner>
  </div>

  <div class="example-table-container">

    <table mat-table [dataSource]="data" class="example-table" matSort matSortActive="created" matSortDisableClear
      matSortDirection="desc">
      <!-- ID Column -->
      <ng-container matColumnDef="id">
        <th mat-header-cell *matHeaderCellDef>#</th>
        <td mat-cell *matCellDef="let row">{{row.ID}}</td>
      </ng-container>

      <!-- Category Column -->
      <ng-container matColumnDef="category">
        <th mat-header-cell *matHeaderCellDef>Category</th>
        <td mat-cell *matCellDef="let row">{{row.Category}}</td>
      </ng-container>

      <!-- Title Column -->
      <ng-container matColumnDef="title">
        <th mat-header-cell *matHeaderCellDef>Title</th>
        <td mat-cell *matCellDef="let row">{{row.Title}}</td>
      </ng-container>

      <!-- Created At Column -->
      <ng-container matColumnDef="createdat">
        <th mat-header-cell *matHeaderCellDef>Created At</th>
        <td mat-cell *matCellDef="let row">{{row.CreatedAt}}</td>
      </ng-container>

      <tr mat-header-row *matHeaderRowDef="displayedColumns"></tr>
      <tr mat-row *matRowDef="let row; columns: displayedColumns;"></tr>
    </table>
  </div>

  <mat-paginator [length]="resultsLength" [pageSize]="30"></mat-paginator>
</div>
```


然后，其Component文件中添加AfterViewInit的hook，并去调用service：     

```typescript
@Component({
  selector: 'app-knowledge-items',
  templateUrl: './knowledge-items.component.html',
  styleUrls: ['./knowledge-items.component.scss']
})
export class KnowledgeItemsComponent implements AfterViewInit {
  displayedColumns: string[] = ['id', 'category', 'title', 'createdat'];
  data: any[] = [];

  resultsLength = 0;
  isLoadingResults = true;

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  constructor(private odataService: ODataService) {}

  ngAfterViewInit() {
    // If the user changes the sort order, reset back to the first page.
    this.sort.sortChange.subscribe(() => this.paginator.pageIndex = 0);

    merge(this.sort.sortChange, this.paginator.page)
      .pipe(
        startWith({}),
        switchMap(() => {
          this.isLoadingResults = true;
          return this.odataService.getKnowledgeItems(
          );
        }),
        map(data => {
          // Flip flag to show that loading has finished.
          this.isLoadingResults = false;
          this.resultsLength = data.total_count;

          return data.items;
        }),
        catchError(() => {
          this.isLoadingResults = false;
          return observableOf([]);
        })
      ).subscribe(data => this.data = data);
  }
}
```

List页面的SCSS文件：   
```scss
/* Toolbar */
.example-spacer {
  flex: 1 1 auto;
}

/* Structure */
.example-container {
    position: relative;
    min-height: 200px;
  }
  
  .example-table-container {
    position: relative;
    max-height: 400px;
    overflow: auto;
  }
  
  table {
    width: 100%;
  }
  
  .example-loading-shade {
    position: absolute;
    top: 0;
    left: 0;
    bottom: 56px;
    right: 0;
    background: rgba(0, 0, 0, 0.15);
    z-index: 1;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .example-rate-limit-reached {
    color: #980000;
    max-width: 360px;
    text-align: center;
  }
  
  /* Column Widths */
  .mat-column-number,
  .mat-column-state {
    max-width: 64px;
  }
  
  .mat-column-created {
    max-width: 124px;
  }
```

同时，Service中添加两个methods：  
- getKnowledgeItems：读取全部的Knowledge Item，当期这个版本暂不考虑pagination。
- createKnowledgeItem：创建新的Knowledge Item。   

代码如下：    

```typescript
  public getKnowledgeItems(): Observable<any> {
    let headers: HttpHeaders = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json')
              .append('Accept', 'application/json');

    let params: HttpParams = new HttpParams();
    params = params.append('$top', '100');
    params = params.append('$count', 'true');
    params = params.append('$select', 'ID,Category,Title,CreatedAt,ModifiedAt');
    return this.http.get(`${this.apiUrl}KnowledgeItems`, {
        headers,
        params,
      })
      .pipe(map((response: HttpResponse<any>) => {
        const rjs = response as any;
        return {
          total_count: rjs['@odata.count'],
          items: rjs.value as any[]
        };
      }),
      catchError((error: HttpErrorResponse) => {
        return throwError(error.statusText + '; ' + error.error + '; ' + error.message);
      }));
  }

  public createKnowledgeItem(ki: any): Observable<any> {
    let headers: HttpHeaders = new HttpHeaders();
    headers = headers.append('Content-Type', 'application/json')
              .append('Accept', 'application/json');

    return this.http.post(`${this.apiUrl}KnowledgeItems`, ki, {
        headers
        // params,
      })
      .pipe(map((response: HttpResponse<any>) => {
        const rjs = response as any;
        return {
          total_count: rjs['@odata.count'],
          items: rjs.value as any[]
        };
      }),
      catchError((error: HttpErrorResponse) => {
        return throwError(error.statusText + '; ' + error.error + '; ' + error.message);
      }));
  }

```

继续增强Detail页面：    

```html
<mat-card>
    <mat-card-header>
        <mat-card-title>Knowledge Item</mat-card-title>
        <mat-card-subtitle>{{currentMode}}</mat-card-subtitle>
    </mat-card-header>
    <mat-card-content>
        <form [formGroup]="itemFormGroup">
            <!-- ID -->
            <div class="achih-control-full-width">
            </div>

            <!-- Title -->
            <mat-form-field>
                <input matInput type="text" placeholder="Title" formControlName="titleControl"
                    name="title" #title maxlength="30">
                <mat-hint align="end">{{title.value.length}} / 30</mat-hint>
            </mat-form-field>

            <!-- Content -->
            <mat-form-field>
              <textarea matInput placeholder="Content" formControlName="contentControl"></textarea>
            </mat-form-field>
        </form>

        <div>
            <button mat-button (click)="onOK()">OK</button>
        </div>
    </mat-card-content>
</mat-card>
```

Component组件文件，暂只支持Create模式：   

```typescript
@Component({
  selector: 'app-knowledge-item-detail',
  templateUrl: './knowledge-item-detail.component.html',
  styleUrls: ['./knowledge-item-detail.component.scss'],
})
export class KnowledgeItemDetailComponent implements OnInit {

  private _destroyed$: ReplaySubject<boolean>;
  currentMode: string;
  // Step: Generic info
  public itemFormGroup: FormGroup;

  constructor(
    private activateRoute: ActivatedRoute,
    private odataService: ODataService) {
    this.itemFormGroup = new FormGroup({
      titleControl: new FormControl('', Validators.required),
      contentControl: new FormControl('', Validators.required),
    });

    this.currentMode = 'Create';
  }

  ngOnInit(): void {
  }

  onOK(): void {
    // On OK
    if (this.currentMode === 'Create') {
      if (!this.itemFormGroup.valid) {
        if (this.itemFormGroup.hasError) {
          let err = this.itemFormGroup.errors;
          console.log(err);
        }
        return;
      }

      // Create a new knowlege item
      this.odataService.createKnowledgeItem({
        Category: 'Concept',
        Title: this.itemFormGroup.get('titleControl').value,
        Content: this.itemFormGroup.get('contentControl').value
      }).subscribe({
        next: val => {
          // Val
        },
        error: err => {
          // Error
        }
      });
    }
  }
}
```

现在可以测试Angular程序了。


![ListPage](/assets/uploads/2020/07/angular_odata_listpage.jpg)


![DetailPage](/assets/uploads/2020/07/angular_odata_detailpage.jpg)


至此，这个Web API 及其相关的Web App已经写完了。


是为之记。   
Alva Chien    
2020.07.19   
更新于2020.12.17   

