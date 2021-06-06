<?php
	require_once './controller/Comment.inc.php';
	
	echo "Llamada a comment.php";
	
	if($_SERVER['REQUEST_METHOD'] == 'POST') {
		$action = $_POST['action'];
		$result;
		
		switch($action) {
			case 'new':
				break;
			case 'set':
				break;
			case 'delete':
				$commentId = $_POST['id'];
				$result = Comment::deleteComment($commentId);
				
				if($result == TRUE) {
					$code = 0;
					$message = "Delete comment with id: $commentId completed";
				} else {
					$code = 1;
					$message = "There was a problem deleting the comment with id: $commentId";
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
