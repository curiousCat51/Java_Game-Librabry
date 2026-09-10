class Background_v2 {
  PImage bgroundImg;
     
  float factor = 0.5;
  float background_width;
  float background_height;
  
  float background_x;
  float background_y;
  
  Background_v2(float startX) {
    if (bgroundImg == null) {
      bgroundImg = loadImage("data/background/tilesetOpenGameBackground.png");
    }
    
    // Nutzt die volle Breite und skaliert die Höhe passend
    background_width  = width * factor;
    background_height = height * factor; 
    
    background_x = startX;
    
    // Setzt das Bild ganz nach oben (Y = 0), damit es hinter dem Vogel 
    // und den Spikes liegt und nicht unter den Boden rutscht!
    background_y = 0; 
  }
 
  void bgrounding() {
    image(bgroundImg, background_x, background_y, background_width, background_height);
  }
 
  void move() {
    background_x -= speed * factor;
     
    if (background_x <= -background_width) {
      background_x += bground.size() * background_width;
    }
  }

  float getX() { return background_x; }
}
