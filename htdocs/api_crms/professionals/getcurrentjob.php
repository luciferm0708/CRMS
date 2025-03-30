<?php
include "../dbcon.php";

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $professional_id = $_GET['professional_id'];

    $query = $connector->prepare(
        "SELECT crime_reports.* 
        FROM crime_reports 
        INNER JOIN assignments ON crime_reports.id = assignments.report_id 
        WHERE assignments.professional_id = ? AND assignments.is_current = TRUE"
    );
    $query->bind_param("i", $professional_id);
    $query->execute();
    $result = $query->get_result();

    if ($row = $result->fetch_assoc()) {
        echo json_encode(["success" => true, "currentJob" => $row]);
    } else {
        echo json_encode(["success" => false, "message" => "No current job found"]);
    }
}
?>