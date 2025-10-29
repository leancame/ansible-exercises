# Ejercicios 6

Realiza una validación de cada una de las tareas de este ejercicio:
[Documentación](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_checkmode.html)

1. Gestionar Servicios Web con Ansible (con Apache2)
  - Crea una lista llamada web_service que contenga los servicios ``httpd`` y ``vsftpd``.
  - Luego, escribe una tarea que verifique si cada uno de estos servicios está activo, usando un bucle que recorra los elementos de la lista.

2. Validar Instalación de Paquetes
  - Escribe un playbook que verifique si los siguientes paquetes están instalados en el sistema: ``apache2``, ``vim``, ``nginx``, y ``filebeat``.
  - Si alguno de estos paquetes no está instalado, la tarea debe devolver un mensaje indicando cuál falta.
 
3. Buscar Archivos de Gran Tamaño
  - Escribe un playbook que realice una búsqueda recursiva desde el directorio raíz ``/`` y encuentre archivos que sean mayores a 100 MB.

4. Búsqueda Avanzada con Expresiones Regulares
  - En este ejercicio, debes buscar archivos en el directorio ``/var/log`` que cumplan con las siguientes condiciones:
  - El nombre del archivo comienza con una letra minúscula (de la a a la z).
  - El nombre contiene un guion bajo (_).
  - El archivo termina con la extensión .log.
**Utiliza expresiones regulares para realizar la búsqueda y muestra los archivos que cumplan con todos los criterios.**


