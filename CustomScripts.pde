class PlayerScript extends ScriptComponent{
  
  HashMap<String, String> actions = new HashMap();
  PhysicsBody pb;
  Collider collider;
  float currentSpeed = 0;

  boolean grounded = false;
  Raycast bottomRay;
  Raycast rightRay;
  Raycast leftRay;
  AnimatedSprite sprite;
  
  PlayerScript(GameObject _gameObject){
    super(_gameObject);
  }
  
  void init(){
    pb = gameObject.getComponent(PhysicsBody.class);
    collider = gameObject.getComponent(Collider.class);
    sprite = gameObject.getComponent(AnimatedSprite.class);
    
    collider.restitutionCoeff = 0;
    
    bottomRay = new Raycast(PVector.add(collider.getPosition(), new PVector(0, collider.getSize().y)), new PVector(collider.getSize().x, 0));
    bottomRay.toggleRaycastDisplay(camera, 8, true);
    
    rightRay = new Raycast(PVector.add(collider.getPosition(), new PVector(collider.getSize().x, 0)), new PVector(0, collider.getSize().y));
    rightRay.toggleRaycastDisplay(camera, 8, true);
    
    leftRay = new Raycast(PVector.add(gameObject.transform.position(), new PVector(gameObject.transform.size.x, 0)), new PVector(0, gameObject.transform.size.y));
    leftRay.toggleRaycastDisplay(camera, 8, true);
    
    actions.put("MoveRight", "Right");
    actions.put("MoveLeft", "Left");
    actions.put("Jump", " ");
    actions.put("Crouch", "Down");
  }
  
  void update(){
  
  }
  
  void fixedUpdate(){
    boolean applyGravity = true;
    
    if (sprite.currentAction == "Crawling"){
      sprite.setScale(new PVector(1.4, 1));
        
      collider.relativePosition = new PVector(0, 24);
      collider.setSize(new PVector(56, 24));
    }
    else{
      sprite.setScale(new PVector(1, 1));
      c.relativePosition = new PVector(6, 0);
      collider.setSize(new PVector(36, 48));
    }
    
    if (grounded){
      sprite.currentAction = "Idle";
    }
    else{
      sprite.setScale(new PVector(1, 1));
      sprite.currentAction = "Jumping";
    }
    
    if (grounded && InputManager.getKey(actions.get("Crouch"))){
      sprite.currentAction = "Crawling";
      sprite.isPlaying = false;
    }
    
    if (InputManager.getKey(actions.get("MoveLeft")) && !leftRay.raycastHit()){
      sprite.isPlaying = true;
      sprite.flipX(false);
      applyGravity = !grounded;
      currentSpeed = -3f;
      pb.setVelocity(currentSpeed, pb.velocity.y);
      if (grounded)
        sprite.currentAction = "Running";
    }
    
    if (InputManager.getKey(actions.get("MoveRight")) && !rightRay.raycastHit()){
      sprite.isPlaying = true;
      sprite.flipX(true);
      applyGravity = !grounded;
      currentSpeed = 3f;
      pb.setVelocity(currentSpeed, pb.velocity.y);
      if (grounded)
        sprite.currentAction = "Running";
    }
    
    if (InputManager.getKeyPressed(actions.get("Jump")) && grounded){
      applyGravity = true;
      pb.applyForce(new PVector(0, -5));
    }
    
    pb.applyGravity = applyGravity;
    
    PVector pos = collider.getPosition();
    
    bottomRay.origin = PVector.add(gameObject.transform.getPosition(), new PVector(0, gameObject.transform.size.y));
    bottomRay.origin.add(new PVector(6, 8)); 

    rightRay.origin = new PVector(pos.x + collider.getSize().x, gameObject.transform.getPosition().y);
    rightRay.origin.add(new PVector(8, -1)); 
    
    leftRay.origin = new PVector(pos.x, gameObject.transform.getPosition().y);
    leftRay.origin.sub(new PVector(8, 1)); 

    grounded = bottomRay.raycastHit();

  }

}
