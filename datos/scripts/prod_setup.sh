#!/bin/bash

# Instalar Nginx
sudo apt-get update
sudo apt-get install -y nginx

# Crear un archivo index.html simple
echo "<html><body><h1>Welcome to Production!</h1></body></html>" | sudo tee /var/www/html/index.html
