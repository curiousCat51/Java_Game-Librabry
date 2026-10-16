class WorldRenderer {

  WorldRenderer(){
    
  }
  
  void drawGrid(World world, int tileSize) {
    stroke(160);
    noFill();

    for (int row = 0; row < world.rows; row++) {
      for (int col = 0; col < world.cols; col++) {
        rect(col * tileSize, row * tileSize, tileSize, tileSize);
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
}
