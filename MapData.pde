//1 rectangle, 2 right angled triangle going up right
class MapData{

    List<int[][]> visualValues = new ArrayList();
    HashMap<Integer, TileMap> tileMaps = new HashMap();
    int[][] colliderValues;
    String tileSetName = "";
    int layers = 0;
    int xLength;
    int yLength;
    int tileWidth;
    int tileHeight;
    int xMargin;
    int yMargin;
    int tileSetXLength;
    int tileSetYLength;
    
    MapData(String mapName){
      switch (mapName){
       case "Level 1" :  tileSetName = "Jungle_terrainwater.png";
       layers = 2;
       xLength = 200;
       yLength = 100;
       tileWidth = tileHeight = 32;
       xMargin = yMargin = 0;
       tileSetXLength = 28;
       tileSetYLength = 15;
       break;
      }
      
      for (int i = 0; i < layers; i++)
        visualValues.add(getMapData("assets/Maps/visuals/" + mapName + "_" + i + ".csv", xLength, yLength));
        
      colliderValues = visualValues.get(1);

    }
    
   TileMap loadTileMap(int mapLayer, int _layer, int _tileWidth, int _tileHeight, Camera _camera){
     if (!tileMaps.containsKey(mapLayer))
       tileMaps.put(mapLayer, new TileMap(this, mapLayer, _layer, _tileWidth, _tileHeight, _camera));
       
     return tileMaps.get(mapLayer);
   }
   
   void loadColliderMap(TileMap tileMap){
        //Create rectangle colliders, one for each uninterrupted row
       for (int y = 0; y < yLength; y++){
         
         boolean beginCollider = false;
         int currentColliderType = -1;
         int currentColliderWidth = 0;
         Tile colliderHost = null;
         
        for (int x = 0; x < xLength; x++){
          PVector position = new PVector(x * tileWidth, y * tileHeight);
          int colliderValue = colliderValues[y][x];
          
          if (colliderValue >= 0){
            if (!beginCollider){
              colliderHost = tileMap.tiles[x][y];
              currentColliderType = colliderValue;
            }
            beginCollider =  true;
            currentColliderWidth += tileWidth;
            if (currentColliderType == 2){
              addTileCollider(colliderHost, currentColliderWidth, tileHeight, currentColliderType);
              beginCollider = false;
              currentColliderWidth = 0;
              colliderHost = null;
              currentColliderType = -1;
            }
          }
          else
          {
            if (beginCollider){
              addTileCollider(colliderHost, currentColliderWidth, tileHeight, currentColliderType);
              beginCollider = false;
              currentColliderWidth = 0;
              colliderHost = null;
              currentColliderType = -1;
            }
          }
        }
        if (beginCollider){
              addTileCollider(colliderHost, currentColliderWidth, tileHeight, currentColliderType);
              beginCollider = false;
              currentColliderWidth = 0;
              colliderHost = null;
              currentColliderType = -1;
        }
      } 
     
   }
   
   private void addTileCollider(Tile colliderHost, int currentColliderWidth, int tileHeight, int currentColliderType){
    TileCollider t;
    if (currentColliderType != 2)
      t = new SquareTileCollider(colliderHost, currentColliderWidth, tileHeight);
    else
      t = new TriangleTileCollider(colliderHost, currentColliderWidth, tileHeight, new PVector(0, tileHeight), new PVector(tileWidth, tileHeight), new PVector(tileWidth, 0));
    //t.toggleColliderDisplay(camera, 1, true);    
    
  }
   
   int[][] getMapData(String mapFilePath, int xLength, int yLength){

   String[] lines = loadStrings(mapFilePath);

   int[][] result = new int[yLength][xLength];
   
   for (int i = 0 ; i < lines.length; i++) {
     String[] items = lines[i].split(",");
 
     int len = items.length;
 
     for (int j = 0; j < len; j++){       
       result[i][j] = Integer.parseInt(items[j]);
     }
   }
   
   return result;

 }
   
   
    
}
/*class MapManager{
  HashMap<String, MapData> maps = new HashMap();
  
  MapData getMapData(String mapName){
    if (!maps.containsKey(mapName))
      maps.put(mapName, new MapData(mapName));
    return maps.get(mapName);
  }
  
}*/