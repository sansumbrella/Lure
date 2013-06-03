class Fish
{
  ArrayList<Node> body;
  ArrayList<Node> tail;
  ArrayList<Spring> springs;
  float size;

  Fish( float _size )
  {
    size = _size;
    body = new ArrayList<Node>();
    tail = new ArrayList<Node>();
    springs = new ArrayList<Spring>();

    PVector nose = new PVector( 0, height * 0.6 );
    for ( int i = 0; i < 4; ++i )
    {
      float x = nose.x + cos( i * PI / 2 ) * size;
      float y = nose.y + sin( i * PI / 2 ) * size;
      body.add( new Node( x, y ) );
    }

    for ( int i = 0; i < 3; ++i )
    {
      float x = nose.x + cos( i * TWO_PI / 3 ) * size * 0.667f - size;
      float y = nose.y + sin( i * TWO_PI / 3 ) * size * 0.667f;
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
    springs.add( new Spring( tail.get(0), body.get(1), 0.8 ) );
    springs.add( new Spring( tail.get(0), body.get(2), 0.8 ) );
    springs.add( new Spring( tail.get(0), body.get(3), 0.8 ) );
  }

  void update()
  {
    body.get(0).x += 1;
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

