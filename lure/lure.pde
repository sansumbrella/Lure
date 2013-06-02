
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
  // surface
  // oxygenated zone
  // low oxygen zone
  line( width * 0.25, height / 2, width * 0.75, height / 2 );
  line( width * 0.1, height / 2 + 3, width * 0.9, height / 2 + 3 );
  line( width * 0.01, height / 2 + 8, width * 0.99, height / 2 + 8 );
  stroke( 100, 20, 100 );
  for( int i = 0; i < 90; ++i )
  {
    float x = map( i, 0, 90, 0, width );
    line( x, height * 0.55, x + 2, height * 0.55 );
  }
}

void keyPressed()
{
  int index = (int)random(7);
  PVector force = new PVector( random( -0.25, 0.25 ), random( -0.5, 0.5 ) );
  String top = "qweruiop";
  String middle = "asdfjkl;";
  String bottom = "zxcvm,./";
  String lower_key = String.valueOf(key).toLowerCase();
  if( top.indexOf( lower_key ) != -1 )
  {
    index = top.indexOf( lower_key );
    force.y = 1;
    force.x = map( index, 0, 7, 0.5, -0.5 );
  }
  else if( middle.indexOf( lower_key ) != -1 )
  {
    index = middle.indexOf( lower_key );
    force.x = map( index, 0, 7, 0.5, -0.5 );
  }
  else if( bottom.indexOf( lower_key ) != -1 )
  {
    index = bottom.indexOf( lower_key );
    force.y = -1;
    force.x = map( index, 0, 7, 0.8, -0.8 );
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
 color oxygenated;
 color depleted;
 float health = 1.0;
 Worm()
 {
   x = width / 2;
   y = height * 0.65;
   x = x;
   py = y;
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
   oxygenated = color(255, 20, 40);
   depleted = color( 100, 20, 100 );
 }
 void draw()
 {
   y += 0.25;
   float vx = x - px;
   float vy = y - py;
   
   x = px + vx;
   y = py + vy;
   for( Spring s : springs )
   {
     s.update();
   }
   noFill();
   stroke( lerpColor( depleted, oxygenated, health ) );
   strokeWeight( 3 );
   pushMatrix();
   translate( x, y );
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
