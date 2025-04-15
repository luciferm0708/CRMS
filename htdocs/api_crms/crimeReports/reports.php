<?php
include "../dbcon.php";
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$people_id  = $_POST['people_id'];
$username = $_POST['username'];
$forum = $_POST['forum'];
$description = $_POST['description'];
$image_urls = []; 


$upload_dir = "uploads/";
if (!is_dir($upload_dir)) {
    mkdir($upload_dir, 0777, true); // Create directory if it doesn't exist
}

if (isset($_FILES['image']) && is_array($_FILES['image']['name'])) {
    // Handle multiple file uploads
    for ($i = 0; $i < count($_FILES['image']['name']); $i++) {
        $tmp_name = $_FILES['image']['tmp_name'][$i];
        $original_name = $_FILES['image']['name'][$i];

        // Generate a unique filename to avoid conflicts
        $target_file = $upload_dir . uniqid() . '_' . basename($original_name);

        if (move_uploaded_file($tmp_name, $target_file)) {
            // Store the public URL of the uploaded file
            $image_urls[] = "http://192.168.68.108/api_crms/crimeReports/" . $target_file;
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to upload file: " . $original_name]);
            exit;
        }
    }
}

// Convert the array of image URLs to a JSON string
$image_urls_json = json_encode($image_urls);

// Insert data into the database
$stmt = $connector->prepare("INSERT INTO crime_reports (people_id, username, forum, description, image_urls) VALUES (?, ?, ?, ?, ?)");
$stmt->bind_param("issss", $people_id, $username, $forum, $description, $image_urls_json);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Report submitted successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Failed to submit report"]);
}
// Debugging logs
error_log("people_id: " . $_POST['people_id']);
error_log("forum: " . $_POST['forum']);
error_log("description: " . $_POST['description']);
error_log("Images: " . json_encode($_FILES));
$stmt->close();
?>