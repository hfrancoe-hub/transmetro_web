<?php require 'config.php'; requiereModulo('reportes'); require 'header.php'; ?>
<h1>Descargar registros</h1>
<p>Descarga los registros permitidos para tu rol en formato CSV para abrirlos en Excel.</p>
<div class="cards reportes">
  <?php if ($_SESSION['rol'] === 'Administrador' || $_SESSION['rol'] === 'Operador'): ?>
  <a class="card link" href="descargar.php?tabla=lineas"><h2>Líneas</h2><p>Descargar registros</p></a>
  <a class="card link" href="descargar.php?tabla=estaciones"><h2>Estaciones</h2><p>Descargar registros</p></a>
  <a class="card link" href="descargar.php?tabla=buses"><h2>Buses</h2><p>Descargar registros</p></a>
  <a class="card link" href="descargar.php?tabla=pilotos"><h2>Pilotos</h2><p>Descargar registros</p></a>
  <a class="card link" href="descargar.php?tabla=parqueos"><h2>Parqueos</h2><p>Descargar registros</p></a>
  <?php endif; ?>
  <?php if ($_SESSION['rol'] === 'Administrador' || $_SESSION['rol'] === 'Jefe de monitoreo'): ?>
  <a class="card link" href="descargar.php?tabla=alertas"><h2>Alertas generadas</h2><p>Descargar registros</p></a>
  <?php endif; ?>
</div>
<?php require 'footer.php'; ?>
