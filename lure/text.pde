// we need to give the player some information
class Marquee
{
  int x, y;
  int yOff = 8;
  int xOff = 0;
  PFont font;
  String txt = "";
  Marquee( int _centerX, int _baseline )
  {
    x = _centerX;
    y = _baseline;
    font = createFont("Lucida Handwriting", 36);
  }

  void display( String text )
  {
    txt = text;
    textFont( font );
    xOff = floor( -textWidth( txt ) / 2 );
  }

  void draw()
  {
    textFont( font );
    noStroke();

    pushMatrix();
    translate( x + xOff, y - yOff );

    fill( 255, 255, 150 );
    text( txt, 0, 0 );

    translate( 0, 2 * yOff );
    scale( 1, -0.5 );
    fill( 100, 100, 75 );
    text( txt, 0, 0 );
    popMatrix();
  }
}

