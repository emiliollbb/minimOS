/*
 * PPM font viewer for minimOS bitmaps *
 * when converted to 4px width         *
 * (C) 2020 Carlos J. Santisteban      *
 * Last modified: 20201023-1340        *
 */

#include <stdio.h>
#include <string.h>

int main(void) {
	FILE *font, *ppm;			// file handlers
	char name[100];				// filename
	unsigned char mat[16][16][16];	// matrix for row, column, scanline
	unsigned char c, x, d, mask;	// no longer unsigned char?
	int i, j, k, z;
	int y;						// scanlines per char, assume 8-bit width

// select input file
	printf("Font bitmap? ");
	fgets(name, 100, stdin);
	printf("Scanlines? (max. 16) ");
	scanf(" %d", &y);
// why should I put the terminator on the read string?
	i=0;
	while (name[i]!='\n' && name[i]!='\0')	{i++;}
	name[i]=0;					// filename is ready
	printf("Opening %s font bitmap...\n", name);
	font=fopen(name, "rb");		// binary mode!
	if (font==NULL) {			// error handling
		printf("Could not open font bitmap!\n");
	} else {
// open output file
		strcat(name,".ppm");
		ppm=fopen(name, "w");
		if (ppm==NULL) {		// error handling
			printf("Cannot output picture!\n");
		} else {
// proceed! first read whole font in matrix
			i = j = 0;			// reset row and column counters
			while (!feof(font) && i<16) {
				for (k=0; k<y; k++) {
					mat[i][j][k]=fgetc(font);	// read byte into matrix
				}
				if ((++j) == 16) {				// column wrap
					j=0;
					++i;
				}
			}
			printf("All read! (%d)\n", y);
			fclose(font);
// create PPM header, in ASCII mode
			fprintf(ppm, "P3\n132 %d\n1\n", y*16);
// then create picture from matrix contents
			for(i=0; i<16; i++) {
				for (k=0; k<y; k++) {		// first scanline, then column
					fprintf(ppm, "1 1 1 1 1 1\n\n");	// 2px white at left
					for (j=0; j<16; j++) {
						d = 6;
						for (mask=192; mask>0; mask>>=2) {
							x = mask & mat[i][j][k];
							switch(x>>d) {
								case 0: fprintf(ppm, "0 0 0 0 0 0  "); break;	// black
								case 1: fprintf(ppm, "0 1 0 0 1 0  "); break;	// green
								case 2: fprintf(ppm, "1 0 0 1 0 0  "); break;	// red
								case 3: fprintf(ppm, "1 1 0 1 1 0  "); break;	// yellow
								default: printf("*** ERROR ***");
							}
							d -= 2;
						}
						fprintf (ppm, "\n");
					}
					fprintf(ppm, "1 1 1 1 1 1\n\n");	// 2px white at right
				}
				fprintf(ppm, "\n");
			}
// clean up
			fclose(ppm);
			printf("Success!\n");
		}
	}

	return 0;
}
