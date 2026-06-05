<?php
session_start();

require_once __DIR__ . '/config.php';

$dsn = "mysql:host=$host;dbname=$dbname;charset=utf8mb4";
$conn = new PDO($dsn, $user, $password, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
]);

$message = '';
$messageClass = '';

if (isset($_POST['login'])) {

    $username = $_POST['username'];
    $password = $_POST['password'];
    $ip = $_SERVER['REMOTE_ADDR'];

    /* // LDAP nastavení
    $ldap_server = "ldap://DC01.praxe2.loc";
    $ldap_domain = "praxe2.loc";
    $ldap_dn = "DC=praxe2,DC=loc";

    // Připojení k LDAP
    $ldap = ldap_connect($ldap_server);
    ldap_set_option($ldap, LDAP_OPT_PROTOCOL_VERSION, 3);
    ldap_set_option($ldap, LDAP_OPT_REFERRALS, 0);

    //Pokud není v username @, přidáme doménu
    if (strpos($username, '@') === false) {
        $username .= '@' . $ldap_domain;
    }
    
    // Ověření uživatele
    $bind = @ldap_bind($ldap, $username, $password); */
    $bind = true;


    if ($bind) {
        $stmt = $conn->prepare("SELECT * FROM users WHERE username = ?");
        $stmt->execute([$username]);
        $user = $stmt->fetch();

        if ($user) {
            $stmt = $conn->prepare("INSERT INTO logs (username, event, ip, created_at) 
                                    VALUES (?, 'login_success', ?, NOW())");
            $stmt->execute([$username, $ip]);

            $_SESSION['user'] = $username;
            header("Location: http://localhost:8080/nova%20slozka/index.html");
            exit;
        } else {
            $stmt = $conn->prepare("INSERT INTO users (username, created_at) VALUES (?, NOW())");
            $stmt->execute([$username]);

            $stmt = $conn->prepare("INSERT INTO logs (username, event, ip, created_at) 
                                    VALUES (?, 'user_created', ?, NOW())");
            $stmt->execute([$username, $ip]);

            $message = "Uživatel <strong>$username</strong> byl vytvořen v MySQL.";
            $messageClass = 'success-message';
        }
    } else {
        $message = 'Chyba LDAP: ' . ldap_error($ldap);
        $messageClass = 'error-message';

        $stmt = $conn->prepare("INSERT INTO logs (username, event, ip, created_at) 
                                VALUES (?, 'login_failed', ?, NOW())");
        $stmt->execute([$username, $ip]);
    }
}
?>

<!DOCTYPE html>
<html lang="cs">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Přihlášení - SILON</title>
    <link rel="stylesheet" href="login.css">
</head>
<body>
    <div class="auth-header">
        <a class="auth-brand" href="https://silon.eu" target="_blank" rel="noopener noreferrer">SILON</a>
    </div>

    <div class="auth-container">
        <div class="auth-panel">
            <h1 class="auth-title">Přihlášení do SILON</h1>
            <p class="auth-subtitle">Zadejte své LDAP přihlašovací údaje pro pokračování.</p>

            <?php if ($message): ?>
                <div class="<?= $messageClass ?>"><?= $message ?></div>
            <?php endif; ?>

            <form method="post">
                <div class="form-group">
                    <label for="username">Uživatelské jméno</label>
                    <input type="text" id="username" name="username" required placeholder="Zadejte uživatele">
                </div>
                <div class="form-group">
                    <label for="password">Heslo</label>
                    <input type="password" id="password" name="password" required placeholder="Zadejte heslo">
                </div>
                <button type="submit" name="login" class="btn-submit">Přihlásit</button>
            </form>
        </div>
    </div>
</body>
</html>
