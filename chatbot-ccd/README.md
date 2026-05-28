# 🎓 Chatbot CCD - UNAB
### Asistente Virtual del Centro de Competencias Digitales

---

## 📋 Descripción

Interfaz web desarrollada en **React + Vite** que conecta con el agente de inteligencia artificial del CCD de la Universidad Autónoma de Bucaramanga (UNAB), construido en **n8n**. Permite a los estudiantes consultar información sobre la Ruta de Competencias Digitales, cursos, inscripciones, progreso académico y noticias del CCD.

---

## 🛠️ Tecnologías utilizadas

| Tecnología | Uso |
|---|---|
| React 18 | Framework de interfaz de usuario |
| Vite | Bundler y servidor de desarrollo |
| n8n | Plataforma de automatización del agente IA |
| Groq (LLaMA) | Modelo de lenguaje del chatbot |
| PostgreSQL | Base de datos de estudiantes y cursos |
| Supabase + pgvector | Base de datos vectorial para RAG |
| Hugging Face | Generación de embeddings |

---

## ✅ Prerrequisitos

Antes de comenzar asegúrate de tener instalado:

- [Node.js](https://nodejs.org) versión 18 o superior
- npm (viene incluido con Node.js)
- Visual Studio Code (recomendado)

Verifica tu instalación de Node.js con:
```bash
node --version
```

---

## 🚀 Instalación y ejecución

### 1. Crear el proyecto con Vite

Abre la terminal en VS Code con `Ctrl + `` y ejecuta:

```bash
npm create vite@latest chatbot-ccd -- --template react
```

Cuando pregunte el framework selecciona **React**, luego selecciona **JavaScript**.

### 2. Entrar a la carpeta del proyecto

```bash
cd chatbot-ccd
```

### 3. Instalar dependencias

```bash
npm install
```

### 4. Reemplazar el archivo principal

- Abre la carpeta `chatbot-ccd` en VS Code
- Navega a `src/App.jsx`
- Borra todo el contenido del archivo
- Pega el contenido del archivo `ChatbotCCD.jsx`

### 5. Configurar el proxy para evitar errores CORS

Abre el archivo `vite.config.js` en la raíz del proyecto y reemplaza todo su contenido con:

```js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      '/webhook': {
        target: 'https://unab-n8n.duckdns.org:5678',
        changeOrigin: true,
        secure: false
      }
    }
  }
})
```

### 6. Verificar la URL del webhook

En `src/App.jsx` asegúrate que la URL del webhook sea la relativa (sin dominio):

```js
const WEBHOOK_URL = "/webhook/71bcaedc-9c88-4af8-9679-2ef8f284d824/chat";
```

### 7. Correr el proyecto

```bash
npm run dev
```

### 8. Abrir en el navegador

```
http://localhost:5173
```

---

## 🏗️ Arquitectura del proyecto

```
chatbot-ccd/
├── src/
│   ├── App.jsx          ← Componente principal del chatbot
│   └── main.jsx         ← Punto de entrada de React
├── vite.config.js       ← Configuración del proxy CORS
├── package.json
└── index.html
```

---

## 🤖 Arquitectura del agente IA (n8n)

```
[When chat message received]
         ↓
     [AI Agent]
    ↙    ↓    ↓    ↓         ↓
[Groq] [Memory] [Query ID] [Query Progreso] [Query Noticias]
                [Estudiante] [Académico]     [CCD]
                     ↓
              [Query Pilares CCD]
                     ↓
         [Supabase Vector Store RAG]
                     ↑
         [Embeddings Hugging Face]
```

---

## 🗄️ Base de datos

El proyecto usa **PostgreSQL** con las siguientes tablas:

| Tabla | Descripción |
|---|---|
| `estudiante` | Información de los 15 estudiantes simulados |
| `catalogo_materias_ccd` | 12 materias organizadas por pilar y plan |
| `oferta` | Cursos disponibles con fechas y docentes |
| `cursos_estudiante` | Historial de materias por estudiante |
| `registro_notas` | Notas y estado de cada curso |
| `documentos_ccd` | Fragmentos vectoriales del documento institucional |

---

## 💬 Funcionalidades del chatbot

- ✅ Validación de identidad por ID de estudiante
- ✅ Consulta de progreso académico personalizado
- ✅ Información sobre pilares y cursos del CCD
- ✅ Fechas de inscripción y oferta académica
- ✅ Noticias del CCD (web scraping UNAB)
- ✅ Sistema RAG con documento institucional
- ✅ Respuestas solo en español
- ✅ Restricción de temas fuera del CCD

---

## 👥 Equipo de desarrollo

Proyecto desarrollado para la asignatura de **Ciencia de Datos** — Universidad Autónoma de Bucaramanga (UNAB) — 2026.

---

## 📄 Licencia

Proyecto académico — UNAB 2026.
