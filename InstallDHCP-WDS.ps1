<#
.DESCRIPTION
    Ce script permet d'installer les rôles DHCP et WDS, de configurer les services.
    Pour le service DHCP, il permet de créer une plage d’adresses qui sera disponible pour les postes du réseau, ainsi qu’un bail.
    Pour le service WDS, il permet de créer un répertoire où seront stockées les images de déploiement et d’initialiser le service.
    
.EXECUTION (en mode élévation de privilèges)
    .\InstallDHCP-WDS.ps1

.NOTES
    Version : 1.0
    Auteur  : FT
    Date    : 2025-03-25
#>


# Installation du rôle DHCP
Write-Host "Installation du rôle DHCP..."
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Vérificationtion de l'installation du rôle DHCP
if ((Get-WindowsFeature -Name DHCP).Installed) {
    Write-Host "Le rôle DHCP a été installé avec succès." -ForegroundColor Green
} else {
    Write-Host "L'installation du rôle DHCP a échoué." -ForegroundColor Red
    Exit
}

# Configuration de DHCP 
Write-Host "Configuration du serveur DHCP..."

# Autorisation du serveur DHCP 
Add-DhcpServerInDc -DnsName "dhcp-wds.lan.local" -IpAddress 192.168.1.11 #Ajout et Autorisation du serveur DHCP dans le domaine Active Directory lan.local

# Démarrage du service DHCP
Start-Service -Name DHCPServer

# Création d'une plage d'adresses (de 192.168.1.100 à  192.168.1.200)
Add-DhcpServerV4Scope -Name "NetworkDHCP1" -StartRange 192.168.1.100 -EndRange 192.168.1.200 -SubnetMask 255.255.255.0 -State Active #Ajout Plage d'Adresses de 192.168.1.100 Ã  192.168.1.200

# Configuration d'une durée du bail
Set-DhcpServerv4Scope -ScopeId 192.168.1.0 -LeaseDuration 8.00:00:00 # Configuration d'un Bail de 8 jours oÃ¹ les adresses seront libérées pour réaffactation

# Installation du rôle WDS (Windows Deployment Services)
Write-Host "Installation du rôle WDS..."
Install-WindowsFeature -Name WDS -IncludeManagementTools

# Vérification de l'installation du rôle WDS
if ((Get-WindowsFeature -Name WDS).Installed) {
    Write-Host "Le rôle WDS a été installé avec succès." -ForegroundColor Green
} else {
    Write-Host "L'installation du rôle WDS a échoué." -ForegroundColor Red
    Exit
}

# Démarrage du service WDS
Write-Host "Démarrage du service WDS..."
Start-Service -Name wdsserver

# Spécifier le répertoire WDS
$wdsFolder = "E:\WDS"

# Vérifier que le répertoire existe et le créer s'il n'existe pas
if (-Not (Test-Path -Path $wdsFolder)) {
    Write-Host "Le répertoire $wdsFolder n'existe pas et va être créé" -ForegroundColor Yellow
    New-Item -Path $wdsFolder -ItemType Directory
}


# Configuration de WDS
Write-Host "Configuration du serveur WDS..."
wdsutil /initialize-server /reminst:$wdsFolder #Initialisation du serveur et définition du répertoire de stockage des images de déploiement

# Redémarrage du service WDS
Write-Host "Démarrage du service WDS..."
Restart-Service -Name wdsserver


# Attendre que le service soit en cours d'exécution
do {
    # Obtenir l'état du service
    $serviceStatus = (Get-Service -Name wdsserver).Status

    # Attendre 1 seconde avant de vérifier à nouveau
    Start-Sleep -Seconds 1
} while ($serviceStatus -ne 'Running')

# Vérification des services
Write-Host "Vérification de l'état des services..."
Get-Service -Name wdsserver, dhcp

Write-Host "Installation et configuration des rôles DHCP et WDS terminées avec succès." -ForegroundColor Green