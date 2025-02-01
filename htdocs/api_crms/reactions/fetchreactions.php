<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
include "../dbcon.php";

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['id'])) {
        getReactions($_GET['id']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Report ID is required']);
    }
}

function getReactions($report_id) {
    global $connector;

    $query = "SELECT reaction_type, COUNT(*) AS count FROM reactions WHERE report_id = ? GROUP BY reaction_type";
    $stmt = $connector->prepare($query);
    $stmt->bind_param("i", $report_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $reactions = [];
    while ($row = $result->fetch_assoc()) {
        $reactions[] = ['reaction_type' => $row['reaction_type'], 'count' => (int) $row['count']];
    }

    echo json_encode(['success' => true, 'reactions' => $reactions]);
    $stmt->close();
    $connector->close();
}
?>
