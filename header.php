<?php verificarSesion(); ?>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><title>Sistema Transmetro</title><link rel="stylesheet" href="assets/style.css"></head><body>
<nav class="topbar">
  <div class="brand"><img src="assets/logo_transmetro.png" alt="Transmetro"><span>Sistema de control</span></div>
  <div><?= e($_SESSION['usuario']) ?> | <a href="logout.php">Salir</a></div>
</nav>
<aside class="sidebar">
  <a href="index.php">Inicio</a>
  <?php if (puedeVerModulo('lineas')): ?><a href="lineas.php">Líneas</a><?php endif; ?>
  <?php if (puedeVerModulo('estaciones')): ?><a href="estaciones.php">Estaciones</a><?php endif; ?>
  <?php if (puedeVerModulo('buses')): ?><a href="buses.php">Buses</a><?php endif; ?>
  <?php if (puedeVerModulo('pilotos')): ?><a href="pilotos.php">Pilotos</a><?php endif; ?>
  <?php if (puedeVerModulo('parqueos')): ?><a href="parqueos.php">Parqueos</a><?php endif; ?>
  <?php if (puedeVerModulo('alertas')): ?><a href="alertas.php">Alertas</a><?php endif; ?>
  <?php if (puedeVerModulo('roles')): ?><a href="roles.php">Roles</a><?php endif; ?>
  <?php if (puedeVerModulo('usuarios')): ?><a href="usuarios.php">Usuarios</a><?php endif; ?>
  <?php if (puedeVerModulo('reportes')): ?><a href="reportes.php">Descargar registros</a><?php endif; ?>
</aside>
<main class="content">
