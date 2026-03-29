format ELF64 executable 3
entry _start

include "sysconsts.inc"

segment executable readable

printfile:
	mov eax, 2
	xor esi, esi
	syscall

	test eax, eax
	js short printfile.open_err

	push rax
	mov edi, 1
	mov esi, eax
	xor edx, edx
	mov r10d, 4096

	.printloop:
		mov eax, 40
		syscall

		test eax, eax
		jg short printfile.printloop

	pop rax
	mov edi, eax
	mov eax, 3
	syscall

	ret

	.open_err:
		mov eax, -1
		ret

_start:
	mov r12d, [rsp]
	shl r12d, 3

	cmp r12d, 8
	je _start.print_stdin

	mov ebx, 16
	.print_args:
		mov rdi, [rsp + rbx]
		call printfile

		test eax, eax
		sets dil
		js exit

		add ebx, 8
		cmp ebx, r12d

		jle _start.print_args
		xor edi, edi
		jmp exit

	.print_stdin:
		sub rsp, SIZEOF_STRUCT_TERMIOS
		mov eax, 16
		xor edi, edi
		mov esi, TCGETS
		mov rdx, rsp
		syscall
		add rsp, SIZEOF_STRUCT_TERMIOS

		test eax, eax
		jns .tty_fd

	.piped_fd:
		mov eax, 275
		xor edi, edi
		xor esi, esi
		mov edx, 1
		xor r10d, r10d
		mov r8d, 4096
		syscall

		test eax, eax
		sets dil

		js exit
		jnz _start.piped_fd
		jmp exit

	.tty_fd:
		mov rbp, rsp
		sub rsp, 4096

		.rw_loop:
			xor eax, eax
			xor edi, edi
			mov rsi, rsp
			mov edx, 4096
			syscall

			test eax, eax
			cmovs rsp, rbp
			sets dil
			js exit

			mov edx, eax
			mov eax, 1
			mov edi, 1
			mov rsi, rsp
			syscall

			cmp eax, edx
			jl partial_write

			.partial_write_ret:
			test eax, eax

			sets dil
			cmovs rsp, rbp
			js exit

			jnz _start.rw_loop

		mov rsp, rbp

	xor dil, dil
	jmp exit

partial_write:
	sub rdx, rax
	add rsi, rax
	mov eax, 1
	syscall
	jmp	_start.partial_write_ret

exit:
	movzx edi, dil
	mov eax, 60
	syscall
