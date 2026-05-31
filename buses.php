<?php require 'config.php'; requiereModulo('buses');
$mensaje='';
$edit = null;

if (isset($_GET['eliminar'])) {
  $id=(int)$_GET['eliminar'];
  try {
    $pdo->prepare('UPDATE alertas SET id_bus=NULL WHERE id_bus=?')->execute([$id]);
    $pdo->prepare('DELETE FROM buses WHERE id_bus=?')->execute([$id]);
    header('Location: buses.php?ok=eliminado'); exit;
  } catch (PDOException $e) { $mensaje='No se pudo eliminar el bus porque tiene datos relacionados.'; }
}

if (isset($_GET['editar'])) {
  $stmt=$pdo->prepare('SELECT * FROM buses WHERE id_bus=?');
  $stmt->execute([(int)$_GET['editar']]);
  $edit=$stmt->fetch();
}

if ($_SERVER['REQUEST_METHOD']==='POST') {
  $idBus = !empty($_POST['id_bus']) ? (int)$_POST['id_bus'] : 0;
  $idLinea = $_POST['id_linea'] ?: null;
  $idPiloto = $_POST['id_piloto'] ?: null;
  $idParqueo = $_POST['id_parqueo'] ?: null;

  // Regla 1: si se asigna piloto y línea al bus, el piloto debe pertenecer a esa misma línea.
  if ($idLinea && $idPiloto) {
    $stmt=$pdo->prepare('SELECT id_linea FROM pilotos WHERE id_piloto=?');
    $stmt->execute([$idPiloto]);
    $lineaPiloto=$stmt->fetchColumn();
    if (!$lineaPiloto) {
      $mensaje='El piloto seleccionado no tiene línea asignada. Primero asigna una línea al piloto en el módulo Pilotos.';
    } elseif ((int)$lineaPiloto !== (int)$idLinea) {
      $mensaje='No se puede asignar este piloto porque ya pertenece a otra línea.';
    }
  }

  // Regla 2: un piloto no puede quedar asignado a dos buses al mismo tiempo.
  if (!$mensaje && $idPiloto) {
    $stmt=$pdo->prepare('SELECT COUNT(*) FROM buses WHERE id_piloto=? AND id_bus<>?');
    $stmt->execute([$idPiloto, $idBus]);
    if ($stmt->fetchColumn() > 0) {
      $mensaje='No se puede asignar este piloto porque ya está asignado a otro bus.';
    }
  }

  if (!$mensaje) {
    if ($idBus) {
      $stmt=$pdo->prepare('UPDATE buses SET placa=?, modelo=?, tipo_bus=?, capacidad_maxima=?, estado=?, id_linea=?, id_parqueo=?, id_piloto=? WHERE id_bus=?');
      $stmt->execute([$_POST['placa'],$_POST['modelo'],$_POST['tipo_bus'],$_POST['capacidad_maxima'],$_POST['estado'],$idLinea,$idParqueo,$idPiloto,$idBus]);
    } else {
      $stmt=$pdo->prepare('INSERT INTO buses(placa, modelo, tipo_bus, capacidad_maxima, estado, id_linea, id_parqueo, id_piloto) VALUES(?,?,?,?,?,?,?,?)');
      $stmt->execute([$_POST['placa'],$_POST['modelo'],$_POST['tipo_bus'],$_POST['capacidad_maxima'],$_POST['estado'],$idLinea,$idParqueo,$idPiloto]);
    }
    header('Location: buses.php?ok=guardado'); exit;
  }
}

require 'header.php';
$lineas=$pdo->query('SELECT * FROM lineas ORDER BY nombre_linea')->fetchAll();
$parqueos=$pdo->query('SELECT * FROM parqueos ORDER BY nombre')->fetchAll();
$pilotos=$pdo->query("SELECT p.*, l.nombre_linea, b.id_bus AS bus_asignado, b.placa AS placa_asignada
  FROM pilotos p
  LEFT JOIN lineas l ON p.id_linea=l.id_linea
  LEFT JOIN buses b ON b.id_piloto=p.id_piloto
  ORDER BY p.nombre")->fetchAll();
$rows=$pdo->query('SELECT b.*, l.nombre_linea, p.nombre parqueo, pi.nombre piloto FROM buses b LEFT JOIN lineas l ON b.id_linea=l.id_linea JOIN parqueos p ON b.id_parqueo=p.id_parqueo LEFT JOIN pilotos pi ON b.id_piloto=pi.id_piloto ORDER BY b.id_bus DESC')->fetchAll();
?>
<h1>Buses</h1>
<?php if($mensaje): ?><div class="alert error"><?=e($mensaje)?></div><?php endif; ?>
<?php if(isset($_GET['ok'])): ?><div class="alert success">Registro guardado correctamente.</div><?php endif; ?>
<form method="POST" class="form-grid">
<input type="hidden" name="id_bus" value="<?=e($edit['id_bus'] ?? '')?>">
<input name="placa" placeholder="Placa" value="<?=e($edit['placa'] ?? '')?>" required>
<input name="modelo" placeholder="Modelo del bus" value="<?=e($edit['modelo'] ?? '')?>" required>
<input name="tipo_bus" placeholder="Tipo de bus" value="<?=e($edit['tipo_bus'] ?? '')?>" required>
<input type="number" name="capacidad_maxima" placeholder="Capacidad máxima" value="<?=e($edit['capacidad_maxima'] ?? '')?>" required>
<select name="estado"><?php foreach(['Disponible','En ruta','Mantenimiento'] as $op): ?><option <?=($edit['estado'] ?? '')==$op?'selected':''?>><?=$op?></option><?php endforeach; ?></select>
<select name="id_linea"><option value="">Sin línea</option><?php foreach($lineas as $x): ?><option value="<?=e($x['id_linea'])?>" <?=($edit['id_linea'] ?? '')==$x['id_linea']?'selected':''?>><?=e($x['nombre_linea'])?></option><?php endforeach; ?></select>
<select name="id_parqueo" required><option value="">Seleccione parqueo</option><?php foreach($parqueos as $x): ?><option value="<?=e($x['id_parqueo'])?>" <?=($edit['id_parqueo'] ?? '')==$x['id_parqueo']?'selected':''?>><?=e($x['nombre'])?></option><?php endforeach; ?></select>
<select name="id_piloto">
  <option value="">Sin piloto</option>
  <?php foreach($pilotos as $x):
    $seleccionado = ($edit['id_piloto'] ?? '')==$x['id_piloto'];
    $ocupadoEnOtroBus = !empty($x['bus_asignado']) && (!$edit || (int)$x['bus_asignado'] !== (int)($edit['id_bus'] ?? 0));
    $textoExtra = $x['nombre_linea'] ? $x['nombre_linea'] : 'Sin línea';
    if ($ocupadoEnOtroBus) { $textoExtra .= ' / ya asignado al bus '.$x['placa_asignada']; }
  ?>
    <option value="<?=e($x['id_piloto'])?>" <?=$seleccionado?'selected':''?> <?=$ocupadoEnOtroBus?'disabled':''?>><?=e($x['nombre'])?> - <?=e($textoExtra)?></option>
  <?php endforeach; ?>
</select>
<button><?= $edit ? 'Actualizar bus' : 'Guardar bus' ?></button>
<?php if($edit): ?><a class="btn secondary" href="buses.php">Cancelar</a><?php endif; ?>
</form>
<a class="btn" href="descargar.php?tabla=buses">Descargar CSV</a>
<table><tr><th>ID</th><th>Placa</th><th>Modelo</th><th>Tipo</th><th>Capacidad</th><th>Línea</th><th>Parqueo</th><th>Piloto</th><th>Acciones</th></tr><?php foreach($rows as $r): ?><tr><td><?=e($r['id_bus'])?></td><td><?=e($r['placa'])?></td><td><?=e($r['modelo'])?></td><td><?=e($r['tipo_bus'])?></td><td><?=e($r['capacidad_maxima'])?></td><td><?=e($r['nombre_linea'])?></td><td><?=e($r['parqueo'])?></td><td><?=e($r['piloto'])?></td><td><a class="btn small" href="buses.php?editar=<?=e($r['id_bus'])?>">Editar</a> <a class="btn small danger" onclick="return confirm('¿Eliminar este bus?')" href="buses.php?eliminar=<?=e($r['id_bus'])?>">Eliminar</a></td></tr><?php endforeach; ?></table>
<?php require 'footer.php'; ?>
