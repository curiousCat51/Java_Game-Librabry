import java.util.*;

// TODO:
// 30.10.2026
// - Letzter Gegnertyp <- fertig
// - Teleportationslogik für Gegner <- fertig
// - verschiedene Wandtypen <- fertig
// - Neuer Level Loader <- fertig
// - Türen und Buttons <- fertig
// 02.11.2026
// - Schliessende Tür verschiebt Spieler <- Fertig
// - Spieler kann Objekte heben <- fertig
// - Erweiterte Steuerung <- fertig
// - Kisten <- fertig
// - Lebensanzeige <- fertig
// 04.11.2026
// - Steuerungsanzeige
// - Neustart anpassen
// - Kamera
// - Bilder einbinden

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
    // world = loader.loadLevel("data/map/level_test.csv", EventListener);
    world = loader.loadLevel("data/map/observation_cells.csv", EventListener);
    
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
  
  updateCrateTeleportation();
  
  ArrayList<Enemy> defeatedEnemies = new ArrayList<Enemy>();
  
  for (WorldObject object : world.world_objects) {
    if (object instanceof Enemy) {
      Enemy enemy = (Enemy) object;
      enemy.updateAttackTimer();
      enemy.updateAttackEffect();
  
      // Bestehender Angriff: LINE_SHOOTER
      if (enemy.enemyType == EnemyType.LINE_SHOOTER && enemy.isAttackReady()) {
  
        Projectile projectile = new Projectile(enemy.getCurrentGridX(), enemy.getCurrentGridY(), enemy.shootDirectionX, enemy.shootDirectionY);
  
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
   // Es darf kein Portal platziert werden, wenn das Target sich innerhalb einer Barriere oder auf einer Tür befindet
   if(!world.isBarrierAt(target.grid_x, target.grid_y) && !world.isDoorAt(target.grid_x, target.grid_y)){
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
    boolean hitPlayer = player != null && projectile.hasHitPlayer(player);
    
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
    if (projectile.isOutsideWorld(world) || projectile.hasHitWall(world) || hitPlayer || hitAnEnemy || projectile.hasHitCrate(world, player)) {
      world.projectiles.remove(i);
    }
  }
  
  renderer.drawGrid(world, tile_size);
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

// Prüft, ob sich eine Kiste auf einem Portal befindet.
void updateCrateTeleportation(){
 
  for(WorldObject object : world.world_objects){
   
    if(!(object instanceof Crate)){
     
      continue; 
    }
    
    Crate crate = (Crate) object;
    
    world.tryTeleport(crate);
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
