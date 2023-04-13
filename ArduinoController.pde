import processing.serial.*;
import cc.arduino.*;

public class ArduinoController{
  Arduino arduino; 
  public ArduinoController(Arduino arduino_object){
    arduino = arduino_object;
  }
}
