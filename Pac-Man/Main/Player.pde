class Player extends Creature{
  AnimationImage image_right;
  AnimationImage image_left;

  
  Player(float grid_x, float grid_y, float speed){
    super(WorldTypes.PLAYER, grid_x, grid_y, speed);
    image_right = new AnimationImage("data/images/Pac-Man/pac-man_walk_right_", 4, ANIMATION_SPEED);
    image_left = new AnimationImage("data/images/Pac-Man/pac-man_walk_left_", 4, ANIMATION_SPEED);
    setImageContainer(image_left);
    this.grid_x = grid_x;
    this.grid_y = grid_y;
  }
  
  void move(){
    if(EventListener.getKeyUP()){
      update(0, 1, CreatureDirections.HOCH, image_left);
    }
    if(EventListener.getKeyDOWN()){
      update(0, -1, CreatureDirections.RUNTER, image_right);
    }
    if(EventListener.getKeyLEFT()){
      update(-1, 0, CreatureDirections.LINKS, image_left);
    }
    if(EventListener.getKeyRIGHT()){
      update(1, 0, CreatureDirections.RECHTS, image_right);
    }
  }
  void update(float pixel_x, float pixel_y, CreatureDirections direction, AnimationImage image){
    changeDirection(direction);
    update(pixel_x, pixel_y, WorldTypes.PLAYER, image, PLAYER_SPEED);
  }
}
