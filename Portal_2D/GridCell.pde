class GridCell{
 ArrayList<WorldObject> objects = new ArrayList<WorldObject>();
 
 // Fügt ein Objekt zu einer Gridzelle hinzu, wenn noch nicht vorhanden
 void addObject(WorldObject object){
  if(object != null && !objects.contains(object)){
   objects.add(object); 
  }
 }
 
 // Entfernt ein Objekt aus einer Gridzelle
 void removeObject(WorldObject object){
  objects.remove(object); 
 }
 
 // Überprüft ob eine bestimmte Gridzelle eine Wand enthält
 boolean containsWall(){
  for(WorldObject object : objects){
   if(object.type == WorldTypes.WALL){
    return true; 
   }
  }
  return false;
 }
 
 // Prüft, ob eine bestimmte Gridzelle eine Tür enthält
 boolean containsDoor(){
  for(WorldObject object : objects){
   if(object.type == WorldTypes.DOOR){
     
     return true;
   }
  }
  return false;
 }
 
 // Überprüft, ob eine Tür in einer bestimmten GridZelle offen ist oder nicht
 boolean isDoorClosed(){
   for(WorldObject object : objects){
     if(object.type == WorldTypes.DOOR){
       Door door = (Door) object;
       
       if(door.open){
         return false;
       }
       return true;
     }
   }
   return false;
 }
 
 // Überprüft, ob in einer bestimmten GridZelle eine Kiste steht
 boolean containsCrate(){
   for(WorldObject object : objects){
    if(object.type == WorldTypes.CRATE){
     return true; 
    }
   }
   return false;
 }
}
