<#
.DESCRIPTION
    Ce script PowerShell Redémarre le serveur automatiquement et uniquement le 1er de chaque mois.
    Une condition vérifie si le jour est bien le 1er du mois et enregistre l'information du reboot si "True"
    
.EXECUTION (en mode élévation de privilèges)
    .\Reboot_Server.ps1

.NOTES
    Version : 1.0
    Auteur  : FT
    Date    : 2025-03-25
#>


# Obtenir la date actuelle
$DDay = Get-Date # Récupération de la date du jour

# Chemin du fichier log
$logFileReboot = "C:\Scripts\logfileReboot.log" 

# Vérifier si 1er du mois
$firstDay = Get-Date -Year $DDay.Year -Month $DDay.Month -Day 25 #Variable étant le 1er de mois pour comparaison avec Date du jour

if ($DDay.Date -eq $firstDay.Date) { #Comparaison entre la date du jour et le 1er du mois
   "Aujourd'hui est le $DDay, redémarrage du serveur." | Out-File -FilePath $logFileReboot -Append #Si condition vraie ajout dans fichier de log

    # Redémarrer le serveur
    Restart-Computer -Force -Confirm:$false # redémarrage forcé du serveur sans confirmation
} else {
    Write-Host "Aujourd'hui n'est pas le 1er du mois, pas de redémarrage."
}