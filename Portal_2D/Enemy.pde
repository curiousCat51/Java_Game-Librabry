class Enemy extends WorldObject{
 
  EnemyType enemyType;
  
  int health;
  
  int attackInterval;
  int attackTimer;
  
  int shootDirectionX;
  int shootDirectionY;
  
  int attackEffectTimer = 0;
  
  boolean areaAttackPending = false;
  int areaAttackWarningTimer = 0;
  int areaAttackWarningDuration = 30;
  
  Enemy(EnemyType enemyType, int grid_x, int grid_y, int health, int attackInterval, int shootDirectionX, int shootDirectionY){
   super(WorldTypes.ENEMY, grid_x, grid_y);
   
   this.enemyType = enemyType;
   this.health = health;
   this.attackInterval = attackInterval;
   this.attackTimer = 0;
   
   this.shootDirectionX = shootDirectionX;
   this.shootDirectionY = shootDirectionY;
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
}
