class Image {
  
  String path;
  
  PImage image;
  
  Image(String path){
    this.path = path;
    image = loadImage(path + ".bmp");
  }
  
  void load(float x, float y){
    image(image, x, y);
  }
}
