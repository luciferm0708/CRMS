<?php
include "../dbcon.php";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $report_id = $_POST['report_id'];
    $professional_id = $_POST['professional_id'];

    // Mark previous assignments as not current
    $updateQuery = $connector->prepare("UPDATE assignments SET is_current = FALSE WHERE professional_id = ?");
    $updateQuery->bind_param("i", $professional_id);
    $updateQuery->execute();

    // Assign the new job
    $insertQuery = $connector->prepare("INSERT INTO assignments (report_id, professional_id, is_current) VALUES (?, ?, TRUE)");
    $insertQuery->bind_param("ii", $report_id, $professional_id);

    if ($insertQuery->execute()) {
        echo json_encode(["success" => true, "message" => "Job assigned successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "Failed to assign job"]);
    }
}
?>