import java.util.*;

abstract class ScriptComponent extends Component{
  
  ScriptComponent(GameObject _gameObject){
    super(_gameObject, ScriptComponent.class);
    GameEngine.addToScriptList(this);
  }
  
  public void init(){}
  public void update(){}
  public void fixedUpdate(){}
}
