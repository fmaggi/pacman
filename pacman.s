.global draw_pacman
.global update_pacman
.global clear_pacman

.equ RADIO,  20
.equ YELLOW, 0xf7e7
.equ BLUE,   0xff
.equ RED, 0xf000
.equ SPEED,  5
.equ COLLIDER, 10
.equ TIMER, 16
.equ GREEN_TIMER, 0x400000

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
        bl check_collision_down
        b.eq check_right
        add x3, x3, SPEED
    check_right:
        cmp x22, 0x40000
        b.ne check_left
        bl check_collision_right
        b.eq check_left
        add x2, x2, SPEED
    check_left:
        cmp x22, 0x2000
        b.ne check_up
        bl check_collision_left
        b.eq check_up
        sub x2, x2, SPEED
    check_up:
        cmp x22, 0x4000
        b.ne toggle
        bl check_collision_up
        b.eq toggle
        sub x3, x3, SPEED


    toggle:
        // cbnz x29, update_done
        eor x28, x28, 1 // toggle whether or not to draw the mouth

    ldur x14, [xzr, GREEN_TIMER]
    sub x14, x14, 1
    stur x14, [xzr, GREEN_TIMER]
    cmp x14, 0
    b.ne update_done

    // ACA APAGAR EL LED

    update_done:
        br x25

// sets flags zero flag if collision happened
check_collision_right:
    mov x21, RED
    add x9, x2, RADIO    // limite Derecho
    add x8, x9, COLLIDER // limite derecho + COLLIDER 
c_right_outer_loop:
    sub x10, x3, RADIO // limite inferior
    add x11, x3, RADIO // limite superior
    cmp x9, x8
    b.ge c_not_collision
c_right_loop:
    cmp x10, x11
    b.ge c_right_loop_done
    lsl x12, x10, 9   // y*512
    add x12, x12, x9  // x + y*512
    lsl x12, x12, 1   // 2(x + y*512)
    add x12, x0, x12  // &framebuffer[pixel]
    ldurh w13, [x12]   
    cmp w13, BLUE
    b.eq c_exit      // collision, exit early

    cmp w13, 0x07c0
    b.ne skip
   
    // ACA PRENDER EL LED
    mov x14, TIMER
    stur x14, [xzr, GREEN_TIMER]
    
skip:
    add x10, x10, 1
    b c_right_loop
c_right_loop_done:
    add x9, x9, 1
    b c_right_outer_loop
    
check_collision_left:
    mov x21, RED
    sub x9, x2, RADIO
    sub x8, x9, COLLIDER // limite izquierod - 1
c_left_outer_loop:
    sub x10, x3, RADIO // limite inferior
    add x11, x3, RADIO // limite superior
    cmp x9, x8
    b.le c_not_collision
c_left_loop:
    cmp x10, x11
    b.ge c_left_loop_done
    lsl x12, x10, 9   // y*512
    add x12, x12, x9  // x + y*512
    lsl x12, x12, 1   // 2(x + y*512)
    add x12, x0, x12  // &framebuffer[pixel]
    ldurh w13, [x12]
    cmp w13, BLUE
    b.eq c_exit
    add x10, x10, 1
    b c_left_loop
c_left_loop_done:
    sub x9, x9, 1
    b c_left_outer_loop

check_collision_up:
    mov x21, RED
    sub x9, x3, RADIO
    sub x8, x9, COLLIDER // limite superior - 1
c_up_outer_loop:
    sub x10, x2, RADIO // limite izquierod
    add x11, x2, RADIO // limite derecho
    cmp x9, x8
    b.le c_not_collision
c_up_loop:
    cmp x10, x11
    b.ge c_up_loop_done
    lsl x12, x9, 9   // y*512
    add x12, x12, x10  // x + y*512
    lsl x12, x12, 1   // 2(x + y*512)
    add x12, x0, x12  // &framebuffer[pixel]
    ldurh w13, [x12]
    cmp x13, BLUE
    b.eq c_exit
    add x10, x10, 1
    b c_up_loop
c_up_loop_done:
    sub x9, x9, 1
    b c_up_outer_loop

check_collision_down:
    mov x21, RED
    add x9, x3, RADIO
    add x8, x9, COLLIDER // limite inferior + 1
c_down_outer_loop:
    sub x10, x2, RADIO // limite izquierod
    add x11, x2, RADIO // limite derecho
    cmp x9, x8
    b.ge c_not_collision
c_down_loop:
    cmp x10, x11
    b.ge c_down_loop_done
    lsl x12, x9, 9   // y*512
    add x12, x12, x10  // x + y*512
    lsl x12, x12, 1   // 2(x + y*512)
    add x12, x0, x12  // &framebuffer[pixel]
    ldurh w13, [x12]
    cmp w13, BLUE
    b.eq c_exit
    add x10, x10, 1
    b c_down_loop
c_down_loop_done:
    add x9, x9, 1
    b c_down_outer_loop

c_not_collision:
    // f*cking assembler cant use xzr instead of x27 :(
    subs xzr, x27, 1 // reset flag in case it was set
c_exit:
    br x30
    

