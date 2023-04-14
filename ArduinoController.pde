import cc.arduino.*;
import processing.serial.*;

public class ArduinoController {
    Arduino arduino;

    public int clock_pin = 14;
    public int bus_pin[] = {2,3,4,5,6,7,8,9};
    public boolean is_read_state = false;

    public ArduinoController(Arduino arduino_obj){
        arduino = arduino_obj;
        arduino.pinMode(clock_pin, arduino.OUTPUT);

        switchToWrite();
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
        arduino.digitalWrite(clock_pin, arduino.HIGH);
        delay(clock_duration);
        arduino.digitalWrite(clock_pin, arduino.LOW);

        setBusToLOW();
    }

    public void switchToRead(){

        println("Switch to read");

        is_read_state = true;

        setBusToINPUT();
        setClockToINPUT();
    }
    public void switchToWrite(){

        println("Swicth to write");

        is_read_state = false;

        setBusToOUTPUT();
        setClockToOUTPUT();
    }
    public void setClockToINPUT(){
        arduino.pinMode(clock_pin, arduino.INPUT);
    }
    public void setClockToOUTPUT(){
        arduino.pinMode(clock_pin, arduino.OUTPUT);
    }
    public void setClockToLOW(){
        arduino.digitalWrite(clock_pin, arduino.LOW);
    }
    public void setClockToHIGH(){
        arduino.digitalWrite(clock_pin, arduino.HIGH);
    }

    public void setBusToLOW(){
        for(int i=0; i<bus_pin.length; i++){
            arduino.digitalWrite(bus_pin[i], arduino.LOW);
        }
    }

    public void setBusToOUTPUT(){
        for(int i=0; i<bus_pin.length; i++){
            arduino.pinMode(bus_pin[i], arduino.OUTPUT);
        }
    }

    public void setBusToINPUT(){
        for(int i=0; i<bus_pin.length; i++){
            arduino.pinMode(bus_pin[i], arduino.INPUT);
        }
    }
    public int[] getBusState(){
        int bus_state[] = {0,0,0,0,0,0,0,0};
        for(int i=0; i<bus_state.length; i++){
            bus_state[i] = arduino.digitalRead(bus_pin[i]);
        }
        return bus_state;
    }
    public int getClockState(){
        return arduino.digitalRead(clock_pin);
    }
}
