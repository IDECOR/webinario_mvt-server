#!/bin/sh

# =================================================================
# SCRIPT PARA MIGRAR CAPAS GEOJSON A POSTGRESQL/POSTGIS
# =================================================================
# Este script busca todos los archivos .json en el directorio actual
# y los importa a la base de datos especificada, creando una tabla
# para cada archivo y su correspondiente índice espacial.
# =================================================================

# --- CONFIGURACIÓN DE LA CONEXIÓN A LA BASE DE DATOS ---
# Modifica estas variables con tus datos de conexión
PG_HOST="10.1.1.89"
PG_DB="db_webinario"
PG_USER="pgadmin"
PG_PASS="pgadmin123"
PG_SCHEMA="public" # Esquema donde se crearán las tablas

# --- LÓGICA DEL SCRIPT ---
# Exportamos la variable PGPASSWORD para que psql y ogr2ogr
# la usen automáticamente sin necesidad de pasar la clave en la línea de comandos.
export PGPASSWORD=$PG_PASS

# Buscamos todos los archivos que terminen en .json en el directorio actual
for geojson_file in *.json; do
    # Nos aseguramos de que el archivo realmente exista para evitar errores
    # si no se encuentra ningún archivo .json
    if [ ! -f "$geojson_file" ]; then
        echo "Advertencia: No se encontraron archivos .json para procesar."
        continue
    fi

    # Obtenemos el nombre del archivo sin la extensión .json para usarlo como nombre de tabla.
    # Ejemplo: de "departamentos.json" se obtiene "departamentos"
    table_name=$(basename "$geojson_file" .json)

    echo "---"
    echo "➡️  Procesando archivo: $geojson_file"

    # 1. MIGRACIÓN CON OGR2OGR
    # Se crea (o sobreescribe si ya existe) la tabla en la base de datos.
    # -lco OVERWRITE=YES: Borra la tabla si ya existe antes de crearla. Ideal para re-ejecutar el script.
    # -lco GEOMETRY_NAME=geom: Fija el nombre de la columna de geometría a 'geom'.
    echo "    - Importando datos a la tabla: \"${PG_SCHEMA}.${table_name}\""
    ogr2ogr -f "PostgreSQL" \
            PG:"host=${PG_HOST} dbname=${PG_DB} user=${PG_USER}" \
            "$geojson_file" \
            -nln "${PG_SCHEMA}.${table_name}" \
            -lco GEOMETRY_NAME=geom \
            -lco OVERWRITE=YES

    # Verificamos si el comando anterior tuvo éxito
    if [ $? -ne 0 ]; then
        echo "    ❌ Error al importar con ogr2ogr. Abortando para este archivo."
        continue
    fi

    # 2. CREACIÓN DEL ÍNDICE ESPACIAL CON PSQL
    # Un índice GIST es fundamental para que las consultas espaciales sean rápidas.
    # Se borra el índice si existía previamente para evitar errores al re-ejecutar.
    # echo "    - Creando índice espacial en la columna 'geom'"
    # psql -h "${PG_HOST}" -d "${PG_DB}" -U "${PG_USER}" -c "DROP INDEX IF EXISTS \"${table_name}_geom_idx\"; CREATE INDEX \"${table_name}_geom_idx\" ON \"${PG_SCHEMA}\".\"${table_name}\" USING GIST (geom);"

    # if [ $? -eq 0 ]; then
    #     echo "    ✅ ¡Completado exitosamente!"
    # else
    #     echo "    ❌ Error al crear el índice espacial."
    # fi

done

# Limpiamos la variable de entorno de la contraseña por seguridad
unset PGPASSWORD

echo "---"
echo "✨ Proceso de migración finalizado."
