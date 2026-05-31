<?php require 'config.php'; requiereModulo('lineas');
$mensaje=''; $edit=null; $seleccionadas=[];
if (isset($_GET['eliminar'])) {
  $id=(int)$_GET['eliminar'];
  try {
    $pdo->prepare('UPDATE buses SET id_linea=NULL WHERE id_linea=?')->execute([$id]);
    $pdo->prepare('DELETE FROM lineas WHERE id_linea=?')->execute([$id]);
    header('Location: lineas.php?ok=eliminado'); exit;
  } catch (PDOException $e) { $mensaje='No se pudo eliminar la línea.'; }
}
if (isset($_GET['editar'])) {
  $stmt=$pdo->prepare('SELECT * FROM lineas WHERE id_linea=?'); $stmt->execute([(int)$_GET['editar']]); $edit=$stmt->fetch();
  $stmt=$pdo->prepare('SELECT id_estacion FROM lineas_estaciones WHERE id_linea=?'); $stmt->execute([(int)$_GET['editar']]);
  $seleccionadas=array_map('intval', array_column($stmt->fetchAll(), 'id_estacion'));
}
if ($_SERVER['REQUEST_METHOD']==='POST') {
  $estaciones = $_POST['estaciones'] ?? [];
  if (!empty($_POST['id_linea'])) {
    $id=(int)$_POST['id_linea'];
    $stmt=$pdo->prepare('UPDATE lineas SET nombre_linea=?, ruta=?, descripcion=? WHERE id_linea=?');
    $stmt->execute([$_POST['nombre_linea'],$_POST['ruta'],$_POST['descripcion'],$id]);
    $pdo->prepare('DELETE FROM lineas_estaciones WHERE id_linea=?')->execute([$id]);
  } else {
    $stmt=$pdo->prepare('INSERT INTO lineas(nombre_linea, ruta, descripcion) VALUES(?,?,?)');
    $stmt->execute([$_POST['nombre_linea'],$_POST['ruta'],$_POST['descripcion']]);
    $id=(int)$pdo->lastInsertId();
  }
  $orden=1;
  $ins=$pdo->prepare('INSERT INTO lineas_estaciones(id_linea,id_estacion,orden) VALUES(?,?,?)');
  foreach($estaciones as $idEst){ $ins->execute([$id,(int)$idEst,$orden++]); }
  header('Location: lineas.php?ok=guardado'); exit;
}
require 'header.php';
$estaciones=$pdo->query('SELECT * FROM estaciones ORDER BY nombre_estacion')->fetchAll();
$rows=$pdo->query('SELECT l.*, COUNT(le.id_estacion) total_estaciones FROM lineas l LEFT JOIN lineas_estaciones le ON l.id_linea=le.id_linea GROUP BY l.id_linea ORDER BY l.id_linea')->fetchAll();
?>
<h1>Líneas y estaciones asignadas</h1>
<?php if($mensaje): ?><div class="alert error"><?=e($mensaje)?></div><?php endif; ?>
<form method="POST" class="form-grid wide-form">
<input type="hidden" name="id_linea" value="<?=e($edit['id_linea'] ?? '')?>">
<input name="nombre_linea" placeholder="Nombre de línea" value="<?=e($edit['nombre_linea'] ?? '')?>" required>
<input name="ruta" placeholder="Ruta / origen y destino" value="<?=e($edit['ruta'] ?? '')?>" required>
<input name="descripcion" placeholder="Descripción" value="<?=e($edit['descripcion'] ?? '')?>">
<div class="multi-box"><strong>Asignar estaciones a esta línea</strong><small>Mantén Ctrl para seleccionar varias.</small><select name="estaciones[]" multiple size="12"><?php foreach($estaciones as $x): ?><option value="<?=e($x['id_estacion'])?>" <?=in_array((int)$x['id_estacion'],$seleccionadas)?'selected':''?>><?=e($x['nombre_estacion'].' - '.$x['ubicacion'])?></option><?php endforeach; ?></select></div>
<button><?= $edit ? 'Actualizar línea' : 'Guardar línea' ?></button><?php if($edit): ?><a class="btn secondary" href="lineas.php">Cancelar</a><?php endif; ?>
</form>
<a class="btn" href="descargar.php?tabla=lineas">Descargar líneas CSV</a>
<table><tr><th>ID</th><th>Línea</th><th>Ruta</th><th>Descripción</th><th>Estaciones</th><th>Acciones</th></tr><?php foreach($rows as $r): ?><tr><td><?=e($r['id_linea'])?></td><td><?=e($r['nombre_linea'])?></td><td><?=e($r['ruta'])?></td><td><?=e($r['descripcion'])?></td><td><?=e($r['total_estaciones'])?></td><td><a class="btn small" href="lineas.php?editar=<?=e($r['id_linea'])?>">Editar</a> <a class="btn small danger" onclick="return confirm('¿Eliminar esta línea?')" href="lineas.php?eliminar=<?=e($r['id_linea'])?>">Eliminar</a></td></tr><?php endforeach; ?></table>
<?php require 'footer.php'; ?>
