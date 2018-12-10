.data
    result_msg: .asciz "It's for you: %d"
.text
.global main
main:
    movq %rsp, %rbp #for correct debugging
    xorq %rax, %rax
    
    movq %rbx, %rbp
    
    movq (%rbx), %r10 #argc
    xorq %r13, %r13 #счетчик
    
loop_calc:
    movq 8(%rbp, %r13, 8), %rcx
    call calc
    inc %r13
    cmpq %r10, %r13
    jl loop_calc
    
    #вывод
    movq $result_msg, %rcx
    pop %rdx   
    call printf
    ret

calc:
    cmpq $0x2b, %rcx
    je _add
    
    cmpq $0x2a, %rcx
    je _mul
    
    cmpq $0x2f, %rcx
    je _div
    
    cmpq $0x2d, %rcx
    je _sub
    
    cmpq $0x2f, %rcx
    jg _num
    
    cmpq $0x3a, %rcx
    jl _num
    
    #error
    
_add:
    xorq %rax, %rax
    pop %r8
    pop %rax
    addq %r8, %rax
    push %rax
    ret
    
_mul:
    xorq %rax, %rax
    pop %r8
    pop %rax
    imul %r8, %rax
    push %rax
    ret
    
_div:
    xorq %rax, %rax
    movq $0, %rdx
    pop %r8
    pop %rax
    div %r8
    push %rax
    ret
 
_sub:
    xorq %rax, %rax
    pop %r8
    pop %rax
    subq %r8, %rax
    push %rax
    ret   

_num:
    push %rcx
    ret    
    