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
