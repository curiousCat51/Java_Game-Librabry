import java.util.HashMap;
import java.util.ArrayDeque;

// ============================================================
// Pac-Man - Processing-native Hauptsketch
// ============================================================
// Gemeinsamer Zustand liegt in den normalen Sketch-Variablen.

int BASE_TILE_SIZE = 16;
float CREATURE_PIXELS_PER_FRAME = 0.6f;
float ANIMATION_SPEED = 0.1f;

int POWER_MODE_DURATION_FRAMES = 600;
int FRUIT_SPAWN_DOT_COUNT = 70;
int BONUS_LIFE_SCORE = 10000;
int INITIAL_LIVES = 3;
int MAX_HUD_LIVES = 3;

float LAYOUT_MARGIN = 20;
float SIDE_PANEL_MIN_WIDTH = 180;
float SIDE_PANEL_MAX_WIDTH = 320;

float SCALE = 1;
float TILE_SIZE = BASE_TILE_SIZE;
float PLAYER_SPEED = CREATURE_PIXELS_PER_FRAME;
float ENEMY_SPEED = CREATURE_PIXELS_PER_FRAME;

float sidePanelWidth;
float mapOffsetX;
float mapOffsetY;

int map_width;
int map_height;

ArrayList<WorldObject> world_objects;
ArrayList<GridPosition> free_tiles;
ArrayList<GridPosition> out_of_map;
ArrayList<Timer> timer;
ArrayList<Enemy> enemies;

boolean[][] blocked_tiles;

Player player;
KeyHandler EventListener;
Screens screen;
HUD hud;
ImageCache imageCache;

int score = 0;
int ghost_score = 200;
int dot_count = 0;
int total_dot_count = 0;

boolean powerMode = false;
int powerTimer = 0;

boolean fruit_spawned = false;
int fruit_pos_x = -1;
int fruit_pos_y = -1;

int lifes = INITIAL_LIVES;
int bonus_lebenS = 0;
int fruit_count = 0;
int[] fruit_counts = new int[8];

boolean game_over = false;
boolean victory = false;

void setup() {
  size(1024, 768);
  surface.setResizable(true);

  imageMode(CENTER);
  noSmooth();

  world_objects = new ArrayList<WorldObject>();
  free_tiles = new ArrayList<GridPosition>();
  out_of_map = new ArrayList<GridPosition>();
  timer = new ArrayList<Timer>();
  enemies = new ArrayList<Enemy>();

  imageCache = new ImageCache();
  EventListener = new KeyHandler();
  screen = new Screens();

  MapLoader loader = new MapLoader(world_objects);
  loader.loadMap("data/map/map1.txt");

  updateLayout();
  hud = new HUD();

}

// ============================================================
// Layout / Responsive Scaling
// ============================================================

void updateLayout() {
  if (map_width <= 0 || map_height <= 0) {
    return;
  }

  sidePanelWidth = constrain(width * 0.25f, SIDE_PANEL_MIN_WIDTH, SIDE_PANEL_MAX_WIDTH);

  float availableWidth = max(1, width - sidePanelWidth);
  float availableHeight = max(1, height);

  float tileFromWidth = (availableWidth - 2 * LAYOUT_MARGIN) / map_width;
  float tileFromHeight = (availableHeight - 2 * LAYOUT_MARGIN) / map_height;

  // Ein einziger Skalierungsfaktor verhindert Verzerrungen.
  TILE_SIZE = max(1, min(tileFromWidth, tileFromHeight));
  SCALE = TILE_SIZE / BASE_TILE_SIZE;

  float mapPixelWidth = map_width * TILE_SIZE;
  float mapPixelHeight = map_height * TILE_SIZE;

  // Die Map wird ausschließlich im linken Spielfeldbereich zentriert.
  mapOffsetX = (availableWidth - mapPixelWidth) * 0.5f;
  mapOffsetY = (availableHeight - mapPixelHeight) * 0.5f;
}

void windowResized() {
  updateLayout();

  // Ein Resize verändert weder Grid-Position noch Bewegungsfortschritt.
  // Jede Klasse berechnet lediglich ihre neuen Pixelkoordinaten.
  for (WorldObject object : world_objects) {
    object.updateLayoutPosition();
  }
}

// ============================================================
// Hauptschleife
// ============================================================

void draw() {
  background(0);

  updateTimers();

  if (game_over) {
    screen.GAME_OVER();
    hud.display();
    return;
  }

  if (victory) {
    screen.VICTORY();
    hud.display();
    return;
  }

  updateGame();
  renderGame();

  hud.updateAnimations();
  hud.display();

  updateGameState();
}

void updateGame() {
  updateTeleporters();
  newFruit();

  // Erst bewegen, danach rendern. Dadurch können Collectables entfernt
  // werden, ohne dass während eines Enhanced-for-Loops die Liste verändert wird.
  if (player != null) {
    player.move();
  }

  for (Enemy enemy : enemies) {
    enemy.move();
  }

  updatePowerMode();
}

void updateTeleporters() {
  for (WorldObject object : world_objects) {
    if (object instanceof Teleporter) {
      ((Teleporter) object).TPupdate();
    }
  }
}

void renderGame() {
  for (WorldObject object : world_objects) {
    object.display();
  }
}

void updateTimers() {
  for (int i = timer.size() - 1; i >= 0; i--) {
    Timer current = timer.get(i);
    current.update();

    if (current.isFinished()) {
      // Teleporter-Timer werden von Teleporter.TPupdate() ausgewertet.
      // Andere Timer können hier künftig ebenfalls verwaltet werden.
    }
  }
}

void updatePowerMode() {
  if (!powerMode) {
    return;
  }

  powerTimer--;

  if (powerTimer > 0) {
    return;
  }

  powerMode = false;
  ghost_score = 200;

  for (Enemy enemy : enemies) {
    enemy.endFrightened();
  }
}

void updateGameState() {
  if (lifes <= 0) {
    game_over = true;
  } else if (total_dot_count > 0 && dot_count >= total_dot_count) {
    victory = true;
  }
}

// ============================================================
// Input
// ============================================================

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

// ============================================================
// Spielregeln / Utility
// ============================================================

void newFruit() {
  if (fruit_pos_x < 0 || fruit_pos_y < 0) {
    return;
  }

  if (dot_count >= FRUIT_SPAWN_DOT_COUNT && !fruit_spawned) {
    world_objects.add(new Fruits(fruit_pos_x, fruit_pos_y));
    fruit_spawned = true;
  }
}

void checkBonusLife() {
  while (score >= (bonus_lebenS + 1) * BONUS_LIFE_SCORE) {
    bonus_lebenS++;
    hud.addLife();
  }
}

void startPowerMode() {
  powerMode = true;
  powerTimer = POWER_MODE_DURATION_FRAMES;
  ghost_score = 200;

  for (Enemy enemy : enemies) {
    enemy.startFrightened();
  }
}

void removeWorldObject(WorldObject object) {
  world_objects.remove(object);
}

boolean isGameOver() {
  return lifes <= 0;
}
