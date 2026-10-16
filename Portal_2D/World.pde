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

  void registerObject(WorldObject object, int row, int col) {
    grid[row][col].addObject(object);
    world_objects.add(object);
  }

  void removeObject(WorldObject object, int row, int col) {
    grid[row][col].removeObject(object);
    world_objects.remove(object);
  }
}
