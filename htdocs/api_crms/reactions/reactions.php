<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
include "../dbcon.php"; 

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    reactToReport();
}

function reactToReport() {
    global $connector;

    $report_id = $_POST['report_id'] ?? null;
    $people_id = $_POST['people_id'] ?? null;
    $reaction_type = $_POST['reaction_type'] ?? null;

    if (!$report_id || !$people_id || !$reaction_type) {
        echo json_encode(['success' => false, 'message' => 'Invalid input']);
        return;
    }

    // Check if the user has already reacted
    $query = "SELECT reaction_type FROM reactions WHERE report_id = ? AND people_id = ?";
    $stmt = $connector->prepare($query);
    $stmt->bind_param("ii", $report_id, $people_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $existing_reaction = $result->fetch_assoc();
    $stmt->close();

    if ($existing_reaction) {
        if ($reaction_type === "remove") {
            // Remove reaction
            $query = "DELETE FROM reactions WHERE report_id = ? AND people_id = ?";
            $stmt = $connector->prepare($query);
            $stmt->bind_param("ii", $report_id, $people_id);
            $stmt->execute();
            $stmt->close();

            echo json_encode(['success' => true, 'message' => 'Reaction removed']);
            return;
        } else {
            // Switch reaction
            if ($existing_reaction['reaction_type'] !== $reaction_type) {
                $query = "UPDATE reactions SET reaction_type = ?, created_at = NOW() WHERE report_id = ? AND people_id = ?";
                $stmt = $connector->prepare($query);
                $stmt->bind_param("sii", $reaction_type, $report_id, $people_id);
                $stmt->execute();
                $stmt->close();

                echo json_encode(['success' => true, 'message' => 'Reaction switched']);
                return;
            }
        }
    } else {
        // Insert new reaction
        $query = "INSERT INTO reactions (report_id, people_id, reaction_type, created_at) VALUES (?, ?, ?, NOW())";
        $stmt = $connector->prepare($query);
        $stmt->bind_param("iis", $report_id, $people_id, $reaction_type);
        $stmt->execute();
        $stmt->close();

        echo json_encode(['success' => true, 'message' => 'Reaction added']);
        return;
    }

    echo json_encode(['success' => false, 'message' => 'Unknown error']);
}
?>
