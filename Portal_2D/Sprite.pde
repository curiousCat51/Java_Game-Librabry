class Sprite extends WorldObject {

  // Das Rasterfeld, zu dem sich dieses Sprite bewegen möchte.
  int targetGridX;
  int targetGridY;

  Sprite(WorldTypes type, int grid_x, int grid_y) {
    super(type, grid_x, grid_y);

    // Zu Beginn liegt das Bewegungsziel auf der aktuellen Position.
    targetGridX = grid_x;
    targetGridY = grid_y;
  }

  // Berechnet das Zielfeld anhand einer gewünschten Bewegungsrichtung.
  // Die aktuelle Position wird dabei noch nicht verändert.
  void calculateNewPosition(int wishX, int wishY) {
    targetGridX = grid_x + wishX;
    targetGridY = grid_y + wishY;
  }
}
