<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");
include "../dbcon.php";

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

try {
    $data = json_decode(file_get_contents('php://input'), true) ?? $_POST;
    
    $required = ['report_id', 'people_id', 'reaction_type'];
    foreach ($required as $field) {
        if (!isset($data[$field])) {
            throw new Exception("Missing required field: $field");
        }
    }

    $report_id = (int)$data['report_id'];
    $people_id = (int)$data['people_id'];
    $reaction_type = $data['reaction_type'];

    // Check existing reaction
    $stmt = $connector->prepare("SELECT reaction_type FROM reactions WHERE report_id = ? AND people_id = ?");
    $stmt->bind_param("ii", $report_id, $people_id);
    $stmt->execute();
    $existing = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    if ($existing) {
        if ($reaction_type === "remove") {
            $stmt = $connector->prepare("DELETE FROM reactions WHERE report_id = ? AND people_id = ?");
            $stmt->bind_param("ii", $report_id, $people_id);
        } else {
            $stmt = $connector->prepare("UPDATE reactions SET reaction_type = ?, created_at = NOW() WHERE report_id = ? AND people_id = ?");
            $stmt->bind_param("sii", $reaction_type, $report_id, $people_id);
        }
    } else {
        $stmt = $connector->prepare("INSERT INTO reactions (report_id, people_id, reaction_type, created_at) VALUES (?, ?, ?, NOW())");
        $stmt->bind_param("iis", $report_id, $people_id, $reaction_type);
    }

    if (!$stmt->execute()) {
        throw new Exception("Database error: " . $stmt->error);
    }
    $stmt->close();

    echo json_encode(['success' => true]);
    exit();

} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage(),
        'error' => $connector->error ?? null
    ]);
    exit();
}