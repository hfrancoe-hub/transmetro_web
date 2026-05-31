<?php
require 'config.php';
$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $correo = trim($_POST['correo'] ?? '');
    $contrasena = $_POST['contrasena'] ?? '';
    $stmt = $pdo->prepare('SELECT u.*, r.nombre_rol FROM usuarios u INNER JOIN roles r ON u.id_rol = r.id_rol WHERE u.correo = ? AND u.estado = "Activo" LIMIT 1');
    $stmt->execute([$correo]);
    $usuario = $stmt->fetch();
    if ($usuario && password_verify($contrasena, $usuario['contrasena'])) {
        $_SESSION['usuario'] = $usuario['nombre'];
        $_SESSION['correo'] = $usuario['correo'];
        $_SESSION['rol'] = $usuario['nombre_rol'];
        header('Location: index.php');
        exit;
    } else {
        $error = 'Correo o contraseña incorrectos.';
    }
}
?>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><title>Login Transmetro</title><link rel="stylesheet" href="assets/style.css"></head>
<body class="login-body">
<div class="login-card">
  <img class="login-logo" src="assets/logo_transmetro.png" alt="Transmetro">
  <h1>Sistema de Transmetro</h1>
  <p>Iniciar sesión</p>
  <?php if ($error): ?><div class="alert error"><?= e($error) ?></div><?php endif; ?>
  <form method="POST">
    <label>Correo</label>
    <input type="email" name="correo" required placeholder="Ingrese su correo">
    <label>Contraseña</label>
    <input type="password" name="contrasena" required placeholder="Ingrese su contraseña">
    <button type="submit">Ingresar</button>
  </form>
</div>
</body></html>
