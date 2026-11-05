import java.util.HashMap;

class ImageManager{
 
  // Speicherort für bereits geladene Bilder
  private HashMap<String,PImage> images;
  
  ImageManager(){
   images = new HashMap<String, PImage>(); 
  }
  
  // Gibt ein Bild zurück und lädt es bei Bedarf
  PImage getImage(String path){
    
    // Wurde das Bild bereits geladen?
    if(images.containsKey(path)){
     return images.get(path); 
    }
    
    // Bild erstmalig laden
    PImage img = loadImage(path);
    
    if(img == null){
     println("Bild konnte nicht gefunden werden: " + path);
     return null;
    }
    
    // Bild für spätere Zugriffe speichern
    images.put(path, img);
    
    return img;
  }
  
  // Anzahl der aktuell gespeicherten Bilder
  int getLoadedImageCount(){
   return images.size(); 
  }
}
