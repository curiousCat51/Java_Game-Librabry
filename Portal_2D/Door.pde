class Door extends WorldObject{
 
  int link_id;
  boolean open = false;
  
  Door(int grid_x, int grid_y, int link_id){
   
    super(WorldTypes.DOOR, grid_x, grid_y);
    this.link_id = link_id;
  }
}
