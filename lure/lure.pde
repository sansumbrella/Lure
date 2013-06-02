
Worm worm;
Mountain mountain;
Fish fish;

float suffocation_line;
float water_surface;

void setup()
{
  size( 640, 480 );
  water_surface = height * 0.5;
  suffocation_line = height * 0.55;

  worm = new Worm();
  mountain = new Mountain();
  fish = new Fish();
  smooth();
}

void draw()
{
  background( 30, 20, 40 );
  mountain.draw();
  worm.update();
  worm.draw();
  fish.draw();
  drawWater();
}

void drawWater()
{
  strokeWeight( 0.5 );
  stroke( 0, 255, 255 );
  // surface
  // oxygenated zone
  // low oxygen zone
  line( width * 0.25, water_surface, width * 0.75, water_surface );
  line( width * 0.1, water_surface + 3, width * 0.9, water_surface + 3 );
  line( width * 0.01, water_surface + 8, width * 0.99, water_surface + 8 );
  stroke( 100, 20, 100 );
  for ( int i = 0; i < 90; ++i )
  {
    float x = map( i, 0, 90, 0, width );
    line( x, suffocation_line, x + 2, suffocation_line );
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
  if ( top.indexOf( lower_key ) != -1 )
  {
    index = top.indexOf( lower_key );
    force.y = 1;
    force.x = map( index, 0, 7, 0.5, -0.5 );
  } else if ( middle.indexOf( lower_key ) != -1 )
  {
    index = middle.indexOf( lower_key );
    force.x = map( index, 0, 7, 0.5, -0.5 );
  } else if ( bottom.indexOf( lower_key ) != -1 )
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
  float px, py;
  float damping = 0.9;
  Node( float _x, float _y )
  {
    x = _x;
    y = _y;
    px = x;
    py = y;
  }

  void update()
  {
    float vx = x - px;
    float vy = y - py;
    float cx = x;
    float cy = y;
    x = x + vx * damping;
    y = y + vy * damping;
    px = cx;
    py = cy;
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
  color oxygenated = color(255, 20, 40);
  color depleted = color( 60, 10, 60 );
  float health = 1.0;
  float damping = 0.85;
  Worm()
  {
    float x = width / 2;
    float y = water_surface;
    segments = new ArrayList<Node>();
    springs = new ArrayList<Spring>();
    for ( int i = 0; i < 8; ++i )
    {
      segments.add( new Node( x + map(i, 0, 7, 0, 21 ), y + noise(i * 0.2) * 12 ) );
    }
    for ( int i = 0; i < segments.size() - 1; ++i )
    {
      springs.add( new Spring( segments.get(i), segments.get(i + 1), 5 ) );
    }
  }
  float top()
  {
    float t = height;
    for( Node n : segments )
    {
      t = min( n.y, t );
    }
    return t;
  }
  void update()
  {
    if ( top() > suffocation_line )
    {
      health = max( health - 0.002, 0.0 );
    }
    else
    {
      health = min( health + 0.001, 1.0 );
    }
//    float vx = x - px;
//    float vy = y - py;
//    float cx = x;
//    float cy = y;
//    x = x + vx * damping;
//    y = y + vy * damping;
//    px = cx;
//    py = cy;
//    // clamp to ends
//    y += 0.04f;
//    y = min( height - 8, max( y, water_surface ) );
//    x = min( width, max( 0, x ) );
    for( Node n : segments )
    {
      n.update();
    }
    for ( Spring s : springs )
    {
      s.update();
    }
  }
  void draw()
  {
    noFill();
    stroke( lerpColor( depleted, oxygenated, health * health ) );
    strokeWeight( 3 );
    beginShape();
    for ( Node n : segments )
    {
      vertex( n.x, n.y );
    }
    endShape();
  }

  void flex( int segment, PVector force )
  {
    Node s = segments.get(segment);
    s.y += force.y * health * health * 1.0;
    s.x += force.x * health * health * 0.5;
  }
}

