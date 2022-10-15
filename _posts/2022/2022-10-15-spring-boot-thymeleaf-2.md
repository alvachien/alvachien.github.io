---
layout: post
title:  "Step by Step Tutorial for Spring Boot and Thymeleaf: Part II"
date:   2022-10-15 18:07:20 +0800
tags: [Web API, Java, Spring, Spring Boot, Spring MVC, Thymeleaf]
categories: [技术Tips]
---

项目源码寄存在[Github repo](https://github.com/alvachien/learning-notes/tree/master/spring-tutorial/thymeleaf-jpa-demo)


继上一篇[《Step by Step Tutorial for Spring Boot and Thymeleaf: Part I》]({% post_url 2022-10-14-spring-boot-thymeleaf %})介绍了项目的初始环境，还有对应的Model，以及对应的Repository。这一篇开始涉及具体的Controller和View————这些还是基于MVC概念。


## 官方文档   

官方Thymeleaf 与Spring Boot的文档：[Thymeleaf Doc](https://www.thymeleaf.org/doc/tutorials/3.0/thymeleafspring.html)

## 列表页面

列表页面所有的Person Role。

### Controller

这里的Controller其实支持了多个View。这里的两个method：
- index: 主页面
- getPersonRoles： 显示Person Role列表

```java
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.alvachien.springtutorial.thymeleafjpademo.exception.ResourceNotFoundException;
import com.alvachien.springtutorial.thymeleafjpademo.model.PersonRole;
import com.alvachien.springtutorial.thymeleafjpademo.service.PersonRoleService;

@Controller
public class PersonRoleController {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
 
    private final int ROW_PER_PAGE = 5;
 
    @Autowired
    private PersonRoleService personRoleService;
 
    @Value("${msg.title}")
    private String title;
 
    @GetMapping(value = {"/", "/index"})
    public String index(Model model) { 
        model.addAttribute("title", title);
        return "index";
    }
 
    @GetMapping(value = "/personroles")
    public String getPersonRoles(Model model, @RequestParam(value = "page", defaultValue = "1") int pageNumber) 
    { 
        List<PersonRole> roles = personRoleService.findAll(pageNumber, ROW_PER_PAGE);
 
        long count = personRoleService.count();
        boolean hasPrev = pageNumber > 1;
        boolean hasNext = (pageNumber * ROW_PER_PAGE) < count;

        model.addAttribute("roles", roles);
        model.addAttribute("hasPrev", hasPrev);
        model.addAttribute("prev", pageNumber - 1);
        model.addAttribute("hasNext", hasNext);
        model.addAttribute("next", pageNumber + 1);
        return "person-role-list";    
    }
}
```

### View

Thymeleaf的语法大致规律如下：
- 需要在HTML的tag下设置对应XML的namespace：`xmlns:th="http://www.thymeleaf.org"`
- 通过XML的namespace：
    - `th:text`：设置当前元素的文本内容;
    - `th:utext`：设置文本内容。与`th:text`的区别在于，`th:text`不会转义html标签，而`th:utext`会。
    - `th:value`：设置当前元素的value值，类似修改指定属性的还有`th:src`，`th:href`。
    - `th:href`：设置超链接。
    - `th:each`：遍历循环元素，通常和`th:text`或`th:value`一起使用。
    - `th:if`：条件判断，类似的还有`th:unless`，`th:switch`，`th:case`。
    - `th:insert`：代码块。类似的还有`th:replace`，`th:include`，三者的区别较大，若使用不恰当会破坏html结构，常用于公共代码块提取的场景。
    - `th:fragment`：定义代码块，方便被`th:insert`引用。
    - `th:object`：声明变量，一般和`*{}`一起配合使用。
    - `th:attr`：修改任意属性，类似的还有`th:attrappend`，`th:attrprepend`。

#### 主页(index.html)

对应的模板文件如下：   

```html
<html xmlns:th="http://www.thymeleaf.org">
    <head>
        <meta charset="UTF-8" />
        <title th:utext="${title}" />
    </head>
    <body>
        <h1 th:utext="${title}" />
        <a th:href="@{/personroles}">Person Roles List</a>  
    </body>
</html>
```


#### List页面 (person-role-list.html)

对应的模板文件如下：

```java
<!DOCTYPE HTML>
<html xmlns:th="http://www.thymeleaf.org">
    <head>
        <meta charset="UTF-8" />
        <title>Person Role List</title>
    </head>
    <body>
        <h1>Person Role List</h1>
        
        <div>
            <nobr>
                <a th:href="@{/}">Back to Index</a>
            </nobr>
        </div>
        <br/><br/>
        <div>
            <table border="1">
                <tr>
                    <th>Id</th>
                    <th>Name</th>
                    <th>Value</th>
                    <th></th>
                </tr>
                <tr th:each ="role : ${roles}">
                    <td><a th:href="@{/personroles/{roleId}(roleId=${role.getId()})}" th:utext="${role.getId()}">...</a></td>
                    <td><a th:href="@{/personroles/{roleId}(roleId=${role.getId()})}" th:utext="${role.getRoleName()}">...</a></td>
                    <td th:utext="${role.getRoleValue()}">...</td>
                    <td><a th:href="@{/personroles/{roleId}/edit(roleId=${role.getId()})}">Edit</a></td>
                </tr>
            </table>          
        </div>
        <br/><br/>
        <div>
            <nobr>
                <span th:if="${hasPrev}"><a th:href="@{/personroles?page={prev}(prev=${prev})}">Prev</a>&nbsp;&nbsp;&nbsp;</span> 
                <span th:if="${hasNext}"><a th:href="@{/personroles?page={next}(next=${next})}">Next</a></span>
            </nobr>
        </div>
    </body>
</html>
```

