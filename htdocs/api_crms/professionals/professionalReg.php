<?php
include "../dbcon.php";
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Retrieve and sanitize input
$professionType = $_POST['profession_type'] ?? '';
$firstName = $_POST['first_name'] ?? '';
$lastName = $_POST['last_name'] ?? '';
$userName = $_POST['username'] ?? '';
$email = $_POST['email'] ?? '';
$organizationName = $_POST['organization_name'] ?? '';
$licenseNumber = $_POST['license_number'] ?? '';
$nidNumber = $_POST['nid_number'] ?? '';
$expertiseArea = $_POST['expertise_area'] ?? '';
$password = isset($_POST['pass']) ? md5($_POST['pass']) : '';
$confirmPassword = isset($_POST['confirm_pass']) ? md5($_POST['confirm_pass']) : '';

// Validate required fields
if (empty($professionType) || empty($firstName) || empty($email) || empty($password)) {
    echo json_encode(array("success" => false, "error" => "Required fields are missing."));
    exit;
}

// Ensure passwords match
if ($password !== $confirmPassword) {
    echo json_encode(array("success" => false, "error" => "Passwords do not match."));
    exit;
}

// Correct SQL query with prepared statement
$query = "INSERT INTO ProfessionalRegistration 
          (profession_type, first_name, last_name, username, email, organization_name, license_number, nid_number, expertise_area, pass, confirm_pass) 
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
$stmt = $connector->prepare($query);
$stmt->bind_param(
    "sssssssssss",
    $professionType, $firstName, $lastName, $userName, $email, $organizationName,
    $licenseNumber, $nidNumber, $expertiseArea, $password, $confirmPassword
);

// Execute query and handle response
if ($stmt->execute()) {
    echo json_encode(array("success" => true));
} else {
    echo json_encode(array("success" => false, "error" => $stmt->error));
}

$stmt->close();
?>
