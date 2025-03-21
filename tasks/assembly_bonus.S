.section .data
black:    .asciz "\033[40m"
red:      .asciz "\033[41m"
green:    .asciz "\033[42m"
blue:     .asciz "\033[44m"
yellow:   .asciz "\033[43m"
white:    .asciz "\033[47m"
cyan:     .asciz "\033[46m"
magenta:  .asciz "\033[45m"
reset:    .asciz "\033[0m"

prompt:   .asciz "Enter up to 16 symbols (B, r, g, b, y, w, c, m):\n"
newline:  .asciz "\n"

.section .bss
input: .skip 17 // 16 characters + newline

.section .text
.global _start

_start:
    // print prompt
    mov x0, #1
    ldr x1, =prompt
    mov x2, #49          // prompt length
    mov x8, #64
    svc #0

    // read user input
    mov x0, #0
    ldr x1, =input
    mov x2, #17
    mov x8, #63
    svc #0

    // print a newline before the colored output
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    // start processing input
    ldr x3, =input
    mov x4, #0

print_loop:
    ldrb w5, [x3, x4]
    cmp w5, #10         // if the character is newline (\n), stop
    beq done
    cmp w5, #0          // if the character is null, stop
    beq done

    cmp w5, #'B'
    beq color_black
    cmp w5, #'r'
    beq color_red
    cmp w5, #'g'
    beq color_green
    cmp w5, #'b'
    beq color_blue
    cmp w5, #'y'
    beq color_yellow
    cmp w5, #'w'
    beq color_white
    cmp w5, #'c'
    beq color_cyan
    cmp w5, #'m'
    beq color_magenta

    // skip unknown character
    add x4, x4, #1
    b print_loop

// set the color before printing the character
color_black:   ldr x0, =black
               b print_char
color_red:     ldr x0, =red
               b print_char
color_green:   ldr x0, =green
               b print_char
color_blue:    ldr x0, =blue
               b print_char
color_yellow:  ldr x0, =yellow
               b print_char
color_white:   ldr x0, =white
               b print_char
color_cyan:    ldr x0, =cyan
               b print_char
color_magenta: ldr x0, =magenta
               b print_char

print_char:
    // print color escape sequence
    mov x1, x0
    mov x2, #5
    mov x0, #1
    mov x8, #64
    svc #0

    // print the character itself
    mov x0, #1
    adr x1, input       // get the correct character address
    add x1, x1, x4
    mov x2, #1
    mov x8, #64
    svc #0

    // move to the next character
    add x4, x4, #1
    b print_loop

done:
    // reset color (to avoid affecting the terminal)
    mov x0, #1
    ldr x1, =reset
    mov x2, #5
    mov x8, #64
    svc #0

    // print newline after the output
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    mov x8, #64
    svc #0

    // exit the program
    mov x0, #0
    mov x8, #93
    svc #0
