class Player extends Sprite {

  KeyHandler EventListener;
  
  
  int repeatStartTime = 0;
  int repeatDelay = 120;
  

  Player(int grid_x, int grid_y, KeyHandler EventListener) {
    super(WorldTypes.PLAYER, grid_x, grid_y);

    this.EventListener = EventListener;
  }
  
  boolean canMoveToTarget(World world) {
    return !world.isWallAt(targetGridY, targetGridX);
  }
  
  boolean tryMove(World world) {
  
    // Ohne Richtung gibt es keinen Bewegungsversuch.
    if (wishX == 0 && wishY == 0) {
      return false;
    }
  
    calculateNewPosition(wishX, wishY);
    
    // Prüfen, ob das Zielfeld begehbar ist.
    if (!canMoveToTarget(world)) {
      return false;
    }
  
    // Das Zielfeld ist gültig.
    return true;
  }
  
  void updateMovementInput(World world) {
  
    // Eine laufende Bewegung zuerst aktualisieren.
    updateMovement(world);
  
    // Während der Bewegung keinen neuen Schritt starten.
    if (isMoving()) {
      return;
    }
  
    // Wurde keine Richtung gehalten, gibt es nichts zu wiederholen.
    if (!isDirectionHeld()) {
      return;
    }
  
    // Wiederholungsverzögerung abwarten.
    if (millis() - repeatStartTime < repeatDelay) {
      return;
    }
  
    // Aktuelle Richtung einlesen.
    processInput();
  
    // Nur bei einem gültigen Ziel eine neue Bewegung starten.
    if (tryMove(world)) {
      moveProgress = 0.0f;
      moveStartTime = millis();
    }
  }
  
  boolean isDirectionHeld() {
    return EventListener.keyUp || EventListener.keyDown || EventListener.keyLeft || EventListener.keyRight;
  }
  
  @Override void moveCompleted() {
    repeatStartTime = millis();
  }
}
