<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE, PUT");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json");
include "../dbcon.php";

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    reactToReport();
}

function reactToReport() {
    global $connector;

    // Get JSON input
    $data = json_decode(file_get_contents("php://input"), true);
    
    // If JSON input fails, try form data
    if ($data === null) {
        $data = $_POST;
    }

    $report_id = $data['report_id'] ?? null;
    $professional_id = $data['professional_id'] ?? null;
    $reaction_type = $data['reaction_type'] ?? null;

    try {
        if (!$report_id || !$professional_id || !$reaction_type) {
            throw new Exception('Invalid input parameters');
        }

        // Check existing reaction
        $stmt = $connector->prepare("SELECT reaction_type FROM prof_reactions WHERE report_id = ? AND professional_id = ?");
        $stmt->bind_param("ii", $report_id, $professional_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $existing_reaction = $result->fetch_assoc();
        $stmt->close();

        if ($existing_reaction) {
            if ($reaction_type === "remove") {
                // Delete reaction
                $stmt = $connector->prepare("DELETE FROM prof_reactions WHERE report_id = ? AND professional_id = ?");
                $stmt->bind_param("ii", $report_id, $professional_id);
            } else {
                // Update reaction
                $stmt = $connector->prepare("UPDATE prof_reactions SET reaction_type = ?, created_at = NOW() WHERE report_id = ? AND professional_id = ?");
                $stmt->bind_param("sii", $reaction_type, $report_id, $professional_id);
            }
        } else {
            // Insert new reaction
            $stmt = $connector->prepare("INSERT INTO prof_reactions (report_id, professional_id, reaction_type, created_at) VALUES (?, ?, ?, NOW())");
            $stmt->bind_param("iis", $report_id, $professional_id, $reaction_type);
        }

        if (!$stmt->execute()) {
            throw new Exception('Database operation failed: ' . $stmt->error);
        }
        $stmt->close();

        echo json_encode([
            'success' => true,
            'message' => $existing_reaction ? ($reaction_type === "remove" ? 'Reaction removed' : 'Reaction updated') : 'Reaction added'
        ]);

    } catch (Exception $e) {
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'message' => $e->getMessage(),
            'error' => $connector->error
        ]);
    }
}
?>