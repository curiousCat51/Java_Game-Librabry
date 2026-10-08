class Life extends WorldObject {
  NormalImage[] images;
  boolean alive = true;
  int animation_frame = 0;
  boolean in_animation = false;
  int animation_timer = 0;

  Life(int grid_x, int grid_y) {
    super(WorldTypes.LIFE, grid_x, grid_y);

    images = new NormalImage[7];
    for (int i = 0; i < images.length; i++) {
      images[i] = new NormalImage("data/images/Visuals/heart_" + (6 - i));
    }

    setImageContainer(images[0]);
  }

  void damage() {
    if (in_animation || !alive) {
      return;
    }

    in_animation = true;
    animation_frame = 0;
    animation_timer = 0;
    lifes = max(0, lifes - 1);
  }

  void updateAnimation() {
    if (!in_animation) {
      return;
    }

    animation_timer++;
    if (animation_timer < 8) {
      return;
    }

    animation_timer = 0;

    if (animation_frame < images.length - 1) {
      animation_frame++;
      setImageContainer(images[animation_frame]);
    } else {
      in_animation = false;
      alive = false;
    }
  }

  boolean getState() {
    return alive;
  }

  void displayAt(float x, float y) {
    if (image_container != null) {
      image_container.drawImage(x, y);
    }
  }
}
