class ObstacleDrawer {
  
  private float diameter = 15f;
  
  void drawObstacle(final Avoid obstacle) {
     fill(0, 255, 200);
     ellipse(obstacle.getX(), obstacle.getY(), diameter, diameter);
  }
}
