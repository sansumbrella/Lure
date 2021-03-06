/**
Lure, by David Wicks http://sansumbrella.com/
Available for use under a CC-BY-SA-NC license
For more information (and to play), see:
http://sansumbrella.com/things/lure/
*/
Worm worm;
Mountain mountain;
Starfield stars;
Marquee marquee;
ArrayList<Fish> fish;

float suffocation_line;
float water_surface;
Boolean running = false;
Boolean alive = false;
color bg_color = color( 30, 20, 40 );
float odds = 0.995;
int num_fish_tempted = 0;
int game_start_ms = 0;
int game_end_ms = 0;

// HTML Elements
var fish_counter = document.getElementById("fish_counter");

void setup()
{
  size( 640, 480 );
  water_surface = height * 0.5;
  suffocation_line = height * 0.55;

  worm = new Worm();
  mountain = new Mountain();
  stars = new Starfield( 83, mountain.base() );
  fish = new ArrayList<Fish>();
  marquee = new Marquee( width / 2, (int)water_surface );
  marquee.display( "Click to Start" );
  smooth();
}

void startGame()
{
  marquee.display( "" );
  worm = new Worm();
  worm.setAerial();
  worm.moveTo( new PVector( 20, water_surface - 10 ) );
  worm.shove( new PVector( 25, -25 ), new PVector( 20, water_surface - 10 ) );
  running = true;
  alive = true;
  num_fish_tempted = 0;
  displayTemptedFish();
  game_start_ms = millis();
}

void wormDrowned()
{
  if ( alive )
  {
    alive = false;
    marquee.display( "You drowned." );
    game_end_ms = millis();
  }
}

void wormEaten( Fish by_fish )
{
  if ( alive )
  {
    alive = false;
    marquee.display( "You were eaten." );
    game_end_ms = millis();
    worm.setEaten();
  }
}

void draw()
{
  // Update
  if ( running )
  {
    worm.update();
  }
  for ( Fish f : fish )
  {
    f.update();
  }
  stars.update();
  // Render
  background( bg_color );
  stars.draw();
  mountain.draw();
  for ( Fish f : fish )
  {
    f.draw();
  }
  worm.draw();
  marquee.draw();
  drawWater();

  // Take stock
  for ( int i = fish.size() - 1; i >= 0; --i )
  {
    if ( fish.get(i).isGone() )
    {
      fish.remove(i);
    }
  }
  if ( fish.size() == 0 || random(1.0) > odds )
  {
    addFish();
  }
}

void addFish()
{
  float size = random( 8, 16 );
  fish.add( new Fish( 0, random( water_surface + size, height - size ), size ) );
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

void fishWasTempted()
{
  num_fish_tempted += 1;
  displayTemptedFish();
}

void displayTemptedFish()
{
 if ( fish_counter != null )
  {
    fish_counter.textContent = "Fish Tempted: " + num_fish_tempted;
  } 
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
    force.y -= 0.5;
  } else if ( bottom.indexOf( key ) != -1 )
  {
    index = floor( map( bottom.indexOf( key ), 0, bottom.length(), 0, worm.numSegments() ) );
    force.y = -1.2;
    force.x = map( index, 0, worm.numSegments() - 1, -0.8, 0.8 );
  }
  worm.flex( index, force );
}

