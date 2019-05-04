class Tool {

  ToolMode mode;

  Tool(final ToolMode mode) {
    this.mode = mode;
  }

  void draw_() {
    switch (mode) {
    case ERASE:
      noFill();
      stroke(0, 100, 260);
      rect(mouseX - eraseRadius, mouseY - eraseRadius, eraseRadius * 2, eraseRadius *2);
      break;

    case ADD_OBSTACLES:
      noStroke();
      fill(0, 200, 200);
      ellipse(mouseX, mouseY, 15, 15);
      break;
    }
  }

  void perform(final PVector position) {
    switch (mode) {
    case ERASE:
      erase(position);
      break;
    case ADD_BOIDS:
      //boids.add(new Boid(mouseX, mouseY));
      //message(boids.size() + " Total Boid" + s(boids.size()));
      break;
    case ADD_OBSTACLES:
      //obstacles.add(new Obstacle(mousePosition));
      break;
    }
  }

  void erase(final PVector position) {
    //for (int i = boids.size()-1; i > -1; i--) {
    //  Boid b = boids.get(i);
    //  if (abs(b.pos.x - mouseX) < eraseRadius && abs(b.pos.y - mouseY) < eraseRadius) {
    //    boids.remove(i);
    //  }
    //}

    //for (int i = obstacles.size()-1; i > -1; i--) {
    //  Obstacle b = obstacles.get(i);
    //  if (abs(b.getX() - mouseX) < eraseRadius && abs(b.getY() - mouseY) < eraseRadius) {
    //    obstacles.remove(i);
    //  }
    //}
  }
}
