class WorldRenderer {

  WorldRenderer(){
    
  }
  
  // Zeichnet das Grid
  void drawGrid(World world, int tileSize) {
    stroke(160);
    noFill();

    for (int row = 0; row < world.rows; row++) {
      for (int col = 0; col < world.cols; col++) {
        rect(col * tileSize, row * tileSize, tileSize, tileSize);
      }
    }
    
    // Angriffsbereich des AREA_ATTACKER anzeigen
    for (WorldObject object : world.world_objects) {
      if (!(object instanceof Enemy)) {
        continue;
      }
    
      Enemy enemy = (Enemy) object;
    
      if (enemy.enemyType != EnemyType.AREA_ATTACKER) {
        continue;
      }
      
      boolean warning = enemy.areaAttackPending;
      boolean attacking = enemy.attackEffectTimer > 0;
      
      if (!warning && !attacking) {
        continue;
      }
      
      noStroke();
      
      if (warning) {
        fill(255, 220, 0, 120);
      } else {
        fill(255, 100, 40, 120);
      }
    
      // Oberes Nachbarfeld
      if (world.isInsideGrid(enemy.grid_x, enemy.grid_y - 1)) {
        rect(enemy.grid_x * tileSize, (enemy.grid_y - 1) * tileSize, tileSize, tileSize);
      }
    
      // Unteres Nachbarfeld
      if (world.isInsideGrid(enemy.grid_x, enemy.grid_y + 1)) {
        rect(enemy.grid_x * tileSize, (enemy.grid_y + 1) * tileSize, tileSize, tileSize);
      }
    
      // Linkes Nachbarfeld
      if (world.isInsideGrid(enemy.grid_x - 1, enemy.grid_y)) {
        rect((enemy.grid_x - 1) * tileSize, enemy.grid_y * tileSize,  tileSize, tileSize);
      }
    
      // Rechtes Nachbarfeld
      if (world.isInsideGrid(enemy.grid_x + 1, enemy.grid_y)) {
        rect((enemy.grid_x + 1) * tileSize, enemy.grid_y * tileSize, tileSize, tileSize);
      }
    }
    
    // Barrieren der Gegner zeichnen
    for(WorldObject object : world.world_objects){
     
      if(!(object instanceof Enemy)){
       
        continue;
      }
      
      Enemy enemy = (Enemy) object;
      
      if(enemy.barrier == null){
        
        continue;
      }
      
      int[][] occupiedCells = enemy.barrier.getOccupiedCells();
      
      for(int[] cell : occupiedCells){
       
        int x = cell[0];
        int y = cell[1];
        
        // Barriere außerhalb des Grids nicht zeichnen.
        if(!world.isInsideGrid(x, y)){
         
          continue;
        }
        
        float pixelX = x * tileSize;
        float pixelY = y * tileSize;
        
        // Transparent blaue Fläche
        noStroke();
        fill(0, 180, 255, 100);
        
        
        rectMode(CORNER);
        rect(pixelX, pixelY, tileSize, tileSize);
        
        // Sichtbare Umrandung
        noFill();
        stroke(0, 180, 255);
        strokeWeight(2);
        
        rect(pixelX + 2, pixelY + 2, tileSize - 4, tileSize - 4);
      }
    }
    
    strokeWeight(1);
  
    // Spieler zeichnen
    noStroke();
    rectMode(CORNER);
    ellipseMode(CENTER);
    
    for (WorldObject object : world.world_objects) {
      if (object == null) {
        continue;
      }
      
      float renderGridX = object.grid_x;
      float renderGridY = object.grid_y;
      
      if (object instanceof Sprite) {
        Sprite sprite = (Sprite) object;
      
        renderGridX = sprite.displayGridX;
        renderGridY = sprite.displayGridY;
      }
      
      switch(object.type){
        case PLAYER: {
          fill(#000000);
          
          float pixelX = (renderGridX + 0.5) * tileSize;
          float pixelY = (renderGridY + 0.5) * tileSize;
    
          ellipse(pixelX, pixelY, tileSize * 0.7, tileSize * 0.7);
        } 
        
        break;
        
        case ENEMY: {
          fill(220, 50, 50);
          
          float pixelX = (renderGridX + 0.5) * tile_size;
          float pixelY = (renderGridY + 0.5) * tile_size;
          
          ellipse(pixelX, pixelY, tileSize * 0.7, tileSize * 0.7);
        }
        
        break;
      
        case TARGET: {
          if(EventListener.portal_mode){
            if(EventListener.selectedPortalType == WorldTypes.PORTAL_A){
              fill(#FC8726);
            }
            else if(EventListener.selectedPortalType == WorldTypes.PORTAL_B){
             fill(#0DC6FC); 
            }
            else{
             fill(0, 100, 255); 
            }
            
            float pixelX = (object.grid_x + 0.5f) * tile_size;
            float pixelY = (object.grid_y + 0.5f) * tile_size;
            
            ellipse(pixelX, pixelY, tile_size * 0.4f, tile_size * 0.4f);
          }
        }
        
        break;
        
        case PORTAL_A: {
          fill(#FC8726);
          
          float pixelX = (renderGridX + 0.5) * tileSize;
          float pixelY = (renderGridY + 0.5) * tileSize;
    
          ellipse(pixelX, pixelY, tileSize * 0.7, tileSize * 0.7);
        }
        
        break;
        
        case PORTAL_B: {
          fill(#0DC6FC);
          
          float pixelX = (renderGridX + 0.5) * tileSize;
          float pixelY = (renderGridY + 0.5) * tileSize;
    
          ellipse(pixelX, pixelY, tileSize * 0.7, tileSize * 0.7);
        }
        
        break;
        
        case WALL: {
          fill(#939393);
          
          float pixelX = (renderGridX + 0.5) * tileSize;
          float pixelY = (renderGridY + 0.5) * tileSize;
    
          rectMode(CENTER);
          rect(pixelX, pixelY, tileSize * 0.7, tileSize * 0.7);
          rectMode(CORNER);
        }
        
        break;
        
        case DOOR: {
          
          Door door = (Door) object;
        
          float pixelX = (renderGridX + 0.5f) * tileSize;
          float pixelY = (renderGridY + 0.5f) * tileSize;
        
          rectMode(CENTER);
        
          if (door.open) {
            // Geöffnete Tür: grüner Rahmen
            noFill();
            stroke(0, 180, 0);
            strokeWeight(3);
            rect(pixelX, pixelY, tileSize * 0.8f, tileSize * 0.8f);
          } else {
            // Geschlossene Tür: braune Fläche
            noStroke();
            fill(130, 75, 35);
            rect(pixelX, pixelY, tileSize * 0.8f, tileSize * 0.8f);
          }
        
          rectMode(CORNER);
          strokeWeight(1);
        }
        
        break;
        
        case BUTTON: {
          Button button = (Button) object;
        
          float pixelX = (renderGridX + 0.5f) * tileSize;
          float pixelY = (renderGridY + 0.5f) * tileSize;
        
          if (button.active) {
            fill(0, 220, 0);
          } else {
            fill(120, 120, 120);
          }
        
          noStroke();
          ellipse(pixelX, pixelY, tileSize * 0.45f, tileSize * 0.45f);
        }
        
        break;
      }
    }
  }
  
  void drawRangeCells(Target target, Player player, World world, int tile_size){
    boolean[][] inRange = target.getCellsInRange(player, world);
    boolean[][] reachable = target.getReachableCells(player, world);
    
    noStroke();
    
    for(int row = 0; row < world.rows; row++){
      for(int col = 0; col < world.cols; col++){
        
        if(!inRange[row][col]){
          continue;
        }
        
        float pixelX = col * tile_size;
        float pixelY = row * tile_size;
        
        if(reachable[row][col]){
          // Grün: Tatsächlich erreichbar
          fill(150, 230, 150, 100);
        }
        else if(!world.isWallAt(col, row)){
          // Rot: Innerhalb der Reichweite, aber nicht erreichbar
          fill(230, 100, 100, 130);
        }
        else{
          // Wand selbst nicht übermalen
          continue;
        }
        
        rect(pixelX, pixelY, tile_size, tile_size);
        
      }
    }
  }
}
