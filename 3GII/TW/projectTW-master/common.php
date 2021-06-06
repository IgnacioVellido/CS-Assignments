<?php
	// Argumentos debe ser un array ya inicializado (aunque sea [])
	require_once './controller/Incident.inc.php';
	require_once './controller/User.inc.php';
		
	function prepareArguments(&$argumentos) {
		require_once 'controller/Navigation.inc.php';
		
		$nav = Navigation::getNavVisitor();
		$topNav = $nav[0];
		$asideNav = $nav[1];
		
		$argumentos['topNavigation'] = $topNav;
		$arguments['usersMostPublished'] = getUsersFormattedByMostIncidentsPublished();
		$arguments['usersMostCommented'] = Incident::getUsersByMostCommentsPublished();
	}
	
	function renderTemplate($ruta, &$argumentos) {
		require_once './vendor/autoload.php';
		
		$loader = new \Twig\Loader\FilesystemLoader('.');
		$twig = new \Twig\Environment($loader);
		
		$template = $twig -> load($ruta);
	
		echo $template -> render($argumentos);
	}
	
	function castObjectsArrayToArraysArray(&$objectsArray) {
		$arraysArray = [];
		
		foreach($objectsArray as $object) {
			array_push($arraysArray, castObjectToArray($object));
		}
		
		return $arraysArray;
	}
	
	function castObjectToArray($object) {
		return (array) $object;
	}
	
	function getUsersFormattedByMostIncidentsPublished() {
		$usersIdOrderByMostIncidentsPublished = Incident::getUsersIdOrderByMostIncidentsPublished();
		$usersOrderByMostIncidentsPublished = [];
		
		foreach($usersIdOrderByMostIncidentsPublished as $userId) {
			$user = User::getUserById($userId -> userId);
			$formattedElement = [];
			$formattedElement['incidentsPublished'] = $userId -> numIncidentsPublished;
			$formattedElement['user'] = castObjectToArray($user);
			
			array_push($usersOrderByMostIncidentsPublished, $formattedElement);
		}
		
		return $usersOrderByMostIncidentsPublished;
	}
?>
