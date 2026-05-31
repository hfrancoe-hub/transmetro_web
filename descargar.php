<?php
require 'config.php'; requiereModulo('descargar');
$tabla = $_GET['tabla'] ?? '';
$permitidas = [
 'buses' => 'SELECT b.id_bus, b.placa, b.modelo, b.tipo_bus, b.capacidad_maxima, b.estado, l.nombre_linea, p.nombre parqueo, pi.nombre piloto FROM buses b LEFT JOIN lineas l ON b.id_linea=l.id_linea JOIN parqueos p ON b.id_parqueo=p.id_parqueo LEFT JOIN pilotos pi ON b.id_piloto=pi.id_piloto',
 'pilotos' => 'SELECT p.id_piloto, p.nombre, p.licencia, p.telefono, p.direccion, p.estado, l.nombre_linea linea_asignada FROM pilotos p LEFT JOIN lineas l ON p.id_linea=l.id_linea',
 'parqueos' => 'SELECT id_parqueo, nombre, ubicacion, capacidad, estado FROM parqueos',
 'alertas' => 'SELECT a.id_alerta, a.tipo_alerta, a.descripcion, a.prioridad, a.estado, a.fecha, e.nombre_estacion, b.placa FROM alertas a LEFT JOIN estaciones e ON a.id_estacion=e.id_estacion LEFT JOIN buses b ON a.id_bus=b.id_bus',
 'estaciones' => 'SELECT e.id_estacion, e.nombre_estacion, e.ubicacion, e.capacidad_esperada, e.usuarios_actuales, e.estado, GROUP_CONCAT(l.nombre_linea ORDER BY le.orden SEPARATOR ", ") lineas FROM estaciones e LEFT JOIN lineas_estaciones le ON e.id_estacion=le.id_estacion LEFT JOIN lineas l ON le.id_linea=l.id_linea GROUP BY e.id_estacion',
 'lineas' => 'SELECT l.id_linea, l.nombre_linea, l.ruta, l.descripcion, GROUP_CONCAT(e.nombre_estacion ORDER BY le.orden SEPARATOR " | ") estaciones FROM lineas l LEFT JOIN lineas_estaciones le ON l.id_linea=le.id_linea LEFT JOIN estaciones e ON le.id_estacion=e.id_estacion GROUP BY l.id_linea'
];
if (!isset($permitidas[$tabla])) { die('Reporte no permitido.'); }

$permisosReporte = [
  'Administrador' => ['buses','pilotos','parqueos','alertas','estaciones','lineas'],
  'Operador' => ['buses','pilotos','parqueos','estaciones','lineas'],
  'Jefe de monitoreo' => ['alertas']
];
if (!in_array($tabla, $permisosReporte[$_SESSION['rol'] ?? ''] ?? [], true)) {
  http_response_code(403);
  die('No tienes permiso para descargar este reporte.');
}

$stmt = $pdo->query($permitidas[$tabla]);
$rows = $stmt->fetchAll();
header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename="reporte_'.$tabla.'_'.date('Y-m-d').'.csv"');
$out = fopen('php://output', 'w');
fprintf($out, chr(0xEF).chr(0xBB).chr(0xBF));
if (!empty($rows)) { fputcsv($out, array_keys($rows[0])); foreach($rows as $row){ fputcsv($out, $row); } }
else { fputcsv($out, ['Sin registros']); }
fclose($out);
exit;
?>
