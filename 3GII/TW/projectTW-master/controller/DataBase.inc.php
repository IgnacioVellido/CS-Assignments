<?php

class DataBase
{
	
	private $connection;
	private $server;
	private	$user;
	private	$password;
	private	$database;

	function __construct($server, $user, $password, $database)
	{
		$this->server = $server;
		$this->user = $user;
		$this->password = $password;
		$this->database = $database;
	}

	function __destrct()
	{
		unset($connection);
		unset($server);
		unset($user);
		unset($password);
		unset($database);
	}

	public function getConnection() {
		if(! $this->connection){
			$this->connection = new mysqli($this->server, $this->user, $this->password, $this->database);
		
			if(! $this->connection)
				die("Connection failed: ");
				
			$this->connection->set_charset("utf8");
		}
		
		return $this->connection; 

	}

	
}
	
?>
