<?php
require 'config.php';
verificarSesion();
require 'header.php';

/*
  Este index cuenta solo registros activos cuando la tabla tiene un campo como:
  estado, activo, estado_bus, estado_piloto, estado_linea, estado_estacion, estado_alerta o disponible.

  Si una tabla no tiene ningún campo de estado, cuenta todos los registros para evitar errores.
*/

function obtenerColumnas($pdo, $tabla){
  static $cache = [];

  if(isset($cache[$tabla])){
    return $cache[$tabla];
  }

  $stmt = $pdo->query("SHOW COLUMNS FROM `$tabla`");
  $columnas = [];

  while($row = $stmt->fetch(PDO::FETCH_ASSOC)){
    $columnas[] = $row['Field'];
  }

  $cache[$tabla] = $columnas;
  return $columnas;
}

function columnaExiste($pdo, $tabla, $columna){
  return in_array($columna, obtenerColumnas($pdo, $tabla));
}

function contarActivos($pdo, $tabla){
  $tablasPermitidas = ['buses','pilotos','lineas','estaciones','alertas','parqueos','usuarios','roles'];

  if(!in_array($tabla, $tablasPermitidas)){
    return 0;
  }

  /*
    Reglas por tabla.
    Puedes ajustar los valores según cómo tengas escrito el estado en tu base de datos.
  */
  $reglas = [
    'buses' => [
      'estado' => ['Activo','Activa','Disponible','Operativo','Operativa','En servicio'],
      'estado_bus' => ['Activo','Activa','Disponible','Operativo','Operativa','En servicio'],
      'activo' => [1]
    ],
    'pilotos' => [
      'estado' => ['Activo','Activa','Disponible'],
      'estado_piloto' => ['Activo','Activa','Disponible'],
      'activo' => [1]
    ],
    'lineas' => [
      'estado' => ['Activo','Activa','Disponible','Operativa'],
      'estado_linea' => ['Activo','Activa','Disponible','Operativa'],
      'activo' => [1]
    ],
    'estaciones' => [
      'estado' => ['Activo','Activa','Operativa','Disponible'],
      'estado_estacion' => ['Activo','Activa','Operativa','Disponible'],
      'activo' => [1]
    ],
    'alertas' => [
      'estado' => ['Activa','Activo','Pendiente','En proceso'],
      'estado_alerta' => ['Activa','Activo','Pendiente','En proceso'],
      'activo' => [1]
    ],
    'parqueos' => [
      'estado' => ['Activo','Activa','Disponible'],
      'disponible' => [1],
      'activo' => [1]
    ],
    'usuarios' => [
      'estado' => ['Activo','Activa'],
      'activo' => [1]
    ],
    'roles' => [
      'estado' => ['Activo','Activa'],
      'activo' => [1]
    ]
  ];

  if(isset($reglas[$tabla])){
    foreach($reglas[$tabla] as $columna => $valores){
      if(columnaExiste($pdo, $tabla, $columna)){
        $placeholders = implode(',', array_fill(0, count($valores), '?'));
        $sql = "SELECT COUNT(*) AS c FROM `$tabla` WHERE `$columna` IN ($placeholders)";
        $stmt = $pdo->prepare($sql);
        $stmt->execute($valores);
        return $stmt->fetch(PDO::FETCH_ASSOC)['c'];
      }
    }
  }

  // Si no encuentra campo de estado, cuenta todos.
  $stmt = $pdo->query("SELECT COUNT(*) AS c FROM `$tabla`");
  return $stmt->fetch(PDO::FETCH_ASSOC)['c'];
}

$modulos = ['buses','pilotos','lineas','estaciones','alertas','parqueos','usuarios','roles'];
$totales = [];

foreach($modulos as $t){
  if (puedeVerModulo($t)) {
    $totales[$t] = contarActivos($pdo, $t);
  }
}

$tarjetas = [
  'buses' => [
    'titulo' => 'Buses activos',
    'icono' => 'bus',
    'color' => 'blue',
    'url' => 'buses.php'
  ],
  'pilotos' => [
    'titulo' => 'Pilotos activos',
    'icono' => 'user',
    'color' => 'blue',
    'url' => 'pilotos.php'
  ],
  'lineas' => [
    'titulo' => 'Líneas activas',
    'icono' => 'route',
    'color' => 'green',
    'url' => 'lineas.php'
  ],
  'estaciones' => [
    'titulo' => 'Estaciones operativas',
    'icono' => 'station',
    'color' => 'blue',
    'url' => 'estaciones.php'
  ],
  'alertas' => [
    'titulo' => 'Alertas activas',
    'icono' => 'alert',
    'color' => 'orange',
    'url' => 'alertas.php'
  ],
  'parqueos' => [
    'titulo' => 'Parqueos disponibles',
    'icono' => 'parking',
    'color' => 'green',
    'url' => 'parqueos.php'
  ],
  'usuarios' => [
    'titulo' => 'Usuarios activos',
    'icono' => 'users',
    'color' => 'blue',
    'url' => 'usuarios.php'
  ],
  'roles' => [
    'titulo' => 'Roles activos',
    'icono' => 'shield',
    'color' => 'green',
    'url' => 'roles.php'
  ]
];

function iconoDashboard($tipo){
  $iconos = [
    'bus' => '<svg viewBox="0 0 24 24"><path d="M6 3h12a3 3 0 0 1 3 3v10a2 2 0 0 1-2 2v2a1 1 0 0 1-2 0v-2H7v2a1 1 0 0 1-2 0v-2a2 2 0 0 1-2-2V6a3 3 0 0 1 3-3Zm0 2a1 1 0 0 0-1 1v5h14V6a1 1 0 0 0-1-1H6Zm1 10a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3Zm10 0a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3Z"/></svg>',
    'user' => '<svg viewBox="0 0 24 24"><path d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8Zm0 2c-4.42 0-8 2.24-8 5v1h16v-1c0-2.76-3.58-5-8-5Z"/></svg>',
    'route' => '<svg viewBox="0 0 24 24"><path d="M7 5a3 3 0 1 0 2 5.24V18a1 1 0 0 0 2 0v-4h2a4 4 0 0 0 4-4V6.83A3 3 0 1 0 15 6.83V10a2 2 0 0 1-2 2h-2V5a3 3 0 0 0-4 0Zm0 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2Zm10-1a1 1 0 1 1 0 2 1 1 0 0 1 0-2Zm-7 14a3 3 0 1 0 4 2.82A3 3 0 0 0 10 19Zm0 2a1 1 0 1 1 0 .01V21Z"/></svg>',
    'station' => '<svg viewBox="0 0 24 24"><path d="M3 20h18v2H3v-2Zm2-1V9l7-5 7 5v10h-2v-8.9l-5-3.57-5 3.57V19H5Zm5 0v-6h4v6h-4Zm-1-8h6V9H9v2Z"/></svg>',
    'alert' => '<svg viewBox="0 0 24 24"><path d="M1 21h22L12 2 1 21Zm12-3h-2v-2h2v2Zm0-4h-2v-5h2v5Z"/></svg>',
    'parking' => '<svg viewBox="0 0 24 24"><path d="M6 3h8a6 6 0 0 1 0 12h-4v6H6V3Zm4 4v4h4a2 2 0 0 0 0-4h-4Z"/></svg>',
    'users' => '<svg viewBox="0 0 24 24"><path d="M16 11a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM8 11a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm0 2c-3.31 0-6 1.69-6 3.78V19h12v-2.22C14 14.69 11.31 13 8 13Zm8 0c-.7 0-1.36.08-1.97.24A5.64 5.64 0 0 1 16 16.78V19h6v-2.22C22 14.69 19.31 13 16 13Z"/></svg>',
    'shield' => '<svg viewBox="0 0 24 24"><path d="M12 2 4 5v6c0 5.55 3.84 10.74 8 12 4.16-1.26 8-6.45 8-12V5l-8-3Zm-1 15-4-4 1.41-1.41L11 14.17l5.59-5.59L18 10l-7 7Z"/></svg>'
  ];

  return $iconos[$tipo] ?? $iconos['bus'];
}
?>

<h1>Panel principal</h1>
<p class="page-subtitle">Bienvenido al Sistema de Control de Transmetro.</p>

<div class="stats-grid">
<?php foreach($tarjetas as $clave => $info): ?>
  <?php if(isset($totales[$clave])): ?>
    <a class="stat-card" href="<?= $info['url'] ?>">
      <div>
        <h2><?= $info['titulo'] ?></h2>
        <strong><?= $totales[$clave] ?></strong>
      </div>

      <div class="stat-icon <?= $info['color'] ?>">
        <?= iconoDashboard($info['icono']) ?>
      </div>
    </a>
  <?php endif; ?>
<?php endforeach; ?>
</div>

<?php require 'footer.php'; ?>
