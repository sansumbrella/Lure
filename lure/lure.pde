
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
  drawWater();
}

void drawWater()
{
  strokeWeight( 0.5 );
  stroke( 0, 255, 255 );
  line( width * 0.25, height / 2, width * 0.75, height / 2 );
  line( width * 0.1, height / 2 + 3, width * 0.9, height / 2 + 3 );
  line( width * 0.01, height / 2 + 8, width * 0.99, height / 2 + 8 );
}

void keyPressed()
{
  int index = (int)random(7);
  PVector force = new PVector( random( -0.1, 0.1 ), random( -0.2, 0.2 ) );
  String top = "qweruiop";
  String middle = "asdfjkl;";
  String bottom = "zxcvm,./";
  if( top.indexOf( key ) != -1 )
  {
    index = top.indexOf( key );
    force.y = 1;
    force.x = 0;
  }
  else if( middle.indexOf( key ) != -1 )
  {
    index = middle.indexOf( key );
  }
  else if( bottom.indexOf( key ) != -1 )
  {
    index = bottom.indexOf( key );
    force.y = -1;
    force.x = 0;
  }
  worm.flex( index, force );
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

class Worm
{
 ArrayList<Node> segments;
 ArrayList<Spring> springs;
 float x, y;
 float px, py;
 Worm()
 {
   x = width / 2;
   y = height * 0.65;
   segments = new ArrayList<Node>();
   springs = new ArrayList<Spring>();
   for( int i = 0; i < 8; ++i )
   {
     segments.add( new Node( map(i, 0, 7, 0, 21 ), noise(i * 0.2) * 12 ) );
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
   strokeWeight( 3 );
   pushMatrix();
   translate( x, y );
   noFill();
   beginShape();
   for( Node n : segments )
   {
     vertex( n.x, n.y );
   }
   endShape();
   popMatrix();
 }
 
 void flex( int segment, PVector force )
 {
//   segments.get(segment);
   y += force.y;
   x += force.x;
   println( "Flex: " + segment + ", " + force.y );
 }
}
