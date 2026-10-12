class GridPosition{
  
  int x;
  int y;
  GridPosition previous;
  
  GridPosition(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  boolean isSamePosition(GridPosition position){
    return position != null && x == position.x && y == position.y;
  }
  
  int getX(){return x;}
  int getY(){return y;}
}
