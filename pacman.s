.global draw_pacman
.global update_pacman
.global clear_pacman

.equ RADIO,  20
.equ YELLOW, 0xf7e7
.equ SPEED,  5

clear_pacman:
    sub x27, x27, 8
    stur x30, [x27]

    mov x1, 0
    mov x4, RADIO
    bl circle

    ldur x30, [x27]
    add x27, x27, 8

    br x30


draw_pacman:
    sub x27, x27, 8
    stur x30, [x27]

    mov x1, YELLOW
    mov x4, RADIO
    bl circle
    
    cbz x28, draw_done
    mov x1, 0
    mov x4, 40
    mov x5, RADIO
    bl triangle_left

    draw_done:
        ldur x30, [x27]
        add x27, x27, 8

        br x30

update_pacman:
    sub x27, x27, 8
    stur x30, [x27]

    bl inputRead
    check_down:
        cmp x22, 0x20000
        b.ne check_right
        add x3, x3, SPEED 
    check_right:
        cmp x22, 0x40000
        b.ne check_left
        add x2, x2, SPEED
    check_left:
        cmp x22, 0x2000
        b.ne check_up
        sub x2, x2, SPEED
    check_up:
        cmp x22, 0x4000
        b.ne toggle
        sub x3, x3, SPEED


    toggle:
        // cbnz x29, update_done
        eor x28, x28, 1 // toggle whether or not to draw the mouth

    update_done:
        ldur x30, [x27]
        add x27, x27, 8

        br x30
