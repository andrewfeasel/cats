format ELF64 executable 3
entry _start

include "sysconsts.inc"

segment executable readable

printfile:
	mov eax, 2
	xor esi, esi
	syscall

	test rax, rax
	js short printfile.open_err

	push rax
	mov edi, 1
	mov esi, eax
	xor edx, edx
	mov r10d, 4096

	.printloop:
		mov eax, 40
		syscall

		test rax, rax
		jg short printfile.printloop

	pop rax
	mov rdi, rax
	mov eax, 3
	syscall

	ret

	.open_err:
		pop rbx
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

		test rax, rax
		js _start.exit_err

		add ebx, 8
		cmp ebx, r12d
		jle _start.print_args
		jmp _start.exit_ok

	.print_stdin:
		sub rsp, SIZEOF_STRUCT_TERMIOS
		mov eax, 16
		xor edi, edi
		mov esi, TCGETS
		mov rdx, rsp
		syscall
		add rsp, SIZEOF_STRUCT_TERMIOS

		test rax, rax
		jns .tty_fd

		.piped_fd:
			mov eax, 275
			xor edi, edi
			xor esi, esi
			mov edx, 1
			xor r10d, r10d
			mov r8d, 4096
			syscall

			test rax, rax
			js  _start.exit_err
			jnz _start.piped_fd
			jmp _start.exit_ok

		.tty_fd:
			sub rsp, 4096

			.rw_loop:
				xor eax, eax
				xor edi, edi
				mov rsi, rsp
				mov edx, 4096
				syscall

				test rax, rax
				js _start.exit_err

				mov edx, eax
				mov eax, 1
				mov edi, 1
				mov rsi, rsp
				syscall

				cmp eax, edx
				jl partial_write

				.partial_write_ret:
				test rax, rax
				js _start.exit_err
				jnz _start.rw_loop

			add rsp, 4096

	.exit_ok:
		mov eax, 60
		xor edi, edi
		syscall

	.exit_err:
		mov eax, 60
		mov edi, 1
		syscall

partial_write:
	sub rdx, rax
	add rsi, rax
	mov eax, 1
	syscall

	test rax, rax
	js _start.exit_err

	jmp	_start.partial_write_ret
