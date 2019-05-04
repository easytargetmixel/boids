private Environment environment;
private ScreenClearer screenClearer = new ScreenClearer(0xFFFF1188, 20);
private BoidDrawer boidDrawer = new BoidDrawer();
private ObstacleDrawer obstacleDrawer = new ObstacleDrawer();
private MessageDisplay messageDisplay = new MessageDisplay();
private Tool tool = new Tool(ToolMode.ADD_BOIDS);

void setup () {
  fullScreen();
  textSize(16f);
  colorMode(HSB);

  initEnvironment();
  screenClearer.perform();
}

void draw () {
  screenClearer.perform();
  tool.draw_();

  environment.updateAndDraw();
  messageDisplay.draw_();
}

void keyPressed () {
  switch (key) {
  case 'q':
    tool.setMode(ToolMode.ADD_BOIDS, messageDisplay);
    break;

  case 'w':
    tool.setMode(ToolMode.ADD_OBSTACLES, messageDisplay);
    break;

  case 'e':
    tool.setMode(ToolMode.ERASE, messageDisplay);
    break;

  case '-':
    environment.decreaseGlobalScale(messageDisplay);
    break;

  case '=':
    environment.increaseGlobalScale(messageDisplay);
    break;

  case ',':
    environment.setupWalls();
    break;

  case '.':
    environment.setupCircle();
  }

  if (key == '1') {
    //option_friend = option_friend ? false : true;
    //message("Turned friend allignment ", option_friend);
  } else if (key == '2') {
    //option_crowd = option_crowd ? false : true;
    //message("Turned crowding avoidance ", option_crowd);
  } else if (key == '3') {
    //option_avoid = option_avoid ? false : true;
    //message("Turned obstacle avoidance ", option_avoid);
  } else if (key == '4') {
    //option_cohese = option_cohese ? false : true;
    //message("Turned cohesion ", option_cohese);
  } else if (key == '5') {
    //option_noise = option_noise ? false : true;
    //message("Turned noise ", option_noise);
  } 
}

void mousePressed() {
  final PVector mousePosition = new PVector(mouseX, mouseY);
  tool.perform(mousePosition);
}

private void initEnvironment() {
  environment = new Environment();
}
