class Teleporter{
  
  Image image;
  
  char teleporter_color;
  int x;
  int y;
  
  Teleporter(int x, int y, char tpC){
    
    teleporter_color = tpC;
    
    this.x = x;
    this.y = y;
    
    switch(teleporter_color){
      case 'b': image = new Image("data/images/portal/blue"); break;
      case 'o': image = new Image("data/images/portal/orange"); break;
    }
  }
  
  void display(){
    image.load(x, y);
  }
}
