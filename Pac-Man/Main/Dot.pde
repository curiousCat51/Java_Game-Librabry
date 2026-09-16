class Dot extends WorldObject{
  NormalImage image;
  
  String iP = "data/images/Items/dot_";
  
  Dot(float grid_x, float grid_y, int dot_type){
    super(WorldTypes.DOT, grid_x, grid_y);
    
    if(dot_type == 1){
      iP = iP + "big";
    }
    else{
      iP = iP + "small";
    }
    image = new NormalImage(iP);
    setImageContainer(image);
  }
}
