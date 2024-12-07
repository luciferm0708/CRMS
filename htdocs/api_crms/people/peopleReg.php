<?php
include "../dbcon.php";
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");


$firstName = $_POST['first_name'];
$lastName = $_POST['last_name'];
$userName = $_POST['username'];
$gender = $_POST['gender'];
$nid = $_POST['nid'];
$dob = $_POST['dob'];
$email = $_POST['email'];
$password = md5($_POST['pass']);
$confirm_password = md5($_POST['confirm_pass']);

$query = "INSERT INTO people SET first_name = '$firstName', last_name = '$lastName',
          username = '$userName', gender = '$gender', nid = '$nid', dob = '$dob', 
          email = '$email', pass = '$password', confirm_pass = '$confirm_password'";

$respone = $connector->query($query);

if($respone) 
{
    echo json_encode(array("success" => true));
} 
else 
{
    echo json_encode(array("success" => false, "error" => $connector->error));
}
