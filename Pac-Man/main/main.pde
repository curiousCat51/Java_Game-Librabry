float SCALE = 2;
float TILE_SIZE = 16 * SCALE;
float PLAYER_SPEED = 0.7f * SCALE;
float ENEMY_SPEED = 0.8f * SCALE;
float ANIMATION_SPEED = 0.1f;

ArrayList<WorldObject> world_objects;
KeyHandler EventListener;

void setup(){
  size(1024, 1024);
  imageMode(CENTER);
  rectMode(CENTER);
  noSmooth();
  world_objects = new ArrayList<WorldObject>();
  new MapLoader(world_objects);
  EventListener = new KeyHandler();
}

void draw(){
  background(0);
  for(int i = 0; i < world_objects.size(); i++){
   WorldObject object = world_objects.get(i); 
   object.drawObject();
  }
}

void keyPressed(){
  EventListener.Pressed();
  WorldObject object = (WorldObject) world_objects.get(0);
  Player p = new Player(object.convertToGrid(object.getPixelX()), object.convertToGrid(object.getPixelY()), PLAYER_SPEED);
  p.move();
}

void keyReleased(){
  EventListener.Released();
}
