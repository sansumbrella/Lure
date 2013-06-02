
Worm worm;
Mountain mountain;

void setup()
{
  size( 640, 480 );
  smooth();
  worm = new Worm();
  mountain = new Mountain();
}

void draw()
{
  background( 30, 20, 40 );
  worm.draw();
  mountain.draw();
  stroke( 0, 255, 255 );
  line( width * 0.25, height / 2, width * 0.75, height / 2 );
  line( width * 0.1, height / 2 + 3, width * 0.9, height / 2 + 3 );
  line( width * 0.01, height / 2 + 8, width * 0.99, height / 2 + 8 );
}

void keyPressed()
{
  switch( key )
  {
    case 'f':
      worm.flex( 0 );
    break;
    case 'j':
      worm.flex( 1 );
    break;
  }
}

class Node
{
  float x, y;
  Node( float _x, float _y )
  {
    x = _x;
    y = _y;
  }
}

class Spring
{
  float rest_length;
  float stiffness = 0.5;
  Node a, b;
  Spring( Node _a, Node _b, float _rest_length )
  {
    a = _a;
    b = _b;
    rest_length = _rest_length;
  }
  void update()
  {
    float distance = dist( a.x, a.y, b.x, b.y );
    
  }
}

class Mountain
{
   ArrayList<PVector> segments;
 Mountain()
 {
   segments = new ArrayList<PVector>();
   float left = width * 0.35;
   float right = width * 0.85;
   float ground = height * 0.4;
   segments.add( new PVector( left - 32, ground + random(6, 18) ) );
   segments.add( new PVector( left, ground ) );
   for( int i = 1; i < 19; ++i )
   {
     float y = ground - 10 - noise(i) * 40;
     segments.add( new PVector( map(i, 0, 20, left,  right ), y ) );
   }
   segments.add( new PVector( right, ground ) );
   segments.add( new PVector( right + 32, ground + random(6, 18) ) );
 }
 void draw()
 {
   strokeWeight( 1 );
   stroke( 255 );
   noFill();
   beginShape();
   for( PVector n : segments )
   {
     vertex( n.x, n.y );
   }
   endShape();
 }
}

class Worm
{
 ArrayList<Node> segments;
 ArrayList<Spring> springs;
 Worm()
 {
   segments = new ArrayList<Node>();
   springs = new ArrayList<Spring>();
   for( int i = 0; i < 8; ++i )
   {
     segments.add( new Node( map(i, 0, 7, width * 0.48, width * 0.52 ), height * 0.7 + noise(i * 0.2) * 8 ) );
   }
   for( int i = 0; i < segments.size() - 1; ++i )
   {
     springs.add( new Spring( segments.get(i), segments.get(i + 1), 5 ) );
   }
 }
 void draw()
 {
   for( Spring s : springs )
   {
     s.update();
   }
   stroke( 255, 20, 40 );
   strokeWeight( 4 );
   noFill();
   beginShape();
   for( Node n : segments )
   {
     vertex( n.x, n.y );
   }
   endShape();
 }
 
 void flex( int i )
 {
   segments.get(i);
 }
}
