class Creature extends WorldObject {
  CreatureDirections direction;
  CreatureDirections wish_direction;
  CollisionResult collision = new CollisionResult();
  
  float speed;
  float grid_x;
  float grid_y;
  
  Creature(WorldTypes type, float grid_x, float grid_y, float speed){
   super(type, grid_x, grid_y);
   direction = CreatureDirections.LINKS;
   this.speed = speed;
   
   collision.setCollisionFilter(WorldTypes.WALL);
  }
  
  void changeDirection(CreatureDirections new_direction){
    wish_direction= new_direction;
  }
  
  void move(CreatureDirections chosen, ImageContainer image, float speed){
      
   float[] XY = moveDic(chosen);
   float nextX = getPixelX() + XY[0] * speed;
   float nextY = getPixelY() + XY[1] * speed; 
   //println("MOVE: " + chosen + " | current: " + getPixelX() + ", " + getPixelY() + " | next: " + nextX + ", " + nextY + " | allowed: " + canMove(chosen, speed));   

   if (canMove(chosen, speed)){
      updateDirection(chosen, image);
      updatePosition(nextX, nextY);
      
      //println("AFTER MOVE: " + getPixelX() + ", " + getPixelY());
   }
  }
  
  void updateDirection(CreatureDirections choosen, ImageContainer image){
    setImageContainer(image); 
    direction = choosen;
  }
  
  void updatePosition(float pixel_x, float pixel_y){
    setPixelX(pixel_x);
    setPixelY(pixel_y);
  }
  
  void snapToTileCenter() {
    // Nächste Rasterposition berechnen
    float centerX = convertToPixel(convertToGrid(getPixelX()));
    float centerY = convertToPixel(convertToGrid(getPixelY()));
  
    // Position am Raster ausrichten
    setPixelX(centerX);
    setPixelY(centerY);
  }
  
  // Methode zur überprüfung, ob ein Tile in gewünschter Richtung frei ist
  boolean canMove(CreatureDirections dir, float speed){

    float[] XY = moveDic(dir);
    float x = XY[0];
    float y = XY[1];
    
    return collision.checkCollision(getPixelX() + x * speed, getPixelY() + y * speed, speed);
  }
  
  float[] moveDic(CreatureDirections dir){
    
    float x = 0;
    float y = 0;

    if (dir == CreatureDirections.RECHTS) x = 1;
    if (dir == CreatureDirections.LINKS)   x = -1;
    if (dir == CreatureDirections.HOCH)    y = -1;
    if (dir == CreatureDirections.RUNTER)  y = 1;
    
    return new float[]{x,y};
  }
  
  // Methode zur Überprüfung, ob das Objekt in der Mitte eines Tiles ist
  boolean isAtTileCenter() {
    float centerX = convertToPixel(convertToGrid(getPixelX())); 
    float centerY = convertToPixel(convertToGrid(getPixelY()));
  

    if(abs(getPixelX() - centerX) < 0.1 &&
       abs(getPixelY() - centerY) < 0.1){
  
      updatePosition(centerX, centerY);
      return true;
    }
  
    return false;
  }
}
