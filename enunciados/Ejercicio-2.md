# Ejercicio 2: Variables y Facts en Ansible

## Paso 1: Parametrizar Valores con un Fichero de Variables

1. Crea un fichero de variables llamado `firewall_vars.yml`.
   - Define las variables necesarias para configurar el firewall, como servicios, puertos, direcciones IP y zonas.
2. Crea un playbook llamado `configurar_firewall.yml` que utilice las variables definidas en el fichero `firewall_vars.yml` para configurar el firewall.

    ```yaml
    - name: Configurar firewall
      hosts: web
      tasks:

      - firewalld:
        service: https
        permanent: true
        state: enable
      
      - firewalld:
          port: 8081/tcp    
          permanent: true
          state: disable

      - firewalld:
          port: 161-162/udp    
          permanent: true
          state: disable

      - firewalld:
          source: 192.168.20.0/24   
          zone: internal
          state: enable
    ```
    
## Paso 2: Definir un Playbook que Solicite el Entorno de Despliegue

1. Crea tres ficheros de variables (`dev.yml`, `pre.yml`, `pro.yml`) que contengan las configuraciones específicas para cada entorno.
2. Crea un playbook que solicite al usuario el entorno de despliegue (`dev`, `pre`, `pro`) y cargue las variables correspondientes desde el fichero adecuado.

## Paso 3: Obtener Información del Sistema

1. Utiliza la [documentación de Ansible](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/hostname_module.html) para obtener los valores `os family`, `hostname` e `ipv4` de tu máquina local y de un nodo remoto.
2. Crea un playbook llamado `obtener_info_sistema.yml` que obtenga y muestre estos valores.

## Paso 4: Usar el Módulo `setup` para Obtener la IPv6

1. Usa el módulo `setup` de Ansible en un comando ad-hoc para obtener la IPv6 del nodo remoto.
2. Almacena el resultado en un fichero.
3. Realiza todo esto en un único comando.

## Paso 5: Crear un Fact Personalizado

1. Crea un fact personalizado que permita obtener variables específicas del nodo remoto.
2. Consulta la [documentación sobre facts personalizados](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html) para aprender cómo hacerlo.
3. Crea un playbook que defina y utilice este fact personalizado.