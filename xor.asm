.data
    buffer: .skip 100
    result: .asciz "Result: %d"
    readonly: .asciz "r"
    writeonly: .asciz "w"
    error: .asciz "Error occured"
    ok: .asciz "Ok"
.text
.global main
#format: in.txt out.txt byte
main:
    movq %rsp, %rbp #for correct debugging
    subq $32, %rsp
  
    movq 16(%rdx), %r13 #out.txt
    movq 24(%rdx), %r15 #byte
    movq 8(%rdx), %r12 #in.txt
    movq $0, %rax
    mov (%r15, %rax), %r14b
    
    movq %r12, %rcx
    movq $readonly, %rdx
    call fopen
    
    movq $buffer, %rcx
    movq $1, %rdx
    movq $100, %r8
    movq %rax, %r9
    call fread
    
    movq %rax, %rbx
    movq %rax, %rsi
    movq $buffer, %r11
    
_xor:
    cmp $0, %rbx
    dec %rbx
    je _write
    xor %r14, (%r11)
    inc %r11
    jmp _xor    
    
_write:
    movq %r13, %rcx #out.txt
    movq $writeonly, %rdx
    call fopen    
    mov %rax, %r15
                                                                     
    movq $buffer, %rcx
    movq %rsi, %rdx
    movq $1, %r8
    movq %rax, %r9 
    call fwrite  
    
    movq %r15, %rcx
    call fclose  
    
    movq %rbp, %rsp
    xorq %rax, %rax
    ret
