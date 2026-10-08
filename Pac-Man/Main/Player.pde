class Player extends Creature {
  AnimationImage image_right;
  AnimationImage image_left;

  int spawn_x;
  int spawn_y;
  boolean enemy_hit = false;

  Player(int grid_x, int grid_y, float speed) {
    super(WorldTypes.PLAYER, grid_x, grid_y, speed);

    image_right = new AnimationImage(
      "data/images/Pac-Man/pac-man_walk_right_", 4, ANIMATION_SPEED
    );
    image_left = new AnimationImage(
      "data/images/Pac-Man/pac-man_walk_left_", 4, ANIMATION_SPEED
    );

    setImageContainer(image_left);

    spawn_x = grid_x;
    spawn_y = grid_y;

    collision.setCollisionEnemy(WorldTypes.ENEMY);
    collision.setCollisionCollect(new WorldTypes[] {
      WorldTypes.FRUIT,
      WorldTypes.DOT
    });
  }

  void move() {
    handleEnemyCollision();
    collect();

    readInput();

    // Eine laufende Bewegung wird zuerst vollständig fortgesetzt.
    updateMovement();
    if (isMoving()) {
      return;
    }

    // Wunschrichtung hat Vorrang.
    if (wish_direction != CreatureDirections.NEUTRAL &&
        canMove(wish_direction)) {
      startMoveWithDirection(wish_direction);
      return;
    }

    // Sonst die aktuelle Richtung beibehalten.
    if (direction != CreatureDirections.NEUTRAL && canMove(direction)) {
      startMoveWithDirection(direction);
    }
  }

  void readInput() {
    if (EventListener.getKeyUP()) {
      wish_direction = CreatureDirections.HOCH;
    } else if (EventListener.getKeyDOWN()) {
      wish_direction = CreatureDirections.RUNTER;
    } else if (EventListener.getKeyLEFT()) {
      wish_direction = CreatureDirections.LINKS;
    } else if (EventListener.getKeyRIGHT()) {
      wish_direction = CreatureDirections.RECHTS;
    }
  }

  void startMoveWithDirection(CreatureDirections chosen) {
    ImageContainer image = getImageForDirection(chosen);
    move(chosen, image);
  }

  ImageContainer getImageForDirection(CreatureDirections chosen) {
    if (chosen == CreatureDirections.LINKS || chosen == CreatureDirections.HOCH) {
      return image_left;
    }
    return image_right;
  }

  void handleEnemyCollision() {
    if (!collision.checkForEnemy(grid_x, grid_y)) {
      enemy_hit = false;
      return;
    }

    Enemy enemy = collision.hit_enemy;
    if (enemy == null || enemy_hit) {
      return;
    }

    enemy_hit = true;

    if (powerMode && enemy.frightened && !enemy.caught) {
      enemy.getCaught();
      score += ghost_score;
      ghost_score *= 2;
      checkBonusLife();
      return;
    }

    if (!powerMode) {
      hud.loseLife();
      // Spieler bleibt logisch auf dem aktuellen Tile. Eine vollständige
      // Respawn-Animation kann später ergänzt werden.
    }
  }

  void collect() {
    for (int i = world_objects.size() - 1; i >= 0; i--) {
      WorldObject object = world_objects.get(i);

      if (object.getGridX() != grid_x || object.getGridY() != grid_y) {
        continue;
      }

      if (object instanceof Dot) {
        ((Dot) object).collect();
        checkBonusLife();
        return;
      }

      if (object instanceof Fruits) {
        ((Fruits) object).collect();
        return;
      }
    }
  }

  CreatureDirections getWishDirection() {
    return wish_direction;
  }
}
