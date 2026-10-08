class HUD {
  Life[] life_slots;
  NormalImage[] fruit_images = new NormalImage[8];

  float padding = 25;
  float heartSpacing = 45;

  HUD() {
    life_slots = new Life[MAX_HUD_LIVES];
    for (int i = 0; i < life_slots.length; i++) {
      life_slots[i] = new Life(0, 0);
    }

    String[] fruits = {
      "cherry", "strawberry", "orange", "apple",
      "melon", "galaxian", "bell", "key"
    };

    for (int i = 0; i < fruits.length; i++) {
      fruit_images[i] = new NormalImage("data/images/Items/" + fruits[i]);
    }
  }

  void display() {
    float hudX = width - sidePanelWidth + padding;
    float hudY = max(padding, mapOffsetY + padding);

    fill(255);
    textAlign(LEFT, TOP);

    textSize(24);
    text("SCORE", hudX, hudY);
    textSize(32);
    text(score, hudX, hudY + 35);

    float lifeY = hudY + 110;
    textSize(24);
    text("LEBEN", hudX, lifeY);

    for (int i = 0; i < life_slots.length; i++) {
      Life life = life_slots[i];
      if (life.getState() || life.in_animation) {
        life.displayAt(hudX + 20 + i * heartSpacing, lifeY + 60);
      }
    }

    float powerY = lifeY + 145;
    textSize(24);
    text("POWER", hudX, powerY);
    textSize(20);

    if (powerMode) {
      text("AKTIV", hudX, powerY + 35);
      text(nf(powerTimer / 60.0f, 1, 1) + " s", hudX, powerY + 60);
    } else {
      text("INAKTIV", hudX, powerY + 35);
    }

    float dotY = powerY + 115;
    textSize(24);
    text("DOTS", hudX, dotY);
    textSize(20);
    text(dot_count + " / " + total_dot_count, hudX, dotY + 35);
    text("Grenze: " + FRUIT_SPAWN_DOT_COUNT, hudX, dotY + 65);

    float fruitY = dotY + 115;
    textSize(24);
    text("FRÜCHTE", hudX, fruitY);

    for (int i = 0; i < fruit_images.length; i++) {
      float x = hudX + (i % 2) * 100 + 15;
      float y = fruitY + 45 + (i / 2) * 50;
      fruit_images[i].drawImage(x, y);
      textSize(18);
      text(fruit_counts[i], x + 30, y - 8);
    }
  }

  void loseLife() {
    for (int i = life_slots.length - 1; i >= 0; i--) {
      if (life_slots[i].getState()) {
        life_slots[i].damage();
        return;
      }
    }
  }

  void addLife() {
    lifes++;

    for (int i = 0; i < life_slots.length; i++) {
      if (!life_slots[i].getState()) {
        life_slots[i] = new Life(0, 0);
        return;
      }
    }
  }

  void updateAnimations() {
    for (Life life : life_slots) {
      life.updateAnimation();
    }
  }
}
