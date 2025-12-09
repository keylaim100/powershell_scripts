Add-Type -AssemblyName System.Windows.Forms  # Estas dos líneas cargan en PowerShell las librerías de .NET necesarias para trabajar con ventanas gráficas System.Windows.Forms permite crear formularios, botones, cajas de texto, etc.
Add-Type -AssemblyName System.Drawing        # System.Drawing se usa para manejar tamaños, posiciones y otros aspectos visuales

# Create form
$form = New-Object System.Windows.Forms.Form           # Aquí se crea un nuevo formulario (ventana) y se guarda en la variable $form
$form.Text = "Input Form"                              # con .Text se define el título de la ventana (“Input Form”)
$form.Size = New-Object System.Drawing.Size(500,250)   # con .Size se define el tamaño (500 de ancho por 250 de alto)
$form.StartPosition = "CenterScreen"                   # y con StartPosition = "CenterScreen" hace que la ventana aparezca centrada en la pantalla cuando se abra

############# Define labels
$textLabel1 = New-Object System.Windows.Forms.Label     # Cada bloque crea una etiqueta de texto con New-Object System.Windows.Forms.Label
$textLabel1.Text = "Input 1:"                           # Text es el texto que se muestra (“Input 1:”)
$textLabel1.Left = 20                                   # Left, Top y Width controlan la posición horizontal, vertical y el ancho de la etiqueta dentro del formulario
$textLabel1.Top = 20                                    
$textLabel1.Width = 120                                 

$textLabel2 = New-Object System.Windows.Forms.Label     # Se repite el mismo patrón para las tres etiquetas cambiando la posición 
$textLabel2.Text = "Input 2:"                           # y el texto (“Input 2:”, “Input 3:”)
$textLabel2.Left = 20                                   
$textLabel2.Top = 60                                    
$textLabel2.Width = 120                                 

$textLabel3 = New-Object System.Windows.Forms.Label     
$textLabel3.Text = "Input 3:"                           
$textLabel3.Left = 20                                   
$textLabel3.Top = 100                                   
$textLabel3.Width = 120                                 

############# Textbox 1
$textBox1 = New-Object System.Windows.Forms.TextBox     # Cada bloque crea una caja de texto donde el usuario podrá escribir
$textBox1.Left = 150                                    # De nuevo se usa New-Object System.Windows.Forms.TextBox y se ajustan Left, Top y Width 
$textBox1.Top = 20                                      # para colocar cada caja al lado de su etiqueta correspondiente
$textBox1.Width = 200                                   

############# Textbox 2
$textBox2 = New-Object System.Windows.Forms.TextBox     # Así el usuario verá tres campos para escribir “Input 1”, “Input 2” y “Input 3”
$textBox2.Left = 150                                    
$textBox2.Top = 60                                      
$textBox2.Width = 200                                   

############# Textbox 3
$textBox3 = New-Object System.Windows.Forms.TextBox     
$textBox3.Left = 150                                    
$textBox3.Top = 100                                     
$textBox3.Width = 200                                   

############# Default values
$defaultValue = ""                                      # Aquí se crea una variable $defaultValue con un texto por defecto (en este caso cadena vacía, sin texto)
$textBox1.Text = $defaultValue                          # Luego se asigna ese valor a la propiedad .Text de cada caja de texto
$textBox2.Text = $defaultValue                          # Si se quisiera que apareciera algo prellenado al abrir el formulario (por ejemplo “0”) 
$textBox3.Text = $defaultValue                          # solo cambiarías el valor de $defaultValue

############# OK Button
$button = New-Object System.Windows.Forms.Button        # Este bloque crea un botón usando New-Object System.Windows.Forms.Button
$button.Left = 360                                      # Se posiciona en la parte derecha del formulario (Left y Top) y se le da un ancho
$button.Top = 140                                       
$button.Width = 100                                     
$button.Text = "OK"                                     # La propiedad Text define lo que se ve en el botón en este caso la palabra “OK”

############# Button click event
$button.Add_Click({                                     # Add_Click asigna un evento al botón es decir el código que se ejecuta cuando el usuario hace clic
    $form.Tag = @{                                      # Dentro de las llaves se crea un pequeño diccionario y se guarda en $form.Tag
        Box1 = $textBox1.Text                           # guardando los textos escritos: Box1 toma el texto de $textBox1,
        Box2 = $textBox2.Text                           # Box2 el de $textBox2 y Box3 el de $textBox3
        Box3 = $textBox3.Text                           # 
    }
    $form.Close()                                       # Luego se llama a $form.Close() para cerrar la ventana después de guardar los datos
})

############# Add controls                              
$form.Controls.Add($button)                             # Estas líneas añaden cada elemento (botón, etiquetas y cajas de texto) a la colección de 
$form.Controls.Add($textLabel1)                         # controles del formulario ($form.Controls)
$form.Controls.Add($textLabel2)                         # Si no se hace esto, los objetos existirían en memoria, pero no aparecerían en la ventana
$form.Controls.Add($textLabel3)                         
$form.Controls.Add($textBox1)                           
$form.Controls.Add($textBox2)                           
$form.Controls.Add($textBox3)                           

############# Show dialog
$form.ShowDialog() | Out-Null                           # ShowDialog() abre la ventana y bloquea la ejecución del script hasta que el usuario la cierre
                                                        # se envía a Out-Null para que no aparezca nada raro en la consola
############# Return values
return $form.Tag.Box1, $form.Tag.Box2, $form.Tag.Box3   # el script devuelve los valores que se guardaron en $form.Tag durante el clic del botón. Box1, Box2 y Box3
                                                        # contienen el texto que el usuario escribió en cada caja de texto, y con return esos valores se devuelven 
                                                        # como resultado del script