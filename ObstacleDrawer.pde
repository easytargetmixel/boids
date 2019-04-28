class ObstacleDrawer {
  
  private color color_ = 0x20903388;
  private float diameter = 15f;
  
  void drawObstacle(final Obstacle obstacle) {
     fill(color_);
     //stroke(color_);
     //noFill();
     ellipse(obstacle.getX(), obstacle.getY(), diameter, diameter);
  }
}
