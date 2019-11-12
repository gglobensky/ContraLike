final int fixedTimeStep = (int)Math.floor(1000f / 60);//1000 milli divided by 60 for the number of desired iteration of the loop fixedUpdate. E.G at 1000 / 60 it'll calculate about 60 times per second.
long frameCounter = 0;

SquareCollider c;
GameObject ball;
Transform tr;
Camera camera;

TileMap t;

int testCount = 0;
void setup () {
  frameRate(1000);
  size (800, 600, P2D);
  //smooth();
   //<>//
  camera = new Camera(width, height);
  MapData mapData = new MapData("Level 1");
  GameObject water = new GameObject();
  
  water.transform.setPosition(new PVector(0, 2256));
  water.transform.size = new PVector(720, 144);
  SquareCollider s = new SquareCollider(water, false);
  
  PVector levelLowerLimit = new PVector(width / 2, 0);
  PVector levelUpperLimit = new PVector(4800, 2400 - height / 2);
  
  water.name = "water";
  new FluidBody(water, 1.5f, 0.1f);
  ball = new GameObject();
  ball.transform.setPosition(new PVector(50, 2100));
  ball.transform.size = new PVector(48, 48);
  c = new SquareCollider(ball, true);
  PhysicsBody pb = new PhysicsBody(ball);
  pb.velocity = new PVector(10, -12);
  new PlayerScript(ball);
  c.toggleColliderDisplay(camera, 1, true);
  c.xSize = 36;
  c.relativePosition = new PVector(6, 0);
  AnimatedSprite a = new AnimatedSprite(ball, 6, camera, "PlayerRunningAnimation.png", "Running", 8, 1, 0, 0, 50, 50, 0.5f);
  //a.relativePos = new PVector(-5, 0);
  //a.setScale(new PVector(1.33f, 1));
  a.addAnimation("PlayerIdleSprite.png", "Idle", 1, 1, 0, 0, 50, 50, 1);
  a.addAnimation("PlayerJumpingSprite.png", "Jumping", 1, 1, 0, 0, 50, 50, 1);
  a.addAnimation("PlayerCrawlingAnimation.png", "Crawling", 3, 1, 0, 0, 70, 50, 1);
  //new Sprite(ball, 8, "H:\\Divers\\Telechargements\\objects.PNG", camera);
  tr = ball.transform;
  BackgroundImage mountains = new BackgroundImage(new PVector(0, levelUpperLimit.y - 64), "assets\\Maps\\backgrounds\\mountain.png", new PVector(1838, 512), 0, camera, false, false);
  mountains.setParallax(new PVector(-0.5, 0.1));
  mountains.setCanXParallax(true);
  mountains.setCanYParallax(true);
  
  BackgroundImage clouds = new BackgroundImage(new PVector(0, levelUpperLimit.y - 768), "assets\\Maps\\backgrounds\\whiteclouds.png", new PVector(919, 300), 0, camera, false, false);
  clouds.setParallax(new PVector(-1, 0.1));
  clouds.setCanXParallax(true);
  clouds.setCanYParallax(true);
  
  /*GameObject ball2 = new GameObject();
  ball2.transform.setPosition(new PVector(50, 2200));
  ball2.transform.size = new PVector(50, 50);
  CircleCollider c2 = new CircleCollider(ball2, 12, true);
  new PhysicsBody(ball2);
  c2.toggleColliderDisplay(camera, 1, true);*/

  TileMap tileMap = mapData.loadTileMap(1, 1, 24, 24, camera);
  mapData.loadTileMap(0, 0, 24, 24, camera);
  mapData.loadColliderMap(tileMap);

  
  /*tileMap.setParallax(new PVector(-0.2, 0));
  tileMap.setCanXParallax(true);*/
  //s.toggleColliderDisplay(camera, 0, true);
  //camera.followFocusPoint = false;
  PVector camPos = PVector.sub(ball.transform.position(), new PVector(width / 2, height / 2));
  camera.setPosition(camPos.x, camPos.y);
  camera.setFocus(ball.transform, new PVector(width / 2, height / 2));
  camera.setCameraLimits(levelLowerLimit, levelUpperLimit);
  
  GameEngine.initScripts();
}

void draw () {
  background (color(75, 175, 255));
  Time.update();
  frameCounter = frameCounter + Time.delta;
  
  //println(raycast.direction);
  /*if (raycast.raycastHit())
    println(testCount++);*/
  
  boolean doFixedUpdate = frameCounter >= fixedTimeStep;
  
  if (doFixedUpdate){   
    GameEngine.updatePhysics();
    GameEngine.updateCollisions();
    GameEngine.resolveCollisions();
    
    frameCounter = 0;
  }
  
  GameEngine.updateScripts(doFixedUpdate);
  
  if (doFixedUpdate)
    InputManager.resetInputManagerValues();
    
  camera.manageView();

}


void keyPressed(){
  InputManager.checkInputs(key, keyCode);
}
void keyReleased(){
  InputManager.checkReleases(key, keyCode); 
}
