# Ejercicio 8

1. Instalación de un Rol de MySQL

- Instala el rol de mysql en tus máquinas. Puedes optar por:
  - Crear tu propio rol de MySQL.
  - Descargar un rol existente desde Ansible Galaxy.
  
Es obligatorio incluir la definición completa del rol, mostrando su estructura, las variables utilizadas, y las tareas principales.


## Solución ##

Iniciamos creando el rol de MySQL. Para ello, creamos usamos el comando `ansible-galaxy init mysql_role` para crear la estructura básica del rol. Esta nos dará una estructura como la siguiente:

```plaintext
mysql_role/
├── defaults/
│   └── main.yml       # Variables predeterminadas
├── files/             # Archivos estáticos (vacío para este ejemplo)
├── handlers/
│   └── main.yml       # Manejadores para reiniciar o recargar servicios
├── meta/
│   └── main.yml       # Metadatos del rol
├── tasks/
│   └── main.yml       # Tareas principales
├── templates/         # Plantillas (vacío para este ejemplo)
├── tests/
│   ├── inventory      # Inventario de prueba
│   └── test.yml       # Playbook de prueba
├── vars/
│   └── main.yml       # Variables específicas
```
La carpeta default contiene la configuración predeterminada del rol. En este caso, creamos un archivo `main` para definir las variables que se utilizarán en el rol.

```bash
  mysql_root_password: "RootSecure123!"
  mysql_databases:
    - name: employee_db
  mysql_users:
    - name: hr_user
      password: "HRUserPass123!"
      priv: "employee_db.*:ALL"
```
En este archivo, definimos tres variables: `mysql_root_password`, `mysql_databases` y `mysql_users`. Estas variables se utilizarán en las tareas del rol. `mysql_root_password` es la contraseña del usuario root de MySQL. `mysql_databases` es una lista de bases de datos que se crearán. `mysql_users` es una lista de usuarios que se crearán y a qué bases de datos tendrán acceso. el comando `priv` define los permisos que tendrá el usuario.

Tras la definición de las variables por defecto nos encontramos con la carpeta `file` que es donde se almacenan los archivos estáticos que se pueden utilizar en el rol. En este caso, no se utilizarán archivos estáticos.

En tercer lugar está las carpeta de `handlers` que es donde se almacenan los manejadores de eventos. En este caso, se utilizará un manejador para reiniciar el servicio de MySQL. El archivo `main.yml` contiene el siguiente contenido:

```bash
  - name: Reiniciar MySQL
    service:
      name: mysql
      state: restarted
```
En cuarto lugar, la carpeta `meta` que es donde se almacenan los metadatos del rol. En este caso, se utilizará un archivo `main.yml` para definir la información del rol que existe por defecto solo modificando el nombre y el papel del rol.

En quinto lugar, la carpeta `tasks` que es donde se almacenan las tareas que se pueden realizar en el rol. Concretando al caso, se utilizarán varias tareas para crear la base de datos, el usuario y la contraseña. El archivo `main.yml` contiene el siguiente contenido:

```bash
  # Instalar paquetes de MySQL
  - name: Instalar paquetes de MySQL  # Nombre de la tarea para instalar los paquetes necesarios de MySQL.
    apt:  # Módulo utilizado para gestionar paquetes en sistemas basados en Debian/Ubuntu.
      name: "{{ item }}"  # Especifica el paquete a instalar. Será iterado por cada elemento en el loop.
      state: present  # Asegura que los paquetes estén instalados (presentes en el sistema).
    loop:  # Itera sobre los siguientes paquetes:
      - mysql-server  # Paquete principal del servidor MySQL.
      - mysql-client  # Paquete para interactuar con el servidor MySQL desde la línea de comandos.
      - python3-mysqldb  # Librería de Python para interactuar con MySQL.
    become: true  # Escala privilegios para ejecutar la tarea como superusuario.

  # Iniciar y habilitar el servicio MySQL
  - name: Iniciar y habilitar el servicio MySQL  # Nombre de la tarea para gestionar el servicio MySQL.
    service:  # Módulo utilizado para gestionar servicios en el sistema.
      name: mysql  # Especifica el servicio que se va a gestionar (MySQL).
      state: started  # Asegura que el servicio esté en ejecución.
      enabled: true  # Asegura que el servicio se habilite para iniciarse automáticamente al arrancar el sistema.

  # Configurar la contraseña del usuario root
  - name: Configurar la contraseña del usuario root  # Nombre de la tarea para establecer la contraseña del usuario root.
    command: >  # Usa el módulo `command` para ejecutar un comando de shell.
      mysqladmin -u root password "{{ mysql_root_password }}"  # Comando para establecer la contraseña de root.
    args:  # Argumentos adicionales para el comando.
      creates: /root/.mysql_password_set  # Este archivo actúa como marcador para evitar que la tarea se ejecute repetidamente.
    become: true  # Escala privilegios para ejecutar la tarea como superusuario.

  # Crear las bases de datos
  - name: Crear bases de datos  # Nombre de la tarea para crear las bases de datos.
    mysql_db:  # Módulo utilizado para gestionar bases de datos en MySQL.
      name: "{{ item.name }}"  # Nombre de la base de datos que se va a crear, tomada de una lista de datos.
      state: present  # Asegura que la base de datos esté presente (creada si no existe).
    loop: "{{ mysql_databases }}"  # Itera sobre la lista de bases de datos definida en las variables.
    become: true  # Escala privilegios para ejecutar la tarea como superusuario.

  # Crear los usuarios
  - name: Crear usuarios de MySQL  # Nombre de la tarea para crear usuarios de MySQL.
    mysql_user:  # Módulo utilizado para gestionar usuarios en MySQL.
      name: "{{ item.name }}"  # Nombre del usuario a crear, tomado de una lista de datos.
      password: "{{ item.password }}"  # Contraseña del usuario.
      priv: "{{ item.priv }}"  # Privilegios asignados al usuario en formato "base_de_datos.tabla:privilegios".
      state: present  # Asegura que el usuario esté presente (creado si no existe).
    loop: "{{ mysql_users }}"  # Itera sobre la lista de usuarios definida en las variables.
    become: true  # Escala privilegios para ejecutar la tarea como superusuario.
```
Como se observa, se han definido varias tareas para instalar los paquetes necesarios, iniciar y habilitar el servicio MySQL, configurar la contraseña del usuario root, crear las bases de datos y crear los usuarios de MySQL. Cada tarea se ejecuta en un orden específico para asegurar que los pasos se realicen de manera correcta. Por ejemplo, se instalan los paquetes necesarios para MySQL antes de iniciar el servicio, y se configura la contraseña del usuario root antes de crear las bases de datos y los usuarios. 

Las dos últimas carpetas son los `tests` y `vars`. La carpeta `tests` contiene los archivos de prueba para el rol, mientras que la carpeta `vars` contiene las variables que se pueden utilizar en el rol. En este caso, se han definido las variables `mysql_root_password`, `mysql_databases` y `mysql_users` para almacenar la contraseña del usuario root, las bases de datos y los usuarios que se van a crear, respectivamente en la propia carpeta `default`. Estas variables se pueden utilizar en las tareas para obtener los valores necesarios para la configuración de MySQL. En el caso de añadir variables idénticas a las definidas en `default` en otros archivos de la carpeta `vars`, se usarán la de esta última carpeta ya que posee preferencia.

Una vez resumido las carpetas del rol pasamos al inventario y el playbook:

El primero de ellos es el archivo `hosts` y su contenido es:

```bash
  [web]
  #nodo1 ansible_host=192.168.88.97 # IP del nodo 1 en la sede
  nodo1 ansible_host=192.168.18.36 # IP del nodo 1 en mi casa

  [local]
  localhost ansible_connection=local # Conexión local
```
El playbook se llamará `mysql.yml`, que ejecutará en el nodo esclavo el contenido del rol a través de lo siguiente:

```bash
  - hosts: web
    become: true
    roles:
      - mysql_role
```

## Ejecución ##

Ejecutamos el playbook a través del comando `ansible-playbook -i hosts.ini mysql.yml -K` como parámetro:

![Captura sobre el código](../../datos/Ejercicio08/playbook%20mysql.png)

Observamos si se ha configurado todo correctamente con el `sudo systemctl status mysql`:

![Captura sobre el código](../../datos/Ejercicio08/instalado%20mysql.png)

Con `sudo mysql` podemos acceder a la base de datos para modificar el usuario root ya que por defecto mysql nos obliga a dar un root@localhost. Con el fin de modificarlo, ejecutamos `ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'contraseña';`. Añadimos la contraseña de las variables y ya podremos entrar sin problemas.

![Captura sobre el código](../../datos/Ejercicio08/cambio%20de%20contraseña.png)

Usamos el root para realizar varias pruebas como se puede observar:

![Captura sobre el código](../../datos/Ejercicio08/pruebas%20de%20tablas%20bases%20de%20datos.png)

Probamos el usuario que ha sido creado antes en las tareas de rol:

![Captura sobre el código](../../datos/Ejercicio08/comandos%20de%20usuarios.png)

