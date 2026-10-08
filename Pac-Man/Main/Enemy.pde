class Enemy extends Creature {
  int GHOST_INKY = 1;
  int GHOST_CLYDE = 2;
  int GHOST_PINKY = 3;
  int GHOST_BLINKY = 4;

  int CLYDE_BLOCK = 0;
  int CLYDE_DETOUR = 1;
  int CLYDE_RETURN = 2;

  AnimationImage image_right;
  AnimationImage image_left;
  AnimationImage image_up;
  AnimationImage image_down;
  AnimationImage image_vul;

  NormalImage image_caught_right;
  NormalImage image_caught_left;
  NormalImage image_caught_up;
  NormalImage image_caught_down;

  int gType;
  int spawn_x;
  int spawn_y;

  boolean caught = false;
  boolean active = true;
  boolean frightened = false;

  int clyde_state = CLYDE_BLOCK;
  GridPosition clyde_target;
  CreatureDirections clyde_detour_direction = CreatureDirections.NEUTRAL;
  int clyde_detour_steps = 0;
  boolean clyde_detour_moving = false;

  Enemy(int grid_x, int grid_y, float speed, int gType) {
    super(WorldTypes.ENEMY, grid_x, grid_y, speed);

    this.gType = gType;
    spawn_x = grid_x;
    spawn_y = grid_y;
    direction = CreatureDirections.LINKS;

    // "color" ist in Processing ein reservierter Datentyp.
    // Daher verwenden wir für den Dateinamen bewusst einen anderen Namen.
    String ghostColorName;
    // Processing verlangt für switch/case konstante Fallwerte.
    // Deshalb werden hier feste Zahlenwerte verwendet.
    if (gType == 1) {
      ghostColorName = "cyan";
    } else if (gType == 2) {
      ghostColorName = "orange";
    } else if (gType == 3) {
      ghostColorName = "pink";
    } else {
      ghostColorName = "red";
    }

    String prefix = "data/images/Ghosts/ghost_" + ghostColorName + "_walk_";
    image_right = new AnimationImage(prefix + "right_", 2, ANIMATION_SPEED);
    image_left = new AnimationImage(prefix + "left_", 2, ANIMATION_SPEED);
    image_up = new AnimationImage(prefix + "up_", 2, ANIMATION_SPEED);
    image_down = new AnimationImage(prefix + "down_", 2, ANIMATION_SPEED);

    image_vul = new AnimationImage(
      "data/images/Ghosts/ghost_vul_", 4, ANIMATION_SPEED
    );

    image_caught_right = new NormalImage("data/images/Ghosts/ghost_cought_walk_right");
    image_caught_left = new NormalImage("data/images/Ghosts/ghost_cought_walk_left");
    image_caught_up = new NormalImage("data/images/Ghosts/ghost_cought_walk_up");
    image_caught_down = new NormalImage("data/images/Ghosts/ghost_cought_walk_down");

    setImageContainer(image_left);
  }

  void move() {
    updateMovement();

    if (isMoving()) {
      return;
    }

    updateStateAfterArrival();

    if (caught) {
      direction = chooseDirectionTo(spawn_x, spawn_y);
      startMoveIfPossible(direction);
      return;
    }

    if (!active) {
      return;
    }

    if (powerMode && frightened) {
      chooseFrightenedDirection();
    } else {
      chooseNormalDirection();
    }

    if (!canMove(direction)) {
      direction = getFreeDirection();
    }

    startMoveIfPossible(direction);
  }

  void updateStateAfterArrival() {
    if (caught && isAtSpawn()) {
      caught = false;
      active = true;
      frightened = false;
      clyde_state = CLYDE_BLOCK;
      clyde_target = null;
      clyde_detour_moving = false;
      clyde_detour_steps = 0;
      return;
    }

    if (gType != GHOST_CLYDE) {
      return;
    }

    if (clyde_state == CLYDE_BLOCK && hasReachedClydeTarget()) {
      clyde_state = CLYDE_DETOUR;
      clyde_detour_steps = 4;
      clyde_detour_moving = false;
    } else if (clyde_state == CLYDE_DETOUR &&
               clyde_detour_moving) {
      clyde_detour_moving = false;
      clyde_detour_steps--;

      if (clyde_detour_steps <= 0) {
        clyde_state = CLYDE_RETURN;
      }
    } else if (clyde_state == CLYDE_RETURN && hasReachedClydeTarget()) {
      clyde_state = CLYDE_BLOCK;
      clyde_target = null;
    }
  }

  void chooseNormalDirection() {
    if (gType == GHOST_CLYDE) {
      if (clyde_state == CLYDE_DETOUR) {
        direction = getRandomDirection(true);
        clyde_detour_direction = direction;
        clyde_detour_moving = true;
        return;
      }

      if (clyde_state == CLYDE_RETURN && clyde_target != null) {
        direction = chooseDirectionTo(clyde_target.x, clyde_target.y);
        return;
      }
    }

    if (isDecisionTile(grid_x, grid_y) || isDeadEnd(grid_x, grid_y)) {
      direction = chooseDirection();
    }
  }

  void chooseFrightenedDirection() {
    CreatureDirections reverse = oppositeDirection(direction);

    if (isDecisionTile(grid_x, grid_y) || isDeadEnd(grid_x, grid_y)) {
      direction = getRandomDirectionWithoutReverse(reverse);
    }
  }

  void startMoveIfPossible(CreatureDirections chosen) {
    if (chosen == CreatureDirections.NEUTRAL || !canMove(chosen)) {
      return;
    }

    move(chosen, getImageForDirection(chosen));
  }

  ImageContainer getImageForDirection(CreatureDirections chosen) {
    if (caught) {
      if (chosen == CreatureDirections.RECHTS) return image_caught_right;
      if (chosen == CreatureDirections.LINKS) return image_caught_left;
      if (chosen == CreatureDirections.HOCH) return image_caught_up;
      return image_caught_down;
    }

    if (powerMode && frightened) {
      return image_vul;
    }

    if (chosen == CreatureDirections.RECHTS) return image_right;
    if (chosen == CreatureDirections.LINKS) return image_left;
    if (chosen == CreatureDirections.HOCH) return image_up;
    return image_down;
  }

  // ------------------------------------------------------------
  // Zielwahl
  // ------------------------------------------------------------

  CreatureDirections chooseDirection() {
    int[] target = getCurrentTarget();
    return chooseDirectionTo(target[0], target[1]);
  }

  CreatureDirections chooseDirectionTo(int targetX, int targetY) {
    targetX = constrain(targetX, 0, map_width - 1);
    targetY = constrain(targetY, 0, map_height - 1);

    GridPosition nextStep = findNextPathStep(grid_x, grid_y, targetX, targetY);
    if (nextStep == null) {
      return direction;
    }

    if (nextStep.x > grid_x) return CreatureDirections.RECHTS;
    if (nextStep.x < grid_x) return CreatureDirections.LINKS;
    if (nextStep.y > grid_y) return CreatureDirections.RUNTER;
    if (nextStep.y < grid_y) return CreatureDirections.HOCH;

    return direction;
  }

  int[] getCurrentTarget() {
    if (player == null) {
      return new int[] {spawn_x, spawn_y};
    }

    if (caught) {
      return new int[] {spawn_x, spawn_y};
    }

    int playerX = player.getGridX();
    int playerY = player.getGridY();

    if (gType == 1) {
      Enemy blinky = getBlinky();
      if (blinky == null) return new int[] {playerX, playerY};
      return calcVector(
        blinky.getGridX(), blinky.getGridY(), playerX, playerY
      );
    }

    if (gType == 2) {
      if (clyde_state == CLYDE_RETURN && clyde_target != null) {
        return new int[] {clyde_target.x, clyde_target.y};
      }

      if (calculateDistance(playerX, playerY) > 4) {
        clyde_target = null;
        return new int[] {playerX, playerY};
      }

      if (clyde_target == null) {
        clyde_target = chooseClydeTarget(player);
      }

      return new int[] {clyde_target.x, clyde_target.y};
    }

    if (gType == 3) {
      int[] playerMove = moveDic(player.getDirection());
      return new int[] {
        constrain(playerX + 4 * playerMove[0], 0, map_width - 1),
        constrain(playerY + 4 * playerMove[1], 0, map_height - 1)
      };
    }

    return new int[] {playerX, playerY};
  }

  Enemy getBlinky() {
    for (Enemy enemy : enemies) {
      if (enemy.gType == GHOST_BLINKY) {
        return enemy;
      }
    }
    return null;
  }

  int[] calcVector(int blinkyX, int blinkyY, int playerX, int playerY) {
    return new int[] {
      constrain(playerX + 2 * (playerX - blinkyX), 0, map_width - 1),
      constrain(playerY + 2 * (playerY - blinkyY), 0, map_height - 1)
    };
  }

  GridPosition chooseClydeTarget(Player targetPlayer) {
    int[] move = moveDic(targetPlayer.getDirection());
    int targetX = constrain(targetPlayer.getGridX() + 4 * move[0], 0, map_width - 1);
    int targetY = constrain(targetPlayer.getGridY() + 4 * move[1], 0, map_height - 1);
    return new GridPosition(targetX, targetY);
  }

  boolean hasReachedClydeTarget() {
    return clyde_target != null &&
           grid_x == clyde_target.x && grid_y == clyde_target.y;
  }

  // ------------------------------------------------------------
  // Frightened / caught
  // ------------------------------------------------------------

  void startFrightened() {
    if (frightened || caught || !active) {
      return;
    }

    frightened = true;
    CreatureDirections reverse = oppositeDirection(direction);

    if (canMove(reverse)) {
      direction = reverse;
    }
  }

  void endFrightened() {
    frightened = false;

    if (gType == GHOST_CLYDE) {
      clyde_state = CLYDE_BLOCK;
      clyde_target = null;
      clyde_detour_moving = false;
      clyde_detour_steps = 0;
    }
  }

  void getCaught() {
    if (!frightened || caught) {
      return;
    }

    caught = true;
    frightened = false;
    active = false;
    direction = oppositeDirection(direction);
  }

  // ------------------------------------------------------------
  // Wegfindung - BFS ohne ArrayList.remove(0)
  // ------------------------------------------------------------

  GridPosition findNextPathStep(int startX, int startY, int targetX, int targetY) {
    if (startX == targetX && startY == targetY) {
      return null;
    }

    if (startX < 0 || startX >= map_width || startY < 0 || startY >= map_height ||
        targetX < 0 || targetX >= map_width || targetY < 0 || targetY >= map_height) {
      return null;
    }

    if (collision.isBlockedByMap(startX, startY) || collision.isBlockedByMap(targetX, targetY)) {
      return null;
    }

    boolean[][] visited = new boolean[map_height][map_width];
    GridPosition[][] previous = new GridPosition[map_height][map_width];
    ArrayDeque<GridPosition> queue = new ArrayDeque<GridPosition>();

    GridPosition start = new GridPosition(startX, startY);
    visited[startY][startX] = true;
    queue.addLast(start);

    CreatureDirections[] directions = {
      CreatureDirections.HOCH,
      CreatureDirections.RUNTER,
      CreatureDirections.LINKS,
      CreatureDirections.RECHTS
    };

    GridPosition found = null;

    while (!queue.isEmpty()) {
      GridPosition current = queue.removeFirst();

      if (current.x == targetX && current.y == targetY) {
        found = current;
        break;
      }

      for (CreatureDirections dir : directions) {
        int nextX = current.x + directionDeltaX(dir);
        int nextY = current.y + directionDeltaY(dir);

        if (nextX < 0 || nextX >= map_width ||
            nextY < 0 || nextY >= map_height) {
          continue;
        }

        if (visited[nextY][nextX] || collision.isBlockedByMap(nextX, nextY)) {
          continue;
        }

        visited[nextY][nextX] = true;
        previous[nextY][nextX] = current;
        queue.addLast(new GridPosition(nextX, nextY));
      }
    }

    if (found == null) {
      return null;
    }

    GridPosition current = found;
    while (current != null) {
      GridPosition parent = previous[current.y][current.x];
      if (parent == null || (parent.x == startX && parent.y == startY)) {
        return current;
      }
      current = parent;
    }

    return null;
  }

  // ------------------------------------------------------------
  // Grid-Hilfen
  // ------------------------------------------------------------

  boolean isWallAtGrid(int gridX, int gridY) {
    return collision.isBlockedByMap(gridX, gridY);
  }

  int countFreeNeighbors(int gridX, int gridY) {
    int count = 0;
    if (!isWallAtGrid(gridX + 1, gridY)) count++;
    if (!isWallAtGrid(gridX - 1, gridY)) count++;
    if (!isWallAtGrid(gridX, gridY + 1)) count++;
    if (!isWallAtGrid(gridX, gridY - 1)) count++;
    return count;
  }

  boolean isDecisionTile(int gridX, int gridY) {
    int freeNeighbors = countFreeNeighbors(gridX, gridY);
    if (freeNeighbors >= 3) return true;
    if (freeNeighbors != 2) return false;

    boolean horizontal = !isWallAtGrid(gridX - 1, gridY) &&
                         !isWallAtGrid(gridX + 1, gridY);
    boolean vertical = !isWallAtGrid(gridX, gridY - 1) &&
                       !isWallAtGrid(gridX, gridY + 1);

    return !(horizontal || vertical);
  }

  boolean isDeadEnd(int gridX, int gridY) {
    return countFreeNeighbors(gridX, gridY) == 1;
  }

  CreatureDirections getRandomDirection(boolean allowReverse) {
    return getRandomDirectionWithoutReverse(
      allowReverse ? CreatureDirections.NEUTRAL : oppositeDirection(direction)
    );
  }

  CreatureDirections getRandomDirectionWithoutReverse(CreatureDirections reverse) {
    CreatureDirections[] candidates = new CreatureDirections[4];
    int count = 0;

    CreatureDirections[] directions = {
      CreatureDirections.HOCH,
      CreatureDirections.RUNTER,
      CreatureDirections.LINKS,
      CreatureDirections.RECHTS
    };

    for (CreatureDirections candidate : directions) {
      if (candidate != reverse && canMove(candidate)) {
        candidates[count++] = candidate;
      }
    }

    if (count > 0) {
      return candidates[int(random(count))];
    }

    if (reverse != CreatureDirections.NEUTRAL && canMove(reverse)) {
      return reverse;
    }

    return getFreeDirection();
  }

  CreatureDirections oppositeDirection(CreatureDirections dir) {
    if (dir == CreatureDirections.RECHTS) return CreatureDirections.LINKS;
    if (dir == CreatureDirections.LINKS) return CreatureDirections.RECHTS;
    if (dir == CreatureDirections.HOCH) return CreatureDirections.RUNTER;
    if (dir == CreatureDirections.RUNTER) return CreatureDirections.HOCH;
    return CreatureDirections.NEUTRAL;
  }

  int calculateDistance(int targetX, int targetY) {
    return abs(targetX - grid_x) + abs(targetY - grid_y);
  }

  int getGType() { return gType; }
  boolean isAtSpawn() { return grid_x == spawn_x && grid_y == spawn_y; }
}
