class Fruits extends WorldObject{
 NormalImage image;
 
 String iP = "data/images/Items/";
 
 Fruits(float grid_x, float grid_y, int fruit_type){
  super(WorldTypes.FRUIT, grid_x, grid_y);
  
  if(fruit_type == 1){
    iP = iP + "apple";
  }
  else if(fruit_type == 2){
    iP = iP + "cherry";
  }
  else if(fruit_type == 3){
    iP = iP + "orange";
  }
  else{
    iP = iP + "strawberry";
  }
  
  image = new NormalImage(iP);
 }
}
