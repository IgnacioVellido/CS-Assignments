<?php
	require_once './controller/IncidentDataBase.inc.php';
	require_once './controller/Incident.inc.php';
	require_once './common.php';

	class User {
		public static function createUser($name, $surname, $password, $email, $mailingAddress, $phoneNumber, $kind, $photo) {
			$fields = "insert into User(name, surname, password, email, phoneNumber, kind";
			$values .= " values ($name, $surname, $password, $email, $phoneNumber, $kind";
			
			if($mailingAddress != null) {
				$fields .= ", mailingAddress";
				$values .= ", $mailingAddress";
			}
			
			if($photo != null) {
				$fields .= ", photo";
				$values .= ", $photo";
			}
			
			$fields .= ")";
			$values .= ");";
			
			return IncidentDataBase::query($fields . $values);
		}
		
		public static function deleteUser($userId) {
			$incidents = Incident::getIncidentsCreatedByUser($userId);
			
			foreach($incidents as $incident) {
				Incident::deleteIncident($incident["id"]);
			}
			
			$deleteUser = "delete from User where id='$userId';";
			
			return IncidentDataBase::getConnection() -> query($deleteUser);
		}
		
		public static function getUserById($id) {
			$user = IncidentDataBase::query("select * from User where id='$id';")[0];
			
			return castObjectToArray($user);
		}
		
		public static function getUsers() {
			$users = IncidentDataBase::query("select * from User;");
			
			return castObjectsArrayToArraysArray($users);
		}
		
		public static function getUserByEmailAndPassword($email, $password) {
			return castObjectToArray(IncidentDataBase::query("select * from User where email='$email' and password='$password';")[0]);
		}
	}
?>
