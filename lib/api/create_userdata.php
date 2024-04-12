<?php
    // get database connection
    include_once 'database.php';
    $database = new Database();
    $db = $database->getConnection();

    // instantiate userdata object
    include_once 'bo_userdata.php';
    $userdata = new userdata($db);

    // get posted data
    $data = json_decode(file_get_contents("php://input"));

    // set userdata property values
    $userdata->name = $data->name;
    $userdata->xmlcontent = $data->xmlcontent;

    // create the userdata
    if($userdata->create()) {
        echo "userdata was created.";
    } else { // if unable to create the userdata, tell the user
        echo "Unable to create userdata.";
    }
?>