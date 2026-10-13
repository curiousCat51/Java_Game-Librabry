class CollisionResult {
  WorldTypes collision_filter;
  WorldTypes[] collision_collect;

  void setCollisionFilter(WorldTypes filter) {
    collision_filter = filter;
  }

  void setCollisionCollect(WorldTypes[] collect) {
    collision_collect = collect == null ? null : collect.clone();
  }

  // Statische Kollisionen werden über blocked_tiles geprüft. Dadurch ist
  // die Abfrage O(1) und nicht mehr abhängig von der Anzahl der Wall-Objekte.
  boolean checkCollision(int moveX, int moveY) {
    if (moveX < 0 || moveX >= map_width || moveY < 0 || moveY >= map_height) {
      return false;
    }

    if (blocked_tiles != null && blocked_tiles[moveY][moveX]) {
      return false;
    }

    return true;
  }

  boolean isBlockedByMap(int x, int y) {
    if (x < 0 || x >= map_width || y < 0 || y >= map_height) {
      return true;
    }

    return blocked_tiles != null && blocked_tiles[y][x];
  }

 

  boolean checkForCollect(int moveX, int moveY) {
    if (collision_collect == null) {
      return false;
    }

    for (WorldObject object : world_objects) {
      if (object.getGridX() != moveX || object.getGridY() != moveY) {
        continue;
      }

      for (WorldTypes type : collision_collect) {
        if (object.getType() == type) {
          return true;
        }
      }
    }

    return false;
  }
}
