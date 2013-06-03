// A jagged peak in the distance
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
    for ( int i = 1; i < 19; ++i )
    {
      float y = ground - 10 - noise(i * 0.3) * 80;
      segments.add( new PVector( map(i, 0, 20, left, right ), y ) );
    }
    segments.add( new PVector( right, ground ) );
    segments.add( new PVector( right + 32, ground + random(6, 18) ) );
  }
  void draw()
  {
    strokeWeight( 1 );
    stroke( 220, 230, 255 );
    fill( bg_color );
    beginShape();
    for ( PVector n : segments )
    {
      vertex( n.x, n.y );
    }
    endShape();
    noStroke();
    PVector tl = segments.get(0);
    PVector tr = segments.get(segments.size() - 1);
    beginShape();
    vertex( tl.x, tl.y );
    vertex( tr.x, tr.y );
    vertex( tr.x, height );
    vertex( tl.x, height );
    endShape();
  }

  float base()
  {
    return min( segments.get(0).y, segments.get(segments.size()-1).y );
  }
}

