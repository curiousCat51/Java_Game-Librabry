class Target{
  
  NormalImage image;
  
  MoveDirectory dir;
  
  char target_color;
  int x;
  int y;
  
  int t_width = 12;
  int t_height = 12;
  
  Target(int x, int y, char tgC){
    
    target_color = tgC;
    
    this.x = x;
    this.y = y;
    
    switch(target_color){
      case 'b': image = new NormalImage("data/images/target/blue"); break;
      case 'o': image = new NormalImage("data/images/target/orange"); break;
    }
  }
  
  void updateGrid(){
    
    int nextX = x;
    int nextY = y;
    
    readInput();
    
    int[] XY = newGrid();
    
    nextX += XY[0];
    nextY += XY[1];
    
    if(!(nextX <= 0 || nextX >= width - t_width / 2) && !(nextY <= 0 || nextY >= height - t_height / 2)){
      x = nextX;
      y = nextY;
    }
  }
  
  void readInput(){
    
    if(EventListener.getKeyUP()){
      dir = MoveDirectory.HOCH;
    }
    else if(EventListener.getKeyDOWN()){
      dir = MoveDirectory.RUNTER;
    }
    else if(EventListener.getKeyLEFT()){
      dir = MoveDirectory.LINKS;
    }
    else if(EventListener.getKeyRIGHT()){
      dir = MoveDirectory.RECHTS;
    }
    else{
      dir = MoveDirectory.NEUTRAL;
    }
    
  }
  
  int[] newGrid(){
    
    int pos_x = 0;
    int pos_y = 0;
    
    if(dir == MoveDirectory.HOCH){
      pos_y -= TARGET_SPEED;
    }
    
    if(dir == MoveDirectory.RUNTER){
      pos_y += TARGET_SPEED;
    }
    
    if(dir == MoveDirectory.RECHTS){
      pos_x += TARGET_SPEED;
    }
    
    if(dir == MoveDirectory.LINKS){
      pos_x -= TARGET_SPEED;
    }
    
    return new int[]{pos_x, pos_y};
  }
  
  void display(){
     image.drawImage(x, y); 
  }
}
