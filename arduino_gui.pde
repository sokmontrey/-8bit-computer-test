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
  
  ard.addOtherPin("clock", 14);
  ard.setBusState("00000000");
  
  //setupRAM();
  ard.readPin("clock");
  ard.addOtherPin("addr_we", 10);
  ard.addOtherPin("ram_we", 11);
  ard.addOtherPin("ram_oe", 12);
  
  ard.addOtherPin("a_se", 13);
  ard.addOtherPin("reg_we", 15);
  
  ard.addOtherPin("alu_oe", 16);
  ard.addOtherPin("sub_en", 17);
  ard.addOtherPin("flg_en", 18);
  
  println("_________START__________");
  delay(2000);
  
  //LOAD A with 0
  
  ard.setBusState("00000001");
  ard.writePin("a_se", 1);
  ard.writePin("reg_we", 1);
  ard.pulsePin("clock", 100);
  ard.writePin("a_se", 0);
  ard.writePin("reg_we", 0);
  
  //LOAD B with 1
  
  ard.setBusState("00000000");
  ard.setBusToINPUT();
  ard.writePin("reg_we", 1);
  ard.pulsePin("clock", 100);
  ard.writePin("reg_we", 0);
  
  for(int i=0; i<255; i++){
    
    ard.writePin("ram_we", 1);
    ard.writePin("alu_oe", 1);
    //ard.writePin("a_se", 1);
    ard.writePin("reg_we", 1);
    ard.writePin("addr_we", 1);
    ard.pulsePin("clock", 0);
    ard.writePin("ram_we", 0);
    ard.writePin("alu_oe", 0);
    ard.writePin("a_se", 0);
    ard.writePin("reg_we", 0);
    ard.writePin("addr_we", 0);
  }
  
  ////RAM 0
  
  //ard.setBusState("00000000");
  //ard.setBusToINPUT();
  //ard.writePin("addr_we", 1);
  //ard.pulsePin("clock", 10);
  //ard.writePin("addr_we", 0);
  
  //ard.setBusState("00001111");
  //ard.setBusToINPUT();
  //ard.writePin("ram_we", 1);
  //ard.writePin("ram_we", 0);
  
  ////RAM 1
  
  //ard.setBusState("00000001");
  //ard.setBusToINPUT();
  //ard.writePin("addr_we", 1);
  //ard.pulsePin("clock", 10);
  //ard.writePin("addr_we", 0);
  
  //ard.setBusState("00000101");
  //ard.setBusToINPUT();
  //ard.writePin("ram_we", 1);
  //ard.writePin("ram_we", 0);
  
  ////LOAD A
  //ard.setBusState("00000000");
  //ard.setBusToINPUT();
  //ard.writePin("addr_we", 1);
  //ard.pulsePin("clock", 10);
  //ard.writePin("addr_we", 0);
  
  //ard.writePin("ram_oe", 1);
  //ard.writePin("a_se", 1);
  //ard.writePin("reg_we", 1);
  //ard.pulsePin("clock", 10);
  //ard.writePin("ram_oe", 0);
  //ard.writePin("a_se", 0);
  //ard.writePin("reg_we", 0);
  
  ////LOAD B
  //ard.setBusState("00000001");
  //ard.setBusToINPUT();
  //ard.writePin("addr_we", 1);
  //ard.pulsePin("clock", 10);
  //ard.writePin("addr_we", 0);
  
  //ard.writePin("ram_oe", 1);
  //ard.writePin("a_se", 0);
  //ard.writePin("reg_we", 1);
  //ard.pulsePin("clock", 10);
  //ard.writePin("ram_oe", 0);
  //ard.writePin("a_se", 0);
  //ard.writePin("reg_we", 0);
  
  ////SUB EN
  
  //ard.writePin("sub_en", 1);
  //ard.writePin("alu_oe", 1);
  //ard.writePin("a_se", 1);
  //ard.writePin("reg_we", 1);
  //ard.writePin("flg_en", 1);
  //ard.pulsePin("clock", 10);
  //ard.writePin("sub_en", 0);
  //ard.writePin("alu_oe", 0);
  //ard.writePin("a_se", 0);
  //ard.writePin("reg_we", 0);
  //ard.writePin("sub_en", 1);
  //ard.writePin("alu_oe", 1);
  //ard.writePin("a_se", 1);
  //ard.writePin("reg_we", 1);
  //ard.writePin("flg_en", 1);
  //ard.pulsePin("clock", 10);
  //ard.writePin("sub_en", 0);
  //ard.writePin("alu_oe", 0);
  //ard.writePin("a_se", 0);
  //ard.writePin("reg_we", 0);
  //ard.writePin("sub_en", 1);
  //ard.writePin("alu_oe", 1);
  //ard.writePin("a_se", 1);
  //ard.writePin("reg_we", 1);
  //ard.writePin("flg_en", 1);
  //ard.pulsePin("clock", 10);
  //ard.writePin("sub_en", 0);
  //ard.writePin("alu_oe", 0);
  //ard.writePin("a_se", 0);
  //ard.writePin("reg_we", 0);
}

void setupALU(){
  ard.addOtherPin("reg_we", 10);
  ard.addOtherPin("a_se", 11);
  ard.addOtherPin("alu_oe", 12);
  ard.addOtherPin("flg_en", 13);
}

void writeA(String value){
  ard.writePin("a_se", 1);
  ard.writePin("reg_we", 1);
  
  ard.setBusState(value);
  
  ard.pulsePin("clock", 100);
  ard.writePin("reg_we", 0);
  ard.writePin("a_se", 0);
}
void writeB(String value){
  ard.writePin("a_se", 0);
  ard.writePin("reg_we", 1);
  
  ard.setBusState(value);
  
  ard.pulsePin("clock", 100);
  ard.writePin("reg_we", 0);
  ard.writePin("a_se", 0);
}

void writeC(String value){
  ard.writePin("c_oe", 0);
  ard.writePin("c_we", 1);
  
  ard.setBusState(value);
  ard.pulsePin("clock", 100);
  ard.writePin("c_we", 0);
}
void writeINTS(String value){
  ard.writePin("ints_we", 1);
  
  ard.setBusState(value);
  ard.pulsePin("clock", 100);
  ard.writePin("ints_we", 0);
}

void setupREG(){
  ard.addOtherPin("ints_we", 10);
  ard.addOtherPin("c_we", 11);
  ard.addOtherPin("c_oe", 12);
}

void setupRAM(){
  ard.addOtherPin("ram_we", 11);
  ard.addOtherPin("ram_oe", 12);
  ard.addOtherPin("addr_we", 10);
}

void writeRAM(String addr, String value){
  setRAMAddr(addr);
  
  ard.setBusState(value);
  ard.writePin("ram_we", 1);
  ard.writePin("addr_we", 0);
  ard.pulsePin("clock", 10);
  ard.writePin("ram_we", 0);
}
void setRAMAddr(String addr){
  ard.writePin("ram_oe", 0);
  ard.writePin("ram_we", 0);
  ard.writePin("addr_we", 1);
  ard.setBusState(addr);
  ard.pulsePin("clock", 10);
  ard.writePin("addr_we", 0);
}

void readRAM(String addr){
  setRAMAddr(addr);
  ard.writePin("ram_oe", 1);
  ard.writePin("addr_we", 0);
  ard.printBusState();
  ard.writePin("ram_oe", 0);
}

//void switchToWrite(){
//    Button button = cp5.get(Button.class, "read_state_button");
//    ard.switchBusToWrite();
//    button.setColorBackground(panel_color);
//}
//void switchToRead(){
//    Button button = cp5.get(Button.class, "read_state_button");
//    ard.switchBusToRead();
//    button.setColorBackground(color(20, 200,100));
//}

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
