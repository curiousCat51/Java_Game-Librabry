class KeyHandler {

  boolean keyUp = false;
  boolean keyDown = false;
  boolean keyLeft = false;
  boolean keyRight = false;
  boolean portal_mode = false;
  WorldTypes selectedPortalType = null;
  boolean placePortalRequested = false;
  boolean cancelPortalRequested = false;

  void handleKeyPressed(int code) {
    if (code == UP)    keyUp = true;
    if (code == DOWN)  keyDown = true;
    if (code == LEFT)  keyLeft = true;
    if (code == RIGHT) keyRight = true;
    if(key == 't' || key == 'T'){
      portal_mode = !portal_mode;
      
      if(!portal_mode){
       selectedPortalType = null; 
      }
    }
    if(portal_mode && key == '1') selectedPortalType = WorldTypes.PORTAL_A;
    if(portal_mode && key == '2') selectedPortalType = WorldTypes.PORTAL_B;
    if(portal_mode && code == ENTER){
     if(selectedPortalType != null){
       placePortalRequested = true;
     }
    }
    if(portal_mode && code == ESC){
      cancelPortalRequested = true;
    }
    
    if(key == 'r' || key == 'R'){
     if(gameOver){
      restartGame(); 
     }
    }
  }

  void handleKeyReleased(int code) {
    if (code == UP)    keyUp = false;
    if (code == DOWN)  keyDown = false;
    if (code == LEFT)  keyLeft = false;
    if (code == RIGHT) keyRight = false;
  }
}
