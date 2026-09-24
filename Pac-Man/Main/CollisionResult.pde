class CollisionResult{
  WorldTypes collision_filter;
  WorldTypes collision_exclude;
  
  CollisionResult(){
  }
  
  void setCollisionFilter(WorldTypes filter){
    collision_filter = filter;
  }
  
  boolean checkCollision(float move_x, float move_y, float speed){
    float collisionSize = TILE_SIZE * speed / 2;
    float halfSize = collisionSize / 2;
    
    
    // Größe der Kollisionsbox
    float creatureLeft = move_x - halfSize;
    float creatureRight = move_x + halfSize;
    float creatureTop = move_y - halfSize;
    float creatureBottom = move_y + halfSize;
    
    for( WorldObject object: world_objects){
      
      if(object.getType() == collision_filter){
        Wall wall = (Wall) object;
        
        if(wall.getWallType() != 0){
          float wallLeft = object.getPixelX() - TILE_SIZE / 2;
          float wallRight = object.getPixelX() + TILE_SIZE / 2;
          float wallTop = object.getPixelY() - TILE_SIZE / 2; 
          float wallBottom = object.getPixelY() + TILE_SIZE / 2; 
          
          // println("Object type: " + object.getType() + " | Collision filter: " + collision_filter);
          
          
          if (creatureRight > wallLeft && creatureLeft < wallRight && creatureBottom > wallTop && creatureTop < wallBottom) {
            //println("Collision with wall at: " + object.getPixelX() + ", " + object.getPixelY() + " | Ghost: " + move_x + ", " + move_y);
            return false;
          }
        }
      }
    }
    return true;
  }
}
