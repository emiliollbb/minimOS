/* Pacman map viewer */
/* new compact format */
/* (c) 2021 Carlos J. Santisteban */

#include <stdio.h>

int main(void) {
	FILE	*f;
	int		x, y, z;
	int		c;

	f=fopen("a.o65","rb");
	if (f==NULL)	return -1;
	for (y=0;y<31;y++) {
		for (x=0; x<16; x++) {
			c=fgetc(f);
//			printf("%x",c);
			for (z=0; z<2; z++) {
				switch(c & 240) {
					case 128:			/* wall */
						printf("#");
						break;
					case 144:			/* base */
						printf("x");
						break;
					case 64:			/* dot */
						printf(".");
						break;
					case 32:			/* pill */
						printf("O");
						break;
					case 0:				/* empty */
						printf(" ");
						break;
					default:
						printf("?");
				}
				c <<= 4;
			}
		}
		printf("\n");
	}
	fclose(f);
	
	return 0;
}
