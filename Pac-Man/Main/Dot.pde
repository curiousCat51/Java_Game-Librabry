class Dot extends WorldObject {
  NormalImage image;
  int dot_type;
  int dot_score;

  Dot(int grid_x, int grid_y, int dot_type) {
    super(WorldTypes.DOT, grid_x, grid_y);
    this.dot_type = dot_type;

    if (dot_type == 1) {
      image = new NormalImage("data/images/Items/dot_big");
      dot_score = 50;
    } else {
      image = new NormalImage("data/images/Items/dot_small");
      dot_score = 10;
    }

    setImageContainer(image);
  }

  void collect() {
    score += dot_score;
    dot_count++;

    if (dot_type == 1) {
      startPowerMode();
    }

    world_objects.remove(this);
  }
}
