class GridPosition{
  int x;
  int y;
  GridPosition previous;
  
  GridPosition(int x, int y){
    this.x = x;
    this.y = y;
    this.previous = null;
  }
  
  boolean isSamePosition(GridPosition position){
    return x == position.x && y == position.y;
  }
}
