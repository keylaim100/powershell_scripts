function Start-ProgressBar  # Esta línea crea una función nueva llamada Start-ProgressBar
{
    [CmdletBinding()] # Esta etiqueta vuelve a la función una función avanzada que permite hacer mas cosas que un cmdlet normal
    param # Aquí se definen los parámetros que recibe la función
    (
        [Parameter(Mandatory = $true)] # Este bloque dice que $Title es un parámetro obligatorio
        $Title, # $Title será un texto que se usa como título de la barra de progreso
        [Parameter(Mandatory = $true)] # Igual que el anterior pero para $Timer, también es obligatorio y además se le pone [int] para indicar que debe ser un número entero
        [int]$Timer                    # representa cuántos segundos durará el conteo de la barra de progreso
    )

    For ($i = 1; $i -le $Timer; $i++) # Este es un bucle que se repite varias veces empieza con $i = 1 y se va incrementando de 1 en 1 ($i++) mientras $i sea menor o igual que $Timer
    {                                 # En cada vuelta del bucle se simula que ha pasado un segundo y se actualiza la barra de progreso
        Start-Sleep -Seconds 1 # Sirve para que la barra no se llene rapido sino que avance poco a poco cada segundo como un temporizador
        $percentComplete = ($i / $Timer)*100 # Aquí se calcula el porcentaje de avance se divide el segundo actual para el total de segundos para obtener la fraccion de progreso y se multiplica por 100 para convertirla en porcentaje
        Write-Progress -Activity $Title -Status "$i second elapsed" -PercentComplete $percentComplete # Esta linea dibuja la barra de progreso en la consola -Activity muestra el título que se paso en $Title, -Status muestra un texto que indica cuántos segundos han pasado
                                                                                                      # y -PercentComplete usa el porcentaje calculado para mostrar cuanto de la barra debe estar llena 
    }
} #Function Start-ProgressBar

Start-ProgressBar -Title "Test timeout" -Timer 30 # Esta linea es la llamada final a la función
