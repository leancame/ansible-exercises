
# Ejercicio 7: Proyecto de Migración de Scripts Bash a Ansible

## Enunciado

En este ejercicio, se te proporcionan dos scripts de Bash sencillos. El objetivo es migrarlos a Ansible utilizando roles y variables de inventario para manejar configuraciones diferentes para entornos de desarrollo (Dev) y producción (Prod).

### Scripts en Bash:

1. **Script para Desarrollo (`dev_setup.sh`):**
   - Instala Git y clona un repositorio.

   ```bash
   #!/bin/bash

   # Instalar Git
   sudo apt-get update
   sudo apt-get install -y git

   # Clonar un repositorio de ejemplo
   git clone [repo de ejemplo] /home/user/dev-repo
   ```

2. **Script para Producción (`prod_setup.sh`):**
   - Instala Nginx y configura un archivo HTML simple.

   ```bash
   #!/bin/bash

   # Instalar Nginx
   sudo apt-get update
   sudo apt-get install -y nginx

   # Crear un archivo index.html simple
   echo "<html><body><h1>Welcome to Production!</h1></body></html>" | sudo tee /var/www/html/index.html
   ```

## Requisitos
## Estructura del Proyecto:
Debes organizar tu proyecto de Ansible de tal manera que las variables necesarias sean detectadas automáticamente sin necesidad de ser importadas manualmente en cada playbook del rol. Esto se logra utilizando la estructura de directorios ``group_vars`` y ``host_vars`` adecuadamente.

## Pruebas Locales:

Primero, prueba la ejecución en local.
Utiliza el parámetro ``--limit`` para limitar la ejecución del playbook a un solo entorno (Dev o Prod). Esto se hace añadiendo el nombre del host que hayas definido en el inventario.

## Pruebas Remotas:

Configura un inventario que apunte a hosts remotos (puedes usar una máquina virtual o VM para esta prueba).

Asegúrate de que la conexión se realiza correctamente vía SSH.

## Ejecución Condicional:

En el playbook principal, el rol de producción (``prod_rol``) solo se debe ejecutar si el rol de desarrollo (``dev_rol``) se ha ejecutado con éxito.

Además, cada rol solo debe ejecutarse si el host correspondiente está definido en el inventario.

## Diagrama de flujo de ejecución
``` sh
+-----------------------------+
|   dev_rol                   |
| (Si el host contiene 'dev') |
| --> Si cumple la condición  |
|     se ejecuta el rol de    |
|     dev y si es exitoso,    |
|     se guarda el resultado  |
+-----------------------------+ 
             |
             |
             v
+-----------------------------+
|   prod_rol                  |
| (Si el host contiene 'prod' |
|  y dev_rol fue exitoso)     |
| --> Entonces se ejecuta     |
|     prod_rol                |
+-----------------------------+   
``` 
### Recursos adicionales

- Documentación sobre la estructura de roles en Ansible:
  https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html

- Documentación sobre variables en Ansible:
  https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#group-variables

- Cómo limitar la ejecución a hosts específicos en Ansible:
  https://docs.ansible.com/ansible/latest/user_guide/intro_patterns.html#limiting-playbook-execution-with-tags-and-host-patterns

- Configuración de inventarios en Ansible:
  https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html

- Configuración de SSH para Ansible:
  https://docs.ansible.com/ansible/latest/user_guide/connection_details.html

- Ejecución condicional de tareas en Ansible:
  https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html

- Uso de `register` para registrar el estado de las tareas:
  https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html#id5




## Respuesta:

Al ser un ejercicio muy largo prefiero explicarlo todo junto y desarrollado:

1.- **Configuración de archivos**

  Antes de realizar cualquier comando o ejecución debemos estipular y configurar los archivos necesarios para la ejecución de Ansible. En este caso, debemos crear un archivo de inventario llamado `hosts.ini` y un archivo de playbook llamado `prueba.yml`. Además debemos usar variables de grupos y de host (en mi caso solo me ha sido necesario las de grupo ya que las de host las veía repetitivas). Por supuesto, debemos tener un archivo de roles llamado `dev_rol` y otro llamado `prod_rol` que contengan las tareas que se deben realizar en cada rol. Con todo ello vamos a mostrar aquellos archivos que hemos creado y que son necesarios para la ejecución de Ansible. Si es verdad que los roles los he creado con el comando `ansible-galaxy init dev_rol` y `ansible-galaxy init prod_rol` creando toda la estructura correspondiente.

  ![Captura sobre el código](../../datos/Ejercicio07/crear%20roles%20galaxy.png)

  El archivo `hosts.ini` es el siguiente:
   ```bash
    [prod]
    # nodo1 ansible_host=192.168.88.97 # IP del nodo 1 en la sede
    nodo1 ansible_host=192.168.18.36 # IP del nodo 1 en mi casa

    [dev]
    localhost ansible_connection=local # Conexión local
   ```
  El archivo de variables grupales `group_vars/dev.yml`  y `group_vars/prod.yml` son los siguientes. Cabe decir que para clonar el repositorio he hecho un token que caduca en una fecha concreta. En un caso normal habría que cifrar todo:

  ```bash
  repo_url: "https://token/stemdo-labs/docker-exercises-lcarbajomendez.git"
  dev_repo_path: "/home/lcarbajo/dev-repo"
  ```

  ```bash
  welcome_message: "<html><body><h1>Welcome to Production!</h1></body></html>"
  nginx_index_path: "/var/www/html/index.html"
  ```
  En cada rol debemos señalar que tarea debe de hacer, es decir, el dev configurará Git y clonará el repositorio. Por otro lado, prod gestionará el servicio de Nginx y creará un archivo de bienvenida. Son las siguientes tareas:

  Dev
  ```bash
  - name: Ensure Git is installed
    apt:
      name: git
      state: present
      update_cache: yes

  - name: Clone the repository
    git:
      repo: "{{ repo_url }}"
      dest: "{{ dev_repo_path }}"
  ```
  Prod
  ```bash
  - name: Ensure Nginx is installed
    apt:
      name: nginx
      state: present
      update_cache: yes

  - name: Create the index.html file
    copy:
      content: "{{ welcome_message }}"
      dest: "{{ nginx_index_path }}"
  ```
  Este es el contenido del playbook:

  ```bash
    - hosts: dev
    become: yes
    tasks:
      # Tarea para ejecutar el rol de desarrollo en los hosts de desarrollo
      - name: Ejecutar el rol de desarrollo
        include_role:
          name: dev_rol  # Especifica el rol a incluir
        register: dev_result  # Registra el resultado de la ejecución del rol en la variable dev_result

      # Tarea para establecer el resultado del rol como una variable global
      - name: Establecer resultado del rol de desarrollo como global
        set_fact:
          dev_result_global: >  # Define una variable global basada en el resultado del rol
            {{
              dev_result |  # Toma el resultado registrado
              combine({'failed': dev_result is failed}) |  # Combina con un indicador de fallo
              default({'failed': true})  # Si no hay resultado, marca como fallo
            }}

      # Tarea para agregar la variable global a los datos del host localhost
      - name: Guardar resultado global en localhost
        add_host:
          name: "localhost"  # Especifica localhost como el host de destino
          dev_result_global: "{{ dev_result_global }}"  # Asigna la variable global al host

      # Tarea para depurar y mostrar el valor de la variable global
      - name: Depurar resultado global
        debug:
          var: dev_result_global  # Muestra el contenido de dev_result_global para propósitos de depuración

      # Tarea para verificar si el rol de desarrollo falló y generar un error si es necesario
      - name: Verificar éxito del rol de desarrollo
        fail:
          msg: "El rol dev_rol falló."  # Mensaje de error si el rol falló
        when: dev_result_global.failed  # Condición para fallar si el resultado indica fallo

  - hosts: prod
    become: yes
    tasks:
      # Tarea para depurar el resultado global desde el host localhost
      - name: Verificar resultado global
        debug:
          var: hostvars['localhost']['dev_result_global']  # Muestra el valor del resultado global del host localhost

      # Tarea para ejecutar el rol de producción solo si el rol de desarrollo no falló
      - name: Ejecutar el rol de producción
        include_role:
          name: prod_rol  # Especifica el rol de producción a ejecutar
        when: not hostvars['localhost']['dev_result_global']['failed']  # Condición para ejecutar solo si el resultado global no indica fallo
  ```
  Este playbook utiliza Ansible para ejecutar roles de desarrollo y producción en hosts de desarrollo y producción, respectivamente. El rol de desarrollo se ejecuta en los hosts de desarrollo y el resultado se registra en una variable global. Luego, el rol de producción se ejecuta en el host de producción solo si el rol de desarrollo no falló. El playbook también incluye tareas para depurar y mostrar el valor de la variable global. Si el rol de desarrollo falla, el playbook generará un error. La variable global se utiliza para compartir el resultado del rol de desarrollo entre los hosts de desarrollo y producción. El playbook utiliza la función `hostvars` para acceder a la variable global del host localhost desde el host de producción. La condición `when` se utiliza para ejecutar el rol de producción solo si el resultado global no indica fallo. El playbook utiliza la función `debug` para depurar y mostrar el valor de la variable global. Se usa la función `fail` para generar un error si el rol de desarrollo falla. También, utilizamos `include_role` para ejecutar los roles de desarrollo y producción . El `set_fact` para establecer la variable global, `add_host` para agregar la variable global al host localhost, `register` para registrar el resultado del rol de desarrollo y la función `combine` para combinar el resultado del rol con un indicador de fallo.

2.- **Ejecución**

Para la ejecución, se nos pide primero en local limitado y otro en un nodo externo:

Para limitarlo en local, ejecuté el comando `ansible-playbook prueba.yml -i inventory/hosts.ini --limit dev -k` en la terminal. El playbook se ejecutó en los hosts de desarrollo y mostró el resultado del rol de desarrollo.

![Captura sobre el código](../../datos/Ejercicio07/ejecucion%20al%20dev.png)

Como se observa, la parte dev funciona correctamente instalando Git y clonando el repositorio. La parte de prod se la salta al centrarse solo en la de desarrollo por el comando `--limit dev`.

![Captura sobre el código](../../datos/Ejercicio07/repositorio%20clonado.png)

Tras la ejecución solamente del rol de desarrollo, pasamos a la ejecución total. Para ello, ejecuté el comando `ansible-playbook prueba.yml -i inventory/hosts.ini -k` en la terminal. El playbook se ejecutó en los hosts de desarrollo y producción y mostró el resultado del rol de desarrollo y producción. En este caso observaremos que el rol de producción se ejecutó correctamente la instalación de Nginx que ya estaba instalado y crear el index.

![Captura sobre el código](../../datos/Ejercicio07/global%201.png)
![Captura sobre el código](../../datos/Ejercicio07/global%202.png)

Aquí podemos ver la prueba de funcionamiento con `sudo systemctl status nginx` y `curl http://localhost` para verificar que el servicio está funcionando correctamente.

![Captura sobre el código](../../datos/Ejercicio07/produciion%20correcta.png)







