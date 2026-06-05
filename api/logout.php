<?php
session_start();

require_once __DIR__ . '/config.php';

$dsn = "mysql:host=$host;dbname=$dbname;charset=utf8mb4";
$conn = new PDO($dsn, $user, $password, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
]);

// Pokud je uživatel přihlášen, zalogujeme odhlášení
if (isset($_SESSION['user'])) {
    $username = $_SESSION['user'];
    $ip = $_SERVER['REMOTE_ADDR'];

    $stmt = $conn->prepare("INSERT INTO logs (username, event, ip, created_at) 
                            VALUES (?, 'logout', ?, NOW())");
    $stmt->execute([$username, $ip]);
}

// Zrušení session
session_unset();
session_destroy();
?>

<html>
<body>
    <h2>Byl jste úspěšně odhlášen.</h2>
    <a href="http://192.168.92.200/api/login.php">Přihlásit se znovu</a>
</body>
</html>