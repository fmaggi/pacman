.globl app
// .equ TICK,   0x1
app:
	//---------------- Inicialización GPIO --------------------
    movz x27, 0x40, lsl 16 // inicializar la stack al final de la memoria

	mov w20, PERIPHERAL_BASE + GPIO_BASE     // Dirección de los GPIO.		
	
	// Configurar GPIO 17 como input:
	mov X21, 0
	str w21,[x20,GPIO_GPFSEL1] 		// Coloco 0 en Function Select 1 (base + 4)   	
	
	//---------------- Main code --------------------
	// X0 contiene la dirección base del framebuffer (NO MODIFICAR)
inicio:
    // mov x29, TICK
    mov x28, 0
    mov x2, 256
    mov x3, 256

loop:

    // sub x29,x29, 1
    
    bl clear_pacman
    bl update_pacman
    bl draw_pacman

	mov x11, 0x50000
delay1: 
	sub x11,x11, 1
	cbnz x11, delay1

    // cbnz x29, loop
    // mov x29, TICK
    b loop


    // --- Infinite Loop ---	
InfLoop: 
	b InfLoop


