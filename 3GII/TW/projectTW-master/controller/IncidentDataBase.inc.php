<?php

require_once './controller/DataBase.inc.php';


class IncidentDataBase
{
	
	private static $database;
	private static $connection;

	function __destrct()
	{
		unset(self::$connection);
		unset(self::$database);
	}

	public static function getConnection(){

		if(! self::$database){
			// self::$database = new DataBase("localhost", "sibw", "_aprobandoSIBWconUn10", "tw");
			self::$database = new DataBase("localhost", "ignaciove1819", "xM1X8PPU", "ignaciove1819");
			self::$connection = self::$database -> getConnection();

			if(! self::$connection)
				die("Conexión fallida: ");
		}
		
		return self::$connection; 

	}

	public static function query($sql) {
		$result = [];

		if($query = self::getConnection() -> query($sql)) {
			while($obj = $query -> fetch_object()) {
				array_push($result, $obj);
			}
		}
		
		return $result;
	}
}
	
?>
