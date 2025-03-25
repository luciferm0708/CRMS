<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
include "../dbcon.php";

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['id'])) {
        getComments($_GET['id']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Report ID is required']);
    }
}

function getComments($report_id) {
    global $connector;

    // Query to fetch comments along with the user's username
    $query = "
        SELECT prof_comments.comment_text, professionalregistration.username, prof_comments.created_at
        FROM comments
        JOIN professionalregistration ON prof_comments.professional_id = professional_id
        WHERE prof_comments.report_id = ?
        ORDER BY prof_comments.created_at DESC
    ";

    $stmt = $connector->prepare($query);
    $stmt->bind_param("i", $report_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $comments = [];
    while ($row = $result->fetch_assoc()) {
        $comments[] = $row;
    }

    echo json_encode(['success' => true, 'comments' => $comments]);
    $stmt->close();
    $connector->close();
}
