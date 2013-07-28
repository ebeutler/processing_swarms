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
// Licence LGPL (see Licence.txt for details)

public class Light {
  private PImage img;
  private int x;
  private int y;
  
  public Light() {
    imageMode(CENTER);
    img = loadImage("light.png");
  }
  
  public void setPos(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public void draw() {
    image(img, x, y);
  }
  
  public int getX() {
    return x;
  }
  
  public int getY() {
    return y;
  }
}
// Licence LGPL (see Licence.txt for details)

int MAX_MOVEMENT = 3;
int SIGHT_RADIUS = 100;
int LIGHT_RADIUS = 150;
int LIGHT_PROXIMITY = 20;

Maxim maxim;
AudioPlayer bgSound;
AudioPlayer fishSound;
PImage bg;
PImage redFish;
PImage greenFish;
PImage resetIcon;
Array agents;
Light light = new Light();
int[] bgColour = new int[]{0, 0, 255};

void setup() {
  //sounds from http://www.freesound.org/ 
  maxim = new Maxim(this);
  bgSound = maxim.loadFile("waves.wav");
  bgSound.setLooping(true);
  fishSound = maxim.loadFile("fish.wav");
  fishSound.setLooping(false);
  
  //background and the fish are from http://morguefile.com/
  bg = loadImage("background.jpg");
  redFish = loadImage("red.png");
  greenFish = loadImage("green.png");
  resetIcon = loadImage("reset.png");
  
  size(768, 576);
  background(bgColour[0], bgColour[1], bgColour[2]);
  ellipseMode(CENTER);
  rectMode(CENTER);
  imageMode(CENTER);
  frameRate(30);
  reset();
}

void draw() {
  bgSound.play(); //sound didn't work when called in setup
  image(bg, width/2, height/2);
  for(Agent agent : agents) {
    agent.move(light);
    agent.draw();
  }
  light.draw();
  image(resetIcon, 20, 20);
}

void mouseClicked() {
  if((mouseX > 10) && (mouseX < 30) && (mouseY > 10) && (mouseY < 30)) {
    reset();
  } else {
    int xpos = mouseX + round(random(-2, 2));
    int ypos = mouseY + round(random(-2, 2));
    if(mouseButton == RIGHT) {
      agents.push(new Agent(xpos, ypos, false));
    } else {
      agents.push(new Agent(xpos, ypos, true));
    }
  }
}

void mouseMoved() {
  light.setPos(mouseX, mouseY);
}

void reset() {
  agents = new Array();
}

