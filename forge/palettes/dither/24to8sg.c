#include <stdio.h>
#include <string.h>

/*	24-bit dithering for 8-bit SIXtation palette
 *	(c) 2019 Carlos J. Santisteban
 *	last modified 20191012-1655 */

int main(void) {
	char nombre[80];			/* string for filenames, plus read buffer */
	char *pt;				/* pointer to dynamically allocated output buffer */
	FILE *fi, *fo;				/* file handlers */

/* get input file */
	printf("PPM file? ");			/* get input filename */
	fgets(nombre, 80, stdin);		/* no longer scanf! */
	fi=fopen(nombre, "r");			/* open input file */
	if (fi==NULL) {
		printf("NO FILE!\n");		/* error handling */
		return -1;
	}

/* swap extension on filename */
	pt=strstr(nombre,".ppm");		/*** temporary pointer use ***/
	if (pt==NULL) {				/* extension not found? */
		pt=strstr(nombre,".PPM");		/* perhaps in uppercase */
		if (pt==NULL) {
			printf("WRONG TYPE!\n");
			return -1;
		}
	}
	*pt='\0';				/* cut extension off */
	strcat(nombre, ".six");			/* create output filename */
	printf("Output file:%s\n",nombre);

/* prepare output file*/
	fo=fopen(nombre, "wb");			/* open output file */
	if (fo==NULL) {
		printf("CANNOT OUTPUT!\n");	/* error handling */
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
	
/* neighbouring colours: (RRRBGGGB) NO LONGER VALID
R & %11100000 if >=%100000
| G>>4 & %1110
| B&%10000000 >>3
| B&%01000000 >>7
*/

/* new 894 palette: OBSOLETE, look for 895 instead!
 * R values = $12, 37, 5B, 80, A4, C8, ED
 * G values = $10, 30, 50, 70, 8F, AF, CF, EF
 * B values = $00, 55, AA, FF... or $20, 60, 9F, DF
*/

/* cleanup and exit */
	fclose(fi);
	fclose(fo);

	return 0;
}
