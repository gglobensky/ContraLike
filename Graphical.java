import java.util.*;

interface IGraphic{
  void attachCamera(Camera camera, int layer);
  void checkCulling(Camera camera);//Update action from Subject
  boolean isCulled();
  void display(Camera camera);
  void addToGraphicsList(Camera camera, int _layer);//Attach to Subject's list (So no one forgets to do it)
  void removeFromGraphicsList(Camera camera, int _layer);//Remove from Subject's list
  void setLayer(Camera camera, int _layer);
}

interface ICanParallax{
  void setCanXParallax(boolean canParallax);
  void setCanYParallax(boolean canParallax);
  void setDrawPosition(Camera camera);
  void setParallax(PVector coeff);//This is the point where all layers should be stacked perfectly
}

abstract class Graphical<T extends Component<T>> extends Component implements IGraphic, ICanParallax{
  PVector relativePos = PVector.zero();
  PVector relativeScale = new PVector(1, 1);
  float relativeAngle;
  private boolean isCulled;
  PVector parallaxCoeff = PVector.zero();
  PVector drawPos = PVector.zero();
  boolean canXParallax = false;
  boolean canYParallax = false;
  
  Map<Camera, Integer> cameras = new HashMap<>();//Camera, Layer
  
  Graphical(GameObject _gameObject, Class<T> _typeParameterClass, int _layer, Camera camera){
    super(_gameObject, _typeParameterClass);
    attachCamera(camera, _layer);
    addToGraphicsList(camera, _layer);
    checkCulling(camera);
  }
  
  public void addToGraphicsList(Camera camera, int layer){
      camera.addToGraphicsList(this, layer);
  }
  
  public void removeFromGraphicsList(Camera camera, int layer){
      camera.removeFromGraphicsList(this, layer);
  }
  
  public void setCanXParallax(boolean canParallax){
    canXParallax = canParallax;
  }
  
  public void setCanYParallax(boolean canParallax){
    canYParallax = canParallax;
  }
  
  public void attachCamera(Camera camera, int layer){
   //if (cameras.get(camera) != null)
    cameras.put(camera, layer);
  }
  
  public void setLayer(Camera camera, int _layer){
    camera.removeFromGraphicsList(this, cameras.get(camera));
    Integer layer = cameras.get(camera);
    layer = _layer;
    camera.addToGraphicsList(this, cameras.get(camera));
  }
  
  public void setParallax(PVector coeff){
   parallaxCoeff = coeff;
  }
  
  public void setDrawPosition(Camera camera){

    PVector camPos = camera.getPosition();
    
    float x = camPos.x;
    float y = camPos.y;
    
    boolean hasFocusPoint = camera.getFocusPoint() != null;
    //System.out.println(hasFocusPoint);
    if (hasFocusPoint){
      PVector focusPosition = camera.getFocusPoint().getPosition();
      PVector focusOffset = camera.getFocusOffset();
  
      if (canXParallax)
        x = camPos.x + (focusPosition.x - focusOffset.x) * parallaxCoeff.x;
  
      
      if (canYParallax)
        y = camPos.y + (focusPosition.y - focusOffset.y) * parallaxCoeff.y;
      }
    //System.out.println(camera.getPosition() + " " + new PVector(x, y));
    
      drawPos = new PVector(x, y);
  }
  
   public boolean isCulled(){
    return isCulled; 
   }
  
   public void checkCulling(Camera camera){
     PVector currentPos = gameObject.transform.getPosition();
     currentPos.add(relativePos);
     PVector currentSize = gameObject.transform.size.get();
     currentSize.x *= relativeScale.x;
     currentSize.y *= relativeScale.y;
     isCulled = camera.isInFrame(currentPos, currentSize, drawPos);
   }
  

  public abstract void display(Camera camera);

}
