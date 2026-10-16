class World {

  GridCell[][] grid;

  ArrayList<WorldObject> world_objects = new ArrayList<WorldObject>();

  int rows;
  int cols;

  World(int rows, int cols) {
    this.rows = rows;
    this.cols = cols;

    grid = new GridCell[rows][cols];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        grid[row][col] = new GridCell();
      }
    }
  }
  
  // Liegt weine Position innerhalb der Welt
  boolean isInsideGrid(int row, int col){
   return row >= 0 && row < rows && col >= 0 && col < cols; 
  }
  
  boolean isWallAt(int row, int col){
   if(!isInsideGrid(row, col)){
    return true; 
   }
   
   return grid[row][col].containsWall();
  }
  
  void moveObject(WorldObject object, int oldRow, int oldCol, int newRow, int newCol) {
    if (object == null || !isInsideGrid(oldRow, oldCol) || !isInsideGrid(newRow, newCol)) {
      return;
    }
  
    grid[oldRow][oldCol].removeObject(object);
    grid[newRow][newCol].addObject(object);
  
    object.grid_x = newCol;
    object.grid_y = newRow;
  }

  void registerObject(WorldObject object, int row, int col) {
    grid[row][col].addObject(object);
    world_objects.add(object);
  }

  void removeObject(WorldObject object, int row, int col) {
    grid[row][col].removeObject(object);
    world_objects.remove(object);
  }
}
