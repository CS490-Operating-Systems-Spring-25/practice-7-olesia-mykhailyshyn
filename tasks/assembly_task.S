    .section .data
buffer:      .space 256
newline:     .asciz "\n"
filename:    .asciz "file2.txt"

    .section .text
    .global _start

_start:
    // getcwd(buffer,256) — NR=17
    ldr     x0, =buffer
    mov     x1, #256
    mov     x8, #17
    svc     #0

    // strlen(buffer)
    ldr     x1, =buffer
    mov     x2, #0
strlen:
    ldrb    w3, [x1,x2]
    cbz     w3, done_strlen
    add     x2,x2,#1
    b       strlen
done_strlen:

    // write cwd + newline — NR=64
    mov     x0,#1
    ldr     x1,=buffer
    mov     x8,#64
    svc     #0
    mov     x0,#1
    ldr     x1,=newline
    mov     x2,#1
    mov     x8,#64
    svc     #0

    // openat(AT_FDCWD, filename, O_CREAT|O_WRONLY|O_TRUNC, 0644) — NR=56
    mov     x0,-100
    ldr     x1,=filename
    mov     x2,#577
    mov     x3,#0644
    mov     x8,#56
    svc     #0
    mov     x19,x0

    // fchmod(fd, 0755) — NR=52
    mov     x0,x19
    mov     x1,#0755
    mov     x8,#52
    svc     #0

    // fchown(fd, uid=1000, gid=1000) — NR=55
    mov     x0,x19
    mov     x1,#1000
    mov     x2,#1000
    mov     x8,#55
    svc     #0

    // close(fd) — NR=57
    mov     x0,x19
    mov     x8,#57
    svc     #0

    // exit — NR=94
    mov     x0,#1
    mov     x8,#94
    svc     #0
