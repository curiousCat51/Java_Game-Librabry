class Ground_v2 {
  PImage groundImg;
     
  float factor = 0.5;
  float ground_width;
  float ground_height;
  
  float ground_x;
  float ground_y;
  
  // Konstruktor benötigt nur noch die X-Startposition dieses spezifischen Bodenelements
  Ground_v2(float startX) {
    // Bild nur beim allerersten Mal von der Festplatte laden
    if (groundImg == null) {
      groundImg = loadImage("data/background/ground/Ground&Stone/Ground/ground8.png");
    }
    
    // Maße erst im Konstruktor berechnen, da 'width' und 'height' erst nach size() existieren
    ground_width  = width * factor;
    ground_height = height * factor;
    
    ground_x = startX;
    // Setzt den Boden exakt bündig auf den unteren Bildschirmrand
    ground_y = height - ground_height; 
  }
 
  void grounding() {
    // Zeichnet genau diese eine Bodenkachel
    image(groundImg, ground_x, ground_y, ground_width, ground_height);
  }
 
  void move() {
    // Bewegung basierend auf der globalen Spielgeschwindigkeit (ohne Faktor, da der Boden sich schneller als der Hintergrund bewegt)
    ground_x -= speed;
     
    // Wenn die Kachel komplett links aus dem Bildschirm gewandert ist...
    if (ground_x <= -ground_width) {
      // ...setze sie nahtlos ganz rechts hinter das letzte sichtbare Bodenelement.
      // (ground.size() * ground_width) sorgt für einen perfekten, unendlichen Kreislauf.
      ground_x += ground.size() * ground_width;
    }
  }

  
  float getGroundX() { return ground_x; }
  float getGroundY() { return ground_y; }
  float getGroundWidth() { return ground_width; }
  float getGroundHeight() { return ground_height; }
}
