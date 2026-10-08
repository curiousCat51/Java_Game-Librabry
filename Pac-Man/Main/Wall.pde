class Wall extends WorldObject {
  NormalImage image;
  int wall_type;
  boolean pass_through;

  Wall(int grid_x, int grid_y, int wall_type, int version) {
    super(WorldTypes.WALL, grid_x, grid_y);

    this.wall_type = wall_type;

    String path = "data/images/Walls/wall_";

    switch (wall_type) {
      case 1:
        path += "connection";
        pass_through = false;
        break;
      case 2:
        path += "corner";
        pass_through = false;
        break;
      case 3:
        path += "cross";
        pass_through = false;
        break;
      case 4:
        path += "end";
        pass_through = false;
        break;
      case 5:
        path += "straight";
        pass_through = false;
        break;
      case 6:
        path += "door";
        pass_through = true;
        break;
      default:
        throw new IllegalArgumentException("Unbekannter Wandtyp: " + wall_type);
    }

    if (wall_type != 6 && version != 0) {
      path += "_" + version;
    }

    image = new NormalImage(path);
    setImageContainer(image);
  }

  int getWallType() { return wall_type; }
  boolean isPassThrough() { return pass_through; }
}
