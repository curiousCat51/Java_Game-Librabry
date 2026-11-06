class Player extends Sprite {

  KeyHandler EventListener;
  
  
  int repeatStartTime = 0;
  int repeatDelay = 120;
  
  // Zeit bevor Trefferpunkte wieder hergestelt werden
  int damageStartTime = 0;
  int damageHealDelay = 500;
  boolean resetRecover = false;
  
  // Zeit für das wiederherstellen von Trefferpunkten
  int healStartTime = 0;
  int healDelay = 2;
  
  int animationFrame = 1;
  int animationLastUpdate = 0;
  int animationInterval = 120; // Millisekunden pro Frame

  Player(int grid_x, int grid_y, KeyHandler EventListener) {
    super(WorldTypes.PLAYER, grid_x, grid_y);
    this.health = 1;
    this.EventListener = EventListener;
  }
  
  // Prüft ob ein gewünschtes Feld frei ist
  boolean canMoveToTarget(World world) {
    // Das Zielfeld des Spielers muss begehbar sein.
    if (world.isWallAt(targetGridX, targetGridY) || world.isBarrierAt(targetGridX, targetGridY) || world.isClosedDoorAt(targetGridX, targetGridY) || world.isCrateAt(targetGridX, targetGridY)) {
      return false;
    }
  
    // Ohne getragenes Objekt reicht die Prüfung des Spielerfeldes.
    if (carriedObject == null) {
      return true;
    }
  
    // Das getragene Objekt bleibt ein Feld vor dem Spieler.
    int carriedX = targetGridX + facingX;
    int carriedY = targetGridY + facingY;
  
    // Wände und geschlossene Türen blockieren das Objekt.
    if (world.isWallAt(carriedX, carriedY) || world.isClosedDoorAt(carriedX, carriedY)) {
      return false;
    }
  
    return true;
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
    // Aktuelle Blickrichtung einlesen.
    updateFacing();
  
    // Eine laufende Bewegung zuerst aktualisieren.
    updateMovement(world);
    
    boolean interactPressed = EventListener.keyInteract && !interactWasDown;
    interactWasDown = EventListener.keyInteract;
     
    if(interactPressed){     
      interact(world);
    }
  
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
  @Override void takeDamage(int damage) {
    super.takeDamage(damage);
    println("Lebenspunkte: " + health);
  }
  
  // Beim Neustart werden die Lebenspunkte zurückgesetzt
  void resetHealth(){
   health = maxHealth; 
  }
  
  // Interagieren mit Weltobjekten
  void interact(World world){
    int objectX = grid_x + facingX;
    int objectY = grid_y + facingY;
    
    if(carriedObject != null){
      if (world.canDropObjectAt(objectX, objectY)) {
        WorldObject objectToDrop = carriedObject;
        
        world.moveObject(objectToDrop, objectToDrop.grid_x, objectToDrop.grid_y, objectX, objectY);
        
        if (objectToDrop instanceof Sprite) {
          Sprite sprite = (Sprite)objectToDrop;
          sprite.carriedBy = null;
          sprite.gettingCarried = false;
        
          sprite.targetGridX = objectX;
          sprite.targetGridY = objectY;
          sprite.displayGridX = objectX;
          sprite.displayGridY = objectY;
          sprite.moveProgress = 1;
        }
        
        carriedObject = null;
      }
      return; //Ablegen eines Objektes
    }
    
    
    WorldObject object = world.getPickupableObjectAt(objectX, objectY);
    
    carriedObject = object;
    
    if(carriedObject instanceof Sprite){
      ((Sprite)carriedObject).carriedBy = this;
      ((Sprite)carriedObject).gettingCarried = true;
    }
    
    if(object != null){
     carriedObject = object; // Aufheben eines Objektes
    }
  }
  
  // Aktualisiert die Blickrichtung des Spielers
  void updateFacing(){
    if (EventListener.keyFaceUp) {
      facingX = 0;
      facingY = -1;
    } else if (EventListener.keyFaceDown) {
      facingX = 0;
      facingY = 1;
    } else if (EventListener.keyFaceLeft) {
      facingX = -1;
      facingY = 0;
    } else if (EventListener.keyFaceRight) {
      facingX = 1;
      facingY = 0;
    }    
  }
  
  // Prüft, wann der Spieler zuletzt Schaden erhalten hat und setzt den Timer zurück, wenn der Spieler erneut getroffen wurde
  void startHealing(){    
    
    // Prüft, ob erneut ein Treffer gelandet wurde
    if(resetRecover){
      damageStartTime = 0;
      healStartTime = 0;
      resetRecover = false;
      return;
    }
    
    // Prüfen, ob seit dem letzten Treffer genug Zeit vergangen ist
    if(damageStartTime < damageHealDelay){
      damageStartTime++;
      return;
    }
    
    // Lässt den Spieler Trefferpunkte wiederherstellen
    recoverHP();
    healthBarShownUntil = millis() + healthBarDuration;
  }
  
  // Stellt Trefferpunkte wieder her
  void recoverHP(){
    if(healStartTime < 1 / healDelay){
     healStartTime++;
     return;
    }
    
    this.health += 2;
    healStartTime = 0;
  }
  
  // Überschreibt die moveCompleted Methode, wenn eine Richtungstaste gehalten wird
  @Override void moveCompleted() {
    repeatStartTime = millis();
  }
  
  @Override boolean canActivateButton(){
    return true; 
  }
}
