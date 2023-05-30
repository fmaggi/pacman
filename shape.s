// Params
// x1 -> color
// x2 -> X_center
// x3 -> Y_center
// x4 -> radius
.global circle

// Params
// x1 -> color
// x2 -> x
// x3 -> y
// x4 -> base
// x5 -> height
.global triangle_up
.global triangle_down
.global triangle_left
.global triangle_right

// Parms
// x1 -> color
// x2 -> x0
// x3 -> y0
// x4 -> x1
// x5 -> y1
// x6 -> thickness?
.global line

circle: 
    // we call sqrt here so we need to store the origin address somewhere
    mov x29, x30
    // x9 -> x 
    // x10 -> y
    mul x12, x4, x4 // r^2

    // empezamos por el punto (0, r)
    mov x9, xzr
    mov x10, x4
    loopX:
        cmp x9, x4
        b.gt exit           // while x <= r
        mov x14, xzr        // y0 = 0
        loopY:
            cmp x14, x10    
            b.gt exitY          // while y0 <= y
            
            // (y0 + Y_center)*512
            add x13, x14, x3    // y0+y_center desplazar en y hacia Y_center
            lsl x13, x13, 9     // (y0+Y_center) * 512
            add x13, x13, x2    // x_center + (y0+y_center)*512

            // (x_center+x, y_center+y0)
            add x15, x9, x13    // (x_center+x) + (y0+Y_center)*512
            lsl x15, x15, 1     // pixel = 2*((x+X_center) + (y0+Y_center)*512)
            add x15, x0, x15    // &framebuffer[pixel]
            sturh w1, [x15]     // setear el color

            // (x_center-x, y_center+y0)
            sub x15, x13, x9
            lsl x15, x15, 1
            add x15, x0, x15
            sturh w1, [x15]

            // (Y_center-y0)*512
            sub x13, x3, x14
            lsl x13, x13, 9

            add x13, x13, x2
            
            // (x_center+x, y_center-y0)
            add x15, x9, x13
            lsl x15, x15, 1
            add x15, x0, x15
            sturh w1, [x15]

            // (x_center-x, y_center-y0)
            sub x15, x13, x9
            lsl x15, x15, 1
            add x15, x0, x15
            sturh w1, [x15]

            add x14, x14, 1    // y0 += 1  
            b loopY
        exitY:
        // move to next pixel
        mul x14, x9, x9     // x^2
        sub x21, x12, x14   // r^2 - x^2
        bl sqrt             // sqrt(r^2 - x^2)
        add x9, x9, 1       // x += 1
        mov x10, x21        // y = sqrt(r^2 - x^2)
        b loopX
    exit:
        br x29
    
triangle_up:
    // dydx = height / (base/2)
    lsr x9, x4, 1          // base / 2
    mov x10, x5             // height
    udiv w10, w10, w9      // height / base/2

    mov x11, xzr            // x
    mov x12, xzr            // y

    tr_up_loop:
        cmp x11, x9
        b.gt tr_up_done            // while x <= base/2
        mov x13, x12              // y0 = y
        
        tr_up_y_loop:
            cmp x13, x5        // while y0 <= height
            b.gt tr_up_y_done

            add x14, x3, x13   // y_left + y0 
            lsl x14, x14, 9    // (y_left + y0)*512

            add x14, x14, x2   // x_left + (y_left + y0)*512

            add x15, x14, x11  // (x_left + x) + (y_left + y0)*512 
            lsl x15, x15, 1    // 2*((x_left + x) + (y_left + y0)*512)
            add x15, x0, x15   // &framebuffer[pixel]
            sturh w1, [x15]

            sub x15, x14, x11
            lsl x15, x15, 1    // 2*((x_left - x) + (y_left + y0)*512)
            add x15, x0, x15   // &framebuffer[pixel]
            sturh w1, [x15]

            add x13, x13, 1     // y0 += 1
            b tr_up_y_loop

        tr_up_y_done:
            add x11, x11, 1     // x += 1
            add x12, x12, x10   // limit_y += dydx
            b tr_up_loop

    tr_up_done:
        br x30

triangle_down:
    // dydx = height / (base/2)
    lsr x9, x4, 1          // base / 2
    mov x10, x5             // height
    udiv w10, w10, w9      // height / base/2

    mov x11, xzr            // x
    mov x12, xzr            // y

    tr_down_loop:
        cmp x11, x9
        b.gt tr_down_done            // while x <= base/2
        mov x13, x12              // y0 = y
    
        tr_down_y_loop:
            cmp x13, x5        // while y0 <= height
            b.gt tr_down_y_done

            sub x14, x3, x13   // y_left - y0 
            lsl x14, x14, 9    // (y_left - y0)*512

            add x14, x14, x2   // x_left + (y_left - y0)*512

            add x15, x14, x11  // (x_left + x) + (y_left - y0)*512 
            lsl x15, x15, 1    // 2*((x_left + x) + (y_left - y0)*512)
            add x15, x0, x15   // &framebuffer[pixel]
            sturh w1, [x15]

            sub x15, x14, x11
            lsl x15, x15, 1    // 2*((x_left - x) + (y_left - y0)*512)
            add x15, x0, x15   // &framebuffer[pixel]
            sturh w1, [x15]

            add x13, x13, 1     // y0 += 1
            b tr_down_y_loop

        tr_down_y_done:
            add x11, x11, 1     // x += 1
            add x12, x12, x10   // limit_y += dydx
            b tr_down_loop

    tr_down_done:
        br x30

triangle_right:
    // dydx = (base/2) / height
    lsr x9, x4, 1         // base / 2
    mov x10, x9
    udiv w10, w10, w5     // base/2 / height

    mov x11, xzr            // x
    mov x12, xzr            // limitY

    tr_r_loop:
        cmp x11, x5
        b.gt tr_r_done            // while x <= height
        mov x13, xzr              // y = 0
        
        tr_r_y_loop:
            cmp x13, x12       // while y <= limitY
            b.gt tr_r_y_done

            add x14, x2, x11   // x_left+x

            add x15, x3, x13   // y_left+y
            lsl x15, x15, 9    // (y_left+y)*512
            add x15, x14, x15  // (x_left + x) + (y_left + y)*512 
            lsl x15, x15, 1    // 2*((x_left + x) + (y_left + y)*512)
            add x15, x0, x15   // &framebuffer[pixel]
            sturh w1, [x15]

            sub x15, x3, x13   // y_left-y
            lsl x15, x15, 9    // (y_left+y)*512
            add x15, x14, x15  // (x_left + x) + (y_left - y0)*512 
            lsl x15, x15, 1    // 2*((x_left + x) + (y_left - y0)*512)
            add x15, x0, x15   // &framebuffer[pixel]
            sturh w1, [x15]

            add x13, x13, 1     // y0 += 1
            b tr_r_y_loop

        tr_r_y_done:
            add x11, x11, 1     // x += 1
            add x12, x12, x10   // limit_y += dydx
            b tr_r_loop

    tr_r_done:
        br x30

triangle_left:
    // dydx = (base/2) / height
    lsr x9, x4, 1         // base / 2
    mov x10, x9
    udiv w10, w10, w5     // base/2 / height

    mov x11, xzr            // x
    mov x12, xzr            // limitY

    tr_l_loop:
        cmp x11, x5
        b.gt tr_l_done            // while x <= height
        mov x13, xzr              // y = 0
        
        tr_l_y_loop:
            cmp x13, x12       // while y0 <= limitY
            b.gt tr_l_y_done

            sub x14, x2, x11   // x_left-x

            add x15, x3, x13   // y_left+y
            lsl x15, x15, 9    // (y_left+y)*512
            add x15, x14, x15  // (x_left - x) + (y_left + y0)*512 
            lsl x15, x15, 1    // 2*((x_left - x) + (y_left + y0)*512)
            add x15, x0, x15   // &framebuffer[pixel]
            sturh w1, [x15]

            sub x15, x3, x13   // y_left-y
            lsl x15, x15, 9    // (y_left+y)*512
            add x15, x14, x15  // (x_left - x) + (y_left - y0)*512 
            lsl x15, x15, 1    // 2*((x_left - x) + (y_left - y0)*512)
            add x15, x0, x15   // &framebuffer[pixel]
            sturh w1, [x15]

            add x13, x13, 1     // y0 += 1
            b tr_l_y_loop

        tr_l_y_done:
            add x11, x11, 1     // x += 1
            add x12, x12, x10   // limit_y += dydx
            b tr_l_loop

    tr_l_done:
        br x30

line:
    cmp x2, x4
    b.eq vertical_line

    // if x0 > x1 switch the points around
    cmp x2, x4 
    b.lt draw_line
    mov x9, x2
    mov x2, x4
    mov x4, x9

    mov x9, x3
    mov x3, x5
    mov x5, x9

    draw_line:
        // dydx = (y1-y0) / (x1-x0)
        sub x9, x5, x3
        sub x10, x4, x2
        sdiv w9, w9, w10

        mov x11, x2  // x = x0
        mov x12, x3  // y = y0

        l_loop:
            cmp x11, x4
            b.gt l_done // while x < x1

            lsl x13, x12, 9    // (y*512)
            add x13, x13, x11  // x+y*512
            lsl x13, x13, 1    // 2*(x+y*512)
            add x13, x13, x0   // &framebuffer[pixel]
            sturh w1, [x13]

            add x11, x11, 1   // x += 1
            add x12, x12 ,x9  // y += dydx

            b l_loop

    l_done:
        br x30

vertical_line:
    cmp x3, x5
    b.lt draw_v_line
    mov x9, x3
    mov x3, x5
    mov x5, x9

    draw_v_line:
        cmp x3, x5
        b.gt l_done

        lsl x13, x3, 9    // (y*512)
        add x13, x13, x1  // x+y*512
        lsl x13, x13, 1    // 2*(x+y*512)
        add x13, x13, x0   // &framebuffer[pixel]
        sturh w1, [x13]

        add x3, x3, 1 // y += dydx

        b draw_v_line

        
        

