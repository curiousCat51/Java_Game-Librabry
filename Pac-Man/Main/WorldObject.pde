abstract class WorldObject {
  float pixel_x;
  float pixel_y;

  int grid_x;
  int grid_y;

  WorldTypes type;
  ImageContainer image_container;

  WorldObject(WorldTypes type, int grid_x, int grid_y) {
    this.type = type;
    this.grid_x = grid_x;
    this.grid_y = grid_y;
    this.pixel_x = convertToPixel(grid_x);
    this.pixel_y = convertToPixel(grid_y);
  }

  void setImageContainer(ImageContainer container) {
    image_container = container;
  }

  void drawObject() {
    if (image_container != null) {
      image_container.drawImage(pixel_x, pixel_y);
    }
  }

  void display() {
    drawObject();
  }

  float convertToPixel(float gridPosition) {
    return mapOffsetX + gridPosition * TILE_SIZE + TILE_SIZE * 0.5f;
  }

  float convertToGrid(float pixelPosition) {
    return round((pixelPosition - mapOffsetX - TILE_SIZE * 0.5f) / TILE_SIZE);
  }

  float getPixelX() { return pixel_x; }
  float getPixelY() { return pixel_y; }

  WorldTypes getType() { return type; }

  int getGridX() { return grid_x; }
  int getGridY() { return grid_y; }

  void setGridX(int value) { grid_x = value; }
  void setGridY(int value) { grid_y = value; }

  void setPixelX(float value) { pixel_x = value; }
  void setPixelY(float value) { pixel_y = value; }

  int[] getPosition() {
    return new int[] {grid_x, grid_y};
  }

  void setPosition(int x, int y) {
    grid_x = x;
    grid_y = y;
    pixel_x = convertToPixel(x);
    pixel_y = convertToPixel(y);
  }

  // Wird nach einem Resize aufgerufen. Statische Objekte können einfach
  // aus ihrer Grid-Position neu berechnet werden. Bewegliche Objekte
  // überschreiben diese Methode, um ihren Bewegungsfortschritt zu erhalten.
  void updateLayoutPosition() {
    pixel_x = convertToPixel(grid_x);
    pixel_y = convertToPixel(grid_y);
  }
}
