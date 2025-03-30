<?php
include "../dbcon.php";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $report_id = $_POST['report_id'];
    $professional_id = $_POST['professional_id'];

    // Check the current number of active jobs for the professional
    $checkQuery = $connector->prepare("SELECT COUNT(*) as active_jobs FROM assignments WHERE professional_id = ? AND is_current = TRUE");
    $checkQuery->bind_param("i", $professional_id);
    $checkQuery->execute();
    $result = $checkQuery->get_result();
    $row = $result->fetch_assoc();
    
    if ($row['active_jobs'] >= 3) {
        echo json_encode(["success" => false, "message" => "Professional already has 3 active jobs."]);
        exit();
    }

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
