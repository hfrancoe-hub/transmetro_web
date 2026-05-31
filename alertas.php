<?php
require 'config.php';
requiereModulo('alertas');

$mensaje = '';
$edit = null;
$rolActual = $_SESSION['rol'] ?? '';

// Permisos especiales del módulo Alertas:
// - Administrador: puede crear y editar.
// - Piloto: solo puede crear/ingresar alertas.
// - Jefe de monitoreo: solo puede editar/atender alertas existentes.
$puedeCrear = in_array($rolActual, ['Administrador', 'Piloto'], true);
$puedeEditar = in_array($rolActual, ['Administrador', 'Jefe de monitoreo'], true);

if (isset($_GET['editar'])) {
    if (!$puedeEditar) {
        header('Location: alertas.php?error=sin_permiso_editar');
        exit;
    }
    $stmt = $pdo->prepare('SELECT * FROM alertas WHERE id_alerta=?');
    $stmt->execute([(int)$_GET['editar']]);
    $edit = $stmt->fetch();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!empty($_POST['id_alerta'])) {
        if (!$puedeEditar) {
            header('Location: alertas.php?error=sin_permiso_editar');
            exit;
        }
        $stmt = $pdo->prepare('UPDATE alertas SET tipo_alerta=?, descripcion=?, prioridad=?, estado=?, id_estacion=?, id_bus=? WHERE id_alerta=?');
        $stmt->execute([
            $_POST['tipo_alerta'],
            $_POST['descripcion'],
            $_POST['prioridad'],
            $_POST['estado'],
            $_POST['id_estacion'] ?: null,
            $_POST['id_bus'] ?: null,
            $_POST['id_alerta']
        ]);
        header('Location: alertas.php?ok=actualizado');
        exit;
    } else {
        if (!$puedeCrear) {
            header('Location: alertas.php?error=sin_permiso_crear');
            exit;
        }
        $stmt = $pdo->prepare('INSERT INTO alertas(tipo_alerta, descripcion, prioridad, estado, id_estacion, id_bus) VALUES(?,?,?,?,?,?)');
        $stmt->execute([
            $_POST['tipo_alerta'],
            $_POST['descripcion'],
            $_POST['prioridad'],
            $_POST['estado'],
            $_POST['id_estacion'] ?: null,
            $_POST['id_bus'] ?: null
        ]);
        header('Location: alertas.php?ok=guardado');
        exit;
    }
}

if (isset($_GET['ok'])) {
    $mensaje = $_GET['ok'] === 'actualizado' ? 'Alerta actualizada correctamente.' : 'Alerta registrada correctamente.';
}
if (isset($_GET['error'])) {
    if ($_GET['error'] === 'sin_permiso_editar') {
        $mensaje = 'Tu rol no tiene permiso para editar alertas.';
    } elseif ($_GET['error'] === 'sin_permiso_crear') {
        $mensaje = 'Tu rol no tiene permiso para crear alertas.';
    }
}

require 'header.php';
$estaciones = $pdo->query('SELECT * FROM estaciones ORDER BY nombre_estacion')->fetchAll();
$buses = $pdo->query('SELECT * FROM buses ORDER BY placa')->fetchAll();
$rows = $pdo->query('SELECT a.*, e.nombre_estacion, b.placa FROM alertas a LEFT JOIN estaciones e ON a.id_estacion=e.id_estacion LEFT JOIN buses b ON a.id_bus=b.id_bus ORDER BY a.id_alerta DESC')->fetchAll();
?>
<h1>Alertas generadas</h1>
<p class="muted">Registro y seguimiento de alertas del sistema Transmetro.</p>

<?php if ($mensaje): ?>
  <div class="alert <?= isset($_GET['error']) ? 'error' : 'success' ?>"><?= e($mensaje) ?></div>
<?php endif; ?>

<?php if (($edit && $puedeEditar) || (!$edit && $puedeCrear)): ?>
<form method="POST" class="form-grid">
  <input type="hidden" name="id_alerta" value="<?= e($edit['id_alerta'] ?? '') ?>">
  <input name="tipo_alerta" placeholder="Tipo de alerta" value="<?= e($edit['tipo_alerta'] ?? '') ?>" required>
  <input name="descripcion" placeholder="Descripción" value="<?= e($edit['descripcion'] ?? '') ?>" required>
  <select name="prioridad">
    <?php foreach (['Baja','Media','Alta','Crítica'] as $op): ?>
      <option <?= ($edit['prioridad'] ?? '') == $op ? 'selected' : '' ?>><?= $op ?></option>
    <?php endforeach; ?>
  </select>
  <select name="estado">
    <?php foreach (['Activa','Atendida','Cerrada'] as $op): ?>
      <option <?= ($edit['estado'] ?? '') == $op ? 'selected' : '' ?>><?= $op ?></option>
    <?php endforeach; ?>
  </select>
  <select name="id_estacion">
    <option value="">Sin estación</option>
    <?php foreach ($estaciones as $x): ?>
      <option value="<?= e($x['id_estacion']) ?>" <?= ($edit['id_estacion'] ?? '') == $x['id_estacion'] ? 'selected' : '' ?>><?= e($x['nombre_estacion']) ?></option>
    <?php endforeach; ?>
  </select>
  <select name="id_bus">
    <option value="">Sin bus</option>
    <?php foreach ($buses as $x): ?>
      <option value="<?= e($x['id_bus']) ?>" <?= ($edit['id_bus'] ?? '') == $x['id_bus'] ? 'selected' : '' ?>><?= e($x['placa']) ?></option>
    <?php endforeach; ?>
  </select>
  <button><?= $edit ? 'Actualizar alerta' : 'Guardar alerta' ?></button>
  <?php if ($edit): ?><a class="btn secondary" href="alertas.php">Cancelar</a><?php endif; ?>
</form>
<?php endif; ?>

<?php if (puedeVerModulo('descargar')): ?>
  <a class="btn" href="descargar.php?tabla=alertas">Descargar CSV</a>
<?php endif; ?>

<table>
  <tr>
    <th>ID</th><th>Tipo</th><th>Descripción</th><th>Prioridad</th><th>Estado</th><th>Fecha</th><th>Estación</th><th>Bus</th><th>Acciones</th>
  </tr>
  <?php foreach ($rows as $r): ?>
    <tr>
      <td><?= e($r['id_alerta']) ?></td>
      <td><?= e($r['tipo_alerta']) ?></td>
      <td><?= e($r['descripcion']) ?></td>
      <td><?= e($r['prioridad']) ?></td>
      <td><?= e($r['estado']) ?></td>
      <td><?= e($r['fecha']) ?></td>
      <td><?= e($r['nombre_estacion']) ?></td>
      <td><?= e($r['placa']) ?></td>
      <td>
        <?php if ($puedeEditar): ?>
          <a class="btn small" href="alertas.php?editar=<?= e($r['id_alerta']) ?>">Editar</a>
        <?php else: ?>
          <span class="muted">Sin edición</span>
        <?php endif; ?>
      </td>
    </tr>
  <?php endforeach; ?>
</table>
<?php require 'footer.php'; ?>
