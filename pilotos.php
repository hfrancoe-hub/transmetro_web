<?php require 'config.php'; requiereModulo('pilotos');
$mensaje=''; $edit=null;
if (isset($_GET['eliminar'])) {
  $id=(int)$_GET['eliminar'];
  try {
    $pdo->prepare('UPDATE buses SET id_piloto=NULL WHERE id_piloto=?')->execute([$id]);
    $pdo->prepare('DELETE FROM pilotos WHERE id_piloto=?')->execute([$id]);
    header('Location: pilotos.php?ok=eliminado'); exit;
  } catch (PDOException $e) { $mensaje='No se pudo eliminar el piloto.'; }
}
if (isset($_GET['editar'])) { $stmt=$pdo->prepare('SELECT * FROM pilotos WHERE id_piloto=?'); $stmt->execute([(int)$_GET['editar']]); $edit=$stmt->fetch(); }
if ($_SERVER['REQUEST_METHOD']==='POST') {
  $idPiloto = !empty($_POST['id_piloto']) ? (int)$_POST['id_piloto'] : 0;
  $idLinea = $_POST['id_linea'] ?: null;

  // Regla: un piloto solo puede pertenecer a una línea a la vez.
  // Si ya tiene una línea asignada, no se permite cambiar directamente a otra.
  if ($idPiloto && $idLinea) {
    $stmt=$pdo->prepare('SELECT id_linea FROM pilotos WHERE id_piloto=?');
    $stmt->execute([$idPiloto]);
    $actual=$stmt->fetchColumn();
    if ($actual && (int)$actual !== (int)$idLinea) {
      $mensaje='No se puede asignar otra línea: este piloto ya tiene una línea asignada. Primero deja la línea en blanco y guarda, luego asigna la nueva.';
    }
  }

  if (!$mensaje) {
    if ($idPiloto) {
      $stmt=$pdo->prepare('UPDATE pilotos SET nombre=?, licencia=?, telefono=?, direccion=?, estado=?, id_linea=? WHERE id_piloto=?');
      $stmt->execute([$_POST['nombre'],$_POST['licencia'],$_POST['telefono'],$_POST['direccion'],$_POST['estado'],$idLinea,$idPiloto]);
    } else {
      $stmt=$pdo->prepare('INSERT INTO pilotos(nombre, licencia, telefono, direccion, estado, id_linea) VALUES(?,?,?,?,?,?)');
      $stmt->execute([$_POST['nombre'],$_POST['licencia'],$_POST['telefono'],$_POST['direccion'],$_POST['estado'],$idLinea]);
    }
    header('Location: pilotos.php?ok=guardado'); exit;
  }
}
require 'header.php';
$lineas=$pdo->query('SELECT * FROM lineas ORDER BY nombre_linea')->fetchAll();
$rows=$pdo->query('SELECT p.*, l.nombre_linea FROM pilotos p LEFT JOIN lineas l ON p.id_linea=l.id_linea ORDER BY p.id_piloto DESC')->fetchAll(); ?>
<h1>Pilotos</h1><?php if($mensaje): ?><div class="alert error"><?=e($mensaje)?></div><?php endif; ?>
<form method="POST" class="form-grid">
<input type="hidden" name="id_piloto" value="<?=e($edit['id_piloto'] ?? '')?>">
<input name="nombre" placeholder="Nombre" value="<?=e($edit['nombre'] ?? '')?>" required>
<input name="licencia" placeholder="Licencia" value="<?=e($edit['licencia'] ?? '')?>" required>
<input name="telefono" placeholder="Teléfono" value="<?=e($edit['telefono'] ?? '')?>">
<input name="direccion" placeholder="Dirección" value="<?=e($edit['direccion'] ?? '')?>">
<select name="estado"><?php foreach(['Activo','Inactivo','Suspendido'] as $op): ?><option <?=($edit['estado'] ?? '')==$op?'selected':''?>><?=$op?></option><?php endforeach; ?></select>
<select name="id_linea"><option value="">Sin línea asignada</option><?php foreach($lineas as $x): ?><option value="<?=e($x['id_linea'])?>" <?=($edit['id_linea'] ?? '')==$x['id_linea']?'selected':''?>><?=e($x['nombre_linea'])?></option><?php endforeach; ?></select>
<button><?= $edit ? 'Actualizar piloto' : 'Guardar piloto' ?></button><?php if($edit): ?><a class="btn secondary" href="pilotos.php">Cancelar</a><?php endif; ?></form>
<a class="btn" href="descargar.php?tabla=pilotos">Descargar CSV</a>
<table><tr><th>ID</th><th>Nombre</th><th>Licencia</th><th>Teléfono</th><th>Línea asignada</th><th>Estado</th><th>Acciones</th></tr><?php foreach($rows as $r): ?><tr><td><?=e($r['id_piloto'])?></td><td><?=e($r['nombre'])?></td><td><?=e($r['licencia'])?></td><td><?=e($r['telefono'])?></td><td><?=e($r['nombre_linea'] ?: 'Sin línea')?></td><td><?=e($r['estado'])?></td><td><a class="btn small" href="pilotos.php?editar=<?=e($r['id_piloto'])?>">Editar</a> <a class="btn small danger" onclick="return confirm('¿Eliminar este piloto?')" href="pilotos.php?eliminar=<?=e($r['id_piloto'])?>">Eliminar</a></td></tr><?php endforeach; ?></table><?php require 'footer.php'; ?>
