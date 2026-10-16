class GridCell{
 ArrayList<WorldObject> objects = new ArrayList<WorldObject>();
 
 void addObject(WorldObject object){
  if(object != null && !objects.contains(object)){
   objects.add(object); 
  }
 }
 
 void removeObject(WorldObject object){
  objects.remove(object); 
 }
 
 boolean containsWall(){
  for(WorldObject object : objects){
   if(object.type == WorldTypes.WALL){
    return true; 
   }
  }
  
  return false;
 }
}
