# Ejercicios 6

Realiza una validación de cada una de las tareas de este ejercicio: (check mode a priori y diff mode)
[Documentación](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html)

1.- Gestionar Servicios Web con Ansible (con Apache2)
  - Crea una lista llamada web_service que contenga los servicios ``httpd``(este caso será `Apache2`) y ``vsftpd``.
  - Luego, escribe una tarea que verifique si cada uno de estos servicios está activo, usando un bucle que recorra los elementos de la lista.

```bash
- name: Gestionar Servicios Web con Ansible
  hosts: web
  become: yes
  vars:
    web_service: # Servicio web a gestionar, lista de elementos
    - apache2
    - vsftpd  
  tasks:
    - name: Verificar si los servicios están activos # Verificar si los servicios están activos
      service: # Verificar si los servicios están activos
        name: "{{ item }}" # Servicio a verificar individual
        state: started # Estado del servicio
      loop: "{{ web_service }}" # Bucle para iterar sobre la lista de servicios
      register: service_status # Registrar el resultado en una variable

    - name: Mostrar el estado de los servicios
      debug: 
        msg: "El servicio {{ item.name }} está {{ item.state }}" # Mostrar el estado de cada servicio
      loop: "{{ service_status.results }}" # Bucle para iterar sobre el resultado de la tarea anterior
```

Con este playbook creamos una variable llamada `web_service` que contiene una lista de servicios web a gestionar. Luego, creamos una tarea que utiliza un bucle `loop` para iterar sobre cada elemento de la lista `web_service`. En cada iteración, la tarea verifica el estado de cada servicio utilizando el módulo `service` y registra el resultado en una variable llamada `service_status`. Finalmente, creamos otra tarea que utiliza un bucle `loop` para iterar sobre el resultado de la tarea anterior y mostrar el estado de cada servicio. Para ejecutarlo, usamos el comando `ansible-playbook -i hosts.ini paso_1.yml -K` y para verificar el estado de los servicios, usamos el comando `ansible-playbook -i hosts.ini paso_1.yml -K --check`.

![Captura sobre el código](../../datos/Ejercicio06/paso%201%20mostrar%20variables.png)

![Captura sobre el código](../../datos/Ejercicio06/paso%201%20check.png)


2.- Validar Instalación de Paquetes
  - Escribe un playbook que verifique si los siguientes paquetes están instalados en el sistema: ``apache2``, ``vim``, ``nginx``, y ``filebeat``.
  - Si alguno de estos paquetes no está instalado, la tarea debe devolver un mensaje indicando cuál falta.

  Se crea el playbook con el siguiente código:

 ```bash
 - name: Verificar paquetes instalados
  hosts: web
  become: yes
  vars:
    paquetes:
      - apache2
      - vim
      - nginx
      - filebeat

  tasks:
    - name: Obtener información de los paquetes instalados
      package_facts: # modulo a usar
        manager: "auto" # Se utiliza el gestor de paquetes por defecto

    - name: Verificar si los paquetes están instalados
      debug:
        msg: "El paquete {{ item }} está {{ 'instalado' if item in ansible_facts.packages else 'no instalado' }}" # mensaje a mostrar
      loop: "{{ paquetes }}" # iterar sobre la lista de paquetes
 ```
 En este apartado, he creado un playbook llamado `paso_2.yml` que utiliza el módulo `package_facts` para obtener la lista de paquetes instalados en el sistema poseyendo `manager` el valor `"auto"` para utilizar el gestor de paquetes por defecto. Luego, he creado una tarea que utiliza un bucle `loop` para iterar sobre la lista de paquetes `paquetes` y verificar si cada paquete está instalado en el sistema. Si un paquete no está instalado, la tarea muestra un mensaje indicando cuál falta. Para ejecutarlo, usamos el comando `ansible-playbook -i hosts.ini paso_2.yml -K`. Para verificarlo solo debemos añadir `--check` al comando anterior.

 ![Captura sobre el código](../../datos/Ejercicio06/paso%202%20comando%20y%20check.png)
 
3.- Buscar Archivos de Gran Tamaño
  - Escribe un playbook que realice una búsqueda recursiva desde el directorio raíz ``/`` y encuentre archivos que sean mayores a 100 MB.

Creamos el siguiente playbook llamado `paso_3.yml`:

```bash
- name: Verificar paquetes instalados
  hosts: web
  become: yes
  tasks:
    - name: Búsqueda archivos 
      find:
        path: / # Busca en la raíz del sistema
        recurse: yes # Busca en subdirectorios
        size: 100M # Busca archivos mayores a 100MB
      register: archivos # Almacena los resultados en una variable
    - name: Mostrar archivos encontrados 
      debug: # Muestra los resultados en pantalla
        var: archivos.files # Muestra la lista de archivos encontrados
```
En este apartado, el playbook `paso_3.yml` utiliza el módulo `find` para buscar archivos en el directorio raíz ``/`` y en subdirectorios, con un tamaño mayor a 100 MB. Los resultados se almacenan en una variable llamada `archivos`. Luego, se muestra la lista de archivos encontrados en pantalla. Para ejecutarlo, usamos el comando `ansible-playbook -i hosts.ini paso_3.yml -K`. Para verificarlo solo debemos añadir `--check` al comando anterior.

 ![Captura sobre el código](../../datos/Ejercicio06/pase%203%20comando%20y%20check.png)


4.- Búsqueda Avanzada con Expresiones Regulares
  - En este ejercicio, debes buscar archivos en el directorio ``/var/log`` que cumplan con las siguientes condiciones:
  - El nombre del archivo comienza con una letra minúscula (de la a a la z).
  - El nombre contiene un guion bajo (_).
  - El archivo termina con la extensión .log.
**Utiliza expresiones regulares para realizar la búsqueda y muestra los archivos que cumplan con todos los criterios.**

  Antes de mostrar el playbook de este apartado, decidí crear un archivo en la carpeta que cumpla todo los requisitos, ya que de por sí no existe ninguno. Tras esto, voy a mostrar el playbook llamado `paso_4.yml`realizado para este caso:

  ```bash
  - name: Buscar archivos que comiencen con letras minúsculas
  hosts: web
  become: yes
  tasks:
    - name: Encontrar archivos que comiencen con letras minúsculas
      find:
        paths: /var/log # Ruta donde se buscarán los archivos
        recurse: no # No buscar en subdirectorios
        use_regex: yes # Utilizar expresiones regulares
        patterns: '^[a-z]*_.*\.log' # Expresión regular donde cumplimos los requisitos
      register: archivos_minusculas # Guardar los resultados en una variable

    - name: Extraer nombres de archivos
      set_fact:
         nombres_archivos: "{{ archivos_minusculas.files | map(attribute='path') | map('basename') | list }}" # Extraer los nombres de los archivos

    - name: Mostrar nombres de archivos encontrados
      debug:
        var: nombres_archivos # Mostrar los nombres de los archivos encontrados
  ```
  En este apartado, el playbook `paso_4.yml` utiliza el módulo `find` para buscar archivos en el directorio ``/var/log`` que cumplan con las condiciones dadas (empiece por una letra minúscula, contenga un guion bajo y termine con la extensión log) con la expresión regular `^[a-z]*_.*\.log`. Los resultados se almacenan en una variable llamada `archivos_minusculas`. Luego, se extraen los nombres de los archivos encontrados a través de la variable `nombres_archivos` y se muestran en pantalla. Para ejecutarlo, usamos el comando `ansible-playbook -i hosts.ini paso_4.yml -K`. Para verificarlo solo debemos añadir `--check` al comando anterior.

  ![Captura sobre el código](../../datos/Ejercicio06/paso%204%20check.png)