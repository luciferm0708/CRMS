<?php
include '../dbcon.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");


$email = $_POST['email'];

$query = "SELECT * FROM people WHERE email = '$email'";

$respone = $connector->query($query);

if($respone->num_rows > 0)
{
    echo json_encode(array("emailFound"=>true));
}
else
{
    echo json_encode(array("emailFound"=>false));
}