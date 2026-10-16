import java.util.*;

World world;
Player player;
Target target;
WorldRenderer renderer;
KeyHandler EventListener;

int tile_size = 32;


void setup(){
 //fullScreen();
 size(512, 512);
 
 renderer = new WorldRenderer();
 EventListener = new KeyHandler();
 
 loadLevel("data/map/observation_cells.csv");
}


void draw() {
  background(200);

  if (world == null) {
    return;
  }
  
  if (player != null) {
    player.updateMovementInput(world);
  }
  
  renderer.drawGrid(world, tile_size);
}



void loadLevel(String filename) {
  String[] lines = loadStrings(filename);

  if (lines == null || lines.length == 0) {
    println("Fehler: Level-Datei konnte nicht geladen werden.");
    return;
  }

  int rows = lines.length;
  int cols = split(lines[0], ',').length;

  // 1. Welt erstellen, bevor Objekte registriert werden
  world = new World(rows, cols);

  // 2. CSV auslesen und Objekte erzeugen
  for (int row = 0; row < rows; row++) {
    String[] values = split(lines[row], ',');

    for (int col = 0; col < cols; col++) {
      int objectType = int(trim(values[col]));

      switch (objectType) {
        case 0:
          // Leere Zelle: kein Objekt erzeugen
          break;

        case 1:
          // x = col, y = row
          player = new Player(col, row, EventListener);

          world.registerObject(player, row, col);
          
          target = new Target(player.grid_x, player.grid_y, EventListener);

          world.registerObject(target, target.grid_y, target.grid_x);
          break;
          
        case 2:
          
          Wall wall = new Wall(col, row);
          
          world.registerObject(wall, row, col);
          break;
          
        case 3:
        
          Portal portal_a = new Portal(WorldTypes.PORTAL_A, col, row);
          
          world.registerObject(portal_a, row, col);
          break;
          
        case 4:
        
          Portal portal_b = new Portal(WorldTypes.PORTAL_B, col, row);
          
          world.registerObject(portal_b, row, col);
          break;

        default:
          println("Unbekannter Objekttyp: " + objectType);
          break;
      }
    }
  }

  // 3. Aktuellen Zustand kontrollieren
  println("Level geladen: " + rows + " Zeilen, " + cols + " Spalten.");
  println("Registrierte Objekte: " + world.world_objects.size());

  for (WorldObject object : world.world_objects) {
    println("Typ: " + object.type + " | Grid X: " + object.grid_x + " | Grid Y: " + object.grid_y);
  }
}

void keyPressed(){
 if(EventListener != null){
  EventListener.handleKeyPressed(keyCode); 
 }
}

void keyReleased(){
  if(EventListener != null){
   EventListener.handleKeyReleased(keyCode); 
  }
}
