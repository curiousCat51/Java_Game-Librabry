class Teleporter extends WorldObject{
  NormalImage image_active;
  NormalImage image_inactive;
  
  boolean isActive = true;
  boolean isTeleporting = false;
  
  String iP = "/data/images/Teleporter/teleporter_";
  
  
  int id;
  int connect_id = 0;
  String timer_name = "Teleporter " + id + " and "; 
  
  Teleporter(int grid_x, int grid_y, int tp_id){
    super(WorldTypes.TELEPORT, grid_x, grid_y);
    
    id = tp_id;
    
    image_inactive = new NormalImage(iP + "white");
    
    int result = TPVersion();
    
    switch(result){
      case 1: iP = iP + "orange"; break;
      case 2: iP = iP + "blue"; break;
    }
    
    image_active = new NormalImage(iP);
    setImageContainer(image_active);
  }
  
  void useTP(){
   setImageContainer(image_inactive);
   isActive = false;
  }
  
  // Conection zwischen zwei Teleportern finden
  int[] findConnection(int i){
    Teleporter t = null;
    int[] position = {0,0};
    
    for(WorldObject object : world_objects){
      if(object instanceof Teleporter){
        t = (Teleporter) object;
        connect_id = t.getID();
        if(connect_id == i){
          position = getPosition();
        }
      }
    }
    
    return new int[]{position[0], position[1]};
  }
  
  // Teleporter deaktivieren und cooldown starten
  void TPdeactivate(){
    isActive = false;
    timer.add(new Timer(timer_name + connect_id, 0, 60, 'i'));
  }
  
  // Teleporter reaktivieren und cooldown zurücksetzen
  void TPreactivate(){
    for(int i = 0; i < timer.size(); i++){
      Timer ti = timer.get(i);
      if(ti.getName() == timer_name + connect_id){
        if(ti.isfinish()){
          timer.remove(i);
          isActive = true;
        }
      }
    }
  }
  
  GridPosition TeleportTo(){
    if(!isActive()){
      return null;
    }
    
    int[] pos;
    
    if(TPVersion() == 1){
          
      pos = findConnection(id + 1);
      
    }
    else{
      
      pos = findConnection(id - 1);
    }
    
    return new GridPosition(pos[0], pos[1]);
  }
  
  int TPVersion(){
    if(id % 2 == 0){
      return 2;
    }
    return 1;
  }
  
  boolean isActive(){return isActive;}
  
  int getID(){return id;}
}
