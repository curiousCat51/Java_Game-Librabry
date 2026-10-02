class MapLoader{
  int map_height;
  
  int id = 1;
  
  MapLoader(ArrayList<WorldObject> world_objects){
   String[] lines = loadStrings("data/map/map1.txt");  
   
   map_height = lines.length;
   
   for(int i = 0; i < lines.length; i++){
     char[] characters = lines[i].toCharArray();
     
     for(int j = 0; j < characters.length; j++){
       char character = characters[j];
       
       switch(character){
         case 'x': out_of_map.add(new GridPosition(i, j)); break; // Position außerhalb der Karte
         
         case 'T': world_objects.add(new Teleporter(j, i, id)); free_tiles.add(new GridPosition(j, i)); id++; break;
         case 'o': world_objects.add(new Dot(j, i, 1)); free_tiles.add(new GridPosition(j,i)); break; // Punkt Groß
         case '.': world_objects.add(new Dot(j, i, 2)); free_tiles.add(new GridPosition(j,i)); break; // Punkt Klein
         
         case 'c': world_objects.add(new Enemy(j, i, ENEMY_SPEED, 1)); free_tiles.add(new GridPosition(j,i)); break; // Geist Cyan
         case 'g': world_objects.add(new Enemy(j, i, ENEMY_SPEED, 2)); free_tiles.add(new GridPosition(j,i)); break; // Geist Orange
         case 'p': world_objects.add(new Enemy(j, i, ENEMY_SPEED, 3)); free_tiles.add(new GridPosition(j,i)); break; // Geist Pink
         case 'r': world_objects.add(new Enemy(j, i, ENEMY_SPEED, 4)); free_tiles.add(new GridPosition(j,i)); break; // Geist Red
         
         case 'P': world_objects.add(new Player(j, i, PLAYER_SPEED)); free_tiles.add(new GridPosition(j,i)); break; // Spieler
         
         case '_': world_objects.add(new Wall(j, i, 6, 0)); break; // Wand Tür
         
         case '-': world_objects.add(new Wall(j, i, 5, 1)); break; // Wand Grade 1
         case '|': world_objects.add(new Wall(j, i, 5, 2)); break; // Wand Grade 2
         
         case '>': world_objects.add(new Wall(j, i, 4, 1)); break; // Wand Ende 1
         case 'v': world_objects.add(new Wall(j, i, 4, 2)); break; // Wand Ende 2
         case '<': world_objects.add(new Wall(j, i, 4, 3)); break; // Wand Ende 3
         case '^': world_objects.add(new Wall(j, i, 4, 4)); break; // Wand Ende 4
         
         case '1': world_objects.add(new Wall(j, i, 1, 1)); break; // Wand Connection 1
         case '2': world_objects.add(new Wall(j, i, 1, 2)); break; // Wand Connection 2
         case '3': world_objects.add(new Wall(j, i, 1, 3)); break; // Wand Connection 3
         case '4': world_objects.add(new Wall(j, i, 1, 4)); break; // Wand Connection 4
         
         case '5': world_objects.add(new Wall(j, i, 2, 1)); break; // Wand Ecke 1
         case '6': world_objects.add(new Wall(j, i, 2, 2)); break; // Wand Ecke 2
         case '7': world_objects.add(new Wall(j, i, 2, 3)); break; // Wand Ecke 3
         case '8': world_objects.add(new Wall(j, i, 2, 4)); break; // Wand Ecke 4
         
         default:{
           if((j == 10 && (i > 4 || i < 23)) || (j == 11 && (i > 4 || i < 23)) || (j == 15 && (i > 4 || i < 23)) || (j == 16 && (i > 4 || i < 23))){
             free_tiles.add(new GridPosition(j,i)); // Freies Tile
           }
         }
       }
     }
   }
  }
  
  int getMapHeight(){
    return map_height;
  }
}
