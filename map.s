.global map

.equ BLUE, 0xff
map:
    mov x29, x30
    mov x1, BLUE
    mov x2, 0
    mov x3, 100
    mov x4, 512
    mov x5, 100
    bl line
    mov x2, 500
    mov x3, 100
    mov x4, 500 
    mov x5, 300
    bl line
    br x29
    
