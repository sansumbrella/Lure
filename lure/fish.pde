class Fish
{
  ArrayList<Node> body;
  ArrayList<Node> tail;
  ArrayList<Spring> springs;
  float size;

  Fish( float base_x, float base_y, float _size )
  {
    size = _size;
    body = new ArrayList<Node>();
    tail = new ArrayList<Node>();
    springs = new ArrayList<Spring>();

    for ( int i = 0; i < 4; ++i )
    {
      float x = base_x + cos( i * PI / 2 ) * size;
      float y = base_y + sin( i * PI / 2 ) * size;
      body.add( new Node( x, y ) );
    }

    for ( int i = 0; i < 3; ++i )
    {
      float x = base_x + cos( i * TWO_PI / 3 ) * size * 0.667f - size;
      float y = base_y + sin( i * TWO_PI / 3 ) * size * 0.667f;
      tail.add( new Node( x, y ) );
    }

    // body structure
    springs.add( new Spring( body.get(0), body.get(1), 0.9 ) );
    springs.add( new Spring( body.get(1), body.get(2), 0.9 ) );
    springs.add( new Spring( body.get(2), body.get(3), 0.9 ) );
    springs.add( new Spring( body.get(3), body.get(0), 0.9 ) );
    springs.add( new Spring( body.get(0), body.get(2), 0.6 ) );
    springs.add( new Spring( body.get(1), body.get(3), 0.6 ) );
    // tail structure
    springs.add( new Spring( tail.get(0), tail.get(1), 0.6 ) );
    springs.add( new Spring( tail.get(1), tail.get(2), 0.6 ) );
    springs.add( new Spring( tail.get(2), tail.get(0), 0.6 ) );
    // connect tail to body
    springs.add( new Spring( tail.get(0), body.get(2), 0.8 ) );
    springs.add( new Spring( tail.get(1), body.get(1), 0.8 ) );
    springs.add( new Spring( tail.get(2), body.get(3), 0.8 ) );
  }

  Boolean isGone()
  {
    Node nose = body.get(0);
    return nose.x > width + size * 2 || nose.x < - size * 2;
  }

  void update()
  {
    Node nose = body.get(0);
    PVector w = worm.center();
    float dx = w.x - nose.x;
    float dy = w.y - nose.y;
    float distance_to_worm = sqrt(dx * dx + dy * dy);
    if ( distance_to_worm < worm.writhingness )
    { // Seek out prey
      nose.x += dx * 0.005;
      nose.y += dy * 0.005;
      nose.x += 0.01;
    }
    else
    { // Swim merrily along
      nose.x += 1;
    }
    if ( distance_to_worm < 8 && worm.health > 0 )
    { // Devour living prey
      wormEaten( this );
    }

    for ( Node n : body )
    {
      n.update();
    }
    for ( Node n : tail )
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
    noStroke();
    fill( 255, 255, 0 );
    beginShape();
    for ( Node n : body )
    {
      vertex( n.x, n.y );
    }
    endShape();
    beginShape();
    for ( Node n : tail )
    {
      vertex( n.x, n.y );
    }
    endShape();
  }
}

