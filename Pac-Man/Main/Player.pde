class Player extends Creature{
  AnimationImage image_right;
  AnimationImage image_left;
  CollisionResult collision = new CollisionResult();
  
  float[] position = {
    0, 1, -1
  };

  
  Player(float grid_x, float grid_y, float speed){
    super(WorldTypes.PLAYER, grid_x, grid_y, speed);
    image_right = new AnimationImage("data/images/Pac-Man/pac-man_walk_right_", 4, ANIMATION_SPEED);
    image_left = new AnimationImage("data/images/Pac-Man/pac-man_walk_left_", 4, ANIMATION_SPEED);
    setImageContainer(image_left);
    this.grid_x = grid_x;
    this.grid_y = grid_y;
    
    
    collision.setCollisionFilter(WorldTypes.WALL);
  }
  
  void move(){
    if(EventListener.getKeyUP()){
      move(position[0], position[2], CreatureDirections.HOCH, image_left, PLAYER_SPEED);
    }
    
    if(EventListener.getKeyDOWN()){
      move(position[0], position[1], CreatureDirections.RUNTER, image_right, PLAYER_SPEED);
    }
    
    if(EventListener.getKeyLEFT()){
      move(position[2], position[0], CreatureDirections.LINKS, image_left, PLAYER_SPEED);
    }
    
    if(EventListener.getKeyRIGHT()){
      move(position[1], position[0], CreatureDirections.RECHTS, image_right, PLAYER_SPEED);
    }
    
    // TODO replace a maploaded tile with the player if not a wall or enemy
  }
}
