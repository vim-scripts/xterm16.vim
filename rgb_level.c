// Prints the rgb ramps with .2 rgbi increments, and the average ramp This ramp
// is used by mrxvt. rxvt uses a uniform rgb ramp, and xterm uses a shifted
// uniform ramp

#include <X11/Xlib.h>
#include <stdio.h>

#define min(x,y) (( (x) < (y) ) ? (x) : (y) )

/* void strcatn( size_t len, char *s, const char *t) {
 *     size_t c;
 * 
 *     len--;
 *     for( c=0; c < len && *s; c++, s++);
 *     for( ; c++ < len && *t; *s++ = *t++);
 *     *s=0;
 * } */

void catlevel( char *buffer, unsigned color);

int main() {
    Display *display;
    Colormap colormap;
    XColor color;
    char colorname[80], rlevel[80], glevel[80], blevel[80], alevel[80];
    int **rgb;
    int i;
    float level;

    // Get the default display and colormap
    display = XOpenDisplay( NULL);
    colormap = DefaultColormap( display, DefaultScreen( display));

    *rlevel = *glevel = *blevel = *alevel = 0;

    // lookup colors
    for( level=0.0; level <= 1.0; level += 0.2) {
	snprintf( colorname, 80, "rgbi:%.2f/%.2f/%.2f", level, level, level);
	if( !XParseColor( display, colormap, colorname, &color)) {
	    printf( "Coult not allocate color %s.\n", colorname);
	    return 1;
	}

	catlevel( rlevel, color.red);
	catlevel( glevel, color.green);
	catlevel( blevel, color.blue);
	catlevel( alevel, ((long) color.red + color.green + color.blue) / 3 );
    }

    printf("red:\t%s\ngreen:\t%s\nblue:\t%s\naverage:%s\n", rlevel, glevel, blevel, alevel);
    return 0;
}

void catlevel( char *buffer, unsigned color) {
    char tmp[80];

    snprintf( tmp, 80, " %02x", min( (color + 128L) / 256, 255));
    strncat( buffer, tmp, 80);
}
