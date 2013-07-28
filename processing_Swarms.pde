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
