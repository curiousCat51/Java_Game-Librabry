class Enemy extends Creature{
  NormalImage image_right;
  NormalImage image_left;
  NormalImage image_up;
  NormalImage image_down;
  
  String iP = "data/images/Ghosts/ghost_";
  int gType;
  
  Enemy(float grid_x, float grid_y, float speed, int gType){
    super(WorldTypes.ENEMY, grid_x, grid_y, speed);
    
    if(gType == 1){
      iP = iP + "cyan_walk_";
    }
    else if(gType == 2){
      iP = iP + "orange_walk_";
    }
    else if(gType == 3){
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
    
    this.gType = gType;
  }
  
  void move(float rnd){
    if(rnd == 1){
      changeDirection(CreatureDirections.RECHTS);
      move(TILE_SIZE / SCALE, 0, CreatureDirections.RECHTS, image_right, ENEMY_SPEED);
    }
    if(rnd == 2){
      changeDirection(CreatureDirections.LINKS);
      move(-(TILE_SIZE/SCALE), 0, CreatureDirections.LINKS, image_left, ENEMY_SPEED);
    }
    if(rnd == 3){
      changeDirection(CreatureDirections.HOCH);
      move(0, TILE_SIZE/SCALE, CreatureDirections.HOCH, image_up, ENEMY_SPEED);
    }
    if(rnd == 4){
      changeDirection(CreatureDirections.RUNTER);
      move(0, -(TILE_SIZE/SCALE), CreatureDirections.RUNTER, image_down, ENEMY_SPEED);
    }
  }
  
  float randomDirection(){
   return random(0, 4); 
  }
  
  void display(){
    drawObject();
  }
}
