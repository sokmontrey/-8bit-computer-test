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
GUIController gui;
ControlP5 cp5;

int bus_state[] = {0,0,0,0,0,0,0,0};
int clock_state = 0;

void setup(){
    size(600, 300);
    background(bg_color); 

    cp5 = new ControlP5(this);
    gui = new GUIController(cp5);

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
  setupALU();
  
  println("_________START__________");
  delay(1000);
  
  writeA("10000000");
  writeB("00111001");
  
  
  //REG
  
   // writeC("10011100");
   // writeINTS("10111100");

  //RAM
  //ard.writePin("ints_we", 0);
  //ard.writePin("c_oe", 0);
  //ard.writePin("c_we", 0);
  
  //ard.setBusState("10010010");
  //ard.writePin("ints_we", 1);
  
  //writeRAM("00000000", "10100000");
  //writeRAM("00000001", "01100000");
  //writeRAM("00000010", "11100000");
  //writeRAM("00000011", "00010000");
  
  //setRAMAddr("00000000");
}

void setupALU(){
  ard.addOtherPin("reg_we", 10);
  ard.addOtherPin("a_se", 11);
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

void addComponentToGUI(){
    String bus_pin_string = "";
    int bus_pin[] = ard.bus_pin;
    int clock_pin = ard.clock_pin;

    for(int i=0; i<bus_pin.length; i++){
        bus_pin_string += bus_pin[i];
        if(i >= bus_pin.length-1) break;
        bus_pin_string += ",";
    }
    gui.addComponent(
        new Col(2, cp5)
        .setOffset(50,120)
        .addElement(cp5.addLabel("Clock Pin: " + clock_pin))
        .addElement(cp5.addLabel("Bus Pin: " + bus_pin_string))
    );

    gui.addComponent(
        new Col(4, cp5)
        .setOffset(50,250)
        .addElement(cp5.addButton("run_script_button")
            .setLabel("Run Script")
            .onClick(new CallbackListener() {
                public void controlEvent(CallbackEvent theEvent) {
                    script();
                }
            })
        )
        .addElement(cp5.addButton("send_signal_bus_state_button")
            .setLabel("Pulse Bus")
            .onClick(new CallbackListener() {
                public void controlEvent(CallbackEvent theEvent) {
                    ard.pulseBusState(bus_state, 0);
                }
            })
        )
        .addElement(cp5.addButton("bus_state_reset_button")
            .setLabel("Reset")
            .onClick(new CallbackListener() {
                public void controlEvent(CallbackEvent theEvent) {
                    for(int i=0; i<bus_state.length; i++){
                        bus_state[i] = 0;
                    }
                }
            })
        )
        .addElement(cp5.addButton("read_state_button")
            .setLabel("Read State")
            .onClick(new CallbackListener() {
                public void controlEvent(CallbackEvent theEvent) {
                    //if(ard.is_read_state){
                    //    switchToWrite();
                    //}else{
                    //    switchToRead();
                    //}
                }
            })
        )

    );

    gui.render();

    Button button = cp5.get(Button.class, "read_state_button");
    if(ard.is_read_state){
        button.setColorBackground(color(20, 200,100));
    }else{
        button.setColorBackground(panel_color);
    }
}
void draw() {
    background(bg_color);
    gui.draw();

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
