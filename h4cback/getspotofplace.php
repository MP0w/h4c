<?php
//error_reporting(E_ALL);
//ini_set('display_errors', '1');

$con = mysql_connect(localhost,"","");
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }

mysql_select_db("", $con);

 $str;
 $start=$_GET['start'];
 $end=$_GET['end'];
 if (!$start) {
 $start=0;	
 }
 if (!$end) {
 $end=40;	
 }
 
 $placeID=$_GET['placeId'];

$query="SELECT * FROM `mpowit_Fanta`.`gas` WHERE `stationId`='".$placeID."' ORDER BY `date`";

$data=mysql_query($query);

$rows = array();
while($r = mysql_fetch_assoc($data)) {
    $rows[] = $r;
}
print json_encode($rows);

?>