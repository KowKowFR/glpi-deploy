#!/bin/bash

# Variables 
GLPI_ARCHIVE="https://github.com/glpi-project/glpi/releases/download/10.0.13/glpi-10.0.13.tgz"
GLPI_INSTALL_DIR="/var/www/html"

# Demander le nom d'utilisateur et le mot de passe MySQL
read -p "Entrez le nom d'utilisateur MySQL pour GLPI: " GLPI_USER
read -p "Entrez le mot de passe MySQL pour GLPI: " GLPI_PASSWORD
echo

# Mise à jour du système
apt update
apt upgrade -y

# Installation des prérequis
apt install -y apache2 mariadb-server php php-mysql php-curl php-gd php-intl php-ldap php-xml php-zip unzip php-mbstring php-bz2 sudo wget

# Téléchargement de GLPI
wget -O "$GLPI_INSTALL_DIR/glpi.tgz" "$GLPI_ARCHIVE"
tar -zxf "$GLPI_INSTALL_DIR/glpi.tgz" -C "$GLPI_INSTALL_DIR"

# Ajout des droits
chmod -R 755 "$GLPI_INSTALL_DIR"
chown -R www-data:www-data "$GLPI_INSTALL_DIR/glpi"

# Création de la base de données MySQL
mysql -e "CREATE DATABASE IF NOT EXISTS glpi;"
mysql -e "CREATE USER IF NOT EXISTS '$GLPI_USER'@'localhost' IDENTIFIED BY '$GLPI_PASSWORD';"
mysql -e "GRANT ALL PRIVILEGES ON glpi.* TO '$GLPI_USER'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Redémarrage du service Apache2
systemctl restart apache2

# Message de fin
echo "GLPI est installé --> http://ip_address/glpi/"