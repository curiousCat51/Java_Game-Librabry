class Button extends WorldObject {

  int link_id;
  boolean active = false;
  
  ArrayList<Door> linkedDoors = new ArrayList<Door>();

  Button(int grid_x, int grid_y, int link_id) {
    super(WorldTypes.BUTTON, grid_x, grid_y);
    this.link_id = link_id;
  }
}
