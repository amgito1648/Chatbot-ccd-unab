# ChatBot CCD — Centro de Competencias Digitales UNAB

Chatbot inteligente basado en arquitectura RAG que permite a estudiantes consultar información del Centro de Competencias Digitales (CCD) de la Universidad Autónoma de Bucaramanga (UNAB), integrando bases de datos, documentos institucionales y servicios académicos.

---

## Tecnologías utilizadas

| Herramienta | Uso |
|---|---|
| **n8n** | Orquestación de flujos y lógica del chatbot |
| **PostgreSQL** | Base de datos institucional con datos de estudiantes |
| **Supabase** | Base de datos externa para noticias (Web Scraping) y documentos RAG |
| **Groq** | Modelo de lenguaje (LLM) para el AI Agent |
| **Google Sheets** | Calendario de eventos académicos |
| **HuggingFace** | Embeddings para el sistema RAG |

---

## Arquitectura general

El proyecto está compuesto por tres flujos en n8n:

1. **Flujo principal** — ChatBot con AI Agent, consultas a Postgres, Google Sheets y Supabase.
2. **Flujo de Web Scraping** — Extracción automática de noticias del sitio web de la UNAB.
3. **Flujo RAG** — Carga y vectorización de documentos institucionales en PDF.

---

## Paso a paso de implementación

### 1. Configuración del AI Agent (Flujo principal)

1. Crear un nuevo workflow en n8n.
2. Agregar el nodo **"When chat message received"** como trigger.
3. Conectarlo al nodo **AI Agent**.
4. Vincular el AI Agent a:
   - **Groq Chat Model**: agregar las credenciales de la API Key generada en [console.groq.com](https://console.groq.com).
   - **Simple Memory**: para mantener el contexto de la conversación.

---

### 2. Conexión a la base de datos PostgreSQL

1. En n8n, crear una credencial de tipo **Postgres** con los datos proporcionados por el profesor (host, puerto, usuario, contraseña y nombre de la base de datos).
2. Verificar la conexión ejecutando una consulta de prueba (`SELECT * FROM estudiante LIMIT 5`).

---

### 3. Implementación de consultas SQL al AI Agent

Cada consulta se agrega como un nodo **"Execute Query"** de Postgres, conectado al AI Agent como herramienta (Tool). Cada nodo tiene una **Description** que le indica al agente cuándo usarla y un **Query** SQL.

#### QueryIDEstudiante
Valida que el ID ingresado por el estudiante exista en el sistema.

**Description:**
```
Úsala para consultar la tabla de estudiantes para verificar si un ID existe
en el sistema. Recibe el ID del estudiante como parámetro y retorna los datos
básicos del estudiante si existe, o un array vacío si no existe.
Usar para validar identidad al inicio de la conversación.
```

**Query:**
```sql
SELECT 
  id_estudiante,
  nombre_completo,
  CASE 
    WHEN id_estudiante IS NOT NULL THEN 'EXISTE'
    ELSE 'NO_EXISTE'
  END AS estado
FROM estudiante
WHERE id_estudiante = '{{ $json.chatInput }}'
LIMIT 1;
```

---

#### QueryPilaresCCD
Retorna los pilares del CCD cuando el estudiante los consulta.

**Description:**
```
Úsala cuando el usuario pregunte cuáles son los pilares del CCD,
cuántos pilares hay, o cómo se llaman. No requiere ningún parámetro.
```

**Query:**
```sql
SELECT DISTINCT pilar
FROM catalogo_materias_ccd
ORDER BY pilar;
```

---

#### QueryProgresoAcademico
Muestra el avance del estudiante en los pilares del CCD según su plan de estudios.

> **Nota:** La lógica de cumplimiento de pilares varía según el plan del estudiante:
> - **Plan nuevo** (año de ingreso >= 2025): basta con aprobar **al menos 1 curso** de un pilar para que se marque como cumplido.
> - **Plan antiguo** (año de ingreso < 2025): se deben aprobar **todos los cursos** del pilar para que se marque como cumplido.

**Description:**
```
Úsala cuando el estudiante pregunte por su progreso académico, qué pilares
ha completado, qué cursos le faltan, o cuánto le falta para terminar la ruta
de competencias digitales.
```

**Query:**
```sql
WITH cursos_aprobados_estudiante AS (
  SELECT rn.codigo_materia
  FROM registro_nota rn
  WHERE rn.id_estudiante = '{{ $fromAI("id_estudiante") }}'
    AND rn.nota = 'A'
),
plan_estudiante AS (
  SELECT plan
  FROM progreso_estudiante
  WHERE id_estudiante = '{{ $fromAI("id_estudiante") }}'
),
cursos_por_pilar AS (
  SELECT 
    ccd.pilar,
    COUNT(*) AS total_cursos_pilar,
    COUNT(cae.codigo_materia) AS cursos_aprobados_en_pilar,
    ARRAY_AGG(ccd.nombre_materia) FILTER (WHERE cae.codigo_materia IS NULL) AS materias_faltantes,
    ARRAY_AGG(ccd.nombre_materia) FILTER (WHERE cae.codigo_materia IS NOT NULL) AS materias_aprobadas
  FROM catalogo_materias_ccd ccd
  LEFT JOIN cursos_aprobados_estudiante cae ON cae.codigo_materia = ccd.codigo_materia
  WHERE ccd.plan = (SELECT plan FROM plan_estudiante)
  GROUP BY ccd.pilar
)
SELECT
  e.nombre_completo,
  e.programa_academico,
  e.anio_ingreso,
  (SELECT plan FROM plan_estudiante) AS plan,
  cpp.pilar,
  CASE
    WHEN (SELECT plan FROM plan_estudiante) = 'nuevo' 
      THEN cpp.cursos_aprobados_en_pilar >= 1
    WHEN (SELECT plan FROM plan_estudiante) = 'antiguo' 
      THEN cpp.cursos_aprobados_en_pilar >= cpp.total_cursos_pilar
  END AS pilar_cumplido,
  cpp.cursos_aprobados_en_pilar,
  cpp.total_cursos_pilar,
  cpp.materias_aprobadas,
  cpp.materias_faltantes
FROM cursos_por_pilar cpp
JOIN estudiante e ON e.id_estudiante = '{{ $fromAI("id_estudiante") }}'
ORDER BY cpp.pilar;
```

---

#### QueryCursosDisponibles
Lista los cursos de la tabla `oferta` que están activos y a los que un estudiante puede inscribirse.

**Description:**
```
Usa esta herramienta cuando el estudiante pregunte por cursos disponibles,
cursos abiertos, cursos en los que puede inscribirse, o la oferta académica
actual del CCD. Consulta la tabla 'oferta' y retorna los cursos activos,
mostrando nombre, pilar, modalidad, cupos disponibles, fechas del curso y
docente. El ID del estudiante ya fue capturado al inicio, pero esta consulta
no lo requiere.
```

**Query:**
```sql
SELECT 
    nombre_curso,
    pilar,
    modalidad,
    cupos_disponibles,
    cupos,
    TO_CHAR(fecha_inicio, 'DD/MM/YYYY') AS fecha_inicio,
    TO_CHAR(fecha_fin, 'DD/MM/YYYY') AS fecha_fin,
    TO_CHAR(fecha_inicio_matricula, 'DD/MM/YYYY') AS inicio_inscripciones,
    TO_CHAR(fecha_fin_matricula, 'DD/MM/YYYY') AS cierre_inscripciones,
    aula,
    docente
FROM oferta
WHERE activo = TRUE
ORDER BY pilar, fecha_inicio;
```

---

### 4. Integración con Google Sheets

1. Ingresar a [Google Cloud Console](https://console.cloud.google.com) con una cuenta personal (la cuenta institucional no permite los permisos necesarios).
2. Crear un proyecto nuevo y habilitar las APIs:
   - **Google Drive API**
   - **Google Sheets API**
3. Crear las credenciales de tipo **OAuth 2.0** y configurarlas en n8n.
4. En Google Drive, crear un archivo de Google Sheets con una tabla que contenga los eventos académicos y sus fechas (ej. prueba diagnóstica, fechas de inscripción, etc.).
5. Compartir el archivo con la cuenta de servicio que Google Cloud generó para n8n.
6. En n8n, agregar el nodo **Google Sheets** (modo `read: sheet`) y vincularlo al AI Agent como herramienta.

---

### 5. Flujo de Web Scraping (workflow separado)

Este flujo se implementó en un workflow independiente para no interferir con el flujo principal.

#### 5.1 Crear la base de datos en Supabase

1. Crear una cuenta en [Supabase](https://supabase.com) y un proyecto nuevo.
2. En el **SQL Editor** de Supabase, crear la tabla de noticias:

```sql
CREATE TABLE noticias (
  id SERIAL PRIMARY KEY,
  titulo TEXT,
  link TEXT UNIQUE,
  fecha DATE,
  resumen TEXT,
  fecha_scraping TIMESTAMP DEFAULT NOW()
);
```

3. En la configuración de Supabase, activar el **Session Pooler** y anotar la cadena de conexión. Usar el **puerto 6543** (Transaction Mode) al configurar las credenciales de Postgres en n8n para evitar el error `EMAXCONNSESSION`.

#### 5.2 Construir el flujo en n8n

El flujo sigue esta secuencia de nodos:

1. **Schedule Trigger** — Define la frecuencia de ejecución del scraping.
2. **HTTP Request** — Método `GET` a la siguiente URL:
   ```
   https://unab.edu.co/wp-json/wp/v2/posts?search=competencias+digitales&per_page=10&_fields=title,link,date,excerpt
   ```
3. **Code (JavaScript)** — Modo **"Run Once for Each Item"**. Extrae y limpia los campos de cada noticia:
   ```javascript
   const item = $input.item.json;
   return {
     json: {
       titulo: item.title.rendered,
       link: item.link,
       fecha: item.date.split('T')[0],
       resumen: item.excerpt.rendered
         .replace(/<[^>]*>/g, '')
         .substring(0, 200)
     }
   };
   ```
4. **Postgres (Execute Query)** — Inserta las noticias en Supabase evitando duplicados:

   **Query:**
   ```sql
   INSERT INTO noticias (titulo, link, fecha, resumen)
   VALUES ($1, $2, $3::date, $4)
   ON CONFLICT (link) DO NOTHING;
   ```
   **Parámetros:**
   ```
   {{ $json.titulo }}
   {{ $json.link }}
   {{ $json.fecha }}
   {{ $json.resumen }}
   ```

---

### 6. Consulta de noticias en el flujo principal

Una vez que el Web Scraping guarda las noticias en Supabase, se agrega la siguiente consulta al flujo principal:

#### QueryNoticiasCCD

**Description:**
```
Úsala cuando el estudiante pregunte por noticias recientes, novedades,
nuevos cursos disponibles o convocatorias del CCD. No requiere ningún parámetro.
```

**Query:**
```sql
SELECT titulo, resumen, link, TO_CHAR(fecha, 'DD/MM/YYYY') AS fecha
FROM noticias
ORDER BY fecha DESC
LIMIT 5;
```

> **Importante:** La credencial de Postgres para este nodo debe apuntar a **Supabase** con el **puerto 6543**, no a la base de datos del profesor.

---

### 7. Flujo RAG — Carga de documentos institucionales (workflow separado)

Este flujo permite cargar documentos PDF institucionales para que el AI Agent los consulte mediante búsqueda semántica.

#### 7.1 Crear la tabla vectorial en Supabase

Antes de ejecutar el flujo, crear la tabla para almacenar los vectores en Supabase desde el SQL Editor (usando la extensión `pgvector`).

#### 7.2 Construir el flujo en n8n

El flujo sigue esta secuencia:

1. **Form Trigger** — Activa el flujo con un formulario, validando que el archivo adjunto sea un PDF.
2. **Default Data Loader** — Carga el contenido del PDF.
3. **Recursive Character Text Splitter** — Divide el documento en fragmentos de texto manejables.
4. **Postgres PGVector Store** — Almacena los fragmentos vectorizados en Supabase.
5. **HuggingFace Embeddings** — Genera los embeddings de cada fragmento.
   - Para la API Key de HuggingFace, es necesario activar la opción de **Inference** en la configuración de la cuenta.

#### 7.3 Vincular el RAG al flujo principal

En el flujo principal, agregar el nodo **"Consultar_Documentos_CCD"** (tipo Vector Store Tool con Postgres PGVector), conectándolo al AI Agent para que pueda responder preguntas basadas en los documentos cargados.

---

## Estructura de la base de datos (PostgreSQL)

| Tabla / Vista | Descripción |
|---|---|
| `estudiante` | Datos del estudiante (ID, nombre, programa, plan, semestre) |
| `catalogo_materias_ccd` | Materias del CCD organizadas por pilar y plan |
| `cursos_estudiantes` | Historial de cursos cursados por el estudiante |
| `registro_nota` | Notas registradas (A = Aprobado, R = Reprobado) |
| `oferta` | Cursos actualmente ofertados por el CCD |
| `progreso_estudiante` | Vista consolidada del progreso por pilares |

---

## Notas importantes

- Las credenciales (API Keys, contraseñas de bases de datos, tokens de Google) **no se exportan** con el workflow de n8n. Al importar el `.json` en una nueva instancia, deben reconfigurarse manualmente.
- Al migrar el workflow a otro servicio de n8n, recordar configurar la credencial de Supabase con el **puerto 6543** desde el inicio para evitar el error de conexiones máximas (`EMAXCONNSESSION`).
- La cuenta de Google usada para Google Sheets debe ser **personal**; las cuentas institucionales no permiten los permisos de Google Cloud necesarios.
