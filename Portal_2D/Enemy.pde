class Enemy extends Sprite{
 
  EnemyType enemyType;
  
  Barrier barrier;
  
  int health;
  
  int attackInterval;
  int attackTimer;
  
  int shootDirectionX;
  int shootDirectionY;
  
  int attackEffectTimer = 0;
  
  boolean areaAttackPending = false;
  int areaAttackWarningTimer = 0;
  int areaAttackWarningDuration = 30;
  
  int moveDirectionX = 0;
  int moveDirectionY = 1;
  
 Enemy(EnemyType enemyType, int grid_x, int grid_y, int shootDirectionX, int shootDirectionY) {
  super(WorldTypes.ENEMY, grid_x, grid_y);

  this.enemyType = enemyType;
  this.health = 3;
  this.attackInterval = 60;
  this.attackTimer = 0;
  this.shootDirectionX = shootDirectionX;
  this.shootDirectionY = shootDirectionY;

  if (enemyType == EnemyType.BARRIER_CREATOR) {
    barrier = new Barrier(this);
  }
}
  
  // Erzeugt eine Warnung bei Flächenangriff
  void startAreaAttackWarning(){
    areaAttackPending = true;
    areaAttackWarningTimer = areaAttackWarningDuration;
  }
  
  // Updated den Zustand der Angriffswarnung
  void updateAreaAttackWarning() {
    if (areaAttackPending && areaAttackWarningTimer > 0) {
      areaAttackWarningTimer--;
    }
  }
  
  // Prüft ob ein Flächenangriff stattfinden darf
  boolean isAreaAttackReady() {
    return areaAttackPending && areaAttackWarningTimer <= 0;
  }
  
  // Lässt den AttackTimer durchlaufen
  void updateAttackTimer(){
   if(attackTimer < attackInterval){
    attackTimer++; 
   }
  }
  
  // Prüft ob der Gegner angreifen kann
  boolean isAttackReady(){
   return attackTimer >= attackInterval; 
  }
  
  // Erzeugt einen Effekt für die Attacke
  void startAttackEffect(){
   attackEffectTimer = 12; 
  }
  
  // Updated den AttackEffectTimer
  void updateAttackEffect(){
   if(attackEffectTimer > 0){
     attackEffectTimer--;
   }
  }
  
  // Setzt den AttackTimer zurück
  void resetAttackTimer(){
   attackTimer = 0; 
  }
  
  // Fügt dem Gegner Schaden zu
  void takeDamage(int damage){
   health -= damage;
   
   health = max(0, health);
   
   println("Gegner-Lebenspunkte: " + health);
  }
  
  // Prüft ob sich bsw der Spieler im Angriffsradius befindet
  boolean isInAttackRange(WorldObject target){
    if(target == null){
     return false; 
    }
    
    int distance = abs(grid_x - target.grid_x) + abs(grid_y - target.grid_y);
    
    return distance == 1;
  }
  
  // Aktualisiert die Bewegungsrichtung des Gegners
  void setMovementDirection(int directionX, int directionY){
   if(abs(directionX) + abs(directionY) != 1){
     return;
   }
   
   moveDirectionX = directionX;
   moveDirectionY = directionY;
  }
  
  @Override boolean canActivateButton(){
    return true; 
  }
}
