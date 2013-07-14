public abstract class Agent {
  int MAX_MOVEMENT = 3;
  int x;
  int y;
  boolean directionLeft; 
  int[] colour;
  
  public Agent(int x, int y) {
    this.x = x;
    this.y = y;
    directionLeft = random(0, 1) > 0.5;
  }

  int getSecondaryColour(int rnd) {
    return rnd + (int)random(-20, 20);
  }
  
  public void draw() {
    pushMatrix();
    drawFishBody();
    drawFishTail();
    drawFishEye();
    popMatrix();
  }
  
  void drawFishBody() {
    stroke(colour[0], colour[1], colour[2]);
    fill(colour[0], colour[1], colour[2]);
    ellipse(x, y, 27, 10);
  }
  
  void drawFishTail() {
    int xPos = x+13;
    if(directionLeft) {
      xPos = x-13;
    }
    triangle(x, y, xPos, y-7, xPos, y+7);
    stroke(bgColour[0], bgColour[1], bgColour[2]);
    fill(bgColour[0], bgColour[1], bgColour[2]);
    ellipse(xPos, y, 3, 12);
  }
  
  void drawFishEye() {
    stroke(0);
    strokeWeight(3);
    if(directionLeft) {
      point(x + 7, y - 2);
    } else {
      point(x - 7, y - 2);
    }
  }
  
  abstract void move(Light light);
  
  public void move(Light light, boolean towardsLight) {
    //set x, y, directionLeft
    if((abs(x - light.getX()) < 100) && (abs(y - light.getY()) < 100)) {
      int diffX = x - light.getX();
      int diffY = y - light.getY();
      setFishDirection();
      if(abs(diffX) > abs(diffY)) {
        if(diffX != 0) {
          diffY = round(diffY / (diffX / (float)MAX_MOVEMENT));
        } else {
          diffY = MAX_MOVEMENT;
        }
        diffX = MAX_MOVEMENT;
      } else {
        if(diffY != 0) {
          diffX = round(diffX / (diffY / (float)MAX_MOVEMENT));
        } else {
          diffX = MAX_MOVEMENT;
        }
        diffY = MAX_MOVEMENT;
      }
      //console.log("movement (x, y):", diffX, diffY);
      x += diffX;
      y += diffY;
    } else {
      if(random(0, 1) < 0.01) {
        directionLeft = !directionLeft;
      }
      if(directionLeft) {
        x += round(random(0, 2));
      } else {
        x += round(random(-2, 0));
      }
      y += round(random(-2, 2));
    }
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
  
  void setFishDirection(int diffX, boolean towardsLight) {
    if(diffX < 0) {
      directionLeft = towardsLight;
    } else {
      directionLeft = !towardsLight;
    }
  }
}
