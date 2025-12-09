# script3.ps1
function New-FolderCreation { #Aquí se define una función llamada New-FolderCreation
    [CmdletBinding()] #Permite que la función se comporte como un cmdlet (mejor manejo de parámetros)
    param(
        [Parameter(Mandatory = $true)] #Declara un parámetro obligatorio llamado $foldername, que es el nombre de la carpeta a crear
        [string]$foldername
    )

    # Create absolute path for the folder relative to current location
    $logpath = Join-Path -Path (Get-Location).Path -ChildPath $foldername #Construye una ruta completa usando la ubicación actual + el nombre de la carpeta
    if (-not (Test-Path -Path $logpath)) {    
        New-Item -Path $logpath -ItemType Directory -Force | Out-Null  #Si la carpeta no existe, la crea.
    }

    return $logpath #Devuelve la ruta completa de la carpeta
}

function Write-Log { #Crea la función principal para crear archivos de log o escribir mensajes
    [CmdletBinding()]
    param(
        # Create parameter set
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]  # Nombre del archivo o lista de archivos
        [Alias('Names')]
        [object]$Name,                    # can be single string or array

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$Ext, # Extensión del archivo (.log, .txt, etc)

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$folder, # Carpeta donde se guardará el archivo

        [Parameter(ParameterSetName = 'Create', Position = 0)]
        [switch]$Create, # Activa el modo de creación

        # Message parameter set
        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$message,

        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$path,
                                                                        # Mensaje a escribir, ruta del archivo, severidad (colores), y activador de este modo
        [Parameter(Mandatory = $false, ParameterSetName = 'Message')]
        [ValidateSet('Information','Warning','Error')]
        [string]$Severity = 'Information',

        [Parameter(ParameterSetName = 'Message', Position = 0)]
        [switch]$MSG
    )

    switch ($PsCmdlet.ParameterSetName) {  # Dependiendo del modo usado, ejecuta Create o Message
        "Create" {
            $created = @()  # Arreglo donde se guardarán las rutas de los archivos creados

            # Normalize $Name to an array
            $namesArray = @()  # Convierte $Name en un arreglo aunque sea un solo string
            if ($null -ne $Name) {
                if ($Name -is [System.Array]) { $namesArray = $Name }
                else { $namesArray = @($Name) }
            }

            # Date + time formatting (safe for filenames)
            $date1 = (Get-Date -Format "yyyy-MM-dd")
            $time  = (Get-Date -Format "HH-mm-ss")     #Crea fecha y hora con formato para archivo

            # Ensure folder exists and get absolute folder path
            $folderPath = New-FolderCreation -foldername $folder  #Crea (si no existe) la carpeta destino

            foreach ($n in $namesArray) {  # Crea un archivo para cada nombre dado
                # sanitize name to string
                $baseName = [string]$n

                # Build filename
                $fileName = "${baseName}_${date1}_${time}.$Ext"  # Genera nombre tipo:NameLog_2025-12-08_20-33-55.log

                # Full path for file
                $fullPath = Join-Path -Path $folderPath -ChildPath $fileName  # Ruta completa del archivo

                # Create the file (New-Item -Force will create or overwrite; use -ErrorAction Stop to catch errors)
                try {
                    # If you prefer to NOT overwrite existing file, use: if (-not (Test-Path $fullPath)) { New-Item ... }
                    New-Item -Path $fullPath -ItemType File -Force -ErrorAction Stop | Out-Null  #Crea el archivo

                    # Optionally write a header line (uncomment if desired)
                    # "Log created: $(Get-Date)" | Out-File -FilePath $fullPath -Encoding UTF8 -Append

                    $created += $fullPath  #Añade la ruta del archivo creado al arreglo
                }
                catch {
                    Write-Warning "Failed to create file '$fullPath' - $_"
                }
            }

            return $created # Devuelve todas las rutas creadas 
        }

        "Message" {
            # Ensure directory for message file exists
            $parent = Split-Path -Path $path -Parent  # Obtiene la carpeta donde está el archivo de log
            if ($parent -and -not (Test-Path -Path $parent)) {  #Crea la carpeta si no existe
                New-Item -Path $parent -ItemType Directory -Force | Out-Null
            }

            $date = Get-Date
            $concatmessage = "|$date| |$message| |$Severity|" # Da formato al mensaje

            switch ($Severity) {
                "Information" { Write-Host $concatmessage -ForegroundColor Green }
                "Warning"     { Write-Host $concatmessage -ForegroundColor Yellow } #Muestra mensaje en consola con color según severidad
                "Error"       { Write-Host $concatmessage -ForegroundColor Red }
            }

            # Append message to the specified path (creates file if it does not exist)
            Add-Content -Path $path -Value $concatmessage -Force #Escribe el mensaje en el archivo (lo crea si no existe)

            return $path  #Devuelve la ruta del archivo modificado
        }

        default {
            throw "Unknown parameter set: $($PsCmdlet.ParameterSetName)"  # Cuando Write-Log se ejecuta PowerShell determina qué conjunto de parámetros se está usando
        }
    }
}

# ---------- Example usage ----------
# This will create the folder "logs" (if missing) and create a file Name-Log_YYYY-MM-DD_HH-mm-ss.log
$logPaths = Write-Log -Name "Name-Log" -folder "logs" -Ext "log" -Create
$logPaths
