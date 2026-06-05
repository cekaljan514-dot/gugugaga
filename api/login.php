<?php
session_start();

require_once __DIR__ . '/config.php';

$dsn = "mysql:host=$host;dbname=$dbname;charset=utf8mb4";
$conn = new PDO($dsn, $user, $password, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
]);

// Pokud byl odeslán formulář
if (isset($_POST['login'])) {

    $username = $_POST['username'];
    $ip = $_SERVER['REMOTE_ADDR'];

    // LDAP nastavení
    $ldap_server = "ldap://DC01.praxxe2.loc";
    $ldap_domain = "praxe2.loc";
    $ldap_dn = "CN=$username,OU=Users,OU=MyCompany,DC=praxe2,DC=loc";

    // Připojení k LDAP
    $ldap = ldap_connect($ldap_server);
    ldap_set_option($ldap, LDAP_OPT_PROTOCOL_VERSION, 3);
    ldap_set_option($ldap, LDAP_OPT_REFERRALS, 0);

    // Ověření uživatele (bez hesla)
    $bind = @ldap_bind($ldap, $ldap_dn);

    if ($bind) {
        echo "LDAP OK<br>";

        // Zkontrolujeme, zda je v MySQL
        $stmt = $conn->prepare("SELECT * FROM users WHERE username = ?");
        $stmt->execute([$username]);
        $user = $stmt->fetch();

        if ($user) {
            // Uživatel existuje → log + redirect
            $stmt = $conn->prepare("INSERT INTO logs (username, event, ip, created_at) 
                                    VALUES (?, 'login_success', ?, NOW())");
            $stmt->execute([$username, $ip]);

            $_SESSION['user'] = $username;

            header("Location: http://192.168.92.200/nova%20slozka");
            exit;
        } else {
            // Uživatel neexistuje → vytvořit, ale NEREDIRECTOVAT
            $stmt = $conn->prepare("INSERT INTO users (username, created_at) VALUES (?, NOW())");
            $stmt->execute([$username]);

            $stmt = $conn->prepare("INSERT INTO logs (username, event, ip, created_at) 
                                    VALUES (?, 'user_created', ?, NOW())");
            $stmt->execute([$username, $ip]);

            echo "<p style='color:green'>Uživatel $username byl vytvořen v MySQL.</p>";
        }

    } else {
        echo "Chyba LDAP: " . ldap_error($ldap);

        // Log chyby
        $stmt = $conn->prepare("INSERT INTO logs (username, event, ip, created_at) 
                                VALUES (?, 'login_failed', ?, NOW())");
        $stmt->execute([$username, $ip]);
    }
}
?>

<html>
<body>
<form method="post">
    Username: <input type="text" name="username" required><br>
    <button type="submit" name="login">Přihlásit</button>
</form>
</body>
</html>