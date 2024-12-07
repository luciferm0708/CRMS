<?php
include '../dbcon.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if (isset($_FILES['image']) && $_FILES['image']['error'] == UPLOAD_ERR_OK) {
    $fileTmpPath = $_FILES['image']['tmp_name'];
    $fileType = mime_content_type($fileTmpPath);

    // Log file info for debugging
    error_log("Uploaded file type: " . $fileType);
    error_log("Uploaded file path: " . $fileTmpPath);

    // Verify that the uploaded file is an image
    if (strpos($fileType, 'image/') === 0) {
        // Read the image content
        $imageData = file_get_contents($fileTmpPath);

        try {
            // Insert the image into the database
            $stmt = $pdo->prepare("INSERT INTO peoproImage (img) VALUES (:img)");
            $stmt->bindParam(':img', $imageData, PDO::PARAM_LOB);
            $stmt->execute();

            // Response
            echo json_encode(["success" => "Image uploaded successfully", "id" => $pdo->lastInsertId()]);
        } catch (PDOException $e) {
            error_log("Database error: " . $e->getMessage());
            echo json_encode(["error" => "Image upload failed: " . $e->getMessage()]);
        }
    } else {
        echo json_encode(["error" => "Uploaded file is not an image."]);
    }
} else {
    error_log("Upload error: " . $_FILES['image']['error']);
    echo json_encode(["error" => "No image file received or upload error."]);
}

?>
