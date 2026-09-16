class Enemy extends Creature{
  NormalImage image_right;
  NormalImage image_left;
  NormalImage image_up;
  NormalImage image_down;
  
  String iP = "data/images/Ghosts/ghost_";
  
  Enemy(float grid_x, float grid_y, float speed, int type){
    super(WorldTypes.ENEMY, grid_x, grid_y, speed);
    
    if(type == 1){
      iP = iP + "cyan_walk_";
    }
    else if(type == 2){
      iP = iP + "orange_walk_";
    }
    else if(type == 3){
      iP = iP + "pink_walk_";
    }
    else{
      iP = iP + "red_walk_";
    }
    
    image_right = new NormalImage(iP + "right");
    image_left = new NormalImage(iP + "left");
    image_up = new NormalImage(iP + "up");
    image_down = new NormalImage(iP + "down");
    
    setImageContainer(image_right);
    // collision
  }
  
  // move
  // randomDirection
}
