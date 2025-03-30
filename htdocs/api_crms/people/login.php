<?php
include "../dbcon.php";
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Retrieve email and password
$email = $_POST['email'];
$password = md5($_POST['pass']);

// Prepared statement to prevent SQL Injection
$stmt = $connector->prepare("SELECT * FROM people WHERE email = ? AND pass = ?");
$stmt->bind_param("ss", $email, $password);
$stmt->execute();
$result = $stmt->get_result();

// Check if user is found
if($result->num_rows > 0) {
    $peopleRecord = $result->fetch_assoc();
    
    // Send success response with peopleData
    echo json_encode(
        array(
            "success" => true,
            "peopleData" => $peopleRecord
        )
    );
} else {
    // Send failure response
    echo json_encode(array("success" => false));
}

// Close the statement
$stmt->close();
?>
