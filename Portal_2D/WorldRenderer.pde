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
  
      if (object.type == WorldTypes.PLAYER) {
        fill(#000000);
        
        float pixelX = (object.grid_x + 0.5) * tile_size;
        float pixelY = (object.grid_y + 0.5) * tile_size;
  
        ellipse(pixelX, pixelY, tile_size * 0.7, tile_size * 0.7);
      }
      
      if(object.type == WorldTypes.PORTAL_A){
        fill(#FC8726);
        
        float pixelX = (object.grid_x + 0.5) * tile_size;
        float pixelY = (object.grid_y + 0.5) * tile_size;
  
        ellipse(pixelX, pixelY, tile_size * 0.7, tile_size * 0.7);
      }
      
      if(object.type == WorldTypes.PORTAL_B){
        fill(#0DC6FC);
        
        float pixelX = (object.grid_x + 0.5) * tile_size;
        float pixelY = (object.grid_y + 0.5) * tile_size;
  
        ellipse(pixelX, pixelY, tile_size * 0.7, tile_size * 0.7);
      }
      
      if(object.type == WorldTypes.WALL){
        fill(#939393);
        
        float pixelX = (object.grid_x + 0.5) * tile_size;
        float pixelY = (object.grid_y + 0.5) * tile_size;
  
        rectMode(CENTER);
        rect(pixelX, pixelY, tile_size * 0.7, tile_size * 0.7);
        rectMode(CORNER);
      }
    }
  }
}
