import java.util.*;

interface CamSubject{
  void addToGraphicsList(IGraphic iGraphic, int layer);
  void removeFromGraphicsList(IGraphic iGraphic, int layer);
  void notify(List<IGraphic>[] graphicsList, ArrayList<ICanParallax> parallaxObjects);
  
  void addToParallaxObjects(ICanParallax obj);
  void removeFromParallaxObjects(ICanParallax obj);
}

class Camera implements CamSubject {
    private static List<IGraphic>[] graphicsList = new List[9];
    private static ArrayList<ICanParallax> parallaxObjects = new ArrayList<ICanParallax>();
    boolean followFocusPoint = true;
    private Transform focusPoint;
    private PVector focusOffset;
    private PVector position = PVector.zero();
    private PVector drawPosition = PVector.zero();
    private PVector lowerLimit;
    private PVector upperLimit;
    
    int width;
    int height;
    
    public PVector getPosition() {
        return position.get();
    }
    
    Camera(int screenWidth, int screenHeight){
     for (int i = 0; i < 9; i++){
      Camera.graphicsList[i] = new ArrayList<>(); 
     }
     width = screenWidth;
     height = screenHeight;
   }
  
  public void setCameraLimits(PVector _lowerLimit, PVector _upperLimit){
    lowerLimit = _lowerLimit;
    upperLimit = _upperLimit;
  }
  
  public void notify(List<IGraphic>[] graphicsList, ArrayList<ICanParallax> parallaxObjects){

    for (int i = 0; i < 9; i++){
     int len = graphicsList[i].size();
     for (int j = 0; j < len; j++){
       graphicsList[i].get(j).checkCulling(this);
     }
    }
    
    int len = parallaxObjects.size();
    
    for (int i = 0; i < len; i++){
      parallaxObjects.get(i).setDrawPosition(this);

    }
    
  }
    
    public void addToGraphicsList(IGraphic iGraphic, int layer){
      if (graphicsList[layer] == null)
        graphicsList[layer] = new ArrayList();
      if (!graphicsList[layer].contains(iGraphic))
        graphicsList[layer].add(iGraphic);

    }
    
    public void addToParallaxObjects(ICanParallax obj){
     if (!parallaxObjects.contains(obj))
       parallaxObjects.add(obj);
    }
    
    public void removeFromParallaxObjects(ICanParallax obj){
     if (parallaxObjects.contains(obj))
       parallaxObjects.remove(obj);
    }
    
    public void removeFromGraphicsList(IGraphic iGraphic, int layer){
       if (graphicsList[layer].contains(iGraphic))
         graphicsList[layer].remove(iGraphic); 
    }

    public static List<IGraphic>[] getGraphicsList(){
       return graphicsList; 
    }
    
    public boolean isInFrame(PVector _position, PVector _dimensions, PVector drawPosition){
      if (_position.x + _dimensions.x > position.x && _position.x < drawPosition.x + width)
        if (_position.y + _dimensions.y > position.y && _position.y < drawPosition.y + height)
          return true;
      return false;
    }
    
    public Transform getFocusPoint(){
     return focusPoint; 
    }
    
    public PVector getFocusOffset(){
     return focusOffset != null? focusOffset : PVector.zero();  
    }
    
    public void setPosition(float x, float y) {
        position.x = x;    
        position.y = y;

        notify(graphicsList, parallaxObjects);
    }
    
    void setFocus(Transform _focusPoint, PVector _focusOffset){
     focusPoint = _focusPoint;
     focusOffset = _focusOffset;
    }
    
    public void manageView(){
       if (followFocusPoint && focusPoint != null){
        position = focusPoint.getPosition();
        if (upperLimit != null && lowerLimit != null){
          position.x = Math.min(Math.max(lowerLimit.x, position.x), upperLimit.x);
          position.y = Math.min(Math.max(lowerLimit.y, position.y), upperLimit.y);
          notify(graphicsList, parallaxObjects);
        }
        if (focusOffset != null){
         position.sub(focusOffset); 
        }
       }
       for (int i = 0; i < 9; i++){
        for (IGraphic g : graphicsList[i])
          g.display(this);
       }
       
    }

}
