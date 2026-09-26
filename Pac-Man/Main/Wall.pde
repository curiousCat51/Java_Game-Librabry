class Wall extends WorldObject{
 NormalImage image;
 
 String iP = "data/images/Walls/wall_";
 int wall_type;
 boolean pass_through;
 
 Wall(int grid_x, int grid_y, int wall_type, int version){
   super(WorldTypes.WALL, grid_x, grid_y);
   
   if(wall_type == 1){
     iP = iP + "connection";
     pass_through = false;
   }
   else if(wall_type == 2){
     iP = iP + "corner";
     pass_through = false;
   }
   else if(wall_type == 3){
     iP = iP + "cross";
     pass_through = false;
   }
   else if(wall_type == 4){
     iP = iP + "end";
     pass_through = false;
   }
   else if(wall_type == 5){
     iP = iP + "straight";
     pass_through = false;
   }
   else if(wall_type == 6){
     iP = iP + "door";
     pass_through = true;
   }
   
   if(wall_type != 6 && version != 0){
     iP = iP + "_" + version; 
   }
   
   image = new NormalImage(iP);
   setImageContainer(image);
   this.wall_type = wall_type;
 }
 
 int getWallType(){return this.wall_type;}
 boolean isPassThrough(){return this.pass_through;}
}
