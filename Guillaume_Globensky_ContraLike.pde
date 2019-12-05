final int fixedTimeStep = (int)Math.floor(1000f / 60);//1000 milli divided by 60 for the number of desired iteration of the loop fixedUpdate. E.G at 1000 / 60 it'll calculate about 60 times per second.
long frameCounter = 0;

///This belongs to Graphical
static Map<Shape, PShape> basicShapes = new HashMap();
static Map<String, PShape> complexShapes = new HashMap();

Game game = new Game();
ShapesInitializerInstance si = new ShapesInitializerInstance();

void setup () {
  frameRate(1000);
  size (800, 600, P2D);
  //smooth();
 //<>//
  si.init();
  game.init();
  GameEngine.initScripts();
}

void draw () {
  background (color(75, 175, 255));
  Time.update();
  frameCounter = frameCounter + Time.delta;
  
  boolean doFixedUpdate = frameCounter >= fixedTimeStep;
  
  if (doFixedUpdate){   
    GameEngine.updatePhysics();
    GameEngine.updateCollisions();
    GameEngine.resolveCollisions();
    
    frameCounter = 0;
  }
  
  GameEngine.updateScripts(doFixedUpdate);
  
  game.update();
         
  if (doFixedUpdate){
    game.fixedUpdate();
    InputManager.resetInputManagerValues();
  }
  
  if (GameObject.componentsDirty){
     GameObject.componentsDirty = false;
     GameEngine.doCleanup();
  }
  println(frameRate);
}


void keyPressed(){
  InputManager.checkInputs(key, keyCode);
}
void keyReleased(){
  InputManager.checkReleases(key, keyCode); 
}
