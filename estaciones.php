<?php require 'config.php'; requiereModulo('estaciones');
$mensaje=''; $edit=null;
if (isset($_GET['eliminar'])) {
  $id=(int)$_GET['eliminar'];
  try {
    $pdo->prepare('DELETE FROM estaciones WHERE id_estacion=?')->execute([$id]);
    header('Location: estaciones.php?ok=eliminado'); exit;
  } catch(PDOException $e){ $mensaje='No se pudo eliminar la estación.'; }
}
if (isset($_GET['editar'])) { $stmt=$pdo->prepare('SELECT * FROM estaciones WHERE id_estacion=?'); $stmt->execute([(int)$_GET['editar']]); $edit=$stmt->fetch(); }
if ($_SERVER['REQUEST_METHOD']==='POST') {
  if (!empty($_POST['id_estacion'])) {
    $stmt=$pdo->prepare('UPDATE estaciones SET nombre_estacion=?, ubicacion=?, capacidad_esperada=?, usuarios_actuales=?, estado=? WHERE id_estacion=?');
    $stmt->execute([$_POST['nombre_estacion'],$_POST['ubicacion'],$_POST['capacidad_esperada'],$_POST['usuarios_actuales'],$_POST['estado'],$_POST['id_estacion']]);
    $idEst=(int)$_POST['id_estacion'];
  } else {
    $stmt=$pdo->prepare('INSERT INTO estaciones(nombre_estacion, ubicacion, capacidad_esperada, usuarios_actuales, estado) VALUES(?,?,?,?,?)');
    $stmt->execute([$_POST['nombre_estacion'],$_POST['ubicacion'],$_POST['capacidad_esperada'],$_POST['usuarios_actuales'],$_POST['estado']]);
    $idEst=$pdo->lastInsertId();
  }
  if ((int)$_POST['usuarios_actuales'] >= ((int)$_POST['capacidad_esperada'] * 1.5)) {
    $desc='La estación '.$_POST['nombre_estacion'].' superó el 150% de su capacidad esperada.';
    $pdo->prepare('INSERT INTO alertas(tipo_alerta, descripcion, prioridad, id_estacion) VALUES(?,?,?,?)')->execute(['Sobrecupo de estación',$desc,'Alta',$idEst]);
  }
  header('Location: estaciones.php?ok=guardado'); exit;
}
require 'header.php'; $rows=$pdo->query('SELECT e.*, GROUP_CONCAT(l.nombre_linea ORDER BY le.orden SEPARATOR ", ") lineas FROM estaciones e LEFT JOIN lineas_estaciones le ON e.id_estacion=le.id_estacion LEFT JOIN lineas l ON le.id_linea=l.id_linea GROUP BY e.id_estacion ORDER BY e.id_estacion DESC')->fetchAll(); ?>
<h1>Estaciones</h1><?php if($mensaje): ?><div class="alert error"><?=e($mensaje)?></div><?php endif; ?>
<form method="POST" class="form-grid"><input type="hidden" name="id_estacion" value="<?=e($edit['id_estacion'] ?? '')?>"><input name="nombre_estacion" placeholder="Nombre" value="<?=e($edit['nombre_estacion'] ?? '')?>" required><input name="ubicacion" placeholder="Ubicación" value="<?=e($edit['ubicacion'] ?? '')?>" required><input type="number" name="capacidad_esperada" placeholder="Capacidad esperada" value="<?=e($edit['capacidad_esperada'] ?? '')?>" required><input type="number" name="usuarios_actuales" placeholder="Usuarios actuales" value="<?=e($edit['usuarios_actuales'] ?? '')?>" required><select name="estado"><?php foreach(['Activa','Inactiva'] as $op): ?><option <?=($edit['estado'] ?? '')==$op?'selected':''?>><?=$op?></option><?php endforeach; ?></select><button><?= $edit ? 'Actualizar estación' : 'Guardar estación' ?></button><?php if($edit): ?><a class="btn secondary" href="estaciones.php">Cancelar</a><?php endif; ?></form>
<a class="btn" href="descargar.php?tabla=estaciones">Descargar CSV</a><table><tr><th>ID</th><th>Estación</th><th>Ubicación</th><th>Líneas</th><th>Capacidad esperada</th><th>Usuarios actuales</th><th>Estado</th><th>Acciones</th></tr><?php foreach($rows as $r): ?><tr><td><?=e($r['id_estacion'])?></td><td><?=e($r['nombre_estacion'])?></td><td><?=e($r['ubicacion'])?></td><td><?=e($r['lineas'])?></td><td><?=e($r['capacidad_esperada'])?></td><td><?=e($r['usuarios_actuales'])?></td><td><?=e($r['estado'])?></td><td><a class="btn small" href="estaciones.php?editar=<?=e($r['id_estacion'])?>">Editar</a> <a class="btn small danger" onclick="return confirm('¿Eliminar esta estación?')" href="estaciones.php?eliminar=<?=e($r['id_estacion'])?>">Eliminar</a></td></tr><?php endforeach; ?></table><?php require 'footer.php'; ?>
