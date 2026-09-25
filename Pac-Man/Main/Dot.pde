class Dot extends WorldObject{
  NormalImage image;
  
  String iP = "data/images/Items/dot_";
  int dot_type;
  
  Dot(int grid_x, int grid_y, int dot_type){
      super(WorldTypes.DOT, grid_x, grid_y);
  
      this.dot_type = dot_type;
  
      if(dot_type == 1){
          iP = iP + "big";
      }
      else{
          iP = iP + "small";
      }
  
      image = new NormalImage(iP);
      setImageContainer(image);
  }
  
  void collectDots(){

    for(int i = world_objects.size() - 1; i >= 0; i--){

        WorldObject object = world_objects.get(i);

        if(object instanceof Dot){

            Dot dot = (Dot)object;

            if(getGridX() == dot.getGridX() &&
               getGridY() == dot.getGridY()){

                if(dot.dot_type == 0){
                    // Kleiner Dot
                    score += 10;
                }

                if(dot.dot_type == 1){
                    // Großer Dot
                    if(dot.dot_type == 1){
                        powerMode = true;
                        powerTimer = 600;
                    }
                }

                world_objects.remove(i);
            }
        }
    }
}
}
