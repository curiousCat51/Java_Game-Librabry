class Fruits extends WorldObject {
  NormalImage image;
  int fruit_type;
  int fruit_score;

  Fruits(int grid_x, int grid_y) {
    super(WorldTypes.FRUIT, grid_x, grid_y);
    fruit_type = generateFruit();

    String path;
    switch (fruit_type) {
      case 1: path = "cherry"; fruit_score = 100; break;
      case 2: path = "strawberry"; fruit_score = 300; break;
      case 3: path = "orange"; fruit_score = 500; break;
      case 4: path = "apple"; fruit_score = 700; break;
      case 5: path = "melon"; fruit_score = 1000; break;
      case 6: path = "galaxian"; fruit_score = 2000; break;
      case 7: path = "bell"; fruit_score = 3000; break;
      default: path = "key"; fruit_score = 5000; break;
    }

    image = new NormalImage("data/images/Items/" + path);
    setImageContainer(image);
  }

  void collect() {
    score += fruit_score;
    logical_dot_count -= FRUIT_SPAWN_DOT_COUNT;
    fruit_count++;
    fruit_counts[fruit_type - 1]++;
    fruit_spawned = false;
    world_objects.remove(this);
    checkBonusLife();
  }

  int generateFruit() {
    return int(random(1, 9));
  }
}
