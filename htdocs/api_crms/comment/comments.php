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

    // Get POST data
    $report_id = $_POST['report_id'] ?? null;
    $people_id = $_POST['people_id'] ?? null;
    $comment_text = $_POST['comment_text'] ?? null;

    // Validate inputs
    if (!$report_id || !$people_id || !$comment_text) {
        echo json_encode(['success' => false, 'message' => 'Invalid input']);
        return;
    }

    // Insert the comment into the database
    $query = "INSERT INTO comments (report_id, people_id, comment_text, created_at) VALUES (?, ?, ?, NOW())";
    $stmt = $connector->prepare($query);
    $stmt->bind_param("iis", $report_id, $people_id, $comment_text);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Comment added']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Database error']);
    }

    $stmt->close();
    $connector->close();
}
