class Environment {
  private int numOfInitialBoids = 2048;
  private ArrayList<Boid> boids;
  private ArrayList<Obstacle> obstacles;

  Environment() {
    boids = new ArrayList<Boid>();
    //for (int x = 100; x < width - 100; x+= 50) {
    //  for (int y = 100; y < height - 100; y+= 50) {
    //    boids.add(new Boid(x + random(3), y + random(3)));
    //    boids.add(new Boid(x + random(3), y + random(3)));
    //  }
    //}

    for (int i = 0; i < numOfInitialBoids; i++) {
      final Boid randomBoid = new Boid(random(width), random(height));
      boids.add(randomBoid);
    }
    setupWalls();
  }

  void setupWalls() {
    obstacles = new ArrayList<Obstacle>();
    //for (int x = 0; x < width; x+= 20) {
    //  final PVector upperObstaclePosition = new PVector(x, 10f);
    //  obstacles.add(new Obstacle(upperObstaclePosition));
    //  final PVector lowerObstaclePosition = new PVector(x, height - 10f);
    //  obstacles.add(new Obstacle(lowerObstaclePosition));
    //}
  }

  void setupCircle() {
    obstacles = new ArrayList<Obstacle>();
    for (int x = 0; x < 50; x+= 1) {
      float dir = (x / 50.0) * TWO_PI;
      final PVector obstaclePosition = new PVector(
        width * 0.5f + cos(dir) * height * 0.4f, 
        height * 0.5f + sin(dir) * height * 0.4f
        ); 
      obstacles.add(new Obstacle(obstaclePosition));
    }
  }

  void updateAndDraw() {
    for (final Boid currentBoid : boids) {
      currentBoid.go(boids, obstacles);
      boidDrawer.drawBoid(currentBoid);
    }

    for (final Obstacle currentObstacle : obstacles) {
      obstacleDrawer.drawObstacle(currentObstacle);
    }
  }
}
