class Door extends WorldObject{
 
  int link_id;
  boolean open = false;
  
  Orientation orientation;
  
  Door(int grid_x, int grid_y, Orientation orientation, int link_id){
   
    super(WorldTypes.DOOR, grid_x, grid_y);
    this.link_id = link_id;
    
    this.orientation = orientation;
    
    if(link_id == 0){
     open = true; 
    }
  }
}
