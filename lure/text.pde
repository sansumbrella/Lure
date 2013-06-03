
class Marquee
{
  int x, y;
  int xOff = 0;
  PFont font;
  String txt = "";
  Marquee( int _centerX, int _baseline )
  {
    x = _centerX;
    y = _baseline;
    font = createFont("Lucida Handwriting", 24);
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
    fill( 255, 255, 150 );
    noStroke();
    text( txt, x + xOff, y );
  }
}
