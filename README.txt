Sistema Transmetro - PHP + MySQL

Ruta requerida:
C:\xampp\htdocs\transmetro_web

URL:
http://localhost/transmetro_web/login.php

Instalación:
1. Elimina la carpeta anterior C:\xampp\htdocs\transmetro_web.
2. Copia esta carpeta transmetro_web dentro de C:\xampp\htdocs.
3. En phpMyAdmin ejecuta: DROP DATABASE IF EXISTS transmetro_db;
4. Importa el archivo db.sql.
5. Ingresa con:
   Correo: admin@transmetro.com
   Contraseña: admin123

Cambios incluidos en esta versión:
- Alertas solo se pueden editar, no eliminar.
- Líneas con estaciones asignadas según el listado de estaciones compartido.
- Estación 4 de Febrero queda escrita como: 4 de Febrero (Dirección: La Merced) y 4 de Febrero (Dirección: USAC Periférico).
- Buses con tipo de unidad: Convencional, No articulado, Articulado, Biarticulado y Eléctrico.
- Capacidades de buses diferenciadas para que existan unidades de menor y mayor capacidad.
- Reporte CSV de buses incluye tipo de bus.
- Validación de pilotos: si un piloto ya tiene estación asignada, primero debe quedar sin estación antes de asignarlo a otra.

Actualización:
- Los pilotos ahora se asignan a una sola línea, no a estaciones.
- No se permite cambiar directamente un piloto a otra línea si ya tiene una asignada; primero debe dejarse sin línea y guardar.
- Al asignar piloto a un bus, el piloto debe pertenecer a la misma línea del bus.


CONTROL DE ACCESO POR ROLES:
- Administrador: acceso completo a todos los módulos.
- Operador: acceso a líneas, estaciones, buses, pilotos, parqueos y descargas operativas.
- Jefe de monitoreo: acceso a alertas y descarga de alertas.

Usuarios de prueba:
- admin@transmetro.com / admin123
- operador@transmetro.com / admin123
- monitoreo@transmetro.com / admin123
