.data
    msg_error: .asciz "Where is correct operator??"
    operator = '%'
    a = 13
    b = 6
    result_msg: .asciz "It's for you: %d"
.text
.global main
main:
    movq %rsp, %rbp #for correct debugging
    subq $40, %rsp
    
    movq $operator, %rcx
    
    cmpq $0x2b, %rcx
    je _add
    
    cmpq $0x2a, %rcx
    je _mul
    
    cmpq $0x2f, %rcx
    je _div
    
    cmpq $0x2d, %rcx
    je _sub
    
    cmpq $0x25, %rcx
    je _mod
    
    jmp _error
    
_print:
    movq $result_msg, %rcx
    movq %rax, %rdx   
    call printf
    movq %rbp, %rsp
    xorq  %rax, %rax
    ret

_error:
    movq $msg_error, %rcx
    call printf
    movq %rbp, %rsp
    xorq  %rax, %rax
    ret
    
_add:
    xorq %rax, %rax
    movq $a, %rax
    addq $b, %rax
    jmp _print
    
_mul:
    xorq %rax, %rax
    movq $a, %rax
    imul $b, %rax
    jmp _print
    
_div:
    xorq %rax, %rax
    movq $0, %rdx
    movq $a, %rax
    movq $b, %rcx
    div %rcx
    jmp _print
    
_mod:
    xorq %rax, %rax
    movq $0, %rdx
    movq $a, %rax
    movq $b, %rcx
    div %rcx
    movq %rdx, %r8
    
    xorq %rdx, %rdx
    movq $result_msg, %rcx
    movq %r8, %rdx   
    call printf
    movq %rbp, %rsp
    xorq  %rax, %rax
    ret

_sub:
    xorq %rax, %rax
    movq $a, %rax
    subq $b, %rax
    jmp _print