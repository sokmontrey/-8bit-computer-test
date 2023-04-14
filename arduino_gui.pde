import controlP5.*;
import processing.serial.*;
import cc.arduino.*;
import java.util.Arrays;

color bg_color = color(36, 33, 33);
color panel_color = color(66, 64, 64);
color font_color = color(214, 214, 177);
color accent_color = color(244, 93, 1);

Arduino arduino;
GUIController gui;
ControlP5 cp5;

int bus_state[] = {0,0,0,0,0,0,0,0};
int clock_pin = 10;
int bus_pin[] = {2,3,4,5,6,7,8,9};
boolean is_read_state = false;

void setup(){
  size(1280, 720);
  background(bg_color); 
  
  cp5 = new ControlP5(this);
  gui = new GUIController(cp5);

  addComponentToGUI();

    if(Arduino.list().length > 0)
        arduino = new Arduino(this, Arduino.list()[0], 57600);
    

    arduino.pinMode(clock_pin, arduino.OUTPUT);

    switchToRead();
}
void script(){
    switchToWrite();

//TODO: render each step
    write("00000001");
    write("01000101");
    write("01110110");
    write("00000010");
    write("00000100");
    write("00001000");
    write("00010000");
    write("00100000");
    write("01000000");
    write("10000000");
}
void write(String state){
    println("Write: " + state);
    changeBusStateFromString(state);

    sendSignal();

    delay(500);
}

void addComponentToGUI(){
    String bus_pin_string = "";
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
        .setOffset(320,120)
        .addElement(cp5.addButton("run_script_button")
            .setLabel("Run Script")
            .onClick(new CallbackListener() {
                public void controlEvent(CallbackEvent theEvent) {
                    script();
                }
            })
        )
        .addElement(cp5.addButton("send_signal_bus_state_button")
            .setLabel("Send Signal")
            .onClick(new CallbackListener() {
                public void controlEvent(CallbackEvent theEvent) {
                    sendSignal();
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
                    if(is_read_state)
                        switchToWrite();
                    else
                        switchToRead();
                }
            })
        )

    );

    gui.render();
}
void switchToRead(){
    println("Switch to read");

    is_read_state = true;

    setBusToINPUT();
    cp5.get(Button.class, "read_state_button")
        .setColorBackground(color(20, 200, 100));
}
void switchToWrite(){

    println("Swicth to write");

    is_read_state = false;

    setBusToOUTPUT();
    cp5.get(Button.class, "read_state_button")
        .setColorBackground(panel_color);
}

void setBusToLOW(){
    for(int i=0; i<bus_pin.length; i++){
        arduino.digitalWrite(bus_pin[i], arduino.LOW);
    }
}

void setBusToOUTPUT(){
    for(int i=0; i<bus_pin.length; i++){
        arduino.pinMode(bus_pin[i], arduino.OUTPUT);
    }
}

void setBusToINPUT(){
    for(int i=0; i<bus_pin.length; i++){
        arduino.pinMode(bus_pin[i], arduino.INPUT);
    }
}

void sendSignal(){

    println("Send Signal");

    for(int i=0; i<bus_state.length; i++){
        arduino.digitalWrite(bus_pin[i], bus_state[i]);
    }
    delay(100);
    arduino.digitalWrite(clock_pin, arduino.HIGH);
    delay(100);
    arduino.digitalWrite(clock_pin, arduino.LOW);

    setBusToLOW();
}
void draw() {
    background(bg_color);
    gui.draw();

    checkBusStateHover();
    if(is_read_state)
        changeBusStateFromArduino();

    drawBusState();
    stroke(panel_color);
    fill(panel_color);
}

void changeBusStateFromArduino(){
    for(int i=0; i<bus_state.length; i++){
        bus_state[i] = arduino.digitalRead(bus_pin[i]);
    }
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

void checkBusStateHover(){
    for(int i=0; i<bus_state.length; i++){
        int start = bus_state_x + bus_state_padding * i + i * bus_state_side ;

        if(mouseY < bus_state_y || mouseY > bus_state_y + bus_state_side) continue;

        if(mouseX < start) continue;
        if(mouseX > start + bus_state_side) continue;

        fill(font_color);
        rect(start, bus_state_y, bus_state_side, bus_state_side);
    }
    // fill(panel_color);
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
