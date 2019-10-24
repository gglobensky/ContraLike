class AnimatedSprite extends Graphical{
 HashMap<String, SpriteAnimation> animations = new HashMap();//Action name, animation
 boolean isPlaying = true;
 String currentAction = "";

 AnimatedSprite(GameObject _gameObject, int _layer, Camera _camera, String spriteFileName, String actionName, int sourceXQty, int sourceYQty, int sourceXMargin, int sourceYMargin, int sourceWidth, int sourceHeight, float duration){
   super(_gameObject, AnimatedSprite.class, _layer, _camera);
   currentAction = actionName;
   addAnimation(spriteFileName, actionName, sourceXQty, sourceYQty, sourceXMargin, sourceYMargin, sourceWidth, sourceHeight, duration);
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
  
  void display(Camera camera){
    currentFrame = (int)(Time.getElapsedTime() / frameDuration) % totalFrames;
    //println((int)(Time.getElapsedTime() / frameDuration) % totalFrames);
    image(frames.get(currentFrame), sprite.gameObject.transform.position().x - camera.getPosition().x, sprite.gameObject.transform.position().y - camera.getPosition().y);
    if (frameCounter > maxFrameCount)
      frameCounter = 0;
  }
}
