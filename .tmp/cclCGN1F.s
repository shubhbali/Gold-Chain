	.file	"curve.cgo2.c"
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "/tmp/go-build" "curve.cgo2.c"
	.p2align 4
	.globl	_cgo_1fc93ead4968_Cfunc_secp256k1_ext_scalar_mul
	.def	_cgo_1fc93ead4968_Cfunc_secp256k1_ext_scalar_mul;	.scl	2;	.type	32;	.endef
	.seh_proc	_cgo_1fc93ead4968_Cfunc_secp256k1_ext_scalar_mul
_cgo_1fc93ead4968_Cfunc_secp256k1_ext_scalar_mul:
.LVL0:
.LFB8:
	.file 1 "cgo-gcc-prolog"
	.loc 1 46 1 view -0
	.cfi_startproc
	.loc 1 46 1 is_stmt 0 view .LVU1
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
	.loc 1 47 2 is_stmt 1 view .LVU2
	.loc 1 46 1 is_stmt 0 view .LVU3
	movq	%rcx, %rbx
.LVL1:
	.loc 1 54 2 is_stmt 1 view .LVU4
	.loc 1 54 22 is_stmt 0 view .LVU5
	call	_cgo_topofstack
.LVL2:
	.loc 1 57 11 view .LVU6
	movq	8(%rbx), %rdx
	movq	(%rbx), %rcx
	movq	16(%rbx), %r8
	.loc 1 54 22 view .LVU7
	movq	%rax, %rdi
.LVL3:
	.loc 1 55 2 is_stmt 1 view .LVU8
	.loc 1 56 21 view .LVU9
	.loc 1 57 2 view .LVU10
	.loc 1 57 11 is_stmt 0 view .LVU11
	call	secp256k1_ext_scalar_mul
.LVL4:
	.loc 1 57 11 view .LVU12
	movl	%eax, %esi
.LVL5:
	.loc 1 58 21 is_stmt 1 view .LVU13
	.loc 1 59 2 view .LVU14
	.loc 1 59 36 is_stmt 0 view .LVU15
	call	_cgo_topofstack
.LVL6:
	.loc 1 60 2 is_stmt 1 view .LVU16
	.loc 1 59 54 is_stmt 0 discriminator 1 view .LVU17
	subq	%rdi, %rax
.LVL7:
	.loc 1 60 12 view .LVU18
	movl	%esi, 24(%rbx,%rax)
	.loc 1 61 48 is_stmt 1 view .LVU19
	.loc 1 62 1 is_stmt 0 view .LVU20
	addq	$32, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 24
.LVL8:
	.loc 1 62 1 view .LVU21
	popq	%rsi
	.cfi_restore 4
	.cfi_def_cfa_offset 16
.LVL9:
	.loc 1 62 1 view .LVU22
	popq	%rdi
	.cfi_restore 5
	.cfi_def_cfa_offset 8
.LVL10:
	.loc 1 62 1 view .LVU23
	ret
	.cfi_endproc
.LFE8:
	.seh_endproc
.Letext0:
	.file 2 "C:/gold/.gomodcache/github.com/ethereum/go-ethereum@v1.8.20/crypto/secp256k1/libsecp256k1/include/secp256k1.h"
	.file 3 "C:/gold/.gomodcache/github.com/ethereum/go-ethereum@v1.8.20/crypto/secp256k1/curve.go"
	.section	.debug_info,"dr"
.Ldebug_info0:
	.long	0x289
	.word	0x5
	.byte	0x1
	.byte	0x8
	.secrel32	.Ldebug_abbrev0
	.uleb128 0x8
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
	.uleb128 0x3
	.long	0x3e
	.uleb128 0x9
	.ascii "secp256k1_context\0"
	.byte	0x2
	.byte	0x2b
	.byte	0x29
	.long	0xdd
	.uleb128 0x7
	.long	0xbe
	.uleb128 0xa
	.ascii "secp256k1_context_struct\0"
	.uleb128 0x1
	.byte	0x1
	.byte	0x8
	.ascii "unsigned char\0"
	.uleb128 0x7
	.long	0xf7
	.uleb128 0x3
	.long	0x108
	.uleb128 0xb
	.byte	0x8
	.uleb128 0xc
	.ascii "secp256k1_ext_scalar_mul\0"
	.byte	0x3
	.byte	0x2b
	.byte	0xc
	.long	0x87
	.long	0x149
	.uleb128 0x4
	.long	0x149
	.uleb128 0x4
	.long	0x10d
	.uleb128 0x4
	.long	0x10d
	.byte	0
	.uleb128 0x3
	.long	0xd8
	.uleb128 0xd
	.ascii "_cgo_topofstack\0"
	.byte	0x1
	.byte	0x13
	.byte	0xe
	.long	0xb9
	.uleb128 0xe
	.ascii "_cgo_1fc93ead4968_Cfunc_secp256k1_ext_scalar_mul\0"
	.byte	0x1
	.byte	0x2d
	.byte	0x1
	.quad	.LFB8
	.quad	.LFE8-.LFB8
	.uleb128 0x1
	.byte	0x9c
	.long	0x277
	.uleb128 0xf
	.ascii "v\0"
	.byte	0x1
	.byte	0x2d
	.byte	0x38
	.long	0x112
	.secrel32	.LLST0
	.secrel32	.LVUS0
	.uleb128 0x10
	.byte	0x20
	.byte	0x1
	.byte	0x2f
	.byte	0x2
	.long	0x208
	.uleb128 0x2
	.ascii "p0\0"
	.byte	0x30
	.byte	0x1c
	.long	0x149
	.byte	0
	.uleb128 0x2
	.ascii "p1\0"
	.byte	0x31
	.byte	0x18
	.long	0x10d
	.byte	0x8
	.uleb128 0x2
	.ascii "p2\0"
	.byte	0x32
	.byte	0x18
	.long	0x10d
	.byte	0x10
	.uleb128 0x2
	.ascii "r\0"
	.byte	0x33
	.byte	0x7
	.long	0x87
	.byte	0x18
	.uleb128 0x2
	.ascii "__pad28\0"
	.byte	0x34
	.byte	0x8
	.long	0x277
	.byte	0x1c
	.byte	0
	.uleb128 0x5
	.ascii "_cgo_a\0"
	.byte	0x35
	.byte	0x31
	.long	0x287
	.secrel32	.LLST1
	.secrel32	.LVUS1
	.uleb128 0x5
	.ascii "_cgo_stktop\0"
	.byte	0x36
	.byte	0x8
	.long	0xb9
	.secrel32	.LLST2
	.secrel32	.LVUS2
	.uleb128 0x5
	.ascii "_cgo_r\0"
	.byte	0x37
	.byte	0x18
	.long	0x87
	.secrel32	.LLST3
	.secrel32	.LVUS3
	.uleb128 0x6
	.quad	.LVL2
	.long	0x14e
	.uleb128 0x6
	.quad	.LVL4
	.long	0x114
	.uleb128 0x6
	.quad	.LVL6
	.long	0x14e
	.byte	0
	.uleb128 0x11
	.long	0x3e
	.long	0x287
	.uleb128 0x12
	.long	0x46
	.byte	0x3
	.byte	0
	.uleb128 0x3
	.long	0x1c3
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
	.uleb128 0x21
	.sleb128 1
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
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
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
	.uleb128 0x6
	.uleb128 0x48
	.byte	0
	.uleb128 0x7d
	.uleb128 0x1
	.uleb128 0x7f
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x26
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
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
	.uleb128 0x9
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
	.uleb128 0xa
	.uleb128 0x13
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3c
	.uleb128 0x19
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
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
	.uleb128 0xd
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
	.uleb128 0xe
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
	.uleb128 0xf
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
	.uleb128 0x10
	.uleb128 0x13
	.byte	0x1
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
	.uleb128 0x11
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
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
	.uleb128 .LVU6
	.uleb128 .LVU6
	.uleb128 .LVU21
	.uleb128 .LVU21
	.uleb128 0
.LLST0:
	.byte	0x4
	.uleb128 .LVL0-.Ltext0
	.uleb128 .LVL2-1-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL2-1-.Ltext0
	.uleb128 .LVL8-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL8-.Ltext0
	.uleb128 .LFE8-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0
.LVUS1:
	.uleb128 .LVU4
	.uleb128 .LVU6
	.uleb128 .LVU6
	.uleb128 .LVU16
	.uleb128 .LVU16
	.uleb128 .LVU18
.LLST1:
	.byte	0x4
	.uleb128 .LVL1-.Ltext0
	.uleb128 .LVL2-1-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL2-1-.Ltext0
	.uleb128 .LVL6-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL6-.Ltext0
	.uleb128 .LVL7-.Ltext0
	.uleb128 0x9
	.byte	0x70
	.sleb128 0
	.byte	0x75
	.sleb128 0
	.byte	0x1c
	.byte	0x73
	.sleb128 0
	.byte	0x22
	.byte	0x9f
	.byte	0
.LVUS2:
	.uleb128 .LVU8
	.uleb128 .LVU12
	.uleb128 .LVU12
	.uleb128 .LVU23
.LLST2:
	.byte	0x4
	.uleb128 .LVL3-.Ltext0
	.uleb128 .LVL4-1-.Ltext0
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL4-1-.Ltext0
	.uleb128 .LVL10-.Ltext0
	.uleb128 0x1
	.byte	0x55
	.byte	0
.LVUS3:
	.uleb128 .LVU13
	.uleb128 .LVU16
	.uleb128 .LVU16
	.uleb128 .LVU22
	.uleb128 .LVU22
	.uleb128 0
.LLST3:
	.byte	0x4
	.uleb128 .LVL5-.Ltext0
	.uleb128 .LVL6-1-.Ltext0
	.uleb128 0x1
	.byte	0x50
	.byte	0x4
	.uleb128 .LVL6-1-.Ltext0
	.uleb128 .LVL9-.Ltext0
	.uleb128 0x1
	.byte	0x54
	.byte	0x4
	.uleb128 .LVL9-.Ltext0
	.uleb128 .LFE8-.Ltext0
	.uleb128 0x8
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x70
	.sleb128 0
	.byte	0x22
	.byte	0x23
	.uleb128 0x18
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
	.section	.debug_line_str,"dr"
.LASF1:
	.ascii "/tmp/go-build\0"
.LASF0:
	.ascii "curve.cgo2.c\0"
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	_cgo_topofstack;	.scl	2;	.type	32;	.endef
	.def	secp256k1_ext_scalar_mul;	.scl	2;	.type	32;	.endef
