class AnimationImage implements ImageContainer{
  // Array, in dem alle Bilder gespeichert werden
  PImage[] images;
  
  // Geschwindigkeit und Fortschritt der Animation
  float animation_speed;
  float animation_progress = 0;
  
  // Anzahl der Bilder
  int image_numbers;
  
  // Richtungsentscheider der Animation 
  boolean backwards = false;
  boolean end = false;
  
  // Zur Erstellung einer Animation werden der Pfad bzw. Name, die Anzahl der Bilder und eine Geschwindigkeit benötigt
  AnimationImage(String path_prefix, int image_numbers, float animation_speed){
    
    // Erstellung des Bilder Arrays. Als Größe wird die Anzahl der Bilder verwendet
    images = new PImage[image_numbers];
    
    // Lädt jedes Bild in einen eigenen Index des Bilder Arrays
    for(int i = 0; i < image_numbers; i++){
     int image_number = i + 1; 
     images[i] = loadImage(path_prefix + image_number + ".bmp");
    }
    
    // Speichert den Wert der lokalen Variablen in die Klassen Variablen
    this.image_numbers = image_numbers;
    this.animation_speed = animation_speed;
  }
  
  // Zeichnet die Animationsbilder auf dem Bildschirm
  void drawImage(float x, float y){
    int image_number = (int) animation_progress;
    
    // Läuft die Animation vorwärts oder rückwärts durch
    if(!backwards){
      animation_progress += animation_speed;
    }
    else{
      animation_progress -= animation_speed;
    }
    
    if(!end){
      // Die Animation läuft so lange vorwärts, bis ihr Ende erreicht wurde
      if(image_number < image_numbers && image_number >= 0){
        backwards = false;
        
        if(image_number == image_numbers - 1){
          end = true;
        }
      }
    }
    else{
      // Sobald ihr Ende erreicht wurde, läuft sie Rückwärts bis 0 erreicht wurde
      backwards = true;
        
      if(image_number == 0){
        end = false;
      }
    }
    
    // Sorgt für die Darstellung des Bildes (Aktuelles Bild, X-Position, Y-Position, Weite des aktuellen Bildes mal der Größenskalierung, Höhe des aktuellen Bildes mal der Größenskalierung
    image(images[image_number], x, y, images[image_number].width * SCALE, images[image_number].height * SCALE);
  }  
}
