class CollisionResult{
  WorldTypes collision_filter;
  WorldTypes collision_exclude;
  
  CollisionResult(){
  }
  
  void setCollisionFilter(WorldTypes filter){
    collision_filter = filter;
  }
  
  boolean checkCollision(int move_x, int move_y){
    
    for( WorldObject object: world_objects){
      
      if(object.getType() == collision_filter){
        Wall wall = (Wall) object;
        
        if(wall.getWallType() == 0){
          return true;
        }
        else{
          
          int[] position = wall.getPosition();
          int wall_x = position[0];
          int wall_y = position[1];
          
          
          if (move_x == wall_x && move_y == wall_y) {
            return false;
          }
        }
      }
    }
    return true;
  }
}
