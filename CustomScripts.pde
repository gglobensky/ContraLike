class PlayerScript extends ScriptComponent{
  
  HashMap<String, String> actions = new HashMap();
  PhysicsBody pb;
  Collider collider;
  float currentXSpeed = 0;
  float currentYSpeed = 0;
  
  boolean grounded = false;
  Raycast bottomRay;
  Raycast rightRay;
  Raycast leftRay;
  String leftRaycastHitTag;
  String rightRaycastHitTag;
  String bottomRaycastHitTag;
  boolean applyGravity = true;
  boolean moving = false;
  boolean inWater = false;
  PVector direction;
      
  AnimatedSprite sprite;
  
  PlayerScript(GameObject _gameObject){
    super(_gameObject);
  }
  
  void init(){
    pb = gameObject.getComponent(PhysicsBody.class);
    collider = gameObject.getComponent(Collider.class);
    sprite = gameObject.getComponent(AnimatedSprite.class);
    
    collider.restitutionCoeff = 0;
    
    bottomRay = new Raycast(PVector.add(collider.getPosition(), new PVector(0, collider.getSize().y)), new PVector(collider.getSize().x + 6, 0));
    //bottomRay.toggleRaycastDisplay(camera, 8, true);
    
    rightRay = new Raycast(PVector.add(collider.getPosition(), new PVector(collider.getSize().x, 0)), new PVector(0, collider.getSize().y));
    //rightRay.toggleRaycastDisplay(camera, 8, true);
    
    leftRay = new Raycast(PVector.add(gameObject.transform.getPosition(), new PVector(gameObject.transform.size.x, 0)), new PVector(0, gameObject.transform.size.y));
    //leftRay.toggleRaycastDisplay(camera, 8, true);
    
    actions.put("MoveRight", "Right");
    actions.put("MoveLeft", "Left");
    actions.put("Jump", " ");
    actions.put("Crouch", "Down");
    actions.put("AimUp", "Up");
    actions.put("DeleteSprite", "x");
    
    sprite.flipX(true);
  }
  
  void update(){
  
  }
  
  void fixedUpdate(){
    
    prepareStep();
    
    manageAnimations();
        
    manageCrouch();
    
    if (!inWater){
      manageMoveLeft();
      
      manageMoveRight();
    } else {
      pb.applyGravity = true;

      manageSwimLeft();
    
      manageSwimRight();    
    }
    
    manageAimDiagonal();
    
    manageAimUp();
    
    manageJump();
    
    if (InputManager.getKey(actions.get("DeleteSprite"))){
      gameObject.removeComponent(sprite);
    }
    
    finalizeStep();
    
    manageRaycastPositions();

  }
  
  private void prepareStep(){
      
    applyGravity = true;
    moving = false;
    inWater = (leftRaycastHitTag == "Water" || rightRaycastHitTag == "Water" || bottomRaycastHitTag == "Water");
    
    leftRaycastHitTag = leftRay.raycastHit();
    rightRaycastHitTag = rightRay.raycastHit();
    bottomRaycastHitTag = bottomRay.raycastHit();
    direction = pb.getVelocity();
    currentYSpeed = pb.velocity.y;
  }
  
  private void finalizeStep(){ 

    pb.applyGravity = applyGravity;

    grounded = (bottomRaycastHitTag != null && bottomRaycastHitTag != "player"); 

    if (leftRaycastHitTag == "SmoothUpSlope" || rightRaycastHitTag == "SmoothUpSlope" || bottomRaycastHitTag == "SmoothUpSlope"){
      if (InputManager.getKeyReleased(actions.get("MoveLeft")) || InputManager.getKeyReleased(actions.get("MoveRight"))){
        direction = PVector.zero();
      }
    }
    
    if (inWater)
      pb.topSpeed = 5f;
    else
      pb.topSpeed = 1000f;
      
    pb.setVelocity(direction.x, direction.y);

  }
  
  private void manageAnimations(){

    if (sprite.currentAction == "Crawling"){
      sprite.setScale(new PVector(1.4, 1));
        
      collider.relativePosition = new PVector(0, 24);
      collider.setSize(new PVector(56, 24));
    }
    else if (sprite.currentAction == "AimUp"){
      sprite.setScale(new PVector(1, 1.14));
      sprite.relativePos = new PVector(0, -3);
    }
    else{
      sprite.relativePos = PVector.zero();
      sprite.setScale(new PVector(1, 1));
      collider.relativePosition = new PVector(6, 0);
      collider.setSize(new PVector(36, 48));
    }
    
    if (grounded){
      sprite.currentAction = "Idle";
    }
    else{
      sprite.setScale(new PVector(1, 1));
      sprite.currentAction = "Jumping";
    }
    
    if (bottomRaycastHitTag == "Water"){
      sprite.isPlaying = false;
      sprite.currentAction = "Crawling";
    }
    
  }
  
  private void manageRaycastPositions(){
    PVector pos = collider.getPosition();
        
    bottomRay.origin = PVector.add(gameObject.transform.getPosition(), new PVector(0, gameObject.transform.size.y));
    bottomRay.origin.add(new PVector(3, 4));

    rightRay.origin = new PVector(pos.x + collider.getSize().x, gameObject.transform.getPosition().y);
    
    leftRay.origin = new PVector(pos.x, gameObject.transform.getPosition().y);
    
    if (grounded){
      leftRay.origin.sub(new PVector(8, 1));
      rightRay.origin.add(new PVector(8, -1));
    }
    else{
      leftRay.origin.sub(new PVector(8, -4));
      rightRay.origin.add(new PVector(8, 4));
    }
  }
  
  private void manageAimDiagonal(){
    if (InputManager.getKey(actions.get("AimUp"))){
      sprite.isPlaying = true;
      if (sprite.currentAction == "Running" || sprite.currentAction == "AimDiagonal"){
        int currentFrame = sprite.getCurrentFrame();
        sprite.currentAction = "AimDiagonal";
        sprite.setCurrentFrame(currentFrame);
      }
    }
  }
  
  private void manageAimUp(){
    if (InputManager.getKey(actions.get("AimUp"))){
      if (sprite.currentAction == "Idle"){
        sprite.currentAction = "AimUp";
      }
    }
  }
  
  private void manageJump(){
    if (InputManager.getKeyPressed(actions.get("Jump")) && grounded){
      applyGravity = true;
      pb.applyForce(new PVector(0, -5));
    }
  }
  
  private void manageCrouch(){   
    if (grounded && InputManager.getKey(actions.get("Crouch"))){
      sprite.currentAction = "Crawling";
      sprite.isPlaying = false;
    } 
  }
  
  private void manageSwimLeft(){
    if (InputManager.getKey(actions.get("MoveLeft")) && (leftRaycastHitTag == "Water" || leftRaycastHitTag == null)){
      sprite.isPlaying = true;
      sprite.flipX(false);
      applyGravity = true;
      currentXSpeed = -1.5f;
      
      direction = new PVector(currentXSpeed, currentYSpeed);
      moving = true;
      
      sprite.currentAction = "Crawling";
    }
  }
  
  private void manageSwimRight(){
    if (InputManager.getKey(actions.get("MoveRight")) && (rightRaycastHitTag == "Water" || rightRaycastHitTag == null)){
      sprite.isPlaying = true;
      sprite.flipX(true);
      applyGravity = true;
      currentXSpeed = 1.5f;
      
      direction = new PVector(currentXSpeed, currentYSpeed);
      moving = true;
      
      sprite.currentAction = "Crawling";
    }
  }
  
  private void manageMoveLeft(){
    if (InputManager.getKey(actions.get("MoveLeft")) && (leftRaycastHitTag == null || leftRaycastHitTag == "SmoothUpSlope")){
      sprite.isPlaying = true;
      sprite.flipX(false);
      applyGravity = !grounded;
      currentXSpeed = -3f;
      
      direction = new PVector(currentXSpeed, currentYSpeed);
      moving = true;
    

      if (leftRaycastHitTag == "SmoothUpSlope"){
        if (collider.hasCollided())
          pb.applyForce(new PVector(0, -1.475f));

      } else if (bottomRaycastHitTag == "SmoothUpSlope" && rightRaycastHitTag == "SmoothUpSlope"){
        PVector position = gameObject.transform.getPosition();
        if (!collider.hasCollided())
          position.y += 1.45f;

        gameObject.transform.setPosition(position);      

      }

      if (grounded)
        sprite.currentAction = "Running";
    }
  }
  
  private void manageMoveRight(){
    if (InputManager.getKey(actions.get("MoveRight")) && (rightRaycastHitTag == null || rightRaycastHitTag == "SmoothUpSlope")){
      sprite.isPlaying = true;
      sprite.flipX(true);
      applyGravity = !grounded;
      currentXSpeed = 3f;
      
      direction = new PVector(currentXSpeed, currentYSpeed);
      moving = true;
      

      if (rightRaycastHitTag == "SmoothUpSlope"){
        if (collider.hasCollided())
          pb.applyForce(new PVector(0, -1.475f));

      } else if (bottomRaycastHitTag == "SmoothUpSlope"){
        PVector position = gameObject.transform.getPosition();
        if (!collider.hasCollided())
          position.y += 1.45f;
        gameObject.transform.setPosition(position);      

      }
      
      if (grounded)
        sprite.currentAction = "Running";
    }
  }
}
