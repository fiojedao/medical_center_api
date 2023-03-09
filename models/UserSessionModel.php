<?php

class UserSessionModel{
    public $enlace;
    protected $session_token;
    
    /**
     * __construct
     *
     * @return void
     */
    public function __construct() {
        $this->enlace = new BaseModel('user_sessions', 'id', new MySqlConnect(), 'email');
    }
    
    function getUserByUserEmail($useremail) {
        try {
            $vResultado = $this->enlace->find_by_email($id);
			return $vResultado;
		} catch ( Exception $e ) {
			die ( $e->getMessage () );
		}
    }

    function storeToken($userId, $token) {
        $query = "INSERT INTO tokens (user_id, token) VALUES (?, ?)";
        $stmt = mysqli_prepare($this->connection, $query);
        mysqli_stmt_bind_param($stmt, "is", $userId, $token);
        mysqli_stmt_execute($stmt);
    }

    function deleteToken($token) {
        $query = "DELETE FROM tokens WHERE token = ?";
        $stmt = mysqli_prepare($this->connection, $query);
        mysqli_stmt_bind_param($stmt, "s", $token);
        mysqli_stmt_execute($stmt);
    }

    function getTokenUserId($token) {
        $query = "SELECT user_id FROM tokens WHERE token = ?";
        $stmt = mysqli_prepare($this->connection, $query);
        mysqli_stmt_bind_param($stmt, "s", $token);
        mysqli_stmt_execute($stmt);
        $result = mysqli_stmt_get_result($stmt);

        if (mysqli_num_rows($result) === 0) {
            return false;
        }

        $row = mysqli_fetch_assoc($result);
        return $row['user_id'];
    }

    /**
     * all
     *
     * @return void
     */
    public function all(){
        try {
			$vResultado = $this->enlace->find_all();
			return $vResultado;
		} catch ( Exception $e ) {
			die ( $e->getMessage () );
		}
    }
    
    /**
     * get
     *
     * @param  mixed $id
     * @return void
     */
    public function get($id){
        try {

            $vResultado = $this->enlace->find_by_id($id);
            
			return $vResultado;
		} catch ( Exception $e ) {
			die ( $e->getMessage () );
		}
    }
    
    /**
     * create
     *
     * @param  mixed $objeto
     * @return void
     */
    public function create($objeto) {
        try {
            //Consulta sql
            $this->enlace->connect();
			$sql = "Insert into  user_sessions (user_id, session_token )". 
                     "Values ('$objeto->user_id', '$objeto->session_token')";
	
			$idUserSession = $this->enlace->executeSQL_DML_last( $sql);
           
            return $this->get($idUserSession);
		} catch ( Exception $e ) {
			die ( $e->getMessage () );
		}
    }
    
    /**
     * update
     *
     * @param  mixed $objeto
     * @return void
     */
    public function update($objeto) {
        try {
            //Consulta sql
            $this->enlace->connect();
			$sql = "UPDATE  user_sessions  SET user_id ='$objeto->user_id', session_token='$objeto->session_token', updated_date = CURRENT_TIMESTAMP()". 
            " Where id ='$objeto->id'";
			
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