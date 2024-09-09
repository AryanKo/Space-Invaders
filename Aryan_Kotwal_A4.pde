/*********************
 *Aryan Kotwal*
 * ICS 3U1 - Assignment 4 *
 **
 *    Space Invaders       *
 **************************/
 //these are the variables declared at the start of the game
 PImage Aliens;
PImage Plane;
PImage Bullet;
int numberOfRows = 5;
int numberOfCols = 11;
int numberOfAliens = numberOfRows * numberOfCols;
int timeOfLastMovement;
int speedUpBullet;
int alienDirectionX = 1; // 1 = right, -1 = left
int alienDirectionY = 25;
boolean[] alienIsHit = new boolean[numberOfAliens];
boolean alienRight;

boolean clickedStart = false, clickedHTP = false;

int[] alienX = new int[numberOfAliens];
int [] alienY = new int[numberOfAliens];
int movementRate = 1;

int TankX = 500;
boolean tankRight, tankLeft;
boolean bulletIsFiring;
float gameState = 0 ;

int bulletY = 750;
int bulletX = TankX;

int score = 0;
int alienNum = numberOfAliens;
int multiplier = 10;

void setup() {
  textAlign(CENTER, CENTER);
  size(1000, 800);
  imageMode(CENTER);
  Plane = loadImage ("Plane1.png");
  Aliens = loadImage ("invader2.png");
  Bullet = loadImage ("bullet.png");
  //size of plane
  Plane.resize(60, 70);
  Aliens.resize(50, 50);
  Bullet.resize (30, 35);

  rectMode(CENTER);
  makeAlienStartingPositions();
  timeOfLastMovement = millis();
    SetVariables ();
}
//Alien start positions
void makeAlienStartingPositions() {
  for (int i = 0; i < numberOfAliens; i++) {
    alienX[i] = 50+50*(i%numberOfCols);
    alienY[i] = 100 + 50 * (i/numberOfCols);
    alienIsHit[i] = false;
  }
}

void draw() {

  println(gameState);
  background(#000000);
  if (gameState == 0) {
    Menu();
  }
  if (gameState == 0.2) {
    howToPlayText();
  }
  if (gameState == 1) {
    drawScore();
    drawAliens();
    bullet();
    drawTank();
    moveTank ();
    moveAliens();
    for (int i = 0; i < 55; i++) {
      destroyAlien(i);
      checkLose(i);
    }
    checkWin();
  }

  if (gameState == 2) {
    winState();
    drawScore();
    clickReplayButton();
    for (int i = 0; i < numberOfAliens; i++) {
      alienX[i] = 50+50*(i%numberOfCols);
      alienY[i] = 100 + 50 * (i/numberOfCols);
    }
  }
  if (gameState==3) {
    loseState();
    drawScore();
    clickReplayButton();
    for (int i = 0; i < numberOfAliens; i++) {
      alienX[i] = 50+50*(i%numberOfCols);
      alienY[i] = 100 + 50 * (i/numberOfCols);
    }
  }
}

void Menu() {
  textSize(64);
  fill(#FFFFFF);
  text ("Aryan's Space Invaders", width/2, 70);
  fill(#000000);
  stroke(#FFFFFF);
  rect (width/2, 205, 100, 30);
  rect (width/2, 250, 170, 35);
  textSize(32);
  fill(#FFFFFF);
  text("START", 500, 200);
  text ("How To Play", width/2, 245);

  text ("Creator : Aryan Kotwal \n Special Thanks to Mr. Parchimowicz \n", width/2, 600);
  textSize(15);
  text ("All Rights Reserved®  Property of ClassFiveGaming®", width/2, 700);
}

void SetVariables () {
  numberOfRows = 5;
  numberOfCols = 11;
  numberOfAliens = numberOfRows * numberOfCols;
  timeOfLastMovement = 0;
  speedUpBullet = 0;
  alienDirectionX = 1; // 1 = right, -1 = left
  alienDirectionY = 25;
  movementRate = 1;

  TankX = 500;
  bulletY = 750;
  bulletX = TankX;

  score = 0;
  alienNum = numberOfAliens;
  multiplier = 10;

  makeAlienStartingPositions();
  timeOfLastMovement = millis();
  
  moveAliens();
  moveTank ();
  shootBullet();
}


void checkMenuButtons() {
  if (mouseX >400 && mouseX < 600 && mouseY > 190 && mouseY < 220) {
    gameState = 1;
    SetVariables ();
  } else if (mouseX > 230 && mouseX <670  && mouseY > 215 && mouseY < 285) {
    gameState = 0.2;
  }
  /**/
}

void clickHTPButtons() {
  if (mouseX >230 && mouseX < 570 && mouseY > 480 && mouseY < 520) {
    gameState = 0;
  }
}

void howToPlayText() {
  textSize(40);
  text ("Left arrow = Move Plane Left \n Right arrow = Move Plane Right \n Space bar = Shoot Bullet", width/2, 300);
  stroke(#FFFFFF);
  noFill();
  rect (width/2, 500, 150, 30);
  //textSize(32);
  fill(#FFFFFF);
  text("Return", width/2, 495);

  if (mouseX >400 && mouseX < 600 && mouseY > 470 && mouseY < 530 && mousePressed == true) {
    gameState = 0;
  }
}

//draw Player score
void drawScore() {
  textSize(40);
  text(" Points: " + score, 500, 50);
}

//This is the winners command
void winState() {
  textSize(50);
  text("You win!!", width/2, 400);
}

void loseState() {
  textSize(50);
  text("You lose!", width/2, 400);
}

void checkWin() {
  if (alienNum < 1) {
    gameState = 2;
  }
}

void clickReplayButton() {
  stroke(#FFFFFF);
  noFill();
  rect (width/2, 500, 150, 35);
  textSize(32);
  fill(#FFFFFF);
  text("Play Again", width/2, 495);

  if (mouseX >400 && mouseX < 600 && mouseY > 470 && mouseY < 530 && mousePressed == true) {
    gameState = 0;
    //SetVariables ();
  }
}

void checkLose(int i) {
  if (alienY[i] > 780) {
    gameState = 3;
  }
}

//move aliens down after bounce
void moveAliensDown() {
  for (int i = 0; i < numberOfAliens; i++) {
    alienY[i] = alienY[i] + alienDirectionY;
  }
  timeOfLastMovement = millis();
  multiplier += 10;
}

boolean someoneTouchedTheEdge = false;
//bounce aliens off the edges
void checkAliensHitEdge(int thisAlien) {
  if ((alienX[thisAlien] > 930 && !alienIsHit[thisAlien]) || (alienX[thisAlien] < 75 && !alienIsHit[thisAlien])) {
    someoneTouchedTheEdge = true;
  }
}

//draw aliens
void drawAliens() {
  for (int i = 0; i < numberOfAliens; i++) {
    if (!alienIsHit[i]) {
      image(Aliens, alienX[i], alienY[i]);
    }
  }
}

//move the aliens
void moveAliens() {
  movementRate = 400 + (alienNum)*30;
  if (millis() - timeOfLastMovement > movementRate) {
    for (int i = 0; i < numberOfAliens; i++) {
      alienX[i] += alienDirectionX*70;
      checkAliensHitEdge(i);
    }
    if (someoneTouchedTheEdge) {
      moveAliensDown();
      alienDirectionX *= -1;
      someoneTouchedTheEdge = false;
    }
    timeOfLastMovement = millis();
  }
}
//draw the tank
void drawTank () {
  image(Plane, TankX, 750);
  //rect(TankX, 750, 50, 30);
}

//move the tank
void moveTank () {
  int tankRightSide = TankX + 25;
  int tankLeftSide = TankX - 25;
  if (tankRight && tankRightSide < width) {
    TankX = TankX + 10;
  }

  if (tankLeft && tankLeftSide > 0)
    TankX=TankX - 10;
}

//draw the bullet and regulate firing
void bullet () {
  if (bulletIsFiring) {
    //rect(bulletX, bulletY, 10, 15);
    image(Bullet, bulletX, bulletY);
    shootBullet();
  }
}

//move the bullet firing
void shootBullet() {
  bulletY -= 10;
  if (bulletY<0) {
    bulletIsFiring=false;
  }

  if (millis() - speedUpBullet > 5000) {
    for (int i = 0; i < 5; i++) {
      bulletY -= 10 + i;
    }
    speedUpBullet = millis();
  }
}

//this is the destroy alien code
void destroyAlien (int i) {
  int AlienR = alienX[i] + 15;
  int AlienL = alienX[i] - 15;
  int AlienT = alienY[i] -15;
  int AlienD = alienY[i] + 15;
  int bulletR = bulletX + 5;
  int bulletL = bulletX - 5;
  int bulletT = bulletY - 7;
  int bulletB = bulletY + 7;

  if (!alienIsHit[i] && bulletT < AlienD && bulletR > AlienL && bulletL < AlienR && bulletB > AlienT) {
    alienIsHit[i] = true;
    bulletIsFiring= false;
    bulletX = TankX;

    bulletY = 700;
    score += 100 + multiplier;
    alienNum-=1;
  }
}

//what happens when key is pressed
void keyPressed() {
  if (keyCode == 32 && !bulletIsFiring) {
    bulletIsFiring= true;
    bulletX = TankX;
    bulletY = 700;
  }
  if ( keyCode == 39) {
    tankRight=true;
  }
  if ( keyCode == 37) {
    tankLeft=true;
  }
}

//what happens when keys are released
void keyReleased() {

  if (keyCode == 39) {
    tankRight = false;
  }

  if (keyCode == 37) {
    tankLeft = false;
  }
}

//mouse pressed code (what happens when clicked)
void mousePressed() {
  if (gameState == 0) {
    checkMenuButtons();
  } else if (gameState == 0.2) {
    clickHTPButtons();
  } else if (gameState == 2 || gameState == 3) {
    clickReplayButton();
  }
}
