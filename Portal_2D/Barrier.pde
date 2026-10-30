class Barrier{
 
  Enemy owner;
  
  int barrier_length = 3;
  
  Barrier(Enemy owner){
   this.owner = owner; 
  }
  
  // Berechnet die drei Rasterfelder der Barriere
  int[][] getOccupiedCells(){
    
    int[][] cells = new int[barrier_length][2];
    
    // Position direkt vor dem Gegner
    int frontX = owner.grid_x + owner.moveDirectionX;
    int frontY = owner.grid_y + owner.moveDirectionY;
    
    // Senkrechte Richtung zur Bewegungsrichtung
    int perpendicularX = -owner.moveDirectionY;
    int perpendicularY = owner.moveDirectionX;
    
    // Barriere symmetrisch um die Vorderseite verteilen
    int center = barrier_length / 2;
    
    for(int i = 0; i < barrier_length; i++){
     
      int offset = i - center;
      
      cells[i][0] = frontX + perpendicularX * offset;
      cells[i][1] = frontY + perpendicularY * offset;
    }
    
    return cells;
  }
}
