<?php
	require_once './controller/IncidentDataBase.inc.php';
	require_once './common.php';
	
	class Comment {
		public static function deleteComment($id) {
			return IncidentDataBase::getConnection() -> query("delete from Comment where commentId='$id';");
		}
		
		public static function includeAuthorsName($id) {
			$sql = "select userId from Comment where commentId='$id';";
			$userId = IncidentDataBase::query($sql)[0] -> userId;
			
			return Comment::includeAuthorsNameByUserId($userId);
		}
		
		public static function includeAuthorsNameByUserId($userId) {
			$sql = "select name,surname from User where id='$userId';";
			
			return IncidentDataBase::query($sql)[0];
		}
		
		public static function includeAuthorsNameInAllComments($comments) {
			foreach($comments as &$comment) {
				$userName = Comment::includeAuthorsName($comment["commentId"]);
				$comment['authorsName'] = $userName -> name . " " . $userName -> surname;
			}
			
			return $comments;
		}
		
		public static function getUsersIdOrderByMostCommentsPublished() {
			return IncidentDataBase::query("select userId, count(*) as numCommentsPublished from Comment group by userId order by count(*) desc");
		}
		
		public static function getCommentById($id) {
			$sql = "select * from Comment where commentId='$id';";
			$comments = IncidentDataBase::query($sql)[0];
			$formattedComments = castObjectToArray($comments);
			
			return Comment::includeAuthorsName($formattedComments["commentId"]);
		}
		
		public static function getCommentByIncidentId($id) {
			$sql = "select * from Comment where incidentId='$id';";
			$comments = IncidentDataBase::query($sql);
			$formattedComments = castObjectsArrayToArraysArray($comments);

			return Comment::includeAuthorsNameInAllComments($formattedComments);
		}
		
		public static function getCommentByAuthorsName($authorsName) {
			$sql = "select * from Comment where authorsName='$authorsName';";
			$comments = IncidentDataBase::query($sql);
			$formattedComments = castObjectsArrayToArraysArray($comments);

			return Comment::includeAuthorsNameInAllComments($formattedComments);
		}
	}
?>
