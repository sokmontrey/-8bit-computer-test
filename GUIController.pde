import controlP5.*;
import java.util.Arrays;

public class GUIController{
  
  ControlP5 cp5;

  Container[] components = new Container[0];
  
  public GUIController(ControlP5 cp5_obj){
    cp5 = cp5_obj;
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
    public GUIController addComponent(Container new_component){
        int l = components.length;
        Container[] temp_components = Arrays.copyOf(components, l);

        if(l == 0){
            components = new Container[1];
            components[0] = new_component;
        }else{
            components = new Container[l + 1];
            for(int i=0; i<l+1; i++){
                components[i] = temp_components[i];
            }
            components[l] = new_component;
        }

        return this;
    }
}
