/*   sharp_testbench_5pix.c
 *   2-dimensional sharp filter using 3x3 kernel
 *      calculation with fixed point values
 *      shift output by one pixel down and right to match hardware implementation
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "bmp24_io.c"

void main(argc,argv)
int argc;
char *argv[];
{
char  f_name[100];
int   x,y;
long  pixel_lt,pixel_ct,pixel_rt;
long  pixel_lc,pixel_cc,pixel_rc;
long  pixel_lb,pixel_cb,pixel_rb;
long  **image_in;
int   y_size, x_size;
long  **image_out;
long  pixel;
long  r, g, b;
FILE  *f_stimuli, *f_expected;


if (argc != 2)
  {
  printf("USAGE: %s <input file base>\n",argv[0]);
  exit(1);
  }

printf("Sobel-Filter 8-bit\n");
printf("==================\n\n");

sprintf(f_name ,"%s.bmp",argv[1]);
bmp24_open(f_name,&image_in,&x_size,&y_size);

bmp24_alloc(&image_out,x_size,y_size);

    for (y=0;y<y_size;y++)
      for (x=0;x<x_size;x++)
        {
        pixel_lt = bmp24_get(image_in,x-1,y-1,x_size,y_size); /* left   top  */
        pixel_ct = bmp24_get(image_in,x  ,y-1,x_size,y_size); /* center top  */
        pixel_rt = bmp24_get(image_in,x+1,y-1,x_size,y_size); /* right  top  */
        pixel_lc = bmp24_get(image_in,x-1,y  ,x_size,y_size); /* left   center  */
		pixel_cc = bmp24_get(image_in,x  ,y  ,x_size,y_size); /* center center  */
        pixel_rc = bmp24_get(image_in,x+1,y  ,x_size,y_size); /* right  center  */
        pixel_lb = bmp24_get(image_in,x-1,y+1,x_size,y_size); /* left   bottom  */
        pixel_cb = bmp24_get(image_in,x  ,y+1,x_size,y_size); /* center bottom  */
        pixel_rb = bmp24_get(image_in,x+1,y+1,x_size,y_size); /* right  bottom  */

		r = 0;
		g = 0;
		b = 0;
		
		r += -1*bmp24_r(pixel_lt);
		g += -1*bmp24_g(pixel_lt);
		b += -1*bmp24_b(pixel_lt);
		
		r += -1*bmp24_r(pixel_ct);
		g += -1*bmp24_g(pixel_ct);
		b += -1*bmp24_b(pixel_ct);
		
		r += -1*bmp24_r(pixel_rt);
		g += -1*bmp24_g(pixel_rt);
		b += -1*bmp24_b(pixel_rt);
		
		r += -1*bmp24_r(pixel_lc);
		g += -1*bmp24_g(pixel_lc);
		b += -1*bmp24_b(pixel_lc);
		
		r += 9*bmp24_r(pixel_cc);
		g += 9*bmp24_g(pixel_cc);
		b += 9*bmp24_b(pixel_cc);

		r += -1*bmp24_r(pixel_rc);
		g += -1*bmp24_g(pixel_rc);
		b += -1*bmp24_b(pixel_rc);
		
		r += -1*bmp24_r(pixel_lb);
		g += -1*bmp24_g(pixel_lb);
		b += -1*bmp24_b(pixel_lb);
		
		r += -1*bmp24_r(pixel_cb);
		g += -1*bmp24_g(pixel_cb);
		b += -1*bmp24_b(pixel_cb);
		
		r += -1*bmp24_r(pixel_rb);
		g += -1*bmp24_g(pixel_rb);
		b += -1*bmp24_b(pixel_rb);
		
		r = (r < 0 ? 0 : (r > 255 ? 255 : r));
		g = (g < 0 ? 0 : (g > 255 ? 255 : g));
		b = (b < 0 ? 0 : (b > 255 ? 255 : b));

        bmp24_put(image_out,r,g,b,x,y,x_size,y_size);
        }

sprintf(f_name ,"%s_sharp_9pix.bmp",argv[1]);
bmp24_close(f_name,image_out,x_size,y_size);


printf("Generating testbench data\n");
/* stimuli data */
sprintf(f_name ,"%s_stimuli.txt",argv[1]);
f_stimuli = fopen(f_name,"w");
if (f_stimuli==NULL)
    {
    printf("\n\nERROR: File %s can not be written\n",f_name);
    exit(0);
    }

fprintf(f_stimuli,"# %s - RGB pixel in hex\n",f_name);
    for (y=0;y<y_size;y++)
      for (x=0;x<x_size;x++)
        {
        pixel = bmp24_get(image_in,x,y,x_size,y_size);
        r = bmp24_r(pixel);
        g = bmp24_g(pixel);
        b = bmp24_b(pixel);
        fprintf(f_stimuli,"%02X %02X %02X\n",r,g,b);
        }
fclose(f_stimuli);

/* expected data */
sprintf(f_name ,"%s_expected.txt",argv[1]);
f_expected = fopen(f_name,"w");
if (f_expected==NULL)
    {
    printf("\n\nERROR: File %s can not be written\n",f_name);
    exit(0);
    }

fprintf(f_expected,"# %s - RGB pixel in hex\n",f_name);
    for (y=0;y<y_size;y++)
      for (x=0;x<x_size;x++)
        {
        /* impossible result for border region: different values for RGB  */
        if (x<2) pixel = 0x55AAEE;  else
        if (y<2) pixel = 0x55AAEE;  else
            pixel = bmp24_get(image_out,x-1,y-1,x_size,y_size);
        r = bmp24_r(pixel);
        g = bmp24_g(pixel);
        b = bmp24_b(pixel);
        fprintf(f_expected,"%02X %02X %02X\n",r,g,b);
        }
fclose(f_expected);


printf("OK ...\n");
}
