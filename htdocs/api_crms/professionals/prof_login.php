<?php
include "../dbcon.php";
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Retrieve email and password
$email = $_POST['email'];
$password = md5($_POST['pass']);

// Prepared statement to prevent SQL Injection
$stmt = $connector->prepare("SELECT * FROM ProfessionalRegistration WHERE email = ? AND pass = ?");
$stmt->bind_param("ss", $email,  $password);
$stmt->execute();
$result = $stmt->get_result();

// Check if user is found
if($result->num_rows > 0) {
    $profRecord = $result->fetch_assoc();
    
    // Send success response with profData
    echo json_encode(
        array(
            "success" => true,
            "professionalData" => $profRecord
        )
    );
} else {
    // Send failure response
    echo json_encode(array("success" => false));
}

$stmt->close();
?>
