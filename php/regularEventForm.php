<?php
if (isset($_POST['eventName'], $_POST['eventAddress'], $_POST['eventDesc'], $_POST['fromDate'], $_POST['toDate'])) {
    require_once 'db_config.php';


    $fromDate = $_POST['fromDate'];
    $toDate = $_POST['toDate'];
    $eventName = $_POST['eventName'];
    $eventAddress = $_POST['eventAddress'];
    $eventDesc = $_POST['eventDesc'];
    $approval = "pending";
    $eventType = "regular";

    $sql = "INSERT INTO tbl_events (eventType, eventName, eventAddress, fromDate, toDate, eventDesc, approval) VALUES ('$eventType', '$eventName', '$eventAddress', '$fromDate', '$toDate', '$eventDesc', '$approval')";

    $executeQuery = mysqli_query($db_conn, $sql);

    if ($executeQuery) {
        echo (json_encode(array('statusCode' => '1', 'message' => 'Event submitted!')));
    } else {
        echo (json_encode(array('statusCode' => '0', 'message' => 'Error while submitting event!')));
    }
    mysqli_close($db_conn);
} else echo (json_encode(array('statusCode' => '4', 'message' => 'Error in method!')));
return;
