<?php
	require_once './controller/IncidentDataBase.inc.php';
	require_once './common.php';
	
	class Keyword {
		public static function formatObjectsToElements($keywords) {
			$formattedKeywords = [];
			
			foreach($keywords as $key) {
				array_push($formattedKeywords, castObjectToArray($key)["keyword"]);
			}
			
			return $formattedKeywords;
		}
		
		public static function getKeywordsByIncidentId($incidentId) {
			$keywords = IncidentDataBase::query("select keyword from Keyword where incidentId='$incidentId';");
			
			return Keyword::formatObjectsToElements($keywords);
		}
		
		public static function getKeywords() {
			return IncidentDataBase::query("select keyword from Keyword;");
		}
	}
?>
