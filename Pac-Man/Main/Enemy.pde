class Enemy extends Creature{
  NormalImage image_right;
  NormalImage image_left;
  NormalImage image_up;
  NormalImage image_down;
  CreatureDirections way;
  
  // Gegner KI:
  // - Prüfen möglicher Richtungen
  // - Richtung wählen
  // - Richtung folgen bis zu einem Hindernis
  // - Neue Richtung wählen
  
  String iP = "data/images/Ghosts/ghost_";
  int gType;
  
  float chaseProbability;

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
    
    this.gType = gType;
    
    //println("HOCH:   " + canMove(CreatureDirections.HOCH, speed));
    //println("RUNTER: " + canMove(CreatureDirections.RUNTER, speed));
    //println("LINKS:  " + canMove(CreatureDirections.LINKS, speed));
    //println("RECHTS: " + canMove(CreatureDirections.RECHTS, speed));
  }
  
  // Method zur Bewegung
  void move(){
    //println("Direction: " + direction + " | Position: " + getPixelX() + ", " + getPixelY());
    
    // Wahl einer neuen Richtung, wenn ein Feld erreicht wurde
    if(isAtTileCenter()){
      int gridX = (int) convertToGrid(getPixelX());
      int gridY =  (int) convertToGrid(getPixelY());
      
      if(isDecisionTile(gridX, gridY)){
          direction = chooseDirection();
      }
      else if(isDeadEnd(gridX, gridY)){
        direction = way;
      }
        
      //println("CENTER: " + getPixelX() + ", " + getPixelY());
      //println("Chosen direction: " + direction);
      //println("Can move: " + canMove(direction, speed));
    }
      
    // Bewegung anhand der aktuellen Richtung
    switch(direction){
      
      case RECHTS:{
        move(direction, image_right, ENEMY_SPEED);
        break;
      }
      case LINKS:{
        move(direction, image_left, ENEMY_SPEED);
        break;
      }
      case HOCH:{
        move(direction, image_up, ENEMY_SPEED);
        break;
      }
      case RUNTER:{
        move(direction, image_down, ENEMY_SPEED);
        break;
      }
      case NEUTRAL:{
        move(direction, image_left, ENEMY_SPEED);
        break;
      }
    }
  }
  
  // Methode zur Wahl einer neuen Richtung
  CreatureDirections chooseDirection() {
    //println("Current: " + direction + " | Position: " + getPixelX() + ", " + getPixelY());
    
    int gridX = (int)convertToGrid(getPixelX());
    int gridY = (int)convertToGrid(getPixelY());
    
    println("GRID: " + gridX + ", " + gridY);
    println("UP: " + isWallAtGrid(gridX, gridY - 1));
    println("DOWN: " + isWallAtGrid(gridX, gridY + 1));
    println("LEFT: " + isWallAtGrid(gridX - 1, gridY));
    println("RIGHT: " + isWallAtGrid(gridX + 1, gridY));
    
    int availableDirections = 0;
    
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
    
    println("CHOOSE AT: " + getPixelX() + ", " + getPixelY());
    for(CreatureDirections direction : CreatureDirections.values()){
      if(direction == CreatureDirections.NEUTRAL){
        continue;
      }
      
      if(canMove(direction, ENEMY_SPEED) && direction != oppositeDirection(this.direction)){
        availableDirections++;
        float[] position = calculatePotentialPosition(getPixelX(), getPixelY(), direction);
        float distance = calculateDistance(position[0], player.getPixelX(), position[1], player.getPixelY());
        
        println(direction + " | Can move: " + canMove(direction, ENEMY_SPEED) + " | Opposite: " + (direction == oppositeDirection(this.direction)));
        if(distance < smallestDistance && distance != 0){
          smallestDistance = distance;
          bestDirection = direction;
          directionFound = true;
        }
      }
    }
    if(!directionFound){
      CreatureDirections opposite = oppositeDirection(this.direction);
      
      if(canMove(opposite, ENEMY_SPEED)){
        bestDirection = oppositeDirection(this.direction);
      } 
      else {
        //println("WARNING: All directions blocked!");
        bestDirection = this.direction;
      }
    }
    println(availableDirections + " available directions");
    println("SELECTED: " + bestDirection + " | CURRENT: " + this.direction);
    return bestDirection;
  }
  
  //boolean canMove(CreatureDirections dir, float x, float y, float speed)
  
  // Methode zur Berechnung der Entfernung nach der Manhattan-Metrik
  float calculateDistance(float xGhost, float xTarget, float yGhost, float yTarget) {
    return abs(xTarget - xGhost) + abs(yTarget - yGhost);
  }
  
  // Methode zur Berechnung der möglichen nächsten Position
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
      case NEUTRAL:
        break;
    }
  
    return new float[]{nextX, nextY};
  }

  // Methode zur ermittlung der invertierten Richtung
  CreatureDirections oppositeDirection(CreatureDirections dir) {
  
    if (dir == CreatureDirections.RECHTS)
      return CreatureDirections.LINKS;
  
    if (dir == CreatureDirections.LINKS)
      return CreatureDirections.RECHTS;
  
    if (dir == CreatureDirections.HOCH)
      return CreatureDirections.RUNTER;
  
    return CreatureDirections.HOCH;
  }
  
  boolean isWallAtGrid(int gridX, int gridY){

    for(WorldObject object : world_objects){
  
      if(object instanceof Wall){
  
        Wall wall = (Wall) object;
  
        int wallX = (int)convertToGrid(wall.getPixelX());
        int wallY = (int)convertToGrid(wall.getPixelY());
  
        if(wallX == gridX && wallY == gridY){
          return true;
        }
      }
    }
  
    return false;
  }
  
  boolean isDecisionTile(int gridX, int gridY) {
    
    int tilesWithoutWalls = 0;
    ArrayList<CreatureDirections> directions;
    directions = new ArrayList<CreatureDirections>();
    for(CreatureDirections direction : CreatureDirections.values()){
      if(direction == CreatureDirections.NEUTRAL){
        continue;
      }
      float[] position = (float[]) moveDic(direction);
      if(!isWallAtGrid((gridX + (int) position[0]), (gridY + (int) position[1]))){
        tilesWithoutWalls++;
        directions.add(direction);
      }
    }
    if(tilesWithoutWalls == 2){
      if(directions.get(0) == oppositeDirection(directions.get(1))){
        return false;
      }
      return true;
    }
    return tilesWithoutWalls >= 3;
  }
  
  boolean isDeadEnd(int gridX, int gridY){
    int tilesWithoutWalls = 0;
    ArrayList<CreatureDirections> directions;
    directions = new ArrayList<CreatureDirections>();
    for(CreatureDirections direction : CreatureDirections.values()){
      if(direction == CreatureDirections.NEUTRAL){
        continue;
      }
      float[] position = (float[]) moveDic(direction);
      if(!isWallAtGrid((gridX + (int) position[0]), (gridY + (int) position[1]))){
        tilesWithoutWalls++;
        directions.add(direction);
      }
    }
    if(tilesWithoutWalls == 1){
      way = directions.get(0);
      return true;
    }
    else{
      return false;
    }
      
  }
  
  // Methode zum Anzeigen des Geistes
  void display(){
    drawObject();
  }
}
