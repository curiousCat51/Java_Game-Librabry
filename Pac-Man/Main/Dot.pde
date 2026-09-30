class Dot extends WorldObject{
  NormalImage image;
  
  String iP = "data/images/Items/dot_";
  int dot_type;
  
  Dot(int grid_x, int grid_y, int dot_type){
    super(WorldTypes.DOT, grid_x, grid_y);

    this.dot_type = dot_type;
    
    switch(dot_type){
      
      case 1: iP = iP + "big"; break;
      case 2: iP = iP + "small"; break;
    }

    image = new NormalImage(iP);
    setImageContainer(image);
  }
  
  // Dot sammeln
  void collect(int x, int y){

    for(int i = world_objects.size() - 1; i >= 0; i--){

        WorldObject object = world_objects.get(i);

        if(object instanceof Dot){

            Dot dot = (Dot)object;

            if(x == dot.getGridX() && y == dot.getGridY()){

              switch(dot_type){
                case 1: score += 50; powerMode = true; powerTimer = 600; break; // Großer Dot
                case 2: score += 10; break; // Kleiner Dot
              }
              world_objects.remove(i);
            }
        }
    }
  }
}
