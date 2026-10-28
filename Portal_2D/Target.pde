class Target extends Sprite{
  
  KeyHandler EventListener;
  
  int repeatDelay = 150;
  int nextMoveTime = 0;
  
  
  Target(int grid_x, int grid_y, KeyHandler EventListener){
    super(WorldTypes.TARGET, grid_x, grid_y);
    
    this.EventListener = EventListener;
  }
  
  // Überprüft die eigene Distanz zum Spieler
  int getDistanceToPlayer(Player player) {
    int distanceX = abs(grid_x - player.grid_x);
    int distanceY = abs(grid_y - player.grid_y);
  
    return distanceX + distanceY;
  }
  
  // Bestimmt ob Spieler eingaben verarbeitet werden
  void updateInput(){
    if(!EventListener.portal_mode){
      wishX = 0;
      wishY = 0;
      return;
    }
    
    processInput();
  }
  
  // Prüft ob Target sich bewegen kann
  boolean canMoveTo(int newX, int newY, Player player, World world){
   // Prüfen ob das Zielfeld innerhalb des Rasters liegt.
   if(!world.isInsideGrid(newX, newY)){
     return false;
   }
   
   // Wände dürfen nicht betreten werden.
   if(world.isWallAt(newX, newY)){
     return false;
   }
   
   // Maximale Manhatten-Distanz zum Spieler: 4 Felder
   int distanceX = abs(newX - player.grid_x);
   int distanceY = abs(newY - player.grid_y);
   
   if(distanceX + distanceY > 4){
     return false;
   }
   
   return true;
  }
  
  // Bewegt das Target innerhalb des Rasters
  void updateMovementInput(Player player, World world){
    // Nur im Portal-Modus darf das Target gesteuert werden.
    if(!EventListener.portal_mode){
      return;
    }
    
    // Gewünschte Richtung aus den Tasteneingaben ermitteln.
    processInput();
    
    // Ohne Richtung gibt es keine Bewegung.
    if(wishX == 0 && wishY == 0){
     return; 
    }
    
    if(millis() < nextMoveTime){
     return; 
    }
    
    // Neue Zielposition berechnen.
    int newX = grid_x + wishX;
    int newY = grid_y + wishY;
    
    // Prüfen, ob die Bewegung erlaubt ist.
    if(!canMoveTo(newX, newY, player, world)){
      return;
    }
    
    // Target im Raster auf das neue Feld verschieben.
    world.moveObject(this, grid_x, grid_y, newX, newY);
    
    nextMoveTime = millis() + repeatDelay;
  }
  
  // Lässt das Target an die Spieler Position zurückkehren, sobald der Portal-Modus endet
  void resetToPlayer(Player player){
   grid_x = player.grid_x;
   grid_y = player.grid_y;
   
   wishX = 0;
   wishY = 0;
  }
  
  // Prüft welche Felder das Target erreichen kann
  boolean[][] getReachableCells(Player player, World world){
   boolean[][] reachable = new boolean[world.rows][world.cols];
   int[][] distance = new int[world.rows][world.cols];
   
   // Alle Entfernungen für die Suche vorbereiten
   for(int row = 0; row < world.rows; row++){
    for(int col = 0; col < world.cols; col++){
      distance[row][col] = -1;
    }
   }
   
   // Warteschlange für die Suche vorbereiten
   ArrayList<int[]> queue = new ArrayList<int[]>();
   
   int startRow = player.grid_y;
   int startCol = player.grid_x;
   
   queue.add(new int[] {startRow, startCol});
   distance[startRow][startCol] = 0;
   reachable[startRow][startCol] = true;
   
   int[][] directions = {{0, -1}, {0, 1}, {-1, 0}, {1, 0}};
   
   int index = 0;
   
   while(index < queue.size()){
    int[] current = queue.get(index++);
    
    int row = current[0];
    int col = current[1];
    
    // Nach vier Schrittten endet die Suche.
    if(distance[row][col] >= 4){
      continue;
    }
    
    for(int[] direction : directions){
     int newRow = row + direction[0];
     int newCol = col + direction[1];
     
     if(!world.isInsideGrid(newRow, newCol)){
      continue; 
     }
     
     if(world.isWallAt(newRow, newCol)){
       continue;
     }
     
     if(distance[newRow][newCol] != -1){
      continue; 
     }
     
     distance[newRow][newCol] = distance[row][col] + 1;
     reachable[newRow][newCol] = true;
     
     queue.add(new int[] {newRow, newCol});
    }
   }
   
   return reachable;
  }
}
