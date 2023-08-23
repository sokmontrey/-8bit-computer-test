import cc.arduino.*;
import processing.serial.*;

public class ArduinoController {
    Arduino arduino;

    public int clock_pin = 14;
    public int bus_pin[] = {2,3,4,5,6,7,8,9};
    public boolean is_read_state = false;
    public HashMap<String, Integer> other_pin = new HashMap<String, Integer>();
    public boolean is_log = false;

    public ArduinoController(Arduino arduino_obj){
        arduino = arduino_obj;
        arduino.pinMode(clock_pin, Arduino.OUTPUT);
        println("\n\n");
    }
    
    public void addPin(String pin_name, int pin_number){
      if(is_log)
        println("ADD pin: '" + pin_name + "' , pin #n: " + pin_number);
      other_pin.put(pin_name, pin_number);
      arduino.pinMode(pin_number, Arduino.OUTPUT);
    }
    
    public void writePin(String pin_name, int state){
      if(is_log)
        println("WRITE pin: '" + pin_name + "' , state: " + state);
      arduino.pinMode(other_pin.get(pin_name), Arduino.OUTPUT);
      arduino.digitalWrite(other_pin.get(pin_name), state);
    }
    public void pulsePin(String pin_name, int duration){
      arduino.pinMode(other_pin.get(pin_name), Arduino.OUTPUT);
      writePin(pin_name, Arduino.HIGH);
      if(is_log)
        println("PULSE HIGH: " + pin_name);
      delay(duration);
      if(is_log)
        println("PULSE LOW: " + pin_name + ", duraiton: " + duration);
      writePin(pin_name, Arduino.LOW);
    }
    public int readPin(String pin_name){
      arduino.pinMode(other_pin.get(pin_name), Arduino.INPUT);
      int value = arduino.digitalRead(other_pin.get(pin_name));
      if(is_log)
        println("READ pin: " + pin_name + ", value: " + value);
      return value;
    }
    public void setPinMode(String pin_name, int mode){
      if(is_log)
        println("MODE pin: " + pin_name + ", value: " + mode);
      arduino.pinMode(other_pin.get(pin_name), mode);
    }
    public void printPin(String pin_name){
      arduino.pinMode(other_pin.get(pin_name), Arduino.INPUT);
      if(is_log)
        println("Pin: " + arduino.digitalRead(other_pin.get(pin_name)));
    }

    public void pulseBusState(
        int bus_state[], 
        int clock_duration
    ){

        if(clock_duration == 0) 
            clock_duration = 50;

        println("Pulse Bus");

        for(int i=0; i<bus_state.length; i++){
            arduino.digitalWrite(bus_pin[i], bus_state[i]);
        }

        delay(10);
        arduino.digitalWrite(clock_pin, Arduino.HIGH);
        delay(clock_duration);
        arduino.digitalWrite(clock_pin, Arduino.LOW);

        setBusToLOW();
    }
    public void setBusState(int bus_state[]){
        for(int i=0; i<bus_state.length; i++){
            arduino.digitalWrite(bus_pin[i], bus_state[i]);
        }
    }
    public void setBusState(String state){
        if(is_log)
          println("WRITE BUS: " + state);
        setBusToOUTPUT();
        String splited[] = state.split("");
        for(int i=0; i<splited.length; i++){
            arduino.digitalWrite(bus_pin[i],Integer.parseInt(splited[i]));
        }
    }

    public void setBusToLOW(){
        for(int i=0; i<bus_pin.length; i++){
            arduino.digitalWrite(bus_pin[i], Arduino.LOW);
        }
    }

    public void setBusToOUTPUT(){
        for(int i=0; i<bus_pin.length; i++){
            arduino.pinMode(bus_pin[i], Arduino.OUTPUT);
        }
    }

    public void setBusToINPUT(){
        for(int i=0; i<bus_pin.length; i++){
            arduino.pinMode(bus_pin[i], Arduino.INPUT);
        }
    }
    public int[] getBusState(){
        int bus_state[] = {0,0,0,0,0,0,0,0};
        for(int i=0; i<bus_state.length; i++){
            bus_state[i] = arduino.digitalRead(bus_pin[i]);
        }
        return bus_state;
    }
    public void printBusState(){
      setBusToINPUT();
      String result = "";
      for(int i=0; i<bus_state.length; i++){
          result += arduino.digitalRead(bus_pin[i]);
      }
      println(result);
    }
}
