<?php
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");

    // include database and object files
    include_once 'database.php';
    include_once 'bo_userdata.php';

    // instantiate database and userdata object
    $database = new Database();
    $db = $database->getConnection();

    // initialize object
    $userdata = new userdata($db);

    // query userdatas
    $stmt = $userdata->readAll();

    // count row
    $num = $stmt->rowCount();

    $data = "";

    // check if more than 0 record found
    if($num>0){
        $x=1;
        // retrieve our table contents
        // fetch() is faster than fetchAll()
        // http://stackoverflow.com/questions/2770630/pdofetchall-vs-pdofetch-in-a-loop
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)){
            // extract row
            // this will make $row['name'] to
            // just $name only
            extract($row);

            $data .= '{';
                $data .= '"id":"'  . $id . '",';
                $data .= '"name":"' . $name . '",';
                $data .= '"xmlcontent":"' . html_entity_decode($xmlcontent) . '"';
            $data .= '}';

            $data .= $x<$num ? ',' : ''; $x++; 
        }
    }

    // json format output
    echo '{"records":[' . $data . ']}';
?>