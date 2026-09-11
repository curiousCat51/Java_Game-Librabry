// ==========================================
// 1. GLOBALE VARIABLEN
// ==========================================
ArrayList<Background_v2> bground; 
ArrayList<Ground_v2> ground;  
ArrayList<Spike_v2> spike; 
Bird_v2 bird; 

int speed = 10;  
float distance = 150;  
float factor = 0.5;  

int spike_max = 10; 
int spike_count = 0;  
int counter = 0; 
int points = 0;  

// Timer
float savedTime; 
float totalTime; 
float cooldown = 2000;  

// Animation State
int b_state = 0; 
int state_runs = 0;  

// Steuerungs-Flags
boolean kSpace = false;  
boolean isPaused = false; 

// Bildschirm-Auflösungen
int width_ = 1280; 
int height_ = 800; 
int width_h = 640; 
int width_q = 320; 
int height_h = 400; 
int height_q = 200;  

// ==========================================
// 2. SETUP (Initialisierung)
// ==========================================
void setup() {   
  size(1280, 800); 
  
  savedTime = millis();   
  totalTime = millis();      
  
  // Hintergrund nahtlos nebeneinander anreihen
  bground = new ArrayList<Background_v2>();   
  float tileWidth = 1280 * factor; 
  bground.add(new Background_v2(0 * tileWidth));   
  bground.add(new Background_v2(1 * tileWidth));   
  bground.add(new Background_v2(2 * tileWidth));   
  bground.add(new Background_v2(3 * tileWidth));   
  
  // Boden nahtlos nebeneinander anreihen
  ground = new ArrayList<Ground_v2>();   
  float groundTileWidth = 1280 * factor;
  ground.add(new Ground_v2(0 * groundTileWidth));   
  ground.add(new Ground_v2(1 * groundTileWidth));   
  ground.add(new Ground_v2(2 * groundTileWidth));   
  ground.add(new Ground_v2(3 * groundTileWidth));   
  
  spike = new ArrayList<Spike_v2>();      
  
  bird = new Bird_v2();   
}  

// ==========================================
// 3. DRAW-LOOP (Haupt-Schleife)
// ==========================================
void draw() {   
  background(0);      
  Frame();       
  
  fill(255);
  textSize(24);
  textAlign(CENTER, TOP);
  // text("Spikes: " + spike_count, 550, 20);   
  // text("Klicks: " + counter, 550, 40);   
  text("Punkte: " + points, width_h, 20);
}  

// ==========================================
// 4. SPIEL-LOGIK (Pro Frame)
// ==========================================
void Frame() {   
  if (isPaused) {
    Pause();
    return; 
  }

  BackgroundMove();      

  if (spike_count < spike_max && millis() >= totalTime + cooldown) {     
    SpikeAdd();   
  }      
  
  SpikeMove();      
  BirdMove();      
  BirdAction();      
  GroundMove(); 
  
  ScoreCheck();      
  SpikeRemove();      
  
  savedTime = millis();      
}   

// ==========================================
// 5. ZUSATZ-FUNKTIONEN
// ==========================================
void SpikeRemove() {   
  for (int i = spike.size() - 1; i >= 0; i--) {     
    if (spike.get(i).getSpikeX() <= -(spike.get(i).getSpikeWidth() * factor)) {       
      spike.remove(i);       
      spike_count--;     
    }   
  } 
} 

void SpikeAdd() {   
  spike.add(new Spike_v2());   
  spike_count++;   
  totalTime = millis(); 
}  

void ScoreCheck() {   
  if (spike.size() == 0) return;

  Bird_v2 currentBird = bird;   
  
  float padX = currentBird.getBirdWidth() * 0.15;  
  float padY = currentBird.getBirdHeight() * 0.20; 
  
  float birdLeft   = currentBird.getBirdX() + padX;   
  float birdRight  = currentBird.getBirdX() + currentBird.getBirdWidth() - padX;   
  float birdTop    = currentBird.getBirdY() + padY;   
  float birdBottom = currentBird.getBirdY() + currentBird.getBirdHeight() - padY;  

  for (int i = 0; i < spike.size(); i++) {    
    Spike_v2 s = spike.get(i);    
    
    float spikeLeft  = s.getSpikeX();    
    float spikeRight = spikeLeft + s.getSpikeWidth();        

    // Kollisionsprüfung
    if (birdRight > spikeLeft && birdLeft < spikeRight) {      
      if (birdTop < s.getSpikeHeightB() || birdBottom > s.getSpikeHeightT()) {        
        GameOver();
        return;      
      }    
    } 
    
    // NEU: Punktesystem
    // Wenn die hintere Kante des Vogels (birdLeft) die hintere Kante des Spikes (spikeRight) 
    // exakt in diesem Frame passiert hat, bekommt der Spieler einen Punkt.
    // (Der Puffer 'speed' fängt den Frame-Sprung präzise ab)
    if (birdLeft >= spikeRight && birdLeft < spikeRight + speed) {
      points++;
    }
  }
}

void Pause() {
  background(0);      
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("PAUSE", width_h, height_h);
  textSize(16);
  text("Drücke 'ENTER' zum Weiterspielen", width_h, height_h + 40);
}

void GameOver() {
  background(0);      
  fill(255, 0, 0);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Game Over!", width_h, height_h);      
  textSize(20);
  fill(255);
  text("Endergebnis: " + points + " Punkte", width_h, height_h + 50);
  noLoop(); 
}

// ==========================================
// 6. TASTATUR-STEUERUNG
// ==========================================
void keyPressed() {   
  if (key == ' ') {     
    kSpace = true;   
  } 
  if (keyCode == ENTER) {
    isPaused = !isPaused;
  }
}  

void keyReleased() {   
  if (key == ' ') {     
    kSpace = false;   
  } 
}  

void BirdStates() {   
  if (state_runs < 9) {    
    if (state_runs % 2 == 1) {      
      if (b_state < 3) {        
        b_state++;      
      } else {        
        b_state = 0;      
      }    
    }   
  } else {    
    state_runs = 0;    
  } 
}  

void BirdAction() {   
  if (kSpace) {     
    bird.fly();     
    counter++;   
  } else {     
    bird.fall();   
  } 
}  

void BirdMove() {   
  bird.birding(b_state);   
  BirdStates();   
  state_runs++; 
}   

void SpikeMove() {   
  for (int i = 0; i < spike.size(); i++) {     
    spike.get(i).spiking();     
    spike.get(i).move();   
  } 
}  

void BackgroundMove() {   
  for (int i = 0; i < bground.size(); i++) {     
    bground.get(i).bgrounding();     
    bground.get(i).move();   
  } 
}  

void GroundMove() {   
  for (int i = 0; i < ground.size(); i++) {     
    ground.get(i).grounding();     
    ground.get(i).move();   
  } 
}  
