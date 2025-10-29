# Ejercicio 9

1. Crear un archivo de secretos
  - Crea un archivo llamado ``missecretos.yml`` que contenga dos variables:
    - ``miuser``: para almacenar un nombre de usuario.
    - ``micontra``: para almacenar una contraseña.

2. Cifrar con Ansible Vault
  - Utiliza Ansible Vault para cifrar el archivo ``missecretos.yml`` y proteger el contenido de las variables.

3. Crear un Playbook
  - Escribe un playbook que:
    - Incluya el archivo cifrado ``missecretos.yml``.
    - Tenga una tarea que muestre el valor de las variables ``miuser`` y ``micontra`` en la salida.
  
4. Ejecutar el Playbook
  - Ejecuta el playbook, asegurándote de que Ansible Vault solicite la contraseña de desencriptación y muestre los valores correctos de las variables.
