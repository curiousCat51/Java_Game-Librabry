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
    
    //println("Ghost spawned at grid: " + grid_x + ", " + grid_y);
    //println("Ghost spawned at pixel: " + getPixelX() + ", " + getPixelY());
  }
  
  void move(){
    // Prüfen, ob die aktuelle Richtung blockiert ist
    if(isAtTileCenter() && !canMove(direction)){
      snapToTileCenter();
      direction = chooseDirection();
      
      //println("New direction: " + direction);
    }
    println("Ghost position: " + getPixelX() + ", " + getPixelY());
    // Bewegung anhand der aktuellen Richtung
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
  
  boolean canMove(CreatureDirections dir) {

    float x = 0;
    float y = 0;

    if (dir == CreatureDirections.RECHTS) x = 1;
    if (dir == CreatureDirections.LINKS)   x = -1;
    if (dir == CreatureDirections.HOCH)    y = -1;
    if (dir == CreatureDirections.RUNTER)  y = 1;

    return collision.checkCollision(getPixelX() + x * ENEMY_SPEED, getPixelY() + y * ENEMY_SPEED);
  }
  
  boolean isAtTileCenter() {
    float centerX = convertToPixel(convertToGrid(getPixelX()));
    float centerY = convertToPixel(convertToGrid(getPixelY()));
  
    return abs(getPixelX() - centerX) < 2.0 &&
           abs(getPixelY() - centerY) < 2.0;
  }
  
  CreatureDirections chooseDirection() {
    //println("Current: " + direction + " | Position: " + getPixelX() + ", " + getPixelY());
    
    Player player = null;
    float smallestDistance = Float.MAX_VALUE;
    CreatureDirections bestDirection = null;
    boolean directionFound = false;
    
    for(WorldObject object: world_objects){
      if(object instanceof Player){
        player = (Player) object;
        break;
      }
    }
    
    if(player == null){
      return this.direction;
    }
    
    for(CreatureDirections direction : CreatureDirections.values()){
      
      //println(direction + " | Can move: " + canMove(direction));
      if(isAtTileCenter() && canMove(direction) && direction != oppositeDirection(this.direction)){
        float[] position = calculatePotentialPosition(getPixelX(), getPixelY(), direction);
        float distance = calculateDistance(position[0], player.getPixelX(), position[1], player.getPixelY());
        
        if(distance < smallestDistance){
          smallestDistance = distance;
          bestDirection = direction;
          directionFound = true;
        }
      }
    }
    if(!directionFound){
      CreatureDirections opposite = oppositeDirection(this.direction);
      
      if(canMove(opposite)){
        bestDirection = oppositeDirection(this.direction);
      } 
      else {
        //println("WARNING: All directions blocked!");
        bestDirection = this.direction;
      }
    }
    
    return bestDirection;
  }
  
  float calculateDistance(float xGhost, float xTarget, float yGhost, float yTarget) {
    return abs(xTarget - xGhost) + abs(yTarget - yGhost);
  }
  
  float[] calculatePotentialPosition(float x, float y, CreatureDirections direction) {
    float nextX = x;
    float nextY = y;
  
    switch (direction) {
      case RECHTS:
        nextX += ENEMY_SPEED;
        break;
  
      case LINKS:
        nextX -= ENEMY_SPEED;
        break;
  
      case HOCH:
        nextY -= ENEMY_SPEED;
        break;
  
      case RUNTER:
        nextY += ENEMY_SPEED;
        break;
    }
  
    return new float[]{nextX, nextY};
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
  
  void display(){
    drawObject();
  }
}
