import controlP5.*;
import processing.serial.*;
import cc.arduino.*;
import java.util.Arrays;

color bg_color = color(36, 33, 33);
color panel_color = color(66, 64, 64);
color font_color = color(214, 214, 177);
color accent_color = color(244, 93, 1);

ArduinoController ard;
GUIController gui;
ControlP5 cp5;

int bus_state[] = {0,0,0,0,0,0,0,0};

void setup(){
  size(1280, 720);
  background(bg_color); 
  
  cp5 = new ControlP5(this);
  gui = new GUIController(cp5);

    gui.addComponent(
        new Row(2, cp5)
        .setOffset(50,50)
        .addElement(cp5.addTextfield("bus_pin_textfield")
            .setLabel("")
            .setValue("2,3,4,5,6,7,8,9")
            .setWidth(100)
        )
        .addElement(cp5.addButton("bus_pin_restart")
            .setLabel("Change")
        )
    );

    // ard = new ArduinoController(new Arduino(this, Arduino.list()[0], 57600));
    gui.render();
}


void draw() {
    background(bg_color);
    gui.draw();

    int padding = 10;
    int side = 40;
    for(int i=0; i<bus_state.length; i++){
        int start = 50 + padding * i + i * side ;
        rect(start, 200, side, side );
        fill(panel_color);
    }
}
