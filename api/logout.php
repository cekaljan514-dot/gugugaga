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

<!DOCTYPE html>
<html lang="cs">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Odhlášení - SILON</title>
    <link rel="stylesheet" href="auth.css">
</head>
<body>
    <div class="auth-header">
        <a class="auth-brand" href="https://silon.eu" target="_blank" rel="noopener noreferrer">SILON</a>
    </div>
    
    <div class="auth-container">
        <div class="success-panel">
            <h1 class="success-title">Byl jste úspěšně odhlášen</h1>
            <p class="success-text">Vaše relace byla bezpečně ukončena. Děkujeme, že jste používali SILON ORGANIGRAM.</p>
            <a href="http://localhost/gugugaga/api/login.php" class="btn-link">Přihlásit se znovu</a>
        </div>
    </div>
</body>
</html>