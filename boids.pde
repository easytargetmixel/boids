private Environment environment;
private ScreenClearer screenClearer = new ScreenClearer(0xFFFF1188, 20);
private BoidDrawer boidDrawer = new BoidDrawer();
private ObstacleDrawer obstacleDrawer = new ObstacleDrawer();
private MessageDisplay messageDisplay = new MessageDisplay();

private float globalScale = .91f;
private float eraseRadius = 20f;
private Tool tool = new Tool(ToolMode.ADD_BOIDS);

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

void setup () {
  fullScreen();
  textSize(16f);
  colorMode(HSB);

  initEnvironment();
  recalculateConstants();
  screenClearer.perform();
}

void draw () {
  screenClearer.perform();
  tool.draw_();

  environment.updateAndDraw();
  messageDisplay.draw_();
}

void keyPressed () {
  if (key == 'q') {
    tool.mode = ToolMode.ADD_BOIDS;
    message("Add boids");
  } else if (key == 'w') {
    tool.mode = ToolMode.ADD_OBSTACLES;
    message("Place obstacles");
  } else if (key == 'e') {
    tool.mode = ToolMode.ERASE;
    message("Eraser");
  } else if (key == '-') {
    message("Decreased scale");
    globalScale *= 0.8;
  } else if (key == '=') {
    message("Increased Scale");
    globalScale /= 0.8;
  } else if (key == '1') {
    option_friend = option_friend ? false : true;
    message("Turned friend allignment ", option_friend);
  } else if (key == '2') {
    option_crowd = option_crowd ? false : true;
    message("Turned crowding avoidance ", option_crowd);
  } else if (key == '3') {
    option_avoid = option_avoid ? false : true;
    message("Turned obstacle avoidance ", option_avoid);
  } else if (key == '4') {
    option_cohese = option_cohese ? false : true;
    message("Turned cohesion ", option_cohese);
  } else if (key == '5') {
    option_noise = option_noise ? false : true;
    message("Turned noise ", option_noise);
  } else if (key == ',') {
    environment.setupWalls();
  } else if (key == '.') {
    environment.setupCircle();
  }
  recalculateConstants();
}

void mousePressed() {
  final PVector mousePosition = new PVector(mouseX, mouseY);
  tool.perform(mousePosition);
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


private void message(final String messageText) {
  messageDisplay.showMessage(messageText);
}

private void message(final String prefixText, final boolean onOffValue) {
  messageDisplay.showMessage(prefixText, onOffValue);
}
