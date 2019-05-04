class Boid {

  private PVector pos;
  private PVector move = new PVector(0f, 0f);
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
    return move.heading();
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

    if (thinkTimer ==0 ) {
      updateFriends(allBoids, friendRadius);
    }
    flock(obstacles, maxSpeed, friendRadius, crowdRadius, avoidRadius, coheseRadius);
    pos.add(move);
  }

  void flock(
    final ArrayList<Obstacle> obstacles, 
    final float maxSpeed, 
    final float friendRadius, 
    final float crowdRadius, 
    final float avoidRadius, 
    final float coheseRadius
    ) {
    final PVector allign = getAverageDir(friendRadius, crowdRadius);
    final PVector avoidObjects = getAvoidAvoids(obstacles, avoidRadius);
    final PVector noise = new PVector(random(2f) - 1f, random(2f) -1f);
    final PVector cohese = getCohesion(coheseRadius);

    allign.mult(1);
    //if (!option_friend) allign.mult(0);

    avoidObjects.mult(3);
    //if (!option_avoid) avoidObjects.mult(0);

    noise.mult(0.1);
    //if (!option_noise) noise.mult(0);

    cohese.mult(1);
    //if (!option_cohese) cohese.mult(0);

    stroke(0, 255, 160);

    move.add(allign);
    move.add(avoidObjects);
    move.add(noise);
    move.add(cohese);

    move.limit(maxSpeed);

    shade += getAverageColor() * 0.03;
    shade += (random(2) - 1) ;
    shade = (shade + 255) % 255; //max(0, min(255, shade));
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

  private PVector getAverageDir(final float friendRadius, final float crowdRadius) {
    PVector sum = new PVector(0, 0);
    int count = 0;

    for (Boid other : friends) {
      float d = PVector.dist(pos, other.pos);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < friendRadius)) {
        PVector copy = other.move.copy();
        copy.normalize();
        copy.div(d); 
        sum.add(copy);
        count++;
      }

      if ((d > 0) && (d < crowdRadius)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other.pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }

      if (count > 0) {
        //sum.div((float)count);
      }
    }
    return sum;
  }

  //private PVector getAvoidDir() {
  //PVector steer = new PVector(0, 0);
  //int count = 0;

  //for (Boid other : friends) {
  //  float d = PVector.dist(pos, other.pos);
  //  // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
  //  if ((d > 0) && (d < crowdRadius)) {
  //    // Calculate vector pointing away from neighbor
  //    PVector diff = PVector.sub(pos, other.pos);
  //    diff.normalize();
  //    diff.div(d);        // Weight by distance
  //    steer.add(diff);
  //    count++;            // Keep track of how many
  //  }
  //}
  //if (count > 0) {
  //  //steer.div((float) count);
  //}
  //  return steer;
  //}

  private PVector getAvoidAvoids(final ArrayList<Obstacle> obstacles, final float avoidRadius) {
    PVector steer = new PVector(0, 0);
    int count = 0;

    for (Obstacle other : obstacles) {
      float d = PVector.dist(pos, other.getPosition());
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < avoidRadius)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other.getPosition());
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    return steer;
  }

  private PVector getCohesion(final float coheseRadius) {
    //float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : friends) {
      float d = PVector.dist(pos, other.pos);
      if ((d > 0) && (d < coheseRadius)) {
        sum.add(other.pos); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);

      PVector desired = PVector.sub(sum, pos);  
      return desired.setMag(0.05);
    } else {
      return new PVector(0, 0);
    }
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
