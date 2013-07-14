public class AgentLight extends Agent {
  public AgentLight(int x, int y) {
    super(x, y);
    int rnd = 255 - (int)random(20, 200);
    int secondary1 = getSecondaryColour(rnd);
    int secondary2 = getSecondaryColour(rnd);
    colour = new int[]{secondary1, 255, secondary2};
  }
  
  void move(Light light) {
    move(light, true);
  }
}
