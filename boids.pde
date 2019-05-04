private Environment environment;
private final ScreenClearer screenClearer = new ScreenClearer(0xFFFF1188, 10);
private final BoidDrawer boidDrawer = new BoidDrawer();
private final ObstacleDrawer obstacleDrawer = new ObstacleDrawer();
private final MessageDisplay messageDisplay = new MessageDisplay();
private final Tool tool = new Tool(ToolMode.ADD_BOIDS);
private final InputHandler inputHandler = new InputHandler();

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

  environment.updateAndDrawBoids();
  messageDisplay.draw_();
}

void keyPressed () {
  inputHandler.onKeyPressed(key, environment, tool);
}

void mousePressed() {
  final PVector mousePosition = new PVector(mouseX, mouseY);
  inputHandler.onMouseClicked(mousePosition, tool);
}

private void initEnvironment() {
  environment = new Environment();
}
