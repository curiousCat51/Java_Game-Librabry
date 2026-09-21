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
  }
  
  void changeDirection(CreatureDirections new_direction){
    wish_direction= new_direction;
  }
  
  void move(float x, float y , CreatureDirections chosen, ImageContainer image, float speed){
   // TODO 
     float nextX = getPixelX() + x * speed;
     float nextY = getPixelY() + y * speed;
      
          
     if (collision.checkCollision(nextX, nextY)) {
        update(nextX, nextY, chosen, image);
      }
  }
  
  void update(float pixel_x, float pixel_y, CreatureDirections choosen, ImageContainer image){
    setPixelX(pixel_x);
    setPixelY(pixel_y);
    setImageContainer(image); 
    direction = choosen;
  }
}
