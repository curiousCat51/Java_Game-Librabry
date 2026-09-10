class Spike_v2 {
  PImage spikeImg;  
  
  float factor = 0.5;
  
  float spike_x;
  float spike_width;
  
  float top_spike_h;
  float bottom_spike_h;
  float opening;
  
  // Die echten Abmessungen des Originalbildes
  final float ORIGINAL_WIDTH = 159;
  final float ORIGINAL_HEIGHT = 326;
  final float ASPECT_RATIO = ORIGINAL_WIDTH / ORIGINAL_HEIGHT; // Ergibt ca. 0.487
  
  Spike_v2() {
    if (spikeImg == null) {
      spikeImg = loadImage("data/spikes/transparent PNG/spike D.png");
    }
    
    spike_x = width; 
    opening = distance; 
    
    generateSizes();
    
    // Proportionale Breite berechnen
    spike_width = bottom_spike_h * ASPECT_RATIO;
    
    spike_width = constrain(spike_width, 40, 55); 
  }
   
  void spiking() {
    // OBERER SPIKE: Wird umgedreht (auf den Kopf gestellt)
    pushMatrix();
    translate(spike_x, top_spike_h); 
    scale(1, -1); 
    image(spikeImg, 0, 0, spike_width, top_spike_h);
    popMatrix();
     
    // UNTERER SPIKE: Normal gezeichnet
    float bottom_y = top_spike_h + opening;
    image(spikeImg, spike_x, bottom_y, spike_width, bottom_spike_h);
  }
   
  void move() {
    spike_x -= speed; 
  }
  
  // Getter-Methoden für die Kollisionsabfrage
  float getSpikeX() { return spike_x; }
  float getSpikeWidth() { return spike_width; }
  float getSpikeHeightB() { return top_spike_h; }
  float getSpikeHeightT() { return top_spike_h + opening; }
  
  void generateSizes() {
    // Der spielbare Bereich (oberhalb des Bodens)
    float playableHeight = height * factor; 
    
    // Zufällige Höhe für den oberen Spike
    top_spike_h = random(80, playableHeight - opening - 80);
    
    // Der untere Spike füllt den Rest des Bildschirms aus
    bottom_spike_h = height - (top_spike_h + opening);
  }
}
