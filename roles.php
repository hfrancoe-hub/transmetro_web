<?php require 'config.php'; soloAdmin();
$mensaje=''; $edit=null;

// Roles fijos del sistema: no se permite eliminar ni crear roles nuevos.
// Solo se permite editar la descripción del rol.
if (isset($_GET['eliminar'])) {
  header('Location: roles.php?error=no_eliminar');
  exit;
}

if (isset($_GET['editar'])) {
  $stmt=$pdo->prepare('SELECT * FROM roles WHERE id_rol=?');
  $stmt->execute([(int)$_GET['editar']]);
  $edit=$stmt->fetch();
}

if ($_SERVER['REQUEST_METHOD']==='POST') {
  if (!empty($_POST['id_rol'])) {
    $stmt=$pdo->prepare('UPDATE roles SET descripcion=? WHERE id_rol=?');
    $stmt->execute([$_POST['descripcion'], (int)$_POST['id_rol']]);
    header('Location: roles.php?ok=guardado'); exit;
  }
  header('Location: roles.php?error=no_crear'); exit;
}

require 'header.php';
$roles=$pdo->query('SELECT * FROM roles ORDER BY id_rol ASC')->fetchAll();
?>
<h1>Roles</h1>

<?php if(isset($_GET['error']) && $_GET['error']==='no_eliminar'): ?>
  <div class="alert error">Los roles del sistema no se pueden eliminar. Solo se puede editar la descripción.</div>
<?php endif; ?>
<?php if(isset($_GET['error']) && $_GET['error']==='no_crear'): ?>
  <div class="alert error">No se permite crear roles nuevos. Los roles ya están definidos.</div>
<?php endif; ?>
<?php if(isset($_GET['ok'])): ?>
  <div class="alert success">Descripción del rol actualizada correctamente.</div>
<?php endif; ?>

<?php if($edit): ?>
<form method="POST" class="form-grid">
  <input type="hidden" name="id_rol" value="<?=e($edit['id_rol'])?>">
  <input value="<?=e($edit['nombre_rol'])?>" readonly title="El nombre del rol no se puede modificar">
  <input name="descripcion" placeholder="Descripción" value="<?=e($edit['descripcion'])?>">
  <button>Actualizar descripción</button>
  <a class="btn secondary" href="roles.php">Cancelar</a>
</form>
<?php else: ?>
  <div class="alert">Los roles están definidos por el sistema. No se pueden agregar ni eliminar; únicamente se puede editar la descripción.</div>
<?php endif; ?>

<table>
<tr><th>ID</th><th>Rol</th><th>Descripción</th><th>Acciones</th></tr>
<?php foreach($roles as $r): ?>
<tr>
  <td><?=e($r['id_rol'])?></td>
  <td><?=e($r['nombre_rol'])?></td>
  <td><?=e($r['descripcion'])?></td>
  <td><a class="btn small" href="roles.php?editar=<?=e($r['id_rol'])?>">Editar descripción</a></td>
</tr>
<?php endforeach; ?>
</table>
<?php require 'footer.php'; ?>
