class Life extends WorldObject{
  NormalImage[] images;
  
  String iP;
  
  boolean alive = true;
  
  int animation_frame = 0;
  
  boolean in_animation = false;
  
  float animation_timer = 0;
  
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
    
    if(in_animation || !alive){
      return;
    }
    in_animation = true;
    animation_frame = 0;
    animation_timer = 0;
    
    lifes--;
  }
  
  void updateAnimation(){
    if(!in_animation){
      return;
    }
    
    animation_timer++;
    
    if(animation_timer >= 8){
      animation_timer = 0;
      
      if(animation_frame < images.length - 1){
        animation_frame++;
        setImageContainer(images[animation_frame]);
      }
      else{
        in_animation = false;
        alive = false;
      }
    }
  }
  
  void lost(){
    if(!alive && !in_animation){
      for(int i = 0; i < world_objects.size(); i++){
        
        WorldObject object = world_objects.get(i);
        
        if(object instanceof Life){
          Life l = (Life) object;
          
          int[] position = l.getPosition();
          
          if(position[0] == getGridX() && position[1] == getGridY()){
            world_objects.remove(i);
          }
        }
      }
    }
  }
  
  boolean getState(){return alive;}
  
  void display(){
      drawObject();
  }
}
