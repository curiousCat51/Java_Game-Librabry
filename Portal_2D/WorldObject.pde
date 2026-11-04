class WorldObject{
  
  int grid_x;
  int grid_y;
  WorldTypes type;
  boolean gettingCarried = false;
  
  WorldObject(WorldTypes type, int grid_x, int grid_y){
    this.type = type;
    this.grid_x = grid_x;
    this.grid_y = grid_y;
  }
  
  boolean canActivateButton(){
    return false; 
  }
}
