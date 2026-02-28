	.file	"gcc_windows_amd64.c"
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "//_/_/GOROOT/src/runtime/cgo" "gcc_windows_amd64.c"
	.p2align 4
	.def	threadentry;	.scl	3;	.type	32;	.endef
	.seh_proc	threadentry
threadentry:
.LVL0:
.LFB7695:
	.file 1 "gcc_windows_amd64.c"
	.loc 1 36 1 view -0
	.cfi_startproc
	.loc 1 36 1 is_stmt 0 view .LVU1
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
	subq	$32, %rsp
	.seh_stackalloc	32
	.cfi_def_cfa_offset 64
	.seh_endprologue
	.loc 1 37 2 is_stmt 1 view .LVU2
	.loc 1 39 2 view .LVU3
	.loc 1 39 5 is_stmt 0 view .LVU4
	movq	(%rcx), %rsi
.LVL1:
	.loc 1 39 5 view .LVU5
	movq	8(%rcx), %rdi
.LVL2:
	.loc 1 39 5 view .LVU6
	movq	16(%rcx), %rbx
.LVL3:
	.loc 1 40 2 is_stmt 1 view .LVU7
	call	free
.LVL4:
	.loc 1 47 2 view .LVU8
	.loc 1 49 24 is_stmt 0 view .LVU9
	movq	tls_g(%rip), %rax
	.loc 1 47 2 view .LVU10
	movl	(%rax), %eax
/APP
 # 47 "gcc_windows_amd64.c" 1
	movq %rdi, %gs:0(%eax)

 # 0 "" 2
	.loc 1 52 2 is_stmt 1 view .LVU11
/NO_APP
	movq	setg_gcc(%rip), %rdx
	movq	%rsi, %r8
	movq	%rbx, %rcx
	call	crosscall1
.LVL5:
	.loc 1 53 2 view .LVU12
	.loc 1 54 1 is_stmt 0 view .LVU13
	xorl	%eax, %eax
	addq	$32, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 24
	popq	%rsi
	.cfi_restore 4
	.cfi_def_cfa_offset 16
	popq	%rdi
	.cfi_restore 5
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE7695:
	.seh_endproc
	.p2align 4
	.globl	x_cgo_init
	.def	x_cgo_init;	.scl	2;	.type	32;	.endef
	.seh_proc	x_cgo_init
x_cgo_init:
.LVL6:
.LFB7693:
	.loc 1 20 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 20 1 is_stmt 0 view .LVU15
	.seh_endprologue
	.loc 1 21 2 is_stmt 1 view .LVU16
	.loc 1 21 11 is_stmt 0 view .LVU17
	movq	%rdx, setg_gcc(%rip)
	.loc 1 22 2 is_stmt 1 view .LVU18
	.loc 1 22 8 is_stmt 0 view .LVU19
	movq	%r8, tls_g(%rip)
	.loc 1 23 1 view .LVU20
	ret
	.cfi_endproc
.LFE7693:
	.seh_endproc
	.p2align 4
	.globl	_cgo_sys_thread_start
	.def	_cgo_sys_thread_start;	.scl	2;	.type	32;	.endef
	.seh_proc	_cgo_sys_thread_start
_cgo_sys_thread_start:
.LVL7:
.LFB7694:
	.loc 1 28 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 28 1 is_stmt 0 view .LVU22
	.seh_endprologue
	.loc 1 29 2 is_stmt 1 view .LVU23
	.loc 1 28 1 is_stmt 0 view .LVU24
	movq	%rcx, %rdx
	.loc 1 29 2 view .LVU25
	leaq	threadentry(%rip), %rcx
.LVL8:
	.loc 1 30 1 view .LVU26
	.loc 1 29 2 view .LVU27
	jmp	_cgo_beginthread
.LVL9:
	.loc 1 29 2 view .LVU28
	.cfi_endproc
.LFE7694:
	.seh_endproc
.lcomm tls_g,8,8
.lcomm setg_gcc,8,8
.Letext0:
	.file 2 "C:/msys64/ucrt64/include/corecrt.h"
	.file 3 "C:/msys64/ucrt64/include/minwindef.h"
	.file 4 "libcgo.h"
	.file 5 "C:/msys64/ucrt64/include/stdlib.h"
	.file 6 "libcgo_windows.h"
	.file 7 "C:/msys64/ucrt64/include/winnt.h"
	.section	.debug_info,"dr"
.Ldebug_info0:
	.long	0x4b5
	.word	0x5
	.byte	0x1
	.byte	0x8
	.secrel32	.Ldebug_abbrev0
	.uleb128 0xd
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
	.uleb128 0x6
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
	.byte	0x4
	.byte	0x7
	.ascii "long unsigned int\0"
	.uleb128 0xe
	.byte	0x8
	.uleb128 0x1
	.byte	0x1
	.byte	0x8
	.ascii "unsigned char\0"
	.uleb128 0x6
	.ascii "DWORD\0"
	.byte	0x3
	.byte	0x8d
	.byte	0x1d
	.long	0xbc
	.uleb128 0x1
	.byte	0x4
	.byte	0x4
	.ascii "float\0"
	.uleb128 0x2
	.long	0xe4
	.uleb128 0x1
	.byte	0x1
	.byte	0x6
	.ascii "signed char\0"
	.uleb128 0x1
	.byte	0x2
	.byte	0x5
	.ascii "short int\0"
	.uleb128 0x1
	.byte	0x10
	.byte	0x4
	.ascii "long double\0"
	.uleb128 0x1
	.byte	0x8
	.byte	0x4
	.ascii "double\0"
	.uleb128 0x2
	.long	0x13a
	.uleb128 0xf
	.uleb128 0x1
	.byte	0x4
	.byte	0x4
	.ascii "float\0"
	.uleb128 0x1
	.byte	0x8
	.byte	0x4
	.ascii "double\0"
	.uleb128 0x1
	.byte	0x2
	.byte	0x4
	.ascii "_Float16\0"
	.uleb128 0x1
	.byte	0x2
	.byte	0x4
	.ascii "__bf16\0"
	.uleb128 0x10
	.ascii "JOB_OBJECT_NET_RATE_CONTROL_FLAGS\0"
	.byte	0x7
	.byte	0x4
	.long	0xac
	.byte	0x7
	.word	0x142f
	.byte	0x12
	.long	0x238
	.uleb128 0x7
	.ascii "JOB_OBJECT_NET_RATE_CONTROL_ENABLE\0"
	.byte	0x1
	.uleb128 0x7
	.ascii "JOB_OBJECT_NET_RATE_CONTROL_MAX_BANDWIDTH\0"
	.byte	0x2
	.uleb128 0x7
	.ascii "JOB_OBJECT_NET_RATE_CONTROL_DSCP_TAG\0"
	.byte	0x4
	.uleb128 0x7
	.ascii "JOB_OBJECT_NET_RATE_CONTROL_VALID_FLAGS\0"
	.byte	0x7
	.byte	0
	.uleb128 0x2
	.long	0x23d
	.uleb128 0x11
	.long	0x248
	.uleb128 0x3
	.long	0xd1
	.byte	0
	.uleb128 0x6
	.ascii "uintptr\0"
	.byte	0x4
	.byte	0xf
	.byte	0x13
	.long	0x71
	.uleb128 0x6
	.ascii "G\0"
	.byte	0x4
	.byte	0x16
	.byte	0x12
	.long	0x262
	.uleb128 0x12
	.ascii "G\0"
	.byte	0x10
	.byte	0x4
	.byte	0x17
	.byte	0x8
	.long	0x28e
	.uleb128 0x4
	.ascii "stacklo\0"
	.byte	0x19
	.byte	0xa
	.long	0x248
	.byte	0
	.uleb128 0x4
	.ascii "stackhi\0"
	.byte	0x1a
	.byte	0xa
	.long	0x248
	.byte	0x8
	.byte	0
	.uleb128 0x13
	.secrel32	.LASF2
	.byte	0x4
	.byte	0x21
	.byte	0x1c
	.long	0x29a
	.uleb128 0x14
	.secrel32	.LASF2
	.byte	0x18
	.byte	0x4
	.byte	0x22
	.byte	0x8
	.long	0x2c9
	.uleb128 0x4
	.ascii "g\0"
	.byte	0x24
	.byte	0x5
	.long	0x2c9
	.byte	0
	.uleb128 0x4
	.ascii "tls\0"
	.byte	0x25
	.byte	0xb
	.long	0x2ce
	.byte	0x8
	.uleb128 0x4
	.ascii "fn\0"
	.byte	0x26
	.byte	0x9
	.long	0x135
	.byte	0x10
	.byte	0
	.uleb128 0x2
	.long	0x258
	.uleb128 0x2
	.long	0x248
	.uleb128 0x2
	.long	0x28e
	.uleb128 0x9
	.ascii "setg_gcc\0"
	.byte	0xf
	.long	0x238
	.uleb128 0x9
	.byte	0x3
	.quad	setg_gcc
	.uleb128 0x9
	.ascii "tls_g\0"
	.byte	0x10
	.long	0xfb
	.uleb128 0x9
	.byte	0x3
	.quad	tls_g
	.uleb128 0xa
	.ascii "crosscall1\0"
	.byte	0x1
	.byte	0x20
	.byte	0xd
	.long	0x32a
	.uleb128 0x3
	.long	0x135
	.uleb128 0x3
	.long	0x238
	.uleb128 0x3
	.long	0xd1
	.byte	0
	.uleb128 0x15
	.ascii "free\0"
	.byte	0x5
	.word	0x1c7
	.byte	0x10
	.long	0x33e
	.uleb128 0x3
	.long	0xd1
	.byte	0
	.uleb128 0xa
	.ascii "_cgo_beginthread\0"
	.byte	0x6
	.byte	0x6
	.byte	0x6
	.long	0x362
	.uleb128 0x3
	.long	0x362
	.uleb128 0x3
	.long	0xd1
	.byte	0
	.uleb128 0x2
	.long	0x367
	.uleb128 0x16
	.long	0xbc
	.long	0x376
	.uleb128 0x3
	.long	0xd1
	.byte	0
	.uleb128 0x17
	.ascii "threadentry\0"
	.byte	0x1
	.byte	0x23
	.byte	0x1
	.long	0xbc
	.quad	.LFB7695
	.quad	.LFE7695-.LFB7695
	.uleb128 0x1
	.byte	0x9c
	.long	0x3f8
	.uleb128 0xb
	.ascii "v\0"
	.byte	0x23
	.byte	0x13
	.long	0xd1
	.secrel32	.LLST0
	.secrel32	.LVUS0
	.uleb128 0x18
	.ascii "ts\0"
	.byte	0x1
	.byte	0x25
	.byte	0xe
	.long	0x28e
	.secrel32	.LLST1
	.secrel32	.LVUS1
	.uleb128 0x19
	.quad	.LVL4
	.long	0x32a
	.long	0x3dd
	.uleb128 0x5
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0
	.uleb128 0x1a
	.quad	.LVL5
	.long	0x307
	.uleb128 0x5
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x73
	.sleb128 0
	.uleb128 0x5
	.uleb128 0x1
	.byte	0x58
	.uleb128 0x2
	.byte	0x74
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0xc
	.ascii "_cgo_sys_thread_start\0"
	.byte	0x1b
	.quad	.LFB7694
	.quad	.LFE7694-.LFB7694
	.uleb128 0x1
	.byte	0x9c
	.long	0x45b
	.uleb128 0xb
	.ascii "ts\0"
	.byte	0x1b
	.byte	0x24
	.long	0x2d3
	.secrel32	.LLST2
	.secrel32	.LVUS2
	.uleb128 0x1b
	.quad	.LVL9
	.long	0x33e
	.uleb128 0x5
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x9
	.byte	0x3
	.quad	threadentry
	.uleb128 0x5
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x3
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0
	.byte	0
	.uleb128 0xc
	.ascii "x_cgo_init\0"
	.byte	0x13
	.quad	.LFB7693
	.quad	.LFE7693-.LFB7693
	.uleb128 0x1
	.byte	0x9c
	.long	0x4b3
	.uleb128 0x8
	.ascii "g\0"
	.byte	0xf
	.long	0x2c9
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x8
	.ascii "setg\0"
	.byte	0x19
	.long	0x238
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x8
	.ascii "tlsg\0"
	.byte	0x2e
	.long	0x4b3
	.uleb128 0x1
	.byte	0x58
	.uleb128 0x8
	.ascii "tlsbase\0"
	.byte	0x3b
	.long	0x4b3
	.uleb128 0x1
	.byte	0x59
	.byte	0
	.uleb128 0x2
	.long	0xd1
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
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 4
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
	.uleb128 0x5
	.uleb128 0x49
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x7e
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x6
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
	.uleb128 0x7
	.uleb128 0x28
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x1c
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0x21
	.sleb128 19
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x9
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
	.uleb128 0x21
	.sleb128 15
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xa
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
	.uleb128 0xb
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
	.uleb128 0xc
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
	.uleb128 0x21
	.sleb128 1
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
	.uleb128 0xd
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
	.uleb128 0xe
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x15
	.byte	0
	.uleb128 0x27
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0x10
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
	.uleb128 0x11
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
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
	.uleb128 0x14
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
	.uleb128 0x5
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
	.uleb128 0x16
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
	.uleb128 0x17
	.uleb128 0x2e
	.byte	0x1
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
	.uleb128 0x18
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
	.uleb128 0x19
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
	.uleb128 0x1a
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x1b
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
	.uleb128 .LVU8
	.uleb128 .LVU8
	.uleb128 0
.LLST0:
	.byte	0x4
	.uleb128 .LVL0-.Ltext0
	.uleb128 .LVL4-1-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL4-1-.Ltext0
	.uleb128 .LFE7695-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0
.LVUS1:
	.uleb128 .LVU5
	.uleb128 .LVU6
	.uleb128 .LVU6
	.uleb128 .LVU7
	.uleb128 .LVU7
	.uleb128 .LVU13
.LLST1:
	.byte	0x4
	.uleb128 .LVL1-.Ltext0
	.uleb128 .LVL2-.Ltext0
	.uleb128 0x5
	.byte	0x54
	.byte	0x93
	.uleb128 0x8
	.byte	0x93
	.uleb128 0x10
	.byte	0x4
	.uleb128 .LVL2-.Ltext0
	.uleb128 .LVL3-.Ltext0
	.uleb128 0x8
	.byte	0x54
	.byte	0x93
	.uleb128 0x8
	.byte	0x55
	.byte	0x93
	.uleb128 0x8
	.byte	0x93
	.uleb128 0x8
	.byte	0x4
	.uleb128 .LVL3-.Ltext0
	.uleb128 .LVL5-.Ltext0
	.uleb128 0x9
	.byte	0x54
	.byte	0x93
	.uleb128 0x8
	.byte	0x55
	.byte	0x93
	.uleb128 0x8
	.byte	0x53
	.byte	0x93
	.uleb128 0x8
	.byte	0
.LVUS2:
	.uleb128 0
	.uleb128 .LVU26
	.uleb128 .LVU26
	.uleb128 .LVU28
	.uleb128 .LVU28
	.uleb128 0
.LLST2:
	.byte	0x4
	.uleb128 .LVL7-.Ltext0
	.uleb128 .LVL8-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL8-.Ltext0
	.uleb128 .LVL9-1-.Ltext0
	.uleb128 0x1
	.byte	0x51
	.byte	0x4
	.uleb128 .LVL9-1-.Ltext0
	.uleb128 .LFE7694-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
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
	.ascii "gcc_windows_amd64.c\0"
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	free;	.scl	2;	.type	32;	.endef
	.def	crosscall1;	.scl	2;	.type	32;	.endef
	.def	_cgo_beginthread;	.scl	2;	.type	32;	.endef
