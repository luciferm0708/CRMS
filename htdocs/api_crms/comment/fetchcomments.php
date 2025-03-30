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
        SELECT comments.comment_text, people.username, comments.created_at
        FROM comments
        JOIN people ON comments.people_id = people.id
        WHERE comments.report_id = ?
        ORDER BY comments.created_at DESC
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
