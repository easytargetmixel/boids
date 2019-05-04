class Boid {

  private PVector pos;
  private PVector velocity = new PVector(0f, 0f);
  private float shade = random(255f);
  private ArrayList<Boid> friends = new ArrayList<Boid>();
  private int thinkTimer = int(random(10));

  Boid (final float x, final float y) {
    pos = new PVector(x, y);
  }

  PVector getPosition() {
    return pos;
  }

  float getX() {
    return pos.x;
  }

  float getY() {
    return pos.y;
  }

  float getHeading() {
    return velocity.heading();
  }

  float getShade() {
    return shade;
  }

  ArrayList<Boid> getFriends() {
    return friends;
  }

  void go(
    final ArrayList<Boid> allBoids, 
    final ArrayList<Obstacle> obstacles, 
    final float maxSpeed, 
    final float friendRadius, 
    final float crowdRadius, 
    final float avoidRadius, 
    final float coheseRadius
    ) {
    increment();
    wrap();

    if (thinkTimer == 0) {
      updateFriends(allBoids, friendRadius);
    }

    flock(obstacles, maxSpeed, friendRadius, crowdRadius, avoidRadius, coheseRadius);
  }

  void flock(
    final ArrayList<Obstacle> obstacles, 
    final float maxSpeed, 
    final float friendRadius, 
    final float crowdRadius, 
    final float avoidRadius, 
    final float coheseRadius
    ) {

    final PVector friendVelocityInfluence = getVelocityInfluenceFromFriends(
      friendRadius, 
      crowdRadius, 
      coheseRadius
      );
    friendVelocityInfluence.mult(1f);
    velocity.add(friendVelocityInfluence);

    final PVector avoidObjects = getObstacleAvoidance(obstacles, avoidRadius);
    avoidObjects.mult(3f);
    velocity.add(avoidObjects);

    final PVector noise = new PVector(random(2f) - 1f, random(2f) -1f);
    noise.mult(0.1f);
    velocity.add(noise);

    velocity.limit(maxSpeed);

    shade += getAverageColor() * 0.03f;
    shade += (random(2f) - 1f) ;
    shade = (shade + 255f) % 255f; //max(0, min(255, shade));

    pos.add(velocity);
  }

  private void updateFriends(final ArrayList<Boid> allBoids, final float friendRadius) {
    final ArrayList<Boid> nearby = new ArrayList<Boid>();
    for (final Boid test : allBoids) {
      if (test == this) {
        continue;
      }

      if (abs(test.pos.x - this.pos.x) < friendRadius &&
        abs(test.pos.y - this.pos.y) < friendRadius) {
        nearby.add(test);
      }
    }

    friends = nearby;
  }

  private float getAverageColor () {
    float total = 0;
    float count = 0;
    for (Boid other : friends) {
      if (other.shade - shade < -128) {
        total += other.shade + 255 - shade;
      } else if (other.shade - shade > 128) {
        total += other.shade - 255 - shade;
      } else {
        total += other.shade - shade;
      }
      count++;
    }

    if (count == 0) return 0;
    return total / (float) count;
  }

  private PVector getVelocityInfluenceFromFriends(
    final float friendRadius, 
    final float crowdRadius, 
    final float coheseRadius
    ) {
    final PVector sum = new PVector(0f, 0f);
    PVector cohesionSum = new PVector(0f, 0f);

    int count = 0;

    for (Boid other : friends) {
      float d = PVector.dist(pos, other.pos);

      if ((d > 0f) && (d < friendRadius)) {
        PVector copy = other.velocity.copy();
        copy.normalize();
        copy.div(d); 
        sum.add(copy);
      }

      if ((d > 0f) && (d < crowdRadius)) {
        PVector diff = PVector.sub(pos, other.pos);
        diff.normalize();
        diff.div(d);
        sum.add(diff);
      }

      if ((d > 0) && (d < coheseRadius)) {
        cohesionSum.add(other.pos);
        count++;
      }
    }

    if (count > 0) {
      cohesionSum.div(count);
      cohesionSum = PVector.sub(cohesionSum, pos).setMag(0.05f).mult(1f);
      sum.add(cohesionSum);
    }

    return sum;
  }

  private PVector getObstacleAvoidance(final ArrayList<Obstacle> obstacles, final float avoidRadius) {
    final PVector steer = new PVector(0f, 0f);

    for (final Obstacle obstacle : obstacles) {
      final float d = PVector.dist(pos, obstacle.getPosition());
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0f) && (d < avoidRadius)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, obstacle.getPosition());
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
      }
    }
    return steer;
  }

  // update all those timers!
  private void increment () {
    thinkTimer = (thinkTimer + 1) % 5;
  }

  private void wrap () {
    pos.x = (pos.x + width) % width;
    pos.y = (pos.y + height) % height;
  }
}
