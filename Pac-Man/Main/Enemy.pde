class Enemy extends Creature{
  NormalImage image_right;
  NormalImage image_left;
  NormalImage image_up;
  NormalImage image_down;
  CollisionResult collision = new CollisionResult();
  
  String iP = "data/images/Ghosts/ghost_";
  int gType;
  
  float chaseProbability;
  float decisionTimer;
  
  float[] position = {
    0, 1, -1
  };
  
  Enemy(float grid_x, float grid_y, float speed, int gType){
    super(WorldTypes.ENEMY, grid_x, grid_y, speed);
    
    if(gType == 1){
      iP = iP + "cyan_walk_";
      chaseProbability = 0.25;
    }
    else if(gType == 2){
      iP = iP + "orange_walk_";
      chaseProbability = 0.15;
    }
    else if(gType == 3){
      iP = iP + "pink_walk_";
      chaseProbability = 0.40;
    }
    else{
      iP = iP + "red_walk_";
      chaseProbability = 0.60;
    }
    
    image_right = new NormalImage(iP + "right");
    image_left = new NormalImage(iP + "left");
    image_up = new NormalImage(iP + "up");
    image_down = new NormalImage(iP + "down");
    
    setImageContainer(image_left);
    collision.setCollisionFilter(WorldTypes.WALL);
    
    this.gType = gType;
  }
  
  void move(){
    if(!canMove(direction)){
      chooseDirection();
    }
    
    switch(direction){
      
      case RECHTS:{
        move(position[1], position[0], direction, image_right, ENEMY_SPEED);
        break;
      }
      case LINKS:{
        move(position[2], position[0], direction, image_left, ENEMY_SPEED);
        break;
      }
      case HOCH:{
        move(position[0], position[2], direction, image_up, ENEMY_SPEED);
        break;
      }
      case RUNTER:{
        move(position[0], position[1], direction, image_down, ENEMY_SPEED);
        break;
      }
    }
  }
  
  void chooseDirection() {
    
    Player player = null;
    
    for(int i = 0; i < world_objects.size(); i++){
      WorldObject object = (WorldObject) world_objects.get(i);
      if(object instanceof Player){
        player = (Player) object;
        break;
      }
    }

    if (player != null && random(1) < chaseProbability) {
      chooseDirectionTowardsPlayer(player);
    }
    else {
      chooseRandomDirection();
    }

    ArrayList<CreatureDirections> possible =
      new ArrayList<CreatureDirections>();

    if (canMove(CreatureDirections.RECHTS))
      possible.add(CreatureDirections.RECHTS);

    if (canMove(CreatureDirections.LINKS))
      possible.add(CreatureDirections.LINKS);

    if (canMove(CreatureDirections.HOCH))
      possible.add(CreatureDirections.HOCH);

    if (canMove(CreatureDirections.RUNTER))
      possible.add(CreatureDirections.RUNTER);

    if (possible.size() == 0)
      return;

    direction = possible.get(
      int(random(possible.size()))
    );
  }
  

  
  void chooseDirectionTowardsPlayer(Player player) {

    float dx = player.getPixelX() - getPixelX();
    float dy = player.getPixelY() - getPixelY();
  
    if (abs(dx) > abs(dy)) {
  
      if (dx > 0 && canMove(CreatureDirections.RECHTS)) {
        direction = CreatureDirections.RECHTS;
        return;
      }
  
      if (dx < 0 && canMove(CreatureDirections.LINKS)) {
        direction = CreatureDirections.LINKS;
        return;
      }
  
    } else {
  
      if (dy > 0 && canMove(CreatureDirections.RUNTER)) {
        direction = CreatureDirections.RUNTER;
        return;
      }
  
      if (dy < 0 && canMove(CreatureDirections.HOCH)) {
        direction = CreatureDirections.HOCH;
        return;
      }
    }
  
    // Desired direction blocked → fall back to random
    chooseDirection();
}

  CreatureDirections oppositeDirection(CreatureDirections dir) {
  
    if (dir == CreatureDirections.RECHTS)
      return CreatureDirections.LINKS;
  
    if (dir == CreatureDirections.LINKS)
      return CreatureDirections.RECHTS;
  
    if (dir == CreatureDirections.HOCH)
      return CreatureDirections.RUNTER;
  
    return CreatureDirections.HOCH;
  }
  
  boolean canMove(CreatureDirections dir) {

    float x = 0;
    float y = 0;

    if (dir == CreatureDirections.RECHTS) x = 1;
    if (dir == CreatureDirections.LINKS)   x = -1;
    if (dir == CreatureDirections.HOCH)    y = -1;
    if (dir == CreatureDirections.RUNTER)  y = 1;

    return collision.checkCollision(
      getPixelX() + x * ENEMY_SPEED,
      getPixelY() + y * ENEMY_SPEED
    );
  }

  void chooseRandomDirection() {

  ArrayList<CreatureDirections> possible =
    new ArrayList<CreatureDirections>();

  CreatureDirections opposite = oppositeDirection(direction);

  if (direction != CreatureDirections.LINKS &&
      canMove(CreatureDirections.RECHTS))
    possible.add(CreatureDirections.RECHTS);

  if (direction != CreatureDirections.RECHTS &&
      canMove(CreatureDirections.LINKS))
    possible.add(CreatureDirections.LINKS);

  if (direction != CreatureDirections.RUNTER &&
      canMove(CreatureDirections.HOCH))
    possible.add(CreatureDirections.HOCH);

  if (direction != CreatureDirections.HOCH &&
      canMove(CreatureDirections.RUNTER))
    possible.add(CreatureDirections.RUNTER);

  if (possible.size() > 0) {
    direction = possible.get(int(random(possible.size())));
  }
  else if (canMove(opposite)) {
    direction = opposite;
  }
}

  boolean isAtTileCenter(){
    
    float gridX = convertToGrid(getPixelX());
    float gridY = convertToGrid(getPixelY());
    
    if(convertToPixel(gridX) == getPixelX() && convertToPixel(gridY) == getPixelY()){
      return true;
    }
    
    return false;
  }
  
  void display(){
    drawObject();
  }
}
