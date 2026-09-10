class Bird_v2 {
  // Alle Animations-Bilder in einem Array
  PImage[] frames = new PImage[4];
  
  // Position und Größe des Vogels
  float bird_x = 152;
  float bird_y = 170;
  float bird_width = 40;
  float bird_height = 50;
  
  // Gravitation und Flugkraft (Physik-Optimierung)
  float velocity = 0;
  float gravity = 0.4;
  float jumpStrength = -6.5;
  
  // Grenzen für das Spielfeld
  float minY = 0;
  float maxY;

  Bird_v2() {
    // Bilder werden einmalig beim Erstellen des Vogels geladen
    frames[0] = loadImage("data/flappy bird (pink)/PNG/frame-1.png");
    frames[1] = loadImage("data/flappy bird (pink)/PNG/frame-2.png");
    frames[2] = loadImage("data/flappy bird (pink)/PNG/frame-3.png");
    frames[3] = loadImage("data/flappy bird (pink)/PNG/frame-4.png");
    
    // Untere Grenze ist der Boden (Dynamisch berechnet)
    maxY = height - bird_height;
  }
  
  // Zeichnet den Vogel basierend auf dem aktuellen Animationsschritt (b_state aus dem Hauptcode)
  void birding(int currentFrame) {
    // Sicherstellen, dass der Index nicht außerhalb des Arrays liegt
    int frameIndex = constrain(currentFrame, 0, 3);
    image(frames[frameIndex], bird_x, bird_y, bird_width, bird_height);
  }
  
  // Wendet die Schwerkraft an, wenn der Spieler nichts drückt
  void fall() {
    velocity += gravity;
    bird_y += velocity;
    
    // Am Boden stoppen (Kein Durchfallen)
    if (bird_y > maxY) {
      bird_y = maxY;
      velocity = 0;
    }
  }
  
  // Lässt den Vogel nach oben fliegen / springen
  void fly() {
    velocity = jumpStrength;
    bird_y += velocity;
    
    // An der Decke stoppen
    if (bird_y < minY) {
      bird_y = minY;
      velocity = 0;
    }
  }
  
  // Getter-Methoden für die kollisionsabfrage im Hauptcode
  float getBirdX() { return bird_x; }
  float getBirdY() { return bird_y; }
  float getBirdWidth() { return bird_width; }
  float getBirdHeight() { return bird_height; }
}
