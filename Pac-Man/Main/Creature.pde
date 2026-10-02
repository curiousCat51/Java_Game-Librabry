class Creature extends WorldObject {
  CreatureDirections direction;
  CreatureDirections wish_direction;
  CollisionResult collision = new CollisionResult();
  GridPosition border_left = new GridPosition(0, 13);
  GridPosition border_right = new GridPosition(27, 13);
  int grid_x;
  int grid_y;
  
  float moveProgress = 1.0;

  float startPixelX;
  float startPixelY;
  
  float targetPixelX;
  float targetPixelY;
  
  int targetGridX;
  int targetGridY;
  
  float moveSpeed;
  
  Creature(WorldTypes type, int grid_x, int grid_y, float speed){
   super(type, grid_x, grid_y);
   direction = CreatureDirections.NEUTRAL;
   wish_direction = CreatureDirections.NEUTRAL;
   
   moveSpeed = speed;
   
   collision.setCollisionFilter(WorldTypes.WALL);
  }
  
  void changeDirection(CreatureDirections new_direction){
    wish_direction= new_direction;
  }
  
  void move(CreatureDirections chosen, ImageContainer image){

      
      int position[] = getPosition();
      GridPosition next;
      
      next = mapEndTP(position[0], position[1], chosen);      
      
  
      if(canMove(chosen)){
  
          updateDirection(chosen, image);
  
          startMovement(next.getX(), next.getY());
      }
  }
  
  // Richtung + Richtungsbild aktualisieren
  void updateDirection(CreatureDirections choosen, ImageContainer image){
    setImageContainer(image); 
    direction = choosen;
  }
  
  // Freie Richtung auswählen
  CreatureDirections getFreeDirection(){

      for(CreatureDirections dir : CreatureDirections.values()){
  
          if(dir == CreatureDirections.NEUTRAL){
              continue;
          }
  
          if(canMove(dir)){
              return dir;
          }
      }
  
      return CreatureDirections.NEUTRAL;
  }
  
  // Methode zur überprüfung, ob ein Tile in gewünschter Richtung frei ist
  boolean canMove(CreatureDirections dir){

    int[] XY = moveDic(dir);
    int x = XY[0];
    int y = XY[1];
    
    return collision.checkCollision(getGridX() + x, getGridY() + y);
  }
  
  // Eigenes "Dictionary" für eine gewählte Richtung
  int[] moveDic(CreatureDirections dir){
    
    int x = 0;
    int y = 0;

    if (dir == CreatureDirections.RECHTS) x = 1;
    if (dir == CreatureDirections.LINKS)   x = -1;
    if (dir == CreatureDirections.HOCH)    y = -1;
    if (dir == CreatureDirections.RUNTER)  y = 1;
    
    return new int[]{x,y};
  }
  
  // Ist eine Creatur am Spieler angekommen
  boolean isAtPlayer(){

      int[] position = getPosition();
  
      for(WorldObject object : world_objects){
  
          if(object instanceof Player){
  
              Player player = (Player) object;
  
              if(position[0] == player.getGridX() && position[1] == player.getGridY()){
                  return true;
              }
          }
      }
  
      return false;
  }
  
  // Startet die Bewegung zwischen Tilemittelpunkten ohne von der mittleren Linie abzukommen
  void startMovement(int targetX, int targetY){

      startPixelX = getPixelX();
      startPixelY = getPixelY();
  
      targetPixelX = convertToPixel(targetX);
      targetPixelY = convertToPixel(targetY);
  
      targetGridX = targetX;
      targetGridY = targetY;
  
      moveProgress = 0.0;
  }
  
 // Aktualisieren der Position zwischen Tilemittelpunkten
 void updateMovement(){

      if(moveProgress >= 1.0){
          return;
      }
  
      moveProgress += moveSpeed / TILE_SIZE;
  
      if(moveProgress > 1.0){
          moveProgress = 1.0;
      }
  
      float newPixelX = startPixelX +
          (targetPixelX - startPixelX) * moveProgress;
  
      float newPixelY = startPixelY +
          (targetPixelY - startPixelY) * moveProgress;
  
      setPixelX((int)newPixelX);
      setPixelY((int)newPixelY);
  
      if(moveProgress >= 1.0){
  
          setGridX(targetGridX);
          setGridY(targetGridY);
      }
  }
  
  // Überprüft ob eine Creatur sich grade zwischen zwei Tiles bewegt oder nicht
  boolean isMoving(){

      return moveProgress < 1.0;
  }
  
  // Teleport von einem zum anderen Ende der Karte
  GridPosition mapEndTP(int pos_x, int pos_y, CreatureDirections chosen){
    int[] XY = moveDic(chosen);
    GridPosition new_pos;
    
    if(getType() == WorldTypes.PLAYER){
      if(isAtSameTile(pos_x, pos_y, border_left.getX(), border_left.getY())){
        new_pos = new GridPosition(border_right.getX() + XY[0], border_right.getY() + XY[1]);
      }
      else if(isAtSameTile(pos_x, pos_y, border_right.getX(), border_right.getY())){
        new_pos = new GridPosition(border_left.getX() + XY[0], border_left.getY() + XY[1]);
      }
      else{
        new_pos = new GridPosition(pos_x + XY[0], pos_y + XY[1]);
      }
    }
    else{
      new_pos = new GridPosition(pos_x + XY[0], pos_y + XY[1]);
    }
    
    return new_pos;
  }
  
  boolean isAtSameTile(int pos_x1, int pos_y1, int pos_x2, int pos_y2){
    return pos_x1 == pos_x2 && pos_y1 == pos_y2;
  }
  
  // Gibt die aktuelle Richtung einer Creatur zurück
  CreatureDirections getDirection(){return this.direction;}
  
  // Methode zum Anzeigen der Creatur
  void display(){
    drawObject();
  }
}
