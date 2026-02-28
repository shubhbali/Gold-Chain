	.file	"gcc_util.c"
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "//_/_/GOROOT/src/runtime/cgo" "gcc_util.c"
	.section .rdata,"dr"
	.align 8
.LC0:
	.ascii "runtime/cgo: out of memory in thread_start\12\0"
	.text
	.p2align 4
	.globl	x_cgo_thread_start
	.def	x_cgo_thread_start;	.scl	2;	.type	32;	.endef
	.seh_proc	x_cgo_thread_start
x_cgo_thread_start:
.LVL0:
.LFB113:
	.file 1 "gcc_util.c"
	.loc 1 10 1 view -0
	.cfi_startproc
	.loc 1 10 1 is_stmt 0 view .LVU1
	pushq	%rbx
	.seh_pushreg	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.seh_stackalloc	32
	.cfi_def_cfa_offset 48
	.seh_endprologue
	.loc 1 11 2 is_stmt 1 view .LVU2
	.loc 1 14 21 view .LVU3
	.loc 1 15 2 view .LVU4
	.loc 1 10 1 is_stmt 0 view .LVU5
	movq	%rcx, %rbx
	.loc 1 15 7 view .LVU6
	movl	$24, %ecx
.LVL1:
	.loc 1 15 7 view .LVU7
	call	malloc
.LVL2:
	.loc 1 16 21 is_stmt 1 view .LVU8
	.loc 1 17 2 view .LVU9
	.loc 1 17 4 is_stmt 0 view .LVU10
	testq	%rax, %rax
	je	.L4
	.loc 1 21 2 is_stmt 1 view .LVU11
	.loc 1 21 6 is_stmt 0 view .LVU12
	movdqu	(%rbx), %xmm0
	movq	16(%rbx), %rdx
	.loc 1 23 2 view .LVU13
	movq	%rax, %rcx
	.loc 1 21 6 view .LVU14
	movq	%rdx, 16(%rax)
	.loc 1 23 2 is_stmt 1 view .LVU15
	.loc 1 21 6 is_stmt 0 view .LVU16
	movups	%xmm0, (%rax)
	.loc 1 24 1 view .LVU17
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
.LVL3:
	.loc 1 23 2 view .LVU18
	jmp	_cgo_sys_thread_start
.LVL4:
.L4:
	.cfi_restore_state
	.loc 1 18 3 is_stmt 1 view .LVU19
	.loc 1 18 11 is_stmt 0 view .LVU20
	movl	$2, %ecx
	call	*__imp___acrt_iob_func(%rip)
.LVL5:
	.loc 1 18 3 discriminator 1 view .LVU21
	movl	$43, %r8d
	movl	$1, %edx
	leaq	.LC0(%rip), %rcx
	.loc 1 18 11 view .LVU22
	movq	%rax, %r9
	.loc 1 18 3 discriminator 1 view .LVU23
	call	fwrite
.LVL6:
	.loc 1 19 3 is_stmt 1 view .LVU24
	call	abort
	nop
.LVL7:
	.cfi_endproc
.LFE113:
	.seh_endproc
	.globl	_cgo_yield
	.section .rdata,"dr"
	.align 8
_cgo_yield:
	.space 8
	.text
.Letext0:
	.file 2 "C:/msys64/ucrt64/include/corecrt.h"
	.file 3 "C:/msys64/ucrt64/include/stdio.h"
	.file 4 "libcgo.h"
	.file 5 "C:/msys64/ucrt64/include/stdlib.h"
	.file 6 "<built-in>"
	.section	.debug_info,"dr"
.Ldebug_info0:
	.long	0x34d
	.word	0x5
	.byte	0x1
	.byte	0x8
	.secrel32	.Ldebug_abbrev0
	.uleb128 0x9
	.ascii "GNU C23 15.2.0\0"
	.byte	0x1d
	.byte	0x3
	.long	0x31647
	.secrel32	.LASF0
	.secrel32	.LASF1
	.quad	.Ltext0
	.quad	.Letext0-.Ltext0
	.secrel32	.Ldebug_line0
	.uleb128 0x1
	.byte	0x1
	.byte	0x6
	.ascii "char\0"
	.uleb128 0x1
	.byte	0x8
	.byte	0x7
	.ascii "long long unsigned int\0"
	.uleb128 0x1
	.byte	0x8
	.byte	0x5
	.ascii "long long int\0"
	.uleb128 0x5
	.ascii "uintptr_t\0"
	.byte	0x2
	.byte	0x4b
	.byte	0x2c
	.long	0x46
	.uleb128 0x1
	.byte	0x2
	.byte	0x7
	.ascii "short unsigned int\0"
	.uleb128 0x1
	.byte	0x4
	.byte	0x5
	.ascii "int\0"
	.uleb128 0x1
	.byte	0x4
	.byte	0x5
	.ascii "long int\0"
	.uleb128 0x1
	.byte	0x4
	.byte	0x7
	.ascii "unsigned int\0"
	.uleb128 0x1
	.byte	0x10
	.byte	0x4
	.ascii "long double\0"
	.uleb128 0x1
	.byte	0x1
	.byte	0x6
	.ascii "signed char\0"
	.uleb128 0x1
	.byte	0x1
	.byte	0x8
	.ascii "unsigned char\0"
	.uleb128 0x1
	.byte	0x2
	.byte	0x5
	.ascii "short int\0"
	.uleb128 0x1
	.byte	0x8
	.byte	0x4
	.ascii "double\0"
	.uleb128 0x1
	.byte	0x4
	.byte	0x4
	.ascii "float\0"
	.uleb128 0x3
	.long	0x115
	.uleb128 0xa
	.long	0x10b
	.uleb128 0xb
	.uleb128 0x8
	.ascii "_iobuf\0"
	.byte	0x8
	.byte	0x3
	.byte	0x21
	.byte	0xa
	.long	0x13d
	.uleb128 0x2
	.ascii "_Placeholder\0"
	.byte	0x3
	.byte	0x23
	.byte	0xb
	.long	0x13d
	.byte	0
	.byte	0
	.uleb128 0xc
	.byte	0x8
	.uleb128 0x5
	.ascii "FILE\0"
	.byte	0x3
	.byte	0x2f
	.byte	0x19
	.long	0x116
	.uleb128 0x5
	.ascii "uintptr\0"
	.byte	0x4
	.byte	0xf
	.byte	0x13
	.long	0x71
	.uleb128 0x5
	.ascii "G\0"
	.byte	0x4
	.byte	0x16
	.byte	0x12
	.long	0x166
	.uleb128 0x8
	.ascii "G\0"
	.byte	0x10
	.byte	0x4
	.byte	0x17
	.byte	0x8
	.long	0x194
	.uleb128 0x2
	.ascii "stacklo\0"
	.byte	0x4
	.byte	0x19
	.byte	0xa
	.long	0x14c
	.byte	0
	.uleb128 0x2
	.ascii "stackhi\0"
	.byte	0x4
	.byte	0x1a
	.byte	0xa
	.long	0x14c
	.byte	0x8
	.byte	0
	.uleb128 0xd
	.secrel32	.LASF2
	.byte	0x4
	.byte	0x21
	.byte	0x1c
	.long	0x1a0
	.uleb128 0xe
	.secrel32	.LASF2
	.byte	0x18
	.byte	0x4
	.byte	0x22
	.byte	0x8
	.long	0x1d2
	.uleb128 0x2
	.ascii "g\0"
	.byte	0x4
	.byte	0x24
	.byte	0x5
	.long	0x1d2
	.byte	0
	.uleb128 0x2
	.ascii "tls\0"
	.byte	0x4
	.byte	0x25
	.byte	0xb
	.long	0x1d7
	.byte	0x8
	.uleb128 0x2
	.ascii "fn\0"
	.byte	0x4
	.byte	0x26
	.byte	0x9
	.long	0x10b
	.byte	0x10
	.byte	0
	.uleb128 0x3
	.long	0x15c
	.uleb128 0x3
	.long	0x14c
	.uleb128 0x3
	.long	0x194
	.uleb128 0xf
	.ascii "_cgo_yield\0"
	.byte	0x1
	.byte	0x1b
	.byte	0xe
	.long	0x110
	.uleb128 0x9
	.byte	0x3
	.quad	_cgo_yield
	.uleb128 0x10
	.ascii "_cgo_sys_thread_start\0"
	.byte	0x4
	.byte	0x3e
	.byte	0x6
	.long	0x222
	.uleb128 0x6
	.long	0x1dc
	.byte	0
	.uleb128 0x11
	.ascii "abort\0"
	.byte	0x5
	.word	0x123
	.byte	0x28
	.uleb128 0x12
	.ascii "__acrt_iob_func\0"
	.byte	0x3
	.byte	0x65
	.byte	0x17
	.long	0x24f
	.long	0x24f
	.uleb128 0x6
	.long	0xac
	.byte	0
	.uleb128 0x3
	.long	0x13f
	.uleb128 0x13
	.ascii "malloc\0"
	.byte	0x5
	.word	0x1c8
	.byte	0x11
	.long	0x13d
	.long	0x26e
	.uleb128 0x6
	.long	0x46
	.byte	0
	.uleb128 0x14
	.ascii "x_cgo_thread_start\0"
	.byte	0x1
	.byte	0x9
	.byte	0x1
	.quad	.LFB113
	.quad	.LFE113-.LFB113
	.uleb128 0x1
	.byte	0x9c
	.long	0x335
	.uleb128 0x15
	.ascii "arg\0"
	.byte	0x1
	.byte	0x9
	.byte	0x21
	.long	0x1dc
	.secrel32	.LLST0
	.secrel32	.LVUS0
	.uleb128 0x16
	.ascii "ts\0"
	.byte	0x1
	.byte	0xb
	.byte	0xf
	.long	0x1dc
	.secrel32	.LLST1
	.secrel32	.LVUS1
	.uleb128 0x7
	.quad	.LVL2
	.long	0x254
	.long	0x2d9
	.uleb128 0x4
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x48
	.byte	0
	.uleb128 0x17
	.quad	.LVL4
	.long	0x1fe
	.uleb128 0x7
	.quad	.LVL5
	.long	0x22d
	.long	0x2fd
	.uleb128 0x4
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x1
	.byte	0x32
	.byte	0
	.uleb128 0x7
	.quad	.LVL6
	.long	0x335
	.long	0x327
	.uleb128 0x4
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	.LC0
	.uleb128 0x4
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x1
	.byte	0x31
	.uleb128 0x4
	.uleb128 0x1
	.byte	0x58
	.uleb128 0x2
	.byte	0x8
	.byte	0x2b
	.byte	0
	.uleb128 0x18
	.quad	.LVL7
	.long	0x222
	.byte	0
	.uleb128 0x19
	.ascii "fwrite\0"
	.ascii "__builtin_fwrite\0"
	.byte	0x6
	.byte	0
	.byte	0
	.section	.debug_abbrev,"dr"
.Ldebug_abbrev0:
	.uleb128 0x1
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
	.uleb128 0x2
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
	.uleb128 0x49
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x7e
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x5
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
	.uleb128 0x6
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
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
	.uleb128 0x8
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
	.uleb128 0x9
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
	.uleb128 0xa
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x15
	.byte	0
	.uleb128 0x27
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
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
	.uleb128 0xe
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
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
	.uleb128 0xf
	.uleb128 0x34
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
	.uleb128 0x3f
	.uleb128 0x19
	.uleb128 0x2
	.uleb128 0x18
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
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
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
	.uleb128 0x12
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
	.uleb128 0x13
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
	.uleb128 0x14
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
	.uleb128 0x15
	.uleb128 0x5
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
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x16
	.uleb128 0x34
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
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x17
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
	.uleb128 0x18
	.uleb128 0x48
	.byte	0
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x19
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
.LVUS0:
	.uleb128 0
	.uleb128 .LVU7
	.uleb128 .LVU7
	.uleb128 .LVU18
	.uleb128 .LVU18
	.uleb128 .LVU19
	.uleb128 .LVU19
	.uleb128 0
.LLST0:
	.byte	0x4
	.uleb128 .LVL0-.Ltext0
	.uleb128 .LVL1-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL1-.Ltext0
	.uleb128 .LVL3-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL3-.Ltext0
	.uleb128 .LVL4-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0x4
	.uleb128 .LVL4-.Ltext0
	.uleb128 .LFE113-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0
.LVUS1:
	.uleb128 .LVU8
	.uleb128 .LVU19
	.uleb128 .LVU19
	.uleb128 .LVU21
.LLST1:
	.byte	0x4
	.uleb128 .LVL2-.Ltext0
	.uleb128 .LVL4-1-.Ltext0
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL4-.Ltext0
	.uleb128 .LVL5-1-.Ltext0
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
	.section	.debug_line,"dr"
.Ldebug_line0:
	.section	.debug_str,"dr"
.LASF2:
	.ascii "ThreadStart\0"
	.section	.debug_line_str,"dr"
.LASF1:
	.ascii "\\\\_\\_\\GOROOT\\src\\runtime\\cgo\0"
.LASF0:
	.ascii "gcc_util.c\0"
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	malloc;	.scl	2;	.type	32;	.endef
	.def	_cgo_sys_thread_start;	.scl	2;	.type	32;	.endef
	.def	fwrite;	.scl	2;	.type	32;	.endef
	.def	abort;	.scl	2;	.type	32;	.endef
