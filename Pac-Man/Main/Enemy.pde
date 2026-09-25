class Enemy extends Creature{
  ArrayList<GridPosition> visited = new ArrayList<GridPosition>();
  ArrayList<GridPosition> toVisit = new ArrayList<GridPosition>();
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

  Enemy(int grid_x, int grid_y, float speed, int gType){
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
    setImageContainer(image_up);
    
    this.gType = gType;
  }
  
  // Method zur Bewegung
  void move(){

    // Continue an existing movement
      updateMovement();
  
      // Don't choose another tile until we reached the current target
      if(isMoving()){
          return;
      }
  
      if(isAtPlayer()){
          direction = CreatureDirections.NEUTRAL;
          return;
      }
  
      int position[] = getPosition();
  
      if(isDecisionTile(position[0], position[1])){
          direction = chooseDirection();
      }
      else if(isDeadEnd(position[0], position[1])){
          direction = chooseDirection();
      }
      else if(!canMove(direction)){
          direction = getFreeDirection();
      }
  
      switch(direction){
  
        case RECHTS:{
          move(direction, image_right);
          break;
        }
  
        case LINKS:{
          move(direction, image_left);
          break;
        }
  
        case HOCH:{
          move(direction, image_up);
          break;
        }
  
        case RUNTER:{
          move(direction, image_down);
          break;
        }
  
        case NEUTRAL:{
          move(direction, image_left);
          break;
        }
      }
    }
  
  // Methode zur Wahl einer neuen Richtung
  CreatureDirections chooseDirection() {
    int position[] = getPosition();
    GridPosition target = visitLoop();
    
    if(target == null){
      return this.direction;
    }
    
    
    GridPosition current = target;
    
    while(current.previous != null){

        if(current.previous.x == position[0] &&
           current.previous.y == position[1]){
            break;
        }
        
        println("Path node: " + current.x + "," + current.y);
    
        current = current.previous;
    }
  
    if(current.x > position[0]){
      return CreatureDirections.RECHTS;
    }
  
    if(current.x < position[0]){
      return CreatureDirections.LINKS;
    }
  
    if(current.y > position[1]){
      return CreatureDirections.RUNTER;
    }
  
    if(current.y < position[1]){
      return CreatureDirections.HOCH;
    }
    if(position[0] == target.x && position[1] == target.y){
      return CreatureDirections.NEUTRAL;
    }
  
    return this.direction;
  }
  
  // Methode zur Berechnung der Entfernung nach der Manhattan-Metrik
  int calculateDistance(int xGhost, int xTarget, int yGhost, int yTarget) {
    return abs(xTarget - xGhost) + abs(yTarget - yGhost);
  }
  
  // Methode zur Berechnung der möglichen nächsten Position
  int[] calculatePotentialPosition(int x, int y, CreatureDirections direction) {  
    int nextXY[] = moveDic(direction);
    
    int nextX = x + nextXY[0];
    int nextY = y + nextXY[1];
  
    return new int[]{nextX, nextY};
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
  
  
  // Ist bereits eine Wand an einem bestimmten Tile?
  boolean isWallAtGrid(int gridX, int gridY){

    for(WorldObject object : world_objects){
  
      if(object instanceof Wall){
        
        Wall wall = (Wall) object;
        
        int position[] = wall.getPosition();
  
        if(position[0] == gridX && position[1] == gridY){
          return true;
        }
      }
    }
  
    return false;
  }
  
  // Ist das Tile eine Kreuzung/Kurve?
  boolean isDecisionTile(int gridX, int gridY) {
    
    int tilesWithoutWalls = 0;
    
    ArrayList<CreatureDirections> directions;
    directions = new ArrayList<CreatureDirections>();
    
    for(CreatureDirections direction : CreatureDirections.values()){
      if(direction == CreatureDirections.NEUTRAL){
        continue;
      }
      int[] pos = moveDic(direction);
      if(!isWallAtGrid(gridX + pos[0], gridY + pos[1])){
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
  
  // Ist das gewählte Tile eine Sackgasse?
  boolean isDeadEnd(int gridX, int gridY){
    
    int tilesWithoutWalls = 0;
    
    ArrayList<CreatureDirections> directions;
    directions = new ArrayList<CreatureDirections>();
    
    for(CreatureDirections direction : CreatureDirections.values()){
      if(direction == CreatureDirections.NEUTRAL){
        continue;
      }
      int[] pos = moveDic(direction);
      if(!isWallAtGrid(gridX + pos[0], gridY + pos[1])){
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
  
  // Methode um mögliche nächste Feld des Pfades zu ermitteln
  void isToVisit(GridPosition current, CreatureDirections dir){
    int[] pos = moveDic(dir);
    
    int nextX = current.x + pos[0];
    int nextY = current.y + pos[1];
    
    GridPosition next = new GridPosition(nextX, nextY);
    next.previous = current;
    
    if(!isWallAtGrid(nextX, nextY) && !isVisited(next) && !isInToVisit(next)){
      toVisit.add(next);
    }
  }
  
  boolean isInToVisit(GridPosition position){
    for(int i = 0; i < toVisit.size(); i++){
      GridPosition toVisitPosition = toVisit.get(i);
      
      if(toVisitPosition.isSamePosition(position)){
        return true;
      }
    }
    return false;
  }
  
  // Methode um die zu besuchenden Felder in die besuchten Felder hinzuzufügen
  GridPosition visit(int targetX, int targetY){      
    
    GridPosition current = toVisit.get(0);
    
    visited.add(current);
    toVisit.remove(0);
    
    if(current.x == targetX && current.y == targetY){
      return current;
    }
    
    for(CreatureDirections dir : CreatureDirections.values()){
      if(dir == CreatureDirections.NEUTRAL){
        continue;
      }
      isToVisit(current, dir);
    }
    return null;
  }
  
  // Schleifen-Methode für die Wegfindung
  GridPosition visitLoop(){
    
    Player player = null;
    
    for(WorldObject object : world_objects){
      if(object instanceof Player){
        player = (Player) object;
        break;
      }
    }
    
    if(player == null){
      return null;
    }
    
    toVisit.clear();
    visited.clear();
    
    int[] position = getPosition();

    GridPosition start = new GridPosition(position[0], position[1]);
    
    toVisit.add(start);
  
    int targetX = player.getGridX();
    int targetY = player.getGridY();
    
     while(!toVisit.isEmpty()){
       GridPosition found = visit(targetX, targetY);
       if(found != null){
         return found;
       }
     }
     return null;
  }
  
  
  
  // Methode zur Überprüfung, ob ein Feld bereits besucht wurde
  boolean isVisited(GridPosition position){
    for(int i = 0; i < visited.size(); i++){
      GridPosition visite = visited.get(i);
      if(visite.isSamePosition(position)){
        return true;
      }
    }  
    return false;
  }
}
