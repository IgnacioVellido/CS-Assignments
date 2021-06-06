<?php
	require_once './controller/IncidentDataBase.inc.php';
	
	class Navigation
	{
		private static function getNavById($id) {
			$sql = "select content,link from Reference where id='$id';";
			
			return IncidentDataBase::query($sql);
		}
		
		public static function getNavVisitor() {
			$topNav = Navigation::getNavById(0);
			$asideNav = Navigation::getNavById(1);

			return [ $topNav, $asideNav ];
		}
		
		public static function getNavCollaborator() {
			$visitorNav = Navigation::getNavVisitor();
			$topNav = Navigation::getNavById(2);
			$asideNav = Navigation::getNavById(3);
			
			return [ array_merge($topNav, $visitorNav[0]), array_merge($asideNav, $visitorNav[1]) ];
		}
		
		public static function getNavManager() {
			$collaborNav = Navigation::getNavCollaborator();
			$topNav = Navigation::getNavById(4);
			$asideNav = Navigation::getNavById(5);
			
			return [ array_merge($topNav, $collaboratorNav[0]), array_merge($asideNav, $collaboratorNav[1]) ];
		}
	}
?>
