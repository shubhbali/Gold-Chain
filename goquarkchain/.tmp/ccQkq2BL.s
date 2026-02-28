# 0 "gcc_amd64.S"
# 1 "C:\\Program Files\\Go\\src\\runtime\\cgo//"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "gcc_amd64.S"




.file "gcc_amd64.S"
# 25 "gcc_amd64.S"
.globl crosscall1
crosscall1:
 pushq %rbx
 pushq %rbp
 pushq %r12
 pushq %r13
 pushq %r14
 pushq %r15


 movq %r8, %rdi
 call *%rdx
 call *%rcx







 popq %r15
 popq %r14
 popq %r13
 popq %r12
 popq %rbp
 popq %rbx
 ret
