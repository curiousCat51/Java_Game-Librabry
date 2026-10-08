class Timer {
  String name;
  int end;
  char direction;
  int current;

  Timer(String name, int start, int end, char countDirection) {
    this.name = name;
    current = start;
    this.end = end;
    direction = countDirection;
  }

  void update() {
    if (direction == 'i') {
      current++;
    } else {
      current--;
    }
  }

  int getTime() { return current; }

  boolean isFinished() {
    return direction == 'i' ? current >= end : current <= end;
  }

  String timerName() { return name; }
}
