<?php
// upload.php
header('Content-Type: application/json');

// Simple CORS — sesuaikan domain production
header("Access-Control-Allow-Origin: *");
header('Access-Control-Allow-Methods: POST, OPTIONS');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;

$uploadDir = __DIR__ . '/uploads/';
if (!is_dir($uploadDir)) @mkdir($uploadDir, 0755, true);

if (!isset($_FILES['file'])) {
    echo json_encode(['success' => false, 'message' => 'No file uploaded']);
    exit;
}

$f = $_FILES['file'];
if ($f['error'] !== UPLOAD_ERR_OK) {
    echo json_encode(['success' => false, 'message' => 'Upload error: ' . $f['error']]);
    exit;
}

// sanitize filename
$ext = pathinfo($f['name'], PATHINFO_EXTENSION);
$base = bin2hex(random_bytes(8));
$fname = $base . ($ext ? "." . $ext : "");
$dest = $uploadDir . $fname;

if (!move_uploaded_file($f['tmp_name'], $dest)) {
    echo json_encode(['success' => false, 'message' => 'Move failed']);
    exit;
}

// return relative path for frontend use
echo json_encode(['success' => true, 'filename' => $fname]);
