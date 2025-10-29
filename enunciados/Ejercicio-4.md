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

2. Esperar a la Eliminación de un Archivo
  - Usa la estructura wait_for de Ansible para que el playbook espere hasta que un archivo específico (por ejemplo, bloqueo.lock, o un archivo que elijas) deje de existir en la máquina remota.
  - Una vez que el archivo haya sido eliminado, ejecuta una tarea que muestre un mensaje de éxito o confirmación.
  - Puedes eliminar el archivo manualmente o por otro método a tu elección.
