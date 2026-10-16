class KeyHandler {

  boolean keyUp = false;
  boolean keyDown = false;
  boolean keyLeft = false;
  boolean keyRight = false;

  void handleKeyPressed(int code) {
    if (code == UP)    keyUp = true;
    if (code == DOWN)  keyDown = true;
    if (code == LEFT)  keyLeft = true;
    if (code == RIGHT) keyRight = true;
  }

  void handleKeyReleased(int code) {
    if (code == UP)    keyUp = false;
    if (code == DOWN)  keyDown = false;
    if (code == LEFT)  keyLeft = false;
    if (code == RIGHT) keyRight = false;
  }
}
