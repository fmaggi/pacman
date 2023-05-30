.global draw_pacman
.global update_pacman
.global clear_pacman

.equ RADIO,  20
.equ YELLOW, 0xf7e7
.equ SPEED,  5
.equ BLUE,   0xff

clear_pacman:
    mov x25, x30

    mov x1, 0
    mov x4, RADIO
    bl circle

    br x25


draw_pacman:
    mov x25, x30

    mov x1, YELLOW
    mov x4, RADIO
    bl circle
    
    cbz x28, draw_done
    mov x1, 0
    mov x4, 40
    mov x5, RADIO
    bl triangle_left

    draw_done:
        br x25

update_pacman:
    mov x25, x30

    bl inputRead
    check_down:
        cmp x22, 0x20000
        b.ne check_right
        add x3, x3, SPEED 
        bl check_collision_down
        b.ne check_right
        sub x3, x3, SPEED
    check_right:
        cmp x22, 0x40000
        b.ne check_left
        add x2, x2, SPEED
        bl check_collision_right
        b.ne check_left
        sub x2, x2, SPEED
    check_left:
        cmp x22, 0x2000
        b.ne check_up
        sub x2, x2, SPEED
        bl check_collision_left
        b.ne check_up
        add x2, x2, SPEED
    check_up:
        cmp x22, 0x4000
        b.ne toggle
        sub x3, x3, SPEED
        bl check_collision_up
        b.ne toggle
        add x3, x3, SPEED


    toggle:
        // cbnz x29, update_done
        eor x28, x28, 1 // toggle whether or not to draw the mouth

    update_done:
        br x25

// sets flags zero flag if collision happened
check_collision_right:
    add x9, x2, RADIO
    add x9, x9, 1 // limite derecho + 1
    sub x10, x3, RADIO // limite inferior
    add x11, x3, RADIO // limite superior
c_right_loop:
    cmp x10, x11
    b.ge c_not_collision
    lsl x12, x10, 9   // y*512
    add x12, x12, x9  // x + y*512
    lsl x12, x12, 1   // 2(x + y*512)
    add x12, x0, x12  // &framebuffer[pixel]
    ldurh w13, [x12]   
    cmp w13, BLUE
    b.eq c_exit      // collision, exit early
    add x10, x10, 1
    b c_right_loop

check_collision_left:
    sub x9, x2, RADIO
    sub x9, x9, 1 // limite izquierod - 1
    sub x10, x3, RADIO // limite inferior
    add x11, x3, RADIO // limite superior
c_left_loop:
    cmp x10, x11
    b.ge c_not_collision
    lsl x12, x10, 9   // y*512
    add x12, x12, x9  // x + y*512
    lsl x12, x12, 1   // 2(x + y*512)
    add x12, x0, x12  // &framebuffer[pixel]
    ldurh w13, [x12]
    cmp w13, BLUE
    b.eq c_exit
    add x10, x10, 1
    b c_left_loop

check_collision_up:
    sub x9, x3, RADIO
    sub x9, x9, 1 // limite superior - 1
    sub x10, x2, RADIO // limite izquierod
    add x11, x2, RADIO // limite derecho
c_up_loop:
    cmp x10, x11
    b.ge c_not_collision
    lsl x12, x9, 9   // y*512
    add x12, x12, x10  // x + y*512
    lsl x12, x12, 1   // 2(x + y*512)
    add x12, x0, x12  // &framebuffer[pixel]
    ldurh w13, [x12]
    cmp x13, BLUE
    b.eq c_exit
    add x10, x10, 1

check_collision_down:
    add x9, x3, RADIO
    add x9, x9, 1 // limite inferior + 1
    sub x10, x2, RADIO // limite izquierod
    add x11, x2, RADIO // limite derecho
c_down_loop:
    cmp x10, x11
    b.ge c_not_collision
    lsl x12, x9, 9   // y*512
    add x12, x12, x10  // x + y*512
    lsl x12, x12, 1   // 2(x + y*512)
    add x12, x0, x12  // &framebuffer[pixel]
    ldurh w13, [x12]
    cmp w13, BLUE
    b.eq c_exit
    add x10, x10, 1

c_not_collision:
    // f*cking assembler cant use xzr instead of x27 :(
    subs xzr, x27, 1 // reset flag in case it was set
c_exit:
    br x30
    

