# Ejercicio 5: Imports y Handlers en Ansible

## Paso 1: Playbook de Instalación de Apache2

1. Crea un playbook que simplemente realice la instalación de apache2

## Paso 2: Reutilizar el Playbook de Instalación de Apache2

1. Modifica tu playbook existente de instalación de Apache2 para incluir un paso adicional que permita iniciar el servicio.
2. Crea un nuevo playbook que haga uso del `import_playbook` para llamar al playbook de instalación y arranque del servicio.

## Paso 3: Reiniciar el Servicio Apache2 al Modificar su Configuración

1. Crea un handler en Ansible que se encargue de reiniciar el servicio Apache2.
2. Ajusta tu playbook para que, si se modifica la configuración de Apache2, se notifique al handler para reiniciar el servicio automáticamente.

## Paso 4: Crear un Playbook para Limpiar Dependencias y Cache

1. Crea un playbook llamado `limpiar_dependencias.yml` que limpie las dependencias y la caché del sistema.
2. Crea un segundo playbook que haga uso del `import_playbook` para llamar al playbook `limpiar_dependencias.yml`.