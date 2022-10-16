---
layout: post
title:  "JDBC Driver to SQL Server Express, Part III"
date:   2020-12-06 18:50:22 +0800
tags: [Java, SQL Server]
categories: [技术Tips]
---

基于前两篇[《JDBC Driver to SQL Server Express》]({% post_url 2020/2020-11-28-JDBC_SQLServer %})和[《JDBC Driver to SQL Server Express，Part II》]({% post_url 2020/2020-12-05-JDBC_SQLServer_2 %})，已经可以尝试使用SQL Server Express并能执行SQL且返回结果集了。


## Connection String

基于官方[文档](https://docs.microsoft.com/en-us/sql/connect/jdbc/building-the-connection-url)，Connection String可以构建：   

```java
jdbc:sqlserver://[serverName[\instanceName][:portNumber]][;property=value[;property=value]]
```

所以，如果一个Server有多个实例，链接时可以指定instance，譬如：    

```java
jdbc:sqlserver://localhost;instanceName=instance1;integratedSecurity=true;
```


## 数据类型： Date, Time和Text

基础数据类型可以参考官方文档： [Link](https://docs.microsoft.com/en-us/sql/connect/jdbc/using-basic-data-types)。


高级数据类型的官方文档：[Link](https://docs.microsoft.com/en-us/sql/connect/jdbc/using-advanced-data-types)



仅记录比较常用和难用的数据类型，如Date，Time，DateTime和Text等：   

|数据库类型|JDBC类型(java.sql.Types)|Java类型|
|--|--|--|
|bigint|BIGINT|long|
|binary|BINARY|byte[]|
|bit|BIT|boolean|
|date|DATE|java.sql.Date|
|datetime|TIMESTAMP|java.sql.TimeStamp|
|datetimeoffset|microsoft.sql.Types.DATETIMEOFFSET|microsoft.sql.DateTimeOffset|
|decimal|DECIMAL|java.math.BigDecimal|
|float|DOUBLE|double|
|varbinary(max)，image|LONGVARBINARY|byte[] (default), Blob, InputStream, String|
|int|INTEGER|int|
|real|REAL|float|
|smallint|SMALLINT|short|
|text, varchar(max)|LONGVARCHAR|String (default), Clob, NClob|
|time|TIME|java.sql.Time|
|timestamp|BINARY|byte[]|
|tinyint|TINYINT|short|
|ntext, nvarchar(max)|LONGVARCHAR|String (default), Clob, NClob|
|xml|LONGVARCHAR|String (default), InputSteam, Clob, byte[], Blob)


读取大的数据类型示例1：   
```java
ResultSet rs = stmt.executeQuery("SELECT TOP 1 * FROM Test1");  
rs.next();  
Reader reader = rs.getCharacterStream(2);
```

读取大的数据类型示例2：   
```java
ResultSet rs = stmt.executeQuery("SELECT photo FROM mypics");  
rs.next();  
InputStream is = rs.getBinaryStream(2);  
```

读取大的数据类型示例3：   
```java
ResultSet rs = stmt.executeQuery("SELECT photo FROM mypics");  
rs.next();  
byte [] b = rs.getBytes(2);
```


插入大型数据示例1：   
```java
PreparedStatement pstmt = con.prepareStatement("INSERT INTO test1 (c1_id, c2_vcmax) VALUES (?, ?)");  
pstmt.setInt(1, 1);  
pstmt.setString(2, htmlStr);  
pstmt.executeUpdate();  
```

插入大型数据示例1：   
```java
try (PreparedStatement pstmt = con.prepareStatement("INSERT INTO test1 (Col1, Col2) VALUES(?,?)")) { 
  File inputFile = new File("CLOBFile20mb.jpg");  
  try (FileInputStream inStream = new FileInputStream(inputFile)) {
    int id = 1;  
    pstmt.setInt(1,id);  
    pstmt.setBinaryStream(2, inStream);  
    pstmt.executeUpdate();
  }
}
```


更新大型数据类型：   
```java
String SQL = "SELECT * FROM test1;";  
try (Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE)
     ResultSet rs = stmt.executeQuery(SQL)) {
  rs.next();

  Clob clob = rs.getClob(2);  
  long pos = clob.position("dog", 1);  
  clob.setString(pos, "cat");  
  rs.updateClob(2, clob);  
  rs.updateRow();  
}
```



## 返回结果集的Metadata


获取Metadata的官方文档，[Link](https://docs.microsoft.com/en-us/sql/connect/jdbc/using-database-metadata)


示例代码：    

```java
public static void getDatabaseMetaData(Connection con) {
    try {
        DatabaseMetaData dbmd = con.getMetaData();
        System.out.println("dbmd:driver version = " + dbmd.getDriverVersion());
        System.out.println("dbmd:driver name = " + dbmd.getDriverName());
        System.out.println("db name = " + dbmd.getDatabaseProductName());
        System.out.println("db ver = " + dbmd.getDatabaseProductVersion());
    }
    // Handle any errors that may have occurred.
    catch (SQLException e) {
        e.printStackTrace();
    }
}
```


## 返回IDENTITY column的结果

如果Table的ID设置为IDENTITY，那么通常程序需要拿到插入成功获得ID。

官方文档：[Link](https://docs.microsoft.com/en-us/sql/connect/jdbc/using-auto-generated-keys)


示例Table：   

```sql
CREATE TABLE TestTable
   (Col1 int IDENTITY,
    Col2 varchar(50),
    Col3 int); 
```


示例代码：   

```java
public static void executeInsertWithKeys(Connection con) {
    try(Statement stmt = con.createStatement();) {
        String SQL = "INSERT INTO TestTable (Col2, Col3) VALUES ('S', 50)";
        int count = stmt.executeUpdate(SQL, Statement.RETURN_GENERATED_KEYS);
        ResultSet rs = stmt.getGeneratedKeys();

        ResultSetMetaData rsmd = rs.getMetaData();
        int columnCount = rsmd.getColumnCount();
        if (rs.next()) {
            do {
                for (int i=1; i<=columnCount; i++) {
                    String key = rs.getString(i);
                    System.out.println("KEY " + i + " = " + key);
                }
            } while(rs.next());
        }
        else {
            System.out.println("NO KEYS WERE GENERATED.");
        }
    }
    // Handle any errors that may have occurred.
    catch (SQLException e) {
        e.printStackTrace();
    }
}
```

