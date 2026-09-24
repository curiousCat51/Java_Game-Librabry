class Wall extends WorldObject{
 NormalImage image;
 
 String iP = "data/images/Walls/wall_";
 int wall_type;
 
 Wall(float grid_x, float grid_y, int wall_type, int version){
   super(WorldTypes.WALL, grid_x, grid_y);
   
   if(wall_type == 1){
     iP = iP + "connection";
   }
   else if(wall_type == 2){
     iP = iP + "corner";
   }
   else if(wall_type == 3){
     iP = iP + "cross";
   }
   else if(wall_type == 4){
     iP = iP + "end";
   }
   else if(wall_type == 5){
     iP = iP + "straight";
   }
   else{
     iP = iP + "door";
   }
   
   if(version != 0){
     iP = iP + "_" + version; 
   }
   
   image = new NormalImage(iP);
   setImageContainer(image);
   this.wall_type = wall_type;
 }
 
 int getWallType(){return this.wall_type;}
}
