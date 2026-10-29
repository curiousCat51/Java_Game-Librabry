class Projectile{
 
  float x;
  float y;
  
  int directionX;
  int directionY;
  
  float speed = 0.08f;
  
  boolean portalReady = true;
  
  int startGridX;
  int startGridY;
  
  boolean hasLeftStartCell = false;
  
  Projectile(int startX, int startY, int directionX, int directionY){
   
    this.x = startX + 0.5f;
    this.y = startY + 0.5f;
    
    this.directionX = directionX;
    this.directionY = directionY;
    
    startGridX = startX;
    startGridY = startY;
  }
  
  // Ändert die Position des Projektils.
  void update(){
    x += directionX * speed;
    y += directionY * speed;
    
    if(floor(x) != startGridX || floor(y) != startGridY){
     hasLeftStartCell = true; 
    }
  }
  
  // Prüft ob das Projectile das Spielfeld verlassen hat
  boolean isOutsideWorld(World world){
    return x < 0 || y < 0 || x >= world.cols || y >= world.rows;
  }
  
  // Prüft ob das Projectile eine Wand trifft
  boolean hasHitWall(World world){
   int gridX = floor(x);
   int gridY = floor(y);
   
   return world.isWallAt(gridX, gridY);
  }
  
  // Prüft ob das Projectile den Spieler getroffen hat
  boolean hasHitPlayer(Player player){
   int projectileGridX = floor(x);
   int projectileGridY = floor(y);
   
   return projectileGridX == player.grid_x && projectileGridY == player.grid_y;
  }
  
  // Prüft ob das Projectile einen Gegner getroffen hat
  boolean hasHitEnemy(Enemy enemy){
    if(enemy == null || !hasLeftStartCell){
     return false; 
    }
    
    return floor(x) == enemy.grid_x && floor(y) == enemy.grid_y;
  }
  
  // Zeichnet das Projectile
  void draw(int tileSize){
    fill(255, 220, 0);
    noStroke();
    
    float pixelX = x * tileSize;
    float pixelY = y * tileSize;
    
    ellipse(pixelX, pixelY, tileSize * 0.25f, tileSize * 0.25f);
  }
}
