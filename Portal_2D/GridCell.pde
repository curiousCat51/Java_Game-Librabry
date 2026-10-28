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
}
