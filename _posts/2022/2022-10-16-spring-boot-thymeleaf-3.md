---
layout: post
title:  "Step by Step Tutorial for Spring Boot and Thymeleaf: Part III"
date:   2022-10-16 22:07:20 +0800
tags: [Web API, Java, Spring, Spring Boot, Spring MVC, Thymeleaf]
categories: [技术Tips]
---


第一篇： [《Step by Step Tutorial for Spring Boot and Thymeleaf: Part I》]({% post_url 2022-10-14-spring-boot-thymeleaf %}) 介绍了项目的初始环境，还有对应的Model，以及对应的Repository。   


第二篇： [《Step by Step Tutorial for Spring Boot and Thymeleaf: Part II》]({% post_url 2022-10-15-spring-boot-thymeleaf-2 %}) 介绍了具体的Controller和View，以及Thymeleaf的语法。    


本篇，介绍了Thymeleaf语法下的多个View的实现。


项目源码寄存在[Github repo](https://github.com/alvachien/learning-notes/tree/master/spring-tutorial/thymeleaf-jpa-demo)。   


## 单条信息的显示

在List页面，单击其中的链接，可以显示单条Role的具体信息。
其具体的URL为： `localhost:8080/personroles/(roleid)`

### 更新Controller

在之前的`PersonRoleController`添加下列Method来支持单条信息的显示。

```java
@Controller
public class PersonRoleController {
    // ...
    @GetMapping(value = "/personroles/{roleId}")
    public String getPersonRoleById(Model model, @PathVariable long roleId) 
    { 
        PersonRole role = null;
        try {
            role = personRoleService.findById(roleId);
        } catch (ResourceNotFoundException ex) {
            model.addAttribute("errorMessage", "Person role not found");
        }
        model.addAttribute("role", role);

        return "person-role-display";
    }
}
```


### 单条信息的显示View

在`template`目录下，新建文件`person-role-display.html`：

```html
<html xmlns:th="http://www.thymeleaf.org">
    <head>
        <meta charset="UTF-8" />
        <title>View Person Role</title>
        <link rel="stylesheet" type="text/css" th:href="@{/css/style.css}"/>
    </head>
    <body>
        <h1>View Person Role</h1>
        <a th:href="@{/personroles}">Back to Person Role List</a>
        <br/><br/>
        <div th:if="${role}">
            <table border="0">
                <tr>
                    <td>ID</td>
                    <td>:</td>
                    <td th:utext="${role.id}">...</td>          
                </tr>
                <tr>
                    <td>Name</td>
                    <td>:</td>
                    <td th:utext="${role.roleName}">...</td>             
                </tr>
                <tr>
                    <td>Value</td>
                    <td>:</td>
                    <td th:utext="${role.roleValue}">...</td>
                </tr>
            </table>
            <br/><br/>
            <div th:if="not ${allowDelete}">
                <a th:href="@{/personroles/{roleId}/edit(roleId=${role.getId()})}">Edit</a> |
                <a th:href="@{/personroles/{roleId}/delete(roleId=${role.getId()})}">Delete</a>
            </div>
        </div>
        <div th:if="${errorMessage}" th:utext="${errorMessage}" class="error">            
        </div>
    </body>
</html>
```

运行程序：

![页面](/assets/uploads/2022/10/spring-boot-thymeleaf-app4.png)


## 单条信息的新建

单条信息的新建和修改都属于单条信息的编辑。   

其具体的URL为： `localhost:8080/personroles/(roleid)`


### 更新Controller

在之前的`PersonRoleController`添加下列Method来支持单条信息的新建。   

```java
    @GetMapping(value = {"/personroles/add"})
    public String showAddPersonRole(Model model) 
    { 
        PersonRole role = new PersonRole();
        model.addAttribute("add", true);
        model.addAttribute("role", role);
     
        return "person-role-edit";
    }
 
    @PostMapping(value = "/personroles/add")
    public String addPersonRole(Model model, @ModelAttribute("role") PersonRole personRole) 
    { 
        try {
            PersonRole newRole = personRoleService.save(personRole);
            return "redirect:/personroles/" + String.valueOf(newRole.getId());
        } catch (Exception ex) {
            // log exception first, 
            // then show error
            String errorMessage = ex.getMessage();
            logger.error(errorMessage);
            model.addAttribute("errorMessage", errorMessage);
     
            model.addAttribute("add", true);
            return "person-role-edit";
        }
    }
```

### 单条记录的编辑View

这里的View，可以用在新建和修改的情形下。

```html
<html xmlns:th="http://www.thymeleaf.org">

<head>
    <meta charset="UTF-8" />
    <title th:text="${add} ? 'Create a person role' : 'Edit a person role'" />
    <link rel="stylesheet" type="text/css" th:href="@{/css/style.css}" />
</head>

<body>
    <h1 th:text="${add} ? 'Create a person role:' : 'Edit a person role:'" />
    <a th:href="@{/personroles}">Back to Person Role List</a>
    <br /><br />
    <form th:action="${add} ? @{/personroles/add} : @{/personroles/{roleId}/edit(roleId=${role.getId()})}"
        th:object="${role}" method="POST">
        <table border="0">
            <tr th:if="${!add}">
                <td>ID</td>
                <td>:</td>
                <td th:utext="*{id}">...</td>
            </tr>
            <tr>
                <td>Name</td>
                <td>:</td>
                <td><input type="text" th:field="*{roleName}" /></td>
            </tr>
            <tr>
                <td>Value</td>
                <td>:</td>
                <td>
                    <select th:field="*{roleValue}">
                        <option th:each="roleOpt : ${T(com.alvachien.springtutorial.thymeleafjpademo.model.PersonRoleEnum).values()}" 
                            th:value="${roleOpt}" th:text="${roleOpt}">
                        </option>
                    </select>
                </td>
            </tr>
        </table>
        <input type="submit" th:value="${add} ? 'Create' : 'Update'" />
    </form>

    <br />
    <!-- Check if errorMessage is not null and not empty -->
    <div th:if="${errorMessage}" th:utext="${errorMessage}" class="error" />
</body>

</html>
```

这里，需要注意的是，在Thymeleaf模板下，Select控件与Java Enum之间的绑定语法：

```html
<select th:field="*{roleValue}">
    <option th:each="roleOpt : ${T(com.alvachien.springtutorial.thymeleafjpademo.model.PersonRoleEnum).values()}" 
        th:value="${roleOpt}" th:text="${roleOpt}">
    </option>
</select>
```

## 单条信息的更新

单条信息的修改URL为： `localhost:8080/personroles/(roleid)/edit`

### 更新Controller

```java
    @GetMapping(value = {"/personroles/{roleId}/edit"})
    public String showEditPersonRole(Model model, @PathVariable long roleId)
    { 
        PersonRole role = null;
        try {
            role = personRoleService.findById(roleId);
        } catch (ResourceNotFoundException ex) {
            model.addAttribute("errorMessage", "Person role not found");
        }
        model.addAttribute("add", false);
        model.addAttribute("role", role);
        return "person-role-edit";
    }
    
    @PostMapping(value = {"/personroles/{roleId}/edit"})
    public String updatePersonRole(Model model,
            @PathVariable long roleId,
            @ModelAttribute("personRole") PersonRole personRole) 
    { 
        try {
            personRole.setId(roleId);
            personRoleService.update(personRole);
            return "redirect:/personroles/" + String.valueOf(personRole.getId());
        } catch (Exception ex) {
            // log exception first, 
            // then show error
            String errorMessage = ex.getMessage();
            logger.error(errorMessage);
            model.addAttribute("errorMessage", errorMessage);
     
             model.addAttribute("add", false);
            return "person-role-edit";
        }
    }
```

### 单条记录的编辑View

这里复用上面的`person-role-edit.html`，所以无需新建额外的View。


运行程序：

![页面](/assets/uploads/2022/10/spring-boot-thymeleaf-app3.png)
