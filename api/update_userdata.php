<?php
    // include database and object files
    include_once 'database.php';
    include_once 'bo_userdata.php';

    // get database connection
    $database = new Database();
    $db = $database->getConnection();

    // prepare userdata object
    $userdata = new userdata($db);

    // get id of userdata to be edited
    $data = json_decode(file_get_contents("php://input"));

    // set ID property of userdata to be edited
    $userdata->id = $data->id;

    // set userdata property values
    $userdata->name = $data->name;
    $userdata->xmlcontent = $data->xmlcontent;

    // update the userdata
    if($userdata->update()){
        echo "userdata was updated.";
    } else { // if unable to update the userdata, tell the user
        echo "Unable to update userdata.";
    }
?>