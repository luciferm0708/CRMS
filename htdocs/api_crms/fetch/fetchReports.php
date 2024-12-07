<?php
include "../dbcon.php";
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Fetch crime reports
$query = "SELECT * FROM crime_reports ORDER BY id";
$result = $connector->query($query);

if ($result->num_rows > 0) {
    $reports = [];
    while ($row = $result->fetch_assoc()) {
        $row['image_urls'] = json_decode($row['image_urls']); // Convert JSON string to array
        $reports[] = $row;
    }
    echo json_encode(["status" => "success", "reports" => $reports]);
} else {
    echo json_encode(["status" => "error", "message" => "No reports found"]);
}
?>