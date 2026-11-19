-- ====================================================================
-- SISTEMA DE PENSUM DIGITAL UCYT - BASE DE DATOS MYSQL
-- Carrera: Informática y Computación (Pensum 2026-2030 - Por Encuentro)
-- Total de Asignaturas: 57 distribuidas en 15 Cuatrimestres (5 Años)
-- ====================================================================

CREATE DATABASE IF NOT EXISTS `pensum_ucyt` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `pensum_ucyt`;

-- 1. Tabla de Roles
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id_rol` INT AUTO_INCREMENT PRIMARY KEY,
  `nombre_rol` VARCHAR(50) NOT NULL UNIQUE,
  `descripcion` VARCHAR(255) NULL
) ENGINE=InnoDB;

INSERT INTO `roles` (`id_rol`, `nombre_rol`, `descripcion`) VALUES
(1, 'Estudiante', 'Consulta de pensum, prerrequisitos, notas y avance curricular'),
(2, 'Docente', 'Gestión de asignaturas, asentamiento de notas y seguimiento académico'),
(3, 'Administrador', 'Control total de usuarios, planes de estudio y matrículas');

-- 2. Tabla de Usuarios
DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE `usuarios` (
  `id_usuario` INT AUTO_INCREMENT PRIMARY KEY,
  `id_rol` INT NOT NULL,
  `username` VARCHAR(60) NOT NULL UNIQUE,
  `password_hash` VARCHAR(255) NOT NULL,
  `email` VARCHAR(120) UNIQUE,
  `estado` ENUM('activo', 'inactivo') DEFAULT 'activo',
  `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`id_rol`) REFERENCES `roles`(`id_rol`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. Tabla de Carreras
DROP TABLE IF EXISTS `carreras`;
CREATE TABLE `carreras` (
  `id_carrera` INT AUTO_INCREMENT PRIMARY KEY,
  `codigo_carrera` VARCHAR(20) NOT NULL UNIQUE,
  `nombre_carrera` VARCHAR(150) NOT NULL,
  `modalidad` VARCHAR(50) DEFAULT 'Por Encuentro',
  `total_cuatrimestres` INT DEFAULT 15,
  `total_creditos` INT DEFAULT 176
) ENGINE=InnoDB;

INSERT INTO `carreras` (`id_carrera`, `codigo_carrera`, `nombre_carrera`, `modalidad`, `total_cuatrimestres`, `total_creditos`) VALUES
(1, 'INF-COMP', 'Informática y Computación', 'Por Encuentro', 15, 176);

-- 4. Tabla de Planes de Estudio / Pensum
DROP TABLE IF EXISTS `planes_estudio`;
CREATE TABLE `planes_estudio` (
  `id_plan` INT AUTO_INCREMENT PRIMARY KEY,
  `id_carrera` INT NOT NULL,
  `codigo_plan` VARCHAR(50) NOT NULL,
  `vigencia_inicio` INT NOT NULL,
  `vigencia_fin` INT NOT NULL,
  FOREIGN KEY (`id_carrera`) REFERENCES `carreras`(`id_carrera`)
) ENGINE=InnoDB;

INSERT INTO `planes_estudio` (`id_plan`, `id_carrera`, `codigo_plan`, `vigencia_inicio`, `vigencia_fin`) VALUES
(1, 1, 'PENSUM-2026-2030', 2026, 2030);

-- 5. Tabla de Estudiantes
DROP TABLE IF EXISTS `estudiantes`;
CREATE TABLE `estudiantes` (
  `id_estudiante` INT AUTO_INCREMENT PRIMARY KEY,
  `id_usuario` INT NOT NULL UNIQUE,
  `id_plan` INT NOT NULL,
  `carnet` VARCHAR(30) NOT NULL UNIQUE,
  `nombres` VARCHAR(80) NOT NULL,
  `apellidos` VARCHAR(80) NOT NULL,
  `cohorte` VARCHAR(20) DEFAULT '2026 - 2030',
  `tipo_ingreso` ENUM('Nuevo Ingreso', 'Reingreso', 'Convalidación') DEFAULT 'Nuevo Ingreso',
  FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id_usuario`) ON DELETE CASCADE,
  FOREIGN KEY (`id_plan`) REFERENCES `planes_estudio`(`id_plan`)
) ENGINE=InnoDB;

-- 6. Tabla de Docentes
DROP TABLE IF EXISTS `docentes`;
CREATE TABLE `docentes` (
  `id_docente` INT AUTO_INCREMENT PRIMARY KEY,
  `id_usuario` INT NOT NULL UNIQUE,
  `codigo_docente` VARCHAR(30) NOT NULL UNIQUE,
  `nombres` VARCHAR(80) NOT NULL,
  `apellidos` VARCHAR(80) NOT NULL,
  `especialidad` VARCHAR(120),
  FOREIGN KEY (`id_usuario`) REFERENCES `usuarios`(`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 7. Tabla de Asignaturas (57 Asignaturas oficiales UCYT)
DROP TABLE IF EXISTS `asignaturas`;
CREATE TABLE `asignaturas` (
  `id_asignatura` INT AUTO_INCREMENT PRIMARY KEY,
  `id_plan` INT NOT NULL,
  `numero` INT NOT NULL,
  `codigo` VARCHAR(20) NOT NULL,
  `nombre` VARCHAR(150) NOT NULL,
  `area_formacion` ENUM('B', 'G', 'E') NOT NULL COMMENT 'B: Básica, G: General, E: Específica',
  `cuatrimestre` INT NOT NULL COMMENT '1 al 15',
  `anio` INT NOT NULL COMMENT '1 al 5',
  `creditos` INT NOT NULL DEFAULT 3,
  `prerrequisito_codigo` VARCHAR(50) DEFAULT 'NINGUNO',
  FOREIGN KEY (`id_plan`) REFERENCES `planes_estudio`(`id_plan`)
) ENGINE=InnoDB;

-- INSERCIÓN DE LAS 57 ASIGNATURAS OFICIALES UCYT
INSERT INTO `asignaturas` (`id_plan`, `numero`, `codigo`, `nombre`, `area_formacion`, `cuatrimestre`, `anio`, `creditos`, `prerrequisito_codigo`) VALUES
-- AÑO 1 - CUATRIMESTRE 1 (NUEVO INGRESO)
(1, 1, 'AN-1200', 'ADMINISTRACIÓN GENERAL', 'B', 1, 1, 3, 'NINGUNO'),
(1, 2, 'EG-1512', 'FILOSOFÍA', 'B', 1, 1, 3, 'NINGUNO'),
(1, 3, 'CU-2025', 'IDENTIDAD NACIONAL Y ORGULLO PATRIO', 'G', 1, 1, 4, 'NINGUNO'),
(1, 4, 'EG-1550', 'MATEMÁTICA BÁSICA', 'B', 1, 1, 3, 'NINGUNO'),
-- AÑO 1 - CUATRIMESTRE 2
(1, 5, 'EG-1561', 'CÁLCULO', 'B', 2, 1, 3, 'EG-1550'),
(1, 6, 'AN-1210', 'CONTABILIDAD I', 'B', 2, 1, 3, 'NINGUNO'),
(1, 7, 'EG-1520', 'INGLÉS I', 'B', 2, 1, 3, 'NINGUNO'),
(1, 8, 'EG-1540', 'INTRODUCCIÓN A LA COMPUTACIÓN', 'B', 2, 1, 3, 'NINGUNO'),
-- AÑO 1 - CUATRIMESTRE 3
(1, 9, 'IF-1600', 'COMPUTACIÓN', 'G', 3, 1, 3, 'EG-1540'),
(1, 10, 'AN-1220', 'ESTADÍSTICA', 'B', 3, 1, 3, 'NINGUNO'),
(1, 11, 'HIN-0101', 'HISTORIA E IDENTIDAD NACIONAL', 'G', 3, 1, 3, 'NINGUNO'),
(1, 12, 'EG-1521', 'INGLÉS II', 'B', 3, 1, 3, 'EG-1520'),

-- AÑO 2 - CUATRIMESTRE 4
(1, 13, 'EG-1600', 'FÍSICA I', 'G', 4, 2, 3, 'EG-1550'),
(1, 14, 'EG-1522', 'INGLÉS III', 'B', 4, 2, 3, 'EG-1521'),
(1, 15, 'AN-1250', 'MERCADOTECNIA BÁSICA', 'B', 4, 2, 3, 'AN-1220'),
(1, 16, 'IF-3100', 'SISTEMAS OPERATIVOS', 'G', 4, 2, 3, 'IF-1600'),
-- AÑO 2 - CUATRIMESTRE 5
(1, 17, 'IF-1300', 'ESTRUCTURA DE DATOS Y ALGORITMO I', 'B', 5, 2, 3, 'IF-1600'),
(1, 18, 'EG-1610', 'FÍSICA II', 'B', 5, 2, 3, 'EG-1600'),
(1, 19, 'AN-1240', 'INGENIERÍA ECONÓMICA', 'G', 5, 2, 3, 'EG-1550'),
(1, 20, 'EG-1523', 'INGLÉS IV', 'B', 5, 2, 3, 'EG-1522'),
-- AÑO 2 - CUATRIMESTRE 6
(1, 21, 'IF-1700', 'ESTRUCTURA DE DATOS Y ALGORITMOS II', 'B', 6, 2, 3, 'IF-1300'),
(1, 22, 'AN-1213', 'FINANZAS', 'G', 6, 2, 3, 'AN-1240'),
(1, 23, 'EG-1524', 'INGLÉS V', 'B', 6, 2, 3, 'EG-1523'),
(1, 24, 'ID-1600', 'METODOLOGÍA DE LA INVESTIGACIÓN I', 'G', 6, 2, 3, 'AN-1220'),

-- AÑO 3 - CUATRIMESTRE 7
(1, 25, 'AN-1202', 'ADMINISTRACIÓN DE RECURSOS HUMANOS', 'E', 7, 3, 3, 'AN-1200'),
(1, 26, 'EG-1650', 'CIRCUITOS ELÉCTRICOS', 'E', 7, 3, 3, 'EG-1610'),
(1, 27, 'AN-1280', 'FORMULACIÓN DE PROYECTOS', 'G', 7, 3, 3, 'ID-1600'),
(1, 28, 'EG-1525', 'INGLÉS VI', 'B', 7, 3, 3, 'EG-1524'),
-- AÑO 3 - CUATRIMESTRE 8
(1, 29, 'IF-3300', 'BASE DE DATOS I', 'E', 8, 3, 3, 'IF-1300'),
(1, 30, 'EG-1660', 'ELECTRÓNICA', 'E', 8, 3, 3, 'EG-1650'),
(1, 31, 'ID-1601', 'METODOLOGÍA DE LA INVESTIGACIÓN II', 'G', 8, 3, 3, 'ID-1600'),
(1, 32, 'IF-1100', 'PROGRAMACIÓN DE COMPUTADORAS I', 'E', 8, 3, 3, 'IF-1700'),
-- AÑO 3 - CUATRIMESTRE 9
(1, 33, 'IF-2290', 'ADMINISTRACIÓN DE CENTROS DE CÓMPUTOS', 'E', 9, 3, 3, 'AN-1202'),
(1, 34, 'IF-3600', 'BASES DE DATOS II', 'E', 9, 3, 3, 'IF-3300'),
(1, 35, 'IF-3310', 'DISEÑO GRÁFICO', 'E', 9, 3, 3, 'EG-1540'),
(1, 36, 'IF-2500', 'ORGANIZACIÓN Y ARQUITECTURA DE COMPUTADORAS', 'E', 9, 3, 3, 'EG-1660'),

-- AÑO 4 - CUATRIMESTRE 10
(1, 37, 'IF-1900', 'ANÁLISIS Y DISEÑO DE SISTEMAS I', 'E', 10, 4, 3, 'IF-3600'),
(1, 38, 'IF-3320', 'DISEÑO DE SITIOS WEB', 'E', 10, 4, 3, 'IF-3310'),
(1, 39, 'IF-2510', 'MANTENIMIENTO Y REPARACIÓN DE EQUIPOS', 'E', 10, 4, 3, 'IF-3100'),
(1, 40, 'IF-1400', 'PROGRAMACIÓN DE COMPUTADORAS II', 'E', 10, 4, 3, 'IF-1100'),
-- AÑO 4 - CUATRIMESTRE 11
(1, 41, 'IF-2100', 'ANÁLISIS Y DISEÑO DE SISTEMAS II', 'E', 11, 4, 3, 'IF-1900'),
(1, 42, 'IF-2600', 'COMUNICACIÓN DE DATOS', 'E', 11, 4, 3, 'EG-1610'),
(1, 43, 'IF-2000', 'INVESTIGACIÓN DE OPERACIONES', 'E', 11, 4, 3, 'AN-1240'),
(1, 44, 'IF-1450', 'PROGRAMACIÓN ORIENTADA A OBJETOS I', 'E', 11, 4, 3, 'IF-1400'),
-- AÑO 4 - CUATRIMESTRE 12
(1, 45, 'IF-2700', 'INGENIERÍA DE SOFTWARE', 'E', 12, 4, 3, 'IF-2100'),
(1, 46, 'IF-3321', 'PROGRAMACIÓN DE SITIOS WEB', 'E', 12, 4, 3, 'IF-3310'),
(1, 47, 'IF-1451', 'PROGRAMACIÓN ORIENTADA A OBJETOS II', 'E', 12, 4, 3, 'IF-1450'),
(1, 48, 'IF-3200', 'REDES I', 'E', 12, 4, 3, 'IF-2600'),

-- AÑO 5 - CUATRIMESTRE 13
(1, 49, 'IF-2900', 'AUDITORÍA DE SISTEMAS AUTOMATIZADOS', 'E', 13, 5, 3, 'IF-2290'),
(1, 50, 'AN-2260', 'ESTRATEGIA Y GESTIÓN EMPRESARIAL', 'G', 13, 5, 3, 'AN-1280'),
(1, 51, 'ID-2610', 'SERVICIO COMUNAL Y/O SOCIAL', 'E', 13, 5, 3, 'AUTORIZACIÓN'),
(1, 52, 'IF-3210', 'REDES II', 'E', 13, 5, 3, 'IF-3200'),
-- AÑO 5 - CUATRIMESTRE 14
(1, 53, 'IF-1452', 'INTELIGENCIA ARTIFICIAL', 'E', 14, 5, 3, 'IF-1100'),
(1, 54, 'ID-1610', 'PRÁCTICAS DE FAMILIARIZACIÓN Y PROFESIONALES', 'E', 14, 5, 7, 'AUTORIZACIÓN'),
(1, 55, 'IF-3000', 'SIMULACIÓN DE SISTEMAS', 'E', 14, 5, 3, 'IF-2700'),
(1, 56, 'ID-2620', 'TESIS', 'E', 14, 5, 3, 'AUTORIZACIÓN'),
-- AÑO 5 - CUATRIMESTRE 15
(1, 57, 'ID-2630', 'MODALIDAD DE GRADUACIÓN', 'E', 15, 5, 3, '14 CUATRIMESTRES APROBADOS');

-- 8. Tabla de Expediente y Carga Curricular por Estudiante
DROP TABLE IF EXISTS `expediente_asignaturas`;
CREATE TABLE `expediente_asignaturas` (
  `id_expediente` INT AUTO_INCREMENT PRIMARY KEY,
  `id_estudiante` INT NOT NULL,
  `id_asignatura` INT NOT NULL,
  `estado` ENUM('pendiente', 'cursando', 'aprobada', 'reprobada') DEFAULT 'pendiente',
  `nota` DECIMAL(5,2) NULL,
  `periodo_cursado` VARCHAR(30) NULL,
  `id_docente_calificador` INT NULL,
  `fecha_calificacion` DATETIME NULL,
  UNIQUE KEY `uk_estudiante_materia` (`id_estudiante`, `id_asignatura`),
  FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes`(`id_estudiante`) ON DELETE CASCADE,
  FOREIGN KEY (`id_asignatura`) REFERENCES `asignaturas`(`id_asignatura`),
  FOREIGN KEY (`id_docente_calificador`) REFERENCES `docentes`(`id_docente`)
) ENGINE=InnoDB;

-- ====================================================================
-- DATOS DE PRUEBA (USUARIOS, DOCENTE Y ESTUDIANTES DE NUEVO INGRESO)
-- ====================================================================

-- 1. Usuarios del Sistema
INSERT INTO `usuarios` (`id_usuario`, `id_rol`, `username`, `password_hash`, `email`) VALUES
(1, 1, '2026-INF-001', SHA2('estudiante123', 256), 'carlos.mendoza@ucyt.edu.ni'),
(2, 1, '2026-INF-002', SHA2('estudiante123', 256), 'maria.morales@ucyt.edu.ni'),
(3, 1, '2026-INF-003', SHA2('estudiante123', 256), 'kevin.lopez@ucyt.edu.ni'),
(4, 2, 'coordinacion.informatica', SHA2('ucyt2026', 256), 'docente.sistemas@ucyt.edu.ni');

-- 2. Perfil Docente
INSERT INTO `docentes` (`id_docente`, `id_usuario`, `codigo_docente`, `nombres`, `apellidos`, `especialidad`) VALUES
(1, 4, 'DOC-UCYT-101', 'Ronald', 'Pravia', 'Coordinación Académica e Ingeniería en Sistemas');

-- 3. Perfiles de Estudiantes de Nuevo Ingreso
INSERT INTO `estudiantes` (`id_estudiante`, `id_usuario`, `id_plan`, `carnet`, `nombres`, `apellidos`, `cohorte`, `tipo_ingreso`) VALUES
(1, 1, 1, '2026-INF-001', 'Carlos Eduardo', 'Mendoza', '2026 - 2030', 'Nuevo Ingreso'),
(2, 2, 1, '2026-INF-002', 'María José', 'Morales', '2026 - 2030', 'Nuevo Ingreso'),
(3, 3, 1, '2026-INF-003', 'Kevin Daniel', 'López', '2026 - 2030', 'Nuevo Ingreso');

-- 4. Inicialización de Expediente para Carlos Mendoza (Estudiante 1)
-- Materias del 1er Cuatrimestre en estado 'cursando' (Carga de Nuevo Ingreso)
INSERT INTO `expediente_asignaturas` (`id_estudiante`, `id_asignatura`, `estado`, `periodo_cursado`) VALUES
(1, 1, 'cursando', 'I Cuatrimestre 2026'),
(1, 2, 'cursando', 'I Cuatrimestre 2026'),
(1, 3, 'cursando', 'I Cuatrimestre 2026'),
(1, 4, 'cursando', 'I Cuatrimestre 2026');

-- ====================================================================
-- VISTA CONVENIENTE: Resumen de Avance Curricular por Estudiante
-- ====================================================================
CREATE OR REPLACE VIEW `vista_progreso_estudiante` AS
SELECT 
    e.id_estudiante,
    e.carnet,
    CONCAT(e.nombres, ' ', e.apellidos) AS nombre_completo,
    c.nombre_carrera,
    c.total_creditos AS creditos_totales_carrera,
    COALESCE(SUM(CASE WHEN ea.estado = 'aprobada' THEN a.creditos ELSE 0 END), 0) AS creditos_aprobados,
    COALESCE(SUM(CASE WHEN ea.estado = 'cursando' THEN a.creditos ELSE 0 END), 0) AS creditos_en_curso,
    COUNT(CASE WHEN ea.estado = 'aprobada' THEN 1 END) AS materias_aprobadas,
    ROUND((COALESCE(SUM(CASE WHEN ea.estado = 'aprobada' THEN a.creditos ELSE 0 END), 0) / c.total_creditos) * 100, 2) AS porcentaje_avance,
    ROUND(AVG(CASE WHEN ea.estado = 'aprobada' THEN ea.nota END), 2) AS promedio_general
FROM `estudiantes` e
JOIN `planes_estudio` pe ON e.id_plan = pe.id_plan
JOIN `carreras` c ON pe.id_carrera = c.id_carrera
LEFT JOIN `expediente_asignaturas` ea ON e.id_estudiante = ea.id_estudiante
LEFT JOIN `asignaturas` a ON ea.id_asignatura = a.id_asignatura
GROUP BY e.id_estudiante;
