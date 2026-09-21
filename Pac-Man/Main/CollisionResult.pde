class CollisionResult{
  WorldTypes collision_filter;
  
  CollisionResult(){
  }
  
  void setCollisionFilter(WorldTypes filter){
    collision_filter = filter;
  }
  
  boolean checkCollision(float move_x, float move_y){
    for( WorldObject object: world_objects){
      if(object.getPixelX() == move_x && object.getPixelY() == move_y){
        if(object.getType() == collision_filter){
            return false;
        }
      }
    }
    return true;
  }
}
