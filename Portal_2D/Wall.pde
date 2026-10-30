class Wall extends WorldObject {

  WallType wallType;
  Orientation orientation;

  Wall(int grid_x, int grid_y, WallType wallType, Orientation orientation) {
    super(WorldTypes.WALL, grid_x, grid_y);

    this.wallType = wallType;
    this.orientation = orientation;
  }
}
