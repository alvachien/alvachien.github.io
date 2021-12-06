---
layout: post
title:  Java泛型
date:   2021-12-06 21:09:17 +0800
tags: [Java, .Net]
categories: [技术Tips]
---

最近一周开看Java的泛型，本以为Java跟C#、.Net一样，却惊奇地发现Java泛型的实现跟自己想象不同。

简单来说：   
- Java编译时，对使用了泛型的Object提供Type Erasure；
- JVM并不支持泛型；

Java的通配符泛型支持所谓的Upper Bounded Wildcard和Lower Bounded Wildcard:   

```java
// Upper bounded wildcard
public static void testMothd(List<? extends Number> lists) {
    System.out.println(list);
}

// Lower bounded wildcard
public static void testMothd2(List<? super Number> lists) {
    System.out.println(list);
}
```

JVM不包括泛型信息，表示，Java的泛型只在编译阶段有效，编译器会将泛型相关信息擦除（即所谓Type Erasure），并且在对象进入和离开方法的边界处添加类型检查和类型转换的方法，即泛型信息不回进入运行时阶段： 所以   

```java
public static void main(String[] args) {
    List<Integer> listInts = new List<>();
    List<String> listStrings = new List<>();

    Class classStringList = listStrings.getClass();
    Class classIntList = listInts.getClass();
    System.out.println(classStringList.equals(classIntList));  // true
}
```

由于Type Erasure，在Java不能创建一个泛型类型的数组。所以，下列代码不能通过编译：     
```java
List<String>[] lsa = new List<String>[10]; // Compile error
```

在Java中，需要通过通配符方式：   
```java
List<?>[] lsa = new List<?>[10]; // Compile ok
```

查看Java的二进制码：   
```Powershell
javap -c testmethod.java
```

对.Net来说，这完全不同，泛型的支持在CLR层面。所以，在生成的IL代码中，泛型概念也在其中。

