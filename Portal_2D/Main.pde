import java.util.ArrayDeque;

float BASE_TILE_SIZE = 32;
float ANIMATION_SPEED = 0.1f;

float LAYOUT_MARGIN = 20;

float SCALE = 1;
float TILE_SIZE = BASE_TILE_SIZE;
float PLAYER_SPEED = TILE_SIZE / 4;
float TARGET_SPEED = TILE_SIZE / 4;

float mapOffsetX;
float mapOffsetY;

int map_width;
int map_height;

ArrayList<WorldObject> world_objects;
ArrayList<GridPosition> free_tiles;
ArrayList<GridPosition> out_of_map;
ArrayList<Target> target;
ArrayList<Portal> portal;

boolean[][] blocked_tiles;

Player player;
KeyHandler EventListener;
ImageCache imageCache;

boolean portal_mode;
boolean place_portal;
int portalVersion = 1;

float deltaTime = 0.0f;
int lastFrameTime = 0;

boolean game_over = false;
boolean victory = false;

void setup(){
  size(255, 255);
  surface.setResizable(true);
  
  imageMode(CENTER);
  noSmooth();
  rectMode(CENTER);
  
  world_objects = new ArrayList<WorldObject>();
  free_tiles = new ArrayList<GridPosition>();
  out_of_map = new ArrayList<GridPosition>();
  target = new ArrayList<Target>();
  portal = new ArrayList<Portal>();
  
  imageCache = new ImageCache();
  EventListener = new KeyHandler();
  
  MapLoader loader = new MapLoader(world_objects);
  loader.loadMap("data/map/map1.txt");
  
  updateLayout();
}

void updateLayout(){
  
  if(map_width <= 0 || map_height <= 0){
    
    return;
  }
  
  float availableWidth = max(1, width);
  float availableHeight = max(1, height);
  
  float tileFromWidth = (availableWidth - 2 * LAYOUT_MARGIN) / map_width;
  float tileFromHeight = (availableHeight - 2 * LAYOUT_MARGIN) / map_height;
  
  TILE_SIZE = max(1, min(tileFromWidth, tileFromHeight));
  SCALE = TILE_SIZE / BASE_TILE_SIZE;
  
  float mapPixelWidth = map_width * TILE_SIZE;
  float mapPixelHeight = map_height * TILE_SIZE;
  
  mapOffsetX = (availableWidth - mapPixelWidth) * 0.5f;
  mapOffsetY = (availableHeight - mapPixelHeight) * 0.5f;
}

void windowResized(){
 updateLayout();
 
 for(WorldObject object : world_objects){
  object.updateLayoutPosition(); 
 }
}

void draw(){
  
  int currentTime = millis();
  
  deltaTime = (currentTime - lastFrameTime) / 1000.0f;
  
  lastFrameTime = currentTime;
  
  background(0, 255, 0);
  updateGame();
  renderGame();
}

void updateGame() {
  if (player != null) {
    player.updateProgress();
    player.move();
  }
}

void renderGame() {
  for (WorldObject object : world_objects) {
    object.drawObject();
  }
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
