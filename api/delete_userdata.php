<?php
    // include database and object file
    include_once 'database.php';
    include_once 'bo_userdata.php';

    // get database connection
    $database = new Database();
    $db = $database->getConnection();

    // prepare userdata object
    $userdata = new userdata($db);

    // get userdata id
    $data = json_decode(file_get_contents("php://input"));

    // set userdata id to be deleted
    $userdata->id = $data->id;

    // delete the userdata
    if($userdata->delete()){
        echo "userdata was deleted.";
    } else { // if unable to delete the userdata
        echo "Unable to delete object.";
    }
?>