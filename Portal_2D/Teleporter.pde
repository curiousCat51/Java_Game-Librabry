class Teleporter extends WorldObject{
  
  NormalImage image;
  
  char teleporter_color;
  
  Teleporter(int grid_x, int grid_y, char tpC){
    super(WorldTypes.TELEPORTER, grid_x, grid_y);
    teleporter_color = tpC;
    
    this.grid_x = grid_x;
    this.grid_y = grid_y;
    
    switch(teleporter_color){
      case 'b': image = new NormalImage("data/images/portal/blue"); break;
      case 'o': image = new NormalImage("data/images/portal/orange"); break;
    }
  }
  
  void display(){
    drawObject();
  }
}
