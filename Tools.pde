import java.time.*; 
import java.util.*;

static class Time{
  static long elapsedTime = 0;
  static long lastTime = 0;
  static long delta = 0;
  static Clock clock = Clock.systemDefaultZone();
  
  static void update(){
  if (lastTime != 0)
    delta = clock.millis() - lastTime;
  lastTime = clock.millis();   
  elapsedTime += delta;
}
  static long getElapsedTime(){ return elapsedTime; }
  static long getMillis(){
    return clock.millis();     
  }
  
  static long getNano(){
   return System.nanoTime(); 
  }
}

static class InputManager{
  static private boolean[] inputs = new boolean[360];
  static private int currentKeyPressed = 65535;
  static private int currentKeyReleased = 65535;
  
  ///UPPERCASE AND LOWERCASE ARE THE SAME FOR INPUTS

  static void checkInputs(Character input, int kCode){//Call it in KeyPressed of main program
    if (input != CODED){
       if (input >= 65 && input <= 90)
        input = (char)(input + 32);
        
      if (inputs[input] == false){
        currentKeyPressed = input;
      }
      inputs[input] = true;
    }
    else{
      if (kCode == ALT){
        if (inputs[128] == false)
              currentKeyPressed = 128;
        inputs[128] = true;
      }
      else if (kCode == CONTROL){
        if (inputs[129] == false)
              currentKeyPressed = 129;
        inputs[129] = true;
      }
      else if (kCode == DELETE){
        if (inputs[130] == false)
              currentKeyPressed = 130;
        inputs[130] = true;
      }
      else if (kCode == DOWN){
        if (inputs[131] == false)
              currentKeyPressed = 131;
        inputs[131] = true;
      }
      else if (kCode == ENTER){
        if (inputs[132] == false)
              currentKeyPressed = 132;
        inputs[132] = true;
      }
      else if (kCode == LEFT){
        if (inputs[133] == false)
              currentKeyPressed = 133;
        inputs[133] = true;
      }
      else if (kCode == RETURN){
        if (inputs[134] == false)
              currentKeyPressed = 134;
        inputs[134] = true;
      }
      else if (kCode == RIGHT){
        if (inputs[135] == false)
              currentKeyPressed = 135;
        inputs[135] = true;
      }
      else if (kCode == SHIFT){
        if (inputs[136] == false)
              currentKeyPressed = 136;
        inputs[136] = true;
      }
      else if (kCode == UP){
        if (inputs[137] == false)
              currentKeyPressed = 137;
        inputs[137] = true;
      }
    }


  }
  

  static void checkReleases(Character input, int kCode){
    if (input != CODED){
      if (input >= 65 && input <= 90)
        input = (char)(input + 32);
      if (inputs[input] == true)
        currentKeyReleased = input;
      inputs[input] = false;
    }
     else{
        if (kCode == ALT){
          if (inputs[128] == true)
              currentKeyReleased = 128;
          inputs[128] = false;
        }
        else if (kCode == CONTROL){
          if (inputs[129] == true)
              currentKeyReleased = 129;
          inputs[129] = false;
        }
        else if (kCode == DELETE){
          if (inputs[130] == true)
              currentKeyReleased = 130;
          inputs[130] = false;
        }
        else if (kCode == DOWN){
          if (inputs[131] == true)
              currentKeyReleased = 131;
          inputs[131] = false;
        }
        else if (kCode == ENTER){
          if (inputs[132] == true)
              currentKeyReleased = 132;
          inputs[132] = false;
        }
        else if (kCode == LEFT){
          if (inputs[133] == true)
              currentKeyReleased = 133;
          inputs[133] = false;
        }
        else if (kCode == RETURN){
          if (inputs[134] == true)
              currentKeyReleased = 134;
          inputs[134] = false;
        }
        else if (kCode == RIGHT){
          if (inputs[135] == true)
              currentKeyReleased = 135;
          inputs[135] = false;
        }
        else if (kCode == SHIFT){
          if (inputs[136] == true)
              currentKeyReleased = 136;
          inputs[136] = false;
        }
        else if (kCode == UP){
          if (inputs[137] == true)
              currentKeyReleased = 137;
          inputs[137] = false;
        } 
     }
  }
  
  static boolean getKeyPressed(Character input){
      boolean b = Character.toLowerCase(input) == currentKeyPressed;
      if (b)
        currentKeyPressed = 65535;
      return b;

  }
  
  static boolean getKeyPressed(String input){
     if (input.length() == 1){
       return getKeyPressed(input.charAt(0));
     }
     else if (input == "Alt"){
        boolean b = currentKeyPressed == 128;
       if (b)
         currentKeyPressed = 65535;
       return b;
     }
     else if (input == "Control"){
          boolean b =  currentKeyPressed == 129;
        if (b)
          currentKeyPressed = 65535;
        return b;
     }
     else if (input == "Delete"){
          boolean b =  currentKeyPressed == 130;
        if (b)
          currentKeyPressed = 65535;
        return b;
     }
     else if (input == "Down"){
          boolean b =  currentKeyPressed == 131;
        if (b)
          currentKeyPressed = 65535;
        return b;
     }
     else if (input == "Enter"){
          boolean b =  currentKeyPressed == 132;
        if (b)
          currentKeyPressed = 65535;
        return b;
     }
     else if (input == "Left"){
          boolean b =  currentKeyPressed == 133;
        if (b)
          currentKeyPressed = 65535;
        return b;
     }
     else if (input == "Return"){
          boolean b =  currentKeyPressed == 134;
        if (b)
          currentKeyPressed = 65535;
        return b;
     }
     else if (input == "Right"){
          boolean b =  currentKeyPressed == 135;
        if (b)
          currentKeyPressed = 65535;
        return b;
     }
     else if (input == "Shift"){
          boolean b =  currentKeyPressed == 136;
        if (b)
          currentKeyPressed = 65535;
        return b;
     }
     else if (input == "Up"){
          boolean b = currentKeyPressed == 137;
        if (b)
          currentKeyPressed = 65535;
        return b;
     }  
     else return false;
  }
  
  static boolean getKeyReleased(Character input){
      boolean b = Character.toLowerCase(input) == currentKeyReleased;
      if (b)
        currentKeyReleased = 65535;
      return b;
  }
  
  static boolean getKeyReleased(String input){
     if (input.length() == 1){
       return getKeyReleased(input.charAt(0));
     }
     else if (input == "Alt"){
        boolean b = currentKeyReleased == 128;
       if (b)
         currentKeyReleased = 65535;
       return b;
     }
     else if (input == "Control"){
          boolean b =  currentKeyReleased == 129;
        if (b)
          currentKeyReleased = 65535;
        return b;
     }
     else if (input == "Delete"){
          boolean b =  currentKeyReleased == 130;
        if (b)
          currentKeyReleased = 65535;
        return b;
     }
     else if (input == "Down"){
          boolean b =  currentKeyReleased == 131;
        if (b)
          currentKeyReleased = 65535;
        return b;
     }
     else if (input == "Enter"){
          boolean b =  currentKeyReleased == 132;
        if (b)
          currentKeyReleased = 65535;
        return b;
     }
     else if (input == "Left"){
          boolean b =  currentKeyReleased == 133;
        if (b)
          currentKeyReleased = 65535;
        return b;
     }
     else if (input == "Return"){
          boolean b =  currentKeyReleased == 134;
        if (b)
          currentKeyReleased = 65535;
        return b;
     }
     else if (input == "Right"){
          boolean b =  currentKeyReleased == 135;
        if (b)
          currentKeyReleased = 65535;
        return b;
     }
     else if (input == "Shift"){
          boolean b =  currentKeyReleased == 136;
        if (b)
          currentKeyReleased = 65535;
        return b;
     }
     else if (input == "Up"){
          boolean b = currentKeyReleased == 137;
        if (b)
          currentKeyReleased = 65535;
        return b;
     }  
     else return false;
  }
  
  static boolean getKey(Character input){
     return inputs[Character.toLowerCase(input)]; 
  }
  
  static boolean getKey(String input){
     if (input.length() == 1){
       return getKey(input.charAt(0));
     }
     else if (input == "Alt"){
        return inputs[128];
     }
     else if (input == "Control"){
          return inputs[129];
     }
     else if (input == "Delete"){
          return inputs[130];
     }
     else if (input == "Down"){
          return inputs[131];
     }
     else if (input == "Enter"){
          return inputs[132];
     }
     else if (input == "Left"){
          return inputs[133];
     }
     else if (input == "Return"){
          return inputs[134];
     }
     else if (input == "Right"){
          return inputs[135];
     }
     else if (input == "Shift"){
          return inputs[136];
     }
     else if (input == "Up"){
          return inputs[137];
     }  
     else return false;
  }

  static void resetInputManagerValues(){
    currentKeyPressed = 65535;
    currentKeyReleased = 65535;
  }
}

static class Helper{
   static boolean inRange(float value, int min, int max) {
     return (value >= min) && (value <= max);
   }
   
   static float ensureRange(float value, float min, float max) {
     return Math.min(Math.max(value, min), max);
   }
   
   static Vector<Vector<Float>> inverseTwoByTwoMatrix(Vector<Vector<Float>> matrix){
     float a = matrix.get(0).get(0);
     float b = matrix.get(0).get(1);
     float c = matrix.get(1).get(0);
     float d = matrix.get(1).get(1);
     float ad = a * d;
     float bc = b * c;
     float coeff = 0;
     
     if (ad != bc){
       coeff = 1 / (ad - bc);
     }
     
     Vector<Vector<Float>> resultMatrix = null;
     
     if (coeff != 0){
       resultMatrix = new Vector<Vector<Float>>();
       Vector<Float> row = new Vector();
       row.add(coeff * d);
       row.add(coeff * -b);
       resultMatrix.add(row);
       row = new Vector();
       row.add(coeff * -c);
       row.add(coeff * a);
       resultMatrix.add(row);
     }
     
     return resultMatrix;
   }
   
   static PVector solveTwoEquationSystem(float a, float b, float c, float d, float e, float f){
     ///ax + by = e // cx + dy = f
     Vector<Vector<Float>>  matrix= new Vector<Vector<Float>>();
     
     Vector<Float> row = new Vector();
     row.add(a);
     row.add(b);
     matrix.add(row);
     row = new Vector();
     row.add(c);
     row.add(d);
     matrix.add(row);
     
     matrix = inverseTwoByTwoMatrix(matrix);
     
     if (matrix != null){
       float x = matrix.get(0).get(0) * e + matrix.get(0).get(1) * f;
       float y = matrix.get(1).get(0) * e + matrix.get(1).get(1) * f;
       
       return new PVector(x, y);}
     
     return null;
   }

}
