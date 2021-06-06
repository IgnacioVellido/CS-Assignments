<?php

	require_once './controller/IncidentDataBase.inc.php';
	
	class Image {
		public static function getImagesByIncidentId($incidentId) {
			return IncidentDataBase::query("select path,description from Images where incidentId='$incidentId';");
		}
	}
?>
