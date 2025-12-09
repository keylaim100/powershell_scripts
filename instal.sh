###################################
# Prerequisites

# Update the list of packages
sudo apt-get update  # Actualiza la lista de paquetes disponibles en los repositorios de Ubuntu

# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common
#Instala paquetes necesarios antes de continuar:
#wget: permite descargar archivos desde internet.
#apt-transport-https: permite que apt use repositorios HTTPS.
#software-properties-common: permite agregar repositorios y manejar llaves.
#El parámetro -y acepta automáticamente las confirmaciones.

# Get the version of Ubuntu
source /etc/os-release #Carga y ejecuta las variables del archivo /etc/os-release, que contiene datos como: versión de Ubuntu, nombre del sistema
                       #ID de la versión: $VERSION_ID

# Download the Microsoft repository keys
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb #Descarga silenciosamente (-q) el archivo .deb con las claves del repositorio de Microsoft, correspondiente a tu versión de Ubuntu

# Register the Microsoft repository keys
sudo dpkg -i packages-microsoft-prod.deb #Instala el archivo descargado, lo que añade los repositorios oficiales de Microsoft y registra la clave GPG para validar paquetes

# Delete the Microsoft repository keys file
rm packages-microsoft-prod.deb #Elimina el archivo descargado porque ya no se necesita

# Update the list of packages after we added packages.microsoft.com
sudo apt-get update #Vuelve a actualizar los paquetes incluyendo ahora los repositorios de Microsoft

###################################
# Install PowerShell
sudo apt-get install -y powershell #Instala PowerShell desde los repositorios de Microsoft previamente agregados

# Start PowerShell
pwsh  #Inicia PowerShell en la terminal
