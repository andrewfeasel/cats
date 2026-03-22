#include <stdio.h>
#include <sys/ioctl.h>
#include <termios.h>

#define INCFILE_PATH "src/sysconsts.inc"

int main(int argc, char **argv)
{
	FILE *incfile = fopen(INCFILE_PATH, "wb");
	if (incfile == NULL) {
		perror("fopen");
		goto open_err;
	}

	fprintf(incfile, "SIZEOF_STRUCT_TERMIOS equ %ld\n", sizeof(struct termios));
	fprintf(incfile, "TCGETS equ %ld\n", TCGETS);

	fclose(incfile);
	return 0;

	open_err:
		return 1;
}
