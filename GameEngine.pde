static class GameEngine{
 static final float gravityForce = 0.1f;
 static List<PhysicsObserver> physicsObjects = new ArrayList();
 static List<ICollidable> colliderObjects = new ArrayList();
 static HashMap<ICollidable, HashMap<ICollidable, CollisionInfo>> collisions = new HashMap();
 static List<ScriptComponent> scripts = new ArrayList();
 
 static void updatePhysics(){
    int len = physicsObjects.size();

    for (int i = 0; i < len; i++){
      physicsObjects.get(i).update();
    }
 }
 
 static void updateScripts(boolean doFixedUpdate){
   int len = scripts.size();

    for (int i = 0; i < len; i++){
      scripts.get(i).update();
      if (doFixedUpdate)
        scripts.get(i).fixedUpdate();
    }

 }
 
 static void initScripts(){

   int len = scripts.size();

    for (int i = 0; i < len; i++){
      scripts.get(i).init();
    }
 
 }
 
 static void updateCollisions(){
    int len = colliderObjects.size();

    for (int i = 0; i < len; i++){
      colliderObjects.get(i).manageCollider();
      if (colliderObjects.get(i).hasMoved()){
        
        for (int j = 0; j < len; j++){
          PVector againstPos = colliderObjects.get(j).getPosition();
          PVector againstSize = colliderObjects.get(j).getSize();
          PVector velocity = colliderObjects.get(i).getVelocity();
          
          float xMin = againstPos.x - velocity.x;
          float xMax = againstPos.x + againstSize.x + velocity.x;
          
          float yMin = againstPos.y - velocity.y;
          float yMax = againstPos.y + againstSize.y + velocity.y;
          
          /*float xMin = -10000;
          float xMax = 10000;
          
          float yMin = 0;
          float yMax = 10000;*/
          
          PVector currentPos = colliderObjects.get(i).getPosition();
          PVector currentSize = colliderObjects.get(i).getSize();
          
          if (currentPos.x >= xMin - currentSize.x && currentPos.x <= xMax + currentSize.x && currentPos.y >= yMin - currentSize.y && currentPos.y <= yMax + currentSize.y){
            if (!(collisions.containsKey(colliderObjects.get(j)) && collisions.get(colliderObjects.get(j)).containsKey(colliderObjects.get(i)))){//check if collision already checked by other object
              if (i != j){
                colliderObjects.get(i).manageCollision(colliderObjects.get(j));
              }
            } 
          }
        }
      }
    }
 }
 
 static void resolveCollisions(){
    
    for (Map.Entry<ICollidable, HashMap<ICollidable, CollisionInfo>> entry : collisions.entrySet()) {
      ICollidable _collider = entry.getKey();
      HashMap<ICollidable, CollisionInfo> _collisions = entry.getValue();
      
      for (Map.Entry<ICollidable, CollisionInfo> _entry : _collisions.entrySet()) {
        ICollidable collidedWith = _entry.getKey();
        CollisionInfo collisionInfo = _entry.getValue();
        _collider.resolveCollision(collidedWith);
      }
    }
    //println(collisions.size());
    collisions.clear();
 }
 
 static public void addToPhysicsList(PhysicsObserver physicsObserver){
   if (!physicsObjects.contains(physicsObserver))
     physicsObjects.add(physicsObserver);
 }
 
 static public void removeFromPhysicsList(PhysicsObserver physicsObserver){
   if (physicsObjects.contains(physicsObserver))
     physicsObjects.remove(physicsObserver);
 }
 
 static public void addToScriptList(ScriptComponent scriptComponent){
   if (!scripts.contains(scriptComponent))
     scripts.add(scriptComponent);
 }
 
 static public void removeFromScriptList(ScriptComponent scriptComponent){
   if (scripts.contains(scriptComponent))
     scripts.remove(scriptComponent);
 }
 
 static public void addToColliderList(ICollidable colliderObject){
   if (!colliderObjects.contains(colliderObject))
     colliderObjects.add(colliderObject);
 }
 
 static public void removeFromColliderList(ICollidable colliderObject){
   if (colliderObjects.contains(colliderObject))
     colliderObjects.remove(colliderObject);
 }
 
 static public void addCollision(ICollidable collider, ICollidable against, CollisionInfo collisionInfo){
   if (!collisions.containsKey(collider))
     collisions.put(collider, new HashMap());
     
   collisions.get(collider).put(against, collisionInfo);//println(collisions.get(collider).get(against));
 }
 
 static CollisionInfo getCollisionInfo(ICollidable collider, ICollidable other){
   if (collisions.containsKey(collider) && collisions.get(collider).containsKey(other)){
     return collisions.get(collider).get(other);
   }
   return null;
 }
}

static class CollisionInfo {
  PVector collisionPoint;
  PVector surfaceNormal;
  public CollisionInfo(){};
  public CollisionInfo(PVector _collisionPoint, PVector _surfaceNormal){
   collisionPoint = _collisionPoint;
   surfaceNormal = _surfaceNormal;
   }
}
