class Wall extends WorldObject {

  WallType wallType;
  Orientation orientation;
  Direction direction;
  
  boolean blockTarget = true;
  
  int id;

  Wall(int grid_x, int grid_y, WallType wallType, Direction direction, Orientation orientation, int id) {
    super(WorldTypes.WALL, grid_x, grid_y);

    this.wallType = wallType;
    this.direction = direction;
    this.orientation = orientation;
    this.id = id;
    
    if(wallType == WallType.GITTER){
     blockTarget = false; 
    }
  }
}
