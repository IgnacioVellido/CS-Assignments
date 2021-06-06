<?php
	require_once './controller/User.inc.php';

	if($_SERVER['REQUEST_METHOD'] == 'POST') {
		$action = $_POST['action'];
		$result;
		
		switch($action) {
			case 'new':
				$name = $_POST['name'];
				$surname = $_POST['surname'];
				$password = $_POST['password'];
				$passCheck = $_POST['passCheck'];
				$email = $_POST['email'];
				$mailingAddress = $_POST['mailingAddress'];
				$phoneNumber = $_POST['phoneNumber'];
				$kind = $_POST['kind'];
				$photo = $_POST['photo'];
				
				$result = User::createUser($name, $surname, $password, $email, $mailingAddress, $phoneNumber, $kind, $photo);
				break;
			case 'set':
				break;
			case 'delete':
				$userId = $_POST['id'];
				$result = User::deleteUser($userId);
				
				if($result == TRUE) {
					$code = 0;
					$message = "Delete user with id: $incidentId completed";
				} else {
					$code = 1;
					$message = "There was a problem deleting the user with id: $userId";
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
