class BoidDrawer {

  private boolean drawLinesToFriends = false;
  private color friendLineColor = 0x10FFFFFF;

  void drawBoid(final Boid boid, final float globalScale) {
    if (drawLinesToFriends) {
      drawLinesToFriends(boid);
    }

    noStroke();
    fill(boid.getShade(), 90f, 200f);
    pushMatrix();
    translate(boid.getX(), boid.getY());
    rotate(boid.getHeading());
    beginShape();
    vertex(15f * globalScale, 0);
    vertex(-7f * globalScale, 7f * globalScale);
    vertex(-7f * globalScale, -7f * globalScale);
    endShape(CLOSE);
    popMatrix();
  }

  void drawLinesToFriends(final Boid boid) {
    stroke(friendLineColor);
    for (final Boid friend : boid.getFriends()) {
      line(boid.getX(), boid.getY(), friend.getX(), friend.getY());
    }
  }
}
