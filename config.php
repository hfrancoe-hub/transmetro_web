<?php
$host = getenv('DB_HOST') ?: 'localhost';
$db   = getenv('DB_NAME') ?: 'transmetro_db';
$user = getenv('DB_USER') ?: 'root';
$pass = getenv('DB_PASS') ?: '';
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;port=3306;dbname=$db;charset=$charset";

$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false,
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (PDOException $e) {
    die('Error de conexión a la base de datos: ' . $e->getMessage());
}

session_start();

function verificarSesion() {
    if (!isset($_SESSION['usuario'])) {
        header('Location: login.php');
        exit;
    }
}

function tieneRol($roles) {
    verificarSesion();
    if (is_string($roles)) { 
        $roles = [$roles]; 
    }
    return in_array($_SESSION['rol'] ?? '', $roles, true);
}

function requiereRol($roles) {
    verificarSesion();
    if (!tieneRol($roles)) {
        http_response_code(403);
        die('<div style="font-family:Arial;padding:30px"><h2>Acceso denegado</h2><p>No tienes permisos para ingresar a esta sección.</p><a href="index.php">Volver al inicio</a></div>');
    }
}

function soloAdmin() {
    requiereRol('Administrador');
}

function puedeVerModulo($modulo) {
    $rol = $_SESSION['rol'] ?? '';
    $permisos = [
        'Administrador' => ['inicio','lineas','estaciones','buses','pilotos','parqueos','alertas','roles','usuarios','reportes','descargar'],
        'Operador' => ['inicio','lineas','estaciones','buses','pilotos','parqueos','reportes','descargar'],
        'Jefe de monitoreo' => ['inicio','alertas','reportes','descargar'],
        'Piloto' => ['inicio','alertas']
    ];
    return in_array($modulo, $permisos[$rol] ?? [], true);
}

function requiereModulo($modulo) {
    verificarSesion();
    if (!puedeVerModulo($modulo)) {
        http_response_code(403);
        die('<div style="font-family:Arial;padding:30px"><h2>Acceso denegado</h2><p>Tu rol no tiene acceso a este módulo.</p><a href="index.php">Volver al inicio</a></div>');
    }
}

function e($texto) {
    return htmlspecialchars((string)$texto, ENT_QUOTES, 'UTF-8');
}
?>