class Teleporter extends WorldObject {
  NormalImage image_active;
  NormalImage image_inactive;

  boolean active = true;
  int id;
  Teleporter connection;

  String basePath = "data/images/Teleporter/teleporter_";

  Teleporter(int grid_x, int grid_y, int tp_id) {
    super(WorldTypes.TELEPORT, grid_x, grid_y);
    id = tp_id;

    image_inactive = new NormalImage(basePath + "white");
    image_active = new NormalImage(basePath + ((id % 2 == 0) ? "blue" : "orange"));
    setImageContainer(image_active);
  }

  void connectTo(Teleporter other) {
    connection = other;
  }

  Teleporter findConnection() {
    if (connection != null) {
      return connection;
    }

    int connectionID = (id % 2 == 0) ? id - 1 : id + 1;
    for (WorldObject object : world_objects) {
      if (object instanceof Teleporter && ((Teleporter) object).id == connectionID) {
        connection = (Teleporter) object;
        return connection;
      }
    }

    return null;
  }

  void updateImage() {
    setImageContainer(active ? image_active : image_inactive);
  }

  void deactivatePair() {
    Teleporter other = findConnection();
    active = false;
    updateImage();

    if (other != null) {
      other.active = false;
      other.updateImage();
    }

    String timerName = getPairTimerName();
    for (Timer existing : timer) {
      if (existing.timerName().equals(timerName)) {
        return;
      }
    }
    timer.add(new Timer(timerName, 0, 60, 'i'));
  }

  void TPupdate() {
    if (active) {
      return;
    }

    String pairName = getPairTimerName();
    for (int i = timer.size() - 1; i >= 0; i--) {
      Timer current = timer.get(i);
      if (!current.timerName().equals(pairName)) {
        continue;
      }

      if (!current.isFinished()) {
        return;
      }

      Teleporter other = findConnection();
      active = true;
      updateImage();

      if (other != null) {
        other.active = true;
        other.updateImage();
      }

      timer.remove(i);
      return;
    }
  }

  String getPairTimerName() {
    Teleporter other = findConnection();
    if (other == null) {
      return "TeleporterPair_" + id;
    }

    return "TeleporterPair_" + min(id, other.id) + "_" + max(id, other.id);
  }

  GridPosition TeleportTo() {
    if (!active) {
      return null;
    }

    Teleporter other = findConnection();
    if (other == null) {
      return null;
    }

    deactivatePair();
    return new GridPosition(other.grid_x, other.grid_y);
  }

  boolean isActive() { return active; }
  int getID() { return id; }
}
