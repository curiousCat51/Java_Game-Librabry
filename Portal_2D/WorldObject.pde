class WorldObject{
  
  int grid_x;
  int grid_y;
  WorldTypes type;
  
  WorldObject(WorldTypes type, int grid_x, int grid_y){
    this.type = type;
    this.grid_x = grid_x;
    this.grid_y = grid_y;
  }
  
  boolean canActivateButton(){
    return false; 
  }
}
