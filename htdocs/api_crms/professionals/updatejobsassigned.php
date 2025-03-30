<?php
include "../dbcon.php";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $job_id = $_POST['id'];
    $progress = $_POST['progress'];

    if ($progress == 100) {
        $updateQuery = $connector->prepare("UPDATE assignments SET is_current = FALSE, progress = ? WHERE id = ?");
        $updateQuery->bind_param("di", $progress, $job_id);
    } else {
        $updateQuery = $connector->prepare("UPDATE assignments SET progress = ? WHERE id = ?");
        $updateQuery->bind_param("di", $progress, $job_id);
    }

    if ($updateQuery->execute()) {
        echo json_encode(["success" => true, "message" => "Job progress updated successfully."]);
    } else {
        echo json_encode(["success" => false, "message" => "Failed to update job progress."]);
    }
}
?>
