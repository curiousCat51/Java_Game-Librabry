class Player extends Sprite {

  KeyHandler keyHandler;
  
  int wishX = 0;
  int wishY = 0;
  

  Player(int grid_x, int grid_y, KeyHandler EventListener) {
    super(WorldTypes.PLAYER, grid_x, grid_y);

    keyHandler = EventListener;
  }
  
  void processInput(){
   wishX = 0;
   wishY = 0;
   
   if(EventListener.keyUp){
     wishY = -1;
   }
   else if(EventListener.keyDown){
    wishY = 1; 
   }
   else if(EventListener.keyLeft){
    wishX = -1; 
   }
   else if(EventListener.keyRight){
    wishX = 1; 
   }
  }
  
  boolean canMoveToTarget(World world) {
  
    // 1. Prüfen, ob das Zielfeld innerhalb der Karte liegt.
    if (targetGridX < 0 || targetGridX >= world.cols || targetGridY < 0 || targetGridY >= world.rows) {
      return false;
    }
  
    // 2. Die Zelle am berechneten Zielfeld abrufen.
    GridCell targetCell = world.grid[targetGridY][targetGridX];
  
    // 3. Prüfen, ob sich dort eine Wand befindet.
    for (WorldObject object : targetCell.objects) {
      if (object.type == WorldTypes.WALL) {
        return false;
      }
    }
  
    // 4. Das Zielfeld ist innerhalb der Karte und frei von Wänden.
    return true;
  }
  
  boolean tryMove(World world) {
  
    // Ohne Richtung gibt es keinen Bewegungsversuch.
    if (wishX == 0 && wishY == 0) {
      return false;
    }
  
    // Prüfen, ob das Zielfeld begehbar ist.
    if (!canMoveToTarget(world)) {
      return false;
    }
  
    // Das Zielfeld ist gültig.
    return true;
  }
}
