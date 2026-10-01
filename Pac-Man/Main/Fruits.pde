class Fruits extends WorldObject{
 NormalImage image;
 
 String iP = "data/images/Items/";
 int fruit_type;
 
 boolean collectable = false;
 
 // x = 13
 // y = 15
 
 Fruits(int grid_x, int grid_y){
  super(WorldTypes.FRUIT, grid_x, grid_y);
  
  this.fruit_type = generateFruit();
  
  switch(fruit_type){
    case 1: iP = iP + "cherry"; break;
    case 2: iP = iP + "strawberry"; break;
    case 3: iP = iP + "orange"; break;
    case 4: iP = iP + "apple"; break;
    case 5: iP = iP + "melon"; break;
    case 6: iP = iP + "galaxian"; break;
    case 7: iP = iP + "bell"; break;
    case 8: iP = iP + "key"; break;
  }
  
  image = new NormalImage(iP);
  setImageContainer(image);
 }
 
 void collect(int x, int y){
   
   for(int i = world_objects.size() - 1; i >= 0; i--){

        WorldObject object = world_objects.get(i);

        if(object instanceof Fruits){

            Fruits fruit = (Fruits)object;

            if(x == fruit.getGridX() && y == fruit.getGridY()){

                switch(fruit_type){
                  case 1: score += 100; break; // Kirsche
                  case 2: score += 300; break; // Erdbeere
                  case 3: score += 500; break; // Orange
                  case 4: score += 700; break; // Apfel
                  case 5: score += 1000; break; // Melone
                  case 6: score += 2000; break; // Galaxian
                  case 7: score += 3000; break; // Glocke
                  case 8: score += 5000; break; // Schlüssel
                }
                world_objects.remove(i);
                dot_count -= 70;
                fruit_spawned = false;
            }
        }
    }
 }
 
 int generateFruit(){
   return (int) random(1, 9);
 }
 
 boolean isCollectable(){return this.collectable;}
 
 // Nur anzeigen, wenn genug Punkte gesammelt wurden
 void display(){   
   drawObject();
 }
}
