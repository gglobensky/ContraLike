class AnimatedSprite extends Graphical{
 HashMap<String, SpriteAnimation> animations = new HashMap();//Action name, animation
 boolean isPlaying = true;
 boolean flipX = false;
 String currentAction = "";
 PVector scale = new PVector(1, 1);
 PVector orientation = new PVector(1, 1);
 
 AnimatedSprite(GameObject _gameObject, int _layer, Camera _camera, String spriteFileName, String actionName, int sourceXQty, int sourceYQty, int sourceXMargin, int sourceYMargin, int sourceWidth, int sourceHeight, float duration){
   super(_gameObject, AnimatedSprite.class, _layer, _camera);
   currentAction = actionName;
   addAnimation(spriteFileName, actionName, sourceXQty, sourceYQty, sourceXMargin, sourceYMargin, sourceWidth, sourceHeight, duration);
 }
 
 public void setScale(PVector _scale){
  relativeScale = _scale;
 }
 
 public int getCurrentFrame(){
    return animations.get(currentAction).getCurrentFrame();
 }
 
 public void setCurrentFrame(int _currentFrame){
    animations.get(currentAction).setCurrentFrame(_currentFrame);
 }
 
 public void flipX(boolean _flipX){
   if (flipX != _flipX){
     if (flipX){
       orientation.x = -1;
       orientation.y = 1;
     }
     else{
       orientation.x = 1;
       orientation.y = 1;
     }
     flipX = _flipX;
   }
 }
 
 void addAnimation(String spriteFileName, String actionName, int sourceXQty, int sourceYQty, int sourceXMargin, int sourceYMargin, int sourceWidth, int sourceHeight, float duration){
   if (!animations.containsKey(actionName)){
     
     int xPos = 0;
     int yPos = 0;
     List<PImage> textures = new ArrayList();
     PImage sourceImage = loadImage("assets/Spritesheet/" + spriteFileName);
        //CREATE A REFERENCE FOR EACH TILE OF THE SHEET
      for (int y = 0; y < sourceYQty; y++){
        for (int i = 0; i < sourceXQty; i++){
          textures.add(sourceImage.get(xPos + sourceXMargin, yPos + sourceYMargin, sourceWidth - 2 * sourceXMargin, sourceHeight - 2 * sourceYMargin));
          xPos += sourceWidth;
        }
        yPos += sourceHeight;
        xPos = 0;
      }
    
    
      animations.put(actionName, new SpriteAnimation(textures, sourceXQty * sourceYQty, duration, this));
    }
    else{
     println("An action with that name is already bound to an animation!"); 
    }
    
   }
   
   void display(Camera camera){
     if (animations.containsKey(currentAction))
       animations.get(currentAction).display(camera);
   }
}

class SpriteAnimation{
  List<PImage> frames;
  int frameCounter = 0;
  float maxFrameCount = 0;
  AnimatedSprite sprite;
  
  int currentFrame = 0;
  int totalFrames;
  float duration;
  float frameDuration;
  
  boolean isFlipped = false;
  
  SpriteAnimation(List<PImage> _frames, int _totalFrames, float _duration, AnimatedSprite _sprite){
    sprite = _sprite;
    frames = _frames;
    totalFrames = _totalFrames;
    duration = _duration;
    
    if (duration < 0){
      println("Duration has to be superior than 0, duration set to 1sec");
      duration = 1;
    }
    
    maxFrameCount = duration * 1000;
    frameDuration = maxFrameCount / totalFrames;
    PVector initialSize = sprite.gameObject.transform.size.get();
    initialSize.x *= sprite.relativeScale.x;
    initialSize.y *= sprite.relativeScale.y;
    
    if (frames != null){
     int len = frames.size();
     for (int i = 0; i < len; i++){
      frames.get(i).resize((int)initialSize.x, (int)initialSize.y);
     }
    }
    
  }

  public int getCurrentFrame(){
    return currentFrame; 
  }
  
  public void setCurrentFrame(int _currentFrame){
    currentFrame = _currentFrame;
  }
  
  void display(Camera camera){
    if (sprite.isPlaying)
      currentFrame = (int)(Time.getElapsedTime() / frameDuration) % totalFrames;
      
    pushMatrix();
    imageMode(CENTER);
    scale(sprite.orientation.x, sprite.orientation.y);
    
    float xPos = sprite.orientation.x * (sprite.gameObject.transform.getPosition().x - camera.getPosition().x + sprite.relativePos.x);
    float yOffset = sprite.gameObject.transform.size.y / 2 * sprite.orientation.y + sprite.relativePos.y;
    xPos += sprite.gameObject.transform.size.x / 2 * sprite.orientation.x;

    image(frames.get(currentFrame), xPos, sprite.gameObject.transform.getPosition().y - camera.getPosition().y + yOffset, sprite.gameObject.transform.size.x * sprite.relativeScale.x, sprite.gameObject.transform.size.y * sprite.relativeScale.y);
    popMatrix();
    imageMode(CORNER);
    if (frameCounter > maxFrameCount)
      frameCounter = 0;
  }
}
