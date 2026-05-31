-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 31-05-2026 a las 02:23:02
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `transmetro_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alertas`
--

CREATE TABLE `alertas` (
  `id_alerta` int(11) NOT NULL,
  `tipo_alerta` varchar(80) NOT NULL,
  `descripcion` text NOT NULL,
  `prioridad` enum('Baja','Media','Alta','Crítica') DEFAULT 'Media',
  `estado` varchar(30) DEFAULT 'Activa',
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `id_estacion` int(11) DEFAULT NULL,
  `id_bus` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `alertas`
--

INSERT INTO `alertas` (`id_alerta`, `tipo_alerta`, `descripcion`, `prioridad`, `estado`, `fecha`, `id_estacion`, `id_bus`) VALUES
(1, 'Sobrecupo de estación', 'La estación Mercado Central superó el 50% de su capacidad esperada.', 'Alta', 'Activa', '2026-05-27 22:39:27', 1, NULL),
(2, 'Sobrecupo de estación', 'La estación Centra Sur superó el 50% de su capacidad esperada.', 'Alta', 'Activa', '2026-05-27 22:39:27', 85, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `buses`
--

CREATE TABLE `buses` (
  `id_bus` int(11) NOT NULL,
  `placa` varchar(30) NOT NULL,
  `modelo` varchar(80) NOT NULL,
  `tipo_bus` varchar(80) NOT NULL DEFAULT 'Articulado',
  `capacidad_maxima` int(11) NOT NULL,
  `estado` varchar(30) DEFAULT 'Disponible',
  `id_linea` int(11) DEFAULT NULL,
  `id_parqueo` int(11) NOT NULL,
  `id_piloto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `buses`
--

INSERT INTO `buses` (`id_bus`, `placa`, `modelo`, `tipo_bus`, `capacidad_maxima`, `estado`, `id_linea`, `id_parqueo`, `id_piloto`) VALUES
(1, 'TM-0101', 'Busscar Urbanuss Pluss / Volvo B12M', 'Articulado', 160, 'Disponible', 1, 2, 1),
(2, 'TM-0102', 'Marcopolo Viale BRT / Volvo B340M', 'Articulado', 160, 'Disponible', 1, 2, 2),
(3, 'TM-0103', 'Marcopolo Viale BRT / Scania K310IA', 'Articulado', 160, 'Disponible', 1, 2, 3),
(4, 'TM-0201', 'Busscar Urbanuss Pluss / Scania K270', 'No articulado', 119, 'Disponible', 2, 3, 4),
(5, 'TM-0202', 'Busscar Urbanuss Pluss / Scania K270', 'No articulado', 119, 'Disponible', 2, 3, 5),
(6, 'TM-0203', 'Bus convencional Transmetro', 'Convencional', 80, 'Disponible', 2, 3, 6),
(7, 'TM-0501', 'FOTON BJ6123EVCA eléctrico', 'Eléctrico', 80, 'Disponible', 3, 1, 7),
(8, 'TM-0502', 'FOTON BJ6123EVCA eléctrico', 'Eléctrico', 80, 'Disponible', 3, 1, 8),
(9, 'TM-0503', 'BYD eléctrico 12 metros', 'Eléctrico', 81, 'Disponible', 3, 1, 9),
(10, 'TM-0601', 'Bus convencional Transmetro', 'Convencional', 80, 'Disponible', 4, 2, 10),
(11, 'TM-0602', 'Busscar Urbanuss Pluss / Scania K270', 'No articulado', 119, 'Disponible', 4, 2, 11),
(12, 'TM-0603', 'Marcopolo Viale BRT', 'Articulado', 160, 'Disponible', 4, 2, 12),
(13, 'TM-0701', 'Marcopolo Viale BRT', 'Articulado', 160, 'Disponible', 5, 3, NULL),
(14, 'TM-0702', 'Bus convencional Transmetro', 'Convencional', 80, 'Disponible', 5, 3, NULL),
(15, 'TM-0703', 'Unidad biarticulada Transmetro', 'Biarticulado', 250, 'Disponible', 5, 3, NULL),
(16, 'TM-1201', 'Marcopolo Viale BRT', 'Articulado', 160, 'Disponible', 6, 1, NULL),
(17, 'TM-1202', 'Unidad biarticulada Transmetro', 'Biarticulado', 250, 'Disponible', 6, 1, NULL),
(18, 'TM-1203', 'Bus convencional Transmetro', 'Convencional', 80, 'Disponible', 6, 1, NULL),
(19, 'TM-1301', 'Busscar Urbanuss Pluss / Scania K270', 'No articulado', 119, 'Disponible', 7, 2, NULL),
(20, 'TM-1302', 'Bus convencional Transmetro', 'Convencional', 80, 'Disponible', 7, 2, NULL),
(21, 'TM-1303', 'Marcopolo Viale BRT', 'Articulado', 160, 'Disponible', 7, 2, NULL),
(22, 'TM-1801', 'Marcopolo Viale BRT', 'Articulado', 160, 'Disponible', 8, 3, NULL),
(23, 'TM-1802', 'Bus convencional Transmetro', 'Convencional', 80, 'Disponible', 8, 3, NULL),
(24, 'TM-1803', 'Unidad biarticulada Transmetro', 'Biarticulado', 250, 'Disponible', 8, 3, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estaciones`
--

CREATE TABLE `estaciones` (
  `id_estacion` int(11) NOT NULL,
  `nombre_estacion` varchar(120) NOT NULL,
  `ubicacion` varchar(180) NOT NULL,
  `capacidad_esperada` int(11) NOT NULL DEFAULT 100,
  `usuarios_actuales` int(11) NOT NULL DEFAULT 0,
  `estado` varchar(30) DEFAULT 'Activa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `estaciones`
--

INSERT INTO `estaciones` (`id_estacion`, `nombre_estacion`, `ubicacion`, `capacidad_esperada`, `usuarios_actuales`, `estado`) VALUES
(1, 'Mercado Central', '8ª avenida y 6ª calle, zona 1', 100, 185, 'Activa'),
(2, 'Correos', '8ª avenida y 12 calle, zona 1', 100, 86, 'Activa'),
(3, 'Beatas de Belén', '8ª avenida y 15 calle, zona 1', 100, 94, 'Activa'),
(4, 'Paseo de las Letras', '8ª avenida y 19 calle, zona 1', 100, 102, 'Activa'),
(5, 'Centro Cívico', '21 calle y 6ª avenida A, zona 1', 120, 110, 'Activa'),
(6, 'Sur 2', '5ª avenida y 18 calle, zona 1', 100, 70, 'Activa'),
(7, 'Gómez Carrillo', '5ª avenida y 14 calle, zona 1', 100, 78, 'Activa'),
(8, 'San Agustín', '5ª avenida y 11 calle, zona 1', 100, 86, 'Activa'),
(9, 'Parque Centenario', '5ª avenida y 8ª calle, zona 1', 100, 94, 'Activa'),
(10, 'San José de la Montaña', 'Avenida Simeón Cañas y 6ª calle, zona 2', 120, 102, 'Activa'),
(11, 'Hipódromo del Norte', 'Avenida Simeón Cañas y 11 calle, zona 2', 100, 110, 'Activa'),
(12, 'Simeón Cañas', 'Avenida Simeón Cañas y 7ª calle, zona 2', 100, 70, 'Activa'),
(13, 'Jocotenango', '6ª avenida entre 3ª y 4ª calle, zona 2', 100, 78, 'Activa'),
(14, 'Parque Colón', '12 avenida 9ª calle, zona 1', 100, 86, 'Activa'),
(15, 'Cipreses - Parque Colón', 'Bulevar La Asunción y Arco 3, zona 5', 120, 94, 'Activa'),
(16, 'Cipreses - Puente de la Penitenciaría', 'Bulevar La Asunción y 11 calle, zona 5', 100, 102, 'Activa'),
(17, 'Jardines de la Asunción - Parque Colón', 'Bulevar La Asunción y Arco 5-6, zona 5', 100, 110, 'Activa'),
(18, 'Jardines de la Asunción - Puente de la Penitenciaría', 'Bulevar La Asunción y 12 calle B, zona 5', 100, 70, 'Activa'),
(19, 'Arrivillaga', 'Bulevar La Asunción y 20 calle, zona 5', 100, 78, 'Activa'),
(20, 'Parque Navidad', '23 calle y 28 avenida, zona 5', 120, 86, 'Activa'),
(21, 'La Palmita', '27 calle y 20 avenida, zona 5', 100, 94, 'Activa'),
(22, 'Palacio de los Deportes - Parque Colón', '10 avenida y 24 calle, zona 5', 100, 102, 'Activa'),
(23, 'Palacio de los Deportes - Puente de la Penitenciaría', '24 calle y 9ª avenida, zona 5', 100, 110, 'Activa'),
(24, 'Puente de la Penitenciaría', 'Vía 1 y 7ª avenida, zona 4', 100, 70, 'Activa'),
(25, 'Mercado La Palmita', '26 calle y 17 avenida A, zona 5', 120, 78, 'Activa'),
(26, 'Vivibien', 'Diagonal 14 y 23 calle, zona 5', 100, 86, 'Activa'),
(27, 'Matamoros', '7ª calle y 16 avenida, zona 1', 100, 94, 'Activa'),
(28, 'Parroquia', '15 avenida y 3ª calle, zona 6', 100, 102, 'Activa'),
(29, 'IGSS Zona 6', '16 avenida y 6ª calle, zona 6', 100, 110, 'Activa'),
(30, 'Centro Zona 6', '16 avenida y 10ª calle, zona 6', 120, 70, 'Activa'),
(31, 'Academia', '16 avenida y 15 calle, zona 6', 100, 78, 'Activa'),
(32, 'Cipresales', 'Avenida La Pedrera y 18 calle, zona 6', 100, 86, 'Activa'),
(33, 'Proyectos 4-4', 'Avenida La Pedrera y 20 calle, zona 6', 100, 94, 'Activa'),
(34, 'Proyectos', 'Avenida La Pedrera y 25 calle, zona 6', 100, 102, 'Activa'),
(35, 'Quintanal', '15 avenida y 13 calle, zona 6', 120, 110, 'Activa'),
(36, 'Corpus Christi', '15 avenida y 10ª calle, zona 6', 100, 70, 'Activa'),
(37, 'José Martí', '14 avenida y 7ª calle, zona 6', 100, 78, 'Activa'),
(38, 'Santa Teresa', '10ª avenida y 4ª calle, zona 1', 100, 86, 'Activa'),
(39, 'USAC Periférico', 'Anillo Periférico y 11 avenida, zona 12', 100, 94, 'Activa'),
(40, 'Granai - La Merced', 'Anillo Periférico y 12 avenida, zona 11', 120, 102, 'Activa'),
(41, 'Granai - USAC Periférico', 'Anillo Periférico y 9ª avenida A, zona 11', 100, 110, 'Activa'),
(42, 'Rodolfo Robles - La Merced', 'Anillo Periférico 20 calle, zona 11', 100, 70, 'Activa'),
(43, 'Rodolfo Robles - USAC Periférico', 'Anillo Periférico Diagonal 21 y calle Mariscal, zona 11', 100, 78, 'Activa'),
(44, 'CEJUSA - La Merced', 'Anillo Periférico y 18 calle, zona 11', 100, 86, 'Activa'),
(45, 'CEJUSA - USAC Periférico', 'Anillo Periférico y 17 calle, zona 11', 120, 94, 'Activa'),
(46, 'San Jorge - La Merced', 'Anillo Periférico y 21 avenida, zona 11', 100, 102, 'Activa'),
(47, 'San Jorge - USAC Periférico', 'Anillo Periférico y 22 avenida, zona 11', 100, 110, 'Activa'),
(48, 'Roosevelt - La Merced', 'Anillo Periférico y Calzada Roosevelt, zona 11', 100, 70, 'Activa'),
(49, 'Roosevelt - USAC Periférico', 'Anillo Periférico y Calzada Roosevelt, zona 11', 100, 78, 'Activa'),
(50, 'San Juan - La Merced', 'Anillo Periférico entre 4ª y 6ª calles, zona 7', 120, 86, 'Activa'),
(51, 'San Juan - USAC Periférico', 'Anillo Periférico y 6ª calle, zona 7', 100, 94, 'Activa'),
(52, 'Ciudad de Plata II - La Merced', 'Anillo Periférico y 14 calle, zona 7', 100, 102, 'Activa'),
(53, 'Ciudad de Plata II - USAC Periférico', 'Anillo Periférico y 13 calle B, zona 7', 100, 110, 'Activa'),
(54, 'Villa Linda - La Merced', 'Anillo Periférico y 16 calle, zona 7', 100, 70, 'Activa'),
(55, 'Villa Linda - USAC Periférico', 'Anillo Periférico y 16 calle, zona 7', 120, 78, 'Activa'),
(56, '4 de Febrero (Dirección: La Merced)', 'Anillo Periférico y 6ª calle, zona 7', 100, 86, 'Activa'),
(57, '4 de Febrero (Dirección: USAC Periférico)', 'Anillo Periférico y 22 calle, zona 7', 100, 94, 'Activa'),
(58, 'Bethania - La Merced', 'Anillo Periférico y 25 calle, zona 7', 100, 102, 'Activa'),
(59, 'Bethania - USAC Periférico', 'Anillo Periférico y 13 avenida, zona 7', 100, 110, 'Activa'),
(60, 'Incenso - La Merced', 'Anillo Periférico y Puente El Incenso, zona 7', 120, 70, 'Activa'),
(61, 'Incenso - USAC Periférico', 'Anillo Periférico y Puente El Incenso, zona 7', 100, 78, 'Activa'),
(62, 'San Juan de Dios', '9ª calle y 2ª avenida, zona 1', 100, 86, 'Activa'),
(63, 'Pasares', '9ª calle y 7ª avenida, zona 1', 100, 94, 'Activa'),
(64, 'La Merced', '11 avenida y 4ª calle, zona 1', 100, 102, 'Activa'),
(65, 'Cruz Roja', '4ª calle y 8ª avenida, zona 1', 120, 110, 'Activa'),
(66, 'Archivo General', '4ª avenida y 7ª calle, zona 1', 100, 70, 'Activa'),
(67, 'Santuario de Guadalupe', '8ª calle y 1ª avenida, zona 1', 100, 78, 'Activa'),
(68, 'Plaza Municipal', '6ª avenida y 21 calle, zona 1', 100, 86, 'Activa'),
(69, 'Plaza Barrios', '9ª avenida y 18 calle, zona 1', 100, 94, 'Activa'),
(70, 'Plaza El Amate', '18 calle y 4ª avenida, zona 1', 120, 102, 'Activa'),
(71, 'Don Bosco', '1ª avenida y 26 calle, zona 1', 100, 110, 'Activa'),
(72, 'Bolívar - Plaza Barrios', 'Avenida Bolívar y 32 calle, zona 8', 100, 70, 'Activa'),
(73, 'Bolívar - Centra Sur', 'Avenida Bolívar y 31 calle, zona 3', 100, 78, 'Activa'),
(74, 'Santa Cecilia', 'Avenida Bolívar y 40 calle, zona 8', 100, 86, 'Activa'),
(75, 'Trébol', 'Calzada Aguilar Batres y avenida Bolívar, zona 12', 120, 94, 'Activa'),
(76, 'Mariscal - Centra Sur', 'Calzada Aguilar Batres y 13 calle, zona 12', 100, 102, 'Activa'),
(77, 'Mariscal - Plaza Barrios', 'Calzada Aguilar Batres y 15 calle, zona 12', 100, 110, 'Activa'),
(78, 'Reformita - Centra Sur', 'Calzada Aguilar Batres y 20 calle, zona 12', 100, 70, 'Activa'),
(79, 'Reformita - Plaza Barrios', 'Calzada Aguilar Batres y 21 calle, zona 12', 100, 78, 'Activa'),
(80, 'El Carmen', 'Calzada Aguilar Batres y 29 calle, zona 12', 120, 86, 'Activa'),
(81, 'Las Charcas - Centra Sur', 'Calzada Aguilar Batres y 32 calle, zona 12', 100, 94, 'Activa'),
(82, 'Las Charcas - Plaza Barrios', 'Calzada Aguilar Batres y 34 calle, zona 12', 100, 102, 'Activa'),
(83, 'Javier', 'Calzada Aguilar Batres y 38 calle, zona 12 Villa Nueva', 100, 110, 'Activa'),
(84, 'Monte María', 'Calzada Aguilar Batres y 46 calle, zona 12 Villa Nueva', 100, 70, 'Activa'),
(85, 'Centra Sur', '21 avenida final, zona 12 Villa Nueva', 120, 185, 'Activa'),
(86, 'El Calvario', '6ª avenida y 20 calle, zona 1', 100, 86, 'Activa'),
(87, '4 Grados Sur', '6ª avenida y 24 calle, zona 4', 100, 94, 'Activa'),
(88, 'Exposición', '6ª avenida y Ruta 6, zona 4', 100, 102, 'Activa'),
(89, 'Terminal', '6ª avenida y 2ª calle, zona 9', 100, 110, 'Activa'),
(90, 'Industria', '6ª avenida y 6ª calle, zona 9', 120, 70, 'Activa'),
(91, 'Tívoli', '6ª avenida y 10ª calle, zona 9', 100, 78, 'Activa'),
(92, 'Montúfar', '6ª avenida y 13 calle, zona 9', 100, 86, 'Activa'),
(93, 'Acueducto', 'Avenida Hincapié y 4ª calle, zona 13', 100, 94, 'Activa'),
(94, 'Fuerza Aérea', 'Avenida Hincapié y 11 calle, zona 13', 100, 102, 'Activa'),
(95, 'Hangares', '15 avenida y 18 calle, zona 13', 120, 110, 'Activa'),
(96, 'Plaza Argentina', '15 avenida y 11 calle, zona 13', 100, 70, 'Activa'),
(97, 'Los Arcos', '15 avenida y 4ª calle, zona 13', 100, 78, 'Activa'),
(98, 'Plaza España', '7ª avenida y 13 calle, zona 9', 100, 86, 'Activa'),
(99, 'IGSS Zona 9', '7ª avenida y 10ª calle, zona 9', 100, 94, 'Activa'),
(100, 'Seis 26', '7ª avenida y 5ª calle, zona 9', 120, 102, 'Activa'),
(101, 'Torre del Reformador', '7ª avenida y 1ª calle, zona 9', 100, 110, 'Activa'),
(102, 'Plaza de la República', '7ª avenida y ruta 4, zona 4', 100, 70, 'Activa'),
(103, 'Cantón Exposición', '7ª avenida Ruta 2 y Vía 3, zona 4', 100, 78, 'Activa'),
(104, 'Banco de Guatemala', '7ª avenida y 22 calle, zona 1', 100, 86, 'Activa'),
(105, 'Tipografía', '18 calle y 7ª avenida, zona 1', 120, 94, 'Activa'),
(106, 'Plaza Berlín', 'Plaza Berlín y Avenida Las Américas, zona 13', 100, 102, 'Activa'),
(107, 'Juan Pablo II', 'Avenida Las Américas y 21 calle, zona 14', 100, 110, 'Activa'),
(108, 'San Martín - Plaza Barrios/FEGUA', '20 avenida y 1ª calle, zona 1', 100, 70, 'Activa'),
(109, 'San Martín - Atlántida', '1ª calle y 18 avenida, zona 1', 100, 78, 'Activa'),
(110, 'Victorias', 'Avenida Las Victorias y 3ª calle, zona 6', 120, 86, 'Activa'),
(111, 'Portales', 'KM 4.5 Carretera al Atlántico 3-20 Ciudad de Guatemala', 100, 94, 'Activa'),
(112, 'San Rafael', '12 calle y 4ª avenida Colonia San Rafael, zona 18', 100, 102, 'Activa'),
(113, 'Paraíso', '12 calle y 25 avenida, zona 18', 100, 110, 'Activa');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lineas`
--

CREATE TABLE `lineas` (
  `id_linea` int(11) NOT NULL,
  `nombre_linea` varchar(80) NOT NULL,
  `ruta` varchar(180) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `lineas`
--

INSERT INTO `lineas` (`id_linea`, `nombre_linea`, `ruta`, `descripcion`) VALUES
(1, 'Línea 1', 'San Sebastián Z.1 / Centro Cívico Z.1', 'Ruta zona 1 hacia Centro Cívico'),
(2, 'Línea 2', 'Hipódromo del Norte Z.2 / San Sebastián Z.1', 'Ruta zona 2 hacia San Sebastián'),
(3, 'Ruta 5 TuBus', 'Parque Colón Z.1 / Puente de la Penitenciaría Z.4', 'Ruta operada por TuBus'),
(4, 'Línea 6', 'Proyectos Z.6 / FEGUA Z.1', 'Ruta zona 6 hacia FEGUA'),
(5, 'Línea 7', 'USAC Periférico Z.12 / La Merced Z.1', 'Ruta por Anillo Periférico'),
(6, 'Línea 12', 'Centra Sur / Plaza Barrios Z.1', 'Ruta Aguilar Batres hacia zona 1'),
(7, 'Línea 13', 'Plaza Argentina Z.13 / Tipografía Z.1', 'Ruta zona 13 hacia Centro Histórico'),
(8, 'Línea 18', 'Atlántida Z.18 / FEGUA Z.1', 'Ruta zona 18 hacia FEGUA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lineas_estaciones`
--

CREATE TABLE `lineas_estaciones` (
  `id_linea` int(11) NOT NULL,
  `id_estacion` int(11) NOT NULL,
  `orden` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `lineas_estaciones`
--

INSERT INTO `lineas_estaciones` (`id_linea`, `id_estacion`, `orden`) VALUES
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parqueos`
--

CREATE TABLE `parqueos` (
  `id_parqueo` int(11) NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `ubicacion` varchar(150) NOT NULL,
  `capacidad` int(11) NOT NULL DEFAULT 0,
  `estado` varchar(30) DEFAULT 'Disponible'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `parqueos`
--

INSERT INTO `parqueos` (`id_parqueo`, `nombre`, `ubicacion`, `capacidad`, `estado`) VALUES
(1, 'Parqueo Central', 'Zona 1', 40, 'Disponible'),
(2, 'Parqueo Norte', 'Zona 18', 30, 'Disponible'),
(3, 'Parqueo Sur', 'Centra Sur / Villa Nueva', 35, 'Disponible'),
(4, 'Parqueo Zona 13', 'Plaza Argentina, zona 13', 25, 'Disponible');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pilotos`
--

CREATE TABLE `pilotos` (
  `id_piloto` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `licencia` varchar(50) NOT NULL,
  `telefono` varchar(25) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `estado` varchar(30) DEFAULT 'Activo',
  `id_linea` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `pilotos`
--

INSERT INTO `pilotos` (`id_piloto`, `nombre`, `licencia`, `telefono`, `direccion`, `estado`, `id_linea`) VALUES
(1, 'Piloto 01', 'LIC-TM-001', '5555-1001', 'Guatemala', 'Activo', 1),
(2, 'Piloto 02', 'LIC-TM-002', '5555-1002', 'Guatemala', 'Activo', 1),
(3, 'Piloto 03', 'LIC-TM-003', '5555-1003', 'Guatemala', 'Activo', 1),
(4, 'Piloto 04', 'LIC-TM-004', '5555-1004', 'Guatemala', 'Activo', 2),
(5, 'Piloto 05', 'LIC-TM-005', '5555-1005', 'Guatemala', 'Activo', 2),
(6, 'Piloto 06', 'LIC-TM-006', '5555-1006', 'Guatemala', 'Activo', 2),
(7, 'Piloto 07', 'LIC-TM-007', '5555-1007', 'Guatemala', 'Activo', 3),
(8, 'Piloto 08', 'LIC-TM-008', '5555-1008', 'Guatemala', 'Activo', 4),
(9, 'Piloto 09', 'LIC-TM-009', '5555-1009', 'Guatemala', 'Activo', 5),
(10, 'Piloto 10', 'LIC-TM-010', '5555-1010', 'Guatemala', 'Activo', 6),
(11, 'Piloto 11', 'LIC-TM-011', '5555-1011', 'Guatemala', 'Activo', 7),
(12, 'Piloto 12', 'LIC-TM-012', '5555-1012', 'Guatemala', 'Activo', 8);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL,
  `nombre_rol` varchar(50) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre_rol`, `descripcion`) VALUES
(1, 'Administrador', 'Acceso completo al sistema'),
(2, 'Operador', 'Gestiona buses, pilotos, parqueos, estaciones y líneas'),
(3, 'Jefe de monitoreo', 'Puede editar alertas y consultar reportes; no crea alertas'),
(4, 'Piloto', 'Puede ingresar alertas y consultarlas; no puede editarlas');

--
-- Disparadores `roles`
--
DELIMITER $$
CREATE TRIGGER `trg_roles_no_delete` BEFORE DELETE ON `roles` FOR EACH ROW BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite eliminar roles. Solo editar descripcion.';
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_roles_no_insert` BEFORE INSERT ON `roles` FOR EACH ROW BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite crear roles nuevos. Los roles ya estan definidos.';
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_roles_no_update_nombre` BEFORE UPDATE ON `roles` FOR EACH ROW BEGIN
  IF NEW.nombre_rol <> OLD.nombre_rol THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite cambiar el nombre del rol. Solo editar descripcion.';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `estado` enum('Activo','Inactivo') DEFAULT 'Activo',
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `correo`, `contrasena`, `id_rol`, `estado`, `fecha_creacion`) VALUES
(1, 'Administrador General', 'admin@transmetro.com', '$2y$12$xPHdHYcn2I01255mtdjVNetwayJ9PDrtBJ8npxzGmQjWfkFm.e5A6', 1, 'Activo', '2026-05-27 22:39:27'),
(2, 'Operador Estación', 'operador@transmetro.com', '$2y$12$xPHdHYcn2I01255mtdjVNetwayJ9PDrtBJ8npxzGmQjWfkFm.e5A6', 2, 'Activo', '2026-05-27 22:39:27'),
(3, 'Jefe de Monitoreo', 'monitoreo@transmetro.com', '$2y$12$xPHdHYcn2I01255mtdjVNetwayJ9PDrtBJ8npxzGmQjWfkFm.e5A6', 3, 'Activo', '2026-05-27 22:39:27'),
(4, 'Piloto Transmetro', 'piloto@transmetro.com', '$2y$12$xPHdHYcn2I01255mtdjVNetwayJ9PDrtBJ8npxzGmQjWfkFm.e5A6', 4, 'Activo', '2026-05-27 22:39:27');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `alertas`
--
ALTER TABLE `alertas`
  ADD PRIMARY KEY (`id_alerta`),
  ADD KEY `id_estacion` (`id_estacion`),
  ADD KEY `id_bus` (`id_bus`);

--
-- Indices de la tabla `buses`
--
ALTER TABLE `buses`
  ADD PRIMARY KEY (`id_bus`),
  ADD UNIQUE KEY `placa` (`placa`),
  ADD UNIQUE KEY `uq_buses_piloto_unico` (`id_piloto`),
  ADD KEY `id_linea` (`id_linea`),
  ADD KEY `id_parqueo` (`id_parqueo`);

--
-- Indices de la tabla `estaciones`
--
ALTER TABLE `estaciones`
  ADD PRIMARY KEY (`id_estacion`);

--
-- Indices de la tabla `lineas`
--
ALTER TABLE `lineas`
  ADD PRIMARY KEY (`id_linea`),
  ADD UNIQUE KEY `nombre_linea` (`nombre_linea`);

--
-- Indices de la tabla `lineas_estaciones`
--
ALTER TABLE `lineas_estaciones`
  ADD PRIMARY KEY (`id_linea`,`id_estacion`),
  ADD KEY `id_estacion` (`id_estacion`);

--
-- Indices de la tabla `parqueos`
--
ALTER TABLE `parqueos`
  ADD PRIMARY KEY (`id_parqueo`);

--
-- Indices de la tabla `pilotos`
--
ALTER TABLE `pilotos`
  ADD PRIMARY KEY (`id_piloto`),
  ADD UNIQUE KEY `licencia` (`licencia`),
  ADD KEY `id_linea` (`id_linea`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`),
  ADD UNIQUE KEY `nombre_rol` (`nombre_rol`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `id_rol` (`id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `alertas`
--
ALTER TABLE `alertas`
  MODIFY `id_alerta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `buses`
--
ALTER TABLE `buses`
  MODIFY `id_bus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `estaciones`
--
ALTER TABLE `estaciones`
  MODIFY `id_estacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT de la tabla `lineas`
--
ALTER TABLE `lineas`
  MODIFY `id_linea` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `parqueos`
--
ALTER TABLE `parqueos`
  MODIFY `id_parqueo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `pilotos`
--
ALTER TABLE `pilotos`
  MODIFY `id_piloto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `alertas`
--
ALTER TABLE `alertas`
  ADD CONSTRAINT `alertas_ibfk_1` FOREIGN KEY (`id_estacion`) REFERENCES `estaciones` (`id_estacion`) ON DELETE SET NULL,
  ADD CONSTRAINT `alertas_ibfk_2` FOREIGN KEY (`id_bus`) REFERENCES `buses` (`id_bus`) ON DELETE SET NULL;

--
-- Filtros para la tabla `buses`
--
ALTER TABLE `buses`
  ADD CONSTRAINT `buses_ibfk_1` FOREIGN KEY (`id_linea`) REFERENCES `lineas` (`id_linea`),
  ADD CONSTRAINT `buses_ibfk_2` FOREIGN KEY (`id_parqueo`) REFERENCES `parqueos` (`id_parqueo`),
  ADD CONSTRAINT `buses_ibfk_3` FOREIGN KEY (`id_piloto`) REFERENCES `pilotos` (`id_piloto`);

--
-- Filtros para la tabla `lineas_estaciones`
--
ALTER TABLE `lineas_estaciones`
  ADD CONSTRAINT `lineas_estaciones_ibfk_1` FOREIGN KEY (`id_linea`) REFERENCES `lineas` (`id_linea`) ON DELETE CASCADE,
  ADD CONSTRAINT `lineas_estaciones_ibfk_2` FOREIGN KEY (`id_estacion`) REFERENCES `estaciones` (`id_estacion`) ON DELETE CASCADE;

--
-- Filtros para la tabla `pilotos`
--
ALTER TABLE `pilotos`
  ADD CONSTRAINT `pilotos_ibfk_1` FOREIGN KEY (`id_linea`) REFERENCES `lineas` (`id_linea`) ON DELETE SET NULL;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
