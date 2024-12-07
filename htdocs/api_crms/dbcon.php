<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");


$serverHost = "localhost";
$user = "root";
$password = "";
$database = "crms";

$connector = new mysqli($serverHost, $user, $password, $database);