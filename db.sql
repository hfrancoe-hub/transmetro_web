CREATE DATABASE IF NOT EXISTS transmetro_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE transmetro_db;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS alertas;
DROP TABLE IF EXISTS buses;
DROP TABLE IF EXISTS lineas_estaciones;
DROP TABLE IF EXISTS pilotos;
DROP TABLE IF EXISTS parqueos;
DROP TABLE IF EXISTS estaciones;
DROP TABLE IF EXISTS lineas;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS roles;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE roles (
  id_rol INT AUTO_INCREMENT PRIMARY KEY,
  nombre_rol VARCHAR(50) NOT NULL UNIQUE,
  descripcion VARCHAR(150) NULL
);

CREATE TABLE usuarios (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(100) NOT NULL UNIQUE,
  contrasena VARCHAR(255) NOT NULL,
  id_rol INT NOT NULL,
  estado ENUM('Activo','Inactivo') DEFAULT 'Activo',
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);

CREATE TABLE parqueos (
  id_parqueo INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(80) NOT NULL,
  ubicacion VARCHAR(150) NOT NULL,
  capacidad INT NOT NULL DEFAULT 0,
  estado VARCHAR(30) DEFAULT 'Disponible'
);

CREATE TABLE lineas (
  id_linea INT AUTO_INCREMENT PRIMARY KEY,
  nombre_linea VARCHAR(80) NOT NULL UNIQUE,
  ruta VARCHAR(180) NOT NULL,
  descripcion TEXT NULL
);

CREATE TABLE estaciones (
  id_estacion INT AUTO_INCREMENT PRIMARY KEY,
  nombre_estacion VARCHAR(120) NOT NULL,
  ubicacion VARCHAR(180) NOT NULL,
  capacidad_esperada INT NOT NULL DEFAULT 100,
  usuarios_actuales INT NOT NULL DEFAULT 0,
  estado VARCHAR(30) DEFAULT 'Activa'
);

CREATE TABLE lineas_estaciones (
  id_linea INT NOT NULL,
  id_estacion INT NOT NULL,
  orden INT NOT NULL DEFAULT 1,
  PRIMARY KEY (id_linea, id_estacion),
  FOREIGN KEY (id_linea) REFERENCES lineas(id_linea) ON DELETE CASCADE,
  FOREIGN KEY (id_estacion) REFERENCES estaciones(id_estacion) ON DELETE CASCADE
);

CREATE TABLE pilotos (
  id_piloto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  licencia VARCHAR(50) NOT NULL UNIQUE,
  telefono VARCHAR(25),
  direccion VARCHAR(150),
  estado VARCHAR(30) DEFAULT 'Activo',
  id_linea INT NULL,
  FOREIGN KEY (id_linea) REFERENCES lineas(id_linea) ON DELETE SET NULL
);

CREATE TABLE buses (
  id_bus INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(30) NOT NULL UNIQUE,
  modelo VARCHAR(80) NOT NULL,
  tipo_bus VARCHAR(80) NOT NULL DEFAULT 'Articulado',
  capacidad_maxima INT NOT NULL,
  estado VARCHAR(30) DEFAULT 'Disponible',
  id_linea INT NULL,
  id_parqueo INT NOT NULL,
  id_piloto INT NULL,
  FOREIGN KEY (id_linea) REFERENCES lineas(id_linea),
  FOREIGN KEY (id_parqueo) REFERENCES parqueos(id_parqueo),
  FOREIGN KEY (id_piloto) REFERENCES pilotos(id_piloto)
);

CREATE TABLE alertas (
  id_alerta INT AUTO_INCREMENT PRIMARY KEY,
  tipo_alerta VARCHAR(80) NOT NULL,
  descripcion TEXT NOT NULL,
  prioridad ENUM('Baja','Media','Alta','Crítica') DEFAULT 'Media',
  estado VARCHAR(30) DEFAULT 'Activa',
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  id_estacion INT NULL,
  id_bus INT NULL,
  FOREIGN KEY (id_estacion) REFERENCES estaciones(id_estacion) ON DELETE SET NULL,
  FOREIGN KEY (id_bus) REFERENCES buses(id_bus) ON DELETE SET NULL
);

INSERT INTO roles (nombre_rol, descripcion) VALUES
('Administrador', 'Acceso completo al sistema'),
('Operador', 'Gestiona buses, pilotos, parqueos, estaciones y líneas'),
('Jefe de monitoreo', 'Puede editar alertas y consultar reportes; no crea alertas'),
('Piloto', 'Puede ingresar alertas y consultarlas; no puede editarlas');

-- Usuario inicial: admin@transmetro.com / admin123
INSERT INTO usuarios (nombre, correo, contrasena, id_rol) VALUES
('Administrador General', 'admin@transmetro.com', '$2y$12$xPHdHYcn2I01255mtdjVNetwayJ9PDrtBJ8npxzGmQjWfkFm.e5A6', 1),
('Operador Estación', 'operador@transmetro.com', '$2y$12$xPHdHYcn2I01255mtdjVNetwayJ9PDrtBJ8npxzGmQjWfkFm.e5A6', 2),
('Jefe de Monitoreo', 'monitoreo@transmetro.com', '$2y$12$xPHdHYcn2I01255mtdjVNetwayJ9PDrtBJ8npxzGmQjWfkFm.e5A6', 3),
('Piloto Transmetro', 'piloto@transmetro.com', '$2y$12$xPHdHYcn2I01255mtdjVNetwayJ9PDrtBJ8npxzGmQjWfkFm.e5A6', 4);

INSERT INTO parqueos (nombre, ubicacion, capacidad, estado) VALUES
('Parqueo Central','Zona 1',40,'Disponible'),
('Parqueo Norte','Zona 18',30,'Disponible'),
('Parqueo Sur','Centra Sur / Villa Nueva',35,'Disponible'),
('Parqueo Zona 13','Plaza Argentina, zona 13',25,'Disponible');

INSERT INTO lineas (nombre_linea, ruta, descripcion) VALUES
('Línea 1', 'San Sebastián Z.1 / Centro Cívico Z.1', 'Ruta zona 1 hacia Centro Cívico'),
('Línea 2', 'Hipódromo del Norte Z.2 / San Sebastián Z.1', 'Ruta zona 2 hacia San Sebastián'),
('Ruta 5 TuBus', 'Parque Colón Z.1 / Puente de la Penitenciaría Z.4', 'Ruta operada por TuBus'),
('Línea 6', 'Proyectos Z.6 / FEGUA Z.1', 'Ruta zona 6 hacia FEGUA'),
('Línea 7', 'USAC Periférico Z.12 / La Merced Z.1', 'Ruta por Anillo Periférico'),
('Línea 12', 'Centra Sur / Plaza Barrios Z.1', 'Ruta Aguilar Batres hacia zona 1'),
('Línea 13', 'Plaza Argentina Z.13 / Tipografía Z.1', 'Ruta zona 13 hacia Centro Histórico'),
('Línea 18', 'Atlántida Z.18 / FEGUA Z.1', 'Ruta zona 18 hacia FEGUA');

INSERT INTO estaciones (nombre_estacion, ubicacion, capacidad_esperada, usuarios_actuales, estado) VALUES
('Mercado Central', '8ª avenida y 6ª calle, zona 1', 100, 185, 'Activa'),
('Correos', '8ª avenida y 12 calle, zona 1', 100, 86, 'Activa'),
('Beatas de Belén', '8ª avenida y 15 calle, zona 1', 100, 94, 'Activa'),
('Paseo de las Letras', '8ª avenida y 19 calle, zona 1', 100, 102, 'Activa'),
('Centro Cívico', '21 calle y 6ª avenida A, zona 1', 120, 110, 'Activa'),
('Sur 2', '5ª avenida y 18 calle, zona 1', 100, 70, 'Activa'),
('Gómez Carrillo', '5ª avenida y 14 calle, zona 1', 100, 78, 'Activa'),
('San Agustín', '5ª avenida y 11 calle, zona 1', 100, 86, 'Activa'),
('Parque Centenario', '5ª avenida y 8ª calle, zona 1', 100, 94, 'Activa'),
('San José de la Montaña', 'Avenida Simeón Cañas y 6ª calle, zona 2', 120, 102, 'Activa'),
('Hipódromo del Norte', 'Avenida Simeón Cañas y 11 calle, zona 2', 100, 110, 'Activa'),
('Simeón Cañas', 'Avenida Simeón Cañas y 7ª calle, zona 2', 100, 70, 'Activa'),
('Jocotenango', '6ª avenida entre 3ª y 4ª calle, zona 2', 100, 78, 'Activa'),
('Parque Colón', '12 avenida 9ª calle, zona 1', 100, 86, 'Activa'),
('Cipreses - Parque Colón', 'Bulevar La Asunción y Arco 3, zona 5', 120, 94, 'Activa'),
('Cipreses - Puente de la Penitenciaría', 'Bulevar La Asunción y 11 calle, zona 5', 100, 102, 'Activa'),
('Jardines de la Asunción - Parque Colón', 'Bulevar La Asunción y Arco 5-6, zona 5', 100, 110, 'Activa'),
('Jardines de la Asunción - Puente de la Penitenciaría', 'Bulevar La Asunción y 12 calle B, zona 5', 100, 70, 'Activa'),
('Arrivillaga', 'Bulevar La Asunción y 20 calle, zona 5', 100, 78, 'Activa'),
('Parque Navidad', '23 calle y 28 avenida, zona 5', 120, 86, 'Activa'),
('La Palmita', '27 calle y 20 avenida, zona 5', 100, 94, 'Activa'),
('Palacio de los Deportes - Parque Colón', '10 avenida y 24 calle, zona 5', 100, 102, 'Activa'),
('Palacio de los Deportes - Puente de la Penitenciaría', '24 calle y 9ª avenida, zona 5', 100, 110, 'Activa'),
('Puente de la Penitenciaría', 'Vía 1 y 7ª avenida, zona 4', 100, 70, 'Activa'),
('Mercado La Palmita', '26 calle y 17 avenida A, zona 5', 120, 78, 'Activa'),
('Vivibien', 'Diagonal 14 y 23 calle, zona 5', 100, 86, 'Activa'),
('Matamoros', '7ª calle y 16 avenida, zona 1', 100, 94, 'Activa'),
('Parroquia', '15 avenida y 3ª calle, zona 6', 100, 102, 'Activa'),
('IGSS Zona 6', '16 avenida y 6ª calle, zona 6', 100, 110, 'Activa'),
('Centro Zona 6', '16 avenida y 10ª calle, zona 6', 120, 70, 'Activa'),
('Academia', '16 avenida y 15 calle, zona 6', 100, 78, 'Activa'),
('Cipresales', 'Avenida La Pedrera y 18 calle, zona 6', 100, 86, 'Activa'),
('Proyectos 4-4', 'Avenida La Pedrera y 20 calle, zona 6', 100, 94, 'Activa'),
('Proyectos', 'Avenida La Pedrera y 25 calle, zona 6', 100, 102, 'Activa'),
('Quintanal', '15 avenida y 13 calle, zona 6', 120, 110, 'Activa'),
('Corpus Christi', '15 avenida y 10ª calle, zona 6', 100, 70, 'Activa'),
('José Martí', '14 avenida y 7ª calle, zona 6', 100, 78, 'Activa'),
('Santa Teresa', '10ª avenida y 4ª calle, zona 1', 100, 86, 'Activa'),
('USAC Periférico', 'Anillo Periférico y 11 avenida, zona 12', 100, 94, 'Activa'),
('Granai - La Merced', 'Anillo Periférico y 12 avenida, zona 11', 120, 102, 'Activa'),
('Granai - USAC Periférico', 'Anillo Periférico y 9ª avenida A, zona 11', 100, 110, 'Activa'),
('Rodolfo Robles - La Merced', 'Anillo Periférico 20 calle, zona 11', 100, 70, 'Activa'),
('Rodolfo Robles - USAC Periférico', 'Anillo Periférico Diagonal 21 y calle Mariscal, zona 11', 100, 78, 'Activa'),
('CEJUSA - La Merced', 'Anillo Periférico y 18 calle, zona 11', 100, 86, 'Activa'),
('CEJUSA - USAC Periférico', 'Anillo Periférico y 17 calle, zona 11', 120, 94, 'Activa'),
('San Jorge - La Merced', 'Anillo Periférico y 21 avenida, zona 11', 100, 102, 'Activa'),
('San Jorge - USAC Periférico', 'Anillo Periférico y 22 avenida, zona 11', 100, 110, 'Activa'),
('Roosevelt - La Merced', 'Anillo Periférico y Calzada Roosevelt, zona 11', 100, 70, 'Activa'),
('Roosevelt - USAC Periférico', 'Anillo Periférico y Calzada Roosevelt, zona 11', 100, 78, 'Activa'),
('San Juan - La Merced', 'Anillo Periférico entre 4ª y 6ª calles, zona 7', 120, 86, 'Activa'),
('San Juan - USAC Periférico', 'Anillo Periférico y 6ª calle, zona 7', 100, 94, 'Activa'),
('Ciudad de Plata II - La Merced', 'Anillo Periférico y 14 calle, zona 7', 100, 102, 'Activa'),
('Ciudad de Plata II - USAC Periférico', 'Anillo Periférico y 13 calle B, zona 7', 100, 110, 'Activa'),
('Villa Linda - La Merced', 'Anillo Periférico y 16 calle, zona 7', 100, 70, 'Activa'),
('Villa Linda - USAC Periférico', 'Anillo Periférico y 16 calle, zona 7', 120, 78, 'Activa'),
('4 de Febrero (Dirección: La Merced)', 'Anillo Periférico y 6ª calle, zona 7', 100, 86, 'Activa'),
('4 de Febrero (Dirección: USAC Periférico)', 'Anillo Periférico y 22 calle, zona 7', 100, 94, 'Activa'),
('Bethania - La Merced', 'Anillo Periférico y 25 calle, zona 7', 100, 102, 'Activa'),
('Bethania - USAC Periférico', 'Anillo Periférico y 13 avenida, zona 7', 100, 110, 'Activa'),
('Incenso - La Merced', 'Anillo Periférico y Puente El Incenso, zona 7', 120, 70, 'Activa'),
('Incenso - USAC Periférico', 'Anillo Periférico y Puente El Incenso, zona 7', 100, 78, 'Activa'),
('San Juan de Dios', '9ª calle y 2ª avenida, zona 1', 100, 86, 'Activa'),
('Pasares', '9ª calle y 7ª avenida, zona 1', 100, 94, 'Activa'),
('La Merced', '11 avenida y 4ª calle, zona 1', 100, 102, 'Activa'),
('Cruz Roja', '4ª calle y 8ª avenida, zona 1', 120, 110, 'Activa'),
('Archivo General', '4ª avenida y 7ª calle, zona 1', 100, 70, 'Activa'),
('Santuario de Guadalupe', '8ª calle y 1ª avenida, zona 1', 100, 78, 'Activa'),
('Plaza Municipal', '6ª avenida y 21 calle, zona 1', 100, 86, 'Activa'),
('Plaza Barrios', '9ª avenida y 18 calle, zona 1', 100, 94, 'Activa'),
('Plaza El Amate', '18 calle y 4ª avenida, zona 1', 120, 102, 'Activa'),
('Don Bosco', '1ª avenida y 26 calle, zona 1', 100, 110, 'Activa'),
('Bolívar - Plaza Barrios', 'Avenida Bolívar y 32 calle, zona 8', 100, 70, 'Activa'),
('Bolívar - Centra Sur', 'Avenida Bolívar y 31 calle, zona 3', 100, 78, 'Activa'),
('Santa Cecilia', 'Avenida Bolívar y 40 calle, zona 8', 100, 86, 'Activa'),
('Trébol', 'Calzada Aguilar Batres y avenida Bolívar, zona 12', 120, 94, 'Activa'),
('Mariscal - Centra Sur', 'Calzada Aguilar Batres y 13 calle, zona 12', 100, 102, 'Activa'),
('Mariscal - Plaza Barrios', 'Calzada Aguilar Batres y 15 calle, zona 12', 100, 110, 'Activa'),
('Reformita - Centra Sur', 'Calzada Aguilar Batres y 20 calle, zona 12', 100, 70, 'Activa'),
('Reformita - Plaza Barrios', 'Calzada Aguilar Batres y 21 calle, zona 12', 100, 78, 'Activa'),
('El Carmen', 'Calzada Aguilar Batres y 29 calle, zona 12', 120, 86, 'Activa'),
('Las Charcas - Centra Sur', 'Calzada Aguilar Batres y 32 calle, zona 12', 100, 94, 'Activa'),
('Las Charcas - Plaza Barrios', 'Calzada Aguilar Batres y 34 calle, zona 12', 100, 102, 'Activa'),
('Javier', 'Calzada Aguilar Batres y 38 calle, zona 12 Villa Nueva', 100, 110, 'Activa'),
('Monte María', 'Calzada Aguilar Batres y 46 calle, zona 12 Villa Nueva', 100, 70, 'Activa'),
('Centra Sur', '21 avenida final, zona 12 Villa Nueva', 120, 185, 'Activa'),
('El Calvario', '6ª avenida y 20 calle, zona 1', 100, 86, 'Activa'),
('4 Grados Sur', '6ª avenida y 24 calle, zona 4', 100, 94, 'Activa'),
('Exposición', '6ª avenida y Ruta 6, zona 4', 100, 102, 'Activa'),
('Terminal', '6ª avenida y 2ª calle, zona 9', 100, 110, 'Activa'),
('Industria', '6ª avenida y 6ª calle, zona 9', 120, 70, 'Activa'),
('Tívoli', '6ª avenida y 10ª calle, zona 9', 100, 78, 'Activa'),
('Montúfar', '6ª avenida y 13 calle, zona 9', 100, 86, 'Activa'),
('Acueducto', 'Avenida Hincapié y 4ª calle, zona 13', 100, 94, 'Activa'),
('Fuerza Aérea', 'Avenida Hincapié y 11 calle, zona 13', 100, 102, 'Activa'),
('Hangares', '15 avenida y 18 calle, zona 13', 120, 110, 'Activa'),
('Plaza Argentina', '15 avenida y 11 calle, zona 13', 100, 70, 'Activa'),
('Los Arcos', '15 avenida y 4ª calle, zona 13', 100, 78, 'Activa'),
('Plaza España', '7ª avenida y 13 calle, zona 9', 100, 86, 'Activa'),
('IGSS Zona 9', '7ª avenida y 10ª calle, zona 9', 100, 94, 'Activa'),
('Seis 26', '7ª avenida y 5ª calle, zona 9', 120, 102, 'Activa'),
('Torre del Reformador', '7ª avenida y 1ª calle, zona 9', 100, 110, 'Activa'),
('Plaza de la República', '7ª avenida y ruta 4, zona 4', 100, 70, 'Activa'),
('Cantón Exposición', '7ª avenida Ruta 2 y Vía 3, zona 4', 100, 78, 'Activa'),
('Banco de Guatemala', '7ª avenida y 22 calle, zona 1', 100, 86, 'Activa'),
('Tipografía', '18 calle y 7ª avenida, zona 1', 120, 94, 'Activa'),
('Plaza Berlín', 'Plaza Berlín y Avenida Las Américas, zona 13', 100, 102, 'Activa'),
('Juan Pablo II', 'Avenida Las Américas y 21 calle, zona 14', 100, 110, 'Activa'),
('San Martín - Plaza Barrios/FEGUA', '20 avenida y 1ª calle, zona 1', 100, 70, 'Activa'),
('San Martín - Atlántida', '1ª calle y 18 avenida, zona 1', 100, 78, 'Activa'),
('Victorias', 'Avenida Las Victorias y 3ª calle, zona 6', 120, 86, 'Activa'),
('Portales', 'KM 4.5 Carretera al Atlántico 3-20 Ciudad de Guatemala', 100, 94, 'Activa'),
('San Rafael', '12 calle y 4ª avenida Colonia San Rafael, zona 18', 100, 102, 'Activa'),
('Paraíso', '12 calle y 25 avenida, zona 18', 100, 110, 'Activa');

INSERT INTO lineas_estaciones (id_linea, id_estacion, orden) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 3),
(1, 4, 4),
(1, 5, 5),
(1, 6, 6),
(1, 7, 7),
(1, 8, 8),
(1, 9, 9),
(2, 10, 1),
(2, 11, 2),
(2, 12, 3),
(2, 13, 4),
(3, 14, 1),
(3, 15, 2),
(3, 16, 3),
(3, 17, 4),
(3, 18, 5),
(3, 19, 6),
(3, 20, 7),
(3, 21, 8),
(3, 22, 9),
(3, 23, 10),
(3, 24, 11),
(3, 25, 12),
(3, 26, 13),
(3, 27, 14),
(4, 28, 1),
(4, 29, 2),
(4, 30, 3),
(4, 31, 4),
(4, 32, 5),
(4, 33, 6),
(4, 34, 7),
(4, 35, 8),
(4, 36, 9),
(4, 37, 10),
(4, 38, 11),
(5, 39, 1),
(5, 40, 2),
(5, 41, 3),
(5, 42, 4),
(5, 43, 5),
(5, 44, 6),
(5, 45, 7),
(5, 46, 8),
(5, 47, 9),
(5, 48, 10),
(5, 49, 11),
(5, 50, 12),
(5, 51, 13),
(5, 52, 14),
(5, 53, 15),
(5, 54, 16),
(5, 55, 17),
(5, 56, 18),
(5, 57, 19),
(5, 58, 20),
(5, 59, 21),
(5, 60, 22),
(5, 61, 23),
(5, 62, 24),
(5, 63, 25),
(5, 64, 26),
(5, 65, 27),
(5, 66, 28),
(5, 67, 29),
(6, 68, 1),
(6, 69, 2),
(6, 70, 3),
(6, 71, 4),
(6, 72, 5),
(6, 73, 6),
(6, 74, 7),
(6, 75, 8),
(6, 76, 9),
(6, 77, 10),
(6, 78, 11),
(6, 79, 12),
(6, 80, 13),
(6, 81, 14),
(6, 82, 15),
(6, 83, 16),
(6, 84, 17),
(6, 85, 18),
(7, 86, 1),
(7, 87, 2),
(7, 88, 3),
(7, 89, 4),
(7, 90, 5),
(7, 91, 6),
(7, 92, 7),
(7, 93, 8),
(7, 94, 9),
(7, 95, 10),
(7, 96, 11),
(7, 97, 12),
(7, 98, 13),
(7, 99, 14),
(7, 100, 15),
(7, 101, 16),
(7, 102, 17),
(7, 103, 18),
(7, 104, 19),
(7, 105, 20),
(7, 106, 21),
(7, 107, 22),
(8, 108, 1),
(8, 109, 2),
(8, 110, 3),
(8, 111, 4),
(8, 112, 5),
(8, 113, 6);

INSERT INTO pilotos (nombre, licencia, telefono, direccion, estado, id_linea) VALUES
('Piloto 01','LIC-TM-001','5555-1001','Guatemala','Activo',1),
('Piloto 02','LIC-TM-002','5555-1002','Guatemala','Activo',1),
('Piloto 03','LIC-TM-003','5555-1003','Guatemala','Activo',1),
('Piloto 04','LIC-TM-004','5555-1004','Guatemala','Activo',2),
('Piloto 05','LIC-TM-005','5555-1005','Guatemala','Activo',2),
('Piloto 06','LIC-TM-006','5555-1006','Guatemala','Activo',2),
('Piloto 07','LIC-TM-007','5555-1007','Guatemala','Activo',3),
('Piloto 08','LIC-TM-008','5555-1008','Guatemala','Activo',4),
('Piloto 09','LIC-TM-009','5555-1009','Guatemala','Activo',5),
('Piloto 10','LIC-TM-010','5555-1010','Guatemala','Activo',6),
('Piloto 11','LIC-TM-011','5555-1011','Guatemala','Activo',7),
('Piloto 12','LIC-TM-012','5555-1012','Guatemala','Activo',8);

INSERT INTO buses (placa, modelo, tipo_bus, capacidad_maxima, estado, id_linea, id_parqueo, id_piloto) VALUES
('TM-0101','Busscar Urbanuss Pluss / Volvo B12M','Articulado',160,'Disponible',1,2,1),
('TM-0102','Marcopolo Viale BRT / Volvo B340M','Articulado',160,'Disponible',1,2,2),
('TM-0103','Marcopolo Viale BRT / Scania K310IA','Articulado',160,'Disponible',1,2,3),
('TM-0201','Busscar Urbanuss Pluss / Scania K270','No articulado',119,'Disponible',2,3,4),
('TM-0202','Busscar Urbanuss Pluss / Scania K270','No articulado',119,'Disponible',2,3,5),
('TM-0203','Bus convencional Transmetro','Convencional',80,'Disponible',2,3,6),
('TM-0501','FOTON BJ6123EVCA eléctrico','Eléctrico',80,'Disponible',3,1,7),
('TM-0502','FOTON BJ6123EVCA eléctrico','Eléctrico',80,'Disponible',3,1,8),
('TM-0503','BYD eléctrico 12 metros','Eléctrico',81,'Disponible',3,1,9),
('TM-0601','Bus convencional Transmetro','Convencional',80,'Disponible',4,2,10),
('TM-0602','Busscar Urbanuss Pluss / Scania K270','No articulado',119,'Disponible',4,2,11),
('TM-0603','Marcopolo Viale BRT','Articulado',160,'Disponible',4,2,12),
('TM-0701','Marcopolo Viale BRT','Articulado',160,'Disponible',5,3,NULL),
('TM-0702','Bus convencional Transmetro','Convencional',80,'Disponible',5,3,NULL),
('TM-0703','Unidad biarticulada Transmetro','Biarticulado',250,'Disponible',5,3,NULL),
('TM-1201','Marcopolo Viale BRT','Articulado',160,'Disponible',6,1,NULL),
('TM-1202','Unidad biarticulada Transmetro','Biarticulado',250,'Disponible',6,1,NULL),
('TM-1203','Bus convencional Transmetro','Convencional',80,'Disponible',6,1,NULL),
('TM-1301','Busscar Urbanuss Pluss / Scania K270','No articulado',119,'Disponible',7,2,NULL),
('TM-1302','Bus convencional Transmetro','Convencional',80,'Disponible',7,2,NULL),
('TM-1303','Marcopolo Viale BRT','Articulado',160,'Disponible',7,2,NULL),
('TM-1801','Marcopolo Viale BRT','Articulado',160,'Disponible',8,3,NULL),
('TM-1802','Bus convencional Transmetro','Convencional',80,'Disponible',8,3,NULL),
('TM-1803','Unidad biarticulada Transmetro','Biarticulado',250,'Disponible',8,3,NULL);

INSERT INTO alertas (tipo_alerta, descripcion, prioridad, estado, id_estacion, id_bus) VALUES
('Sobrecupo de estación', 'La estación Mercado Central superó el 50% de su capacidad esperada.', 'Alta', 'Activa', 1, NULL),
('Sobrecupo de estación', 'La estación Centra Sur superó el 50% de su capacidad esperada.', 'Alta', 'Activa', (SELECT id_estacion FROM estaciones WHERE nombre_estacion='Centra Sur' LIMIT 1), NULL);

-- Reglas de seguridad para mantener roles fijos y evitar pilotos duplicados en buses
ALTER TABLE buses ADD UNIQUE KEY uq_buses_piloto_unico (id_piloto);

DELIMITER $$
CREATE TRIGGER trg_roles_no_insert
BEFORE INSERT ON roles
FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite crear roles nuevos. Los roles ya estan definidos.';
END$$

CREATE TRIGGER trg_roles_no_delete
BEFORE DELETE ON roles
FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite eliminar roles. Solo editar descripcion.';
END$$

CREATE TRIGGER trg_roles_no_update_nombre
BEFORE UPDATE ON roles
FOR EACH ROW
BEGIN
  IF NEW.nombre_rol <> OLD.nombre_rol THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite cambiar el nombre del rol. Solo editar descripcion.';
  END IF;
END$$
DELIMITER ;
