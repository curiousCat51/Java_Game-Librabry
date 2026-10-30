class World {

  GridCell[][] grid;

  ArrayList<WorldObject> world_objects = new ArrayList<WorldObject>();
  ArrayList<Projectile> projectiles = new ArrayList<Projectile>();

  int rows;
  int cols;

  World(int cols, int rows) {
    this.rows = rows;
    this.cols = cols;

    grid = new GridCell[rows][cols];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        grid[row][col] = new GridCell();
      }
    }
  }
  
  // Fügt ein Projectile hinzu
  void addProjectile(Projectile projectile){
    if(projectile != null){
     projectiles.add(projectile); 
    }
  }
  
  // Liegt eine Position innerhalb der Welt
  boolean isInsideGrid(int x, int y){
   return x >= 0 && x < cols && y >= 0 && y < rows; 
  }
  
  // Befindet sich an einer Position eine Wand
  boolean isWallAt(int x, int y){
   if(!isInsideGrid(x, y)){
    return true; 
   }
   
   return grid[y][x].containsWall();
  }
  
  // Prüft ob sich an einer Position eine Barriere befindet.
  boolean isBarrierAt(int x, int y){
   
    for(WorldObject object : world_objects){
     
      if(!(object instanceof Enemy)){
       
        continue;
      }
      
      Enemy enemy = (Enemy) object;
      
      if(enemy.barrier == null){
       
        continue;
      }
      
      int[][] occupiedCells = enemy.barrier.getOccupiedCells();
      
      for(int[] cell : occupiedCells){
       
        if(cell[0] == x && cell[1] == y){
         
          return true;
        }
      }
    }
    return false;
  }
  
  // Bewegt ein Objekt von einer Position zur nächsten.
  void moveObject(WorldObject object, int oldX, int oldY, int newX, int newY){
    if(object == null || !isInsideGrid(oldX, oldY) || !isInsideGrid(newX, newY)){
      return;
    }
    
    grid[oldY][oldX].removeObject(object);
    grid[newY][newX].addObject(object);
    
    object.grid_x = newX;
    object.grid_y = newY;
  }
  
  // Teleportiert einen Sprite beim Betreten eines Portals.
  boolean tryTeleport(Sprite sprite){
   if(sprite == null || sprite.type == WorldTypes.TARGET || !isInsideGrid(sprite.grid_x, sprite.grid_y)){
    return false; 
   }
   
   // Portal auf der aktuellen Position suchen.
   WorldObject portalHere = null;
   
   for(WorldObject object : grid[sprite.grid_y][sprite.grid_x].objects){
    if(object.type == WorldTypes.PORTAL_A || object.type == WorldTypes.PORTAL_B){
     portalHere = object;
     break;
    }
   }
   
   
   // Wurde das zuletzt verwendete Portal verlassen?
   if(!sprite.portalReady && portalHere != sprite.lastPortal){
    
     sprite.portalReady = true;
     sprite.lastPortal = null;
     sprite.lastPartnerPortal = null;
   }
   
   if(portalHere == null){
    return false; 
   }
   
   // Das jeweils andere Portal bestimmen.
   WorldTypes destinationType = portalHere.type == WorldTypes.PORTAL_A ? WorldTypes.PORTAL_B : WorldTypes.PORTAL_A;
   
   WorldObject destinationPortal = null;
   
   for(WorldObject object : world_objects){
    if(object.type == destinationType){
     destinationPortal = object;
     break;
    }
   }
   
   // Ohne Gegenportal findet keine Übertragung statt.
   if(destinationPortal == null){
    return false; 
   }
   
   // Prüfen, ob beide Portale noch die selben sind.
   if(!sprite.portalReady && portalHere == sprite.lastPortal && destinationPortal == sprite.lastPartnerPortal){
    
     return false;
   }
   
   // Sprite zum Zielportal bewegen.
   moveObject(sprite, sprite.grid_x, sprite.grid_y, destinationPortal.grid_x, destinationPortal.grid_y);
   
   // Sichtbare Position aktualisieren.
   sprite.displayGridX = sprite.grid_x;
   sprite.displayGridY = sprite.grid_y;
   
   // Bewegungsziel aktualisieren.
   sprite.targetGridX = sprite.grid_x;
   sprite.targetGridY = sprite.grid_y;
   
   // Verwendetes Portalpaar speichern.
   sprite.portalReady = false;
   sprite.lastPortal = destinationPortal;
   sprite.lastPartnerPortal = portalHere;
   
   return true;
  }

  // Fügt ein Objekt der hinzu Liste
  void registerObject(WorldObject object, int col, int row) {
    grid[row][col].addObject(object);
    world_objects.add(object);
  }

  // Entfernt ein Objekt von der Liste
  void removeObject(WorldObject object, int col, int row) {
    grid[row][col].removeObject(object);
    world_objects.remove(object);
  }
  
  // Platziert ein Portal
  void placePortal(WorldTypes type, int col, int row){
    
    // Nur Portal A und Portal B dürfen platziert werden.
    if(type != WorldTypes.PORTAL_A && type != WorldTypes.PORTAL_B){
      return;
    }
    
    // Ungültige Positionen und Wände verhindern.
    if(!isInsideGrid(col, row) || isWallAt(col, row)){
      return;
    }
    
    // Ein Portal A und Portal B dürfen nicht dieselbe Zelle belegen.
    for(WorldObject object : grid[row][col].objects){
     if(object.type == WorldTypes.PORTAL_A || object.type == WorldTypes.PORTAL_B){
      // Ein Portal des anderen Typs blockiert die Platzierung.
      if(object.type != type){
       return; 
      }
     }
    }
    
    // Ein vorhandenes Portal desselben Typs entfernen.
    for(int i = world_objects.size() - 1; i >= 0; i--){
      WorldObject object = world_objects.get(i);
      
      if(object.type == type){
        removeObject(object, object.grid_x, object.grid_y);
      }
    }
    
    // Neues Portal an der gewünschetn Position regristrieren.
    Portal portal = new Portal(type, col, row);
    registerObject(portal, col, row);
  }
  
  // Teleportiert ein Projektil beim Betreten eines Portals.
  boolean tryTeleport(Projectile projectile) {
    if (projectile == null) {
      return false;
    }
  
    int x = floor(projectile.x);
    int y = floor(projectile.y);
  
    if (!isInsideGrid(x, y)) {
      return false;
    }
  
    WorldObject portalHere = null;
  
    for (WorldObject object : grid[y][x].objects) {
      if (object.type == WorldTypes.PORTAL_A
          || object.type == WorldTypes.PORTAL_B) {
        portalHere = object;
        break;
      }
    }
  
    // Erst wieder teleportieren, nachdem das Projektil das vorherige Portal verlassen hat.
    if (!projectile.portalReady) {
      if (portalHere == null) {
        projectile.portalReady = true;
      }
  
      return false;
    }
  
    if (portalHere == null) {
      return false;
    }
  
    WorldTypes destinationType =
        portalHere.type == WorldTypes.PORTAL_A
        ? WorldTypes.PORTAL_B
        : WorldTypes.PORTAL_A;
  
    WorldObject destinationPortal = null;
  
    for (WorldObject object : world_objects) {
      if (object.type == destinationType) {
        destinationPortal = object;
        break;
      }
    }
  
    // Ohne Gegenportal keine Teleportation.
    if (destinationPortal == null) {
      return false;
    }
  
    // Projektil mittig am Gegenportal platzieren.
    projectile.x = destinationPortal.grid_x + 0.5f;
    projectile.y = destinationPortal.grid_y + 0.5f;
  
    projectile.portalReady = false;
  
    return true;
  }
  
  // Prüft die Verknüpfung der Türen und Buttons
  boolean linkDoorsAndButtons() {

    for (WorldObject obj : world_objects) {
  
      if (obj.type == WorldTypes.BUTTON) {
  
        Button button = (Button) obj;
        Door matchingDoor = null;
        int buttonCount = 0;
  
        for (WorldObject other : world_objects) {
  
          if (other.type == WorldTypes.BUTTON) {
            Button otherButton = (Button) other;
  
            if (otherButton.link_id == button.link_id) {
              buttonCount++;
            }
          }
  
          if (other.type == WorldTypes.DOOR) {
            Door door = (Door) other;
  
            if (door.link_id == button.link_id) {
  
              if (matchingDoor != null) {
                println("Fehler: Mehrere Türen mit link_id " + button.link_id);
                return false;
              }
  
              matchingDoor = door;
            }
          }
        }
  
        if (buttonCount > 1) {
          println("Fehler: Mehrere Buttons mit link_id " + button.link_id);
          return false;
        }
  
        if (matchingDoor == null) {
          println("Fehler: Keine passende Tür für Button mit link_id " + button.link_id);
          return false;
        }
  
        button.linkedDoor = matchingDoor;
      }
    }
  
    // Prüfen, ob jede Tür einen passenden Button besitzt
    for (WorldObject obj : world_objects) {
  
      if (obj.type == WorldTypes.DOOR) {
  
        Door door = (Door) obj;
        boolean matchingButtonFound = false;
  
        for (WorldObject other : world_objects) {
  
          if (other.type == WorldTypes.BUTTON) {
            Button button = (Button) other;
  
            if (button.link_id == door.link_id) {
              matchingButtonFound = true;
              break;
            }
          }
        }
  
        if (!matchingButtonFound) {
          println("Fehler: Kein passender Button für Tür mit link_id " + door.link_id);
          return false;
        }
      }
    }
  
    return true;
  }
  
  void updateButtons() {
    
      for (WorldObject object : world_objects) {
    
        if (!(object instanceof Button)) {
          continue;
        }
    
        Button button = (Button) object;
        boolean occupied = false;
    
        for (WorldObject other : world_objects) {
    
          if (other == button || !other.canActivateButton()) {
            continue;
          }
    
          if (other.grid_x == button.grid_x &&
              other.grid_y == button.grid_y) {
            occupied = true;
            break;
          }
        }
    
        button.active = occupied;
        button.linkedDoor.open = occupied;
      }
    }
}
