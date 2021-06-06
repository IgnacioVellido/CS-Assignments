<?php
	require_once './common.php';
	require_once './controller/Incident.inc.php';
	require_once './controller/User.inc.php';
	
	$arguments = [];
	prepareArguments($arguments);
	
	$arguments['incidents'] = Incident::getIncidents();
	$arguments['users'] = User::getUsers();
	
	renderTemplate('./view/html/user-management.html', $arguments);
?>
