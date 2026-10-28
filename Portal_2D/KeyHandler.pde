class KeyHandler {

  boolean keyUp = false;
  boolean keyDown = false;
  boolean keyLeft = false;
  boolean keyRight = false;
  boolean portal_mode = false;

  void handleKeyPressed(int code) {
    if (code == UP)    keyUp = true;
    if (code == DOWN)  keyDown = true;
    if (code == LEFT)  keyLeft = true;
    if (code == RIGHT) keyRight = true;
    if(key == 't' || key == 'T') portal_mode = !portal_mode;
  }

  void handleKeyReleased(int code) {
    if (code == UP)    keyUp = false;
    if (code == DOWN)  keyDown = false;
    if (code == LEFT)  keyLeft = false;
    if (code == RIGHT) keyRight = false;
  }
}
