public class Light {
  private int x;
  private int y;
  
  public void setPos(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public void draw() {
    stroke(255, 255, 0);
    fill(255, 255, 0);
    ellipse(x, y, 20, 20);
  }
  
  public int getX() {
    return x;
  }
  
  public int getY() {
    return y;
  }
}
