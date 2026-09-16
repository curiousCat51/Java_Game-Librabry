class NormalImage implements ImageContainer{
 
  PImage image;
  
  NormalImage(String path){
    this.image = loadImage(path + ".bmp");
  }
  
  void drawImage(float x, float y){
    image(image, x, y, image.width * SCALE, image.height * SCALE);
  }
}
