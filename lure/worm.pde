class Worm
{
  ArrayList<Node> segments;
  ArrayList<Spring> springs;
  color oxygenated = color(255, 20, 40);
  color depleted = color( 60, 10, 60 );
  float health = 1.0;
  float min_height = water_surface + 5;
  float max_height = height - 3;
  float writhingness = 0;
  float flex_strength = 0;
  Boolean flying = false;
  Worm()
  {
    float x = -40;
    float y = min_height;
    segments = new ArrayList<Node>();
    springs = new ArrayList<Spring>();
    for ( int i = 0; i < 10; ++i )
    {
      segments.add( new Node( x + map(i, 0, 9, 0, 25 ), y + noise(i * 0.2) * 12 ) );
    }
    for ( int i = 0; i < segments.size() - 1; ++i )
    { // connect to immediate neighbor strongly
      springs.add( new Spring( segments.get(i), segments.get(i + 1), 2.5, 0.4 ) );
    }
    for ( int i = 0; i < segments.size() - 2; ++i )
    { // connect to next neighbor weakly
      springs.add( new Spring( segments.get(i), segments.get(i + 2), 5, 0.1 ) );
    }
  }
  int numSegments()
  {
    return segments.size();
  }
  float top()
  {
    float t = height;
    for ( Node n : segments )
    {
      t = min( n.y, t );
    }
    return t;
  }

  void setAerial()
  {
    flying = true;
    min_height = 0;
    flex_strength = 0.2;
    for ( Node n : segments )
    {
      n.damping = 0.995;
    }
  }
  void setUnderwater()
  {
    flying = false;
    min_height = water_surface + 5;
    flex_strength = 3.0;
    for ( Node n : segments )
    {
      n.damping = 0.89;
    }
  }

  PVector center()
  {
    PVector c = new PVector(0, 0);
    for ( Node n : segments )
    {
      c.x += n.x;
      c.y += n.y;
    }
    c.div( segments.size() );
    return c;
  }

  void update()
  {
    writhingness *= lerp( 0.90, 0.99, health );
    writhingness = max( 1.0, min( 320, writhingness ) );
    if ( flying )
    {
      if ( top() > water_surface + 2 )
      {
        setUnderwater();
      }
    }
    if ( top() > suffocation_line )
    {
      health = max( health - 0.001, 0.0 );
    }
    else
    {
      health = min( health + 0.002, 1.0 );
    }
    for ( Node n : segments )
    { // Apply Gravity
      n.y += 0.03;
      n.y = max( min_height, min( n.y, max_height ) );
      n.x = max( 0, min( n.x, width ) );
    }
    for ( Node n : segments )
    {
      n.update();
    }
    for ( Spring s : springs )
    {
      s.update();
    }

    if ( health == 0 )
    {
      wormDrowned();
    }
  }
  void draw()
  {
    noStroke();
    fill( color( oxygenated, 10 ) );
    PVector c = center();
    ellipse( c.x, c.y, writhingness * 2, writhingness * 2 );
    noFill();
    stroke( lerpColor( depleted, oxygenated, health * health ) );
    strokeWeight( 3 );
    beginShape();
    for ( Node n : segments )
    {
      curveVertex( n.x, n.y );
    }
    endShape();
  }

  void flex( int segment, PVector force )
  {
    float factor = health > 0.0 ? map( health, 0.0, 1.0, 0.1, 1.0 ) : 0.0;
    Node s = segments.get(segment);
    s.y += force.y * factor * flex_strength;
    s.x += force.x * factor * flex_strength;
    writhingness += abs(force.y * health) * 9;
  }

  void moveTo( PVector loc )
  {
    PVector c = center();
    loc.sub( c );
    for ( Node n : segments )
    {
      n.x += loc.x;
      n.y += loc.y;
      n.px = n.x;
      n.py = n.y;
    }
  }

  void shove( PVector force, PVector loc )
  {
    for ( Node n : segments )
    {
      float dx = loc.x - n.x;
      float dy = loc.y - n.y;
      float dist2 = dx * dx + dy * dy;
      dist2 = min( 24.0, max( dist2, 1.0 ) );
      n.x += force.x / dist2;
      n.y += force.y / dist2;
    }
  }
}

