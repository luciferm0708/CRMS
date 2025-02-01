<?php
include '../dbcon.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$img = [];

$upload_dir = "proImageUploads/";
if (!is_dir($upload_dir)) {
    mkdir($upload_dir, 0777, true); // Create directory if it doesn't exist
}

if (isset($_FILES['img']) && is_array($_FILES['img']['name'])) {
    // Handle multiple file uploads
    for ($i = 0; $i < count($_FILES['image']['name']); $i++) {
        $tmp_name = $_FILES['img']['tmp_name'][$i];
        $original_name = $_FILES['img']['name'][$i];

        // Generate a unique filename to avoid conflicts
        $target_file = $upload_dir . uniqid() . '_' . basename($original_name);

        if (move_uploaded_file($tmp_name, $target_file)) {
            // Store the public URL of the uploaded file
            $img[] = "http://192.168.0.25/api_crms/people/" . $target_file;
        } else {
            echo json_encode(["status" => "error", "message" => "Failed to upload file: " . $original_name]);
            exit;
        }
    }
}

// Convert the array of image URLs to a JSON string
$image_urls_json = json_encode($img);

// Insert data into the database
$stmt = $connector->prepare("INSERT INTO peoproImage (img) VALUES (?)");
$stmt->bind_param("s", $image_urls_json);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "data" => "Image submitted successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => "Failed to save image URLs to the database."]);
}
$stmt->close();
$connector->close();
?>
