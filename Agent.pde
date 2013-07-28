// Licence LGPL (see Licence.txt for details)

public abstract class Agent {
  int x;
  int y;
  boolean directionLeft;
  boolean towardsLight;
  
  public Agent(int x, int y, boolean towardsLight) {
    this.x = x;
    this.y = y;
    this.towardsLight = towardsLight;
    directionLeft = random(0, 1) > 0.5;
    fishSound.cue(0);
    fishSound.play();
  }
  
  public void draw() {
    PImage img = redFish;
    if(towardsLight) { img = greenFish; }
    pushMatrix();
    if(directionLeft) {
      scale(-1.0, 1.0);
      image(img, -x, y);
    } else {
      image(img, x, y);
    }
    popMatrix();
  }
  
  public void move(Light light) {
    int diffX = x - light.getX();
    int adX = abs(diffX);
    int diffY = y - light.getY();
    int adY = abs(diffY);
    if((!towardsLight || ((adX > LIGHT_PROXIMITY) && (adY > LIGHT_PROXIMITY))) 
        && (adX < LIGHT_RADIUS) && (adY < LIGHT_RADIUS)) {
      setFishDirection(diffX);
      int sign = 1;
      if(towardsLight) { sign = -1; }
      x += sign * getMoveX(adX, adY, light.getX());
      y += sign * getMoveY(adX, adY, light.getY());
    } else { //fish is in the light or too far to see it
      swarmOrRandomSwim();
    }
    preventSwimmingOutOfScreen();
  }
  
  void setFishDirection(int diffX) {
    if(diffX < 0) {
      directionLeft = true;
    } else {
      directionLeft = false;
    }
  }
  
  int getMoveX(int dx, int dy, int lightX) {
    short sign = 1;
    if(lightX > x) { sign = -1; }
    if(dy != 0) {
      if(dx > dy) {
        return sign * MAX_MOVEMENT;
      } else {
        int dx = round(dx / (dy / (float)MAX_MOVEMENT));
        if(sign * dx < 0) {
          dx = sign * dx;
        } 
        return dx;
      }
    } else {
      return sign * MAX_MOVEMENT;
    } 
  }
  
  int getMoveY(int dx, int dy, int lightY) {
    short sign = 1;
    if(lightY > y) { sign = -1; }
    if(dx != 0) {
      if(dy > dx) {
        return sign * MAX_MOVEMENT;
      } else {
        return sign * round(dy / (dx / (float)MAX_MOVEMENT));
      }
    } else {
      return sign * MAX_MOVEMENT;
    }
  }
  
  void swarmOrRandomSwim() {
    Agent neighbor = attractedToOtherFish();
    if(neighbor != null) {
      int dx = x - neighbor.x;
      int dy = y - neighbor.y;
      if(((dx > 0) && !towardsLight) || ((dx < 0) && towardsLight)) {
        directionLeft = true;
      } else { 
        directionLeft = false;
      }
      x += -1 * getMoveX(abs(dx), abs(dy), neighbor.x);
      y += -1 * getMoveY(abs(dx), abs(dy), neighbor.y);
    } else {
      if(random(0, 1) < 0.01) {
        directionLeft = !directionLeft;
      }
      if(directionLeft) {
        x += round(random(0, 1));
      } else {
        x += round(random(-1, 0));
      }
      y += round(random(-2, 2));
    }
  }
  
  Agent attractedToOtherFish() {
    for(int i = 0; i < agents.length; i++) {
      int dx = abs(x - agents[i].x);
      int dy = abs(y - agents[i].y);
      if((this != agents[i]) && (dx <= SIGHT_RADIUS) && (dy <= SIGHT_RADIUS)
          && (dx > LIGHT_PROXIMITY) && (dy > LIGHT_PROXIMITY)) {
        return agents[i];
      }
    }
    return null;
  }
  
  void preventSwimmingOutOfScreen() {
    if(x < 0) {
      x = 0;
      directionLeft = !directionLeft;
    }
    if(x > width) {
      x = width;
      directionLeft = !directionLeft;
    }
    if(y < 0) { y = 0; }
    if(y > height) { y = height; }
  }
}
