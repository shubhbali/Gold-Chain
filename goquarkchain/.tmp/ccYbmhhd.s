	.file	"_cgo_export.c"
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/tmp/go-build" "_cgo_export.c"
	.p2align 4
	.globl	secp256k1GoPanicIllegal
	.def	secp256k1GoPanicIllegal;	.scl	2;	.type	32;	.endef
	.seh_proc	secp256k1GoPanicIllegal
secp256k1GoPanicIllegal:
.LVL0:
.LFB14:
	.file 1 "_cgo_export.c"
	.loc 1 27 1 view -0
	.cfi_startproc
	.loc 1 27 1 is_stmt 0 view .LVU1
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
	.loc 1 28 2 is_stmt 1 view .LVU2
	.loc 1 27 1 is_stmt 0 view .LVU3
	movq	%rcx, %rsi
	movq	%rdx, %rbx
	.loc 1 28 21 view .LVU4
	call	_cgo_wait_runtime_init_done
.LVL1:
	.loc 1 38 2 view .LVU5
	leaq	32(%rsp), %rdx
	movl	$16, %r8d
	leaq	_cgoexp_1fc93ead4968_secp256k1GoPanicIllegal(%rip), %rcx
	.loc 1 28 21 view .LVU6
	movq	%rax, %rdi
.LVL2:
	.loc 1 29 2 is_stmt 1 view .LVU7
	.loc 1 33 2 view .LVU8
	.loc 1 34 2 view .LVU9
	.loc 1 35 2 view .LVU10
	.loc 1 38 2 is_stmt 0 view .LVU11
	movq	%rax, %r9
	.loc 1 35 12 view .LVU12
	movq	%rsi, 32(%rsp)
	.loc 1 36 2 is_stmt 1 view .LVU13
	.loc 1 36 12 is_stmt 0 view .LVU14
	movq	%rbx, 40(%rsp)
	.loc 1 37 21 is_stmt 1 view .LVU15
	.loc 1 38 2 view .LVU16
	call	crosscall2
.LVL3:
	.loc 1 39 21 view .LVU17
	.loc 1 40 2 view .LVU18
	movq	%rdi, %rcx
	call	_cgo_release_context
	nop
.LVL4:
	.loc 1 41 1 is_stmt 0 view .LVU19
	addq	$48, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 24
.LVL5:
	.loc 1 41 1 view .LVU20
	popq	%rsi
	.cfi_restore 4
	.cfi_def_cfa_offset 16
.LVL6:
	.loc 1 41 1 view .LVU21
	popq	%rdi
	.cfi_restore 5
	.cfi_def_cfa_offset 8
.LVL7:
	.loc 1 41 1 view .LVU22
	ret
	.cfi_endproc
.LFE14:
	.seh_endproc
	.p2align 4
	.globl	secp256k1GoPanicError
	.def	secp256k1GoPanicError;	.scl	2;	.type	32;	.endef
	.seh_proc	secp256k1GoPanicError
secp256k1GoPanicError:
.LVL8:
.LFB15:
	.loc 1 46 1 is_stmt 1 view -0
	.cfi_startproc
	.loc 1 46 1 is_stmt 0 view .LVU24
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
	.loc 1 47 2 is_stmt 1 view .LVU25
	.loc 1 46 1 is_stmt 0 view .LVU26
	movq	%rcx, %rsi
	movq	%rdx, %rbx
	.loc 1 47 21 view .LVU27
	call	_cgo_wait_runtime_init_done
.LVL9:
	.loc 1 57 2 view .LVU28
	leaq	32(%rsp), %rdx
	movl	$16, %r8d
	leaq	_cgoexp_1fc93ead4968_secp256k1GoPanicError(%rip), %rcx
	.loc 1 47 21 view .LVU29
	movq	%rax, %rdi
.LVL10:
	.loc 1 48 2 is_stmt 1 view .LVU30
	.loc 1 52 2 view .LVU31
	.loc 1 53 2 view .LVU32
	.loc 1 54 2 view .LVU33
	.loc 1 57 2 is_stmt 0 view .LVU34
	movq	%rax, %r9
	.loc 1 54 12 view .LVU35
	movq	%rsi, 32(%rsp)
	.loc 1 55 2 is_stmt 1 view .LVU36
	.loc 1 55 12 is_stmt 0 view .LVU37
	movq	%rbx, 40(%rsp)
	.loc 1 56 21 is_stmt 1 view .LVU38
	.loc 1 57 2 view .LVU39
	call	crosscall2
.LVL11:
	.loc 1 58 21 view .LVU40
	.loc 1 59 2 view .LVU41
	movq	%rdi, %rcx
	call	_cgo_release_context
	nop
.LVL12:
	.loc 1 60 1 is_stmt 0 view .LVU42
	addq	$48, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 24
.LVL13:
	.loc 1 60 1 view .LVU43
	popq	%rsi
	.cfi_restore 4
	.cfi_def_cfa_offset 16
.LVL14:
	.loc 1 60 1 view .LVU44
	popq	%rdi
	.cfi_restore 5
	.cfi_def_cfa_offset 8
.LVL15:
	.loc 1 60 1 view .LVU45
	ret
	.cfi_endproc
.LFE15:
	.seh_endproc
.Letext0:
	.file 2 "C:/msys64/ucrt64/include/corecrt.h"
	.section	.debug_info,"dr"
.Ldebug_info0:
	.long	0x3fa
	.word	0x5
	.byte	0x1
	.byte	0x8
	.secrel32	.Ldebug_abbrev0
	.uleb128 0x11
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
	.uleb128 0x12
	.ascii "size_t\0"
	.byte	0x2
	.byte	0x23
	.byte	0x2c
	.long	0x55
	.uleb128 0x1
	.byte	0x8
	.byte	0x7
	.ascii "long long unsigned int\0"
	.uleb128 0x1
	.byte	0x8
	.byte	0x5
	.ascii "long long int\0"
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
	.byte	0x1
	.byte	0x8
	.ascii "unsigned char\0"
	.uleb128 0x1
	.byte	0x8
	.byte	0x4
	.ascii "double\0"
	.uleb128 0x1
	.byte	0x4
	.byte	0x4
	.ascii "float\0"
	.uleb128 0x1
	.byte	0x10
	.byte	0x4
	.ascii "long double\0"
	.uleb128 0x1
	.byte	0x1
	.byte	0x6
	.ascii "signed char\0"
	.uleb128 0x1
	.byte	0x2
	.byte	0x5
	.ascii "short int\0"
	.uleb128 0x1
	.byte	0x8
	.byte	0x3
	.ascii "complex float\0"
	.uleb128 0x1
	.byte	0x10
	.byte	0x3
	.ascii "complex double\0"
	.uleb128 0x13
	.byte	0x8
	.uleb128 0x4
	.ascii "_cgoexp_1fc93ead4968_secp256k1GoPanicError\0"
	.byte	0x2a
	.long	0x164
	.uleb128 0x2
	.long	0x12b
	.byte	0
	.uleb128 0x4
	.ascii "_cgo_release_context\0"
	.byte	0xd
	.long	0x185
	.uleb128 0x2
	.long	0x46
	.byte	0
	.uleb128 0x4
	.ascii "_cgoexp_1fc93ead4968_secp256k1GoPanicIllegal\0"
	.byte	0x17
	.long	0x1be
	.uleb128 0x2
	.long	0x12b
	.byte	0
	.uleb128 0x4
	.ascii "crosscall2\0"
	.byte	0xb
	.long	0x1e4
	.uleb128 0x2
	.long	0x1e4
	.uleb128 0x2
	.long	0x12b
	.uleb128 0x2
	.long	0x96
	.uleb128 0x2
	.long	0x46
	.byte	0
	.uleb128 0x7
	.long	0x1e9
	.uleb128 0x14
	.long	0x1f4
	.uleb128 0x2
	.long	0x12b
	.byte	0
	.uleb128 0x15
	.ascii "_cgo_wait_runtime_init_done\0"
	.byte	0x1
	.byte	0xc
	.byte	0xf
	.long	0x46
	.uleb128 0x16
	.ascii "secp256k1GoPanicError\0"
	.byte	0x1
	.byte	0x2d
	.byte	0x6
	.quad	.LFB15
	.quad	.LFE15-.LFB15
	.uleb128 0x1
	.byte	0x9c
	.long	0x309
	.uleb128 0x5
	.ascii "msg\0"
	.byte	0x2d
	.byte	0x22
	.long	0x309
	.secrel32	.LLST3
	.secrel32	.LVUS3
	.uleb128 0x5
	.ascii "data\0"
	.byte	0x2d
	.byte	0x2d
	.long	0x12b
	.secrel32	.LLST4
	.secrel32	.LVUS4
	.uleb128 0x8
	.secrel32	.LASF2
	.byte	0x2f
	.long	0x46
	.secrel32	.LLST5
	.secrel32	.LVUS5
	.uleb128 0x9
	.byte	0x30
	.long	0x29c
	.uleb128 0x6
	.ascii "p0\0"
	.byte	0x31
	.long	0x309
	.byte	0
	.uleb128 0x6
	.ascii "p1\0"
	.byte	0x32
	.long	0x12b
	.byte	0x8
	.byte	0
	.uleb128 0xa
	.secrel32	.LASF3
	.byte	0x33
	.byte	0x4c
	.long	0x281
	.uleb128 0xb
	.secrel32	.LASF4
	.byte	0x34
	.long	0x29c
	.uleb128 0xc
	.ascii "_cgo_a\0"
	.byte	0x35
	.long	0x29c
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0xd
	.quad	.LVL9
	.long	0x1f4
	.uleb128 0xe
	.quad	.LVL11
	.long	0x1be
	.long	0x2f4
	.uleb128 0xf
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x3
	.uleb128 0x1
	.byte	0x58
	.uleb128 0x1
	.byte	0x40
	.uleb128 0x3
	.uleb128 0x1
	.byte	0x59
	.uleb128 0x2
	.byte	0x75
	.sleb128 0
	.byte	0
	.uleb128 0x10
	.quad	.LVL12
	.long	0x164
	.uleb128 0x3
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x75
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x7
	.long	0x3e
	.uleb128 0x17
	.ascii "secp256k1GoPanicIllegal\0"
	.byte	0x1
	.byte	0x1a
	.byte	0x6
	.quad	.LFB14
	.quad	.LFE14-.LFB14
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0x5
	.ascii "msg\0"
	.byte	0x1a
	.byte	0x24
	.long	0x309
	.secrel32	.LLST0
	.secrel32	.LVUS0
	.uleb128 0x5
	.ascii "data\0"
	.byte	0x1a
	.byte	0x2f
	.long	0x12b
	.secrel32	.LLST1
	.secrel32	.LVUS1
	.uleb128 0x8
	.secrel32	.LASF2
	.byte	0x1c
	.long	0x46
	.secrel32	.LLST2
	.secrel32	.LVUS2
	.uleb128 0x9
	.byte	0x1d
	.long	0x390
	.uleb128 0x6
	.ascii "p0\0"
	.byte	0x1e
	.long	0x309
	.byte	0
	.uleb128 0x6
	.ascii "p1\0"
	.byte	0x1f
	.long	0x12b
	.byte	0x8
	.byte	0
	.uleb128 0xa
	.secrel32	.LASF3
	.byte	0x20
	.byte	0x4c
	.long	0x375
	.uleb128 0xb
	.secrel32	.LASF4
	.byte	0x21
	.long	0x390
	.uleb128 0xc
	.ascii "_cgo_a\0"
	.byte	0x22
	.long	0x390
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0xd
	.quad	.LVL1
	.long	0x1f4
	.uleb128 0xe
	.quad	.LVL3
	.long	0x1be
	.long	0x3e8
	.uleb128 0xf
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x3
	.uleb128 0x1
	.byte	0x51
	.uleb128 0x2
	.byte	0x91
	.sleb128 -48
	.uleb128 0x3
	.uleb128 0x1
	.byte	0x58
	.uleb128 0x1
	.byte	0x40
	.uleb128 0x3
	.uleb128 0x1
	.byte	0x59
	.uleb128 0x2
	.byte	0x75
	.sleb128 0
	.byte	0
	.uleb128 0x10
	.quad	.LVL4
	.long	0x164
	.uleb128 0x3
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x75
	.sleb128 0
	.byte	0
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
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x49
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x7e
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x4
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
	.sleb128 13
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x3c
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
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
	.uleb128 0x6
	.uleb128 0xd
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
	.sleb128 9
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 9
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x17
	.uleb128 0x2137
	.uleb128 0x17
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x13
	.byte	0x1
	.uleb128 0xb
	.uleb128 0x21
	.sleb128 16
	.uleb128 0x88
	.uleb128 0x21
	.sleb128 8
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 10
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x88
	.uleb128 0x21
	.sleb128 8
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0x21
	.sleb128 1
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x39
	.uleb128 0x21
	.sleb128 22
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
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
	.uleb128 0xd
	.uleb128 0x48
	.byte	0
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
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
	.uleb128 0xf
	.uleb128 0x49
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
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
	.uleb128 0x12
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
	.uleb128 0x13
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
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
	.uleb128 0x16
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
	.uleb128 0x17
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
.LVUS3:
	.uleb128 0
	.uleb128 .LVU28
	.uleb128 .LVU28
	.uleb128 .LVU44
	.uleb128 .LVU44
	.uleb128 0
.LLST3:
	.byte	0x4
	.uleb128 .LVL8-.Ltext0
	.uleb128 .LVL9-1-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL9-1-.Ltext0
	.uleb128 .LVL14-.Ltext0
	.uleb128 0x1
	.byte	0x54
	.byte	0x4
	.uleb128 .LVL14-.Ltext0
	.uleb128 .LFE15-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0
.LVUS4:
	.uleb128 0
	.uleb128 .LVU28
	.uleb128 .LVU28
	.uleb128 .LVU43
	.uleb128 .LVU43
	.uleb128 0
.LLST4:
	.byte	0x4
	.uleb128 .LVL8-.Ltext0
	.uleb128 .LVL9-1-.Ltext0
	.uleb128 0x1
	.byte	0x51
	.byte	0x4
	.uleb128 .LVL9-1-.Ltext0
	.uleb128 .LVL13-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL13-.Ltext0
	.uleb128 .LFE15-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.byte	0
.LVUS5:
	.uleb128 .LVU30
	.uleb128 .LVU40
	.uleb128 .LVU40
	.uleb128 .LVU45
.LLST5:
	.byte	0x4
	.uleb128 .LVL10-.Ltext0
	.uleb128 .LVL11-1-.Ltext0
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL11-1-.Ltext0
	.uleb128 .LVL15-.Ltext0
	.uleb128 0x1
	.byte	0x55
	.byte	0
.LVUS0:
	.uleb128 0
	.uleb128 .LVU5
	.uleb128 .LVU5
	.uleb128 .LVU21
	.uleb128 .LVU21
	.uleb128 0
.LLST0:
	.byte	0x4
	.uleb128 .LVL0-.Ltext0
	.uleb128 .LVL1-1-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL1-1-.Ltext0
	.uleb128 .LVL6-.Ltext0
	.uleb128 0x1
	.byte	0x54
	.byte	0x4
	.uleb128 .LVL6-.Ltext0
	.uleb128 .LFE14-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0
.LVUS1:
	.uleb128 0
	.uleb128 .LVU5
	.uleb128 .LVU5
	.uleb128 .LVU20
	.uleb128 .LVU20
	.uleb128 0
.LLST1:
	.byte	0x4
	.uleb128 .LVL0-.Ltext0
	.uleb128 .LVL1-1-.Ltext0
	.uleb128 0x1
	.byte	0x51
	.byte	0x4
	.uleb128 .LVL1-1-.Ltext0
	.uleb128 .LVL5-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL5-.Ltext0
	.uleb128 .LFE14-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x51
	.byte	0x9f
	.byte	0
.LVUS2:
	.uleb128 .LVU7
	.uleb128 .LVU17
	.uleb128 .LVU17
	.uleb128 .LVU22
.LLST2:
	.byte	0x4
	.uleb128 .LVL2-.Ltext0
	.uleb128 .LVL3-1-.Ltext0
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL3-1-.Ltext0
	.uleb128 .LVL7-.Ltext0
	.uleb128 0x1
	.byte	0x55
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
.LASF3:
	.ascii "_cgo_argtype\0"
.LASF2:
	.ascii "_cgo_ctxt\0"
.LASF4:
	.ascii "_cgo_zero\0"
	.section	.debug_line_str,"dr"
.LASF1:
	.ascii "/tmp/go-build\0"
.LASF0:
	.ascii "_cgo_export.c\0"
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	_cgo_wait_runtime_init_done;	.scl	2;	.type	32;	.endef
	.def	_cgoexp_1fc93ead4968_secp256k1GoPanicIllegal;	.scl	2;	.type	32;	.endef
	.def	crosscall2;	.scl	2;	.type	32;	.endef
	.def	_cgo_release_context;	.scl	2;	.type	32;	.endef
	.def	_cgoexp_1fc93ead4968_secp256k1GoPanicError;	.scl	2;	.type	32;	.endef
	.section	.rdata$.refptr._cgoexp_1fc93ead4968_secp256k1GoPanicError, "dr"
	.p2align	3, 0
	.globl	.refptr._cgoexp_1fc93ead4968_secp256k1GoPanicError
	.linkonce	discard
.refptr._cgoexp_1fc93ead4968_secp256k1GoPanicError:
	.quad	_cgoexp_1fc93ead4968_secp256k1GoPanicError
	.section	.rdata$.refptr._cgoexp_1fc93ead4968_secp256k1GoPanicIllegal, "dr"
	.p2align	3, 0
	.globl	.refptr._cgoexp_1fc93ead4968_secp256k1GoPanicIllegal
	.linkonce	discard
.refptr._cgoexp_1fc93ead4968_secp256k1GoPanicIllegal:
	.quad	_cgoexp_1fc93ead4968_secp256k1GoPanicIllegal
