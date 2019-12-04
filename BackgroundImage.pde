class BackgroundImage implements IGraphic, ICanParallax{
  Map<Camera, Integer> cameras = new HashMap();//Camera, Layer
  PVector position = PVector.zero();
  PVector drawPos = PVector.zero();
  PVector size;
  PImage texture;
  boolean fillWidth = false;
  boolean fillHeight = false;
  private boolean isCulled;
  PVector parallaxCoeff = PVector.zero();
  boolean canXParallax = false;
  boolean canYParallax = false;
     
  BackgroundImage(PVector _position, String texturePath, PVector _size, int _layer, Camera camera, boolean _fillWidth, boolean _fillHeight){
    texture = loadImage(texturePath);
    size = _size;
    position = _position;
    fillWidth = _fillWidth;
    fillHeight = _fillHeight;
    attachCamera(camera, _layer);
    addToGraphicsList(camera, _layer);
    camera.addToParallaxObjects(this);
    texture.resize((int)size.x, (int)size.y);
  }
  
  public void display(Camera camera){
    PVector startPos = PVector.add(PVector.sub(position, drawPos), camera.getFocusOffset());
    image(texture, startPos.x, startPos.y); 
    
  }
  
  public void setParallax(PVector coeff){
   parallaxCoeff = coeff;
  }
   
  public void setCanXParallax(boolean canParallax){
    canXParallax = canParallax;
  }
  
  public void setCanYParallax(boolean canParallax){
    canYParallax = canParallax;
  }
   
   public void attachCamera(Camera camera, int layer) {
    //if (cameras.get(camera) != null)
    cameras.put(camera, layer);
  }

  public void addToGraphicsList(Camera camera, int layer) {
    attachCamera(camera, layer);
    setLayer(camera, layer);
    camera.addToGraphicsList(this, layer);
  }

  public void removeFromGraphicsList(Camera camera, int layer) {
    camera.removeFromGraphicsList(this, cameras.get(camera));
  }

  public void setLayer(Camera camera, int _layer) {
    camera.removeFromGraphicsList(this, cameras.get(camera));
    Integer layer = cameras.get(camera);
    layer = _layer;
    camera.addToGraphicsList(this, cameras.get(camera));
  }

  public boolean isCulled() {
    return isCulled;
  }
  
  public void checkCulling(Camera camera){

   }
  
  public void setDrawPosition(Camera camera){

    PVector camPos = camera.getPosition();
    
    float x = camPos.x;
    float y = camPos.y;
    
    boolean hasFocusPoint = camera.getFocusPoint() != null;
    //System.out.println(hasFocusPoint);
    if (hasFocusPoint){
      PVector focusPosition = camera.getPosition();
      PVector focusOffset = camera.getFocusOffset();
  
      if (canXParallax)
        x = camPos.x + (focusPosition.x - focusOffset.x) * parallaxCoeff.x;
  
      
      if (canYParallax)
        y = camPos.y + (focusPosition.y - focusOffset.y) * parallaxCoeff.y;
      }
    //System.out.println(camera.getPosition() + " " + new PVector(x, y));
    
      drawPos = new PVector(x, y);
  }
}
