class Timer{
  
  String name;
  int end;
  char direct;
  int current;
  
  Timer(String name, int start, int end, char count_direct){
    this.name = name;
    current = start;
    this.end = end;
    direct = count_direct;
  }
  
  void update(){
    if(direct == 'i'){
      current++;
    }
    else{
      current--;
    }
  }
  
  boolean isfinish(){
    if(current == end){
      return true;
    }
    return false;
  }
  
  String getName(){return name;}
}
