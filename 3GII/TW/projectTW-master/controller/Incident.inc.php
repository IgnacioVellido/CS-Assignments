<?php

	require_once './controller/IncidentDataBase.inc.php';
	require_once './controller/User.inc.php';
	require_once './controller/Vote.inc.php';
	require_once './controller/Keyword.inc.php';
	require_once './controller/Comment.inc.php';
	require_once './controller/Image.inc.php';
	require_once './common.php';
	
	class Incident
	{
		public static function deleteIncident($incidentId) {
			$deleteImages = IncidentDataBase::getConnection() -> query("delete from Images where incidentId='$incidentId';");
			$deleteComments = IncidentDataBase::getConnection() -> query("delete from Comment where incidentId='$incidentId';");
			$deleteKeywords = IncidentDataBase::getConnection() -> query("delete from Keyword where incidentId='$incidentId';");
			$deleteVotes = IncidentDataBase::getConnection() -> query("delete from Vote where incidentId='$incidentId';");
			$deleteIncident = IncidentDataBase::getConnection() -> query("delete from Incident where id='$incidentId';");
			
			return $deleteImages && $deleteComments && $deleteKeywords && $deleteIncident && $deleteVotes;
		}
		
		public static function getAuthorsName($userId) {
			return IncidentDataBase::query("select name from User where id='$userId';")[0] -> name;
		}
		
		public static function getPositivelyVotes($incidentId) {
			return Vote::numberPeopleAprovedIncident($incidentId);
		}
		
		public static function getDenyVotes($incidentId) {
			return Vote::numberPeopleDenyIncident($incidentId);
		}
		
		public static function getKeywordsByIncidentId($incidentId) {
			return Keyword::getKeywordsByIncidentId($incidentId);
		}
		
		public static function getCommentsByIncidentId($incidentId) {
			return Comment::getCommentByIncidenId($incidentId);
		}
		
		public static function getUsersIdOrderByMostIncidentsPublished() {
			return IncidentDataBase::query("select userId, count(*) as numIncidentsPublished from Incident group by userId order by count(*) desc");
		}
		
		public static function getUsersByMostCommentsPublished() {
			$usersId = Comment::getUsersIdOrderByMostCommentsPublished();
			$users = [];
			
			foreach($usersId as $id) {
				$user = User::getUserById($id -> userId);
				
				$formattedUser = [];
				$formattedUser['user'] = castObjectToArray($user);
				$formattedUser['commentsPublished'] = $id -> numCommentsPublished;
				array_push($users, $formattedUser);
			}
			
			return $users;
		}
		
		public static function formatIncidents($incidents) {
			$formattedIncidents = [];
			
			foreach($incidents as $element) {
				$formattedElement = (array) $element;
				$id = $formattedElement['id'];
				$userId = $formattedElement['userId'];
				$denyVotes = Incident::getDenyVotes($id);
				$authorsName = Incident::getAuthorsName($userId);
				$comments = Comment::getCommentByIncidentId($id);
				$keywords = Incident::getKeywordsByIncidentId($id);
				$images = Image::getImagesByIncidentId($id);

				$formattedElement['approveVotes'] = Incident::getPositivelyVotes($id);
				$formattedElement['denyVotes'] = Incident::getDenyVotes($id);
				$formattedElement['authorsName'] = Incident::getAuthorsName($userId);
				$formattedElement['keywords'] = implode(",", $keywords);
				$formattedElement['comments'] = $comments;
				$formattedElement['images'] = castObjectsArrayToArraysArray($images);
				
				array_push($formattedIncidents, $formattedElement);
			}
			
			return $formattedIncidents;
		}
		
		public static function getIncident($id) {
			$incident = IncidentDataBase::query("select * from Incident where id='$id';");
			
			return Incident::formatIncidents($incident)[0];
		}
		
		public static function getIncidents() {
			$incidents = IncidentDataBase::query("select * from Incident;");
			
			return Incident::formatIncidents($incidents);
		}
		
		public static function getIncidentsCreatedByUser($userId) {
			$incidents = IncidentDataBase::query("select * from Incident where userId='$userId';");
			
			return Incident::formatIncidents($incidents);
		}
	}

?>
