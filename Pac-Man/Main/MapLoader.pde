class MapLoader{
  
  MapLoader(ArrayList<WorldObject> world_objects){
   String[] lines = loadStrings("data/map/map2.txt");  
   
   
   for(int i = 0; i < lines.length; i++){
     char[] characters = lines[i].toCharArray();
     
     for(int j = 0; j < characters.length; j++){
       char character = characters[j];
       
       if(character == 'P'){
         world_objects.add(new Player(j, i, PLAYER_SPEED));
       }
       else if(character == '-'){
         // Wand Grade 1
         world_objects.add(new Wall(j, i, 5, 1));
       }
       else if(character == '.'){
         // kleiner Punkt
         world_objects.add(new Dot(j, i, 2));
       }
       else if(character == 'o'){
         // großer Punkt
         world_objects.add(new Dot(j, i, 1));
       }
       else if(character == '|'){
         // Wand Grade 2
         world_objects.add(new Wall(j, i, 5, 2));
       }
       else if(character == 'c'){
         world_objects.add(new Enemy(j, i, ENEMY_SPEED, 1));
         // Ghost Cyan
       }
       else if(character == 'p'){
         world_objects.add(new Enemy(j, i, ENEMY_SPEED, 3));
         // Ghost Pink
       }
       else if(character == 'r'){
         world_objects.add(new Enemy(j, i, ENEMY_SPEED, 4));
         // Ghost Red
       }
       else if(character == 'g'){
         world_objects.add(new Enemy(j, i, ENEMY_SPEED, 2));
         // Ghost Orange
       }
       else if(character == '>'){
         world_objects.add(new Wall(j, i, 4, 1));
         // Wand Ende 1
       }
       else if(character == 'v'){
         world_objects.add(new Wall(j, i, 4, 2));
         // Wand Ende 2
       }
       else if(character == '<'){
         world_objects.add(new Wall(j, i, 4, 3));
         // Wand Ende 3
       }
       else if(character == '^'){
         world_objects.add(new Wall(j, i, 4, 4));
         // Wand Ende 4
       }
       else if(character == '3'){
         world_objects.add(new Wall(j, i, 1, 3));
         // Wand Connection 3
       }
       else if(character == '5'){
         world_objects.add(new Wall(j, i, 2, 1));
         // Wand Ecke 1
       }
       else if(character == '6'){
         world_objects.add(new Wall(j, i, 2, 2));
         // Wand Ecke 2
       }
       else if(character == '7'){
         world_objects.add(new Wall(j, i, 2, 3));
         // Wand Ecke 3
       }
       else if(character == '8'){
         world_objects.add(new Wall(j, i, 2, 4));
         // Wand Ecke 4
       }
       else if(character == 8212){
         world_objects.add(new Wall(j, i, 6, 0));
         // Wand Tür 
       }
       else if(character == '1'){
         world_objects.add(new Wall(j, i, 1, 1));
         // Wand Connection 1
       }
       else if(character == '2'){
         world_objects.add(new Wall(j, i, 1, 2));
         // Wand Connection 2
       }
       else if(character == '4'){
         world_objects.add(new Wall(j, i, 1, 4));
         // Wand Connection 4
       }
     }
   }
  }
}
