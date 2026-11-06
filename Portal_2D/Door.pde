class Door extends WorldObject{
 
  int link_id;
  boolean open = false;
  int link_count;
  
  Orientation orientation;
  
  ArrayList<Button> activeButtons = new ArrayList<Button>();
  
  Door(int grid_x, int grid_y, Orientation orientation, int link_id, int link_count){
   
    super(WorldTypes.DOOR, grid_x, grid_y);
    this.link_id = link_id;
    this.link_count = link_count;
    
    this.orientation = orientation;
    
    if(link_id == 0){
     open = true; 
    }
    
    println("link_id: " + link_id);
    println("link_count: " + link_count);
  }
  
  // Verändert den Tür Zustand, wenn die Bedingungen zum öffnen/ schließen erfüllt sind
  void updateDoor(){
    if(link_count == activeButtons.size()){
     open = true;
     return;
    }
    open = false;
  }
  
  // Button wird gedrückt
  void activateLink(Button button){
    
    for(Button b : activeButtons){
      if(b.grid_x == button.grid_x && b.grid_y == button.grid_y){
        return;
      }
      
      println(b);
      println(button);
      activeButtons.add(button);
    }
  }
  
  // Button wird nicht mehr gedrückt
  void deactivateLink(Button button){
   for(Button b : activeButtons){
     
    if(b.grid_x == button.grid_x && b.grid_y == button.grid_y){
      println(b);
      println(button);
      activeButtons.remove(b);
    }
   }
  }
}
