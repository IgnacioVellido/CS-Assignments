<?php
	require_once './controller/Vote.inc.php';
	
	$message = "";
	$code = "";
	
	if($_SERVER['REQUEST_METHOD'] == 'POST') {
		$userId;
		
		if(isset($_COOKIE['userId'])) {
			$userId = $_COOKIE['userId'];
		} else {
			$userId = 0;
		}
		
		$incidentId = $_POST['incidentId'];
		$positively = $_POST['positively'];
		
		$result = Vote::createVote($userId, $incidentId, $positively);
		
		if($result == TRUE) {
			$code = "0";
			$message = "Operation successfully done";
		} else {
			$code = "1";
			$message = "Something went wrong when voting";
		}
	} else {
		$message = "Bad request http";
		$code = "2";
	}
	
	echo "{
		\"message\": \"$message\",
		\"code\": $code
	}";
?>
