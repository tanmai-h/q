#include <GL/glut.h>
#include <stdio.h>

#define sq(a) (a)*(a)

int x1, y1, x2, y2;

void myInit() {
	glClear(GL_COLOR_BUFFER_BIT);
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glMatrixMode(GL_PROJECTION);
	gluOrtho2D(-500, 500, -500, 500);
}

void draw_pixel(int x, int y) {
	glBegin(GL_POINTS);
		glVertex2i(x, y);
	glEnd();
}

void bresenham(int x1, int x2, int y1, int y2) {
    int dy = y2-y1, dx = x2-x1;
    float m = dy/dx;
    dx = abs(dx); dy = (abs(dy));

    int incx = (x2 < x1) ? -1 : 1;
    int incy = (y2 < y1) ? -1 : 1;

    if(m < 1) {
        draw_pixel(x1,y1);
        int pk = 2*dy - dx;
        for (int i = 0; i < dx; i++) {
            if (pk < 0) {
                pk = pk + 2*dy;

            }
            else if(pk >= 0) {
                pk = pk + 2*dy - 2*dx;
                y1 += incy;
            }
            x1 += incx;
            draw_pixel(x1,y1);
        }
    }
    else {
        draw_pixel(x1,y1);
        int pk = 2*dx - dy;
        for (int i = 0; i < dy; i++) {
            if (pk < 0) {
                pk = pk + 2*dx;
            }
            else {
                pk = pk + 2*dx - 2*dy;
                x1 += incx;
            }
            y1 += incy;
            draw_pixel(x1,y1);
        }
    }
}

void mpline(int x1, int x2, int y1, int y2) {
	int dx = x2-x1, dy = y2-y1;
	dx = abs(dx); dy = abs(dy);

	int d = dy - dx/2;
	int incx = (x2>x1) ? 1 : -1, incy = (y2>y1) ? 1 : -1;

	for(int i = 0; i < dx; i++) {
		x1 += incx;
		if (d < 0) 
			d = d + dy;
		else if(d >= 0) 
			d = d + dy - dx;
			y1 += incy;
		draw_pixel(x1,y1);
	}

}

void mpcircle(int a, int b, int r) {
	int x = 0, y = r;
	draw_pixel(0,0);
	float pk = 5/4 - r;
	draw_pixel(x+a,y+b);
	printf("%d %d\n", x, y);
	while (y > x) {
		if (pk < 0) 
			pk = pk + 2*x +1;
		else if(pk >=0) {
			pk = pk + 2*(x-y) + 1;
			y--;
		}
		x++;
		printf("%d %d\n", x, y);
		if (x>y) break;
		draw_pixel(x+a,y+b);
		draw_pixel(-x+a,y+b);	
		draw_pixel(x+a,-y+b);
		draw_pixel(-x+a,-y+b);
		
		draw_pixel(y+a,x+b);
		draw_pixel(-y+a,x+b);
		draw_pixel(y+a,-x+b);
		draw_pixel(-y+a,-x+b);
	}
}
void circle2(int a, int b, int r) {
	float e = 3, s = 5-2*r;
	int x = 0, y = r;
	float pk = 5.0/4 - r;
	while(y>x) {
		if (pk < 0) {
			pk += e;
			e += 2;
			s += 2;
		}
		else {
			y--;
			pk += s;
			e += 2;
			s += 4;
		}
		x++;
		draw_pixel(x+a,y+b);
		draw_pixel(-x+a,y+b);	
		draw_pixel(x+a,-y+b);
		draw_pixel(-x+a,-y+b);
		
		draw_pixel(y+a,x+b);
		draw_pixel(-y+a,x+b);
		draw_pixel(y+a,-x+b);
		draw_pixel(-y+a,-x+b);
	}
}
void mpellipse(int a,int b) {
	double sa=a*a, sb=b*b;
	double x=0,y=b;
	double d1 = sb + 0.25*sa - sa*b;

	while (sa*(y-0.5) > sb*(x+1)) {
		if (d1 < 0)
			d1 += sb * (2*x + 3);
		else {
			d1 += sb * (2*x+3) + sa*(-2*y+2);
			y--;
		}
		x++;
		draw_pixel(x,y);
		draw_pixel(x,-y);
		draw_pixel(-x,y);
		draw_pixel(-x,-y);
	}
	double d2 = sb*sq(x+0.5) + sa*sq(y-1) - sa*sb;
	while(y>0) {
		if(d2<0) {
			d2 += sb*(2*x+2) + sa*(-2*y+3);
			x++;
		}
		else {
			d2 += sa*(-2*y+3);
		}
		y--;
		draw_pixel(x,y);
		draw_pixel(x,-y);
		draw_pixel(-x,y);
		draw_pixel(-x,-y);
	}
}

float  xmin = -100, xmax=100,ymin=-100,ymax=100;

void myDisplay();
int code(int x,int y) {
	int c=0;
	if (x<xmin) c |= 1;
	if (x > xmax) c |= 2;
	if(y < ymin) c |= 4;
	if(y > ymax) c |= 8;

	return c;
}

void clip() {
	int c1 = code(x1,y1), c2 = code(x2,y2);
	float m = (float)(y2-y1) / (x2-x1);
	int x,y;
	printf("%d %d - codes", c1, c2);
	while((c1|c2) > 0) {  // while not fully inside
		printf("here\n");
		if ((c1&c2) != 0) exit(0);
		int c = (c1 != 0) ? c1 : c2;
		float xi=x1,yi=y1;
		if(c==0) {
			xi=x2; yi=y2;
		}
		if(c & 8) {
			y = ymax;
			x = xi + 1.0*(y-yi)/m;
		}
		else if (c & 4) {
			y = ymin;
			x = xi + 1.0*(y-yi)/m;
		}
		else if(c & 2) {
			x = xmax;
			y = yi + 1.0*m*(x-xi);
		}
		else {
			x = xmin;
			y = yi + 1.0*m*(x-xi);
		}

		if(c == c1) {
			x1 = x; y1 = y;
			c1 = code(x,y);
		}
		else {
			x2 = x; y2 = y;
			c2 = code(x,y);
		}
	}
	printf("enddd");
	myDisplay();
}

void mykey(unsigned char key,int x,int y) {
    if(key=='c') {
        // clip(x1,y1,x2,y2);
		clip();
        glFlush();
    }
}

void myDisplay() {
	printf("%d %d %d %d \n",x1,y1,x2,y2);
	// mpline(x1, x2, y1, y2);
	// mpline(0,0,100,200);
	// mpcircle(x1,y1,x2);
	// circle2(x1,y1,x2);
	// mpellipse(x1,y1);
	// glBegin(GL_LINE_LOOP);
	// 	glVertex2i(xmin,ymin);
	// 	glVertex2i(xmin,ymax);
	// 	glVertex2i(xmax,ymax);
	// 	glVertex2i(xmax,ymin);
	// glEnd();
	// glBegin(GL_LINES);
	// 	glVertex2i(x1,y1);
	// 	glVertex2i(x2,y2);
	// glEnd();
	//mpellipse(x2,y2,x1,y1);
	
	glFlush();
}

int main(int argc, char **argv) {

	// printf( "Enter (x1, y1, x2, y2)\n");
	// scanf("%d %d %d %d", &x1, &y1, &x2, &y2);
	scanf("%d%d%d%d", &x1,&y1,&x2,&y2);
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_SINGLE|GLUT_RGB);
	glutInitWindowSize(500, 500);
	glutInitWindowPosition(0, 0);
	glutCreateWindow("Bresenham's Line Drawing");
	myInit();
	// clip();
	glutDisplayFunc(myDisplay);
	glutKeyboardFunc(mykey);
	glutMainLoop();
}
