<?php

include "../dbcon.php";
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    addComment();
}

function addComment() {
    global $connector;

    $input = json_decode(file_get_contents('php://input'), true) ?? $_POST;
    
    $report_id = $input['report_id'] ?? null;
    $professional_id = $input['professional_id'] ?? null;
    $comment_text = $input['comment_text'] ?? null;

    $missing = [];
    if (!$report_id) $missing[] = 'report_id';
    if (!$professional_id) $missing[] = 'professional_id';
    if (!$comment_text) $missing[] = 'comment_text';
    
    if (!empty($missing)) {
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'message' => 'Missing required fields: ' . implode(', ', $missing)
        ]);
        return;
    }

    try {
        $query = "INSERT INTO prof_comments 
                 (report_id, professional_id, comment_text) 
                 VALUES (?, ?, ?)";
        $stmt = $connector->prepare($query);
        $stmt->bind_param("iis", $report_id, $professional_id, $comment_text);
        
        if ($stmt->execute()) {
            echo json_encode([
                'success' => true,
                'message' => 'Comment added successfully',
                'comment_id' => $stmt->insert_id
            ]);
        } else {
            throw new Exception("Database error: " . $stmt->error);
        }
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'message' => 'Failed to add comment: ' . $e->getMessage()
        ]);
    } finally {
        if (isset($stmt)) $stmt->close();
    }
}