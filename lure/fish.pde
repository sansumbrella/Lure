class Fish
{
  float size = 12.0f;
  void update()
  {
  }
  void draw()
  {
    pushMatrix();
    translate( width / 4, height * 0.6 );
    noStroke();
    fill( 255, 255, 0 );
    beginShape();
    for ( int i = 0; i < 4; ++i )
    {
      float x = cos( i * PI / 2 ) * size;
      float y = sin( i * PI / 2 ) * size;
      vertex( x, y );
    }
    endShape();
    beginShape();
    for ( int i = 0; i < 3; ++i )
    {
      float x = cos( i * TWO_PI / 3 ) * size * 0.667f - size;
      float y = sin( i * TWO_PI / 3 ) * size * 0.667f;
      vertex( x, y );
    }
    endShape();
    popMatrix();
  }
}
