
Worm worm;
Mountain mountain;
Starfield stars;
Fish fish;

float suffocation_line;
float water_surface;
Boolean running = false;
color bg_color = color( 30, 20, 40 );

void setup()
{
  size( 640, 480 );
  water_surface = height * 0.5;
  suffocation_line = height * 0.55;

  worm = new Worm();
  mountain = new Mountain();
  stars = new Starfield( 83, height * 0.45 );
  fish = new Fish();
  smooth();
  background( bg_color );
}

void startGame()
{
  worm.health = 1.0;
  worm.writhingness = 1.0;
  worm.setAerial();
  worm.moveTo( new PVector( 20, water_surface - 10 ) );
  worm.shove( new PVector( 18, -20 ), new PVector( 20, water_surface - 10 ) );
//  worm.flex( 0, new PVector( 10, -10 ) );
  running = true;
}

void draw()
{
  if ( running )
  {
    worm.update();
  }
  stars.update();
  background( bg_color );
  stars.draw();
  mountain.draw();
  worm.draw();
  fish.draw();
  drawWater();
}

void drawWater()
{
  strokeWeight( 1 );
  // surface
  // oxygenated zone
  // low oxygen zone
  stroke( 0, 127, 127 );
  line( width * 0.25, water_surface, width * 0.75, water_surface );
  stroke( 0, 180, 180 );
  line( width * 0.1, water_surface + 3, width * 0.9, water_surface + 3 );
  stroke( 0, 255, 255 );
  line( 0, water_surface + 8, width, water_surface + 8 );
  stroke( 100, 20, 100 );
  for ( int i = 0; i < 90; ++i )
  {
    float x = map( i, 0, 90, 0, width );
    line( x, suffocation_line, x + 2, suffocation_line );
  }
}

void mousePressed()
{
  startGame();
}

void keyPressed()
{
  int index = (int)random(worm.numSegments() - 0.0001);
  PVector force = new PVector( random( -0.5, 0.5 ), random( -0.4, 0.5 ) );
  String top = "qwertyuiop";
  String middle = "asdfghjkl;";
  String bottom = "zxcvbnm,./";
  if ( top.indexOf( key ) != -1 )
  {
    index = floor( map( top.indexOf( key ), 0, top.length(), 0, worm.numSegments() ) );
    force.y = 1;
    force.x = map( index, 0, worm.numSegments() - 1, -0.8, 0.8 );
  } else if ( middle.indexOf( key ) != -1 )
  {
    index = floor( map( middle.indexOf( key ), 0, middle.length(), 0, worm.numSegments() ) );
    force.x = map( index, 0, worm.numSegments() - 1, -0.8, 0.8 );
    force.y -= 0.25;
  } else if ( bottom.indexOf( key ) != -1 )
  {
    index = floor( map( bottom.indexOf( key ), 0, bottom.length(), 0, worm.numSegments() ) );
    force.y = -1;
    force.x = map( index, 0, worm.numSegments() - 1, -0.8, 0.8 );
  }
  worm.flex( index, force );
}

