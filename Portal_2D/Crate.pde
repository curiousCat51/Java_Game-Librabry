class Crate extends Sprite{
 
  Crate(int grid_x, int grid_y){
    super(WorldTypes.CRATE, grid_x, grid_y);
  }
  
  @Override boolean canActivateButton(){
    
    if(gettingCarried){
     return false; 
    }
    return true; 
  }
}
