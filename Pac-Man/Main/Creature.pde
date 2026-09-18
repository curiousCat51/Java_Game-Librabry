class Creature extends WorldObject {

  CreatureDirections direction;
  CreatureDirections wish_direction;
  CollisionResult collision;
  
  float speed;
  float grid_x;
  float grid_y;
  
  Creature(WorldTypes type, float grid_x, float grid_y, float speed){
   super(type, grid_x, grid_y);
   direction = CreatureDirections.LINKS;
   this.speed = speed;
   
   // collision filter setzen
  }
  
  void changeDirection(CreatureDirections new_direction){
    wish_direction= new_direction;
  }
  
  void move(float x, float y , CreatureDirections choosen, ImageContainer image, float speed){
   // TODO 
   float pixel_x;
   float pixel_y;
    
        
   if(x == 0){
     pixel_x = getPixelX();
   }
   else{
     pixel_x = getPixelX() + x * speed;
   }
   
   if(y == 0){
     pixel_y = getPixelY();
   }
   else{
     pixel_y = getPixelY() + y * speed;
   }
   
   if(collision.checkCollision(pixel_x, pixel_y)){
     update(pixel_x, pixel_y , choosen, image);
   }
   else{
     update(getPixelX(), getPixelY(), choosen, image);
   }   
  
  }
  
  void update(float pixel_x, float pixel_y, CreatureDirections choosen, ImageContainer image){
    setPixelX(pixel_x);
    setPixelY(pixel_y);
    setImageContainer(image); 
    direction = choosen;
  }
}
