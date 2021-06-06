<?php
	require_once './controller/Incident.inc.php';
	
	if($_SERVER['REQUEST_METHOD'] == 'POST') {
		$action = $_POST['action'];
		$result;
		
		switch($action) {
			case 'new':
				break;
			case 'set':
				break;
			case 'delete':
				$incidentId = $_POST['id'];
				$result = Incident::deleteIncident($incidentId);
				
				if($result == TRUE) {
					$code = 0;
					$message = "Delete incident with id: $incidentId completed";
				} else {
					$code = 1;
					$message = "There was a problem deleting the incident with id: $incidentId";
				}
				
				break;
			default:
		}
		
	} else if($_SERVER['REQUEST_METHOD'] == 'GET') {
		$code = 0;
		$message = "Calling with GET";
	} else {
		$code = 1;
		$message = "Bad request method";
	}
	
	echo "{
		\"code\": \"$code\",
		\"message\": \"$message\"
	}";
?>
