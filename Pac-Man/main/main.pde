// ==========================================
// 1. GLOBALE VARIABLEN
// ==========================================

// Größenskalierung der Darstellung
float SCALE = 2;

// Größe eines einzelnen Feldes
float TILE_SIZE = 16 * SCALE;

// Geschwindigkeit der Beweglichen Entitäten
float PLAYER_SPEED = 0.6f * SCALE; // Wieder auf 0.7f setzen
float ENEMY_SPEED = 0.6f * SCALE; // Wieder auf 0.8f setzen

// Geschwindigkeit von Animationen
float ANIMATION_SPEED = 0.1f;

// Liste der Objekte (Spieler, Wände, Gegner, ...)
ArrayList<WorldObject> world_objects;

GridPosition map_end = new GridPosition(29, 28);

// Objekt zum handling von Eingaben 
KeyHandler EventListener;

// Punkte
int score = 0;

// Anzahl der gesammelten Dots
int dot_count = 0;

// Dot Effekte
boolean powerMode = false;
int powerTimer = 0;

boolean fruit_spawned = false;

// Leben des Spielers
int lifes = 3;
int last_life_x = 0;
int leben_erstellt = 0;

// Bereits vergebene Bonusleben
int bonus_lebenS = 0;

int map_height;

boolean game_over = false;

Screens screen = new Screens();

// ==========================================
// 2. SETUP (Initialisierung)
// ==========================================
void setup(){
  size(1024, 1024);
  imageMode(CENTER);
  noSmooth();
  
  // Erstellung der Welt-Objekt-Liste
  world_objects = new ArrayList<WorldObject>();
  
  // Aufruf des MapLoaders
  new MapLoader(world_objects);
  
  // Erstellung des KeyHandler-Objektes
  EventListener = new KeyHandler();
  
  MapLoader loader = new MapLoader(world_objects);
  
  map_height = loader.getMapHeight();
  
  for(int i = 0; i <= lifes + 1; i+=2){
    Life life = new Life(i, map_height);
    world_objects.add(life);
    last_life_x = i;
    leben_erstellt++;
  }
}

// ==========================================
// 3. DRAW-LOOP (Hauptschleife)
// ==========================================
void draw(){
  background(0);
  
  if(game_over){
    screen.GAME_OVER();
  }
  else{
    
    newFruit();
    
    // Darstellung jedes einzelnen Objektes
    for(int i = 0; i < world_objects.size(); i++){
  
      WorldObject object = world_objects.get(i);
  
      if(object instanceof Enemy){
  
          Enemy e = (Enemy) object;
  
          e.move();
          e.display();
      }
      else if(object instanceof Player){
  
          Player p = (Player) object;
  
          p.move();
          p.display();
      }
      else if(object instanceof Life){
        
        Life l = (Life) object;
        l.updateAnimation();
        l.display();
      }
      else if(object instanceof Fruits){
        Fruits f = (Fruits) object;
        
        f.display();
      }
      else if(object instanceof Dot){
        Dot d = (Dot) object;
        
        d.display();
      }
      else {
        object.drawObject();
      }
    }
    
    if(powerMode){
  
      powerTimer--;
  
      if(powerTimer <= 0){
          powerMode = false;
      }
    }
    pushMatrix();
    color(0, 0, 0);
    text("Score: " + score + "\n Dots collected: " + dot_count, width - 100, 100);
    popMatrix();
  }
  
  if(isGameOver()){
    game_over = true;
  }
}

// ==========================================
// 4. TASTATUR-STEUERUNG
// ==========================================

// Wenn eine Taste gedrückt wird,...
void keyPressed(){
  // ...wird die Eingabe gehandelt und...
  EventListener.Pressed();
}

// Wenn eine Taste losgelassen wird,...
void keyReleased(){
  // ...wird die Eingabe gehandelt
  EventListener.Released();
}

boolean isGameOver(){
  if(lifes == 0){
    return true;
  }
  
  return false;
}

void newFruit(){  
  if(dot_count == 70 && !fruit_spawned){
    Fruits fruit = new Fruits(13, 15);
    world_objects.add(fruit);
    fruit_spawned = true;
  }
}

void checkBonusLife() {
  while (score >= (bonus_lebenS + 1) * 10000) {
    lifes++;
    bonus_lebenS++;
    updateHearts();
  }
}

void updateHearts() {
  // Alte Herzobjekte entfernen
  for (int i = world_objects.size() - 1; i >= 0; i--) {
    if (world_objects.get(i) instanceof Life) {
      world_objects.remove(i);
    }
  }

  // Neue Herzen entsprechend der Lebensanzahl erzeugen
  for (int i = 0; i < lifes; i++) {
    Life life = new Life(i * 2, map_height);
    world_objects.add(life);
  }
}
