class Player extends WorldObject{
  
  // Image Objekte für die Darstellung bei Bewegung
  AnimationImage image_up_walk;
  AnimationImage image_down_walk;
  AnimationImage image_left_walk;
  AnimationImage image_right_walk;
  
  // Image Objekte für die Darstellung bei Stillstehen
  NormalImage image_up;
  NormalImage image_down;
  NormalImage image_left;
  NormalImage image_right;
  
  // Spawn-Position festhalten
  GridPosition spawn;
  
  // Directory mit den Bewegungsrichtungen
  MoveDirectory dir;
  
  // Aktuelle Bewegungsrichtung
  MoveDirectory direction;
  
  // Neue Bewegungsrichtung
  MoveDirectory wish_direction;
  
  // Collision Abfragen
  CollisionResult collision = new CollisionResult();
  
  // Aniomationsfortschritt
  float progress = 1;
  
  // Positionsvariablen
  float moveProgress = 1.0f;

  int movementStartGridX;
  int movementStartGridY;
  int targetGridX;
  int targetGridY;

  float startPixelX;
  float startPixelY;
  float targetPixelX;
  float targetPixelY;
  
  float moveRepeatDelay = 0.20f;
  float moveRepeatTimer = 0.0f;
  
  boolean hasStartedMoving = false;
  
  Player(int grid_x, int grid_y){
    
    super(WorldTypes.PLAYER, grid_x, grid_y);
    
    movementStartGridX = grid_x;
    movementStartGridY = grid_y;
    targetGridX = grid_x;
    targetGridY = grid_y;
    
    image_up_walk = new AnimationImage("data/images/player/up/", 4, ANIMATION_SPEED);
    image_down_walk = new AnimationImage("data/images/player/down/", 4, ANIMATION_SPEED);
    image_left_walk = new AnimationImage("data/images/player/left/", 4, ANIMATION_SPEED);
    image_right_walk = new AnimationImage("data/images/player/right/", 4, ANIMATION_SPEED);
    
    image_up = new NormalImage("data/images/player/up/" + (int) progress);
    image_down = new NormalImage("data/images/player/down/" + (int) progress);
    image_left = new NormalImage("data/images/player/left/" + (int) progress);
    image_right = new NormalImage("data/images/player/right/" + (int) progress);
    
    setImageContainer(image_down);
    
    spawn = new GridPosition(grid_x, grid_y);
  }
  
  void updateProgress(){
    
    if(wish_direction == MoveDirectory.HOCH){
      if(image_up_walk.getProgress() != 0){
        progress = image_up_walk.getProgress();
      }
    }
    else if(wish_direction == MoveDirectory.RUNTER){
      if(image_down_walk.getProgress() != 0){
        progress = image_down_walk.getProgress();
      }
    }
    else if(wish_direction == MoveDirectory.LINKS){
      if(image_left_walk.getProgress() != 0){
        progress = image_left_walk.getProgress();
      }
    }
    else if(wish_direction == MoveDirectory.RECHTS){
      if(image_right_walk.getProgress() != 0){
        progress = image_right_walk.getProgress();
      }
    }
  }
  
  void move() {
  
    // Laufende Bewegung zuerst fortsetzen.
    updateMovement();
  
    // Keine neue Bewegung während der aktuellen Bewegung.
    if (isMoving()) {
      return;
    }
  
    readInput();
  
    // Keine Richtung gehalten: Wiederholung zurücksetzen.
    if (!EventListener.isDirectionHeld()) {
      moveRepeatTimer = 0.0f;
      return;
    }
  
    if (hasStartedMoving && moveRepeatTimer > 0.0f) {
      moveRepeatTimer -= deltaTime;
      return;
    }
    
    if (wish_direction != MoveDirectory.NEUTRAL
        && canMove(wish_direction)) {
    
      startMoveWithDirection(wish_direction);
      hasStartedMoving = true;
    }
  }
  
  void readInput() {
    if (EventListener.getKeyUP()) {
      wish_direction = MoveDirectory.HOCH;
    } else if (EventListener.getKeyDOWN()) {
      wish_direction = MoveDirectory.RUNTER;
    } else if (EventListener.getKeyLEFT()) {
      wish_direction = MoveDirectory.LINKS;
    } else if (EventListener.getKeyRIGHT()) {
      wish_direction = MoveDirectory.RECHTS;
    }
    else{
     wish_direction = MoveDirectory.NEUTRAL; 
    }
  }
  
  void startMoveWithDirection(MoveDirectory chosen) {
    ImageContainer image = getImageForDirection(chosen);
    moveObject(chosen, image);
  }
  
  ImageContainer getImageForDirection(MoveDirectory chosen) {
    if (chosen == MoveDirectory.LINKS) {
      return image_left_walk;
    }
    else if(chosen == MoveDirectory.RECHTS){
      return image_right_walk;
    }
    else if(chosen == MoveDirectory.HOCH){
     return image_up_walk; 
    }
    else if(chosen == MoveDirectory.RUNTER){
     return image_down_walk; 
    }
    else{
      if(direction == MoveDirectory.LINKS){
        return image_left;
      }
      else if(direction == MoveDirectory.RECHTS){
       return image_right; 
      }
      else if(direction == MoveDirectory.HOCH){
        return image_up;
      }
      else{
        return image_down;
      }
    }
  }
  
  void changeDirection(MoveDirectory newDirection){
   wish_direction = newDirection; 
  }
  
  void moveObject(MoveDirectory chosen, ImageContainer image) {
    if (!canMove(chosen)) {
      return;
    }

    updateDirection(chosen, image);

    GridPosition next = getTeleportDestination(grid_x, grid_y, chosen);

    if (next == null) {
      return;
    }

    if (next.getX() != grid_x + directionDeltaX(chosen) ||
        next.getY() != grid_y + directionDeltaY(chosen)) {
      // Teleporter: logisch direkt am Ziel ankommen.
      setPosition(next.getX(), next.getY());
      moveProgress = 1.0f;
      movementStartGridX = grid_x;
      movementStartGridY = grid_y;
      targetGridX = grid_x;
      targetGridY = grid_y;
      return;
    }

    startMovement(next.getX(), next.getY());
  }
  
  void updateDirection(MoveDirectory newDirection, ImageContainer image){
   setImageContainer(image);
   direction = newDirection;
  }
  
  boolean canMove(MoveDirectory dir) {
    if (dir == MoveDirectory.NEUTRAL) {
      return false;
    }

    int nextX = grid_x + directionDeltaX(dir);
    int nextY = grid_y + directionDeltaY(dir);
    return collision.checkCollision(nextX, nextY);
  }
  
  int directionDeltaX(MoveDirectory dir) {
    if (dir == MoveDirectory.RECHTS) return 1;
    if (dir == MoveDirectory.LINKS) return -1;
    return 0;
  }

  int directionDeltaY(MoveDirectory dir) {
    if (dir == MoveDirectory.RUNTER) return 1;
    if (dir == MoveDirectory.HOCH) return -1;
    return 0;
  }

  int[] moveDic(MoveDirectory dir) {
    return new int[] {directionDeltaX(dir), directionDeltaY(dir)};
  }
  
  void updateMovement() {
    if (moveProgress >= 1.0f) {
      return;
    }

    // moveSpeed ist Pixel/Frame. In Tile-Fortschritt umrechnen, damit
    // die Bewegung nicht durch eine falsche Einheit vervielfacht wird.
    float progressPerFrame = (TILE_SIZE > 0) ? (PLAYER_SPEED * SCALE / TILE_SIZE) : 0;
    moveProgress = min(1.0f, moveProgress + progressPerFrame);

    pixel_x = lerp(startPixelX, targetPixelX, moveProgress);
    pixel_y = lerp(startPixelY, targetPixelY, moveProgress);

    if (moveProgress >= 1.0f) {
      grid_x = targetGridX;
      grid_y = targetGridY;
      pixel_x = convertToPixel(grid_x);
      pixel_y = convertToPixel(grid_y);
    }
  }
  
  
  /**
  * Beginnt die Bewegung zu einem benachbartem Rasterfeld.
  *
  * Speichert die Start- und Zielposition für die Animation.
  * Der Bewegungsfortschritt beginnt bei null.
  *
  * Wichtig:
  * Eine bereits laufende Bewegung darf nicht versehentlich durch einen erneuten Aufruf zurückgesetzt werden.
  */
  
  void startMovement(int targetX, int targetY) {
    
    moveRepeatTimer = moveRepeatDelay;
    
    movementStartGridX = grid_x;
    movementStartGridY = grid_y;

    startPixelX = convertToPixel(movementStartGridX);
    startPixelY = convertToPixel(movementStartGridY);
    targetPixelX = convertToPixel(targetX);
    targetPixelY = convertToPixel(targetY);

    targetGridX = targetX;
    targetGridY = targetY;
    moveProgress = 0.0f;
  }
  
  boolean isMoving() {
    return moveProgress < 1.0f;
  }
  
  GridPosition getTeleportDestination(int posX, int posY, MoveDirectory chosen) {
    int nextX = posX + directionDeltaX(chosen);
    int nextY = posY + directionDeltaY(chosen);

    if (nextX < 0 || nextX >= map_width || nextY < 0 || nextY >= map_height) {
      return null;
    }

    Teleporter teleporter = findTeleporterAt(nextX, nextY);
    if (teleporter == null) {
      return new GridPosition(nextX, nextY);
    }

    return new GridPosition(teleporter.getGridX(), teleporter.getGridY());
  }

  Teleporter findTeleporterAt(int x, int y) {
    for (Teleporter tp : teleporter) {
      if (tp.getGridX() == x && tp.getGridY() == y) {
        return (Teleporter) tp;
      }
    }
    return null;
  }
  
  void updateLayoutPosition() {
    if (!isMoving()) {
      pixel_x = convertToPixel(grid_x);
      pixel_y = convertToPixel(grid_y);
      return;
    }

    // Resize darf die Bewegung NICHT abschließen. Stattdessen werden nur
    // die Pixel-Endpunkte neu berechnet und derselbe Fortschritt beibehalten.
    startPixelX = convertToPixel(movementStartGridX);
    startPixelY = convertToPixel(movementStartGridY);
    targetPixelX = convertToPixel(targetGridX);
    targetPixelY = convertToPixel(targetGridY);

    pixel_x = lerp(startPixelX, targetPixelX, moveProgress);
    pixel_y = lerp(startPixelY, targetPixelY, moveProgress);
  }
  
  void display() {
    drawObject();
  }
}
