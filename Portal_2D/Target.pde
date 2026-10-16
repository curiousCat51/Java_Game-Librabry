class Target extends Sprite{
  
  KeyHandler EventListener;
  
  
  Target(int grid_x, int grid_y, KeyHandler EventListener){
    super(WorldTypes.TARGET, grid_x, grid_y);
    
    this.EventListener = EventListener;
  }
  
  int getDistanceToPlayer(Player player) {
    int distanceX = abs(grid_x - player.grid_x);
    int distanceY = abs(grid_y - player.grid_y);
  
    return distanceX + distanceY;
  }
}
