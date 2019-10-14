/*	24-bit dithering for 8-bit SIXtation palette
 *	(c) 2019 Carlos J. Santisteban
 *	last modified 20191014-2226 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* global variables */
unsigned char levR[7]={18, 55, 91, 128, 164, 200, 237};
unsigned char levG[8]={16, 48, 80, 112, 143, 175, 207, 239};
unsigned char levB[4]={32, 96, 159, 223};

/***********************/
/* auxiliary functions */
/***********************/
long coord(int x, int y, int sx) {
/* compute offset from coordinates */
	return (long)sx*y+x;
}

unsigned char palR(int i) {
/* get red value from standard palette */
	if (i>31) {				/* user-defined colours */
		return levR[((i&224)>>5)-1];
	} else if (i<16) {			/* system colours */
		return (i&4)?255:0;
	} else {				/* system grayscale */
		return (i-15)*15;
	}
}

unsigned char palG(int i) {
/* get green value from standard palette */
	if (i>31) {				/* user-defined colours */
		return levG[(i&15)>>1];
	} else if (i<16) {			/* system colours */
		return (((i&8)>>2)|((i&2)>>1))*85;
	} else {				/* system grayscale */
		return (i-15)*15;
	}
}

unsigned char palB(int i) {
/* get blue value from standard palette */
	if (i>31) {				/* user-defined colours */
		return levB[((i&16)>>3)|(i&1)];
	} else if (i<16) {			/* system colours */
		return (i&1)?255:0;
	} else {				/* system grayscale */
		return (i-15)*15;
	}
}

/****************/
/* main program */
/****************/
int main(void) {
	char nombre[80];			/* string for filenames, plus read buffer */
	char *pt;				/* temporary pointer */
	unsigned char *R, *G, *B, *I;		/* pointers to dynamically allocated buffers */
	unsigned char r, g, b, i;		/* pixel values and index */
	char dr, dg, db;			/* error diffusion variables */
	int sx, sy, x, y;			/* coordinates and limits */
	long xy;
	FILE *fi, *fo;				/* file handlers */

/* get input file */
	printf("PPM file? ");			/* get input filename */
	fgets(nombre, 80, stdin);		/* no longer scanf! */
	fi=fopen(nombre, "r");			/* open input file */
	if (fi==NULL) {
		printf("NO FILE!\n");			/* error handling */
//		return -1;
	}

/* swap extension on filename */
	pt=strstr(nombre, ".ppm");		/* temporary pointer use */
	if (pt==NULL) {				/* extension not found? */
		pt=strstr(nombre, ".PPM");		/* perhaps in uppercase */
		if (pt==NULL) {
			printf("WRONG TYPE!\n");
			return -1;
		}
	}
	*pt='\0';				/* cut extension off */
	strcat(nombre, ".six");			/* create output filename */
	printf("Output file:%s\n", nombre);

/* prepare output file*/
	fo=fopen(nombre, "wb");			/* open output file */
	if (fo==NULL) {
		printf("CANNOT OUTPUT!\n");	/* error handling */
		return -1;
	}

/* start reading PPM in order to determine size */
sx=1;//360;	/* placeholders */
sy=1;//768;

/* allocate buffer space */
	R=(unsigned char*)malloc(sx*sy);
	G=(unsigned char*)malloc(sx*sy);
	B=(unsigned char*)malloc(sx*sy);
	I=(unsigned char*)malloc(sx*sy);	/* indexed output */
	if(R==NULL||G==NULL||G==NULL||I==NULL) {
		printf("OUT OF MEMORY!\n");
		return -1;
	}

/* expected format:
P3
#comments after pound sign
#P3 means ASCII pixmap
#width and height in pixels
1360 768
#max value
255
#actual data follows, no more than 76 chars per line
#triplet order is R G B
#whitespace is ignored
*/

/* scan original file for error diffusion */
	pt=0;					/* base offset */
	for (y=0;y<sy;y++) {
		for (x=0;x<sx;x++) {
			xy=coord(x,y,sx);			/* current pixel */
			r=R[xy];				/* component values */
			g=G[xy];
			b=B[xy];
/* seek nearest colour */
i=31;/*placeholder*/
			I[xy]=i;				/* set indexed pixel */
			/* might be pushed directly into output file as well */
/* compute error per channel */
			dr=r-palR(i);
			dg=g-palG(i);
			db=b-palB(i);
/* diffuse error */
			
		}
	}

/* cleanup and exit */
	fclose(fi);
	fclose(fo);
/* THIS FOR DEBUGGING */
	if(R==NULL||G==NULL||G==NULL||I==NULL) {
		printf("OUT OF MEMORY!\n");
		return -1;
	}
/* release memory */
	free(R);
	free(G);
	free(B);
	free(I);

	return 0;
}
