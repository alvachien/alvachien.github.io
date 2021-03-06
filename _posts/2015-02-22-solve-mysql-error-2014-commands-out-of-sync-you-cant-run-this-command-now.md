---
layout: post
title: "Solve MySQL error 2014: Commands out of sync; you can't run this command now"
date: 2015-02-22 16:05
author: alvachien
comments: true
tags: [MySql, mysqli, PHP, Web Development]
categories: [技术Tips]
---
如果需要在新插入数据记录后立刻进行查询，则可能遇到著名的MySQL error 2014: Commands out of sync; you can't run this command now

问题的关键在于，执行完插入语句之后，必须对statement进行显式地close。而且，必须是使用statement对象。

示例的成功代码：

```php
$mysqli = new mysqli( MySqlHost, MySqlUser, MySqlPwd, MySqlDB );

/* check connection */
if (mysqli_connect_errno ()) {
    die("Connect failed: %s\n" . mysqli_connect_error ());
}

$sError = "";
$nCode = 0;
$nNewid = 0;
$sMsg = "";

// Create award: return code, message and last insert id
/* Prepare an insert statement */
$query = "CALL " . MySqlLearnObjectCreateProc . "(?, ?, ?);";

if ($stmt = $mysqli->prepare($query)) {
    $stmt->bind_param("iss", $ctgyid, $name, $content);
    /* Execute the statement */
    if ($stmt->execute()) {
        /* bind variables to prepared statement */
        $stmt->bind_result($code, $msg, $lastid);

        /* fetch values */
        while ($stmt->fetch()) {
            $nCode = (int) $code;
            $sMsg = $msg;
            $nNewid = (int)$lastid;
        }
    } else {
        $nCode = 1;
        $sMsg = "Failed to execute query: ". $query;
    }

    /* close statement */
    $stmt->close();
} else {
    $nCode = 1;
    $sMsg = "Failed to parpare statement: ". $query;
}

$rsttable = array();
if ($nCode > 0) {
    $sError = $sMsg;
} else if ($nCode === 0 &amp;&amp; $nNewid > 0) {
    $query = "SELECT ID, CATEGORY_ID, CATEGORY_NAME, NAME, CONTENT FROM " . MySqlLearnObjListView . " WHERE ID = ". $nNewid;

    if ($result = $mysqli->query($query)) {
        /* fetch associative array */
        while ($row = $result->fetch_row()) {
            $rsttable [] = array (
                "id" => $row [0],
                "categoryid" => $row [1],
                "categoryname" => $row [2],
                "name" => $row[3],
                "content" => $row[4]
            );
        }
        /* free result set */
        $result->close();
    } else {
        $sError = "Failed to execute query: ". $query . " ; Error: ". $mysqli->error;
    }
}

/* close connection */
$mysqli->close();
```

是为之记。
Alva Chien
2015.2.22
