// A voracious predator
class Fish
{
  ArrayList<Node> body;
  ArrayList<Node> tail;
  ArrayList<Spring> springs;
  float size;
  color body_color;
  Boolean was_tempted;

  Fish( float base_x, float base_y, float _size )
  {
    size = _size;
    body = new ArrayList<Node>();
    tail = new ArrayList<Node>();
    springs = new ArrayList<Spring>();
    body_color =  color( ceil(random(2, 5)) * 50, 255, 0 ); 
    was_tempted = false;

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
      float hunting_speed = (distance_to_worm < 100) ? map( distance_to_worm, 100, 0, 1.0, 0.1 )
        : map( distance_to_worm, 640, 100, 0.1, 1.25 );
      float nx = dx / distance_to_worm;
      float ny = dy / distance_to_worm;
      nose.x += nx * hunting_speed;
      nose.y += ny * hunting_speed;

      if ( ! was_tempted )
      {
        was_tempted = true;
        fishWasTempted();
      }

      if ( distance_to_worm < 12 && worm.health > 0 )
      { // Devour living prey
        if ( !worm.eaten )
        {
          nose.x = w.x;
          nose.y = w.y;
          wormEaten( this );
        }
      }
    }
    else
    { // Swim merrily along
      nose.x += 1;
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
    fill( body_color );
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

