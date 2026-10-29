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
   
   // Nach einer Übertragung muss die Figur das Portal erst verlassen.
   if(!sprite.portalReady){
     if(portalHere == null){
       sprite.portalReady = true;
     }
     return false;
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
   
   moveObject(sprite, sprite.grid_x, sprite.grid_y, destinationPortal.grid_x, destinationPortal.grid_y);
   
   sprite.portalReady = false;
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
}
