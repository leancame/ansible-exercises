# Introducción

# Ejercicio 1: Crear Carpeta de Trabajo e Inventario con Dos Nodos

## Paso 1: Crear la Carpeta de Trabajo
1. Crea una carpeta de trabajo en la terminal para almacenar los archivos de este ejercicio. Nómbrala `inventario_ejercicio`.

## Paso 2: Crear el Primer Inventario con Dos Nodos
2. Dentro de la carpeta `inventario_ejercicio`, crea un archivo de inventario llamado `inventory.ini`.
   - Define un inventario ficticio con 2 nodos (`nodo1` y `nodo2`).
   - Organiza los nodos en los grupos `webservers`(nodo1) y `proxy`(nodo2).

## Paso 3: Configurar el Archivo de Configuración
3. Crea un archivo de configuración llamado `ansible.cfg` en la carpeta `inventario_ejercicio`.
   - Incluye la ruta al inventario y configura la ejecución de todas las tareas con permisos de superusuario.

## Paso 4 :Playbook 1
4. Crea un playbook llamado `configurar_servidor.yml` que realice las siguientes acciones:
   - **Verificar la conectividad** con los nodos en el grupo `webservers` usando el módulo `ping`.
   - **Instalar Apache2** en `nodo1`.
   - **Comprobar que Apache2** está en funcionamiento.
   Este playbook se ejecutará únicamente en el nodo1

## Paso 5: Playbook 2
5. Crea un playbook llamado `guardar_fecha.yml` que realice las siguientes acciones:
- **Guardar la fecha actual** en un archivo llamado `/tmp/fechahora.data`.
   Este playbook se ejecutará únicamente en el nodo2

## Paso 6: Ejecutar el Playbook
6. Ejecuta el playbook para cada nodo desde la shell

```sh
ansible-playbook configurar_servidor.yml
ansible-playbook guardar_fecha.yml