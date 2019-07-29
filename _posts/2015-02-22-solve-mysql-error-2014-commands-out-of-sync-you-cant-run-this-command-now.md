---
layout: post
title: "Solve MySQL error 2014: Commands out of sync; you can't run this command now"
date: 2015-02-22 16:05
author: alvachien
comments: true
categories: [MySql, mysqli, PHP, Web Development]
---
如果需要在新插入数据记录后立刻进行查询，则可能遇到著名的MySQL error 2014: Commands out of sync; you can't run this command now

问题的关键在于，执行完插入语句之后，必须对statement进行显式地close。而且，必须是使用statement对象。

示例的成功代码：

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

if ($stmt = $mysqli-&gt;prepare($query)) {
$stmt-&gt;bind_param("iss", $ctgyid, $name, $content);
/* Execute the statement */
if ($stmt-&gt;execute()) {
/* bind variables to prepared statement */
$stmt-&gt;bind_result($code, $msg, $lastid);

/* fetch values */
while ($stmt-&gt;fetch()) {
$nCode = (int) $code;
$sMsg = $msg;
$nNewid = (int)$lastid;
}
} else {
$nCode = 1;
$sMsg = "Failed to execute query: ". $query;
}

/* close statement */
$stmt-&gt;close();
} else {
$nCode = 1;
$sMsg = "Failed to parpare statement: ". $query;
}

$rsttable = array();
if ($nCode &gt; 0) {
$sError = $sMsg;
} else if ($nCode === 0 &amp;&amp; $nNewid &gt; 0) {
$query = "SELECT ID, CATEGORY_ID, CATEGORY_NAME, NAME, CONTENT FROM " . MySqlLearnObjListView . " WHERE ID = ". $nNewid;

if ($result = $mysqli-&gt;query($query)) {
/* fetch associative array */
while ($row = $result-&gt;fetch_row()) {
$rsttable [] = array (
"id" =&gt; $row [0],
"categoryid" =&gt; $row [1],
"categoryname" =&gt; $row [2],
"name" =&gt; $row[3],
"content" =&gt; $row[4]
);
}
/* free result set */
$result-&gt;close();
} else {
$sError = "Failed to execute query: ". $query . " ; Error: ". $mysqli-&gt;error;
}
}

/* close connection */
$mysqli-&gt;close();

是为之记。
Alva Chien
2015.2.22
