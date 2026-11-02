class KeyHandler {

  boolean keyUp = false;
  boolean keyDown = false;
  boolean keyLeft = false;
  boolean keyRight = false;
  boolean keyFaceUp = false;
  boolean keyFaceLeft = false;
  boolean keyFaceDown = false;
  boolean keyFaceRight = false;
  
  boolean portal_mode = false;
  WorldTypes selectedPortalType = null;
  boolean placePortalRequested = false;
  boolean cancelPortalRequested = false;
  boolean keyInteract = false;
  
  void handleKeyPressed(int code) {
    if (code == UP)    keyUp = true;
    if (code == DOWN)  keyDown = true;
    if (code == LEFT)  keyLeft = true;
    if (code == RIGHT) keyRight = true;
    if (key == 'w' || key == 'W') keyFaceUp = true;
    if (key == 'a' || key == 'A') keyFaceLeft = true;
    if (key == 's' || key == 'S') keyFaceDown = true;
    if (key == 'd' || key == 'D') keyFaceRight = true;
    
    if (key == 't' || key == 'T'){
      portal_mode = !portal_mode;
      
      if(!portal_mode){
       selectedPortalType = null; 
      }
    }
    if (portal_mode && key == '1') selectedPortalType = WorldTypes.PORTAL_A;
    if (portal_mode && key == '2') selectedPortalType = WorldTypes.PORTAL_B;
    if (portal_mode && code == ENTER){
     if (selectedPortalType != null){
       placePortalRequested = true;
     }
    }
    if (portal_mode && code == ESC){
      cancelPortalRequested = true;
    }
    
    if (key == 'r' || key == 'R'){
     if(gameOver){
      restartGame(); 
     }
    }
    
    if (key == 'e' || key == 'E'){
      keyInteract = true;
    }
  }

  void handleKeyReleased(int code) {
    if (code == UP)    keyUp = false;
    if (code == DOWN)  keyDown = false;
    if (code == LEFT)  keyLeft = false;
    if (code == RIGHT) keyRight = false;
    if (key == 'w' || key == 'W') keyFaceUp = false;
    if (key == 'a' || key == 'A') keyFaceLeft = false;
    if (key == 's' || key == 'S') keyFaceDown = false;
    if (key == 'd' || key == 'D') keyFaceRight = false;
    
    if(key == 'e' || key == 'E') keyInteract = false;
  }
}
