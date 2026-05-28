-- ============================================================
-- SCRIPT COMPLETO BASE DE DATOS CCD - UNAB
-- Ejecutar en Railway Postgres o Supabase
-- ============================================================

-- ============================================================
-- TABLA: estudiante
-- ============================================================
CREATE TABLE IF NOT EXISTS estudiante (
    id_estudiante VARCHAR(20) PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    programa_academico VARCHAR(100),
    facultad VARCHAR(100),
    anio_ingreso INTEGER,
    semestre_actual INTEGER,
    email VARCHAR(100),
    telegram_id VARCHAR(20),
    telefono VARCHAR(20),
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT NOW()
);

INSERT INTO estudiante VALUES
('20250001','Valentina Gómez Rincón','Ingeniería de Sistemas','Ingeniería',2025,2,'v.gomez@unab.edu.co','100001','3001234567',true,'2026-03-29T03:39:00.387Z'),
('20250002','Santiago Pérez Morales','Administración de Empresas','Ciencias Económicas',2025,2,'s.perez@unab.edu.co','100002','3012345678',true,'2026-03-29T03:39:00.387Z'),
('20220003','Laura Cristina Vargas Díaz','Derecho','Derecho',2022,8,'l.vargas@unab.edu.co','100003','3023456789',true,'2026-03-29T03:39:00.387Z'),
('20230004','Andrés Felipe Rojas Castro','Psicología','Ciencias Humanas',2023,5,'a.rojas@unab.edu.co','100004','3034567890',true,'2026-03-29T03:39:00.387Z'),
('20240005','María José Torres Acevedo','Comunicación Social y Periodismo','Comunicación y Artes',2024,3,'m.torres@unab.edu.co','100005','3045678901',true,'2026-03-29T03:39:00.387Z'),
('20210006','Daniel Esteban Lozano Ruiz','Arquitectura','Arquitectura y Diseño',2021,9,'d.lozano@unab.edu.co','100006','3056789012',true,'2026-03-29T03:39:00.387Z'),
('20250007','Camila Andrea Suárez León','Medicina','Ciencias de la Salud',2025,1,'c.suarez@unab.edu.co','100007','3067890123',true,'2026-03-29T03:39:00.387Z'),
('20200008','Julián Mauricio Pinto García','Ingeniería Industrial','Ingeniería',2020,10,'j.pinto@unab.edu.co','100008','3078901234',true,'2026-03-29T03:39:00.387Z'),
('20240009','Isabella Ramírez Quintero','Diseño Gráfico','Arquitectura y Diseño',2024,3,'i.ramirez@unab.edu.co','100009','3089012345',true,'2026-03-29T03:39:00.387Z'),
('20250010','Sebastián Herrera Blanco','Contaduría Pública','Ciencias Económicas',2025,2,'s.herrera@unab.edu.co','100010','3090123456',true,'2026-03-29T03:39:00.387Z'),
('20230011','Paula Andrea Mejía Ospina','Licenciatura en Lengua Inglesa','Educación',2023,5,'p.mejia@unab.edu.co','100011','3101234567',true,'2026-03-29T03:39:00.387Z'),
('20240012','Nicolás David Cárdenas Ortiz','Ingeniería Biomédica','Ingeniería',2024,4,'n.cardenas@unab.edu.co','100012','3112345678',true,'2026-03-29T03:39:00.387Z'),
('20220013','Gabriela Ximena López Soto','Negocios Internacionales','Ciencias Económicas',2022,7,'g.lopez@unab.edu.co','100013','3123456789',true,'2026-03-29T03:39:00.387Z'),
('20240014','Mateo Alejandro Guerrero Vega','Ingeniería Civil','Ingeniería',2024,4,'m.guerrero@unab.edu.co','100014','3134567890',true,'2026-03-29T03:39:00.387Z'),
('20230015','Sofía Catalina Mendoza Parra','Fisioterapia','Ciencias de la Salud',2023,5,'s.mendoza@unab.edu.co','100015','3145678901',true,'2026-03-29T03:39:00.387Z');

-- ============================================================
-- TABLA: catalogo_materias_ccd
-- ============================================================
CREATE TABLE IF NOT EXISTS catalogo_materias_ccd (
    codigo_materia VARCHAR(10) PRIMARY KEY,
    codigo_curso INTEGER,
    nombre_materia VARCHAR(100),
    plan VARCHAR(10),
    pilar VARCHAR(100),
    descripcion TEXT
);

INSERT INTO catalogo_materias_ccd VALUES
('CLDG',18019,'Cultura Digital','antiguo','Competencias Digitales Básicas','Fundamentos de cultura digital para la vida universitaria y profesional.'),
('VLDN',18020,'Vida en Línea','antiguo','Competencias Digitales Básicas','Gestión de identidad digital, seguridad y ciudadanía en internet.'),
('WORD',18021,'Word','antiguo','Analítica y Contenido Digital','Procesamiento de textos con Microsoft Word a nivel profesional.'),
('PWPT',18024,'PowerPoint','antiguo','Analítica y Contenido Digital','Diseño y presentación de contenidos con Microsoft PowerPoint.'),
('EXCL',18022,'Excel','antiguo','Transformación Digital','Análisis de datos y automatización con Microsoft Excel.'),
('HECO',18032,'Interacción Digital','nuevo','Competencias Digitales Básicas','Fundamentos de interacción humano-computador, UX y entornos digitales.'),
('CDAT',18007,'Habilidades en Analítica Digital','nuevo','Analítica y Contenido Digital','Análisis de datos, dashboards y toma de decisiones basada en datos.'),
('MARK',15007,'Marca Personal Digital','nuevo','Analítica y Contenido Digital','Construcción y gestión de la identidad y marca profesional en medios digitales.'),
('MAOP',15008,'Creación de Contenidos Digitales','nuevo','Analítica y Contenido Digital','Producción para redes sociales, blogs y plataformas digitales.'),
('TINF',18006,'IA Generativa','nuevo','Transformación Digital','Aplicaciones prácticas de la inteligencia artificial generativa en el entorno profesional.'),
('DEGE',15122,'Marco Legal Digital','nuevo','Transformación Digital','Legislación en entornos digitales: propiedad intelectual, protección de datos y contratos.'),
('PSIC',14013,'Cuidado y Bienestar Digital','nuevo','Transformación Digital','Salud mental, bienestar y equilibrio en el uso de tecnologías.');

-- ============================================================
-- TABLA: oferta
-- ============================================================
CREATE TABLE IF NOT EXISTS oferta (
    id_oferta SERIAL PRIMARY KEY,
    codigo_curso INTEGER,
    nombre_curso VARCHAR(100),
    pilar VARCHAR(100),
    modalidad VARCHAR(20),
    cupos INTEGER,
    cupos_disponibles INTEGER,
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    fecha_inicio_matricula TIMESTAMP,
    fecha_fin_matricula TIMESTAMP,
    aula VARCHAR(50),
    docente VARCHAR(100),
    activo BOOLEAN DEFAULT true
);

INSERT INTO oferta (codigo_curso, nombre_curso, pilar, modalidad, cupos, cupos_disponibles, fecha_inicio, fecha_fin, fecha_inicio_matricula, fecha_fin_matricula, aula, docente, activo) VALUES
(18032,'Interacción Digital','Competencias Digitales Básicas','Virtual',35,12,'2026-04-15','2026-05-15','2026-03-27','2026-04-09','Aula Virtual Canvas','Mg. Carlos Andrés Suárez',true),
(18032,'Interacción Digital','Competencias Digitales Básicas','Presencial',30,8,'2026-04-15','2026-05-15','2026-03-27','2026-04-09','Sala 301 Bloque C','Esp. Patricia Morales',true),
(18007,'Habilidades en Analítica Digital','Analítica y Contenido Digital','Virtual',35,20,'2026-04-15','2026-05-15','2026-03-27','2026-04-09','Aula Virtual Canvas','MSc. Diana Lorena Pineda',true),
(15007,'Marca Personal Digital','Analítica y Contenido Digital','Presencial',25,5,'2026-04-15','2026-05-15','2026-03-27','2026-04-09','Sala 204 Bloque A','Esp. Jorge Luis Cárdenas',true),
(15008,'Creación de Contenidos Digitales','Analítica y Contenido Digital','Virtual',40,25,'2026-04-15','2026-05-15','2026-03-27','2026-04-09','Aula Virtual Canvas','Mg. Laura Beatriz Nieto',true),
(18006,'IA Generativa','Transformación Digital','Virtual',50,32,'2026-04-15','2026-05-15','2026-03-27','2026-04-09','Aula Virtual Canvas','PhD. Hernando Arévalo',true),
(15122,'Marco Legal Digital','Transformación Digital','Presencial',30,18,'2026-04-15','2026-05-15','2026-03-27','2026-04-09','Sala 105 Bloque B','Mg. Sandra Patricia Ruiz',true),
(14013,'Cuidado y Bienestar Digital','Transformación Digital','Virtual',40,28,'2026-04-15','2026-05-15','2026-03-27','2026-04-09','Aula Virtual Canvas','Esp. Marcela Uribe',true);

-- ============================================================
-- TABLA: cursos_estudiante
-- ============================================================
CREATE TABLE IF NOT EXISTS cursos_estudiante (
    id SERIAL PRIMARY KEY,
    id_estudiante VARCHAR(20),
    codigo_materia VARCHAR(10),
    codigo_curso INTEGER,
    nombre_materia VARCHAR(100),
    semestre VARCHAR(10),
    anio INTEGER,
    fecha_matricula TIMESTAMP
);

INSERT INTO cursos_estudiante (id, id_estudiante, codigo_materia, codigo_curso, nombre_materia, semestre, anio, fecha_matricula) VALUES
(1,'20220003','CLDG',18019,'Cultura Digital','2022-2',2022,'2022-08-01'),
(2,'20220003','VLDN',18020,'Vida en Línea','2023-1',2023,'2023-01-15'),
(3,'20220003','WORD',18021,'Word','2023-1',2023,'2023-01-15'),
(4,'20220003','PWPT',18024,'PowerPoint','2023-2',2023,'2023-08-01'),
(5,'20220003','EXCL',18022,'Excel','2024-1',2024,'2024-01-15'),
(6,'20230004','CLDG',18019,'Cultura Digital','2023-1',2023,'2023-01-15'),
(7,'20230004','VLDN',18020,'Vida en Línea','2023-2',2023,'2023-08-01'),
(8,'20230004','WORD',18021,'Word','2024-1',2024,'2024-01-15'),
(9,'20240005','HECO',18032,'Interacción Digital','2024-1',2024,'2024-01-15'),
(10,'20210006','CLDG',18019,'Cultura Digital','2021-2',2021,'2021-08-01'),
(11,'20210006','VLDN',18020,'Vida en Línea','2022-1',2022,'2022-01-15'),
(12,'20210006','WORD',18021,'Word','2022-2',2022,'2022-08-01'),
(13,'20210006','EXCL',18022,'Excel','2023-1',2023,'2023-01-15'),
(14,'20200008','CLDG',18019,'Cultura Digital','2020-2',2020,'2020-08-01'),
(15,'20200008','VLDN',18020,'Vida en Línea','2021-1',2021,'2021-01-15'),
(16,'20200008','WORD',18021,'Word','2021-2',2021,'2021-08-01'),
(17,'20200008','EXCL',18022,'Excel','2022-1',2022,'2022-01-15'),
(18,'20200008','PWPT',18024,'PowerPoint','2022-2',2022,'2022-08-01'),
(19,'20240009','HECO',18032,'Interacción Digital','2024-1',2024,'2024-01-15'),
(20,'20240009','MAOP',15008,'Creación de Contenidos Digitales','2024-2',2024,'2024-08-01'),
(21,'20250010','HECO',18032,'Interacción Digital','2025-1',2025,'2025-01-15'),
(22,'20230011','CLDG',18019,'Cultura Digital','2023-1',2023,'2023-01-15'),
(23,'20230011','VLDN',18020,'Vida en Línea','2023-2',2023,'2023-08-01'),
(24,'20230011','WORD',18021,'Word','2024-1',2024,'2024-01-15'),
(25,'20230011','PWPT',18024,'PowerPoint','2024-1',2024,'2024-01-15'),
(26,'20230011','EXCL',18022,'Excel','2024-2',2024,'2024-08-01'),
(27,'20240012','HECO',18032,'Interacción Digital','2024-1',2024,'2024-01-15'),
(28,'20240012','CDAT',18007,'Habilidades en Analítica Digital','2024-2',2024,'2024-08-01'),
(29,'20240012','TINF',18006,'IA Generativa','2024-2',2024,'2024-08-01'),
(30,'20240014','HECO',18032,'Interacción Digital','2024-1',2024,'2024-01-15'),
(31,'20240014','MARK',15007,'Marca Personal Digital','2024-2',2024,'2024-08-01'),
(32,'20240014','DEGE',15122,'Marco Legal Digital','2025-1',2025,'2025-01-15'),
(33,'20230015','CLDG',18019,'Cultura Digital','2023-2',2023,'2023-08-01'),
(34,'20230015','VLDN',18020,'Vida en Línea','2024-1',2024,'2024-01-15'),
(35,'20250001','HECO',18032,'Interacción Digital','2025-1',2025,'2025-01-15'),
(36,'20250001','TINF',18006,'IA Generativa','2025-2',2025,'2025-08-01');

-- ============================================================
-- TABLA: registro_notas
-- ============================================================
CREATE TABLE IF NOT EXISTS registro_notas (
    id SERIAL PRIMARY KEY,
    id_estudiante VARCHAR(20),
    codigo_materia VARCHAR(10),
    codigo_curso INTEGER,
    tipo_registro VARCHAR(20),
    nota CHAR(1),
    fecha_registro TIMESTAMP,
    observacion TEXT
);

INSERT INTO registro_notas (id, id_estudiante, codigo_materia, codigo_curso, tipo_registro, nota, fecha_registro, observacion) VALUES
(1,'20220003','CLDG',18019,'curso','A','2022-12-15',null),
(2,'20220003','VLDN',18020,'curso','A','2023-06-20',null),
(3,'20220003','WORD',18021,'curso','A','2023-06-20',null),
(4,'20220003','PWPT',18024,'curso','A','2023-12-10',null),
(5,'20220003','EXCL',18022,'curso','A','2024-06-15',null),
(6,'20230004','CLDG',18019,'curso','A','2023-06-15',null),
(7,'20230004','VLDN',18020,'curso','A','2023-12-10',null),
(8,'20230004','WORD',18021,'curso','A','2024-06-20',null),
(9,'20240005','HECO',18032,'curso','A','2024-06-30',null),
(10,'20210006','CLDG',18019,'curso','A','2021-12-10',null),
(11,'20210006','VLDN',18020,'curso','A','2022-06-15',null),
(12,'20210006','WORD',18021,'curso','A','2022-12-20',null),
(13,'20210006','EXCL',18022,'curso','A','2023-06-10',null),
(14,'20200008','CLDG',18019,'curso','A','2020-12-05',null),
(15,'20200008','VLDN',18020,'curso','A','2021-06-10',null),
(16,'20200008','WORD',18021,'curso','A','2021-12-15',null),
(17,'20200008','EXCL',18022,'curso','A','2022-06-20',null),
(18,'20200008','PWPT',18024,'curso','A','2022-12-10',null),
(19,'20240009','HECO',18032,'curso','A','2024-06-25',null),
(20,'20240009','MAOP',15008,'curso','A','2024-12-10',null),
(21,'20250010','HECO',18032,'validacion','A','2025-04-10',null),
(22,'20230011','CLDG',18019,'curso','A','2023-06-12',null),
(23,'20230011','VLDN',18020,'curso','A','2023-12-08',null),
(24,'20230011','WORD',18021,'curso','A','2024-06-15',null),
(25,'20230011','PWPT',18024,'curso','A','2024-06-15',null),
(26,'20230011','EXCL',18022,'curso','R','2024-12-05',null),
(27,'20240012','HECO',18032,'curso','A','2024-06-20',null),
(28,'20240012','CDAT',18007,'curso','A','2024-12-15',null),
(29,'20240012','TINF',18006,'curso','R','2024-12-15',null),
(30,'20240014','HECO',18032,'curso','A','2024-06-18',null),
(31,'20240014','MARK',15007,'curso','A','2024-12-20',null),
(32,'20240014','DEGE',15122,'validacion','A','2025-02-05',null),
(33,'20230015','CLDG',18019,'curso','A','2023-12-10',null),
(34,'20230015','VLDN',18020,'curso','A','2024-06-05',null),
(35,'20250001','HECO',18032,'curso','A','2025-06-10',null),
(36,'20250001','TINF',18006,'curso','A','2025-12-05',null);

-- ============================================================
-- VISTA: progreso_academico (útil para el chatbot)
-- ============================================================
CREATE OR REPLACE VIEW progreso_academico AS
SELECT 
    e.id_estudiante,
    e.nombre_completo,
    e.programa_academico,
    e.anio_ingreso,
    CASE WHEN e.anio_ingreso >= 2024 THEN 'nuevo' ELSE 'antiguo' END as plan,
    COUNT(CASE WHEN rn.nota = 'A' THEN 1 END) as cursos_aprobados,
    COUNT(CASE WHEN rn.nota = 'R' THEN 1 END) as cursos_reprobados,
    BOOL_OR(CASE WHEN cm.pilar = 'Competencias Digitales Básicas' AND rn.nota = 'A' THEN true ELSE false END) as pilar1_cumplido,
    BOOL_OR(CASE WHEN cm.pilar = 'Analítica y Contenido Digital' AND rn.nota = 'A' THEN true ELSE false END) as pilar2_cumplido,
    BOOL_OR(CASE WHEN cm.pilar = 'Transformación Digital' AND rn.nota = 'A' THEN true ELSE false END) as pilar3_cumplido
FROM estudiante e
LEFT JOIN registro_notas rn ON e.id_estudiante = rn.id_estudiante
LEFT JOIN catalogo_materias_ccd cm ON rn.codigo_materia = cm.codigo_materia
GROUP BY e.id_estudiante, e.nombre_completo, e.programa_academico, e.anio_ingreso;
