
Worm worm;

void setup()
{
  size( 640, 480 );
  worm = new Worm();
}

void draw()
{
  background( 30, 20, 40 );
  worm.draw();
}

class Worm
{
 float x, y;
 Worm()
 {
   x = width/2;
   y = height/2;
 }
 void draw()
 {
   fill( 255, 0, 0 );
   ellipse( x, y, 10, 10 );
 }
}
