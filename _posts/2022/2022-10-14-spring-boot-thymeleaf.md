---
layout: post
title:  "Step by Step Tutorial for Spring Boot and Thymeleaf: Part I"
date:   2022-10-14 21:30:20 +0800
tags: [Web API, Java, Spring, Spring Boot, Spring MVC, Thymeleaf]
categories: [技术Tips]
---

学习Spring MVC，也想学习一下Thymeleaf模板，于是，将整个过程记录下来，作为一个Step by Step的Tutorial教程吧。

项目源码寄存在[Github repo](https://github.com/alvachien/learning-notes/tree/master/spring-tutorial/thymeleaf-jpa-demo)


## 开发环境
- 数据库
本案例中使用Microsoft SQL Server Express。呃，主要原因就是，当前我的电脑上已经安装有（随着Visual Studio安装的），就懒得再去安装额外的数据库系统了。   

如果没有安装SQL Server Express，可以去[SQL Server官网](https://www.microsoft.com/sqlserver)去下载，Express版本是免费的。
- Java SDK，版本选择了11（最新的一个LTS版本）。
- IDE: VS Code，自行下载。
- 版本管理，毫无疑问：Git。
- Maven的下载安装，详见[Apache Maven 官网](https://maven.apache.org/)


## 创建程序

打开[Spring Initalizer](https://start.spring.io/)来创建初始程序：

![初始化程序](/assets/uploads/2022/10/spring-boot-thymeleaf.png)

下载压缩包，将该包解压到对应的目录下。

## 更新POM

参考[《JDBC Driver to SQL Server Express》]({% post_url 2020-11-28-JDBC_SQLServer %})，POM文件需要更新以支持SQL Server。

```xml
<dependency>
    <groupId>com.microsoft.sqlserver</groupId>
    <artifactId>mssql-jdbc</artifactId>
    <version>10.2.1.jre11</version>
    <scope>runtime</scope>
</dependency>
```

## JPA相关的属性

至于，使用SQL Server Express，需要额外的配置才能正确使用。参考之前的文档。

设置JPA相关的属性(app.properties)：

```ini
spring.datasource.driver-class-name=com.microsoft.sqlserver.jdbc.SQLServerDriver
spring.datasource.url=jdbc:sqlserver://localhost;database=library;integratedSecurity=true;encrypt=true;trustServerCertificate=true
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=update
```


## Model定义

这里创建一个Person Role（用户角色）的Model。

```java
import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Convert;
import javax.persistence.Entity;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.springframework.validation.annotation.Validated;
 
@Validated
@Entity
@Table(name = "person_role_def")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class PersonRole {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) 
    @Column(name = "id")
    private Long id;

    @Column(name="role_value", nullable = false, columnDefinition = "INT")
    @Convert(converter = PersonRoleEnumConverter.class)
    private PersonRoleEnum roleValue;

    @Column(name="role_name", nullable = true, length = 50)
    private String roleName;

    public PersonRole() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public PersonRoleEnum getRoleValue() {
        return roleValue;
    }

    public void setRoleValue(PersonRoleEnum roleValue) {
        this.roleValue = roleValue;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
}
```

其中，Person Role有个Enum的属性，用来将创建的Role归集于系统所支持的角色中来，同时，保留了Own Defined作为系统的扩展：

```java
public enum PersonRoleEnum {
    OWNDEFINED(0),
    AUTHOR( 1 ),
    ACTOR( 2 ),
    DIRECTOR(3);
 
    private final int code;
    
    PersonRoleEnum(int code) {
        this.code = code;
    }
 
    public static PersonRoleEnum fromCode(int code) {
        if ( code == 1 ) {
            return AUTHOR;
        }
        if ( code == 2 ) {
            return ACTOR;
        }
        if ( code == 3 ) {
            return DIRECTOR;
        }
        if ( code == 0) {
            return OWNDEFINED;
        }
        
        throw new UnsupportedOperationException(
            "The code " + code + " is not supported!"
        );
    }
 
    public int getCode() {
        return code;
    }
}
```

要存储Enum到Database，需要定义一个Converter：

```java
import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter(autoApply = true)
public class PersonRoleEnumConverter implements AttributeConverter<PersonRoleEnum, Integer> {
 
    @Override
    public Integer convertToDatabaseColumn(PersonRoleEnum role) {
        return role == null ? null : role.getCode();
    }
 
    @Override
    public PersonRoleEnum convertToEntityAttribute(Integer value) {
        return value == null ? null : PersonRoleEnum.fromCode( value );
    }
}
```

## Repository

实现JPA Repository的Interface：

```java
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.PagingAndSortingRepository;

public interface PersonRoleRepository extends PagingAndSortingRepository<PersonRole, Long>, JpaSpecificationExecutor<PersonRole> 
{    
}
```

## Exception 

几个用到的Exception：BadResourceException, ResourceAlreadyExistsException, 和ResourceNotFoundException;

```java
import java.util.ArrayList;
import java.util.List;

public class BadResourceException extends Exception {

    private List<String> errorMessages = new ArrayList<>();

    public BadResourceException() {
    }

    public BadResourceException(String msg) {
        super(msg);
    }

    public List<String> getErrorMessages() {
        return errorMessages;
    }

    public void setErrorMessages(List<String> errorMessages) {
        this.errorMessages = errorMessages;
    }

    public void addErrorMessage(String message) {
        this.errorMessages.add(message);
    }
}

public class ResourceAlreadyExistsException extends Exception {
 
    public ResourceAlreadyExistsException() {
    }
 
    public ResourceAlreadyExistsException(String msg) {
        super(msg);
    }
}

public class ResourceNotFoundException extends Exception {
 
    public ResourceNotFoundException() {
    }
 
    public ResourceNotFoundException(String msg) {
        super(msg);
    }    
}
```

## Service

创建Service来实现Database层面的操作：

```java
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import com.alvachien.springtutorial.thymeleafjpademo.exception.*;
import com.alvachien.springtutorial.thymeleafjpademo.model.PersonRole;
import com.alvachien.springtutorial.thymeleafjpademo.repository.PersonRoleRepository;

@Service
public class PersonRoleService {
    @Autowired
    private PersonRoleRepository personRoleRepository;

    private boolean existsById(Long id) {
        return personRoleRepository.existsById(id);
    }

    public PersonRole findById(Long id) throws ResourceNotFoundException {
        PersonRole role = personRoleRepository.findById(id).orElse(null);
        if (role == null) {
            throw new ResourceNotFoundException("Cannot find Role with id: " + id);
        }

        return role;
    }

    public List<PersonRole> findAll(int pageNumber, int rowPerPage) {
        List<PersonRole> roles = new ArrayList<>();
        Pageable sortedByIdAsc = PageRequest.of(pageNumber - 1, rowPerPage,
                Sort.by("id").ascending());
        personRoleRepository.findAll(sortedByIdAsc).forEach(roles::add);
        return roles;
    }

    public PersonRole save(PersonRole role) throws BadResourceException, ResourceAlreadyExistsException {
        if (!ObjectUtils.isEmpty(role.getRoleName())) {
            if (role.getId() != null && existsById(role.getId())) {
                throw new ResourceAlreadyExistsException("Role with id: " + role.getId() + " already exists");
            }
            return personRoleRepository.save(role);
        } else {
            BadResourceException exc = new BadResourceException("Failed to save role");
            exc.addErrorMessage("Contact is null or empty");
            throw exc;
        }
    }

    public void update(PersonRole role) throws BadResourceException, ResourceNotFoundException {
        if (!ObjectUtils.isEmpty(role.getRoleName())) {
            if (!existsById(role.getId())) {
                throw new ResourceNotFoundException("Cannot find role with id: " + role.getId());
            }
            personRoleRepository.save(role);
        } else {
            BadResourceException exc = new BadResourceException("Failed to save role");
            exc.addErrorMessage("Role is null or empty");
            throw exc;
        }
    }

    public void deleteById(Long id) throws ResourceNotFoundException {
        if (!existsById(id)) {
            throw new ResourceNotFoundException("Cannot find role with id: " + id);
        } else {
            personRoleRepository.deleteById(id);
        }
    }

    public Long count() {
        return personRoleRepository.count();
    }
}
```

