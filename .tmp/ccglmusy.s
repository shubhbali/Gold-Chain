	.file	"gcc_libinit_windows.c"
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "//_/_/GOROOT/src/runtime/cgo" "gcc_libinit_windows.c"
	.section .rdata,"dr"
	.align 8
.LC0:
	.ascii "runtime: failed to create runtime initialization wait event.\12\0"
	.text
	.p2align 4
	.globl	_cgo_preinit_init
	.def	_cgo_preinit_init;	.scl	2;	.type	32;	.endef
	.seh_proc	_cgo_preinit_init
_cgo_preinit_init:
.LFB7693:
	.file 1 "gcc_libinit_windows.c"
	.loc 1 32 21 view -0
	.cfi_startproc
	subq	$40, %rsp
	.seh_stackalloc	40
	.cfi_def_cfa_offset 48
	.seh_endprologue
	.loc 1 33 3 view .LVU1
	.loc 1 33 23 is_stmt 0 view .LVU2
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movl	$1, %edx
	xorl	%ecx, %ecx
	call	*__imp_CreateEventA(%rip)
.LVL0:
	.loc 1 33 21 discriminator 1 view .LVU3
	movq	%rax, runtime_init_wait(%rip)
	.loc 1 34 3 is_stmt 1 view .LVU4
	.loc 1 34 6 is_stmt 0 view .LVU5
	testq	%rax, %rax
	je	.L4
	.loc 1 39 3 is_stmt 1 view .LVU6
	leaq	runtime_init_cs(%rip), %rcx
	.loc 1 40 1 is_stmt 0 view .LVU7
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	.loc 1 39 3 view .LVU8
	rex.W jmp	*__imp_InitializeCriticalSection(%rip)
.LVL1:
.L4:
	.cfi_restore_state
.LBB24:
.LBI24:
	.loc 1 32 1 is_stmt 1 view .LVU9
.LBB25:
	.loc 1 35 3 view .LVU10
	.loc 1 35 11 is_stmt 0 view .LVU11
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
.LVL2:
	.loc 1 35 3 discriminator 1 view .LVU12
	movl	$61, %r8d
	movl	$1, %edx
	leaq	.LC0(%rip), %rcx
	.loc 1 35 11 view .LVU13
	movq	%rax, %r9
	.loc 1 35 3 discriminator 1 view .LVU14
	call	fwrite
.LVL3:
	.loc 1 36 3 is_stmt 1 view .LVU15
	call	abort
	nop
.LVL4:
.LBE25:
.LBE24:
	.cfi_endproc
.LFE7693:
	.seh_endproc
	.p2align 4
	.globl	_cgo_maybe_run_preinit
	.def	_cgo_maybe_run_preinit;	.scl	2;	.type	32;	.endef
	.seh_proc	_cgo_maybe_run_preinit
_cgo_maybe_run_preinit:
.LFB7694:
	.loc 1 44 26 view -0
	.cfi_startproc
	pushq	%rbx
	.seh_pushreg	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.seh_stackalloc	32
	.cfi_def_cfa_offset 48
	.seh_endprologue
	.loc 1 45 3 view .LVU17
.LVL5:
.LBB44:
.LBI44:
	.file 2 "C:/msys64/ucrt64/include/psdk_inc/intrin-impl.h"
	.loc 2 1671 10 view .LVU18
.LBB45:
	.loc 2 1672 5 view .LVU19
	.loc 2 1672 12 is_stmt 0 view .LVU20
	xorl	%eax, %eax
	lock xaddl	%eax, runtime_init_once_done(%rip)
.LVL6:
	.loc 2 1672 12 view .LVU21
.LBE45:
.LBE44:
	.loc 1 45 6 discriminator 1 view .LVU22
	testl	%eax, %eax
	je	.L12
	.loc 1 57 1 view .LVU23
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L12:
	.cfi_restore_state
	.loc 1 46 4 is_stmt 1 view .LVU24
.LVL7:
.LBB46:
.LBI46:
	.loc 2 1693 10 view .LVU25
.LBB47:
	.loc 2 1694 4 view .LVU26
	.loc 2 1694 11 is_stmt 0 view .LVU27
	movl	$1, %eax
	lock xaddl	%eax, runtime_init_once_gate(%rip)
.LVL8:
	.loc 2 1694 11 view .LVU28
.LBE47:
.LBE46:
	.loc 1 46 7 discriminator 1 view .LVU29
	testl	%eax, %eax
	je	.L13
.LBB48:
.LBI48:
	.loc 1 44 1 is_stmt 1 view .LVU30
.LBB49:
	.loc 1 51 6 view .LVU31
.LVL9:
.LBB50:
.LBI50:
	.loc 2 1704 10 view .LVU32
.LBB51:
	.loc 2 1705 4 view .LVU33
	.loc 2 1705 11 is_stmt 0 view .LVU34
	lock subl	$1, runtime_init_once_gate(%rip)
.LVL10:
	.loc 2 1705 11 view .LVU35
.LBE51:
.LBE50:
	.loc 1 52 6 is_stmt 1 view .LVU36
	.loc 1 53 7 is_stmt 0 view .LVU37
	movq	__imp_Sleep(%rip), %rbx
.LBB53:
.LBB52:
	.loc 2 1705 11 view .LVU38
	jmp	.L9
	.p2align 4,,10
	.p2align 3
.L10:
.LBE52:
.LBE53:
	.loc 1 53 7 is_stmt 1 view .LVU39
	xorl	%ecx, %ecx
	call	*%rbx
.LVL11:
.L9:
	.loc 1 52 12 view .LVU40
.LBB54:
.LBI54:
	.loc 2 1671 10 view .LVU41
.LBB55:
	.loc 2 1672 5 view .LVU42
	.loc 2 1672 12 is_stmt 0 view .LVU43
	xorl	%eax, %eax
	lock xaddl	%eax, runtime_init_once_done(%rip)
.LVL12:
	.loc 2 1672 12 view .LVU44
.LBE55:
.LBE54:
	.loc 1 52 12 discriminator 1 view .LVU45
	testl	%eax, %eax
	je	.L10
.LBE49:
.LBE48:
	.loc 1 57 1 view .LVU46
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L13:
	.cfi_restore_state
	.loc 1 47 6 is_stmt 1 view .LVU47
	call	_cgo_preinit_init
.LVL13:
	.loc 1 48 6 view .LVU48
.LBB56:
.LBI56:
	.loc 2 1693 10 view .LVU49
.LBB57:
	.loc 2 1694 4 view .LVU50
	.loc 2 1694 11 is_stmt 0 view .LVU51
	lock addl	$1, runtime_init_once_done(%rip)
.LVL14:
	.loc 2 1694 11 view .LVU52
.LBE57:
.LBE56:
	.loc 1 57 1 view .LVU53
	addq	$32, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE7694:
	.seh_endproc
	.p2align 4
	.globl	_cgo_is_runtime_initialized
	.def	_cgo_is_runtime_initialized;	.scl	2;	.type	32;	.endef
	.seh_proc	_cgo_is_runtime_initialized
_cgo_is_runtime_initialized:
.LFB7696:
	.loc 1 65 31 is_stmt 1 view -0
	.cfi_startproc
	pushq	%rbx
	.seh_pushreg	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.seh_stackalloc	32
	.cfi_def_cfa_offset 48
	.seh_endprologue
	.loc 1 66 3 view .LVU55
	.loc 1 68 3 view .LVU56
	leaq	runtime_init_cs(%rip), %rcx
	call	*__imp_EnterCriticalSection(%rip)
.LVL15:
	.loc 1 69 3 view .LVU57
	.loc 1 69 10 is_stmt 0 view .LVU58
	movl	runtime_init_done(%rip), %ebx
.LVL16:
	.loc 1 70 3 is_stmt 1 view .LVU59
	leaq	runtime_init_cs(%rip), %rcx
	call	*__imp_LeaveCriticalSection(%rip)
.LVL17:
	.loc 1 71 3 view .LVU60
	.loc 1 72 1 is_stmt 0 view .LVU61
	movl	%ebx, %eax
	addq	$32, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
.LVL18:
	.loc 1 72 1 view .LVU62
	ret
	.cfi_endproc
.LFE7696:
	.seh_endproc
	.p2align 4
	.globl	_cgo_wait_runtime_init_done
	.def	_cgo_wait_runtime_init_done;	.scl	2;	.type	32;	.endef
	.seh_proc	_cgo_wait_runtime_init_done
_cgo_wait_runtime_init_done:
.LFB7697:
	.loc 1 75 35 is_stmt 1 view -0
	.cfi_startproc
	pushq	%rbp
	.seh_pushreg	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rdi
	.seh_pushreg	%rdi
	.cfi_def_cfa_offset 24
	.cfi_offset 5, -24
	pushq	%rsi
	.seh_pushreg	%rsi
	.cfi_def_cfa_offset 32
	.cfi_offset 4, -32
	pushq	%rbx
	.seh_pushreg	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	subq	$56, %rsp
	.seh_stackalloc	56
	.cfi_def_cfa_offset 96
	.seh_endprologue
	.loc 1 76 2 view .LVU64
	.loc 1 78 3 view .LVU65
	call	_cgo_maybe_run_preinit
.LVL19:
	.loc 1 79 2 view .LVU66
	movq	__imp_EnterCriticalSection(%rip), %rdi
	movq	__imp_LeaveCriticalSection(%rip), %rsi
	.loc 1 80 4 is_stmt 0 view .LVU67
	movq	__imp_WaitForSingleObject(%rip), %rbp
	.loc 1 79 8 view .LVU68
	jmp	.L16
	.p2align 4,,10
	.p2align 3
.L17:
	.loc 1 80 4 is_stmt 1 view .LVU69
	movq	runtime_init_wait(%rip), %rcx
	movl	$-1, %edx
	call	*%rbp
.LVL20:
.L16:
	.loc 1 79 9 view .LVU70
.LBB63:
.LBI63:
	.loc 1 65 1 view .LVU71
.LBB64:
	.loc 1 66 3 view .LVU72
	.loc 1 68 3 view .LVU73
	leaq	runtime_init_cs(%rip), %rcx
	call	*%rdi
.LVL21:
	.loc 1 69 3 view .LVU74
	.loc 1 69 10 is_stmt 0 view .LVU75
	movl	runtime_init_done(%rip), %ebx
.LVL22:
	.loc 1 70 3 is_stmt 1 view .LVU76
	leaq	runtime_init_cs(%rip), %rcx
	call	*%rsi
.LVL23:
	.loc 1 71 3 view .LVU77
	.loc 1 71 3 is_stmt 0 view .LVU78
.LBE64:
.LBE63:
	.loc 1 79 9 discriminator 1 view .LVU79
	testl	%ebx, %ebx
	je	.L17
	.loc 1 82 2 is_stmt 1 view .LVU80
.LBB65:
.LBI65:
	.loc 1 159 9 view .LVU81
.LBB66:
	.loc 1 160 2 view .LVU82
	.loc 1 162 2 view .LVU83
	leaq	runtime_init_cs(%rip), %rcx
	call	*%rdi
.LVL24:
	.loc 1 163 2 view .LVU84
	.loc 1 163 6 is_stmt 0 view .LVU85
	movq	cgo_context_function(%rip), %rbx
.LVL25:
	.loc 1 164 2 is_stmt 1 view .LVU86
	leaq	runtime_init_cs(%rip), %rcx
	call	*%rsi
.LVL26:
	.loc 1 165 2 view .LVU87
	.loc 1 165 2 is_stmt 0 view .LVU88
.LBE66:
.LBE65:
	.loc 1 83 2 is_stmt 1 view .LVU89
	.loc 1 90 9 is_stmt 0 view .LVU90
	xorl	%eax, %eax
	.loc 1 83 5 view .LVU91
	testq	%rbx, %rbx
	je	.L15
.LBB67:
	.loc 1 84 3 is_stmt 1 view .LVU92
	.loc 1 86 3 view .LVU93
	.loc 1 86 15 is_stmt 0 view .LVU94
	movq	$0, 40(%rsp)
	.loc 1 87 3 is_stmt 1 view .LVU95
	.loc 1 87 4 is_stmt 0 view .LVU96
	leaq	40(%rsp), %rcx
	call	*%rbx
.LVL27:
	.loc 1 88 3 is_stmt 1 view .LVU97
	.loc 1 88 13 is_stmt 0 view .LVU98
	movq	40(%rsp), %rax
.L15:
.LBE67:
	.loc 1 91 1 view .LVU99
	addq	$56, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 32
.LVL28:
	.loc 1 91 1 view .LVU100
	popq	%rsi
	.cfi_restore 4
	.cfi_def_cfa_offset 24
	popq	%rdi
	.cfi_restore 5
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE7697:
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC1:
	.ascii "unexpected cgo_bindm on Windows\12\0"
	.text
	.p2align 4
	.globl	x_cgo_bindm
	.def	x_cgo_bindm;	.scl	2;	.type	32;	.endef
	.seh_proc	x_cgo_bindm
x_cgo_bindm:
.LVL29:
.LFB7698:
	.loc 1 94 31 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 94 31 is_stmt 0 view .LVU102
	subq	$40, %rsp
	.seh_stackalloc	40
	.cfi_def_cfa_offset 48
	.seh_endprologue
	.loc 1 95 2 is_stmt 1 view .LVU103
	.loc 1 95 10 is_stmt 0 view .LVU104
	movl	$2, %ecx
.LVL30:
	.loc 1 95 10 view .LVU105
	call	*__imp___acrt_iob_func(%rip)
.LVL31:
	.loc 1 95 2 discriminator 1 view .LVU106
	movl	$32, %r8d
	movl	$1, %edx
	leaq	.LC1(%rip), %rcx
	.loc 1 95 10 view .LVU107
	movq	%rax, %r9
	.loc 1 95 2 discriminator 1 view .LVU108
	call	fwrite
.LVL32:
	.loc 1 96 2 is_stmt 1 view .LVU109
	call	abort
	nop
.LVL33:
	.cfi_endproc
.LFE7698:
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC2:
	.ascii "runtime: failed to signal runtime initialization complete.\12\0"
	.text
	.p2align 4
	.globl	x_cgo_notify_runtime_init_done
	.def	x_cgo_notify_runtime_init_done;	.scl	2;	.type	32;	.endef
	.seh_proc	x_cgo_notify_runtime_init_done
x_cgo_notify_runtime_init_done:
.LVL34:
.LFB7699:
	.loc 1 100 45 view -0
	.cfi_startproc
	.loc 1 100 45 is_stmt 0 view .LVU111
	subq	$40, %rsp
	.seh_stackalloc	40
	.cfi_def_cfa_offset 48
	.seh_endprologue
	.loc 1 101 3 is_stmt 1 view .LVU112
	call	_cgo_maybe_run_preinit
.LVL35:
	.loc 1 103 3 view .LVU113
	leaq	runtime_init_cs(%rip), %rcx
	call	*__imp_EnterCriticalSection(%rip)
.LVL36:
	.loc 1 104 2 view .LVU114
	.loc 1 105 3 is_stmt 0 view .LVU115
	leaq	runtime_init_cs(%rip), %rcx
	.loc 1 104 20 view .LVU116
	movl	$1, runtime_init_done(%rip)
	.loc 1 105 3 is_stmt 1 view .LVU117
	call	*__imp_LeaveCriticalSection(%rip)
.LVL37:
	.loc 1 107 3 view .LVU118
	.loc 1 107 8 is_stmt 0 view .LVU119
	movq	runtime_init_wait(%rip), %rcx
	call	*__imp_SetEvent(%rip)
.LVL38:
	.loc 1 107 6 discriminator 1 view .LVU120
	testl	%eax, %eax
	je	.L24
	.loc 1 111 1 view .LVU121
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L24:
	.cfi_restore_state
	.loc 1 108 3 is_stmt 1 view .LVU122
	.loc 1 108 11 is_stmt 0 view .LVU123
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
.LVL39:
	.loc 1 108 3 discriminator 1 view .LVU124
	movl	$59, %r8d
	movl	$1, %edx
	leaq	.LC2(%rip), %rcx
	.loc 1 108 11 view .LVU125
	movq	%rax, %r9
	.loc 1 108 3 discriminator 1 view .LVU126
	call	fwrite
.LVL40:
	.loc 1 109 3 is_stmt 1 view .LVU127
	call	abort
	nop
.LVL41:
	.cfi_endproc
.LFE7699:
	.seh_endproc
	.p2align 4
	.globl	x_cgo_set_traceback_functions
	.def	x_cgo_set_traceback_functions;	.scl	2;	.type	32;	.endef
	.seh_proc	x_cgo_set_traceback_functions
x_cgo_set_traceback_functions:
.LVL42:
.LFB7700:
	.loc 1 124 77 view -0
	.cfi_startproc
	.loc 1 124 77 is_stmt 0 view .LVU129
	pushq	%rbx
	.seh_pushreg	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.seh_stackalloc	32
	.cfi_def_cfa_offset 48
	.seh_endprologue
	.loc 1 125 2 is_stmt 1 view .LVU130
	.loc 1 124 77 is_stmt 0 view .LVU131
	movq	%rcx, %rbx
	.loc 1 125 2 view .LVU132
	leaq	runtime_init_cs(%rip), %rcx
.LVL43:
	.loc 1 125 2 view .LVU133
	call	*__imp_EnterCriticalSection(%rip)
.LVL44:
	.loc 1 126 2 is_stmt 1 view .LVU134
	.loc 1 126 25 is_stmt 0 view .LVU135
	movq	(%rbx), %rax
	.loc 1 129 2 view .LVU136
	leaq	runtime_init_cs(%rip), %rcx
	.loc 1 126 25 view .LVU137
	movq	%rax, cgo_traceback_function(%rip)
	.loc 1 127 2 is_stmt 1 view .LVU138
	.loc 1 127 23 is_stmt 0 view .LVU139
	movq	8(%rbx), %rax
	movq	%rax, cgo_context_function(%rip)
	.loc 1 128 2 is_stmt 1 view .LVU140
	.loc 1 128 26 is_stmt 0 view .LVU141
	movq	16(%rbx), %rax
	movq	%rax, cgo_symbolizer_function(%rip)
	.loc 1 129 2 is_stmt 1 view .LVU142
	.loc 1 130 1 is_stmt 0 view .LVU143
	addq	$32, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
.LVL45:
	.loc 1 129 2 view .LVU144
	rex.W jmp	*__imp_LeaveCriticalSection(%rip)
.LVL46:
	.cfi_endproc
.LFE7700:
	.seh_endproc
	.p2align 4
	.globl	_cgo_get_traceback_function
	.def	_cgo_get_traceback_function;	.scl	2;	.type	32;	.endef
	.seh_proc	_cgo_get_traceback_function
_cgo_get_traceback_function:
.LFB7701:
	.loc 1 133 70 is_stmt 1 view -0
	.cfi_startproc
	pushq	%rbx
	.seh_pushreg	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.seh_stackalloc	32
	.cfi_def_cfa_offset 48
	.seh_endprologue
	.loc 1 134 2 view .LVU146
	.loc 1 136 2 view .LVU147
	leaq	runtime_init_cs(%rip), %rcx
	call	*__imp_EnterCriticalSection(%rip)
.LVL47:
	.loc 1 137 2 view .LVU148
	.loc 1 137 6 is_stmt 0 view .LVU149
	movq	cgo_traceback_function(%rip), %rbx
.LVL48:
	.loc 1 138 2 is_stmt 1 view .LVU150
	leaq	runtime_init_cs(%rip), %rcx
	call	*__imp_LeaveCriticalSection(%rip)
.LVL49:
	.loc 1 139 2 view .LVU151
	.loc 1 140 1 is_stmt 0 view .LVU152
	movq	%rbx, %rax
	addq	$32, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
.LVL50:
	.loc 1 140 1 view .LVU153
	ret
	.cfi_endproc
.LFE7701:
	.seh_endproc
	.p2align 4
	.globl	x_cgo_call_traceback_function
	.def	x_cgo_call_traceback_function;	.scl	2;	.type	32;	.endef
	.seh_proc	x_cgo_call_traceback_function
x_cgo_call_traceback_function:
.LVL51:
.LFB7702:
	.loc 1 146 65 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 146 65 is_stmt 0 view .LVU155
	pushq	%rsi
	.seh_pushreg	%rsi
	.cfi_def_cfa_offset 16
	.cfi_offset 4, -16
	pushq	%rbx
	.seh_pushreg	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$40, %rsp
	.seh_stackalloc	40
	.cfi_def_cfa_offset 64
	.seh_endprologue
	.loc 1 147 2 is_stmt 1 view .LVU156
	.loc 1 149 2 view .LVU157
.LBB70:
.LBI70:
	.loc 1 133 9 view .LVU158
.LBB71:
	.loc 1 134 2 view .LVU159
	.loc 1 136 2 view .LVU160
.LBE71:
.LBE70:
	.loc 1 146 65 is_stmt 0 view .LVU161
	movq	%rcx, %rsi
.LBB73:
.LBB72:
	.loc 1 136 2 view .LVU162
	leaq	runtime_init_cs(%rip), %rcx
.LVL52:
	.loc 1 136 2 view .LVU163
	call	*__imp_EnterCriticalSection(%rip)
.LVL53:
	.loc 1 137 2 is_stmt 1 view .LVU164
	.loc 1 137 6 is_stmt 0 view .LVU165
	movq	cgo_traceback_function(%rip), %rbx
.LVL54:
	.loc 1 138 2 is_stmt 1 view .LVU166
	leaq	runtime_init_cs(%rip), %rcx
	call	*__imp_LeaveCriticalSection(%rip)
.LVL55:
	.loc 1 139 2 view .LVU167
	.loc 1 139 2 is_stmt 0 view .LVU168
.LBE72:
.LBE73:
	.loc 1 150 2 is_stmt 1 view .LVU169
	.loc 1 150 5 is_stmt 0 view .LVU170
	testq	%rbx, %rbx
	je	.L27
	.loc 1 154 2 is_stmt 1 view .LVU171
	.loc 1 154 3 is_stmt 0 view .LVU172
	movq	%rsi, %rcx
	movq	%rbx, %rax
	.loc 1 155 1 view .LVU173
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
.LVL56:
	.loc 1 155 1 view .LVU174
	popq	%rsi
	.cfi_restore 4
	.cfi_def_cfa_offset 8
.LVL57:
	.loc 1 154 3 view .LVU175
	rex.W jmp	*%rax
.LVL58:
	.p2align 4,,10
	.p2align 3
.L27:
	.cfi_restore_state
	.loc 1 155 1 view .LVU176
	addq	$40, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
.LVL59:
	.loc 1 155 1 view .LVU177
	popq	%rsi
	.cfi_restore 4
	.cfi_def_cfa_offset 8
.LVL60:
	.loc 1 155 1 view .LVU178
	ret
	.cfi_endproc
.LFE7702:
	.seh_endproc
	.p2align 4
	.globl	_cgo_get_context_function
	.def	_cgo_get_context_function;	.scl	2;	.type	32;	.endef
	.seh_proc	_cgo_get_context_function
_cgo_get_context_function:
.LFB7703:
	.loc 1 159 66 is_stmt 1 view -0
	.cfi_startproc
	pushq	%rbx
	.seh_pushreg	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.seh_stackalloc	32
	.cfi_def_cfa_offset 48
	.seh_endprologue
	.loc 1 160 2 view .LVU180
	.loc 1 162 2 view .LVU181
	leaq	runtime_init_cs(%rip), %rcx
	call	*__imp_EnterCriticalSection(%rip)
.LVL61:
	.loc 1 163 2 view .LVU182
	.loc 1 163 6 is_stmt 0 view .LVU183
	movq	cgo_context_function(%rip), %rbx
.LVL62:
	.loc 1 164 2 is_stmt 1 view .LVU184
	leaq	runtime_init_cs(%rip), %rcx
	call	*__imp_LeaveCriticalSection(%rip)
.LVL63:
	.loc 1 165 2 view .LVU185
	.loc 1 166 1 is_stmt 0 view .LVU186
	movq	%rbx, %rax
	addq	$32, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
.LVL64:
	.loc 1 166 1 view .LVU187
	ret
	.cfi_endproc
.LFE7703:
	.seh_endproc
	.p2align 4
	.globl	_cgo_get_symbolizer_function
	.def	_cgo_get_symbolizer_function;	.scl	2;	.type	32;	.endef
	.seh_proc	_cgo_get_symbolizer_function
_cgo_get_symbolizer_function:
.LFB7704:
	.loc 1 169 72 is_stmt 1 view -0
	.cfi_startproc
	pushq	%rbx
	.seh_pushreg	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.seh_stackalloc	32
	.cfi_def_cfa_offset 48
	.seh_endprologue
	.loc 1 170 2 view .LVU189
	.loc 1 172 2 view .LVU190
	leaq	runtime_init_cs(%rip), %rcx
	call	*__imp_EnterCriticalSection(%rip)
.LVL65:
	.loc 1 173 2 view .LVU191
	.loc 1 173 6 is_stmt 0 view .LVU192
	movq	cgo_symbolizer_function(%rip), %rbx
.LVL66:
	.loc 1 174 2 is_stmt 1 view .LVU193
	leaq	runtime_init_cs(%rip), %rcx
	call	*__imp_LeaveCriticalSection(%rip)
.LVL67:
	.loc 1 175 2 view .LVU194
	.loc 1 176 1 is_stmt 0 view .LVU195
	movq	%rbx, %rax
	addq	$32, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
.LVL68:
	.loc 1 176 1 view .LVU196
	ret
	.cfi_endproc
.LFE7704:
	.seh_endproc
	.p2align 4
	.globl	x_cgo_call_symbolizer_function
	.def	x_cgo_call_symbolizer_function;	.scl	2;	.type	32;	.endef
	.seh_proc	x_cgo_call_symbolizer_function
x_cgo_call_symbolizer_function:
.LVL69:
.LFB7705:
	.loc 1 182 67 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 182 67 is_stmt 0 view .LVU198
	pushq	%rsi
	.seh_pushreg	%rsi
	.cfi_def_cfa_offset 16
	.cfi_offset 4, -16
	pushq	%rbx
	.seh_pushreg	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$40, %rsp
	.seh_stackalloc	40
	.cfi_def_cfa_offset 64
	.seh_endprologue
	.loc 1 183 2 is_stmt 1 view .LVU199
	.loc 1 185 2 view .LVU200
.LBB76:
.LBI76:
	.loc 1 169 9 view .LVU201
.LBB77:
	.loc 1 170 2 view .LVU202
	.loc 1 172 2 view .LVU203
.LBE77:
.LBE76:
	.loc 1 182 67 is_stmt 0 view .LVU204
	movq	%rcx, %rsi
.LBB79:
.LBB78:
	.loc 1 172 2 view .LVU205
	leaq	runtime_init_cs(%rip), %rcx
.LVL70:
	.loc 1 172 2 view .LVU206
	call	*__imp_EnterCriticalSection(%rip)
.LVL71:
	.loc 1 173 2 is_stmt 1 view .LVU207
	.loc 1 173 6 is_stmt 0 view .LVU208
	movq	cgo_symbolizer_function(%rip), %rbx
.LVL72:
	.loc 1 174 2 is_stmt 1 view .LVU209
	leaq	runtime_init_cs(%rip), %rcx
	call	*__imp_LeaveCriticalSection(%rip)
.LVL73:
	.loc 1 175 2 view .LVU210
	.loc 1 175 2 is_stmt 0 view .LVU211
.LBE78:
.LBE79:
	.loc 1 186 2 is_stmt 1 view .LVU212
	.loc 1 186 5 is_stmt 0 view .LVU213
	testq	%rbx, %rbx
	je	.L31
	.loc 1 190 2 is_stmt 1 view .LVU214
	.loc 1 190 3 is_stmt 0 view .LVU215
	movq	%rsi, %rcx
	movq	%rbx, %rax
	.loc 1 191 1 view .LVU216
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
.LVL74:
	.loc 1 191 1 view .LVU217
	popq	%rsi
	.cfi_restore 4
	.cfi_def_cfa_offset 8
.LVL75:
	.loc 1 190 3 view .LVU218
	rex.W jmp	*%rax
.LVL76:
	.p2align 4,,10
	.p2align 3
.L31:
	.cfi_restore_state
	.loc 1 191 1 view .LVU219
	addq	$40, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
.LVL77:
	.loc 1 191 1 view .LVU220
	popq	%rsi
	.cfi_restore 4
	.cfi_def_cfa_offset 8
.LVL78:
	.loc 1 191 1 view .LVU221
	ret
	.cfi_endproc
.LFE7705:
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC3:
	.ascii "runtime: failed to create new OS thread (%lu)\12\0"
	.text
	.p2align 4
	.globl	_cgo_beginthread
	.def	_cgo_beginthread;	.scl	2;	.type	32;	.endef
	.seh_proc	_cgo_beginthread
_cgo_beginthread:
.LVL79:
.LFB7706:
	.loc 1 193 74 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 193 74 is_stmt 0 view .LVU223
	pushq	%rdi
	.seh_pushreg	%rdi
	.cfi_def_cfa_offset 16
	.cfi_offset 5, -16
	pushq	%rsi
	.seh_pushreg	%rsi
	.cfi_def_cfa_offset 24
	.cfi_offset 4, -24
	pushq	%rbx
	.seh_pushreg	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$48, %rsp
	.seh_stackalloc	48
	.cfi_def_cfa_offset 80
	.seh_endprologue
	.loc 1 194 2 is_stmt 1 view .LVU224
	.loc 1 195 2 view .LVU225
	.loc 1 197 2 view .LVU226
.LVL80:
	.loc 1 197 24 discriminator 1 view .LVU227
	.loc 1 197 13 is_stmt 0 view .LVU228
	xorl	%edi, %edi
	.loc 1 193 74 view .LVU229
	movq	%rcx, %rsi
	movq	%rdx, %rbx
.LVL81:
.L36:
	.loc 1 198 3 is_stmt 1 view .LVU230
	.loc 1 198 13 is_stmt 0 view .LVU231
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	movl	$0, 32(%rsp)
	movq	%rbx, %r9
	movq	$0, 40(%rsp)
	movq	%rsi, %r8
	call	*__imp_CreateThread(%rip)
.LVL82:
	.loc 1 199 3 is_stmt 1 view .LVU232
	.loc 1 199 6 is_stmt 0 view .LVU233
	testq	%rax, %rax
	jne	.L34
	.loc 1 199 23 discriminator 1 view .LVU234
	call	*__imp_GetLastError(%rip)
.LVL83:
	.loc 1 199 20 discriminator 2 view .LVU235
	cmpl	$5, %eax
	je	.L38
.L35:
	.loc 1 212 2 is_stmt 1 view .LVU236
	call	*__imp_GetLastError(%rip)
.LVL84:
	.loc 1 212 10 is_stmt 0 discriminator 1 view .LVU237
	movl	$2, %ecx
	.loc 1 212 2 view .LVU238
	movl	%eax, %ebx
.LVL85:
	.loc 1 212 10 discriminator 1 view .LVU239
	call	*__imp___acrt_iob_func(%rip)
.LVL86:
	.loc 1 212 2 discriminator 2 view .LVU240
	movl	%ebx, %r8d
	leaq	.LC3(%rip), %rdx
	movq	%rax, %rcx
	call	fprintf
.LVL87:
	.loc 1 213 2 is_stmt 1 view .LVU241
	call	abort
.LVL88:
	.p2align 4,,10
	.p2align 3
.L34:
	.loc 1 205 10 view .LVU242
	.loc 1 208 3 view .LVU243
	movq	%rax, %rcx
	.loc 1 214 1 is_stmt 0 view .LVU244
	addq	$48, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 24
.LVL89:
	.loc 1 214 1 view .LVU245
	popq	%rsi
	.cfi_restore 4
	.cfi_def_cfa_offset 16
.LVL90:
	.loc 1 214 1 view .LVU246
	popq	%rdi
	.cfi_restore 5
	.cfi_def_cfa_offset 8
.LVL91:
	.loc 1 208 3 view .LVU247
	rex.W jmp	*__imp_CloseHandle(%rip)
.LVL92:
	.p2align 4,,10
	.p2align 3
.L38:
	.cfi_restore_state
	.loc 1 203 4 is_stmt 1 view .LVU248
	movl	%edi, %ecx
	.loc 1 197 35 is_stmt 0 discriminator 2 view .LVU249
	addl	$1, %edi
.LVL93:
	.loc 1 203 4 view .LVU250
	call	*__imp_Sleep(%rip)
.LVL94:
	.loc 1 204 4 is_stmt 1 view .LVU251
	.loc 1 197 35 discriminator 2 view .LVU252
	.loc 1 197 24 discriminator 1 view .LVU253
	cmpl	$20, %edi
	jne	.L36
	jmp	.L35
	.cfi_endproc
.LFE7706:
	.seh_endproc
	.p2align 4
	.globl	x_cgo_sys_thread_create
	.def	x_cgo_sys_thread_create;	.scl	2;	.type	32;	.endef
	.seh_proc	x_cgo_sys_thread_create
x_cgo_sys_thread_create:
.LVL95:
.LFB7695:
	.loc 1 60 76 view -0
	.cfi_startproc
	.loc 1 60 76 is_stmt 0 view .LVU255
	.seh_endprologue
	.loc 1 61 2 is_stmt 1 view .LVU256
	.loc 1 62 1 is_stmt 0 view .LVU257
	.loc 1 61 2 view .LVU258
	jmp	_cgo_beginthread
.LVL96:
	.loc 1 61 2 view .LVU259
	.cfi_endproc
.LFE7695:
	.seh_endproc
.lcomm cgo_symbolizer_function,8,8
.lcomm cgo_context_function,8,8
.lcomm cgo_traceback_function,8,8
	.globl	x_crosscall2_ptr
	.bss
	.align 8
x_crosscall2_ptr:
	.space 8
	.globl	x_cgo_pthread_key_created
	.align 8
x_cgo_pthread_key_created:
	.space 8
.lcomm runtime_init_done,4,4
.lcomm runtime_init_wait,8,8
.lcomm runtime_init_cs,40,32
.lcomm runtime_init_once_done,4,4
.lcomm runtime_init_once_gate,4,4
	.text
.Letext0:
	.file 3 "C:/msys64/ucrt64/include/corecrt.h"
	.file 4 "C:/msys64/ucrt64/include/minwindef.h"
	.file 5 "C:/msys64/ucrt64/include/basetsd.h"
	.file 6 "C:/msys64/ucrt64/include/winnt.h"
	.file 7 "C:/msys64/ucrt64/include/minwinbase.h"
	.file 8 "C:/msys64/ucrt64/include/stdio.h"
	.file 9 "libcgo.h"
	.file 10 "C:/msys64/ucrt64/include/handleapi.h"
	.file 11 "C:/msys64/ucrt64/include/processthreadsapi.h"
	.file 12 "C:/msys64/ucrt64/include/synchapi.h"
	.file 13 "C:/msys64/ucrt64/include/errhandlingapi.h"
	.file 14 "C:/msys64/ucrt64/include/stdlib.h"
	.file 15 "<built-in>"
	.section	.debug_info,"dr"
.Ldebug_info0:
	.long	0x17c6
	.word	0x5
	.byte	0x1
	.byte	0x8
	.secrel32	.Ldebug_abbrev0
	.uleb128 0x28
	.ascii "GNU C23 15.2.0\0"
	.byte	0x1d
	.byte	0x3
	.long	0x31647
	.secrel32	.LASF0
	.secrel32	.LASF1
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.secrel32	.Ldebug_line0
	.uleb128 0x5
	.byte	0x1
	.byte	0x6
	.ascii "char\0"
	.uleb128 0x21
	.long	0x3e
	.uleb128 0x8
	.ascii "size_t\0"
	.byte	0x3
	.byte	0x23
	.byte	0x2c
	.long	0x5a
	.uleb128 0x5
	.byte	0x8
	.byte	0x7
	.ascii "long long unsigned int\0"
	.uleb128 0x5
	.byte	0x8
	.byte	0x5
	.ascii "long long int\0"
	.uleb128 0x8
	.ascii "uintptr_t\0"
	.byte	0x3
	.byte	0x4b
	.byte	0x2c
	.long	0x5a
	.uleb128 0x5
	.byte	0x2
	.byte	0x7
	.ascii "short unsigned int\0"
	.uleb128 0x5
	.byte	0x4
	.byte	0x5
	.ascii "int\0"
	.uleb128 0x5
	.byte	0x4
	.byte	0x5
	.ascii "long int\0"
	.uleb128 0x22
	.long	0xb4
	.uleb128 0x5
	.byte	0x4
	.byte	0x7
	.ascii "unsigned int\0"
	.uleb128 0x5
	.byte	0x4
	.byte	0x7
	.ascii "long unsigned int\0"
	.uleb128 0x29
	.byte	0x8
	.uleb128 0x5
	.byte	0x1
	.byte	0x8
	.ascii "unsigned char\0"
	.uleb128 0x8
	.ascii "WINBOOL\0"
	.byte	0x4
	.byte	0x7f
	.byte	0xd
	.long	0xad
	.uleb128 0x8
	.ascii "WORD\0"
	.byte	0x4
	.byte	0x8c
	.byte	0x1a
	.long	0x97
	.uleb128 0x8
	.ascii "DWORD\0"
	.byte	0x4
	.byte	0x8d
	.byte	0x1d
	.long	0xd5
	.uleb128 0x5
	.byte	0x4
	.byte	0x4
	.ascii "float\0"
	.uleb128 0x3
	.long	0x11a
	.uleb128 0x8
	.ascii "LPDWORD\0"
	.byte	0x4
	.byte	0x98
	.byte	0x12
	.long	0x131
	.uleb128 0x8
	.ascii "LPVOID\0"
	.byte	0x4
	.byte	0x99
	.byte	0x11
	.long	0xea
	.uleb128 0x5
	.byte	0x1
	.byte	0x6
	.ascii "signed char\0"
	.uleb128 0x5
	.byte	0x2
	.byte	0x5
	.ascii "short int\0"
	.uleb128 0x8
	.ascii "ULONG_PTR\0"
	.byte	0x5
	.byte	0x31
	.byte	0x2e
	.long	0x5a
	.uleb128 0x8
	.ascii "SIZE_T\0"
	.byte	0x5
	.byte	0x93
	.byte	0x27
	.long	0x171
	.uleb128 0xd
	.ascii "CHAR\0"
	.word	0x12e
	.byte	0x10
	.long	0x3e
	.uleb128 0x21
	.long	0x192
	.uleb128 0xd
	.ascii "LONG\0"
	.word	0x130
	.byte	0x14
	.long	0xb4
	.uleb128 0x22
	.long	0x1a4
	.uleb128 0x3
	.long	0x19f
	.uleb128 0xd
	.ascii "LPCSTR\0"
	.word	0x164
	.byte	0x17
	.long	0x1b6
	.uleb128 0xd
	.ascii "HANDLE\0"
	.word	0x1b2
	.byte	0x11
	.long	0xea
	.uleb128 0x1b
	.ascii "_LIST_ENTRY\0"
	.byte	0x10
	.word	0x284
	.byte	0x12
	.long	0x20d
	.uleb128 0x6
	.ascii "Flink\0"
	.word	0x285
	.byte	0x19
	.long	0x20d
	.byte	0
	.uleb128 0x6
	.ascii "Blink\0"
	.word	0x286
	.byte	0x19
	.long	0x20d
	.byte	0x8
	.byte	0
	.uleb128 0x3
	.long	0x1d9
	.uleb128 0xd
	.ascii "LIST_ENTRY\0"
	.word	0x287
	.byte	0x5
	.long	0x1d9
	.uleb128 0x5
	.byte	0x10
	.byte	0x4
	.ascii "long double\0"
	.uleb128 0x5
	.byte	0x8
	.byte	0x4
	.ascii "double\0"
	.uleb128 0x5
	.byte	0x4
	.byte	0x4
	.ascii "float\0"
	.uleb128 0x5
	.byte	0x8
	.byte	0x4
	.ascii "double\0"
	.uleb128 0x5
	.byte	0x2
	.byte	0x4
	.ascii "_Float16\0"
	.uleb128 0x5
	.byte	0x2
	.byte	0x4
	.ascii "__bf16\0"
	.uleb128 0x2a
	.ascii "JOB_OBJECT_NET_RATE_CONTROL_FLAGS\0"
	.byte	0x7
	.byte	0x4
	.long	0xc5
	.byte	0x6
	.word	0x142f
	.byte	0x12
	.long	0x33b
	.uleb128 0x17
	.ascii "JOB_OBJECT_NET_RATE_CONTROL_ENABLE\0"
	.byte	0x1
	.uleb128 0x17
	.ascii "JOB_OBJECT_NET_RATE_CONTROL_MAX_BANDWIDTH\0"
	.byte	0x2
	.uleb128 0x17
	.ascii "JOB_OBJECT_NET_RATE_CONTROL_DSCP_TAG\0"
	.byte	0x4
	.uleb128 0x17
	.ascii "JOB_OBJECT_NET_RATE_CONTROL_VALID_FLAGS\0"
	.byte	0x7
	.byte	0
	.uleb128 0x1b
	.ascii "_RTL_CRITICAL_SECTION_DEBUG\0"
	.byte	0x30
	.word	0x2544
	.byte	0x14
	.long	0x433
	.uleb128 0x6
	.ascii "Type\0"
	.word	0x2545
	.byte	0xc
	.long	0x10d
	.byte	0
	.uleb128 0x6
	.ascii "CreatorBackTraceIndex\0"
	.word	0x2546
	.byte	0xc
	.long	0x10d
	.byte	0x2
	.uleb128 0x6
	.ascii "CriticalSection\0"
	.word	0x2547
	.byte	0x25
	.long	0x4d1
	.byte	0x8
	.uleb128 0x6
	.ascii "ProcessLocksList\0"
	.word	0x2548
	.byte	0x12
	.long	0x212
	.byte	0x10
	.uleb128 0x6
	.ascii "EntryCount\0"
	.word	0x2549
	.byte	0xd
	.long	0x11a
	.byte	0x20
	.uleb128 0x6
	.ascii "ContentionCount\0"
	.word	0x254a
	.byte	0xd
	.long	0x11a
	.byte	0x24
	.uleb128 0x6
	.ascii "Flags\0"
	.word	0x254b
	.byte	0xd
	.long	0x11a
	.byte	0x28
	.uleb128 0x6
	.ascii "CreatorBackTraceIndexHigh\0"
	.word	0x254c
	.byte	0xc
	.long	0x10d
	.byte	0x2c
	.uleb128 0x6
	.ascii "SpareWORD\0"
	.word	0x254d
	.byte	0xc
	.long	0x10d
	.byte	0x2e
	.byte	0
	.uleb128 0x1b
	.ascii "_RTL_CRITICAL_SECTION\0"
	.byte	0x28
	.word	0x255f
	.byte	0x14
	.long	0x4d1
	.uleb128 0x6
	.ascii "DebugInfo\0"
	.word	0x2560
	.byte	0x23
	.long	0x4d6
	.byte	0
	.uleb128 0x6
	.ascii "LockCount\0"
	.word	0x2561
	.byte	0xc
	.long	0x1a4
	.byte	0x8
	.uleb128 0x6
	.ascii "RecursionCount\0"
	.word	0x2562
	.byte	0xc
	.long	0x1a4
	.byte	0xc
	.uleb128 0x6
	.ascii "OwningThread\0"
	.word	0x2563
	.byte	0xe
	.long	0x1ca
	.byte	0x10
	.uleb128 0x6
	.ascii "LockSemaphore\0"
	.word	0x2564
	.byte	0xe
	.long	0x1ca
	.byte	0x18
	.uleb128 0x6
	.ascii "SpinCount\0"
	.word	0x2565
	.byte	0x11
	.long	0x171
	.byte	0x20
	.byte	0
	.uleb128 0x3
	.long	0x433
	.uleb128 0xd
	.ascii "PRTL_CRITICAL_SECTION_DEBUG\0"
	.word	0x254e
	.byte	0x23
	.long	0x4fa
	.uleb128 0x3
	.long	0x33b
	.uleb128 0xd
	.ascii "RTL_CRITICAL_SECTION\0"
	.word	0x2566
	.byte	0x7
	.long	0x433
	.uleb128 0xd
	.ascii "PRTL_CRITICAL_SECTION\0"
	.word	0x2566
	.byte	0x1d
	.long	0x4d1
	.uleb128 0x12
	.ascii "_SECURITY_ATTRIBUTES\0"
	.byte	0x18
	.byte	0x7
	.byte	0xd
	.byte	0x12
	.long	0x5a0
	.uleb128 0x7
	.ascii "nLength\0"
	.byte	0x7
	.byte	0xe
	.byte	0xb
	.long	0x11a
	.byte	0
	.uleb128 0x7
	.ascii "lpSecurityDescriptor\0"
	.byte	0x7
	.byte	0xf
	.byte	0xc
	.long	0x146
	.byte	0x8
	.uleb128 0x7
	.ascii "bInheritHandle\0"
	.byte	0x7
	.byte	0x10
	.byte	0xd
	.long	0xfd
	.byte	0x10
	.byte	0
	.uleb128 0x3
	.long	0x53a
	.uleb128 0x8
	.ascii "LPSECURITY_ATTRIBUTES\0"
	.byte	0x7
	.byte	0x11
	.byte	0x32
	.long	0x5a0
	.uleb128 0x8
	.ascii "CRITICAL_SECTION\0"
	.byte	0x7
	.byte	0xbb
	.byte	0x20
	.long	0x4ff
	.uleb128 0x8
	.ascii "LPCRITICAL_SECTION\0"
	.byte	0x7
	.byte	0xbd
	.byte	0x21
	.long	0x51c
	.uleb128 0x8
	.ascii "PTHREAD_START_ROUTINE\0"
	.byte	0x7
	.byte	0xfa
	.byte	0x1a
	.long	0x615
	.uleb128 0x3
	.long	0x61a
	.uleb128 0x23
	.long	0x11a
	.long	0x629
	.uleb128 0x2
	.long	0x146
	.byte	0
	.uleb128 0x8
	.ascii "LPTHREAD_START_ROUTINE\0"
	.byte	0x7
	.byte	0xfb
	.byte	0x21
	.long	0x5f7
	.uleb128 0x3
	.long	0x64d
	.uleb128 0x14
	.long	0x658
	.uleb128 0x2
	.long	0xea
	.byte	0
	.uleb128 0x12
	.ascii "_iobuf\0"
	.byte	0x8
	.byte	0x8
	.byte	0x21
	.byte	0xa
	.long	0x67f
	.uleb128 0x7
	.ascii "_Placeholder\0"
	.byte	0x8
	.byte	0x23
	.byte	0xb
	.long	0xea
	.byte	0
	.byte	0
	.uleb128 0x8
	.ascii "FILE\0"
	.byte	0x8
	.byte	0x2f
	.byte	0x19
	.long	0x658
	.uleb128 0x3
	.long	0x85
	.uleb128 0x12
	.ascii "cgoTracebackArg\0"
	.byte	0x20
	.byte	0x9
	.byte	0x5e
	.byte	0x8
	.long	0x6e5
	.uleb128 0x1c
	.secrel32	.LASF2
	.byte	0x5f
	.byte	0xd
	.long	0x85
	.byte	0
	.uleb128 0x7
	.ascii "SigContext\0"
	.byte	0x9
	.byte	0x60
	.byte	0xd
	.long	0x85
	.byte	0x8
	.uleb128 0x7
	.ascii "Buf\0"
	.byte	0x9
	.byte	0x61
	.byte	0xd
	.long	0x68c
	.byte	0x10
	.uleb128 0x7
	.ascii "Max\0"
	.byte	0x9
	.byte	0x62
	.byte	0xd
	.long	0x85
	.byte	0x18
	.byte	0
	.uleb128 0x12
	.ascii "cgoContextArg\0"
	.byte	0x8
	.byte	0x9
	.byte	0x69
	.byte	0x8
	.long	0x709
	.uleb128 0x1c
	.secrel32	.LASF2
	.byte	0x6a
	.byte	0xc
	.long	0x85
	.byte	0
	.byte	0
	.uleb128 0x12
	.ascii "cgoSymbolizerArg\0"
	.byte	0x38
	.byte	0x9
	.byte	0x71
	.byte	0x8
	.long	0x787
	.uleb128 0x7
	.ascii "PC\0"
	.byte	0x9
	.byte	0x72
	.byte	0xe
	.long	0x85
	.byte	0
	.uleb128 0x7
	.ascii "File\0"
	.byte	0x9
	.byte	0x73
	.byte	0xe
	.long	0x787
	.byte	0x8
	.uleb128 0x7
	.ascii "Lineno\0"
	.byte	0x9
	.byte	0x74
	.byte	0xe
	.long	0x85
	.byte	0x10
	.uleb128 0x7
	.ascii "Func\0"
	.byte	0x9
	.byte	0x75
	.byte	0xe
	.long	0x787
	.byte	0x18
	.uleb128 0x7
	.ascii "Entry\0"
	.byte	0x9
	.byte	0x76
	.byte	0xe
	.long	0x85
	.byte	0x20
	.uleb128 0x7
	.ascii "More\0"
	.byte	0x9
	.byte	0x77
	.byte	0xe
	.long	0x85
	.byte	0x28
	.uleb128 0x7
	.ascii "Data\0"
	.byte	0x9
	.byte	0x78
	.byte	0xe
	.long	0x85
	.byte	0x30
	.byte	0
	.uleb128 0x3
	.long	0x46
	.uleb128 0x12
	.ascii "cgoSetTracebackFunctionsArg\0"
	.byte	0x18
	.byte	0x9
	.byte	0x7f
	.byte	0x8
	.long	0x7e5
	.uleb128 0x7
	.ascii "Traceback\0"
	.byte	0x9
	.byte	0x80
	.byte	0x9
	.long	0x7f5
	.byte	0
	.uleb128 0x1c
	.secrel32	.LASF2
	.byte	0x81
	.byte	0x9
	.long	0x80a
	.byte	0x8
	.uleb128 0x7
	.ascii "Symbolizer\0"
	.byte	0x9
	.byte	0x82
	.byte	0x9
	.long	0x81f
	.byte	0x10
	.byte	0
	.uleb128 0x14
	.long	0x7f0
	.uleb128 0x2
	.long	0x7f0
	.byte	0
	.uleb128 0x3
	.long	0x691
	.uleb128 0x3
	.long	0x7e5
	.uleb128 0x14
	.long	0x805
	.uleb128 0x2
	.long	0x805
	.byte	0
	.uleb128 0x3
	.long	0x6e5
	.uleb128 0x3
	.long	0x7fa
	.uleb128 0x14
	.long	0x81a
	.uleb128 0x2
	.long	0x81a
	.byte	0
	.uleb128 0x3
	.long	0x709
	.uleb128 0x3
	.long	0x80f
	.uleb128 0xb
	.ascii "runtime_init_once_gate\0"
	.byte	0x12
	.byte	0x16
	.long	0x1b1
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_once_gate
	.uleb128 0xb
	.ascii "runtime_init_once_done\0"
	.byte	0x13
	.byte	0x16
	.long	0x1b1
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_once_done
	.uleb128 0xb
	.ascii "runtime_init_cs\0"
	.byte	0x15
	.byte	0x19
	.long	0x5c3
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.uleb128 0xb
	.ascii "runtime_init_wait\0"
	.byte	0x17
	.byte	0xf
	.long	0x1ca
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_wait
	.uleb128 0xb
	.ascii "runtime_init_done\0"
	.byte	0x18
	.byte	0xc
	.long	0xad
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_done
	.uleb128 0x24
	.ascii "x_cgo_pthread_key_created\0"
	.byte	0x1b
	.byte	0xb
	.long	0x85
	.uleb128 0x9
	.byte	0x3
	.quad	x_cgo_pthread_key_created
	.uleb128 0x14
	.long	0x920
	.uleb128 0x2
	.long	0x648
	.uleb128 0x2
	.long	0xea
	.uleb128 0x2
	.long	0xad
	.uleb128 0x2
	.long	0x4b
	.byte	0
	.uleb128 0x24
	.ascii "x_crosscall2_ptr\0"
	.byte	0x1c
	.byte	0x8
	.long	0x942
	.uleb128 0x9
	.byte	0x3
	.quad	x_crosscall2_ptr
	.uleb128 0x3
	.long	0x906
	.uleb128 0xb
	.ascii "cgo_traceback_function\0"
	.byte	0x72
	.byte	0xf
	.long	0x7f5
	.uleb128 0x9
	.byte	0x3
	.quad	cgo_traceback_function
	.uleb128 0xb
	.ascii "cgo_context_function\0"
	.byte	0x75
	.byte	0xf
	.long	0x80a
	.uleb128 0x9
	.byte	0x3
	.quad	cgo_context_function
	.uleb128 0xb
	.ascii "cgo_symbolizer_function\0"
	.byte	0x78
	.byte	0xf
	.long	0x81f
	.uleb128 0x9
	.byte	0x3
	.quad	cgo_symbolizer_function
	.uleb128 0x25
	.ascii "fprintf\0"
	.byte	0x8
	.word	0x1c0
	.byte	0xf
	.long	0xad
	.long	0x9df
	.uleb128 0x2
	.long	0x9df
	.uleb128 0x2
	.long	0x787
	.uleb128 0x2b
	.byte	0
	.uleb128 0x3
	.long	0x67f
	.uleb128 0x15
	.ascii "CloseHandle\0"
	.byte	0xa
	.byte	0x13
	.byte	0x1d
	.long	0xfd
	.long	0xa02
	.uleb128 0x2
	.long	0x1ca
	.byte	0
	.uleb128 0x2c
	.ascii "GetLastError\0"
	.byte	0xd
	.byte	0x31
	.byte	0x1b
	.long	0x11a
	.uleb128 0x25
	.ascii "CreateThread\0"
	.byte	0xb
	.word	0x136
	.byte	0x1c
	.long	0x1ca
	.long	0xa50
	.uleb128 0x2
	.long	0x5a5
	.uleb128 0x2
	.long	0x183
	.uleb128 0x2
	.long	0x629
	.uleb128 0x2
	.long	0x146
	.uleb128 0x2
	.long	0x11a
	.uleb128 0x2
	.long	0x136
	.byte	0
	.uleb128 0x15
	.ascii "SetEvent\0"
	.byte	0xc
	.byte	0x2f
	.byte	0x1d
	.long	0xfd
	.long	0xa6b
	.uleb128 0x2
	.long	0x1ca
	.byte	0
	.uleb128 0x15
	.ascii "WaitForSingleObject\0"
	.byte	0xc
	.byte	0x73
	.byte	0x1b
	.long	0x11a
	.long	0xa96
	.uleb128 0x2
	.long	0x1ca
	.uleb128 0x2
	.long	0x11a
	.byte	0
	.uleb128 0x18
	.ascii "LeaveCriticalSection\0"
	.byte	0x2c
	.long	0xab7
	.uleb128 0x2
	.long	0x5dc
	.byte	0
	.uleb128 0x18
	.ascii "EnterCriticalSection\0"
	.byte	0x2b
	.long	0xad8
	.uleb128 0x2
	.long	0x5dc
	.byte	0
	.uleb128 0x18
	.ascii "Sleep\0"
	.byte	0x7f
	.long	0xaea
	.uleb128 0x2
	.long	0x11a
	.byte	0
	.uleb128 0x18
	.ascii "InitializeCriticalSection\0"
	.byte	0x70
	.long	0xb10
	.uleb128 0x2
	.long	0x5dc
	.byte	0
	.uleb128 0x2d
	.ascii "abort\0"
	.byte	0xe
	.word	0x123
	.byte	0x28
	.uleb128 0x15
	.ascii "__acrt_iob_func\0"
	.byte	0x8
	.byte	0x65
	.byte	0x17
	.long	0x9df
	.long	0xb3d
	.uleb128 0x2
	.long	0xc5
	.byte	0
	.uleb128 0x15
	.ascii "CreateEventA\0"
	.byte	0xc
	.byte	0x77
	.byte	0x1c
	.long	0x1ca
	.long	0xb6b
	.uleb128 0x2
	.long	0x5a5
	.uleb128 0x2
	.long	0xfd
	.uleb128 0x2
	.long	0xfd
	.uleb128 0x2
	.long	0x1bb
	.byte	0
	.uleb128 0x10
	.ascii "_cgo_beginthread\0"
	.byte	0xc1
	.byte	0x6
	.quad	.LFB7706
	.quad	.LFE7706-.LFB7706
	.uleb128 0x1
	.byte	0x9c
	.long	0xca1
	.uleb128 0xc
	.ascii "func\0"
	.byte	0xc1
	.byte	0x31
	.long	0xcb0
	.secrel32	.LLST26
	.secrel32	.LVUS26
	.uleb128 0xc
	.ascii "arg\0"
	.byte	0xc1
	.byte	0x45
	.long	0xea
	.secrel32	.LLST27
	.secrel32	.LVUS27
	.uleb128 0x16
	.ascii "tries\0"
	.byte	0xc2
	.byte	0x6
	.long	0xad
	.secrel32	.LLST28
	.secrel32	.LVUS28
	.uleb128 0x16
	.ascii "thandle\0"
	.byte	0xc3
	.byte	0x9
	.long	0x1ca
	.secrel32	.LLST29
	.secrel32	.LVUS29
	.uleb128 0x4
	.quad	.LVL82
	.long	0xa17
	.long	0xc1c
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x58
	.uleb128 0x2
	.byte	0x74
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x59
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x2
	.byte	0x77
	.sleb128 32
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x1
	.uleb128 0x2
	.byte	0x77
	.sleb128 40
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0xa
	.quad	.LVL83
	.long	0xa02
	.uleb128 0xa
	.quad	.LVL84
	.long	0xa02
	.uleb128 0x4
	.quad	.LVL86
	.long	0xb1b
	.long	0xc4d
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x32
	.byte	0
	.uleb128 0x4
	.quad	.LVL87
	.long	0x9be
	.long	0xc72
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x9
	.byte	0x3
	.quad	.LC3
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x58
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.byte	0
	.uleb128 0xa
	.quad	.LVL88
	.long	0xb10
	.uleb128 0x2e
	.quad	.LVL92
	.long	0x9e4
	.uleb128 0x9
	.quad	.LVL94
	.long	0xad8
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x75
	.sleb128 -1
	.byte	0
	.byte	0
	.uleb128 0x23
	.long	0xd5
	.long	0xcb0
	.uleb128 0x2
	.long	0xea
	.byte	0
	.uleb128 0x3
	.long	0xca1
	.uleb128 0x10
	.ascii "x_cgo_call_symbolizer_function\0"
	.byte	0xb6
	.byte	0x6
	.quad	.LFB7705
	.quad	.LFE7705-.LFB7705
	.uleb128 0x1
	.byte	0x9c
	.long	0xd85
	.uleb128 0xc
	.ascii "arg\0"
	.byte	0xb6
	.byte	0x3e
	.long	0x81a
	.secrel32	.LLST22
	.secrel32	.LVUS22
	.uleb128 0x16
	.ascii "pfn\0"
	.byte	0xb7
	.byte	0x9
	.long	0x81f
	.secrel32	.LLST23
	.secrel32	.LVUS23
	.uleb128 0x1d
	.long	0xd85
	.quad	.LBI76
	.byte	.LVU201
	.secrel32	.LLRL24
	.byte	0xb9
	.byte	0x8
	.long	0xd73
	.uleb128 0xe
	.long	0xdad
	.secrel32	.LLST25
	.secrel32	.LVUS25
	.uleb128 0x4
	.quad	.LVL71
	.long	0xab7
	.long	0xd57
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.uleb128 0x9
	.quad	.LVL73
	.long	0xa96
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.byte	0
	.uleb128 0x26
	.quad	.LVL76
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0
	.byte	0
	.uleb128 0x19
	.ascii "_cgo_get_symbolizer_function\0"
	.byte	0xa9
	.byte	0x9
	.long	0x81f
	.long	0xdb9
	.uleb128 0x1a
	.ascii "ret\0"
	.byte	0xaa
	.byte	0x9
	.long	0x81f
	.byte	0
	.uleb128 0x19
	.ascii "_cgo_get_context_function\0"
	.byte	0x9f
	.byte	0x9
	.long	0x80a
	.long	0xdea
	.uleb128 0x1a
	.ascii "ret\0"
	.byte	0xa0
	.byte	0x9
	.long	0x80a
	.byte	0
	.uleb128 0x10
	.ascii "x_cgo_call_traceback_function\0"
	.byte	0x92
	.byte	0x6
	.quad	.LFB7702
	.quad	.LFE7702-.LFB7702
	.uleb128 0x1
	.byte	0x9c
	.long	0xeb9
	.uleb128 0xc
	.ascii "arg\0"
	.byte	0x92
	.byte	0x3c
	.long	0x7f0
	.secrel32	.LLST16
	.secrel32	.LVUS16
	.uleb128 0x16
	.ascii "pfn\0"
	.byte	0x93
	.byte	0x9
	.long	0x7f5
	.secrel32	.LLST17
	.secrel32	.LVUS17
	.uleb128 0x1d
	.long	0xeb9
	.quad	.LBI70
	.byte	.LVU158
	.secrel32	.LLRL18
	.byte	0x95
	.byte	0x8
	.long	0xea7
	.uleb128 0xe
	.long	0xee0
	.secrel32	.LLST19
	.secrel32	.LVUS19
	.uleb128 0x4
	.quad	.LVL53
	.long	0xab7
	.long	0xe8b
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.uleb128 0x9
	.quad	.LVL55
	.long	0xa96
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.byte	0
	.uleb128 0x26
	.quad	.LVL58
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0
	.byte	0
	.uleb128 0x19
	.ascii "_cgo_get_traceback_function\0"
	.byte	0x85
	.byte	0x9
	.long	0x7f5
	.long	0xeec
	.uleb128 0x1a
	.ascii "ret\0"
	.byte	0x86
	.byte	0x9
	.long	0x7f5
	.byte	0
	.uleb128 0x10
	.ascii "x_cgo_set_traceback_functions\0"
	.byte	0x7c
	.byte	0x6
	.quad	.LFB7700
	.quad	.LFE7700-.LFB7700
	.uleb128 0x1
	.byte	0x9c
	.long	0xf71
	.uleb128 0xc
	.ascii "arg\0"
	.byte	0x7c
	.byte	0x48
	.long	0xf71
	.secrel32	.LLST14
	.secrel32	.LVUS14
	.uleb128 0x4
	.quad	.LVL44
	.long	0xab7
	.long	0xf55
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.uleb128 0x1e
	.quad	.LVL46
	.long	0xa96
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.byte	0
	.uleb128 0x3
	.long	0x78c
	.uleb128 0x10
	.ascii "x_cgo_notify_runtime_init_done\0"
	.byte	0x64
	.byte	0x1
	.quad	.LFB7699
	.quad	.LFE7699-.LFB7699
	.uleb128 0x1
	.byte	0x9c
	.long	0x106a
	.uleb128 0xc
	.ascii "dummy\0"
	.byte	0x64
	.byte	0x26
	.long	0xea
	.secrel32	.LLST13
	.secrel32	.LVUS13
	.uleb128 0xa
	.quad	.LVL35
	.long	0x131c
	.uleb128 0x4
	.quad	.LVL36
	.long	0xab7
	.long	0xfef
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.uleb128 0x4
	.quad	.LVL37
	.long	0xa96
	.long	0x100e
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.uleb128 0xa
	.quad	.LVL38
	.long	0xa50
	.uleb128 0x4
	.quad	.LVL39
	.long	0xb1b
	.long	0x1032
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x32
	.byte	0
	.uleb128 0x4
	.quad	.LVL40
	.long	0x17ae
	.long	0x105c
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	.LC2
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x58
	.uleb128 0x2
	.byte	0x8
	.byte	0x3b
	.byte	0
	.uleb128 0xa
	.quad	.LVL41
	.long	0xb10
	.byte	0
	.uleb128 0x10
	.ascii "x_cgo_bindm\0"
	.byte	0x5e
	.byte	0x6
	.quad	.LFB7698
	.quad	.LFE7698-.LFB7698
	.uleb128 0x1
	.byte	0x9c
	.long	0x10f3
	.uleb128 0xc
	.ascii "dummy\0"
	.byte	0x5e
	.byte	0x18
	.long	0xea
	.secrel32	.LLST12
	.secrel32	.LVUS12
	.uleb128 0x4
	.quad	.LVL31
	.long	0xb1b
	.long	0x10bb
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x32
	.byte	0
	.uleb128 0x4
	.quad	.LVL32
	.long	0x17ae
	.long	0x10e5
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	.LC1
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x58
	.uleb128 0x2
	.byte	0x8
	.byte	0x20
	.byte	0
	.uleb128 0xa
	.quad	.LVL33
	.long	0xb10
	.byte	0
	.uleb128 0x2f
	.ascii "_cgo_wait_runtime_init_done\0"
	.byte	0x1
	.byte	0x4b
	.byte	0x1
	.long	0x85
	.quad	.LFB7697
	.quad	.LFE7697-.LFB7697
	.uleb128 0x1
	.byte	0x9c
	.long	0x1271
	.uleb128 0x16
	.ascii "pfn\0"
	.byte	0x4c
	.byte	0x9
	.long	0x80a
	.secrel32	.LLST9
	.secrel32	.LVUS9
	.uleb128 0x30
	.quad	.LBB67
	.quad	.LBE67-.LBB67
	.long	0x1177
	.uleb128 0xb
	.ascii "arg\0"
	.byte	0x54
	.byte	0x18
	.long	0x6e5
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.uleb128 0x31
	.quad	.LVL27
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x91
	.sleb128 -56
	.byte	0
	.byte	0
	.uleb128 0xf
	.long	0x1271
	.quad	.LBI63
	.byte	.LVU71
	.quad	.LBB63
	.quad	.LBE63-.LBB63
	.byte	0x4f
	.byte	0xa
	.long	0x11e3
	.uleb128 0xe
	.long	0x1298
	.secrel32	.LLST10
	.secrel32	.LVUS10
	.uleb128 0x4
	.quad	.LVL21
	.long	0xab7
	.long	0x11c7
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.uleb128 0x9
	.quad	.LVL23
	.long	0xa96
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.byte	0
	.uleb128 0xf
	.long	0xdb9
	.quad	.LBI65
	.byte	.LVU81
	.quad	.LBB65
	.quad	.LBE65-.LBB65
	.byte	0x52
	.byte	0x8
	.long	0x124f
	.uleb128 0xe
	.long	0xdde
	.secrel32	.LLST11
	.secrel32	.LVUS11
	.uleb128 0x4
	.quad	.LVL24
	.long	0xab7
	.long	0x1233
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.uleb128 0x9
	.quad	.LVL26
	.long	0xa96
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.byte	0
	.uleb128 0xa
	.quad	.LVL19
	.long	0x131c
	.uleb128 0x9
	.quad	.LVL20
	.long	0xa6b
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x9
	.byte	0xff
	.byte	0
	.byte	0
	.uleb128 0x19
	.ascii "_cgo_is_runtime_initialized\0"
	.byte	0x41
	.byte	0x1
	.long	0xad
	.long	0x12a7
	.uleb128 0x1a
	.ascii "status\0"
	.byte	0x42
	.byte	0x7
	.long	0xad
	.byte	0
	.uleb128 0x10
	.ascii "x_cgo_sys_thread_create\0"
	.byte	0x3c
	.byte	0x1
	.quad	.LFB7695
	.quad	.LFE7695-.LFB7695
	.uleb128 0x1
	.byte	0x9c
	.long	0x131c
	.uleb128 0xc
	.ascii "func\0"
	.byte	0x3c
	.byte	0x33
	.long	0xcb0
	.secrel32	.LLST30
	.secrel32	.LVUS30
	.uleb128 0xc
	.ascii "arg\0"
	.byte	0x3c
	.byte	0x47
	.long	0xea
	.secrel32	.LLST31
	.secrel32	.LVUS31
	.uleb128 0x1e
	.quad	.LVL96
	.long	0xb6b
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0xa3
	.uleb128 0x1
	.byte	0x51
	.byte	0
	.byte	0
	.uleb128 0x27
	.ascii "_cgo_maybe_run_preinit\0"
	.byte	0x2c
	.uleb128 0x27
	.ascii "_cgo_preinit_init\0"
	.byte	0x20
	.uleb128 0x1f
	.ascii "_InterlockedDecrement\0"
	.word	0x6a8
	.long	0xb4
	.long	0x1377
	.uleb128 0x20
	.secrel32	.LASF3
	.word	0x6a8
	.byte	0x33
	.long	0x1377
	.byte	0
	.uleb128 0x3
	.long	0xc0
	.uleb128 0x1f
	.ascii "_InterlockedIncrement\0"
	.word	0x69d
	.long	0xb4
	.long	0x13aa
	.uleb128 0x20
	.secrel32	.LASF3
	.word	0x69d
	.byte	0x33
	.long	0x1377
	.byte	0
	.uleb128 0x1f
	.ascii "_InterlockedExchangeAdd\0"
	.word	0x687
	.long	0xb4
	.long	0x13e9
	.uleb128 0x20
	.secrel32	.LASF3
	.word	0x687
	.byte	0x35
	.long	0x1377
	.uleb128 0x32
	.ascii "Value\0"
	.byte	0x2
	.word	0x687
	.byte	0x46
	.long	0xb4
	.byte	0
	.uleb128 0x13
	.long	0x1335
	.quad	.LFB7693
	.quad	.LFE7693-.LFB7693
	.uleb128 0x1
	.byte	0x9c
	.long	0x14b9
	.uleb128 0xf
	.long	0x1335
	.quad	.LBI24
	.byte	.LVU9
	.quad	.LBB24
	.quad	.LBE24-.LBB24
	.byte	0x20
	.byte	0x1
	.long	0x1477
	.uleb128 0x4
	.quad	.LVL2
	.long	0xb1b
	.long	0x143f
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x32
	.byte	0
	.uleb128 0x4
	.quad	.LVL3
	.long	0x17ae
	.long	0x1469
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	.LC0
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x58
	.uleb128 0x2
	.byte	0x8
	.byte	0x3d
	.byte	0
	.uleb128 0xa
	.quad	.LVL4
	.long	0xb10
	.byte	0
	.uleb128 0x4
	.quad	.LVL0
	.long	0xb3d
	.long	0x149d
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x58
	.uleb128 0x1
	.byte	0x30
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x59
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.uleb128 0x1e
	.quad	.LVL1
	.long	0xaea
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.byte	0
	.uleb128 0x13
	.long	0x131c
	.quad	.LFB7694
	.quad	.LFE7694-.LFB7694
	.uleb128 0x1
	.byte	0x9c
	.long	0x1622
	.uleb128 0xf
	.long	0x13aa
	.quad	.LBI44
	.byte	.LVU18
	.quad	.LBB44
	.quad	.LBE44-.LBB44
	.byte	0x2d
	.byte	0x8
	.long	0x1513
	.uleb128 0x11
	.long	0x13cd
	.secrel32	.LLST0
	.secrel32	.LVUS0
	.uleb128 0x11
	.long	0x13d9
	.secrel32	.LLST1
	.secrel32	.LVUS1
	.byte	0
	.uleb128 0xf
	.long	0x137c
	.quad	.LBI46
	.byte	.LVU25
	.quad	.LBB46
	.quad	.LBE46-.LBB46
	.byte	0x2e
	.byte	0x8
	.long	0x1545
	.uleb128 0x11
	.long	0x139d
	.secrel32	.LLST2
	.secrel32	.LVUS2
	.byte	0
	.uleb128 0xf
	.long	0x131c
	.quad	.LBI48
	.byte	.LVU30
	.quad	.LBB48
	.quad	.LBE48-.LBB48
	.byte	0x2c
	.byte	0x1
	.long	0x15e2
	.uleb128 0x1d
	.long	0x1349
	.quad	.LBI50
	.byte	.LVU32
	.secrel32	.LLRL3
	.byte	0x33
	.byte	0x6
	.long	0x158f
	.uleb128 0x11
	.long	0x136a
	.secrel32	.LLST4
	.secrel32	.LVUS4
	.byte	0
	.uleb128 0xf
	.long	0x13aa
	.quad	.LBI54
	.byte	.LVU41
	.quad	.LBB54
	.quad	.LBE54-.LBB54
	.byte	0x34
	.byte	0xd
	.long	0x15ce
	.uleb128 0x11
	.long	0x13cd
	.secrel32	.LLST5
	.secrel32	.LVUS5
	.uleb128 0x11
	.long	0x13d9
	.secrel32	.LLST6
	.secrel32	.LVUS6
	.byte	0
	.uleb128 0x9
	.quad	.LVL11
	.long	0xad8
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x30
	.byte	0
	.byte	0
	.uleb128 0xf
	.long	0x137c
	.quad	.LBI56
	.byte	.LVU49
	.quad	.LBB56
	.quad	.LBE56-.LBB56
	.byte	0x30
	.byte	0x6
	.long	0x1614
	.uleb128 0x11
	.long	0x139d
	.secrel32	.LLST7
	.secrel32	.LVUS7
	.byte	0
	.uleb128 0xa
	.quad	.LVL13
	.long	0x1335
	.byte	0
	.uleb128 0x13
	.long	0x1271
	.quad	.LFB7696
	.quad	.LFE7696-.LFB7696
	.uleb128 0x1
	.byte	0x9c
	.long	0x1685
	.uleb128 0xe
	.long	0x1298
	.secrel32	.LLST8
	.secrel32	.LVUS8
	.uleb128 0x4
	.quad	.LVL15
	.long	0xab7
	.long	0x1669
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.uleb128 0x9
	.quad	.LVL17
	.long	0xa96
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.byte	0
	.uleb128 0x13
	.long	0xeb9
	.quad	.LFB7701
	.quad	.LFE7701-.LFB7701
	.uleb128 0x1
	.byte	0x9c
	.long	0x16e8
	.uleb128 0xe
	.long	0xee0
	.secrel32	.LLST15
	.secrel32	.LVUS15
	.uleb128 0x4
	.quad	.LVL47
	.long	0xab7
	.long	0x16cc
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.uleb128 0x9
	.quad	.LVL49
	.long	0xa96
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.byte	0
	.uleb128 0x13
	.long	0xdb9
	.quad	.LFB7703
	.quad	.LFE7703-.LFB7703
	.uleb128 0x1
	.byte	0x9c
	.long	0x174b
	.uleb128 0xe
	.long	0xdde
	.secrel32	.LLST20
	.secrel32	.LVUS20
	.uleb128 0x4
	.quad	.LVL61
	.long	0xab7
	.long	0x172f
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.uleb128 0x9
	.quad	.LVL63
	.long	0xa96
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.byte	0
	.uleb128 0x13
	.long	0xd85
	.quad	.LFB7704
	.quad	.LFE7704-.LFB7704
	.uleb128 0x1
	.byte	0x9c
	.long	0x17ae
	.uleb128 0xe
	.long	0xdad
	.secrel32	.LLST21
	.secrel32	.LVUS21
	.uleb128 0x4
	.quad	.LVL65
	.long	0xab7
	.long	0x1792
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.uleb128 0x9
	.quad	.LVL67
	.long	0xa96
	.uleb128 0x1
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	runtime_init_cs
	.byte	0
	.byte	0
	.uleb128 0x33
	.ascii "fwrite\0"
	.ascii "__builtin_fwrite\0"
	.byte	0xf
	.byte	0
	.byte	0
	.section	.debug_abbrev,"dr"
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x49
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x7e
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 6
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x48
	.byte	0
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 6
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x34
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x2138
	.uleb128 0xb
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x58
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x57
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x5
	.byte	0
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x17
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x1c
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x18
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 12
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 26
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x19
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1a
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1b
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 6
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1c
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 9
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x1d
	.uleb128 0x1d
	.byte	0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x2138
	.uleb128 0xb
	.uleb128 0x55
	.uleb128 0x17
	.uleb128 0x58
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x59
	.uleb128 0xb
	.uleb128 0x57
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1e
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x82
	.uleb128 0x19
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1f
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 10
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x20
	.uleb128 0x21
	.sleb128 3
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x20
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 2
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x21
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x22
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x23
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x24
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x25
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x26
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x82
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x27
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x20
	.uleb128 0x21
	.sleb128 1
	.byte	0
	.byte	0
	.uleb128 0x28
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0x8
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x90
	.uleb128 0xb
	.uleb128 0x91
	.uleb128 0x6
	.uleb128 0x3
	.uleb128 0x1f
	.uleb128 0x1b
	.uleb128 0x1f
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x10
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x29
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x2a
	.uleb128 0x4
	.byte	0x1
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2b
	.uleb128 0x18
	.byte	0
	.byte	0
	.byte	0
	.uleb128 0x2c
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x2d
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x87
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x2e
	.uleb128 0x48
	.byte	0
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x82
	.uleb128 0x19
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x2f
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x40
	.uleb128 0x18
	.uleb128 0x7a
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x30
	.uleb128 0xb
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x7
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x31
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x83
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x32
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0x5
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x33
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x6e
	.uleb128 0x8
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loclists,"dr"
	.long	.Ldebug_loc3-.Ldebug_loc2
.Ldebug_loc2:
	.word	0x5
	.byte	0x8
	.byte	0
	.long	0
.Ldebug_loc0:
.LVUS26:
	.uleb128 0
	.uleb128 .LVU230
	.uleb128 .LVU230
	.uleb128 .LVU246
	.uleb128 .LVU246
	.uleb128 .LVU248
	.uleb128 .LVU248
	.uleb128 0
.LLST26:
	.byte	0x4
	.uleb128 .LVL79-.Ltext0
	.uleb128 .LVL81-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL81-.Ltext0
	.uleb128 .LVL90-.Ltext0
	.uleb128 0x1
	.byte	0x54
	.byte	0x4
	.uleb128 .LVL90-.Ltext0
	.uleb128 .LVL92-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL92-.Ltext0
	.uleb128 .LFE7706-.Ltext0
	.uleb128 0x1
	.byte	0x54
	.byte	0
.LVUS27:
	.uleb128 0
	.uleb128 .LVU230
	.uleb128 .LVU230
	.uleb128 .LVU239
	.uleb128 .LVU239
	.uleb128 .LVU242
	.uleb128 .LVU242
	.uleb128 .LVU245
	.uleb128 .LVU245
	.uleb128 .LVU248
	.uleb128 .LVU248
	.uleb128 0
.LLST27:
	.byte	0x4
	.uleb128 .LVL79-.Ltext0
	.uleb128 .LVL81-.Ltext0
	.uleb128 0x1
	.byte	0x51
	.byte	0x4
	.uleb128 .LVL81-.Ltext0
	.uleb128 .LVL85-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL85-.Ltext0
	.uleb128 .LVL88-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL88-.Ltext0
	.uleb128 .LVL89-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL89-.Ltext0
	.uleb128 .LVL92-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL92-.Ltext0
	.uleb128 .LFE7706-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0
.LVUS28:
	.uleb128 .LVU227
	.uleb128 .LVU230
	.uleb128 .LVU230
	.uleb128 .LVU247
	.uleb128 .LVU248
	.uleb128 .LVU250
	.uleb128 .LVU250
	.uleb128 .LVU251
	.uleb128 .LVU251
	.uleb128 .LVU253
	.uleb128 .LVU253
	.uleb128 0
.LLST28:
	.byte	0x4
	.uleb128 .LVL80-.Ltext0
	.uleb128 .LVL81-.Ltext0
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL81-.Ltext0
	.uleb128 .LVL91-.Ltext0
	.uleb128 0x1
	.byte	0x55
	.byte	0x4
	.uleb128 .LVL92-.Ltext0
	.uleb128 .LVL93-.Ltext0
	.uleb128 0x1
	.byte	0x55
	.byte	0x4
	.uleb128 .LVL93-.Ltext0
	.uleb128 .LVL94-1-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL94-1-.Ltext0
	.uleb128 .LVL94-.Ltext0
	.uleb128 0x3
	.byte	0x75
	.sleb128 -1
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL94-.Ltext0
	.uleb128 .LFE7706-.Ltext0
	.uleb128 0x1
	.byte	0x55
	.byte	0
.LVUS29:
	.uleb128 .LVU232
	.uleb128 .LVU235
	.uleb128 .LVU242
	.uleb128 .LVU248
.LLST29:
	.byte	0x4
	.uleb128 .LVL82-.Ltext0
	.uleb128 .LVL83-1-.Ltext0
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL88-.Ltext0
	.uleb128 .LVL92-1-.Ltext0
	.uleb128 0x1
	.byte	0x50
	.byte	0
.LVUS22:
	.uleb128 0
	.uleb128 .LVU206
	.uleb128 .LVU206
	.uleb128 .LVU218
	.uleb128 .LVU218
	.uleb128 .LVU219
	.uleb128 .LVU219
	.uleb128 .LVU219
	.uleb128 .LVU219
	.uleb128 .LVU221
	.uleb128 .LVU221
	.uleb128 0
.LLST22:
	.byte	0x4
	.uleb128 .LVL69-.Ltext0
	.uleb128 .LVL70-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL70-.Ltext0
	.uleb128 .LVL75-.Ltext0
	.uleb128 0x1
	.byte	0x54
	.byte	0x4
	.uleb128 .LVL75-.Ltext0
	.uleb128 .LVL76-1-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL76-1-.Ltext0
	.uleb128 .LVL76-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL76-.Ltext0
	.uleb128 .LVL78-.Ltext0
	.uleb128 0x1
	.byte	0x54
	.byte	0x4
	.uleb128 .LVL78-.Ltext0
	.uleb128 .LFE7705-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0
.LVUS23:
	.uleb128 .LVU211
	.uleb128 .LVU217
	.uleb128 .LVU217
	.uleb128 .LVU219
	.uleb128 .LVU219
	.uleb128 .LVU220
.LLST23:
	.byte	0x4
	.uleb128 .LVL73-.Ltext0
	.uleb128 .LVL74-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL74-.Ltext0
	.uleb128 .LVL76-1-.Ltext0
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL76-.Ltext0
	.uleb128 .LVL77-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0
.LVUS25:
	.uleb128 .LVU209
	.uleb128 .LVU211
.LLST25:
	.byte	0x4
	.uleb128 .LVL72-.Ltext0
	.uleb128 .LVL73-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0
.LVUS16:
	.uleb128 0
	.uleb128 .LVU163
	.uleb128 .LVU163
	.uleb128 .LVU175
	.uleb128 .LVU175
	.uleb128 .LVU176
	.uleb128 .LVU176
	.uleb128 .LVU176
	.uleb128 .LVU176
	.uleb128 .LVU178
	.uleb128 .LVU178
	.uleb128 0
.LLST16:
	.byte	0x4
	.uleb128 .LVL51-.Ltext0
	.uleb128 .LVL52-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL52-.Ltext0
	.uleb128 .LVL57-.Ltext0
	.uleb128 0x1
	.byte	0x54
	.byte	0x4
	.uleb128 .LVL57-.Ltext0
	.uleb128 .LVL58-1-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL58-1-.Ltext0
	.uleb128 .LVL58-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL58-.Ltext0
	.uleb128 .LVL60-.Ltext0
	.uleb128 0x1
	.byte	0x54
	.byte	0x4
	.uleb128 .LVL60-.Ltext0
	.uleb128 .LFE7702-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0
.LVUS17:
	.uleb128 .LVU168
	.uleb128 .LVU174
	.uleb128 .LVU174
	.uleb128 .LVU176
	.uleb128 .LVU176
	.uleb128 .LVU177
.LLST17:
	.byte	0x4
	.uleb128 .LVL55-.Ltext0
	.uleb128 .LVL56-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL56-.Ltext0
	.uleb128 .LVL58-1-.Ltext0
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL58-.Ltext0
	.uleb128 .LVL59-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0
.LVUS19:
	.uleb128 .LVU166
	.uleb128 .LVU168
.LLST19:
	.byte	0x4
	.uleb128 .LVL54-.Ltext0
	.uleb128 .LVL55-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0
.LVUS14:
	.uleb128 0
	.uleb128 .LVU133
	.uleb128 .LVU133
	.uleb128 .LVU144
	.uleb128 .LVU144
	.uleb128 0
.LLST14:
	.byte	0x4
	.uleb128 .LVL42-.Ltext0
	.uleb128 .LVL43-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL43-.Ltext0
	.uleb128 .LVL45-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL45-.Ltext0
	.uleb128 .LFE7700-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0
.LVUS13:
	.uleb128 0
	.uleb128 .LVU113
	.uleb128 .LVU113
	.uleb128 0
.LLST13:
	.byte	0x4
	.uleb128 .LVL34-.Ltext0
	.uleb128 .LVL35-1-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL35-1-.Ltext0
	.uleb128 .LFE7699-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0
.LVUS12:
	.uleb128 0
	.uleb128 .LVU105
	.uleb128 .LVU105
	.uleb128 0
.LLST12:
	.byte	0x4
	.uleb128 .LVL29-.Ltext0
	.uleb128 .LVL30-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL30-.Ltext0
	.uleb128 .LFE7698-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0
.LVUS9:
	.uleb128 .LVU88
	.uleb128 .LVU100
.LLST9:
	.byte	0x4
	.uleb128 .LVL26-.Ltext0
	.uleb128 .LVL28-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0
.LVUS10:
	.uleb128 .LVU76
	.uleb128 .LVU78
.LLST10:
	.byte	0x4
	.uleb128 .LVL22-.Ltext0
	.uleb128 .LVL23-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0
.LVUS11:
	.uleb128 .LVU86
	.uleb128 .LVU88
.LLST11:
	.byte	0x4
	.uleb128 .LVL25-.Ltext0
	.uleb128 .LVL26-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0
.LVUS30:
	.uleb128 0
	.uleb128 .LVU259
	.uleb128 .LVU259
	.uleb128 0
.LLST30:
	.byte	0x4
	.uleb128 .LVL95-.Ltext0
	.uleb128 .LVL96-1-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL96-1-.Ltext0
	.uleb128 .LFE7695-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0
.LVUS31:
	.uleb128 0
	.uleb128 .LVU259
	.uleb128 .LVU259
	.uleb128 0
.LLST31:
	.byte	0x4
	.uleb128 .LVL95-.Ltext0
	.uleb128 .LVL96-1-.Ltext0
	.uleb128 0x1
	.byte	0x51
	.byte	0x4
	.uleb128 .LVL96-1-.Ltext0
	.uleb128 .LFE7695-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.byte	0
.LVUS0:
	.uleb128 .LVU18
	.uleb128 .LVU21
.LLST0:
	.byte	0x4
	.uleb128 .LVL5-.Ltext0
	.uleb128 .LVL6-.Ltext0
	.uleb128 0xa
	.byte	0x3
	.quad	runtime_init_once_done
	.byte	0x9f
	.byte	0
.LVUS1:
	.uleb128 .LVU18
	.uleb128 .LVU21
.LLST1:
	.byte	0x4
	.uleb128 .LVL5-.Ltext0
	.uleb128 .LVL6-.Ltext0
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0
.LVUS2:
	.uleb128 .LVU25
	.uleb128 .LVU28
.LLST2:
	.byte	0x4
	.uleb128 .LVL7-.Ltext0
	.uleb128 .LVL8-.Ltext0
	.uleb128 0xa
	.byte	0x3
	.quad	runtime_init_once_gate
	.byte	0x9f
	.byte	0
.LVUS4:
	.uleb128 .LVU32
	.uleb128 .LVU35
.LLST4:
	.byte	0x4
	.uleb128 .LVL9-.Ltext0
	.uleb128 .LVL10-.Ltext0
	.uleb128 0xa
	.byte	0x3
	.quad	runtime_init_once_gate
	.byte	0x9f
	.byte	0
.LVUS5:
	.uleb128 .LVU41
	.uleb128 .LVU44
.LLST5:
	.byte	0x4
	.uleb128 .LVL11-.Ltext0
	.uleb128 .LVL12-.Ltext0
	.uleb128 0xa
	.byte	0x3
	.quad	runtime_init_once_done
	.byte	0x9f
	.byte	0
.LVUS6:
	.uleb128 .LVU41
	.uleb128 .LVU44
.LLST6:
	.byte	0x4
	.uleb128 .LVL11-.Ltext0
	.uleb128 .LVL12-.Ltext0
	.uleb128 0x2
	.byte	0x30
	.byte	0x9f
	.byte	0
.LVUS7:
	.uleb128 .LVU49
	.uleb128 .LVU52
.LLST7:
	.byte	0x4
	.uleb128 .LVL13-.Ltext0
	.uleb128 .LVL14-.Ltext0
	.uleb128 0xa
	.byte	0x3
	.quad	runtime_init_once_done
	.byte	0x9f
	.byte	0
.LVUS8:
	.uleb128 .LVU59
	.uleb128 .LVU62
	.uleb128 .LVU62
	.uleb128 0
.LLST8:
	.byte	0x4
	.uleb128 .LVL16-.Ltext0
	.uleb128 .LVL18-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL18-.Ltext0
	.uleb128 .LFE7696-.Ltext0
	.uleb128 0x1
	.byte	0x50
	.byte	0
.LVUS15:
	.uleb128 .LVU150
	.uleb128 .LVU153
	.uleb128 .LVU153
	.uleb128 0
.LLST15:
	.byte	0x4
	.uleb128 .LVL48-.Ltext0
	.uleb128 .LVL50-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL50-.Ltext0
	.uleb128 .LFE7701-.Ltext0
	.uleb128 0x1
	.byte	0x50
	.byte	0
.LVUS20:
	.uleb128 .LVU184
	.uleb128 .LVU187
	.uleb128 .LVU187
	.uleb128 0
.LLST20:
	.byte	0x4
	.uleb128 .LVL62-.Ltext0
	.uleb128 .LVL64-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL64-.Ltext0
	.uleb128 .LFE7703-.Ltext0
	.uleb128 0x1
	.byte	0x50
	.byte	0
.LVUS21:
	.uleb128 .LVU193
	.uleb128 .LVU196
	.uleb128 .LVU196
	.uleb128 0
.LLST21:
	.byte	0x4
	.uleb128 .LVL66-.Ltext0
	.uleb128 .LVL68-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL68-.Ltext0
	.uleb128 .LFE7704-.Ltext0
	.uleb128 0x1
	.byte	0x50
	.byte	0
.Ldebug_loc3:
	.section	.debug_aranges,"dr"
	.long	0x2c
	.word	0x2
	.secrel32	.Ldebug_info0
	.byte	0x8
	.byte	0
	.word	0
	.word	0
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.quad	0
	.quad	0
	.section	.debug_rnglists,"dr"
.Ldebug_ranges0:
	.long	.Ldebug_ranges3-.Ldebug_ranges2
.Ldebug_ranges2:
	.word	0x5
	.byte	0x8
	.byte	0
	.long	0
.LLRL3:
	.byte	0x4
	.uleb128 .LBB50-.Ltext0
	.uleb128 .LBE50-.Ltext0
	.byte	0x4
	.uleb128 .LBB53-.Ltext0
	.uleb128 .LBE53-.Ltext0
	.byte	0
.LLRL18:
	.byte	0x4
	.uleb128 .LBB70-.Ltext0
	.uleb128 .LBE70-.Ltext0
	.byte	0x4
	.uleb128 .LBB73-.Ltext0
	.uleb128 .LBE73-.Ltext0
	.byte	0
.LLRL24:
	.byte	0x4
	.uleb128 .LBB76-.Ltext0
	.uleb128 .LBE76-.Ltext0
	.byte	0x4
	.uleb128 .LBB79-.Ltext0
	.uleb128 .LBE79-.Ltext0
	.byte	0
.Ldebug_ranges3:
	.section	.debug_line,"dr"
.Ldebug_line0:
	.section	.debug_str,"dr"
.LASF2:
	.ascii "Context\0"
.LASF3:
	.ascii "Addend\0"
	.section	.debug_line_str,"dr"
.LASF1:
	.ascii "\\\\_\\_\\GOROOT\\src\\runtime\\cgo\0"
.LASF0:
	.ascii "gcc_libinit_windows.c\0"
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	fwrite;	.scl	2;	.type	32;	.endef
	.def	abort;	.scl	2;	.type	32;	.endef
	.def	fprintf;	.scl	2;	.type	32;	.endef
