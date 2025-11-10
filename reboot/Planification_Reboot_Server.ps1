<#
.DESCRIPTION
    Ce script PowerShell crée une tâche planifiée qui planifie le lancement d'un script de redémarrage d'un serveur.
    La tâche est exécutée sous le compte système local (NT AUTHORITY\SYSTEM)
    
.EXECUTION (en mode élévation de privilèges)
    .\Planification_Reboot_Server.ps1

.NOTES
    Version : 1.0
    Auteur  : FT
    Date    : 2025-03-25
#>


# Création du déclencheur
$declencheur = New-ScheduledTaskTrigger -Daily -At 5am #Création du déclencheur qui s'exécute tous les jours à 5h.

# Création de l'Action de redémarrage
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\Scripts\Reboot_Server.ps1" #Lancement d'un script qui redémarre le serveur uniquement le 1er du mois

# Enregistrer la tâche planifiée
Register-ScheduledTask -Action $action -Trigger $declencheur -TaskName "Redémarrage du Serveur" -User "NT AUTHORITY\SYSTEM" # Utilisation du compte système local pour exécuter la tâche avec des privilèges élevés.