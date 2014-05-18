<?php

	$con = mysql_connect(localhost,"","");
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }

mysql_select_db("", $con);
 
 $text=$_GET['text'];
 $long=$_GET['long'];
 $lat=$_GET['lat'];
 $priceB=$_GET['priceB'];
 $priceG=$_GET['priceG'];
 $stationID=$_GET['stationId'];
 
 if($_GET['user']){
	 $user=$_GET['user'];
 }else{
 	$user=$_SERVER['REMOTE_ADDR'];
 }
 
 $text=str_replace("'", "`", $text);
	
	$sql = "INSERT INTO `mpowit_Fanta`.`gas` (`name`, `lat`, `long`, `date`, `stationId`, `priceB`, `priceG`, `message`, `id`) VALUES ('".$_GET['name']."', '".$lat."', '".$long."', CURRENT_TIMESTAMP, '".$stationID."', '".$priceB."', '".$priceG."', '".$text."', NULL);";
	
	if($lat && $long && $stationID && $priceB && $priceG){
	
	mysql_query($sql);
		
		$res=array(
			
			"result"=>"ok",
		
		);
		
		echo(json_encode($res));
		
	}else{
		
		
		$res=array(
			
			"result"=>"error",
		
		);
		
				echo(json_encode($res));
		

	}
	
	
	mysql_close($con);
		

?>