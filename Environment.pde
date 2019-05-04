class Environment {
  private int numOfInitialBoids = 2048;
  private ArrayList<Boid> boids;
  private ArrayList<Obstacle> obstacles;
  private float globalScale = .91f;
  private float maxSpeed;
  private float friendRadius;
  private float crowdRadius;
  private float avoidRadius;
  private float coheseRadius;
  private boolean option_friend = true;
  private boolean option_crowd = true;
  private boolean option_avoid = true;
  private boolean option_noise = true;
  private boolean option_cohese = true;

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
    recalculateConstants();
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

  void decreaseGlobalScale(final MessageDisplay messageDisplay) {
    setGlobalScale(globalScale * 0.8f, messageDisplay);
  }

  void increaseGlobalScale(final MessageDisplay messageDisplay) {
    setGlobalScale(globalScale / 0.8f, messageDisplay);
  }

  void setGlobalScale(final float globalScale, final MessageDisplay messageDisplay) {
    this.globalScale = globalScale;
    messageDisplay.showMessage("Global Scale: " + globalScale);
    recalculateConstants();
  }

  private void recalculateConstants () {
    maxSpeed = 2.1f * globalScale;
    friendRadius = 60f * globalScale;
    crowdRadius = (friendRadius / 1.3f);
    avoidRadius = 90f * globalScale;
    coheseRadius = friendRadius;
  }

  void updateAndDraw() {
    for (final Boid currentBoid : boids) {
      currentBoid.go(
        boids, 
        obstacles, 
        maxSpeed, 
        friendRadius, 
        crowdRadius, 
        avoidRadius, 
        coheseRadius
        );
      boidDrawer.drawBoid(currentBoid, globalScale);
    }

    for (final Obstacle currentObstacle : obstacles) {
      obstacleDrawer.drawObstacle(currentObstacle);
    }
  }
}
