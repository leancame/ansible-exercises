# Ejercicio 3: Uso de Módulos de Ansible

## Paso 1: Comprimir el Directorio `/apps/tomcat` en Formato gz

1. **Comprimir el directorio sin usar variables**:
    - Crea un playbook llamado `comprimir_tomcat_sin_variables.yml`.
    - Utiliza el módulo `archive` para comprimir el directorio `/apps/tomcat` en un archivo `.gz`.
  
2. **Comprimir el directorio usando variables**:
    - Crea un playbook llamado `comprimir_tomcat_con_variables.yml`.
    - Define una variable para la ruta del directorio y otra para el archivo comprimido.
    - Utiliza el módulo `archive` para comrpimir el directorio indicado.

## Paso 2: Comprimir Archivos con Exclusiones

1. **Comprimir archivos excluyendo ciertos patrones**:
    - Crea un playbook llamado `comprimir_logs_excluir.yml`.
    - Utiliza el módulo `find` para localizar todos los archivos en las carpetas `/apps/tomcat/logs` y `/var/log/tomcat/`.
    - Excluye aquellos que tengan la palabra `access` y sean de extensión `.txt`.
    - Usa el módulo `archive` para comprimir los archivos encontrados.

## Paso 3: Instalar Paquetes .deb
1. **Instalar un paquete `.deb` desde un archivo local**:
    - Crea un playbook llamado `instalar_paquete_local.yml`.
    - Usa el módulo `apt` o `dpkg` para instalar un paquete `.deb` que esté almacenado localmente.

2. **Instalar un paquete desde Internet**:
    - Crea un playbook llamado `instalar_paquete_internet.yml`.
    - Utiliza el módulo `apt` para instalar un programa disponible en los repositorios de Internet, como `htop` o `curl`.
