<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");
include "../dbcon.php";

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

try {
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        // Fixed the missing closing parentheses in the conditions
        if (!isset($_GET['id'])) throw new Exception('Missing report ID');
        if (!isset($_GET['people_id'])) throw new Exception('Missing people ID');
        
        $report_id = (int)$_GET['id'];
        $people_id = (int)$_GET['people_id'];
        
        // Get reaction counts
        $stmt = $connector->prepare("SELECT reaction_type, COUNT(*) AS count FROM reactions WHERE report_id = ? GROUP BY reaction_type");
        $stmt->bind_param("i", $report_id);
        $stmt->execute();
        $result = $stmt->get_result();
        
        $reactions = [];
        while ($row = $result->fetch_assoc()) {
            $reactions[] = [
                'reaction_type' => $row['reaction_type'],
                'count' => (int)$row['count']
            ];
        }
        $stmt->close();

        // Get user reaction
        $stmt = $connector->prepare("SELECT reaction_type FROM reactions WHERE report_id = ? AND people_id = ?");
        $stmt->bind_param("ii", $report_id, $people_id);
        $stmt->execute();
        $userReaction = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        echo json_encode([
            'success' => true,
            'reactions' => $reactions,
            'user_reaction' => $userReaction ? $userReaction['reaction_type'] : null
        ]);
        exit();
    }
} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage(),
        'error' => $connector->error ?? null
    ]);
    exit();
}
