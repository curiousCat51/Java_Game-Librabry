class Player extends Creature{
  AnimationImage image_right;
  AnimationImage image_left;
  
  int grid_x;
  int grid_y;
  
  Player(int grid_x, int grid_y, float speed){
    super(WorldTypes.PLAYER, grid_x, grid_y, speed);
    
    image_right = new AnimationImage("data/images/Pac-Man/pac-man_walk_right_", 4, ANIMATION_SPEED);
    image_left = new AnimationImage("data/images/Pac-Man/pac-man_walk_left_", 4, ANIMATION_SPEED);
    
    setImageContainer(image_left);
    
    this.grid_x = grid_x;
    this.grid_y = grid_y;
    
    collision.setCollisionFilter(WorldTypes.WALL);
  }
  
  void move(){

      // Eingabe auswerten
  
      if(EventListener.getKeyUP()){
          wish_direction = CreatureDirections.HOCH;
      }
  
      if(EventListener.getKeyDOWN()){
          wish_direction = CreatureDirections.RUNTER;
      }
  
      if(EventListener.getKeyLEFT()){
          wish_direction = CreatureDirections.LINKS;
      }
  
      if(EventListener.getKeyRIGHT()){
          wish_direction = CreatureDirections.RECHTS;
      }
  
  
      // Aktuelle Bewegung weiterführen
  
      updateMovement();
  
      if(isMoving()){
          return;
      }
  
  
      // Gewünschte Richtung ausprobieren
  
      if(wish_direction != CreatureDirections.NEUTRAL &&
         canMove(wish_direction)){
  
          switch(wish_direction){
  
              case HOCH:
                  move(wish_direction, image_left);
                  break;
  
              case RUNTER:
                  move(wish_direction, image_right);
                  break;
  
              case LINKS:
                  move(wish_direction, image_left);
                  break;
  
              case RECHTS:
                  move(wish_direction, image_right);
                  break;
  
              case NEUTRAL:
                  break;
          }
  
          return;
      }
  
  
      // Falls Wunschrichtung blockiert ist:
      // aktuelle Richtung weiterlaufen
  
      if(direction != CreatureDirections.NEUTRAL &&
         canMove(direction)){
  
          switch(direction){
  
              case HOCH:
                  move(direction, image_left);
                  break;
  
              case RUNTER:
                  move(direction, image_right);
                  break;
  
              case LINKS:
                  move(direction, image_left);
                  break;
  
              case RECHTS:
                  move(direction, image_right);
                  break;
  
              case NEUTRAL:
                  break;
          }
      }
  }
    // TODO replace a maploaded tile with the player if not a wall or enemy
  
}
