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
 
 $longq=$_GET['long'];
 $latq=$_GET['lat'];
 $dist=10;
 
 if($_GET['distance']){
	 $dist=$_GET['distance'];
 }
 
 $lat1=$latq-(20/69);
 $lat2=$latq+(20/69);
 $long1=$longq-$dist/abs(cos(deg2rad($latq))*69);
 $long2=$longq+$dist/abs(cos(deg2rad($latq))*69);

$query="SELECT *,3956 * 2 * ASIN(SQRT( POWER(SIN((".$latq." -lat) * pi()/180 / 2), 2) +COS(".$latq." * pi()/180) * COS(lat * pi()/180) *POWER(SIN((".$longq." -`long`) * pi()/180 / 2), 2) )) AS distance
FROM `mpowit_Fanta`.`gas`
WHERE  `long` between ".$long1." and ".$long2." and lat between ".$lat1." and ".$lat2."
having distance < ".$dist." ORDER BY `date` DESC  ";

$data=mysql_query($query);

$rows = array();
while($r = mysql_fetch_assoc($data)) {
    $rows[] = $r;
}
print json_encode($rows);

?>