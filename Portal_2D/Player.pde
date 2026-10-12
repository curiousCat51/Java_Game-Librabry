class Player{
  
  GridPosition spawn;
  MoveDirectory dir;
  
  int x;
  int y;
  int p_width = 12;
  int p_height = 12;
  
  Player(int x, int y){
    
    spawn = new GridPosition(x, y);
    
    this.x = x;
    this.y = y;
  }
  
  void updateGrid(){
    
    int nextX = x;
    int nextY = y;
    
    readInput();
    
    int[] XY = newGrid();
    
    nextX += XY[0];
    nextY += XY[1];
    
    if(!(nextX <= 0 || nextX >= width - p_width / 2) && !(nextY <= 0 || nextY >= height - p_height / 2)){
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
      pos_y -= speed;
    }
    
    if(dir == MoveDirectory.RUNTER){
      pos_y += speed;
    }
    
    if(dir == MoveDirectory.RECHTS){
      pos_x += speed;
    }
    
    if(dir == MoveDirectory.LINKS){
      pos_x -= speed;
    }
    
    return new int[]{pos_x, pos_y};
  }
  
  void placePortal(){
    switch(portalVersion){
      case "1": target.add(portalVersion, new Target(x, y, 'b')); break;
      case "2": target.add(portalVersion, new Target(x, y, 'o')); break;
    }
  }
  
  int getX(){return x;}
  int getY(){return y;}
  
  void display(){
    
    pushMatrix();
    fill(255, 0, 0);
    rect(x, y, p_width, p_height);
    popMatrix();
    
  }
}
