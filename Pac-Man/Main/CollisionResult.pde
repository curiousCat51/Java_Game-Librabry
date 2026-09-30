class CollisionResult{
  WorldTypes collision_filter;
  WorldTypes[] collision_collect;
  WorldTypes collision_enemy;
  
  CollisionResult(){
  }
  
  void setCollisionFilter(WorldTypes filter){
    collision_filter = filter;
  }
  
  void setCollisionCollect(WorldTypes[] collect){
    
    collision_collect = new WorldTypes[collect.length];
    
    for(int i = 0; i < collect.length; i++){
      collision_collect[i] = collect[i];
    }
  }
  
  void setCollisionEnemy(WorldTypes enemy){
    collision_enemy = enemy;
  }
  
  
  // Collision check für Wände
  boolean checkCollision(int move_x, int move_y){
    
    for( WorldObject object: world_objects){
      
      if(object.getType() == collision_filter){
        Wall wall = (Wall) object;
        
        if(!wall.isPassThrough()){
                 
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
  
  // Collision check für Gegner
  boolean checkForEnemy(int move_x, int move_y){
    
    for(WorldObject object : world_objects){
      
      if(object.getType() == collision_enemy){
        
        Enemy enemy = (Enemy) object;
        
        int[] position = enemy.getPosition();
        int enemy_x = position[0];
        int enemy_y = position[1];
        
        if(move_x == enemy_x && move_y == enemy_y){
          return true;
        }
      }
    }
    return false;
  }
  
  // Collision check für Collectables
  boolean checkForCollect(int move_x, int move_y){
    
    for(WorldObject object : world_objects){
      
      if(object.getType() == collision_collect[0]){
        // FRUITS
        Fruits fruit = (Fruits) object;
        
        int[] position = fruit.getPosition();
        int fruit_x = position[0];
        int fruit_y = position[1];
        
        if(move_x == fruit_x && move_y == fruit_y){
          return true;
        }
      }
      
      if(object.getType() == collision_collect[1]){
        // DOT
        Dot dot = (Dot) object;
        
        int[] position = dot.getPosition();
        int dot_x = position[0];
        int dot_y = position[1];
        
        if(move_x == dot_x && move_y == dot_y){
          return true;
        }
      }
    }
    return false;
  }
}
