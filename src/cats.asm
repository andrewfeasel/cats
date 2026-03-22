format ELF64 executable 3
entry _start

include "sysconsts.inc"

segment executable readable
printfile:
	mov eax, 2
	xor esi, esi
	syscall

	test ax, ax
	js short printfile.open_err
	push rbx
	mov ebx, eax

	.printloop:
		mov eax, 40
		mov edi, 1
		mov esi, ebx
		xor edx, edx
		mov r10d, 4096
		syscall

		test ax, ax
		jg short printfile.printloop

	mov eax, 3
	mov edi, ebx
	syscall

	pop rbx
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

		test ax, ax
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

		test ax, ax
		jns .tty_fd

		.piped_fd:
			mov eax, 275
			xor edi, edi
			xor esi, esi
			mov edx, 1
			xor r10d, r10d
			mov r8d, 4096
			xor r9d, r9d
			syscall

			test ax, ax
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

				test ax, ax
				js _start.exit_err

				mov edx, eax
				mov eax, 1
				mov edi, 1
				mov rsi, rsp
				syscall

				test ax, ax
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
