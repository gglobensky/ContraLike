import java.util.*;
import processing.core.PApplet;

abstract class Component<T>
{
    final Class<T> typeParameterClass;
    GameObject gameObject;
    
    public Component(GameObject _gameObject, Class<T> typeParameterClass) {
        gameObject = _gameObject;
        this.typeParameterClass = typeParameterClass;
        if (!(typeParameterClass == Transform.class && gameObject.transform != null))
          gameObject.addComponent(this);
    }
    
    public Class<T> getType() {
      return typeParameterClass;
    }
}


public class GameObject
{
  
  static List<Component> expiredComponents = new ArrayList();
  static boolean componentsDirty = false;


  boolean isEnabled = true;
  Transform transform;
  static int counter = 1;
  String name;
  String tag;
  
  Map<Class<Component>, List<Component>> components;
  
    public <T extends Component> T getComponent(Class<T> c){
      return (T)components.get(c).get(0); 
    }
    
    public <T extends Component> List<T> getComponents(Class<T> c){
      List<Component> _components = components.get(c);
      int len = _components.size();
      
      List<T> CastedComponents = new ArrayList<>();
      for (int i = 0; i < len; i++){
       CastedComponents.add((T) _components.get(i));
      }
      
      return CastedComponents; 
    }
    

    <T extends Component> void addComponent(Component c){
      if (!components.containsKey(c.getType())){
        components.put(c.getType(), new ArrayList<Component>());
      }
      if (!components.get(c.getType()).contains(c)){
        components.get(c.getType()).add(c);
      }
    }
    
    <T extends Component> void removeComponent(Component c){
      if (components.containsKey(c.getType())){
        
        expiredComponents.add(c);
        
        componentsDirty = true;
        
      } else {
        System.out.println("Component not found, cannot remove"); 
      }
    }
    
    GameObject(){

    components = new HashMap<>();
    name = "GameObject " + counter;
    tag = "";
    counter++;
    transform = new Transform(this, PVector.zero(), new PVector(1, 1));
    this.addComponent(transform);
  }
}

class Transform extends Component{
  
 static final PVector worldUp = new PVector(0, -1);
 static final PVector worldRight = new PVector(1, 0);
 static final PVector worldDown = new PVector(0, 1);
 PVector up = new PVector(0, -1);
 PVector right = new PVector(1, 0);
 PVector size = new PVector(1, 1);
 protected float rotation = 0;
 private PVector previousPosition;
 private PVector position;
 PVector scale;

  Transform(GameObject _gameObject, PVector _position, PVector _size){
    super(_gameObject, Transform.class);
    position = _position;
    previousPosition = position;
    scale = new PVector(1, 1);
  }
  
  public PVector getPosition(){
    return position.get(); 
  }
  
  /*public PVector position(){
    return position; 
  }*/
  
  public void setPosition(PVector _position){
    previousPosition = position;
    position = _position;
    
  }
  
  public PVector getPreviousPosition(){ return previousPosition; }
  
  public PVector rotateVector(float _rad, PVector worldAxis){

    double cs = Math.cos(_rad);
    double sn = Math.sin(_rad);
    
    double px = worldAxis.x * cs - worldAxis.y * sn; 
    double py = worldAxis.x * sn + worldAxis.y * cs;
    
    return new PVector((float)px, (float)py);
  }
  
  protected void rotateOnAxis(float _rad){
    rotation += _rad;
    
    up = rotateVector(rotation, Transform.worldUp);
    right = rotateVector(rotation, Transform.worldRight);
  }

}
