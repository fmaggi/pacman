// Params
// x20 -> n
// returns 
// x20 -> sqrt(n)
// works only for 32-bit numbers
.global sqrt

// implementation of newton's method for sqrt
// https://en.wikipedia.org/wiki/Integer_square_root
sqrtV1:
    subs xzr, x21, 1
    b.le sqrtV1_exit          // // if n <= 1 return n
    lsr x22, x21, 1    // initial guess n/2
    lsr x23, x21, 2
    add x23, x23, 1   // update n/4 + 1
    sqrtV1_loop:
        cmp x23, x22
        b.ge sqrtV1_exit          // while x22 < x21
        mov x22, x23       // x21 = x22
        udiv x23, x21, x22
        add x23, x23, x22
        lsr x23, x23, 1    // x22 = (x21 + x/x21) / 2
        b sqrtV1_loop
    sqrtV1_exit:
        mov x21, x23
        br x30


// if ((i + 128) * (i + 128) <= x) i += 128;
// if ((i + 64) * (i + 64) <= x) i += 64;
// if ((i + 32) * (i + 32) <= x) i += 32;
// if ((i + 16) * (i + 16) <= x) i += 16;
// if ((i + 8) * (i + 8) <= x) i += 8;
// if ((i + 4) * (i + 4) <= x) i += 4;
// if ((i + 2) * (i + 2) <= x) i += 2;
// if ((i + 1) * (i + 1) <= x) i += 1;
// return i;
// magic from https://stackoverflow.com/questions/3581528/how-is-the-square-root-function-implemented
sqrt:
    mov x22, xzr // i = 0
    mov x23, 128 // x22 = 128
    sqrt_loop:
        // because they are all powers of two, we can orr them instead of adding them
        orr x24, x22, x23 // x23 = i + x22
        mul x24, x24, x24 // x23 = (i+x22)^2
        cmp x24, x21
        b.gt sqrt_next         // if (i+x22) <= x
        orr x22, x22, x23 // i += x22
    sqrt_next:
        lsr x23, x23, 1      // x22 /= 2
        cbnz x23, sqrt_loop  // while x22 > 0 
    mov x21, x22             // return i
    br x30

