# Webinario: MVT Server para trabajar con datos geoespaciales

## 📦 Material de trabajo

### 🧾 Requisitos previos
- Tener instalado **PostgreSQL** (v12+ recomendado).  
- Extensión **PostGIS** instalada y habilitada en la base de datos.  
- Herramientas útiles: `psql`, `ogr2ogr` (parte de GDAL).  
- Acceso de escritura a la base de datos (usuario con permisos para crear tablas / esquemas).

---

### 🗺️ Capas

Las capas pueden cargarse todas juntas en el servidor **PostgreSQL/PostGIS** utilizando el script **`migrar_a_postgresql.sh`**.

#### Pasos

1. Colocar **todas las capas** en un único directorio.  
   - Las capas deben estar en formato **`.json`**.  
   - Si alguna capa está comprimida en **`.zip`**, descomprímela antes.  
2. Copiar el script **`migrar_a_postgresql.sh`** en el mismo directorio.  
3. **Modificar los parámetros de conexión** dentro del script para que apunten a tu base de datos (host, puerto, nombre de la base, usuario y contraseña).  
   - Ejemplo de variables en el script:
     ```sh
     PG_HOST="10.1.1.89"
     PG_DB="db_webinario"
     PG_USER="user"
     PG_PASS="password"
     PG_SCHEMA="public"
     ```
4. Ejecutar el script desde la terminal:
   ```bash
   ./migrar_a_postgresql.sh


### 🎨 Styles

El archivo **`styles.zip`** contiene los **estilos de ejemplo** utilizados durante el webinario.  

#### Instrucciones de uso

1. Descomprimí el archivo `styles.zip` en una carpeta de tu preferencia.  
2. Dentro encontrarás ejemplos de **estilos en formato JSON**, compatibles con **MapLibre GL** o **Mapbox GL JS**.  
3. Podés abrirlos, modificarlos y adaptarlos a tus propias capas y fuentes de datos.  
4. Si los nombres de las capas o campos en tu base difieren de los del ejemplo, ajustá esos valores dentro del archivo de estilo.
