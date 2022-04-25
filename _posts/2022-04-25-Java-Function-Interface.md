---
layout: post
title:  Lamda Expression and Functional Interface in Java
date:   2022-04-25 21:09:17 +0800
tags: [Java]
categories: [技术Tips]
---

继续封控，继续深入学习Java。


Java 8 引入了Lamda Expression的概念，其实**lambda expression**就是一个**functional interface**。


And a *functional interface* is an interface:
- With only one abstract method;
- Can define several Default methods;
- Can define several Static methods;
- Shall (not mandatory) be defined by annotation '@FunctionalInterface'
 
JAVA Compiler will use Function Interface method's signature (parameter and return types) to check lambda expression.

有了Lambda expression之后，Java 7跟Java 8的代码就有了如下区别：

```java
// Java 7
Predicate<String> p = new Predicate<String>() {
    public boolean test(String s) {
        return s.length() < 20;
    }
}

// Java 8
Predicate<String> p = s -> s.length() < 20;
```

### Package java.util.function

There are 43 classes introduced in JDK 8, with four categories:
- Consumers
- Supplier
- Functions
- Predicates

#### Consumers

A **consumer** consumes an object, and doesn't return anything. 

```java
public interface Consumer<T> {
    public void accept(T t);
}
public interface BiConsumer<T, V> {
    public void accept(T t, V v);
}
```

#### Suppliers

A **supplier** provides an object, take no parameter. 

```java
public interface Supplier<T> {
    public T get();
}
```

#### Functions

A **function** takes an object and returns another object.

```java
public interface Function<T, R> {
    public R apply(T, t);
}
public interface BiFunction<T, V, R> {
    public R apply(T t, V v);
}
public interface UnaryOperator<T> extends Function<T, T> {}
public interface BinaryOperator<T> extends BiFunction<T, T, T> {}
```

#### Predicates

A **predicate** takes an object and return a boolean.

```java
public interface Predicate<T> {
    public boolean test(T t);
}
public interface BiPredicate<T, U> {
    public boolean test(T t, U u);
}
```
