import controlP5.*;
import processing.serial.*;
import cc.arduino.*;
import java.util.Arrays;

color bg_color = color(36, 33, 33);
color panel_color = color(66, 64, 64);
color font_color = color(214, 214, 177);
color accent_color = color(244, 93, 1);

Arduino arduino;
ArduinoController ard;
ControlP5 cp5;

int bus_state[] = {0,0,0,0,0,0,0,0};
int clock_state = 0;

void setup(){
    size(600, 300);
    background(bg_color); 

    cp5 = new ControlP5(this);

    arduino = new Arduino(this, Arduino.list()[0], 57600);
    ard = new ArduinoController(arduino);

    //addComponentToGUI();
    script();
}

void script(){
  println("_________SETUP__________");
  
  ard.addPin("clock", 14);
  ard.setBusState("00000000");
  
  println("_________START__________");
  delay(2000);
  
  ShiftController shft = new ShiftController(ard, 10, 11);
  shft.addPin("a", 9);
  shft.addPin("b", 10);
  shft.addPin("c", 11);
  
  shft.setPin("a", 1);
  shft.setPin("b", 0);
  shft.setPin("c", 0);
  shft.pushState();
  
  delay(1000);
  
  shft.setPin("a", 0);
  shft.setPin("b", 1);
  shft.setPin("c", 0);
  shft.pushState();
  
  delay(1000);
  
  shft.setPin("a", 0);
  shft.setPin("b", 0);
  shft.setPin("c", 1);
  shft.pushState();
  
  delay(1000);
  
  shft.setPin("a", 1);
  shft.setPin("b", 1);
  shft.setPin("c", 1);
  shft.pushState();
  
  delay(1000);
}

void draw() {
    background(bg_color);

    changeBusStateFromArduino();

    drawBusState();

    stroke(panel_color);
    fill(panel_color);
}

void changeBusStateFromArduino(){
    bus_state = ard.getBusState();
}
void changeBusStateFromString(String value){
    String splited[] = value.split("");
    for(int i=0; i<splited.length; i++){
        bus_state[i] = Integer.parseInt(splited[i]);
    }
}

int bus_state_x = 50,
    bus_state_y = 50,
    bus_state_padding = 10,
    bus_state_side = 40;

void drawBusState(){
    for(int i=0; i<bus_state.length; i++){
        int start = bus_state_x + bus_state_padding * i + i * bus_state_side ;
        if(bus_state[i] == 1){
            fill(50, 180, 90);
        } else {
            fill(panel_color);
        }
        rect(start, bus_state_y, bus_state_side, bus_state_side );
    }
}
void checkMouseClickedBusState(){
    for(int i=0; i<bus_state.length; i++){
        int start = bus_state_x + bus_state_padding * i + i * bus_state_side ;

        if(mouseY < bus_state_y || mouseY > bus_state_y + bus_state_side) continue;

        if(mouseX < start) continue;
        if(mouseX > start + bus_state_side) continue;

        fill(20, 200, 100);
        rect(start, bus_state_y, bus_state_side, bus_state_side);

        if(bus_state[i] == 1){
            bus_state[i] =0;
        }else{
            bus_state[i] =1;
        }
        fill(panel_color);
    }
}

void mouseClicked(){
    checkMouseClickedBusState();
}
