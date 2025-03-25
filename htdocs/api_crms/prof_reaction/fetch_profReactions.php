<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
include "../dbcon.php";

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['id']) && isset($_GET['professional_id'])) {
        getReactions($_GET['id'], $_GET['professional_id']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Report ID and Professional ID are required']);
    }
}

function getReactions($report_id, $professional_id) {
    global $connector;

    // Get reaction counts
    $query = "SELECT reaction_type, COUNT(*) AS count FROM reactions WHERE report_id = ? GROUP BY reaction_type";
    $stmt = $connector->prepare($query);
    $stmt->bind_param("i", $report_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $reactions = [];
    while ($row = $result->fetch_assoc()) {
        $reactions[] = ['reaction_type' => $row['reaction_type'], 'count' => (int) $row['count']];
    }
    $stmt->close();

    // Get user's reaction for this post
    $userReactionQuery = "SELECT reaction_type FROM reactions WHERE report_id = ? AND professional_id = ?";
    $stmt = $connector->prepare($userReactionQuery);
    $stmt->bind_param("ii", $report_id, $professional_id);
    $stmt->execute();
    $userResult = $stmt->get_result();
    $userReaction = $userResult->fetch_assoc();
    $stmt->close();

    echo json_encode([
        'success' => true,
        'reactions' => $reactions,
        'user_reaction' => $userReaction ? $userReaction['reaction_type'] : null
    ]);
}
?>