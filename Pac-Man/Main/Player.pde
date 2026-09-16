class Player extends Creature{
  AnimationImage image_right;
  AnimationImage image_left;
  
  Player(float grid_x, float grid_y, float speed){
    super(WorldTypes.PLAYER, grid_x, grid_y, speed);
    image_right = new AnimationImage("data/images/Pac-Man/pac-man_walk_right_", 4, ANIMATION_SPEED);
    image_left = new AnimationImage("data/images/Pac-Man/pac-man_walk_left_", 4, ANIMATION_SPEED);
    setImageContainer(image_right);
    setImageContainer(image_left);
  }
  
  // move
  // update
}
