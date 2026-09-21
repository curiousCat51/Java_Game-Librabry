class CollisionResult{
  WorldTypes collision_filter;
  
  CollisionResult(){
  }
  
  void setCollisionFilter(WorldTypes filter){
    collision_filter = filter;
  }
  
  boolean checkCollision(float move_x, float move_y){
    float collisionSize = TILE_SIZE * 0.8;
    float halfSize = collisionSize / 2;
    
    
    // Größe der Ghost-Kollisionsbox
    float ghostLeft = move_x - halfSize;
    float ghostRight = move_x + halfSize;
    float ghostTop = move_y - halfSize;
    float ghostBottom = move_y + halfSize;
    
    for( WorldObject object: world_objects){
      if(object.getType() == collision_filter){
        float wallLeft = object.getPixelX() - TILE_SIZE / 2;
        float wallRight = object.getPixelX() + TILE_SIZE / 2;
        float wallTop = object.getPixelY() - TILE_SIZE / 2;
        float wallBottom = object.getPixelY() + TILE_SIZE / 2;
        
       println("Object type: " + object.getType() +
        " | Collision filter: " + collision_filter);
        // println("Object type: " + object.getType() + " | Collision filter: " + collision_filter);
        if (ghostRight > wallLeft && ghostLeft < wallRight && ghostBottom > wallTop && ghostTop < wallBottom) {
          println("Collision with wall at: " + object.getPixelX() + ", " + object.getPixelY() + " | Ghost: " + move_x + ", " + move_y);
          return false;
        }
      }
    }
    return true;
  }
}
