<?php
include '../dbcon.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$email = $_POST['email'];

// Prepared statement to prevent SQL Injection
$query = "SELECT * FROM ProfessionalRegistration WHERE email = ?";
$stmt = $connector->prepare($query);
$stmt->bind_param("s", $email);
$stmt->execute();
$response = $stmt->get_result();

if ($response->num_rows > 0) {
    echo json_encode(array("emailFound" => true));
} else {
    echo json_encode(array("emailFound" => false));
}

$stmt->close();
?>
