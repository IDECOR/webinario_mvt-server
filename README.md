# Webinario MVT Server para trabajar con datos geoespaciales

## Material de Trabajo

### Capas

Las capas puede subirse todas juntas al servidor Postgres/Postgis mediante el script **migrar_a_postgresql.sh**

- Colocar todas las capas en único directorio, las capas deben estar en formato json (las que estén en zip, descomprimirlas antes), además colocar el script migrar_a_postgresql.sh. 
- Ejecutar el script.

Esto debe funcionar sin problema en cualquier sistema Unix-like

Otra manera es cargar las capas en QGis y desde ahí exportarlas a Postgresql

### Styles

El archivo styles.zip contiene los ejmplos de styles usados en el webinario
