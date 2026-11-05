class WorldRenderer {

  WorldRenderer(){
    
  }
  
  // Zeichnet das Grid und die Objekte aus den einzelnen Zellen
  void drawGrid(World world, int tileSize, ImageManager imageManager) {
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
    
    Player player = null;
    
    for(WorldObject object : world.world_objects){
     
      if(object instanceof Player){
       
        player = (Player) object;
        break;
      }
    }
    
    for (WorldObject object : world.world_objects) {
      if (object == null) {
        continue;
      }
      
      if (object instanceof Sprite) {
        drawHealthBar((Sprite) object, tileSize);
      }
      
      if (player != null && object == player.carriedObject) {
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
          Player Psprite = (Player) object;
          
          String direction = "down";
          
          if(Psprite.facingX == 1){
           direction = "right"; 
          }
          else if(Psprite.facingX == -1){
           direction = "left"; 
          }
          else if(Psprite.facingY == -1){
           direction = "up"; 
          }
          
          int now = millis();
          
          if(Psprite.isMoving()){
           if(now - Psprite.animationLastUpdate >= Psprite.animationInterval){
            Psprite.animationFrame++;
            
            if(Psprite.animationFrame > 4){
             
              Psprite.animationFrame = 1;
            }
            
            Psprite.animationLastUpdate = now;
           }
           else{
            Psprite.animationFrame = 1;
            Psprite.animationLastUpdate = now;
           }
          }
          
          String imagePath = "images/player/" + direction + "/" + Psprite.animationFrame + ".bmp";
          
          PImage playerImage = imageManager.getImage(imagePath);
          
          if(playerImage != null){
           float pixelX = renderGridX * tileSize;
           float pixelY = renderGridY * tileSize;
           
           image(playerImage, pixelX, pixelY, tileSize, tileSize);
          }
        } 
        
        break;
        
        case ENEMY: {
          
          Enemy enemy = (Enemy) object;
          
          String imagePath = "images/enemy/";
          
          if(enemy.shootDirectionX == 0){
            if(enemy.shootDirectionY == -1){
             imagePath += "up/up.bmp";  
            }
            else{
             imagePath += "down/down.bmp"; 
            }
          }
          else if(enemy.shootDirectionY == 0){
           if(enemy.shootDirectionX == -1){
            imagePath += "left/left.bmp"; 
           }
           else{
            imagePath += "right/right.bmp"; 
           }
          }
          else{
           imagePath += "down/down.bmp"; 
          }
          
          float pixelX = renderGridX * tile_size;
          float pixelY = renderGridY * tile_size;
          
          PImage enemyImage = imageManager.getImage(imagePath);
          
          if(enemyImage != null){
           image(enemyImage, pixelX, pixelY, tileSize, tileSize); 
          }
        }
        
        break;
      
        case TARGET: {
          String imagePath = "images/target/";
          
          if(EventListener.portal_mode){
            if(EventListener.selectedPortalType == WorldTypes.PORTAL_A){
              imagePath = imagePath + "orange.bmp";
              
              PImage targetImage = imageManager.getImage(imagePath);
          
              if(targetImage != null){
               float pixelX = renderGridX * tileSize;
               float pixelY = renderGridY * tileSize;
               
               image(targetImage, pixelX, pixelY, tileSize, tileSize);
              }
            }
            else if(EventListener.selectedPortalType == WorldTypes.PORTAL_B){
             imagePath = imagePath + "blue.bmp";
             
             PImage targetImage = imageManager.getImage(imagePath);
          
              if(targetImage != null){
               float pixelX = renderGridX * tileSize;
               float pixelY = renderGridY * tileSize;
               
               image(targetImage, pixelX, pixelY, tileSize, tileSize);
              }
            }
            else{
             fill(0, 100, 255); 
             
             float pixelX = (object.grid_x + 0.5f) * tile_size;
             float pixelY = (object.grid_y + 0.5f) * tile_size;
              
             ellipse(pixelX, pixelY, tile_size * 0.4f, tile_size * 0.4f);
             
             break;
            }
           }
        }
        
        break;
        
        case PORTAL_A: {
          
          String imagePath = "images/portal/orange.bmp";
          
          PImage portalImage = imageManager.getImage(imagePath);
          
          if(portalImage != null){
           float pixelX = renderGridX * tileSize;
           float pixelY = renderGridY * tileSize;
           
           image(portalImage, pixelX, pixelY, tileSize, tileSize);
          }
        }
        
        break;
        
        case PORTAL_B: {
          String imagePath = "images/portal/blue.bmp";
          
          PImage portalImage = imageManager.getImage(imagePath);
          
          if(portalImage != null){
           float pixelX = renderGridX * tileSize;
           float pixelY = renderGridY * tileSize;
           
           image(portalImage, pixelX, pixelY, tileSize, tileSize);
          }
        }
        
        break;
        
        case WALL: {
          
          Wall wall = (Wall) object;
          
          String imagePath = "images/wall";
          
          float pixelX = renderGridX * tileSize;
          float pixelY = renderGridY * tileSize;
          
          if(wall.wallType == WallType.GITTER){
            imagePath += "/bar";
          }
          else if(wall.wallType == WallType.VERBINDUNG){
            imagePath += "/connection";
          }
          else if(wall.wallType == WallType.ECKE){
            imagePath += "/corner";
          }
          else if(wall.wallType == WallType.ENDE){
            imagePath += "/end";
          }
          else if(wall.wallType == WallType.GERADE){
            imagePath += "/straight";
          }
          else{
            imagePath += "/cross.bmp";
          }
          
          if(wall.wallType != WallType.GERADE && wall.orientation != Orientation.SENKRECHT && wall.orientation !=  Orientation.WAAGERECHT){
            if(wall.wallType != WallType.KREUZ){
             imagePath += "/" + wall.id + ".bmp"; 
            }
          }
          else{
           if(wall.orientation ==  Orientation.WAAGERECHT){
             imagePath += "/1.bmp";
           }
           else{
            imagePath += "/2.bmp"; 
           }
          }
          
          
          PImage wallImage = imageManager.getImage(imagePath);
          
          if(wallImage != null){
            image(wallImage, pixelX, pixelY, tileSize, tileSize);
          }
        }
        
        break;
        
        case DOOR: {
          
          Door door = (Door) object;
          
          String imagePath = "images/door/";
        
          float pixelX = renderGridX * tileSize;
          float pixelY = renderGridY * tileSize;
          
          if(door.orientation == Orientation.SENKRECHT){
           imagePath += "vertical/"; 
          }
          else{
           imagePath += "horizontal/"; 
          }
        
          if (door.open) {
            // Geöffnete Tür: grüner Rahmen
            
            imagePath += "open.bmp";
          } else {
            // Geschlossene Tür: braune Fläche
            
            imagePath += "closed.bmp";
          }
          
          PImage doorImage = imageManager.getImage(imagePath);
          
          if(doorImage != null){
           
           image(doorImage, pixelX, pixelY, tileSize, tileSize);
          }
        }
        
        break;
        
        case BUTTON: {
          Button button = (Button) object;
          
          String imagePath = "images/button/";
        
          float pixelX = renderGridX * tileSize;
          float pixelY = renderGridY * tileSize;
        
          if (button.active) {
            imagePath += "pressed.bmp";
          } else {
            imagePath += "released.bmp";
          }
        
          PImage buttonImage = imageManager.getImage(imagePath);
          
          if(buttonImage != null){
           image(buttonImage, pixelX, pixelY, tileSize, tileSize); 
          }
        }
        
        break;
        
        case CRATE:{
          
          String imagePath = "images/crate/crate.bmp";
          
          PImage crateImage = imageManager.getImage(imagePath);
          
          float pixelX = renderGridX * tileSize;
          float pixelY = renderGridY * tileSize;
          
          if(crateImage != null){
           image(crateImage, pixelX, pixelY, tileSize, tileSize); 
          }
        }
      }
    }
    
        // Getragenes Objekt kleiner vor dem Spieler zeichnen
    if (player != null && player.carriedObject instanceof Enemy) {
      float renderGridX = player.displayGridX + player.facingX;
      float renderGridY = player.displayGridY + player.facingY;

      float pixelX = (renderGridX + 0.5f) * tileSize;
      float pixelY = (renderGridY + 0.5f) * tileSize;
      float carriedSize = tileSize * 0.45f;

      Enemy enemy = (Enemy) player.carriedObject;
          
          String imagePath = "images/enemy/";
          
          if(enemy.shootDirectionX == 0){
            if(enemy.shootDirectionY == -1){
             imagePath += "up/up.bmp";  
            }
            else{
             imagePath += "down/down.bmp"; 
            }
          }
          else if(enemy.shootDirectionY == 0){
           if(enemy.shootDirectionX == -1){
            imagePath += "left/left.bmp"; 
           }
           else{
            imagePath += "right/right.bmp"; 
           }
          }
          else{
           imagePath += "down/down.bmp"; 
          }
          
          PImage enemyImage = imageManager.getImage(imagePath);
          
          if(enemyImage != null){
           image(enemyImage, pixelX, pixelY, carriedSize, carriedSize); 
          }
    }
    else if(player != null && player.carriedObject instanceof Crate){
      
      float renderGridX = player.displayGridX + player.facingX;
      float renderGridY = player.displayGridY + player.facingY;
         
      float pixelX = (renderGridX + 0.5f) * tileSize;
      float pixelY = (renderGridY + 0.5f) * tileSize;
      float carriedSize = tileSize * 0.45f;
      
      String imagePath = "images/crate/crate.bmp";
      
      PImage crateImage = imageManager.getImage(imagePath);
      
      if(crateImage != null){
       image(crateImage, pixelX, pixelY, carriedSize, carriedSize); 
      }
    }
  }
  
  // Zeichnet die erreichbaren Felder für das Target
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
  
  // Zeichnet die Lebensanzeigen von Spieler und Gegner
  void drawHealthBar(Sprite sprite, int tileSize) {
    if (!sprite.isHealthBarVisible()) {
      return;
    }
  
    float barWidth = tileSize * 0.8f;
    float barHeight = 5;
  
    float x = (sprite.getCurrentGridX() + 0.1f) * tileSize;
    float y = (sprite.getCurrentGridY() - 0.2f) * tileSize;
  
    float healthPercent = sprite.getHealthPercent();
  
    // Hintergrund der Leiste
    noStroke();
    fill(80);
    rect(x, y, barWidth, barHeight);
  
    // Lebenspunkte: Grün bei voller Gesundheit, Rot bei 0
    color healthColor = lerpColor(color(0, 255, 0), color(255, 0, 0), 1 - healthPercent);
    fill(healthColor);
    rect(x, y, barWidth * healthPercent, barHeight);
  }
  
  // Stellt die Tastenbelegung dar
  void drawControls(KeyHandler keys, Player player) {
    ArrayList<String> controls = new ArrayList<String>();
  
    // Bewegung ist im Portal-Modus gesperrt.
    if (!keys.portal_mode && player != null) {
      controls.add("Pfeiltasten: Bewegen");
      controls.add("W A S D: Blickrichtung");
      controls.add("E: Aufheben / Ablegen");
    }
  
    controls.add("T: Portal-Modus");
  
    if (keys.portal_mode) {
      controls.add("1 / 2: Portal wählen");
  
      if (keys.selectedPortalType != null) {
        controls.add("Enter: Platzieren");
      }
  
      controls.add("Esc: Abbrechen");
    }
  
    float padding = 10;
    float lineHeight = 18;
    float maxTextWidth = width - padding * 2;
  
    textSize(12);
    textAlign(LEFT, CENTER);
  
    // Hinweise in Zeilen umbrechen, sobald die Fensterbreite nicht reicht.
    ArrayList<String> lines = new ArrayList<String>();
    String line = "";
  
    for (String control : controls) {
      String candidate = line.length() == 0 ? control : line + "   |   " + control;
  
      if (textWidth(candidate) <= maxTextWidth) {
        line = candidate;
      } else {
        if (line.length() > 0) {
          lines.add(line);
        }
        line = control;
      }
    }
  
    if (line.length() > 0) {
      lines.add(line);
    }
  
    float barHeight = padding * 2 + lines.size() * lineHeight;
  
    noStroke();
    fill(30, 220);
    rect(0, height - barHeight, width, barHeight);
  
    fill(255);
    for (int i = 0; i < lines.size(); i++) {
      text(lines.get(i), padding, height - barHeight + padding + lineHeight * (i + 0.5f));
    }
  }
}
