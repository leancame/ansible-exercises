# Ejercicio 4

1. Manejo de Errores Basado en Distribución
  - Partiendo del siguiente playbook que instala ``git`` tanto en Ubuntu como en CentOS, escribe un nuevo playbook que gestione los posibles errores en función de la distribución del sistema operativo.
  - Aunque sabemos que normalmente se usarían condicionales para este tipo de situaciones, en este ejercicio no se deben usar condicionales (``when``). En su lugar, utiliza bloques (``block``), manejo de errores (``rescue``) o siempre ejecutado (``always``) para gestionar los posibles errores.

    ```yaml
    - name: ejercicio
    hosts: all
    tasks:
        - name: instala en ubuntu
        apt:
            name: git
            state: present
        - name: instala en centos
        yum: 
            name: git
            state: present
    ```

    ```bash
    - name: ejercicio # nombre del ejercicio
      hosts: web # nombre del grupo de hosts
      become: yes # permisos de superusuario
      tasks: # lista de tareas a realizar
          - name: instala git en ubuntu 
            block: # bloque de tareas
              - apt: # tarea de instalación de paquetes
                  name: git # nombre del paquete a instalar
                  state: present # estado del paquete (presente o ausente)
            rescue: # bloque de tareas de rescate
              - name: manejar error en ubuntu 
                debug: # tarea de depuración
                  msg: "Error al instalar git en Ubuntu" # mensaje de error
            always: # bloque de tareas siempre que se ejecute la tarea
              - name: siempre ejecutado en ubuntu
                debug: # tarea de depuración
                  msg: "Intento de instalación de git en Ubuntu completado" # mensaje de depuración

          - name: intenta leer un archivo en una ruta inexistente
            block: # bloque de tareas
              - command: cat /ruta/inexistente/archivo.txt # tarea de lectura de archivo inexistente 
            rescue: # bloque de tareas de rescate
              - name: manejar error en centos
                debug: # tarea de depuración
                  msg: "Error al intentar leer el archivo en CentOS" # mensaje de error
            always: # bloque de tareas siempre que se ejecute la tarea
              - name: siempre ejecutado en centos 
                debug: # tarea de depuración
                  msg: "Intento de lectura del archivo en CentOS completado" # mensaje de depuración
    ```

    En el nuevo playbook, he decidido utilizar bloques para gestionar los posibles errores. En el `block` de la tarea de instalación de `git` en Ubuntu, si se produce un error, se ejecutará el bloque de rescate, que mostrará un mensaje de error. Luego, siempre que se ejecute la tarea, se ejecutará el bloque `always`, que mostrará un mensaje de depuración. De manera similar, en el `block` de la tarea de lectura de archivo inexistente en CentOS, si se produce un error, se ejecutará el bloque de rescate, que mostrará un mensaje de error. Luego, siempre que se ejecute la tarea, se ejecutará el bloque `always`, que mostrará un mensaje de depuración.

    Para su funcionamiento, ejecutaremos el comando `ansible-playbook -i hosts.ini manejo_errores.yml -K` en la terminal. El playbook se ejecutará en el nodo1 que es una máquina esclava y mostrará error en la ruta inexistente y los mensajes de depuración en el bloque `always`.

    ![Captura sobre el código](../../datos/Ejercicio04/parte%201%20errores%20block.png)

    Mostramos como se instaló correctamente `git` con el comando `git --version` observando que poseemos una versión de `git` instalada en la máquina esclava.

    ![Captura sobre el código](../../datos/Ejercicio04/git%20instalado.png)


2. Esperar a la Eliminación de un Archivo

  - Usa la estructura wait_for de Ansible para que el playbook espere hasta que un archivo específico (por ejemplo, bloqueo.lock, o un archivo que elijas) deje de existir en la máquina remota.
  - Una vez que el archivo haya sido eliminado, ejecuta una tarea que muestre un mensaje de éxito o confirmación.
  - Puedes eliminar el archivo manualmente o por otro método a tu elección.

    En primer lugar, he creado el archivo en el escritorio de la máquina esclava denominado bloqueo.lock. Luego, he creado un playbook que utiliza la estructura `wait_for` de Ansible para esperar a que el archivo bloqueo.lock deje de existir en la máquina remota. Una vez que el archivo haya sido eliminado, el playbook ejecutará una tarea que muestra un mensaje de éxito o confirmación. En este supuesto, el término `state` es igual a `absent` para indicar que el archivo debe ser eliminado. Para que funcionará prober a no eliminarlo y finalmente una saegunda prueba eliminando el archivo de forma manual.

    El playbook es el siguiente:

    ```bash
    - name: Esperar a la eliminación de un archivo
      hosts: web
      become: yes
      tasks:
        - name: Esperar a que el archivo bloqueo.lock sea eliminado
          wait_for: # Esperar a que el archivo bloqueo.lock sea eliminado
            path: /home/lcarbajo/Escritorio/bloqueo.lock # Ruta del archivo
            state: absent # Estado que se espera hasta que se elimine
            timeout: 40 # Espera 40 segundo

        - name: Mostrar mensaje de éxito
          debug: # Mostrar mensaje de éxito
            msg: "El archivo bloqueo.lock ha sido eliminado exitosamente" # Mensaje de éxito
    ```

    Para su funcionamiento, ejecutaremos el comando `ansible-playbook -i hosts.ini eliminar_archivo.yml -K` en la terminal viendo en este caso lo descrito anteriormente para saber su funcionamiento.

    ![Captura sobre el código](../../datos/Ejercicio04/al%20no%20eliminar%20y%20al%20eliminar.png)

