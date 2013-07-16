// Licence LGPL (see Licence.txt for details)

public class AgentDark extends Agent {
  public AgentDark(int x, int y) {
    super(x, y);
    int rnd = 255 - (int)random(20, 200);
    int secondary1 = getSecondaryColour(rnd);
    int secondary2 = getSecondaryColour(rnd);
    colour = new int[]{255, secondary1, secondary2};
  }
  
  void move(Light light) {
    move(light, false);
  }
}
