	.file	"gcc_context.c"
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.file 0 "//_/_/GOROOT/src/runtime/cgo" "gcc_context.c"
	.p2align 4
	.globl	_cgo_release_context
	.def	_cgo_release_context;	.scl	2;	.type	32;	.endef
	.seh_proc	_cgo_release_context
_cgo_release_context:
.LVL0:
.LFB113:
	.file 1 "gcc_context.c"
	.loc 1 10 43 view -0
	.cfi_startproc
	.loc 1 10 43 is_stmt 0 view .LVU1
	pushq	%rbx
	.seh_pushreg	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$48, %rsp
	.seh_stackalloc	48
	.cfi_def_cfa_offset 64
	.seh_endprologue
	.loc 1 11 2 is_stmt 1 view .LVU2
	.loc 1 13 2 view .LVU3
	.loc 1 10 43 is_stmt 0 view .LVU4
	movq	%rcx, %rbx
	.loc 1 13 8 view .LVU5
	call	_cgo_get_context_function
.LVL1:
	.loc 1 14 2 is_stmt 1 view .LVU6
	.loc 1 14 5 is_stmt 0 view .LVU7
	testq	%rbx, %rbx
	je	.L1
	testq	%rax, %rax
	je	.L1
.LBB2:
	.loc 1 15 3 is_stmt 1 view .LVU8
	.loc 1 17 3 view .LVU9
	.loc 1 17 15 is_stmt 0 view .LVU10
	movq	%rbx, 40(%rsp)
	.loc 1 18 3 is_stmt 1 view .LVU11
	.loc 1 18 4 is_stmt 0 view .LVU12
	leaq	40(%rsp), %rcx
	call	*%rax
	nop
.LVL2:
.L1:
	.loc 1 18 4 view .LVU13
.LBE2:
	.loc 1 20 1 view .LVU14
	addq	$48, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 8
.LVL3:
	.loc 1 20 1 view .LVU15
	ret
	.cfi_endproc
.LFE113:
	.seh_endproc
.Letext0:
	.file 2 "C:/msys64/ucrt64/include/corecrt.h"
	.file 3 "libcgo.h"
	.section	.debug_info,"dr"
.Ldebug_info0:
	.long	0x1ff
	.word	0x5
	.byte	0x1
	.byte	0x8
	.secrel32	.Ldebug_abbrev0
	.uleb128 0x3
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
	.uleb128 0x4
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
	.uleb128 0x5
	.ascii "cgoContextArg\0"
	.byte	0x8
	.byte	0x3
	.byte	0x69
	.byte	0x8
	.long	0x134
	.uleb128 0x6
	.ascii "Context\0"
	.byte	0x3
	.byte	0x6a
	.byte	0xc
	.long	0x71
	.byte	0
	.byte	0
	.uleb128 0x7
	.long	0x13f
	.uleb128 0x8
	.long	0x13f
	.byte	0
	.uleb128 0x2
	.long	0x10b
	.uleb128 0x2
	.long	0x134
	.uleb128 0x9
	.ascii "_cgo_get_context_function\0"
	.byte	0x3
	.byte	0x6c
	.byte	0x10
	.long	0x144
	.uleb128 0xa
	.ascii "_cgo_release_context\0"
	.byte	0x1
	.byte	0xa
	.byte	0x6
	.quad	.LFB113
	.quad	.LFE113-.LFB113
	.uleb128 0x1
	.byte	0x9c
	.uleb128 0xb
	.ascii "ctxt\0"
	.byte	0x1
	.byte	0xa
	.byte	0x25
	.long	0x71
	.secrel32	.LLST0
	.secrel32	.LVUS0
	.uleb128 0xc
	.ascii "pfn\0"
	.byte	0x1
	.byte	0xb
	.byte	0x9
	.long	0x144
	.secrel32	.LLST1
	.secrel32	.LVUS1
	.uleb128 0xd
	.quad	.LBB2
	.quad	.LBE2-.LBB2
	.long	0x1f4
	.uleb128 0xe
	.ascii "arg\0"
	.byte	0x1
	.byte	0xf
	.byte	0x18
	.long	0x10b
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.uleb128 0xf
	.quad	.LVL2
	.uleb128 0x10
	.uleb128 0x1
	.byte	0x52
	.uleb128 0x2
	.byte	0x91
	.sleb128 -24
	.byte	0
	.byte	0
	.uleb128 0x11
	.quad	.LVL1
	.long	0x149
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
	.uleb128 0x4
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
	.uleb128 0x5
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
	.uleb128 0x6
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
	.uleb128 0x7
	.uleb128 0x15
	.byte	0x1
	.uleb128 0x27
	.uleb128 0x19
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x5
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x9
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
	.uleb128 0xb
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
	.uleb128 0xc
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
	.uleb128 0xd
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
	.uleb128 0xe
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
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x48
	.byte	0x1
	.uleb128 0x7d
	.uleb128 0x1
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x49
	.byte	0
	.uleb128 0x2
	.uleb128 0x18
	.uleb128 0x7e
	.uleb128 0x18
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x48
	.byte	0
	.uleb128 0x7d
	.uleb128 0x1
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
	.uleb128 .LVU6
	.uleb128 .LVU6
	.uleb128 .LVU15
	.uleb128 .LVU15
	.uleb128 0
.LLST0:
	.byte	0x4
	.uleb128 .LVL0-.Ltext0
	.uleb128 .LVL1-1-.Ltext0
	.uleb128 0x1
	.byte	0x52
	.byte	0x4
	.uleb128 .LVL1-1-.Ltext0
	.uleb128 .LVL3-.Ltext0
	.uleb128 0x1
	.byte	0x53
	.byte	0x4
	.uleb128 .LVL3-.Ltext0
	.uleb128 .LFE113-.Ltext0
	.uleb128 0x4
	.byte	0xa3
	.uleb128 0x1
	.byte	0x52
	.byte	0x9f
	.byte	0
.LVUS1:
	.uleb128 .LVU6
	.uleb128 .LVU13
.LLST1:
	.byte	0x4
	.uleb128 .LVL1-.Ltext0
	.uleb128 .LVL2-1-.Ltext0
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
	.section	.debug_line_str,"dr"
.LASF1:
	.ascii "\\\\_\\_\\GOROOT\\src\\runtime\\cgo\0"
.LASF0:
	.ascii "gcc_context.c\0"
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	_cgo_get_context_function;	.scl	2;	.type	32;	.endef
