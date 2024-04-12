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

    // read the details of userdata to be edited
    $userdata->readOne();

    // create array
    $userdata_arr[] = array(
        "id" =>  $userdata->id,
        "name" => $userdata->name,
        "xmlcontent" => $userdata->xmlcontent
    );

    // make it json format
    print_r(json_encode($userdata_arr));
?>