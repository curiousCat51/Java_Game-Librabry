class ImageCache {
  HashMap<String, PImage> originalImages = new HashMap<String, PImage>();
  HashMap<String, PImage> scaledImages = new HashMap<String, PImage>();

  PImage load(String path) {
    if (!originalImages.containsKey(path)) {
      PImage loaded = loadImage(path + ".bmp");
      if (loaded == null) {
        throw new RuntimeException("Bild konnte nicht geladen werden: " + path);
      }
      originalImages.put(path, loaded);
    }

    return originalImages.get(path);
  }

  PImage getScaled(String path, PImage source) {
    int size = max(1, round(TILE_SIZE));
    String key = path + "@" + size;

    if (!scaledImages.containsKey(key)) {
      PImage resized = source.copy();
      resized.resize(size, size);
      scaledImages.put(key, resized);
    }

    return scaledImages.get(key);
  }
}

class NormalImage implements ImageContainer {
  String path;
  PImage image;

  NormalImage(String path) {
    this.path = path;
    image = imageCache.load(path);
  }

  void drawImage(float x, float y) {
    PImage renderImage = imageCache.getScaled(path, image);
    image(renderImage, x, y);
  }
}
