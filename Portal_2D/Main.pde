import java.util.*;

// TODO:
// - Letzter Gegnertyp <- fertig
// - Teleportationslogik für Gegner <- fertig
// - verschiedene Wandtypen <- fertig
// - Türen und Buttons <- dran
// - Neuer Level Loader <- dran
// - Neustart anpassen
// - Bilder einbinden
// - Kamera
// - (Boxen)

World world;
Player player;
Target target;
WorldRenderer renderer;
KeyHandler EventListener;

int tile_size = 32;
int target_distance = 4;

boolean gameOver = false;

void setup(){
 //fullScreen();
 size(512, 512);
 
 renderer = new WorldRenderer();
 EventListener = new KeyHandler();
 
    LevelLoader loader = new LevelLoader();
    world = loader.loadLevel("data/map/level_test.csv", EventListener);
    
    if (world == null) {
      println("Level konnte nicht geladen werden.");
      return;
    }
    
    // Player suchen
    player = null;
    target = null;
    
    for (WorldObject obj : world.world_objects) {
      if (obj.type == WorldTypes.PLAYER) {
        player = (Player) obj;
        break;
      }
    }
    
    // Target erstellen
    if (player != null) {
      target = new Target(player.grid_x, player.grid_y, EventListener);
      world.registerObject(target, target.grid_x, target.grid_y);
    } else {
      println("Fehler: Kein Player gefunden.");
    }
    
    world = loader.loadLevel("data/map/observation_cells.csv", EventListener);
  
  //loadLevel("data/map/observation_cells.csv");
}


void draw() {
  background(200);
  
  if (!EventListener.portal_mode && player != null && target != null) {
    target.resetToPlayer(player);
  }

  if (world == null) {
    return;
  }
  
  if(gameOver){
    background(0);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("GAME OVER", width / 2, height / 2);
    return;
  }
  
  updateEnemyTeleportation();
  
  ArrayList<Enemy> defeatedEnemies = new ArrayList<Enemy>();
  
  for (WorldObject object : world.world_objects) {
    if (object instanceof Enemy) {
      Enemy enemy = (Enemy) object;
      enemy.updateAttackTimer();
      enemy.updateAttackEffect();
  
      // Bestehender Angriff: LINE_SHOOTER
      if (enemy.enemyType == EnemyType.LINE_SHOOTER && enemy.isAttackReady()) {
  
        Projectile projectile = new Projectile(enemy.grid_x, enemy.grid_y, enemy.shootDirectionX, enemy.shootDirectionY);
  
        world.addProjectile(projectile);
        enemy.resetAttackTimer();
      }
  
      // AREA_ATTACKER: Vorwarnung starten
      if (enemy.enemyType == EnemyType.AREA_ATTACKER && !enemy.areaAttackPending && enemy.isAttackReady()) {
        enemy.startAreaAttackWarning();
      }
      
      // Vorwarnzeit aktualisieren
      enemy.updateAreaAttackWarning();
      
      // AREA_ATTACKER: Angriff nach der Vorwarnung
      if (enemy.enemyType == EnemyType.AREA_ATTACKER && enemy.isAreaAttackReady()) {
      
        enemy.startAttackEffect();
      
        for (WorldObject target : world.world_objects) {
          if (target == enemy) {
            continue;
          }
      
          if (enemy.isInAttackRange(target)) {
            if (target instanceof Player) {
              ((Player) target).takeDamage(1);
      
              if (((Player) target).health <= 0) {
                gameOver = true;
              }
            } else if (target instanceof Enemy) {
              Enemy targetEnemy = (Enemy) target;
              targetEnemy.takeDamage(1);
      
              if (targetEnemy.health <= 0 && !defeatedEnemies.contains(targetEnemy)) {
                defeatedEnemies.add(targetEnemy);
              }
            }
          }
        }
      
        enemy.areaAttackPending = false;
        enemy.resetAttackTimer();
      }
    }
  }
  
  for(Enemy defeatedEnemy : defeatedEnemies){
   world.removeObject(defeatedEnemy, defeatedEnemy.grid_x, defeatedEnemy.grid_y); 
  }
  
  if (player != null) {
    player.updateMovementInput(world);
  }
  
  if(target != null){
   target.updateMovementInput(player, world); 
  }
  
  if (world != null) {
    world.updateButtons();
  }
  
 // Portal-Modus abbrechen
 if(EventListener.cancelPortalRequested){
  EventListener.portal_mode = false;
  EventListener.selectedPortalType = null;
  EventListener.cancelPortalRequested = false;
  EventListener.placePortalRequested = false;
 }
 
 
  // Ausgewähltes Portal platzieren
 if(EventListener.portal_mode && EventListener.placePortalRequested && EventListener.selectedPortalType != null && target != null && world != null){
   // Es darf kein Portal platziert werden, wenn das Target sich innerhalb einer Barriere befindet
   if(!world.isBarrierAt(target.grid_x, target.grid_y)){
     world.placePortal(EventListener.selectedPortalType, target.grid_x, target.grid_y);
     
     EventListener.placePortalRequested = false;
     EventListener.portal_mode = false;
     EventListener.selectedPortalType = null;
   }
   else{
    EventListener.cancelPortalRequested = true; 
   }
 }
 
 if(EventListener.portal_mode && target != null && player != null){
   renderer.drawRangeCells(target, player, world, tile_size);
 }
 
 Player player = null;
 
 for(WorldObject object : world.world_objects){
   if(object instanceof Player){
    player = (Player) object;
    break;
   }
 }
  
  for (int i = world.projectiles.size() - 1; i >= 0; i--) {
    Projectile projectile = world.projectiles.get(i);
  
    projectile.update();
    
    world.tryTeleport(projectile);
    
    projectile.draw(tile_size);
  
    // Prüfen, ob der Spieler getroffen wurde
    boolean hitPlayer = player != null
        && projectile.hasHitPlayer(player);
    
    if (hitPlayer) {
      player.takeDamage(1);
    
      if (player.health <= 0) {
        gameOver = true;
      }
    }
    
    // Prüfen, ob ein Gegner getroffen wurde
    Enemy hitEnemy = null;
    
    for (WorldObject object : world.world_objects) {
      if (object instanceof Enemy) {
        Enemy enemy = (Enemy) object;
    
        if (projectile.hasHitEnemy(enemy)) {
          hitEnemy = enemy;
          break;
        }
      }
    }
    
    boolean hitAnEnemy = hitEnemy != null;
    
    if (hitAnEnemy) {
      hitEnemy.takeDamage(1);
    }
    
    // Besiegten Gegner aus der Welt entfernen
    if (hitEnemy != null && hitEnemy.health <= 0) {
      world.removeObject(hitEnemy, hitEnemy.grid_y, hitEnemy.grid_x);
    }
    
    // Projektil entfernen, wenn es eine Grenze, eine Wand, den Spieler oder einen Gegner trifft
    if (projectile.isOutsideWorld(world) || projectile.hasHitWall(world) || hitPlayer || hitAnEnemy) {
      world.projectiles.remove(i);
    }
  }
  
  renderer.drawGrid(world, tile_size);
}


// Lädt die gewünschte Karte als Welt
void loadLevel(String filename) {
  String[] lines = loadStrings(filename);

  if (lines == null || lines.length == 0) {
    println("Fehler: Level-Datei konnte nicht geladen werden.");
    return;
  }

  int rows = lines.length;
  int cols = split(lines[0], ',').length;

  // 1. Welt erstellen, bevor Objekte registriert werden
  world = new World(cols, rows);

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

          world.registerObject(player, col, row);
          
          target = new Target(player.grid_x, player.grid_y, EventListener);

          world.registerObject(target, target.grid_x, target.grid_y);
          break;
          
        case 2:
          
          Wall wall = new Wall(col, row, WallType.GERADE, Orientation.SENKRECHT);
          
          world.registerObject(wall, col, row);
          break;
          
        case 3:
        
          Portal portal_a = new Portal(WorldTypes.PORTAL_A, col, row);
          
          world.registerObject(portal_a, col, row);
          break;
          
        case 4:
        
          Portal portal_b = new Portal(WorldTypes.PORTAL_B, col, row);
          
          world.registerObject(portal_b, col, row);
          break;

        default:
          println("Unbekannter Objekttyp: " + objectType);
          break;
      }
    }
  }
  
   //Testgegner erzeugen und regristrieren
   Enemy enemy1 = new Enemy(EnemyType.LINE_SHOOTER, 0, 2, 1, 0);
  
   world.registerObject(enemy1, enemy1.grid_x, enemy1.grid_y);
  
   Enemy enemy2 = new Enemy(EnemyType.AREA_ATTACKER, 3, 5, 0, 1);
  
   world.registerObject(enemy2, enemy2.grid_x, enemy2.grid_y);
  
  Enemy enemy3 = new Enemy(EnemyType.BARRIER_CREATOR, 3, 1, 0, 1);
  
  enemy3.setMovementDirection(0, 1);
  
  world.registerObject(enemy3, enemy3.grid_x, enemy3.grid_y);

  // 3. Aktuellen Zustand kontrollieren
  println("Level geladen: " + rows + " Zeilen, " + cols + " Spalten.");
  println("Registrierte Objekte: " + world.world_objects.size());

  for (WorldObject object : world.world_objects) {
    println("Typ: " + object.type + " | Grid X: " + object.grid_x + " | Grid Y: " + object.grid_y);
  }
}

// Prüft, ob sich ein Gegner auf einem Portal befindet.
void updateEnemyTeleportation(){
 
  for(WorldObject object : world.world_objects){
   
    if(!(object instanceof Enemy)){
     
      continue; 
    }
    
    Enemy enemy = (Enemy) object;
    
    world.tryTeleport(enemy);
  }
}

void restartGame(){
 if(player != null){
  player.resetHealth(); 
 }
 
 world.projectiles.clear();
 gameOver = false;
}

void keyPressed(){
 if(EventListener != null){
  EventListener.handleKeyPressed(keyCode); 
 }
 
 // Verhindert, das Processing bei ESC den Sketch beendet.
 if(key == ESC){
  key = 0; 
 }
}

void keyReleased(){
  if(EventListener != null){
   EventListener.handleKeyReleased(keyCode); 
  }
}
