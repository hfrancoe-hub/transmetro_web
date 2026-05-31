<?php require 'config.php'; requiereModulo('parqueos');
$mensaje=''; $edit=null;
if (isset($_GET['eliminar'])) {
  $id=(int)$_GET['eliminar'];
  $asignados=$pdo->prepare('SELECT COUNT(*) FROM buses WHERE id_parqueo=?'); $asignados->execute([$id]);
  if ($asignados->fetchColumn() > 0) { $mensaje='No se puede eliminar este parqueo porque tiene buses asignados. Cambia primero el parqueo de esos buses.'; }
  else { $pdo->prepare('DELETE FROM parqueos WHERE id_parqueo=?')->execute([$id]); header('Location: parqueos.php?ok=eliminado'); exit; }
}
if (isset($_GET['editar'])) { $stmt=$pdo->prepare('SELECT * FROM parqueos WHERE id_parqueo=?'); $stmt->execute([(int)$_GET['editar']]); $edit=$stmt->fetch(); }
if ($_SERVER['REQUEST_METHOD']==='POST') {
  if (!empty($_POST['id_parqueo'])) {
    $stmt=$pdo->prepare('UPDATE parqueos SET nombre=?, ubicacion=?, capacidad=?, estado=? WHERE id_parqueo=?');
    $stmt->execute([$_POST['nombre'],$_POST['ubicacion'],$_POST['capacidad'],$_POST['estado'],$_POST['id_parqueo']]);
  } else {
    $stmt=$pdo->prepare('INSERT INTO parqueos(nombre, ubicacion, capacidad, estado) VALUES(?,?,?,?)');
    $stmt->execute([$_POST['nombre'],$_POST['ubicacion'],$_POST['capacidad'],$_POST['estado']]);
  }
  header('Location: parqueos.php?ok=guardado'); exit;
}
require 'header.php'; $rows=$pdo->query('SELECT * FROM parqueos ORDER BY id_parqueo DESC')->fetchAll(); ?>
<h1>Parqueos</h1><?php if($mensaje): ?><div class="alert error"><?=e($mensaje)?></div><?php endif; ?>
<form method="POST" class="form-grid"><input type="hidden" name="id_parqueo" value="<?=e($edit['id_parqueo'] ?? '')?>"><input name="nombre" placeholder="Nombre" value="<?=e($edit['nombre'] ?? '')?>" required><input name="ubicacion" placeholder="Ubicación" value="<?=e($edit['ubicacion'] ?? '')?>" required><input type="number" name="capacidad" placeholder="Capacidad" value="<?=e($edit['capacidad'] ?? '')?>" required><select name="estado"><?php foreach(['Disponible','Lleno','Mantenimiento'] as $op): ?><option <?=($edit['estado'] ?? '')==$op?'selected':''?>><?=$op?></option><?php endforeach; ?></select><button><?= $edit ? 'Actualizar parqueo' : 'Guardar parqueo' ?></button><?php if($edit): ?><a class="btn secondary" href="parqueos.php">Cancelar</a><?php endif; ?></form>
<a class="btn" href="descargar.php?tabla=parqueos">Descargar CSV</a><table><tr><th>ID</th><th>Nombre</th><th>Ubicación</th><th>Capacidad</th><th>Estado</th><th>Acciones</th></tr><?php foreach($rows as $r): ?><tr><td><?=e($r['id_parqueo'])?></td><td><?=e($r['nombre'])?></td><td><?=e($r['ubicacion'])?></td><td><?=e($r['capacidad'])?></td><td><?=e($r['estado'])?></td><td><a class="btn small" href="parqueos.php?editar=<?=e($r['id_parqueo'])?>">Editar</a> <a class="btn small danger" onclick="return confirm('¿Eliminar este parqueo?')" href="parqueos.php?eliminar=<?=e($r['id_parqueo'])?>">Eliminar</a></td></tr><?php endforeach; ?></table><?php require 'footer.php'; ?>
