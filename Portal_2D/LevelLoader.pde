class LevelLoader{
 
  
  World loadLevel(String filename, KeyHandler eventListener) {
  
    String[] lines = loadStrings(filename);
  
    if (lines == null || lines.length == 0) {
      println("Fehler: Level-Datei konnte nicht geladen werden.");
      return null;
    }
  
    int rows = -1;
    int cols = -1;
    int objectStartIndex = -1;
  
    // 1. Levelinformationen auslesen
    for (int i = 0; i < lines.length; i++) {
  
      String line = trim(lines[i]);
  
      if (line.length() == 0) {
        continue;
      }
  
      String[] values = split(line, ',');
  
      String Key = trim(values[0]);
  
      // Beginn des Objektabschnitts erkennen
      if (Key.equals("object_type")) {
      
        if (values.length != 8) {
          println("Fehler: Ungültige Objekt-Kopfzeile.");
          return null;
        }
      
        objectStartIndex = i;
        break;
      }
  
      String Value = trim(values[1]);
  
      try {
        if (Key.equals("rows")) {
          rows = Integer.parseInt(Value);
        }
        else if (Key.equals("cols")) {
          cols = Integer.parseInt(Value);
        }
      }
      catch (NumberFormatException e) {
        println("Fehler: Ungültiger Zahlenwert in Zeile " + (i + 1));
        return null;
      }
    }
  
    // 2. Levelgröße überprüfen
    if (rows <= 0 || cols <= 0) {
      println("Fehler: Levelgröße fehlt oder ist ungültig.");
      return null;
    }
  
    if (objectStartIndex == -1) {
      println("Fehler: Objekt-Kopfzeile fehlt.");
      return null;
    }
  
    // 3. Welt erstellen
    World newWorld = new World(cols, rows);
    
    int playerCount = 0;
  
    // 4. Objektzeilen auslesen und validieren
    for (int i = objectStartIndex + 1; i < lines.length; i++) {
  
      String line = trim(lines[i]);
  
      if (line.length() == 0) {
        continue;
      }
  
      String[] values = split(line, ',');
  
      if (values.length != 8) {
        println("Fehler: Ungültige Anzahl an Feldern in Zeile " + (i + 1));
        return null;
      }
  
      String objectType = trim(values[0]).toUpperCase();
      
      // Prüft, ob der objectType bekannt ist oder nicht
      if (!objectType.equals("PLAYER") && !objectType.equals("WALL") && !objectType.equals("ENEMY") && !objectType.equals("DOOR") && !objectType.equals("BUTTON")) {

        println("Fehler: Unbekannter Objekttyp: " + objectType);
        return null;
      }

      String subType = trim(values[1]);
  
      String gridXValue = trim(values[2]);
      String gridYValue = trim(values[3]);
  
      String moveDirection = trim(values[4]);
      String shootDirection = trim(values[5]);
      String orientation = trim(values[6]);
      String linkId = trim(values[7]);
  
      // Pflichtfelder überprüfen
      if (isNullValue(objectType) || isNullValue(gridXValue) || isNullValue(gridYValue)) {
  
        println("Fehler: Pflichtfeld fehlt in Zeile " + (i + 1));
        return null;
      }
  
      // Koordinaten überprüfen
      int gridX;
      int gridY;
  
      try {
        gridX = Integer.parseInt(gridXValue);
        gridY = Integer.parseInt(gridYValue);
      }
      catch (NumberFormatException e) {
        println("Fehler: Ungültige Koordinaten in Zeile " + (i + 1));
        return null;
      }
  
      // Koordinaten innerhalb der Welt überprüfen
      if (gridX < 0 || gridX >= cols || gridY < 0 || gridY >= rows) {
  
        println("Fehler: Objekt außerhalb der Welt in Zeile " + (i + 1));
        return null;
      }
      
      if (objectType.equals("WALL")) {
      
        Wall wall = createWall(gridX, gridY, subType, orientation);
      
        if (wall == null) {
          return null;
        }
      
        newWorld.registerObject(wall, gridX, gridY);
      }
      
      if (objectType.equals("PLAYER")) {
        playerCount++;
      
        if (playerCount > 1) {
          println("Fehler: Das Level darf nur einen Player enthalten.");
          return null;
        }
      
        Player newPlayer = createPlayer(gridX, gridY, eventListener);
        newWorld.registerObject(newPlayer, gridX, gridY);
      }
      
      if (objectType.equals("ENEMY")) {
        Enemy enemy = createEnemy(gridX, gridY, subType, moveDirection, shootDirection);
      
        if (enemy == null) return null;
      
        newWorld.registerObject(enemy, gridX, gridY);
      }
      
      if (objectType.equals("DOOR")) {
      
        if (isNullValue(linkId)) {
          println("Fehler: Tür benötigt eine gültige link_id in Zeile " + (i + 1));
          return null;
        }
      
        int doorLinkId;
      
        try {
          doorLinkId = Integer.parseInt(linkId);
        }
        catch (NumberFormatException e) {
          println("Fehler: Ungültige link_id für Tür in Zeile " + (i + 1));
          return null;
        }
      
        Door door = new Door(gridX, gridY, doorLinkId);
        newWorld.registerObject(door, gridX, gridY);
      }
      
      if (objectType.equals("BUTTON")) {
      
        if (isNullValue(linkId)) {
          println("Fehler: Button benötigt eine gültige link_id in Zeile " + (i + 1));
          return null;
        }
      
        int buttonLinkId;
      
        try {
          buttonLinkId = Integer.parseInt(linkId);
        }
        catch (NumberFormatException e) {
          println("Fehler: Ungültige link_id für Button in Zeile " + (i + 1));
          return null;
        }
      
        Button button = new Button(gridX, gridY, buttonLinkId);
        newWorld.registerObject(button, gridX, gridY);
      }
      
      // Optionale Enum-Werte überprüfen
      if (!isValidDirection(moveDirection) || !isValidDirection(shootDirection) || !isValidOrientation(orientation)) {
  
        println("Fehler: Ungültiger Richtungs- oder Ausrichtungswert in Zeile " + (i + 1));
        return null;
      }
  
      println("Objekt: " + objectType + " | Untertyp: " + subType + " | X: " + gridX + " | Y: " + gridY + " | Bewegung: " + moveDirection + " | Schuss: " + shootDirection + " | Ausrichtung: " + orientation);
    }
  
    println("Levelgröße eingelesen: " + rows + " Zeilen, " + cols + " Spalten.");
    
    if (playerCount != 1) {
      println("Fehler: Das Level muss genau einen Player enthalten.");
      return null;
    }
    
    if (!newWorld.linkDoorsAndButtons()) {
      return null;
    }
  
    return newWorld;
  }
  
  // Prüft, ob ein Wert die aus der CSV Datei NULL ausschreibt
  boolean isNullValue(String value){
   
    return value == null || trim(value).equalsIgnoreCase("NULL");
  }
  
  // Prüft, ob eine Richtung vorhenden ist im Richtungs Enum
  boolean isValidDirection(String value){
   
    if(isNullValue(value)){
     
      return true;
    }
    
    try{
     
      Direction.valueOf(trim(value).toUpperCase());
      return true;
    }
    catch(IllegalArgumentException e){
      return false;
    }
  }
  
  // Prüft, ob eine Orientierung vorhanden ist im Orientierungs Enum
  boolean isValidOrientation(String value){
   
    if(isNullValue(value)){
     
      return true;
    }
    
    try{
     
      Orientation.valueOf(trim(value).toUpperCase());
      return true;
    }
    catch(IllegalArgumentException e){
     return false; 
    }
  }
  
  // Liefert den eingelesenen WallType als verwertbaren Wert zurück
  WallType parseWallType(String value){
   
    if(isNullValue(value)){
     
      return null;
    }
    try{
     
      return WallType.valueOf(trim(value).toUpperCase());
    }
    catch(IllegalArgumentException e){
     
      return null;
    }
  }
  
  // Liefert die eingelesenen Orienation als verwertbaren Wert zurück
  Orientation parseOrientation(String value){

    if (isNullValue(value)) {
      return null;
    }
  
    try {
      return Orientation.valueOf(trim(value).toUpperCase());
    }
    catch (IllegalArgumentException e) {
      return null;
    }
  }
  
  Wall createWall(int gridX, int gridY, String subType, String orientationValue) {
  
    WallType wallType = parseWallType(subType);
    Orientation orientation = parseOrientation(orientationValue);
  
    if (wallType == null || orientation == null) {
      println("Fehler: Ungültige Wand-Eigenschaften.");
      return null;
    }
  
    return new Wall(gridX, gridY, wallType, orientation);
  }
  
  Player createPlayer(int gridX, int gridY, KeyHandler eventListener){
   
    return new Player(gridX, gridY, eventListener);
  }
  
  EnemyType parseEnemyType(String value) {
    if (isNullValue(value)) return null;
  
    try {
      return EnemyType.valueOf(trim(value).toUpperCase());
    }
    catch (IllegalArgumentException e) {
      return null;
    }
  }
  
  // Wandelt die Richtung in verwertbare Werte um
  int[] parseDirection(String value) {
    if (isNullValue(value)) return new int[] {0, 0};
  
    Direction direction;
  
    try {
      direction = Direction.valueOf(trim(value).toUpperCase());
    }
    catch (IllegalArgumentException e) {
      return null;
    }
  
    switch (direction) {
      case OBEN:    return new int[] {0, -1};
      case UNTEN:   return new int[] {0, 1};
      case LINKS:   return new int[] {-1, 0};
      case RECHTS:  return new int[] {1, 0};
    }
  
    return null;
  }
  
  Enemy createEnemy(int gridX, int gridY, String subType, String moveDirectionValue, String shootDirectionValue) {
    EnemyType enemyType = parseEnemyType(subType);
    int[] moveDirection = parseDirection(moveDirectionValue);
    int[] shootDirection = parseDirection(shootDirectionValue);
  
    if (enemyType == null || moveDirection == null || shootDirection == null) {
      println("Fehler: Ungültige Enemy-Eigenschaften.");
      return null;
    }
  
    Enemy enemy = new Enemy(enemyType, gridX, gridY, shootDirection[0], shootDirection[1]);
  
    if (!isNullValue(moveDirectionValue)) {
      enemy.setMovementDirection(moveDirection[0], moveDirection[1]);
    }
  
    return enemy;
  }
}
