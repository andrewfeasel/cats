format ELF64 executable 3
entry _start

segment executable readable
_start:
	mov eax, 2
	mov rdi, [rsp + 16]
	xor esi, esi
	syscall

	test ax, ax
	js short _start.open_err
	mov ebx, eax

	.printloop:
		mov eax, 40
		mov edi, 1
		mov esi, ebx
		xor edx, edx
		mov r10d, 4096
		syscall

		test ax, ax
		jg short _start.printloop

	mov eax, 3
	mov edi, ebx
	syscall

	mov eax, 60
	xor edi, edi
	syscall

	.open_err:
		mov eax, 60
		mov edi, 1
		syscall
