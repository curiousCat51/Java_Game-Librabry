class Enemy extends Creature{
  ArrayList<GridPosition> visited = new ArrayList<GridPosition>();
  ArrayList<GridPosition> toVisit = new ArrayList<GridPosition>();
  AnimationImage image_right;
  AnimationImage image_left;
  AnimationImage image_up;
  AnimationImage image_down;
  AnimationImage image_vul;
  NormalImage image_cought_right;
  NormalImage image_cought_left;
  NormalImage image_cought_up;
  NormalImage image_cought_down;
  CreatureDirections way;
  CreatureDirections previous_direction;
  
  // Gegner KI:
  // - Prüfen möglicher Richtungen
  // - Richtung wählen
  // - Richtung folgen bis zu einem Hindernis
  // - Neue Richtung wählen
  
  String path = "data/images/Ghosts/ghost_";
  String iP = path;
  int gType;
  String pattern;
  int spawn_x;
  int spawn_y;
  boolean cought = false;

  Enemy(int grid_x, int grid_y, float speed, int gType){
    super(WorldTypes.ENEMY, grid_x, grid_y, speed);
    
    spawn_x = grid_x;
    spawn_y = grid_y;
    
    previous_direction = direction;
    
    switch(gType){
      case 1: iP = iP + "cyan_walk_"; break; // Inky bewegt sich abhängig von Pac-Man and Blinkys Position
      case 2: iP = iP + "orange_walk_"; break; // Clyde wechselt zwischen Pac-Man nähern und vor Pac-Man fliehen
      case 3: iP = iP + "pink_walk_"; break; // Pinky schneidet Wege ab (Pac-Man's aktuelle Position + 4 Felder in Pac-Man's bewegungs Richtung)
      case 4: iP = iP + "red_walk_"; break; // Blinky jagt direkt (Pac-Man's aktuelle Position)
    }
    
    
    image_right = new AnimationImage(iP + "right_", 2, ANIMATION_SPEED);
    image_left = new AnimationImage(iP + "left_", 2, ANIMATION_SPEED);
    image_up = new AnimationImage(iP + "up_", 2, ANIMATION_SPEED);
    image_down = new AnimationImage(iP + "down_", 2, ANIMATION_SPEED);
    image_vul = new AnimationImage(path + "vul_", 4, ANIMATION_SPEED);
    image_cought_right = new NormalImage(path + "cought_walk_right");
    image_cought_left = new NormalImage(path + "cought_walk_left");
    image_cought_up = new NormalImage(path + "cought_walk_up");
    image_cought_down = new NormalImage(path + "cought_walk_down");
    
    setImageContainer(image_left);
    
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
      
      int position[] = getPosition();
      
      println("POWER MODE: " + powerMode);
      if(powerMode){
        
        direction = chooseFleeDirection();
        println("Flee direction: " + direction);
        
      }
      else{
        
        println("NORMAL MODE | Direction: " + direction + " | Previous: " + previous_direction);
        
        if(isAtPlayer()){
          if(direction != CreatureDirections.NEUTRAL){
            previous_direction = direction;
          }
          direction = CreatureDirections.NEUTRAL;
          return;
        }
        
        if(isDecisionTile(position[0], position[1])){
            direction = chooseDirection();
        }
        else if(isDeadEnd(position[0], position[1])){
            direction = chooseDirection();
        }        
      }
      
      if(!canMove(direction)){
    
        direction = getFreeDirection();
    
        println("Final direction: " + direction);
        
        if(previous_direction != direction){
          previous_direction = direction;
        }
      }
      
      switch(direction){
  
        case RECHTS:{
          if(powerMode){
            move(direction, image_vul);
            break;
          }
          else if(cought){
            move(direction, image_cought_right);
            break;
          }
          else{
            move(direction, image_right);
            break;
          }
        }
  
        case LINKS:{
          if(powerMode){
            move(direction, image_vul);
            break;
          }
          else if(cought){
            move(direction, image_cought_left);
            break;
          }
          else{
            move(direction, image_left);
            break;
          }
        }
  
        case HOCH:{
          if(powerMode){
            move(direction, image_vul);
            break;
          }
          else if(cought){
            move(direction, image_cought_up);
            break;
          }
          else{
            move(direction, image_up);
            break;
          }
        }
  
        case RUNTER:{
          if(powerMode){
            move(direction, image_vul);
            break;
          }
          else if(cought){
            move(direction, image_cought_down);
            break;
          }
          else{
            move(direction, image_down);
            break;
          }
        }
  
        case NEUTRAL:{
          if(powerMode){
            move(direction, image_vul);
            break;
          }
          else if(cought){
            move(direction, image_cought_left);
            break;
          }
          else{
            move(direction, image_left);
            break;
          }
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
  
  CreatureDirections chooseFleeDirection(){
    CreatureDirections direction = chooseDirection();
    
    return oppositeDirection(direction);
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
  
        if(position[0] == gridX && position[1] == gridY && !wall.isPassThrough()){
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
