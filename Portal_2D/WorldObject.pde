class WorldObject{
  
  int grid_x;
  int grid_y;
  WorldTypes type;
  
  WorldObject(WorldTypes type, int grid_y, int grid_x){
    this.type = type;
    this.grid_x = grid_x;
    this.grid_y = grid_y;
  }
}
