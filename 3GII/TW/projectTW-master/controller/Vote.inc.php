<?php
	require_once './controller/DataBase.inc.php';
	require_once './controller/IncidentDataBase.inc.php';
	
	class Vote
	{
		public static function numberPeopleVotedIncident($incidentId, $alias, $positively) {
			$sql = "select count(*) as $alias from Vote where incidentId='$incidentId' and positively='$positively';";
			
			return IncidentDataBase::query($sql)[0];
		}
		
		public static function userAlreadyVotedTheIncident($userId, $incidentId) {
			$voted = IncidentDataBase::query("select count(*) as voted from Vote where userId='$userId' and incidentId='$incidentId';") -> voted;
			
			return ($voted == 1) ? true : false;
		}
		
		public static function numberPeopleAprovedIncident($incidentId) {
			return Vote::numberPeopleVotedIncident($incidentId, "numPeopleAproved", 1) -> numPeopleAproved;
		}
		
		public static function numberPeopleDenyIncident($incidentId) {
			return Vote::numberPeopleVotedIncident($incidentId, "numPeopleDeny", 0) -> numPeopleDeny;
		}
		
		public static function createVote($userId, $incidentId, $positively) {
			return IncidentDataBase::query("insert into Vote values ('$userId', '$incidentId', $positively);");
		}
	}
?>
