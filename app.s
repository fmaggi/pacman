.globl app
.equ R, 0xF800
.equ G, 0x07E0
.equ B, 0x001F 
app:
	//---------------- Inicialización GPIO --------------------

	mov w20, PERIPHERAL_BASE + GPIO_BASE     // Dirección de los GPIO.		
	
	// Configurar GPIO 17 como input:
	mov X21,#0
	str w21,[x20,GPIO_GPFSEL1] 		// Coloco 0 en Function Select 1 (base + 4)   	
	
	//---------------- Main code --------------------
	// X0 contiene la dirección base del framebuffer (NO MODIFICAR)
inicio:
    
	// --- Infinite Loop ---	
    mov x1, R
    mov x2, 256
    mov x3, 256
    mov x4, 150
    bl circle
    
InfLoop: 
	b InfLoop

// Nunca deberia llegar aca. Solamente por un salto
dibujarX: // espera en w3 el color y en x2 cuantas columnas dibujar del color, en x10 donde empezar
	mov x1,512         	// Tamaño en X
    mul x1, x1, x2      // X*Y. cuantos pixeles en total
loop:
	sturh w3,[x10]	   	// Setear el color del pixel N
	add x10,x10,2	   	// Siguiente pixel
	sub x1,x1,1	   		// Decrementar el contador
	cbnz x1,loop	   	// Si no terminó, saltar
    br x30              // volver al llamador
	
