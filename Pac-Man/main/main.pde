// ==========================================
// 1. GLOBALE VARIABLEN
// ==========================================

// Größenskalierung der Darstellung
float SCALE = 2;

// Größe eines einzelnen Feldes
float TILE_SIZE = 16 * SCALE;

// Geschwindigkeit der Beweglichen Entitäten
float PLAYER_SPEED = 0.7f * SCALE; // Wieder auf 0.7f setzen
float ENEMY_SPEED = 0.8f * SCALE; // Wieder auf 0.8f setzen

// Geschwindigkeit von Animationen
float ANIMATION_SPEED = 0.1f;

// Liste der Objekte (Spieler, Wände, Gegner, ...)
ArrayList<WorldObject> world_objects;

// Objekt zum handling von Eingaben 
KeyHandler EventListener;

// Dot Effekte
int score = 0;
boolean powerMode = false;
int powerTimer = 0;

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
}

// ==========================================
// 3. DRAW-LOOP (Hauptschleife)
// ==========================================
void draw(){
  background(0);
  // Darstellung jedes einzelnen Objektes
  for(int i = 0; i < world_objects.size(); i++){

    WorldObject object = world_objects.get(i);

    object.drawObject();

    if(object instanceof Enemy){

        Enemy e = (Enemy) object;

        e.move();
        e.display();
    }

    if(object instanceof Player){

        Player p = (Player) object;

        p.move();
        p.display();
    }
  }
  if(powerMode){

      powerTimer--;
  
      if(powerTimer <= 0){
          powerMode = false;
      }
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
