# Introducción

# Ejercicio 1: Crear Carpeta de Trabajo e Inventario con Dos Nodos

## Paso 1: Crear la Carpeta de Trabajo

1.- Crea una carpeta de trabajo en la terminal para almacenar los archivos de este ejercicio. Nómbrala `inventario_ejercicio`.

Antes de realizar cualquier actividad, lo primero que he realizado es la creación de dos máquinas esclavas y la conexión ssh de estas con la maestra para poder realizar todos los ejercicios a futuros.

Para crear la carpeta solo debemos usar `mkdir` a la carpeta donde tenemos las soluciones.

![Captura sobre el código](../../datos/Ejercicio01/creacion%20inventario.png)



## Paso 2: Crear el Primer Inventario con Dos Nodos
2.- Dentro de la carpeta `inventario_ejercicio`, crea un archivo de inventario llamado `inventory.ini`.
   - Define un inventario ficticio con 2 nodos (`nodo1` y `nodo2`).
   - Organiza los nodos en los grupos `webservers`(nodo1) y `proxy`(nodo2).

Al igual que el caso anterior, he decidido crear un archivo llamado `inventory.ini` en la carpeta que he creado anteriormente con el comando `touch` y luego he editado el archivo con `nano` para agregar los datos solicitados. También, lo puedo modificar desde Visual Studio Code. 

El código que he utilizado es el siguiente: 
```bash
[webservers]
nodo1 ansible_host=192.168.18.36

[proxy]
nodo2 ansible_host=192.168.18.37
```

![Captura sobre el código](../../datos/Ejercicio01/creacion%20archivo%20inventario%20ini%20ficticio%202%20con%20ip.png)

Tengo que añadir que las IP de las máquinas suelen cambiar dependiendo la red en la que estoy por lo que si estoy en mi casa se le da otro rango de IP diferente al de la foto. A lo largo de estos días iré probando para saber si puedo asignar una IP concreta.


## Paso 3: Configurar el Archivo de Configuración
3.- Crea un archivo de configuración llamado `ansible.cfg` en la carpeta `inventario_ejercicio`.
   - Incluye la ruta al inventario y configura la ejecución de todas las tareas con permisos de superusuario.

Para la creación de este archivo he utilizado el comando `touch` y luego he editado el archivo con `nano` para agregar los datos solicitados.

![Captura sobre el código](../../datos/Ejercicio01/crear%20archivo%20ansible.png)

En este archivo se configura la ruta al archivo de inventario `inventory.ini` y se configura la ejecución de todas las tareas con permisos de superusuario con `become = True`.

```bash
[defaults]
inventory = inventory.ini

[privilege_escalation]
become = True
```

![Captura sobre el código](../../datos/Ejercicio01/ansible.cfg%202.png)

Tras la creación del archivo, he querido corroborar que el archivo se haya creado correctamente y que funcione. Para ello, he usado el comando `ansible all -m ping` fallando a causa de no poseer la password de la maestra. Por ende, usé `ansible all -m ping -k` para que me solicite la password SSH de la máquina esclava y poder acceder. Otro comando usable es `ansible all -m ping -k --ask-become-pass` para que me solicite la password de superusuario además de lo dicho anteriormente.

![Captura sobre el código](../../datos/Ejercicio01/comprobar%20ansible.cfg%20.png)


## Paso 4: Playbook 1
4.- Crea un playbook llamado `configurar_servidor.yml` que realice las siguientes acciones:
   - **Verificar la conectividad** con los nodos en el grupo `webservers` usando el módulo `ping`.
   - **Instalar Apache2** en `nodo1`.
   - **Comprobar que Apache2** está en funcionamiento.
   Este playbook se ejecutará únicamente en el nodo1

Para la creación del Playbook 1 he utilizado el comando `touch` y luego he editado el archivo con `nano` para agregar los siguientes datos:

```bash
---
- name: Configurar servidor web en nodo1 # Configurar servidor web en nodo1
  hosts: webservers # Seleccionar grupo de nodos  
  become: yes # Permitir ejecutar comandos con privilegios de superusuario
  tasks: # Definir tareas a ejecutar
    - name: Verificar conectividad con el nodo (ping) # Verificar conectividad con el nodo (ping)
      ansible.builtin.ping: # Utilizar modulo ping

    - name: Instalar Apache2 # Instalar Apache2
      ansible.builtin.apt: # Utilizar modulo apt
        name: apache2 # Nombre del paquete a instalar
        state: present # Estado deseado del paquete (presente o ausente)
        update_cache: true # Actualizar cache de paquetes antes de instalar

    - name: Comprobar que Apache2 está en funcionamiento # Comprobar que Apache2 está en funcionamiento
      ansible.builtin.service: # Utilizar modulo service
        name: apache2 # Nombre del servicio a comprobar
        state: started # Estado deseado del servicio (iniciado o detenido)
        enabled: true # Habilitar el servicio para que se inicie automáticamente al arrancar el sistema
```
Para ejecutarlo, he utilizado el comando `ansible-playbook configurar_servidor.yml -K` para que me solicite la password SSH de la máquina esclava y poder acceder mostrando lo siguiente:

![Captura sobre el código](../../datos/Ejercicio01/play%20book%20uno.png)

Comprobar que funciona en la máquina esclava con el comando `apache2 -v`:

![Captura sobre el código](../../datos/Ejercicio01/comprobar%20apache%202.png)

Comprobar que funciona en la máquina maestra con `asible nodo1 -m command -a "systemctl status apache2" -K` el cual muestra el estado de apache2 en la máquina esclava. Este comando ejecutará systemctl status apache2 en el nodo1 y te pedirá la contraseña de sudo para poder obtener el estado del servicio Apache2:

![Captura sobre el código](../../datos/Ejercicio01/ver%20apache%20dos%20con%20asible.png)


## Paso 5: Playbook 2
5.- Crea un playbook llamado `guardar_fecha.yml` que realice las siguientes acciones:
- **Guardar la fecha actual** en un archivo llamado `/tmp/fechahora.data`.
   Este playbook se ejecutará únicamente en el nodo2

Para la creación del Playbook 1 he utilizado el comando `touch` y luego he editado el archivo con `nano` para agregar los siguientes datos:

```bash
---
- name: Guardar la fecha actual en /tmp/fechahora.data # Proporciona una descripción de la tarea
  hosts: nodo2 # Indica el nombre del host que se va a ejecutar la tarea
  tasks:
    - name: Guardar la fecha actual en un archivo # Proporciona una descripción de la tarea
      command: date > /tmp/fechahora.data # Ejecuta el comando date y redirige la salida a /tmp/fechahora
```
Para ejecutarlo, he utilizado el comando `ansible-playbook guardar_fecha -K` para que me solicite la password SSH de la máquina esclava y poder acceder mostrando lo siguiente:

![Captura sobre el código](../../datos/Ejercicio01/ejecucion%20del%20guardar%20fecha.png)

Una vez ejecutado el playbook, se puede verificar el contenido del archivo `/tmp/fechahora.data` en la máquina esclava:

![Captura sobre el código](../../datos/Ejercicio01/ver%20que%20se%20ha%20creado%20la%20fecha.png)



## Paso 6: Ejecutar el Playbook
6.- Ejecuta el playbook para cada nodo desde la shell

```sh
ansible-playbook configurar_servidor.yml
ansible-playbook guardar_fecha.yml