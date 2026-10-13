class ImageCache{
  HashMap<String, PImage> originalImages = new HashMap<String, PImage>();
  HashMap<String, PImage> rescaledImages = new HashMap<String, PImage>();
  
  PImage load(String path){
    
    if(!originalImages.containsKey(path)){
      
       PImage loaded = loadImage(path + ".bmp"); 
       
       if(loaded == null){
         throw new RuntimeException("Bild konnte nicht geladen werden: " + path);
       }
        
       originalImages.put(path, loaded);
    }
    
    return originalImages.get(path);
  }
  
  PImage getRescaled(String path, PImage scource){
    
    int size = max(1, round(TILE_SIZE));
    String key = path + "@" + size;
    
    if(!rescaledImages.containsKey(key)){
      
      PImage resized = scource.copy();
      resized.resize(size, size);
      rescaledImages.put(key, resized);
      
    }
    
    return rescaledImages.get(key);
  }
}

class NormalImage implements ImageContainer{
  
  String path;
  PImage image;
  
  NormalImage(String path){
    
    this.path = path;
    image = imageCache.load(path);
  }
  
  void drawImage(float x, float y){
    
    PImage renderImage = imageCache.getRescaled(path, image);
    image(renderImage, x, y);
  }
}
