class Creature extends WorldObject{

  CreatureDirections direction;
  CreatureDirections wish_direction;
  float speed;
  float grid_x;
  float grid_y;
  // collision filter
  
  Creature(WorldTypes type, float grid_x, float grid_y, float speed){
   super(type, grid_x, grid_y);
   direction = CreatureDirections.LINKS;
   this.speed = speed;
  }
  
  void changeDirection(CreatureDirections new_direction){
    wish_direction= new_direction;
  }
  
  void move(){
   // TODO replace a maploaded tile with the player if not a wall or enemy
  }
  
  // CollisionRersult checkCollision(float move_x, float move_y)
  // set Collision filter
  
  void update(float x, float y , WorldTypes type, ImageContainer image, float speed){
    for(int i = 0; i < world_objects.size(); i++){
      if(world_objects.get(i).getType() == type){
        WorldObject object = (WorldObject) world_objects.get(i);
        grid_x = (object.convertToGrid(object.getPixelX()) + object.convertToGrid(x)) * speed;
        grid_y = (object.convertToGrid(object.getPixelY()) + object.convertToGrid(y)) * speed;
        object.setPixelX(object.convertToPixel(grid_x));
        object.setPixelY(object.convertToPixel(grid_y));
        object.setImageContainer(image);
      }
    }  
    direction = wish_direction;
  }
}
