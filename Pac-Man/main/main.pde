import processing.awt.PSurfaceAWT.SmoothCanvas;
import javax.swing.JFrame;
import java.awt.Dimension;
// ==========================================
// GRÖSSEN / LAYOUT
// ==========================================

float SCALE = 2;
float TILE_SIZE = 16 * SCALE;

// Grundgeschwindigkeit pro Tile
float PLAYER_SPEED = 0.6f * SCALE;
float ENEMY_SPEED = 0.6f * SCALE;

// Größe des Informationsbereichs rechts
float sidePanelWidth;

// Position der Map auf dem Bildschirm
float mapOffsetX;
float mapOffsetY;

// Abstände um die Map
float layoutMargin = 20;

// Mapgröße
int map_width;
int map_height;

float previousWidth;
float previousHeight;

// Geschwindigkeit von Animationen
float ANIMATION_SPEED = 0.1f;

// Liste der Objekte (Spieler, Wände, Gegner, ...)
ArrayList<WorldObject> world_objects;

// Liste der Freien Tiles
ArrayList<GridPosition> free_tiles;

// Liste der Tiles welche nicht erreichbar sein sollten
ArrayList<GridPosition> out_of_map;

// Liste der Timer
ArrayList<Timer> timer;

// Objekt zum handling von Eingaben 
KeyHandler EventListener;

GridPosition score_position;

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

boolean game_over = false;

Screens screen = new Screens();
// ==========================================
// 2. SETUP (Initialisierung)
// ==========================================
void setup(){

  size(1024, 1024);
  surface.setResizable(true);
  
  SmoothCanvas canvas = (SmoothCanvas) surface.getNative();
  JFrame frame = (JFrame) canvas.getFrame();

  frame.setMinimumSize(new Dimension(800, 600));

  imageMode(CENTER);
  noSmooth();

  world_objects = new ArrayList<WorldObject>();
  free_tiles = new ArrayList<GridPosition>();
  out_of_map = new ArrayList<GridPosition>();
  timer = new ArrayList<Timer>();

  // Map laden
  new MapLoader(world_objects);

  // Layout anhand der geladenen Map berechnen
  updateLayout();

  EventListener = new KeyHandler();

  // TODO:
  // Die Lebensanzeige  später in den rechten Informationsbereich verschieben
  previousWidth = width;
  previousHeight = height;
}

// ==========================================
// DYNAMISCHES LAYOUT
// ==========================================

void updateLayout(){

  if(map_width <= 0 || map_height <= 0){
    return;
  }

  // Rechter Bereich für Score, Leben usw.
  sidePanelWidth = constrain(width * 0.25f, 180, 320);

  // Platz, der der Map zur Verfügung steht
  float availableWidth = width - sidePanelWidth;
  float availableHeight = height;

  // Größe eines Tiles so wählen,
  // dass die komplette Map hineinpasst
  TILE_SIZE = min((availableWidth - layoutMargin * 2) / map_width,(availableHeight - layoutMargin * 2) / map_height);

  // Die Bilder sind 16x16 Pixel groß
  SCALE = TILE_SIZE / 16.0f;

  // Geschwindigkeiten an die neue Größe anpassen
  PLAYER_SPEED = 0.6f * SCALE;
  ENEMY_SPEED = 0.6f * SCALE;

  // Tatsächliche Größe der Map
  float mapPixelWidth = map_width * TILE_SIZE;
  float mapPixelHeight = map_height * TILE_SIZE;

  // Map innerhalb des linken Bereiches zentrieren
  mapOffsetX = (availableWidth - mapPixelWidth) / 2.0f;
  mapOffsetY = (height - mapPixelHeight) / 2.0f;
}

// ==========================================
// 3. DRAW-LOOP (Hauptschleife)
// ==========================================
void draw(){
  
  if(width != previousWidth || height != previousHeight){

    updateLayout();
  
    for(WorldObject object : world_objects){
      object.updateLayoutPosition();
    }
  
    previousWidth = width;
    previousHeight = height;
  }
  
  background(0);
  
  if(game_over){
    screen.GAME_OVER();
  }
  else{
    
    newFruit();
    
    // Darstellung jedes einzelnen Objektes
    for(int i = 0; i < world_objects.size(); i++){
  
      WorldObject object = world_objects.get(i);
  
      if(object instanceof Teleporter){
        Teleporter t = (Teleporter) object;
        
        t.TPupdate();
        t.display();
      }
      else if(object instanceof Enemy){
  
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
    //text("Score: " + score + "\n Dots collected: " + dot_count, score_position.getX(), score_position.getY());
    popMatrix();
    
    for(Timer time : timer){
      pushMatrix();
      color(0, 0, 0);
      //text(time.timerName() + time.getTime(), score_position.getX(), 3);
      popMatrix();
    }
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
    Fruits fruit = new Fruits(13, 16);
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
  for (int i = last_life_x; i < lifes; i++) {
    Life life = new Life(2, map_width + i * 2);
    world_objects.add(life);
  }
}
