
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
  int index = (int)random(worm.numSegments() - 0.0001);
  PVector force = new PVector( random( -0.25, 0.25 ), random( -0.5, 0.5 ) );
  String top = "qwertyuiop";
  String middle = "asdfghjkl;";
  String bottom = "zxcvbnm,./";
  String lower_key = String.valueOf(key).toLowerCase();
  if ( top.indexOf( lower_key ) != -1 )
  {
    index = floor( map( top.indexOf( lower_key ), 0, top.length(), 0, worm.numSegments() ) );
    force.y = 1;
    force.x = map( index, 0, worm.numSegments(), -0.5, 0.5 );
  } else if ( middle.indexOf( lower_key ) != -1 )
  {
    index = floor( map( middle.indexOf( lower_key ), 0, middle.length(), 0, worm.numSegments() ) );
    force.x = map( index, 0, worm.numSegments(), -0.5, 0.5 );
    force.y -= 0.25;
  } else if ( bottom.indexOf( lower_key ) != -1 )
  {
    index = floor( map( bottom.indexOf( lower_key ), 0, bottom.length(), 0, worm.numSegments() ) );
    force.y = -1;
    force.x = map( index, 0, worm.numSegments(), -0.8, 0.8 );
  }
  worm.flex( index, force );
}

