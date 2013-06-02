class Node
{
  float x, y;
  float px, py;
  float damping = 0.9;
  Node( float _x, float _y )
  {
    x = _x;
    y = _y;
    px = x;
    py = y;
  }

  void update()
  {
    float vx = x - px;
    float vy = y - py;
    float cx = x;
    float cy = y;
    x = x + vx * damping;
    y = y + vy * damping;
    px = cx;
    py = cy;
  }
}

class Spring
{
  float rest_length;
  float stiffness;
  Node a, b;
  Spring( Node _a, Node _b, float _rest_length, float _stiffness )
  {
    a = _a;
    b = _b;
    rest_length = _rest_length;
    stiffness = _stiffness;
  }
  void update()
  {
    float dx = b.x - a.x;
    float dy = b.y - a.y;
    float distance = sqrt( dx * dx + dy * dy );
    float delta = rest_length - distance;
    float offsetX = (delta * dx / distance) / 2 * stiffness;
    float offsetY = (delta * dy / distance) / 2 * stiffness;
    a.x -= offsetX;
    a.y -= offsetY;
    b.x += offsetX;
    b.y += offsetY;
  }
}
