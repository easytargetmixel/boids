private Environment environment;
private BoidDrawer boidDrawer = new BoidDrawer();
private ObstacleDrawer obstacleDrawer = new ObstacleDrawer();

private float globalScale = .91f;
private float eraseRadius = 20f;
private String tool = "boids";

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

private int messageTimer = 0;
private String messageText = "";

void setup () {
  fullScreen();
  textSize(16f);
  initEnvironment();
  recalculateConstants();
}

void draw () {
  noStroke();
  colorMode(HSB);
  //fill(0, 100);
  rect(0, 0, width, height);


  if (tool == "erase") {
    noFill();
    stroke(0, 100, 260);
    rect(mouseX - eraseRadius, mouseY - eraseRadius, eraseRadius * 2, eraseRadius *2);
    if (mousePressed) {
      erase();
    }
  } else if (tool == "avoids") {
    noStroke();
    fill(0, 200, 200);
    ellipse(mouseX, mouseY, 15, 15);
  }
  for (final Boid currentBoid : boids) {
    currentBoid.go();
    boidDrawer.drawBoid(currentBoid);
  }

  for (final Obstacle currentObstacle : obstacles) {
    obstacleDrawer.drawObstacle(currentObstacle);
  }

  if (messageTimer > 0) {
    messageTimer -= 1;
  }
  drawGUI();
}

void keyPressed () {
  if (key == 'q') {
    tool = "boids";
    message("Add boids");
  } else if (key == 'w') {
    tool = "avoids";
    message("Place obstacles");
  } else if (key == 'e') {
    tool = "erase";
    message("Eraser");
  } else if (key == '-') {
    message("Decreased scale");
    globalScale *= 0.8;
  } else if (key == '=') {
    message("Increased Scale");
    globalScale /= 0.8;
  } else if (key == '1') {
    option_friend = option_friend ? false : true;
    message("Turned friend allignment " + on(option_friend));
  } else if (key == '2') {
    option_crowd = option_crowd ? false : true;
    message("Turned crowding avoidance " + on(option_crowd));
  } else if (key == '3') {
    option_avoid = option_avoid ? false : true;
    message("Turned obstacle avoidance " + on(option_avoid));
  } else if (key == '4') {
    option_cohese = option_cohese ? false : true;
    message("Turned cohesion " + on(option_cohese));
  } else if (key == '5') {
    option_noise = option_noise ? false : true;
    message("Turned noise " + on(option_noise));
  } else if (key == ',') {
    environment.setupWalls();
  } else if (key == '.') {
    environment.setupCircle();
  }
  recalculateConstants();
}

void mousePressed () {
  final PVector mousePosition = new PVector(mouseX, mouseY);
  switch (tool) {
  case "boids":
    //boids.add(new Boid(mouseX, mouseY));
    //message(boids.size() + " Total Boid" + s(boids.size()));
    break;
  case "avoids":
    //obstacles.add(new Obstacle(mousePosition));
    break;
  }
}

private void initEnvironment() {
  environment = new Environment();
}

private void recalculateConstants () {
  maxSpeed = 2.1f * globalScale;
  friendRadius = 60f * globalScale;
  crowdRadius = (friendRadius / 1.3f);
  avoidRadius = 90f * globalScale;
  coheseRadius = friendRadius;
}

private void drawGUI() {
  if (messageTimer <= 0) {
    return;
  }
  
  fill((min(30f, messageTimer) / 30f) * 255f);
  text(messageText, 10f, height - 20f);
}

String s(int count) {
  return (count != 1) ? "s" : "";
}

String on(boolean in) {
  return in ? "on" : "off";
}



void erase () {
  for (int i = boids.size()-1; i > -1; i--) {
    Boid b = boids.get(i);
    if (abs(b.pos.x - mouseX) < eraseRadius && abs(b.pos.y - mouseY) < eraseRadius) {
      boids.remove(i);
    }
  }

  for (int i = obstacles.size()-1; i > -1; i--) {
    Obstacle b = obstacles.get(i);
    if (abs(b.getX() - mouseX) < eraseRadius && abs(b.getY() - mouseY) < eraseRadius) {
      obstacles.remove(i);
    }
  }
}

void drawText (String s, float x, float y) {
  fill(0);
  text(s, x, y);
  fill(200);
  text(s, x-1, y-1);
}


void message (String in) {
  messageText = in;
  messageTimer = (int) frameRate * 3;
}
