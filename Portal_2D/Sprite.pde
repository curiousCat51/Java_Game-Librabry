class Sprite extends WorldObject {

  // Das Rasterfeld, zu dem sich dieses Sprite bewegen möchte.
  int targetGridX;
  int targetGridY;
  
  float displayGridX;
  float displayGridY;
  
  float moveProgress = 1.0f;
  
  int moveStartTime;
  int moveDuration = 200;
  
  int wishX = 0;
  int wishY = 0;
  
  boolean portalReady = true;

  Sprite(WorldTypes type, int grid_x, int grid_y) {
    super(type, grid_x, grid_y);

    // Zu Beginn liegt das Bewegungsziel auf der aktuellen Position.
    targetGridX = grid_x;
    targetGridY = grid_y;
    
    displayGridX = grid_x;
    displayGridY = grid_y;
  }

  // Berechnet das Zielfeld anhand einer gewünschten Bewegungsrichtung.
  void calculateNewPosition(int wishX, int wishY) {
    targetGridX = grid_x + wishX;
    targetGridY = grid_y + wishY;
  }
  
  // Aktualisiert die Position zwischen zwei Feldern
  void updateMovement(World world) {
  
    // Keine Animation nötig, wenn der Sprite stillsteht.
    if (!isMoving()) {
      return;
    }
  
    // Bewegung schrittweise fortsetzen.
    moveProgress = min(1.0f, (millis() - moveStartTime) / (float) moveDuration);
  
    // Sichtbare Position zwischen Start und Ziel berechnen.
    displayGridX = lerp(grid_x, targetGridX, moveProgress);
    displayGridY = lerp(grid_y, targetGridY, moveProgress);
  
    // Bei 100 % die Bewegung abschließen.
    if (moveProgress >= 1.0f) {
      world.moveObject(this, grid_x, grid_y, targetGridX, targetGridY);
      
      world.tryTeleport(this);
  
      displayGridX = grid_x;
      displayGridY = grid_y;
      
      moveCompleted();
    }
  }
  
  // Verarbeitet die Eingaben des Spielers
  void processInput(){
   wishX = 0;
   wishY = 0;
   
   if(EventListener.keyUp){
    wishY = -1;
   }
   else if(EventListener.keyDown){
    wishY = 1; 
   }
   else if(EventListener.keyLeft){
    wishX = -1; 
   }
   else if(EventListener.keyRight){
    wishX = 1; 
   }
  }
  
  // Überprüft ob ein Sprite sich aktuell bewegt oder nicht
  boolean isMoving(){
   return moveProgress < 1.0f; 
  }
  
  void moveCompleted() {
    // Wird nach Abschluss einer Bewegung aufgerufen.
  }
}
