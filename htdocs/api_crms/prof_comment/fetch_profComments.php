<?php
include "../dbcon.php";
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['id'])) {
        getComments($_GET['id']);
    } else {
        echo json_encode([
            'success' => false, 
            'message' => 'Report ID is required'
        ]);
    }
    exit();
}

function getComments($report_id) {
    global $connector;
    
    // Query to fetch comments with the professional's username.
    $query = "
        SELECT pc.comment_text, pr.username, pc.created_at
        FROM prof_comments pc
        JOIN professionalregistration pr ON pc.professional_id = pr.professional_id
        WHERE pc.report_id = ?
        ORDER BY pc.created_at DESC
    ";
    
    $stmt = $connector->prepare($query);
    if (!$stmt) {
        echo json_encode([
            'success' => false, 
            'message' => 'Query prepare failed: ' . $connector->error
        ]);
        exit();
    }
    $stmt->bind_param("i", $report_id);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $comments = [];
    while ($row = $result->fetch_assoc()) {
        $comments[] = $row;
    }
    
    echo json_encode([
        'success' => true,
        'comments' => $comments
    ]);
    $stmt->close();
    $connector->close();
}
?>
