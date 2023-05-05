//--------DEFINICIÓN DE FUNCIONES-----------//
    .global inputRead    
	//DESCRIPCION: Lee el boton en el GPIO17. 
//------FIN DEFINICION DE FUNCIONES-------//

inputRead: 	
	ldr w22, [x20, GPIO_GPLEV0] 	// Leo el registro GPIO Pin Level 0 y lo guardo en X22
    orr x23, xzr, 0x20000 // Limpio el bit 17 (estado del GPIO17)
    orr x23, x23, 0x60000 // Limpio el bit 18 (estado del GPIO18)
    orr x23, x23, 0x4000  // Limpio el bit 15 (estado del GPIO15)
    orr x23, x23, 0x2000  // Limpio el bit 14 (estado del GPIO14)
	and X22,X22, x23
		
    br x30 		//Vuelvo a la instruccion link
