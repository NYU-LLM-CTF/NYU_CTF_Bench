	.text
	.file	"main.cpp"
	.section	.text.startup,"ax",@progbits
	.p2align	4, 0x90         # -- Begin function __cxx_global_var_init
	.type	__cxx_global_var_init,@function
__cxx_global_var_init:                  # @__cxx_global_var_init
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movabsq	$_ZStL8__ioinit, %rdi
	callq	_ZNSt8ios_base4InitC1Ev
	movabsq	$_ZNSt8ios_base4InitD1Ev, %rax
	movq	%rax, %rdi
	movabsq	$_ZStL8__ioinit, %rsi
	movabsq	$__dso_handle, %rdx
	callq	__cxa_atexit
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	__cxx_global_var_init, .Lfunc_end0-__cxx_global_var_init
	.cfi_endproc
                                        # -- End function
	.text
	.globl	_Z4initv                # -- Begin function _Z4initv
	.p2align	4, 0x90
	.type	_Z4initv,@function
_Z4initv:                               # @_Z4initv
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	xorl	%eax, %eax
	movl	%eax, %esi
	movq	stdin, %rdi
	callq	setbuf
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	_Z4initv, .Lfunc_end1-_Z4initv
	.cfi_endproc
                                        # -- End function
	.globl	_Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE # -- Begin function _Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.p2align	4, 0x90
	.type	_Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE,@function
_Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE: # @_Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$224, %rsp
	movabsq	$.L__const._Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE.hm, %rax
	movq	%rdi, -8(%rbp)
	leaq	-192(%rbp), %rcx
	movq	%rcx, %rdi
	movq	%rax, %rsi
	movl	$172, %edx
	callq	memcpy
	movl	$1, -196(%rbp)
	movl	$0, -200(%rbp)
.LBB2_1:                                # =>This Inner Loop Header: Depth=1
    .byte 0xeb,0xff,0xc0
	movslq	-200(%rbp), %rax
	movq	-8(%rbp), %rdi
	movq	%rax, -208(%rbp)        # 8-byte Spill
	callq	_ZNKSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6lengthEv
	movq	-208(%rbp), %rcx        # 8-byte Reload
	cmpq	%rax, %rcx
	jae	.LBB2_6
# %bb.2:                                #   in Loop: Header=BB2_1 Depth=1
	movl	-200(%rbp), %eax
	movq	-8(%rbp), %rdi
	movslq	-200(%rbp), %rsi
	movl	%eax, -212(%rbp)        # 4-byte Spill
	callq	_ZNKSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEixEm
	movsbl	(%rax), %ecx

    movq $0x04ebc03140ec8348, %rax #31 c0   xor eax, eax (useless)
    .byte 0xeb,0xf5     #jmp -11
    movq $0x06ebffffff2c958b, %rax #8B 95 2C FF FF FF   mov edx, [rbp+var_D4]
    movq $0x02ebca31da31c231, %rax #31 CA   xor edx, ecx
    movq $0x02ebffffff389503, %rax #03 95 38 FF FF FF   add edx, [rbp+var_C8]
    movq $0x05ebffffff388d8b, %rax #mov ecx, [rbp-0xc8]
    movq $0x03ebc16348c0ff48, %rax #movsxd rax, ecx
    .byte 0xc3,0xc0,0x31 #3 bytes are skipped so does nothing

	#movl	-212(%rbp), %edx        # 4-byte Reload
	#xorl	%ecx, %edx
	#addl	-200(%rbp), %edx
	#movslq	-200(%rbp), %rax
	cmpl	-192(%rbp,%rax,4), %edx
	je	.LBB2_4
# %bb.3:                                #   in Loop: Header=BB2_1 Depth=1
	movl	$0, -196(%rbp)
.LBB2_4:                                #   in Loop: Header=BB2_1 Depth=1
	jmp	.LBB2_5
.LBB2_5:                                #   in Loop: Header=BB2_1 Depth=1
	movl	-200(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -200(%rbp)
	jmp	.LBB2_1
.LBB2_6:
	movl	-196(%rbp), %eax
	addq	$224, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end2:
	.size	_Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE, .Lfunc_end2-_Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.cfi_endproc
                                        # -- End function
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
.Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 3, __gxx_personality_v0
	.cfi_lsda 3, .Lexception0
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$80, %rsp
	movl	$0, -4(%rbp)
	callq	_Z4initv
	leaq	-40(%rbp), %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEC1Ev
.Ltmp0:
	movl	$_ZSt4cout, %edi
	movl	$.L.str, %esi
	callq	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.Ltmp1:
	movq	%rax, -64(%rbp)         # 8-byte Spill
	jmp	.LBB3_1
.LBB3_1:
.Ltmp2:
	movl	$_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_, %esi
	movq	-64(%rbp), %rdi         # 8-byte Reload
	callq	_ZNSolsEPFRSoS_E
.Ltmp3:
	jmp	.LBB3_2
.LBB3_2:
.Ltmp4:
	movl	$_ZSt3cin, %edi
	leaq	-40(%rbp), %rsi
	callq	_ZStrsIcSt11char_traitsIcESaIcEERSt13basic_istreamIT_T0_ES7_RNSt7__cxx1112basic_stringIS4_S5_T1_EE
.Ltmp5:
	jmp	.LBB3_3
.LBB3_3:
.Ltmp6:
	leaq	-40(%rbp), %rdi
	callq	_Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
.Ltmp7:
	movl	%eax, -68(%rbp)         # 4-byte Spill
	jmp	.LBB3_4
.LBB3_4:
	movl	-68(%rbp), %eax         # 4-byte Reload
	cmpl	$0, %eax
	je	.LBB3_9
# %bb.5:
.Ltmp8:
	movl	$_ZSt4cout, %edi
	movl	$.L.str.1, %esi
	callq	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.Ltmp9:
	movq	%rax, -80(%rbp)         # 8-byte Spill
	jmp	.LBB3_6
.LBB3_6:
.Ltmp10:
	movl	$_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_, %esi
	movq	-80(%rbp), %rdi         # 8-byte Reload
	callq	_ZNSolsEPFRSoS_E
.Ltmp11:
	jmp	.LBB3_7
.LBB3_7:
	jmp	.LBB3_9
.LBB3_8:
.Ltmp12:
                                        # kill: def $edx killed $edx killed $rdx
	movq	%rax, -48(%rbp)
	movl	%edx, -52(%rbp)
	leaq	-40(%rbp), %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED1Ev
	jmp	.LBB3_10
.LBB3_9:
	movl	$0, -4(%rbp)
	leaq	-40(%rbp), %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED1Ev
	movl	-4(%rbp), %eax
	addq	$80, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.LBB3_10:
	.cfi_def_cfa %rbp, 16
	movq	-48(%rbp), %rdi
	callq	_Unwind_Resume
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
	.cfi_endproc
	.section	.gcc_except_table,"a",@progbits
	.p2align	2
GCC_except_table3:
.Lexception0:
	.byte	255                     # @LPStart Encoding = omit
	.byte	255                     # @TType Encoding = omit
	.byte	1                       # Call site Encoding = uleb128
	.uleb128 .Lcst_end0-.Lcst_begin0
.Lcst_begin0:
	.uleb128 .Ltmp0-.Lfunc_begin0   # >> Call Site 1 <<
	.uleb128 .Ltmp11-.Ltmp0         #   Call between .Ltmp0 and .Ltmp11
	.uleb128 .Ltmp12-.Lfunc_begin0  #     jumps to .Ltmp12
	.byte	0                       #   On action: cleanup
	.uleb128 .Ltmp11-.Lfunc_begin0  # >> Call Site 2 <<
	.uleb128 .Lfunc_end3-.Ltmp11    #   Call between .Ltmp11 and .Lfunc_end3
	.byte	0                       #     has no landing pad
	.byte	0                       #   On action: cleanup
.Lcst_end0:
	.p2align	2
                                        # -- End function
	.section	.text.startup,"ax",@progbits
	.p2align	4, 0x90         # -- Begin function _GLOBAL__sub_I_main.cpp
	.type	_GLOBAL__sub_I_main.cpp,@function
_GLOBAL__sub_I_main.cpp:                # @_GLOBAL__sub_I_main.cpp
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	callq	__cxx_global_var_init
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end4:
	.size	_GLOBAL__sub_I_main.cpp, .Lfunc_end4-_GLOBAL__sub_I_main.cpp
	.cfi_endproc
                                        # -- End function
	.type	_ZStL8__ioinit,@object  # @_ZStL8__ioinit
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.hidden	__dso_handle
	.type	.L__const._Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE.hm,@object # @__const._Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE.hm
	.section	.rodata,"a",@progbits
	.p2align	4
.L__const._Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE.hm:
	.long	102                     # 0x66
	.long	110                     # 0x6e
	.long	101                     # 0x65
	.long	103                     # 0x67
	.long	131                     # 0x83
	.long	114                     # 0x72
	.long	59                      # 0x3b
	.long	114                     # 0x72
	.long	128                     # 0x80
	.long	95                      # 0x5f
	.long	69                      # 0x45
	.long	113                     # 0x71
	.long	95                      # 0x5f
	.long	134                     # 0x86
	.long	138                     # 0x8a
	.long	74                      # 0x4a
	.long	112                     # 0x70
	.long	114                     # 0x72
	.long	51                      # 0x33
	.long	138                     # 0x8a
	.long	95                      # 0x5f
	.long	57                      # 0x39
	.long	142                     # 0x8e
	.long	95                      # 0x5f
	.long	130                     # 0x82
	.long	70                      # 0x46
	.long	132                     # 0x84
	.long	134                     # 0x86
	.long	75                      # 0x4b
	.long	150                     # 0x96
	.long	95                      # 0x5f
	.long	77                      # 0x4d
	.long	110                     # 0x6e
	.long	159                     # 0x9f
	.long	56                      # 0x38
	.long	58                      # 0x3a
	.long	52                      # 0x34
	.long	54                      # 0x36
	.long	56                      # 0x38
	.long	58                      # 0x3a
	.long	68                      # 0x44
	.long	70                      # 0x46
	.long	129                     # 0x81
	.size	.L__const._Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE.hm, 172

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"help me"
	.size	.L.str, 8

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"you found me!"
	.size	.L.str.1, 14

	.section	.init_array,"aw",@init_array
	.p2align	3
	.quad	_GLOBAL__sub_I_main.cpp

	.ident	"clang version 9.0.0-2~ubuntu18.04.2 (tags/RELEASE_900/final)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __cxx_global_var_init
	.addrsig_sym __cxa_atexit
	.addrsig_sym _Z4initv
	.addrsig_sym setbuf
	.addrsig_sym _Z5checkRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.addrsig_sym _ZNKSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6lengthEv
	.addrsig_sym _ZNKSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEixEm
	.addrsig_sym _ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	.addrsig_sym __gxx_personality_v0
	.addrsig_sym _ZNSolsEPFRSoS_E
	.addrsig_sym _ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_
	.addrsig_sym _ZStrsIcSt11char_traitsIcESaIcEERSt13basic_istreamIT_T0_ES7_RNSt7__cxx1112basic_stringIS4_S5_T1_EE
	.addrsig_sym _GLOBAL__sub_I_main.cpp
	.addrsig_sym _Unwind_Resume
	.addrsig_sym _ZStL8__ioinit
	.addrsig_sym __dso_handle
	.addrsig_sym stdin
	.addrsig_sym _ZSt4cout
	.addrsig_sym _ZSt3cin
