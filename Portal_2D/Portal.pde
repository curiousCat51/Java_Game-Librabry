class Portal extends WorldObject{
  
  NormalImage image;
  
  char portal_color;
  
  Portal(int grid_x, int grid_y, char pColor){
    super(WorldTypes.PORTAL, grid_x, grid_y);
    portal_color = pColor;
    
    this.grid_x = grid_x;
    this.grid_y = grid_y;
    
    switch(portal_color){
      case 'b': image = new NormalImage("data/images/portal/blue"); break;
      case 'o': image = new NormalImage("data/images/portal/orange"); break;
    }
  }
  
  void display(){
    drawObject();
  }
}
