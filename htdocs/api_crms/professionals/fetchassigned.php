<?php
include "../dbcon.php";

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (!isset($_GET['professional_id'])) {
        echo json_encode(["success" => false, "message" => "professional_id is required."]);
        exit;
    }

    $professional_id = $_GET['professional_id'];

    $query = $connector->prepare("SELECT * FROM assignments WHERE professional_id = ? AND is_current = TRUE");
    $query->bind_param("i", $professional_id);
    $query->execute();

    $result = $query->get_result();
    $jobs = [];
    while ($row = $result->fetch_assoc()) {
        $jobs[] = $row;
    }

    // Debugging: Log the result
    error_log("Jobs for professional_id $professional_id: " . json_encode($jobs));

    echo json_encode(["success" => true, "jobs" => $jobs]);
}
?>
