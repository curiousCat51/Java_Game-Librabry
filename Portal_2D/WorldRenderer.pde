class WorldRenderer {

  WorldRenderer(){
    
  }
  
  // Zeichnet das Grid
  void drawGrid(World world, int tileSize) {
    stroke(160);
    noFill();

    for (int row = 0; row < world.rows; row++) {
      for (int col = 0; col < world.cols; col++) {
        rect(row * tileSize, col * tileSize, tileSize, tileSize);
      }
    }
  
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
      
      if (object.type == WorldTypes.PLAYER) {
        fill(#000000);
        
        float pixelX = (renderGridX + 0.5) * tileSize;
        float pixelY = (renderGridY + 0.5) * tileSize;
  
        ellipse(pixelX, pixelY, tileSize * 0.7, tileSize * 0.7);
      }
      
      if(object.type == WorldTypes.TARGET && EventListener.portal_mode){
       fill(0, 100, 255);
       noStroke();
       
       float pixelX = (object.grid_x + 0.5f) * tile_size;
       float pixelY = (object.grid_y + 0.5f) * tile_size;
       
       ellipse(pixelX, pixelY, tile_size * 0.4f, tile_size * 0.4f);
      }
      
      if(object.type == WorldTypes.PORTAL_A){
        fill(#FC8726);
        
        float pixelX = (renderGridX + 0.5) * tileSize;
        float pixelY = (renderGridY + 0.5) * tileSize;
  
        ellipse(pixelX, pixelY, tileSize * 0.7, tileSize * 0.7);
      }
      
      if(object.type == WorldTypes.PORTAL_B){
        fill(#0DC6FC);
        
        float pixelX = (renderGridX + 0.5) * tileSize;
        float pixelY = (renderGridY + 0.5) * tileSize;
  
        ellipse(pixelX, pixelY, tileSize * 0.7, tileSize * 0.7);
      }
      
      if(object.type == WorldTypes.WALL){
        fill(#939393);
        
        float pixelX = (renderGridX + 0.5) * tileSize;
        float pixelY = (renderGridY + 0.5) * tileSize;
  
        rectMode(CENTER);
        rect(pixelX, pixelY, tileSize * 0.7, tileSize * 0.7);
        rectMode(CORNER);
      }
    }
  }
  
  void drawReachableCells(Target target, Player player, World world, int tile_size){
    boolean[][] reachable = target.getReachableCells(player, world);
    
    noStroke();
    fill(150, 230, 150, 100);
    
    for(int row = 0; row < world.rows; row++){
     for(int col = 0; col < world.cols; col++){
       if(reachable[row][col]){
         
         float pixelX = col * tile_size;
         float pixelY = row * tile_size;
         
         rect(pixelX, pixelY, tile_size, tile_size);
       }
     }
    }
  }
}
