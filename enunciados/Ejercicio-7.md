
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