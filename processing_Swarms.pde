Array agents;
Light light = new Light();
int[] bgColour = new int[]{0, 0, 255};

void setup() {
  size(1200, 800);
  background(bgColour[0], bgColour[1], bgColour[2]);
  ellipseMode(CENTER);
  rectMode(CENTER);
  frameRate(30);
  reset();
}

void draw() {
  stroke(bgColour[0], bgColour[1], bgColour[2]);
  fill(bgColour[0], bgColour[1], bgColour[2]);
  rect(width/2, height/2, width, height);
  for(Agent agent : agents) {
    agent.move(light);
    agent.draw();
  }
  light.draw();
}

void mouseClicked() {
  if(mouseButton == RIGHT) {
    agents.push(new AgentDark(mouseX, mouseY));
  } else {
    agents.push(new AgentLight(mouseX, mouseY));
  }
}

void mouseMoved() {
  light.setPos(mouseX, mouseY);
}

void reset() {
  agents = new Array();
}
