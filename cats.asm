format ELF64 executable 3
entry _start

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

	mov ebx, 16

	.printargs:
		mov rdi, [rsp + rbx]
		call printfile

		test ax, ax
		js _start.printerr

		add ebx, 8
		cmp ebx, r12d
		jle short _start.printargs

	mov eax, 60
	xor edi, edi
	syscall

	.printerr:
		mov eax, 60
		mov edi, 1
		syscall
