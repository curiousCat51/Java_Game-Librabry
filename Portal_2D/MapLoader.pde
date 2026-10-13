class MapLoader {
  int teleporterId = 1;
  char tpC;

  ArrayList<WorldObject> targetObjects;

  MapLoader(ArrayList<WorldObject> worldObjects) {
    targetObjects = worldObjects;
  }

  void loadMap(String mapPath) {
    String[] lines = loadStrings(mapPath);

    if (lines == null || lines.length == 0) {
      throw new RuntimeException("Map konnte nicht geladen werden: " + mapPath);
    }

    map_height = lines.length;
    map_width = lines[0].length();

    blocked_tiles = new boolean[map_height][map_width];

    for (int y = 0; y < map_height; y++) {
      parseRow(lines[y], y);
    }
  }


  void parseRow(String line, int y) {
    for (int x = 0; x < line.length(); x++) {
      parseTile(line.charAt(x), x, y);
    }
  }

  void parseTile(char character, int x, int y) {
    switch (character) {
      case 'x':
        out_of_map.add(new GridPosition(x, y));
        blocked_tiles[y][x] = true;
        return;

      case 'T':
        if(teleporterId == 1){
          tpC = 'b';
        }
        else{
          tpC = 'o';
        }
        targetObjects.add(new Teleporter(x, y, tpC));
        free_tiles.add(new GridPosition(x, y));
        return;
        
      case 'P':
        if (player != null) {
          throw new RuntimeException("Map enthält mehr als einen Spieler.");
        }
        player = new Player(x, y);
        targetObjects.add(player);
        free_tiles.add(new GridPosition(x, y));
        return;

      case '_':
        addWall(x, y, 6, 0);
        return;

      case '+':
        addWall(x, y, 3, 0);
        return;

      case '-':
        addWall(x, y, 5, 1);
        return;

      case '|':
        addWall(x, y, 5, 2);
        return;

      case '>':
        addWall(x, y, 4, 1);
        return;

      case 'v':
        addWall(x, y, 4, 2);
        return;

      case '<':
        addWall(x, y, 4, 3);
        return;

      case '^':
        addWall(x, y, 4, 4);
        return;

      case '1':
      case '2':
      case '3':
      case '4':
        addWall(x, y, 1, character - '0');
        return;

      case '5':
      case '6':
      case '7':
      case '8':
        addWall(x, y, 2, character - '4');
        return;

      case ' ':
        // Leerzeichen sind begehbare Map-Fläche.
        free_tiles.add(new GridPosition(x, y));
        return;

      default:
        // Unbekannte Zeichen werden bewusst als Fehler behandelt, damit
        // Tippfehler in Maps nicht unbemerkt die Spiellogik verändern.
        throw new RuntimeException(
          "Unbekanntes Map-Zeichen '" + character + "' bei (" + x + ", " + y + ")."
        );
    }
  }

  void addWall(int x, int y, int wallType, int version) {
    targetObjects.add(new Wall(x, y, wallType, version));
    blocked_tiles[y][x] = wallType != 6;
  }
}
