<?php
include "../dbcon.php";
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header('Content-Type: application/json'); // Make sure the response is treated as JSON

// Fetch crime reports
$query = "SELECT * FROM crime_reports ORDER BY id";
$result = $connector->query($query);

if ($result->num_rows > 0) {
    $reports = [];
    while ($row = $result->fetch_assoc()) {
        // Decode image URLs from JSON
        $row['image_urls'] = json_decode($row['image_urls'], true);

        // Add username (already part of the table, assuming 'username' exists)
        $reports[] = $row;
    }

    // Respond with the reports data including username
    echo json_encode([
        "status" => "success",
        "reports" => $reports
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "No reports found"
    ]);
}
?>
