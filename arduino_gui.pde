import controlP5.*;
import processing.serial.*;
import cc.arduino.*;

color bg_color = color(36, 33, 33);
color panel_color = color(66, 64, 64);
color font_color = color(214, 214, 177);
color accent_color = color(244, 93, 1);

class Container{
  public Controller[] elements;
  
  float scaling_size_factor = 1.4;
  PFont font = createFont("arial", 20);
  color bg_color = color(86, 84, 84);
  color fg_color = color(244, 93, 1);
  color font_color = color(214, 214, 177);
  
  public int offset_x = 0, 
      offset_y = 0,
      padding = 20;
      
  private ControlP5 cp5;
  
  public int total_w = 0,
             total_h = 0;
  
  public Container(int total_num_element, ControlP5 cp5_object){
    elements = new Controller[total_num_element];
    cp5 = cp5_object;
  }
  
  int count = 0;
  public Container addElement(Controller element){
    if(count >= elements.length) return this;
    elements[count] = element;
    count +=1;
    return this;
  }
  
  public Container setOffset(int x,int y){
    offset_x = x;
    offset_y = y;
    return this;  
  }
  
  public Container setPadding(int new_padding){
    padding = new_padding;
    return this;
  }
  
  public Container render(){
    return this;
  }
  protected void afterRender(){
      
  }
  
  public Container setScalingFactor(int new_scaling_factor){
    scaling_size_factor = new_scaling_factor;
    return this;
  }
  public Container setFont(PFont new_value){
    font = new_value;
    return this;
  }
  public Container setBackgroundColor(color new_value){
    bg_color = new_value;
    return this;
  }
  public Container setForegroundColor(color new_value){
    fg_color = new_value;
    return this;
  }
  public Container setFontColor(color new_value){
    font_color = new_value;
    return this;
  }
  
  protected void modify(){
    for(Controller element : elements){
      int w = element.getWidth(),
          h = element.getHeight();
      
      int new_w = (int)(w * scaling_size_factor),
          new_h = (int)(h * scaling_size_factor);
          
      element.setSize(new_w, new_h);
      element.setFont(font);
      element.setColorBackground(bg_color);
      element.setColorForeground(fg_color);
      element.setColorLabel(font_color);
    }
  }
}

class Row extends Container{
  
  public Row(int total_num_element, ControlP5 cp5){
    super(total_num_element, cp5);
  }
  
  public Container render(){
    
    modify();
    
    int last_x = padding;
    
    total_w = padding;
    int max_height = 0;
    
    for(Controller ele : elements){
      ele.setPosition(last_x + offset_x, offset_y + padding);
      last_x += ele.getWidth() + padding;
      
      total_w += ele.getWidth() + padding;
      max_height = max(max_height, ele.getHeight());
    }
    total_h = padding * 2 + max_height;
    
    afterRender();
    
    return this;
  }
}


class Col extends Container{
  
  public Col(int total_num_element, ControlP5 cp5){
    super(total_num_element, cp5);
  }
  
  public Container render(){
    
    modify();
    
    int last_y = padding;
    
    total_h = padding;
    int max_width = 0;
    
    for(Controller ele : elements){
      ele.setPosition(offset_x + padding, offset_y + last_y);
      last_y += ele.getHeight() + padding;
      
      total_h += ele.getHeight() + padding;
      max_width = max(max_width, ele.getWidth());
    }
    total_w = padding * 2 + max_width;
    
    afterRender();
    
    return this;
  }
}

class ArduinoController{
  Arduino arduino; 
  public ArduinoController(Arduino arduino_object){
    arduino = arduino_object;
  }
}

class GUIController{
  
  ControlP5 cp5;

  Container[] components;
  
  public GUIController(ControlP5 cp5_obj){
    cp5 = cp5_obj;
    
    
    Container temp_components[] = {
      new Col(3, cp5)
      .setOffset(50,50)
      .addElement(cp5.addButton("b1"))
      .addElement(cp5.addButton("b2"))
      .addElement(cp5.addTextfield("Bus pins").setValue("2,3,4,5,6,7,8,9"))
    };
    
    components = new Container[temp_components.length];
    components = temp_components;
    
    render();
  }
  
  public void draw(){
    for(Container component : components){
      rect(component.offset_x, component.offset_y, component.total_w, component.total_h);
    }
    color _panel_color = panel_color;
    fill(_panel_color);
  }
  
  public void render(){
    for(Container component : components){
      component.render();
    }
  }
}

ArduinoController ard;
GUIController gui;

void setup(){
  size(1280, 720);
  background(bg_color); 
  
  gui = new GUIController(new ControlP5(this));
  ard = new ArduinoController(new Arduino(this, Arduino.list()[0], 57600));
  gui.render();
}


void draw() {
  background(bg_color);
  gui.draw();
}
