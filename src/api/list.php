<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

require_once __DIR__ . '/config.php';

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

    print_r($data);
} catch (PDOException $e) {
    send_json_response([
        'status' => 'error',
        'message' => 'Database query failed',
    ], 500);
}
?> 