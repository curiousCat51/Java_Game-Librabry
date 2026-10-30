class Player extends Sprite {

  KeyHandler EventListener;
  
  
  int repeatStartTime = 0;
  int repeatDelay = 120;
  
  int health = 3;
  

  Player(int grid_x, int grid_y, KeyHandler EventListener) {
    super(WorldTypes.PLAYER, grid_x, grid_y);

    this.EventListener = EventListener;
  }
  
  // Prüft ob ein gewünschtes Feld frei ist
  boolean canMoveToTarget(World world) {
    return !world.isWallAt(targetGridX, targetGridY) && !world.isBarrierAt(targetGridX, targetGridY);
  }
  
  // Prüft ob eine Bewegung möglich ist
  boolean tryMove(World world) {
  
    // Ohne Richtung gibt es keinen Bewegungsversuch.
    if (wishX == 0 && wishY == 0) {
      return false;
    }
  
    // Berechnen der theoretischen neuen Position
    calculateNewPosition(wishX, wishY);
    
    // Prüfen, ob das Zielfeld begehbar ist.
    if (!canMoveToTarget(world)) {
      return false;
    }
  
    // Das Zielfeld ist gültig.
    return true;
  }
  
  // Aktualisiert die Bewegungsrichtung anhand der Eingabe des Spielers
  void updateMovementInput(World world) {
  
    // Eine laufende Bewegung zuerst aktualisieren.
    updateMovement(world);
  
    // Während der Bewegung keinen neuen Schritt starten.
    if (isMoving()) {
      return;
    }
    
    if(EventListener.portal_mode){
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
  
  // Wird eine Richtungstaste gehalten
  boolean isDirectionHeld() {
    return EventListener.keyUp || EventListener.keyDown || EventListener.keyLeft || EventListener.keyRight;
  }
  
  // Fügt dem Spieler Schaden zu
  void takeDamage(int damage){
    health -= damage;
    
    health = max(0, health);
    
    println("Spieler-Lebenspunkte: " + health);
  }
  
  // Beim Neustart werden die Lebenspunkte zurückgesetzt
  void resetHealth(){
   health = 3; 
  }
  // Überschreibt die moveCompleted Methode, wenn eine Richtungstaste gehalten wird
  @Override void moveCompleted() {
    repeatStartTime = millis();
  }
  
  @Override boolean canActivateButton(){
    return true; 
  }
}
