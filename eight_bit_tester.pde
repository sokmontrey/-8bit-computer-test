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
void writeRam(String addr, String data){
  ard.setBusState(addr);
  ard.writePin("addr_reg_we", 1);
  ard.pulsePin("clk", 100);
  ard.writePin("addr_reg_we", 0);
  
  delay(100);
  
  ard.setBusState(data);
  ard.writePin("ram_we", 1);
  ard.pulsePin("clk", 100);
  ard.writePin("ram_we", 0);
  
  delay(100);
}
  
void script(){
  println("_________SETUP__________");
  
  ard.addPin("clk", 14);
  ard.setBusState("00000000");
  ard.addPin("addr_reg_we", 10);
  ard.addPin("ram_we", 11);
  
  println("Wait 3s");
  delay(1000);
  println("Wait 2s");
  delay(1000);
  println("Wait 1s");
  delay(1000);
  
  //writeRam("00000000", "01010101");
  //writeRam("11111111", "01110111");
  //writeRam("00000001", "00000010");
  //writeRam("00000010", "10101010");
  //ard.setBusState("00000000");
  
  //ard.setPinMode("addr_reg_we", 1);
  //ard.setPinMode("ram_we", 1);
  //ard.setPinMode("clk", 1);
  //ard.setBusToINPUT();
  
  ard.setBusState("00000001");
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
