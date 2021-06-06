<?php
	require_once './controller/User.inc.php';
	
	$message = "";
	$code = "";
	
	if($_SERVER['REQUEST_METHOD'] == 'POST') {
		switch ($_POST['action']) {
			case 'login':
				if(! isset($_COOKIE['userId'])) {
					$mail = $_POST['email'];
					$password = $_POST['pass'];
					
					$user = User::getUserByEmailAndPassword($mail, $password);
					
					if($user) {
						setcookie('userId', $user["id"]);
						$message = "Login successfully";
						$code = "0";
					} else {
						$message = "User or password are wrong, please try again";
						$code = "1";
					}
					
				} else {
					$message = "Tried to login when the user is currently login";
					$code = "2";
				}
				
				break;
			case 'logout':
				if(isset($_COOKIE['userId'])) {
					setcookie('userId', null, -1);
					unset($_COOKIE['userId']);
					
					$message = "Log out successfully";
					$code = "0";
				} else {
					$message = "Tried to logout when the user wasn't login";
					$code = "3";
				}
				break;
		}
		
		
	} else {
		$message = "Bad request http";
		$code = "4";
	}
	
	echo "{
		\"message\": \"$message\",
		\"code\": $code
	}";
?>
