class Life extends WorldObject{
  NormalImage[] images;
  
  String iP;
  
  boolean alive = true;
  
  int damage_state = 0;
  
  Life(int grid_x, int grid_y){
    super(WorldTypes.LIFE, grid_x, grid_y);
    
    images = new NormalImage[7];
    
    int j = 6;
    
    for(int i = 0; i < images.length; i++){
      iP = "data/images/Visuals/heart_" + j;
      images[i] = new NormalImage(iP);
      j--;
    }
    
    setImageContainer(images[0]);
  }
  
  void damage(){
    
    if(!alive){
      return;
    }
    
    damage_state++;
    
    setImageContainer(images[damage_state]);
    
    if(damage_state == 6){
      alive = false;
      lifes--;
    }    
  }
  
  boolean getState(){return alive;}
  
  void display(){
      drawObject();
  }
}
