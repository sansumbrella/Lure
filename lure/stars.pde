// The stars in the firmament
class Starfield
{
  ArrayList<PVector> stars;
  float horizon;
  float theta;
  Starfield( int _num_stars, float _horizon )
  {
    horizon = _horizon;
    stars = new ArrayList<PVector>();
    for( int i = 0; i < _num_stars; ++i )
    {
      float t = map( i, 0, _num_stars - 1, 0, TWO_PI );
      float r = width / 2 * sqrt( random(0.0, 1.0) );
      stars.add( new PVector( cos(t) * r, sin(t) * r ) );
    }
  }
  
  void update()
  {
    theta += 0.0001;
  }
  
  void draw()
  {
    pushMatrix();
    translate( width / 2, horizon );
    rotate( theta );
    stroke( 180, 200, 200 );
    strokeWeight( 1 );
    for( PVector p : stars )
    {
      point( p.x, p.y );
    }
    popMatrix();
    // occlude stars below the horizon
    noStroke();
    fill( bg_color );
    rect( 0, horizon, width, height - horizon );
  }
}
