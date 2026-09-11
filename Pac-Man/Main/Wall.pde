class Wall extends WorldObject{
 NormalImage image;
 
 Wall(float grid_x, float grid_y){
   super(WorldTypes.WALL, grid_x, grid_y);
   image = new NormalImage("Assets/");
 }
}
