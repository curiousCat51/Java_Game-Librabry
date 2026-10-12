int tile_size = 24;
int speed = tile_size / 2;

HashMap<String, Target> target = new HashMap<String, Target>();
HashMap<String, Teleporter> teleporter = new HashMap<String, Teleporter>();
KeyHandler EventListener;
Player player = new Player(12, 12);

boolean portal_mode;
boolean place_portal;
String portalVersion = "1";

void setup(){
  size(255, 255);
  rectMode(CENTER);
  imageMode(CENTER);
  
  EventListener = new KeyHandler();
}

void draw(){
  background(0);
  
  println("PortalMode: " + portal_mode + "\nPortal Version: " + portalVersion);
  
  if(!portal_mode){
    player.updateGrid();
  }
  else{
    player.placePortal();
    
    Target t = target.get(portalVersion);
    
    t.updateGrid();
    t.display();
  }
  
  player.display();
  
}

void keyPressed() {
  if (EventListener != null) {
    EventListener.Pressed();
  }
}

void keyReleased() {
  if (EventListener != null) {
    EventListener.Released();
  }
}
