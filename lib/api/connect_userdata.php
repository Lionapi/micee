<?php
    // include database and object files 
    include_once 'database.php';
    include_once 'bo_userdata.php';

    // get database connection
    $database = new Database();
    $db = $database->getConnection();

    // prepare userdata object
    $userdata = new userdata($db);

    // get properties of userdata to be edited
    $data = json_decode(file_get_contents("php://input"));

    // set properties property of userdata to be edited
    $userdata->Login = $data->Login;
    $userdata->Motdepasse = $data->Motdepasse;

    // read the details of userdata
    $stmt = $userdata->connect();
    // count row
    $num = $stmt->rowCount();

    if($num > 0){
        // get retrieved row
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        // create array
        $userdata_arr[] = array(
            "id" =>  $row['id'],
            "name" => $row['name'],
            "xmlcontent" => $row['xmlcontent']
        );
        // make it json format
        print_r(json_encode($userdata_arr));
    } else {
        echo "Compte ou Mot de passe incorrect.";
    }
?>