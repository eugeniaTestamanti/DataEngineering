# DataEngineering

Paso a paso para ejecutar el script cargar_drinks.sh:
	1) Guardar el script en el sistema C:/Users/tuUsuario
	2) Abrir Git Bash
	3) Copiar el script al contenedor: docker cp cargar_drinks.sh edvai_hadoop:/home/hadoop/
	4) Ejecutar el contenedor: docker exec -it edvai_hadoop bash
	5) Cambiar al user hadoop: su hadoop
