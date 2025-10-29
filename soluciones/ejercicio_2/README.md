# Ejercicio 2: Variables y Facts en Ansible

## Paso 1: Parametrizar Valores con un Fichero de Variables

1.- Crea un fichero de variables llamado `firewall_vars.yml`.
   - Define las variables necesarias para configurar el firewall, como servicios, puertos, direcciones IP y zonas.

Antes de realizar el fichero, he decidido instalar el firewall, ya que mi máquina no lo posee. Con esa motivación he realizado los siguientes comandos:

```bash
sudo apt install firewalld -y # Instalación del firewall

sudo systemctl start firewalld # Arranque del servicio

sudo firewall-cmd --state # Estado del firewall
```

Tras ello, creamos el archivo `firewall_vars.yml` con los datos oportunos:

```bash
# Define las variables necesarias para configurar el firewall, como servicios, puertos, direcciones IP y zonas.

# Servicios
service: https

#Puertos tcp
tcp: 8081/tcp 

#Puertos udp
udp: 161-162/udp

# Zona
zona: internal

# IP
ip: 192.168.20.0/24

```
Simplemente añadimos a la variable deseada su valor.


2.- Crea un playbook llamado `configurar_firewall.yml` que utilice las variables definidas en el fichero `firewall_vars.yml` para configurar el firewall.

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

    Tras observar el que se nos pasa, he modificado los datos para añadir las variables correspondientes: `service`, `tcp`, `udp`, `zona` y `ip`.

    ```bash
    - name: Configurar firewall
    hosts: web
    vars_files:
        - firewall_vars.yml
    become: yes
    tasks:
        - firewalld:
            service: "{{ service }}"
            permanent: true
            state: enabled

        - firewalld:
            port: "{{ tcp }}"
            permanent: true
            state: disabled

        - firewalld:
            port: "{{ udp }}"
            permanent: true
            state: disabled

        - firewalld:
            source: "{{ ip }}"
            zone: "{{ zona }}"
            state: enabled
            permanent: true
    ```


Para llegar a este archivo, lo he ido moficicando conforme a los errores que me han ocurrido:

`fatal: [nodo1]: FAILED! => {"changed": false, "msg": "value of state must be one of: absent, disabled, enabled, present, got: enable"}`

En este caso he tenido que modificar el estado de la tarea a `enabled` en lugar de `enable` o `disabled` por `disable`.


`fatal: [nodo1]: FAILED! => {"changed": false, "msg": "ERROR: Exception caught: org.fedoraproject.slip.dbus.service.PolKit.NotAuthorizedException.org.fedoraproject.FirewallD1.config: "}`

En el segundo supuesto el error PolKit.NotAuthorizedException indica que el comando necesita privilegios elevados añadiendo `become: yes`

`fatal: [nodo1]: FAILED! => {"msg": "Missing sudo password"}`

Y por último, solo he realizado el comando añadiendo `-K` el cual me pide la contraseña de sudo para elevar los privilegios durante la ejecución del playbook. Este es el comando:

```bash
ansible-playbook -i hosts.ini configurar_firewall.yml -K
```
![Captura sobre el código](../../datos/Ejercicio02/prueba%20playbook%20apartado%202.png)

Para comprobar si esta el firewall correctamente usé:

```bash
sudo firewall-cmd --reload # para recargar la configuración
sudo firewall-cmd --get-active-zones # para ver las zonas activas
```

![Captura sobre el código](../../datos/Ejercicio02/prueba%20del%20firewall%20en%20maquina%20escalva.png)


## Paso 2: Definir un Playbook que Solicite el Entorno de Despliegue

1.- Crea tres ficheros de variables (`dev.yml`, `pre.yml`, `pro.yml`) que contengan las configuraciones específicas para cada entorno.

2.- Crea un playbook que solicite al usuario el entorno de despliegue (`dev`, `pre`, `pro`) y cargue las variables correspondientes desde el fichero adecuado.

```bash
dev.yml
db_host: dev-lcarbajo@stemdo.io
db_user: dev_LeandroCarbajoMendez
db_password: dev_1111

```
```bash
pre.yml
db_host: pre-lcarbajo@stemdo.io
db_user: pre_LeandroCarbajoMendez
db_password: pre_2222

```
```bash
pro.yml
db_host: pro-lcarbajo@stemdo.io
db_user: pro_LeandroCarbajoMendez
db_password: pro_3333

```
En estos archivos damos el host, el usuario y la contraseña para cada entorno. A raíz de estos archivos vamos a crear un playbook denominado `entorno`:

```bash
- name: Desplegar aplicación # Nombre de la aplicación
  hosts: all # Hosts que se van a conectar
  vars_prompt: # Variables que se van a solicitar
    - name: "entorno" # Nombre
      prompt: "Introduce el entorno de despliegue (dev, pre, pro)" # Mensaje de ayuda
      private: no # Si se debe ocultar la respuesta

  tasks:
    - name: Cargar variables del entorno # Nombre de la tarea
      include_vars: "{{ entorno }}.yml" # Archivo de variables a cargar

    - name: Mostrar variables cargadas # Nombre de la tarea
      debug: # Nombre de la acción
        msg: # Mensaje a mostrar
          - "Entorno: {{ entorno }}"
          - "DB Host: {{ db_host }}"
          - "DB User: {{ db_user }}"
```

Con el comando `ansible-playbook -i hosts.ini entorno.yml -K` se ejecuta el playbook y se solicita el entorno de despliegue. A continuación se muestra el resultado de la ejecución del archivo de variables deseado.

![Captura sobre el código](../../datos/Ejercicio02/ejecucion%20entorno%20dev.png)


## Paso 3: Obtener Información del Sistema

1.- Utiliza la [documentación de Ansible](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/hostname_module.html) para obtener los valores `os family`, `hostname` e `ipv4` de tu máquina local y de un nodo remoto.


El valor `os family` es una variable que nos indica la familia del sistema operativo. El valor `hostname` es el nombre del equipo. El valor `ipv4` es la dirección IP del equipo. Teniendo en cuenta esto

2.- Crea un playbook llamado `obtener_info_sistema.yml` que obtenga y muestre estos valores.

```bash
- name: Obtener información del sistema # Nombre del comando
  hosts: all # Hosts que se van a ejecutar el comando
  gather_facts: yes # Recopilar información del sistema

  tasks: # Tareas
    - name: Obtener el sistema operativo
      debug: # Mostrar información en pantalla
        msg: "OS Family: {{ ansible_os_family }}" # Mensaje a mostrar

    - name: Obtener el nombre de host 
      debug: # Mostrar información en pantalla
        msg: "Hostname: {{ ansible_hostname }}" # Mensaje a mostrar

    - name: Obtener la dirección IPv4
      debug: # Mostrar información en pantalla
        msg: "IPv4: {{ ansible_default_ipv4.address }}" # Mensaje a mostrar
```

Para comprobar los datos usamos el comando que llevamos usando en todo el trabajo `ansible-playbook -i hosts.ini obtener_info_sistema.yml -K`:

![Captura sobre el código](../../datos/Ejercicio02/obtener%20informacion.png)

## Paso 4: Usar el Módulo `setup` para Obtener la IPv6

1.- Usa el módulo `setup` de Ansible en un comando ad-hoc para obtener la IPv6 del nodo remoto.
2.- Almacena el resultado en un fichero.
3.- Realiza todo esto en un único comando.

Para obtener la información de la IPv6 del nodo remoto, usamos el comando `ansible nodo1 -i hosts.ini -m setup -a 'filter=ansible_default_ipv6' > nodo1_ipv6.txt`

`ansible nodo1` : Ejecuta el comando en el nodo1.
`-i host.ini` : Indica el archivo de hosts.
`-m setup` : Módulo setup.
`-a 'filter=ansible_default_ipv6'` : Filtro para obtener la información de la IPv6.
`> nodo1_ipv6.txt` : Almacena el resultado en un fichero texto.

Para observar su contenido en la máquina solo debemos usar `cat nodo1_ipv6.json` en la carpeta correspondiente:

![Captura sobre el código](../../datos/Ejercicio02/ip%20v6.png)

## Paso 5: Crear un Fact Personalizado

1.- Crea un fact personalizado que permita obtener variables específicas del nodo remoto.
2.- Consulta la [documentación sobre facts personalizados](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html) para aprender cómo hacerlo.
3.- Crea un playbook que defina y utilice este fact personalizado.

```bash 
- name: Facts personalizado
  hosts: nodo1
  gather_facts: no # No se recopilarán los hechos
  tasks:
    - name: Fecha y hora
      command: date +"%Y-%m-%d %H:%M:%S" # Fecha y hora en formato de texto.
      register: fecha_actual

    - name: Definir Facts Custom 
      set_fact: # Definir una variable de Facts personalizada
        ansible_facts: # Nombre de la variable de Facts
          fecha_actual: "{{ fecha_actual.stdout }}" # Valor de la variable

    - name: Ejecutar facts custom
      debug: # Mostrar el valor de la variable de Facts personalizada
        msg: # Mensaje a mostrar
          - "Fecha y hora: {{ ansible_facts.fecha_actual }}"

```

Con este código, en primer lugar se ejecuta el comando `date +"%Y-%m-%d %H:%M:%S"` para obtener la fecha y hora actual en formato de texto. Luego, se define una variable de Facts personalizada llamada `fecha actual` y se le asigna el valor obtenido en el paso anterior. Finalmente, se muestra el valor de la variable de Facts personalizada mediante el módulo `debug` y usando el mensaje `Fecha y hora: {{ ansible_facts.fecha_actual }}`.

Para saber si funciona ejecutamos `ansible-playbook -i hosts.ini fact.yml` y se mostrará la fecha y hora actual en la pantalla.

![Captura sobre el código](../../datos/Ejercicio02/fact%20personalizado.png)