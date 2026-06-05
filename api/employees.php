<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

require_once __DIR__ . '/config.php';

function send_json_response(array $payload, int $statusCode = 200): void
{
    http_response_code($statusCode);
    echo json_encode($payload, JSON_UNESCAPED_UNICODE);
    exit;
}

try {
    $dsn = "mysql:host=$host;dbname=$dbname;charset=utf8mb4";
    $conn = new PDO($dsn, $user, $password, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
} catch (PDOException $e) {
    send_json_response([
        'status' => 'error',
        'message' => 'Database connection failed',
    ], 500);
}

try {
    $sql = 'SELECT * FROM employees';
    $statement = $conn->prepare($sql);
    $statement->execute();
    $data = $statement->fetchAll();

    if (empty($data)) {
        echo json_encode([]);
        exit;
    }

    $items = [];
    foreach ($data as $employee) {
        $employee['children'] = [];
        $items[$employee['id']] = $employee;
    }

    $tree = [];
    foreach ($items as $id => &$employee) {
        if ($employee['parent_id'] === null) {
            $tree[$id] = &$employee;
        } elseif (isset($items[$employee['parent_id']])) {
            $items[$employee['parent_id']]['children'][$id] = &$employee;
        }
    }

    echo json_encode($tree, JSON_UNESCAPED_UNICODE);
    exit;
} catch (PDOException $e) {
    send_json_response([
        'status' => 'error',
        'message' => 'Database query failed',
    ], 500);
}
?> 