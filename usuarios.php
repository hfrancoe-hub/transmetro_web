<?php require 'config.php'; soloAdmin();
$mensaje=''; $edit=null;
if (isset($_GET['eliminar'])) {
  $id=(int)$_GET['eliminar'];
  if ($id == ($_SESSION['usuario']['id_usuario'] ?? 0)) { $mensaje='No puedes eliminar el usuario con el que estás conectado.'; }
  else {
    $pdo->prepare('DELETE FROM usuarios WHERE id_usuario=?')->execute([$id]);
    header('Location: usuarios.php?ok=eliminado'); exit;
  }
}
if (isset($_GET['editar'])) { $stmt=$pdo->prepare('SELECT * FROM usuarios WHERE id_usuario=?'); $stmt->execute([(int)$_GET['editar']]); $edit=$stmt->fetch(); }
if ($_SERVER['REQUEST_METHOD']==='POST') {
  if (!empty($_POST['id_usuario'])) {
    if (!empty($_POST['contrasena'])) {
      $hash=password_hash($_POST['contrasena'], PASSWORD_DEFAULT);
      $stmt=$pdo->prepare('UPDATE usuarios SET nombre=?, correo=?, contrasena=?, id_rol=?, estado=? WHERE id_usuario=?');
      $stmt->execute([$_POST['nombre'], $_POST['correo'], $hash, $_POST['id_rol'], $_POST['estado'], $_POST['id_usuario']]);
    } else {
      $stmt=$pdo->prepare('UPDATE usuarios SET nombre=?, correo=?, id_rol=?, estado=? WHERE id_usuario=?');
      $stmt->execute([$_POST['nombre'], $_POST['correo'], $_POST['id_rol'], $_POST['estado'], $_POST['id_usuario']]);
    }
  } else {
    $hash=password_hash($_POST['contrasena'], PASSWORD_DEFAULT);
    $stmt=$pdo->prepare('INSERT INTO usuarios(nombre, correo, contrasena, id_rol, estado) VALUES(?,?,?,?,?)');
    $stmt->execute([$_POST['nombre'], $_POST['correo'], $hash, $_POST['id_rol'], $_POST['estado']]);
  }
  header('Location: usuarios.php?ok=guardado'); exit;
}
require 'header.php'; $roles=$pdo->query('SELECT * FROM roles')->fetchAll(); $usuarios=$pdo->query('SELECT u.*, r.nombre_rol FROM usuarios u JOIN roles r ON u.id_rol=r.id_rol ORDER BY u.id_usuario DESC')->fetchAll(); ?>
<h1>Usuarios</h1><?php if($mensaje): ?><div class="alert error"><?=e($mensaje)?></div><?php endif; ?>
<form method="POST" class="form-grid"><input type="hidden" name="id_usuario" value="<?=e($edit['id_usuario'] ?? '')?>"><input name="nombre" placeholder="Nombre" value="<?=e($edit['nombre'] ?? '')?>" required><input type="email" name="correo" placeholder="Correo" value="<?=e($edit['correo'] ?? '')?>" required><input type="password" name="contrasena" placeholder="<?= $edit ? 'Nueva contraseña opcional' : 'Contraseña' ?>" <?= $edit ? '' : 'required' ?>><select name="id_rol"><?php foreach($roles as $r): ?><option value="<?=e($r['id_rol'])?>" <?=($edit['id_rol'] ?? '')==$r['id_rol']?'selected':''?>><?=e($r['nombre_rol'])?></option><?php endforeach; ?></select><select name="estado"><?php foreach(['Activo','Inactivo'] as $op): ?><option <?=($edit['estado'] ?? '')==$op?'selected':''?>><?=$op?></option><?php endforeach; ?></select><button><?= $edit ? 'Actualizar usuario' : 'Guardar usuario' ?></button><?php if($edit): ?><a class="btn secondary" href="usuarios.php">Cancelar</a><?php endif; ?></form>
<table><tr><th>ID</th><th>Nombre</th><th>Correo</th><th>Rol</th><th>Estado</th><th>Acciones</th></tr><?php foreach($usuarios as $u): ?><tr><td><?=e($u['id_usuario'])?></td><td><?=e($u['nombre'])?></td><td><?=e($u['correo'])?></td><td><?=e($u['nombre_rol'])?></td><td><?=e($u['estado'])?></td><td><a class="btn small" href="usuarios.php?editar=<?=e($u['id_usuario'])?>">Editar</a> <a class="btn small danger" onclick="return confirm('¿Eliminar este usuario?')" href="usuarios.php?eliminar=<?=e($u['id_usuario'])?>">Eliminar</a></td></tr><?php endforeach; ?></table>
<?php require 'footer.php'; ?>
