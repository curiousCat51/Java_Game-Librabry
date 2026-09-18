class CollisionResult{
  WorldTypes[] collision_filter;
  boolean success = false;
  
  CollisionResult(){
  }
  
  boolean checkCollision(float move_x, float move_y){
    for( WorldObject object: world_objects){
      if(object.getPixelX() == move_x && object.getPixelY() == move_y){
        for(int i = 0; i < collision_filter.length; i++){
          if(object.getType() != collision_filter[i]){
            success = true;
          }
        }
      }
    }
    
    return success;
  }
  
  void setCollisionFilter(WorldTypes[] collision_filter){
    for(int i = 0; i < collision_filter.length; i++){
     this.collision_filter[i] = collision_filter[i]; 
    }
  }
}
