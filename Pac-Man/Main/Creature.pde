class Creature extends WorldObject {
  CreatureDirections direction = CreatureDirections.NEUTRAL;
  CreatureDirections wish_direction = CreatureDirections.NEUTRAL;

  CollisionResult collision = new CollisionResult();

  // Fortschritt zwischen movementStart und movementTarget: 0..1.
  float moveProgress = 1.0f;

  int movementStartGridX;
  int movementStartGridY;
  int targetGridX;
  int targetGridY;

  float startPixelX;
  float startPixelY;
  float targetPixelX;
  float targetPixelY;

  // Pixel pro Frame in der Basis-Skalierung. Die tatsächliche
  // Tile-Bewegung wird erst in updateMovement() über TILE_SIZE berechnet.
  float moveSpeed;

  Creature(WorldTypes type, int grid_x, int grid_y, float speed) {
    super(type, grid_x, grid_y);
    moveSpeed = speed;
    movementStartGridX = grid_x;
    movementStartGridY = grid_y;
    targetGridX = grid_x;
    targetGridY = grid_y;
    collision.setCollisionFilter(WorldTypes.WALL);
  }

  void changeDirection(CreatureDirections newDirection) {
    wish_direction = newDirection;
  }

  void move(CreatureDirections chosen, ImageContainer image) {
    if (chosen == CreatureDirections.NEUTRAL || !canMove(chosen)) {
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

  void updateDirection(CreatureDirections newDirection, ImageContainer image) {
    setImageContainer(image);
    direction = newDirection;
  }

  CreatureDirections getFreeDirection() {
    CreatureDirections[] directions = {
      CreatureDirections.HOCH,
      CreatureDirections.RUNTER,
      CreatureDirections.LINKS,
      CreatureDirections.RECHTS
    };

    for (CreatureDirections candidate : directions) {
      if (canMove(candidate)) {
        return candidate;
      }
    }

    return CreatureDirections.NEUTRAL;
  }

  boolean canMove(CreatureDirections dir) {
    if (dir == CreatureDirections.NEUTRAL) {
      return false;
    }

    int nextX = grid_x + directionDeltaX(dir);
    int nextY = grid_y + directionDeltaY(dir);
    return collision.checkCollision(nextX, nextY);
  }

  int directionDeltaX(CreatureDirections dir) {
    if (dir == CreatureDirections.RECHTS) return 1;
    if (dir == CreatureDirections.LINKS) return -1;
    return 0;
  }

  int directionDeltaY(CreatureDirections dir) {
    if (dir == CreatureDirections.RUNTER) return 1;
    if (dir == CreatureDirections.HOCH) return -1;
    return 0;
  }

  int[] moveDic(CreatureDirections dir) {
    return new int[] {directionDeltaX(dir), directionDeltaY(dir)};
  }

  boolean isAtPlayer() {
    return player != null &&
           grid_x == player.getGridX() &&
           grid_y == player.getGridY();
  }

  void startMovement(int targetX, int targetY) {
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

  void updateMovement() {
    if (moveProgress >= 1.0f) {
      return;
    }

    // moveSpeed ist Pixel/Frame. In Tile-Fortschritt umrechnen, damit
    // die Bewegung nicht durch eine falsche Einheit vervielfacht wird.
    float progressPerFrame = (TILE_SIZE > 0) ? (moveSpeed * SCALE / TILE_SIZE) : 0;
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

  boolean isMoving() {
    return moveProgress < 1.0f;
  }

  GridPosition getTeleportDestination(int posX, int posY, CreatureDirections chosen) {
    int nextX = posX + directionDeltaX(chosen);
    int nextY = posY + directionDeltaY(chosen);

    if (nextX < 0 || nextX >= map_width || nextY < 0 || nextY >= map_height) {
      return null;
    }

    Teleporter teleporter = findTeleporterAt(nextX, nextY);
    if (teleporter == null || !teleporter.isActive()) {
      return new GridPosition(nextX, nextY);
    }

    GridPosition destination = teleporter.TeleportTo();
    return destination == null ? new GridPosition(nextX, nextY) : destination;
  }

  Teleporter findTeleporterAt(int x, int y) {
    for (WorldObject object : world_objects) {
      if (object instanceof Teleporter &&
          object.getGridX() == x && object.getGridY() == y) {
        return (Teleporter) object;
      }
    }
    return null;
  }

  boolean isAtSameTile(int x1, int y1, int x2, int y2) {
    return x1 == x2 && y1 == y2;
  }

  CreatureDirections getDirection() {
    return direction;
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
