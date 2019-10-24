class TileMap implements IGraphic, ICanParallax{
  Map<Camera, Integer> cameras = new HashMap();//Camera, Layer
  MapData map;

  int tileWidth;
  int tileHeight;
  
  PVector parallaxCoeff = PVector.zero();
  boolean canXParallax = false;
  boolean canYParallax = false;
  PVector drawPos = PVector.zero();
  
  boolean limitCamera;

  List<PImage> textures;
  Tile[][] tiles;
  
  TileMap(MapData _map, int mapLayer, int _layer, int _tileWidth, int _tileHeight, Camera _camera){
    map = _map;

    int sourceWidth = map.tileWidth;
    int sourceHeight = map.tileHeight;
    int sourceXQty = map.tileSetXLength;
    int sourceYQty = map.tileSetYLength;
    int sourceXMargin = map.xMargin;
    int sourceYMargin = map.yMargin;
    tileWidth = _tileWidth;
    tileHeight = _tileHeight;
    
    textures = new ArrayList();
    tiles = new Tile[map.xLength][map.yLength];
    
    int[][] mapData = map.visualValues.get(mapLayer);
    int[][] colliderData = map.colliderValues;
    
    PImage sourceImage = loadImage("assets/Tilesets/" + map.tileSetName);
    attachCamera(_camera, _layer);
    
    int xPos = 0;
    int yPos = 0;
    
    //CREATE A REFERENCE FOR EACH TILE OF THE SHEET
    for (int y = 0; y < sourceYQty; y++){
      for (int i = 0; i < sourceXQty; i++){
        textures.add(sourceImage.get(xPos + sourceXMargin, yPos + sourceYMargin, sourceWidth - 2 * sourceXMargin, sourceHeight - 2 * sourceYMargin));
        xPos += sourceWidth;
      }
      yPos += sourceHeight;
      xPos = 0;
    }
    
    for (int x = 0; x < map.xLength; x++){
      for (int y = 0; y < map.yLength; y++){
        PVector position = new PVector(x * tileWidth, y * tileHeight);
        PImage sprite = null;
        int mapValue = mapData[y][x];
        if (mapValue != -1)
          sprite = textures.get(mapValue);
        tiles[x][y] = new Tile(position, sprite, tileWidth, tileHeight, this);
      }
    }
    
    _camera.addToGraphicsList(this, _layer);
    //Manually attach graphics to other cameras
    _camera.addToParallaxObjects(this);
  }
  
  
  public void checkCulling(Camera camera){}
   
   public boolean isCulled(){
    return false; 
   }

  public void attachCamera(Camera camera, int layer){
   //if (!cameras.containsKey(camera))
    cameras.put(camera, layer);
  }
  
  public void addToGraphicsList(Camera camera, int layer){
      camera.addToGraphicsList(this, layer);
  }
  
  public void removeFromGraphicsList(Camera camera, int layer){
      camera.removeFromGraphicsList(this, layer);
  }
  
  public void setLayer(Camera camera, int _layer){
    removeFromGraphicsList(camera, cameras.get(camera));
    Integer layer = cameras.get(camera);
    layer = _layer;
    addToGraphicsList(camera, cameras.get(camera));
  }

 void display(Camera _camera){
   //currentPosition = getDrawPosition(camera);
   showTiles(_camera);
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
 
 public void setCanXParallax(boolean canParallax){
    canXParallax = canParallax;
  }
  
  public void setCanYParallax(boolean canParallax){
    canYParallax = canParallax;
  }
 
 void showTiles(Camera camera){
     
     PVector startPos = PVector.sub(drawPos, camera.getFocusOffset());
   
     int firstXTile = (int)(startPos.x / tileWidth) - 2;
     int lastXTile = (int)((startPos.x + camera.width) / tileWidth) + 2;
       
     int firstYTile = (int)(startPos.y / tileHeight) - 2;
     int lastYTile = (int)((startPos.y + camera.height) / tileHeight) + 2;

      for (int x = firstXTile; x < lastXTile; x++){
        for (int y = firstYTile; y < lastYTile; y++){
          if (Helper.inRange(x, 0, map.xLength - 1) && Helper.inRange(y, 0, map.yLength - 1))
            tiles[x][y].showTile(startPos);
        }
      }   
 }

 
}

private class Tile{
  final PVector startPosition;
  PImage sprite;
  TileMap tileMap;
  float restitutionCoeff = 0.4f;
  
  Tile(PVector _position, PImage _sprite, int tileHeight, int tileWidth, TileMap _tileMap){
    startPosition = _position;
    sprite = _sprite;
    tileMap = _tileMap;
    if (sprite != null)
      sprite.resize(tileHeight, tileWidth);
  }

  public void showTile(PVector offset){
    if (sprite != null){
      PVector viewPos = startPosition.get();
      viewPos.sub(offset);
      image(sprite, viewPos.x, viewPos.y);
    }
  }
}
