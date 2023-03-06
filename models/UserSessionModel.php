<?php

class UserSessionModel{
    public $enlace;
    protected $session_token;

    public function __construct() {
        $this->enlace=new MySqlConnect();
        session_start();
        $this->generate_token();
    }

    public function get_session_token() {
        return $this->session_token;
    }

    protected function generate_token() {
        $this->session_token = bin2hex(random_bytes(32));
        $_SESSION['session_token'] = $this->session_token;
    }

    public function validate_token($token) {
        return $token === $this->session_token;
    }

    public function all(){
        try {
            //Consulta sql
			$vSql = "SELECT * FROM user_sessions;";
			$this->enlace->connect();
            //Ejecutar la consulta
			$vResultado = $this->enlace->ExecuteSQL ( $vSql);
				
			// Retornar el objeto
			return $vResultado;
		} catch ( Exception $e ) {
			die ( $e->getMessage () );
		}
    }

    public function get($id){
        try {
            //Consulta sql
			$vSql = "SELECT * FROM user_sessions where id=$id";
			$this->enlace->connect();
            //Ejecutar la consulta
			$vResultado = $this->enlace->ExecuteSQL ( $vSql);

           
			// Retornar el objeto
			return $vResultado;
		} catch ( Exception $e ) {
			die ( $e->getMessage () );
		}
    }


    public function create($objeto) {
        try {
            //Consulta sql
            $this->enlace->connect();
			$sql = "Insert into  user_sessions (user_id, session_token, , created_date, updated_date)". 
                     "Values ('$objeto->user_id', '$objeto->session_token', '$objeto->created_date', '$objeto->updated_date')";
	
			$idUserSession = $this->enlace->executeSQL_DML_last( $sql);
           
            return $this->get($idUserSession);
		} catch ( Exception $e ) {
			die ( $e->getMessage () );
		}
    }

    public function update($objeto) {
        try {
            //Consulta sql
            $this->enlace->connect();
			$sql = "UPDATE  user_sessions  SET user_id ='$objeto->user_id',".
            " session_token='$objeto->session_token', created_date=$objeto->created_date, updated_date='$objeto->updated_date'". 
            " Where id='$objeto->id'";
			
            //Ejecutar la consulta
			$cResults = $this->enlace->executeSQL_DML( $sql);
            
            
            //Retornar 
            return $this->get($objeto->id);
		} catch ( Exception $e ) {
			die ( $e->getMessage () );
		}
    }





   
}
?>