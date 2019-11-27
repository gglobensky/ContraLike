Camera camera;
public class Game{

  SquareCollider c;
  GameObject player;
  Transform tr;
  
  TileMap t;
  
  public void init(){
    camera = new Camera(width, height); 
    MapData mapData = new MapData("Level 1");
    
    GameObject water = new GameObject();
    water.tag = "Water";
    water.transform.setPosition(new PVector(0, 2256));
    water.transform.size = new PVector(720, 144);
    SquareCollider s = new SquareCollider(water, false);
    water.name = "water";
    new FluidBody(water, 1.5f, 0.1f);
    
    PVector levelLowerLimit = new PVector(width / 2, 0);
    PVector levelUpperLimit = new PVector(4800, 2400 - height / 2);
    
    player = new GameObject();
    player.transform.setPosition(new PVector(50, 2100));
    player.transform.size = new PVector(48, 48);
    c = new SquareCollider(player, true);
    c.setTag("player");
    PhysicsBody pb = new PhysicsBody(player);
    pb.velocity = new PVector(10, -12);
    new PlayerScript(player);

    c.xSize = 36;
    c.relativePosition = new PVector(6, 0);
    AnimatedSprite a = new AnimatedSprite(player, 6, camera, "PlayerRunningAnimation.png", "Running", 8, 1, 0, 0, 50, 50, 0.5f);
    a.addAnimation("PlayerIdleSprite.png", "Idle", 1, 1, 0, 0, 50, 50, 1);
    a.addAnimation("PlayerJumpingSprite.png", "Jumping", 1, 1, 0, 0, 50, 50, 1);
    a.addAnimation("PlayerCrawlingAnimation.png", "Crawling", 3, 1, 0, 0, 70, 50, 1);
    a.addAnimation("PlayerRunningAiming.png", "AimDiagonal", 8, 1, 0, 0, 50, 50, 0.5f);
    a.addAnimation("PlayerAimUp.png", "AimUp", 1, 1, 0, 0, 50, 57, 1f);
    tr = player.transform;
    
    BackgroundImage mountains = new BackgroundImage(new PVector(0, levelUpperLimit.y - 64), "assets\\Maps\\backgrounds\\mountain.png", new PVector(1838, 512), 0, camera, false, false);
    mountains.setParallax(new PVector(-0.5, 0.1));
    mountains.setCanXParallax(true);
    mountains.setCanYParallax(true);
    
    BackgroundImage clouds = new BackgroundImage(new PVector(0, levelUpperLimit.y - 768), "assets\\Maps\\backgrounds\\whiteclouds.png", new PVector(919, 300), 0, camera, false, false);
    clouds.setParallax(new PVector(-1, 0.1));
    clouds.setCanXParallax(true);
    clouds.setCanYParallax(true);

    TileMap tileMap = mapData.loadTileMap(1, 1, 24, 24, camera);
    mapData.loadTileMap(0, 0, 24, 24, camera);
    mapData.loadTileMap(2, 2, 24, 24, camera);
    mapData.loadColliderMap(tileMap);

    //Add or remove colliders from display list for debug purposes
    //c.toggleColliderDisplay(camera, 1, true);

    PVector camPos = PVector.sub(player.transform.getPosition(), new PVector(width / 2, height / 2));
    camera.setPosition(camPos.x, camPos.y);
    camera.setFocus(player.transform, new PVector(width / 2, height / 2));
    camera.setCameraLimits(levelLowerLimit, levelUpperLimit);

  }
  
  public void update(){
    camera.manageView();
  }
  
  public void fixedUpdate(){
  
  }
}
