#Importation des modules
import os #Intéragir avec le système d'exploitation
import shutil #Manipuler les dossiers et fichiers
 
folder = '/tmp'
for files in os.listdir(folder): #Parcourir le dossier tmp
    path = os.path.join(folder, files) #Combine dossier et fichier pour former un chemin valide
    try:
        shutil.rmtree(path) #Suppression dossier et contenu
    except OSError: # Exécuter si c'est un fichier
        os.remove(path) #Suppression fichier