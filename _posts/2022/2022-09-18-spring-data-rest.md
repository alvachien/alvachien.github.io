---
layout: post
title:  "Spring Boot: Spring Data Rest"
date:   2022-09-18 22:27:20 +0800
tags: [Web API, Java, Spring, Spring Boot]
categories: [技术Tips]
---

[Spring Rest Data](https://spring.io/projects/spring-data-rest)是建立在Spring Data下的一个子项目。

它存在的目的在于简化开发流程，因为它直接把resository以HATEOAS风格暴露成Web服务，而不需要再手写Controller层。


使用前，需要在POM添加如下依赖：

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-data-rest</artifactId>
</dependency>
```

Repository的接口也有两层：CrudRepository, PagingAndSortingRepository.

```java
public interface CrudRepository<T, ID extends Serializable>
    extends Repository<T, ID> {
    <S extends T> S save(S entity); 
    T findOne(ID primaryKey);       
    Iterable<T> findAll();          
    Long count();                   
    void delete(T entity);          
    boolean exists(ID primaryKey);  
    // ...
}
```

```java
public interface PagingAndSortingRepository<T, ID extends Serializable>
  extends CrudRepository<T, ID> {

  Iterable<T> findAll(Sort sort);

  Page<T> findAll(Pageable pageable);
}
```

然而，这种很便捷的库，要融入一些别的需求，就很麻烦。譬如：权限，数据校验等；
所以，实际项目中Spring Data REST开发的相对较少。

知乎上有一段评论，写得非常好，就不复制了（版权归于原作者）。
![Zhihu](/assets/uploads/2022/09/spring-data-rest-zhihu.png)
