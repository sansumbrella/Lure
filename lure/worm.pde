class Worm
{
  ArrayList<Node> segments;
  ArrayList<Spring> springs;
  color oxygenated = color(255, 20, 40);
  color depleted = color( 60, 10, 60 );
  float health = 1.0;
  float damping = 0.85;
  float writhingness = 0;
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
    { // connect to immediate neighbor strongly
      springs.add( new Spring( segments.get(i), segments.get(i + 1), 3, 0.4 ) );
    }
    for ( int i = 0; i < segments.size() - 2; ++i )
    { // connect to next neighbor weakly
      springs.add( new Spring( segments.get(i), segments.get(i + 2), 6, 0.1 ) );
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
  
  PVector center()
  {
    PVector c = new PVector(0, 0);
    for( Node n : segments )
    {
      c.x += n.x;
      c.y += n.y;
    }
    c.div( segments.size() );
    return c;
  }
  
  void update()
  {
    writhingness *= 0.96;
    if ( top() > suffocation_line )
    {
      health = max( health - 0.001, 0.0 );
    }
    else
    {
      health = min( health + 0.001, 1.0 );
    }
    for ( Node n : segments )
    { // Apply Gravity
      n.y += 0.03;
      n.y = max( water_surface, min( n.y, height - 2 ) );
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
    strokeWeight( 4 );
    PVector c = center();
    ellipse( c.x, c.y, writhingness * 48.0, writhingness * 48.0 );
  }

  void flex( int segment, PVector force )
  {
    println( "Flex segment: " + segment );
    Node s = segments.get(segment);
    s.y += force.y * health * 2.0;
    s.x += force.x * health * 2.0;
    writhingness += force.y * health;
  }
}

