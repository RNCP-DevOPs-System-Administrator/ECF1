# ================================================================
# Script d'Automatisation pour l'Installation des Rôles SSH, UFW, Apache et PHP
# ================================================================
# Ce script permet d'automatiser l'installation et la configuration des services suivants :
# 1. SSH (OpenSSH) pour l'accès à distance sécurisé.
# 2. UFW pour gérer le pare-feu et protéger le serveur.
# 3. Apache pour héberger des sites web.
# 4. PHP pour exécuter des scripts sur les pages web.
#
# Prérequis :
# - Le script doit être exécuté avec des privilèges administratifs (sudo).
#
# Auteur : FT
# Date : 2025-03-25
# Version : 1.0
# ================================================================


#!/bin/bash

# Mise à jour de la liste des paquets
echo "Mise à jour des paquets..."
sudo apt update && sudo apt upgrade -y #Mise à jour de la liste des paquets et upgrade des paquets installés

# Installation des services SSH, UFW, Apache et PHP
echo "Installation des services SSH, UFW, Apache et PHP"
sudo apt install -y openssh-server ufw apache2 php libapache2-mod-php php-mysql #Pour PHP installation en plus des modules Apache et mysql

# Activation et Vérification de SSH
echo "Activation et Vérification du service SSH..."
sudo systemctl enable ssh
sudo systemctl start ssh
sudo systemctl status ssh

# Sauvegarde et Configuration du fichier de configuration SSH sshd_config
# Sauvegarde de la configuration avant modification
SSH_CONF="/etc/ssh/sshd_config"
cp $SSH_CONF /etc/ssh/sshd_config.bak

echo "Configuration de /etc/ssh/sshd_config..."
# Activation de l'authentification par clé publique et désactivation de l'authentification par mot de passe
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' $SSH_CONF #Désactivation de l'authentification par mot de passe
sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin no/' $SSH_CONF #Désactivation de la connexion SSH avec root
sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' $SSH_CONF #Activation de l'authentification par clé publique

# Redémarrage et Vérification du service SSH pour appliquer les modifications
echo "Redémarrage du service SSH..."
systemctl restart ssh
# Vérification du service SSH après redémarrage
systemctl status ssh

# Activation et Vérification d'Apache
echo "Activation et Vérification du service Apache..."
sudo systemctl enable apache2
sudo systemctl start apache2
sudo systemctl status apache2

# Activation et Vérification de UFW
echo "Activation et Vérification de UFW..."
sudo ufw enable
sudo ufw status

# Configuration de UFW
echo "Configuration de UFW pour autoriser SSH et Apache..."
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Vérification de UFW et des règles appliquées
echo "Vérification de UFW et des règles appliquées..."
ufw status verbose

# Vérification de l'installation de PHP
echo "Vérification de la version de PHP..."
php -v

# Création d'un fichier de test PHP pour vérifier si fonctionnel avec Apache
echo "<?php phpinfo(); ?>" > /var/www/html/info.php #Fichier de test qui affiche des informations sur la configuration PHP

# Redémarrer Apache pour appliquer toutes les configurations
systemctl restart apache2

# Message de fin
echo "L'installation et la configuration sont terminées !"
echo "Test du serveur en accédant à http://debianbullseye/info.php"