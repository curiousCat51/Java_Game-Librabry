class Creature extends WorldObject{

  CreatureDirections direction;
  CreatureDirections wish_direction;
  float speed;
  // collision filter
  
  Creature(WorldTypes type, float grid_x, float grid_y, float speed){
   super(type, grid_x, grid_y);
   direction = CreatureDirections.UP;
   this.speed = speed;
  }
  
  void changeDirection(CreatureDirections new_direction){
    wish_direction= new_direction;
  }
  
  void move(){
   // TODO 
  }
  
  // CollisionRersult checkCollision(float move_x, float move_y)
  // set Collision filter
  
  void update(){ 
  }
}
