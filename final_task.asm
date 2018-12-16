.data
    result_msg: .asciz "It's for you: %d"
    error_msg: .asciz "Uncorrect"
    zero_mag: .asciz "Zero division"
.text
.global main
main:
    movq %rsp, %rbp #for correct debugging
    xorq %rax, %rax
    
    movq %rdx, %r12 #argv
    movq %rcx, %r10 #argc
    sub $1, %r10
    xor %r13, %r13 #счетчик
    
loop_calc:
    movq 8(%r12, %r13, 8), %r11
    jmp calc
_continue_loop:
    inc %r13
    cmpq %r10, %r13
    jl loop_calc
    
print:
    #вывод
    mov $result_msg, %rcx
    pop %rdx 
    mov (%rsp), %r10
    cmp $0x4013a5, %r10
    jne error
    call printf
    call exit

print_zero:
    mov $zero_mag, %rcx
    call printf
    call exit  
      
error:
    mov $error_msg, %rcx
    call printf
    call exit
    
calc:
    xor %al, %al
    mov (%r11), %al
    
    cmp $0x2b, %al
    je _add
    
    cmp $0x78, %al
    je _mul
    
    cmp $0x2f, %al
    je _div
    
    cmp $0x2d, %al
    je _sub
    
    xor %al, %al
    jmp  _atoi
    
_add:
    xor %rax, %rax
    xor %r8, %r8
    pop %r8
    pop %rax
    add %r8, %rax
    push %rax
    jmp _continue_loop 
    
_mul:
    xor %rax, %rax
    xor %r8, %r8
    pop %r8
    pop %rax
    imul %r8, %rax
    push %rax
    jmp _continue_loop 
    
_div:
    xor %rax, %rax
    xor %r8, %r8
    mov $0, %rdx
    pop %r8
    cmp $0, %r8
    je print_zero
    pop %rax
    div %r8
    push %rax
    jmp _continue_loop 
 
_sub:
    mov 1(%r11), %bl
    cmp $0, %bl
    jne _atoi 
    xor %rax, %rax
    xor %r8, %r8
    pop %r8
    pop %rax
    subq %r8, %rax
    push %rax
    jmp _continue_loop   

_num:
    cmp $1, %bl
    je __make_neg
__cont_num: 
    xor %bl, %bl
    push %r15
    jmp _continue_loop 

_atoi:
    mov $0, %r15 #previous
__get_next:
    mov (%r11), %r9b
    cmp $0x2d, %r9
    je __neg
    cmp $0, %r9
    je _num
    sub $0x30, %r9
    cmp $0, %r9
    jl error
    cmp $9, %r9
    jg error
    imul $10, %r15
    add %r15, %r9
    mov %r9, %r15
    inc %r11
    jmp __get_next    

__neg:
    mov $1, %bl  
    inc %r11 
    jmp __get_next
    
__make_neg:
    neg %r15
    jmp __cont_num