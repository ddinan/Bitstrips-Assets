package com.bitstrips.controls
{
   import com.bitstrips.character.Container;
   import com.bitstrips.character.IBody;
   import com.bitstrips.ui.SlidePane;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ActionPane extends Sprite
   {
       
      
      private var _body:IBody;
      
      private var c:Container;
      
      private var ui:MovieClip;
      
      private var sl:SlidePane;
      
      public var debug:Boolean = false;
      
      public function ActionPane()
      {
         super();
         sl = new SlidePane();
         sl.setSize(237,85);
         addChild(sl);
         ui = new sticky_container();
         ui.height = 70;
         ui.scaleX = ui.scaleY;
         ui.y = ui.y + 90;
         sl.set_source(ui);
         c = new Container([ui.s0,ui.s1,ui.s2,ui.s3,ui.s4,ui.s5,ui.s6,ui.s7,ui.s8,ui.s9]);
         c.over_updates = false;
         c.click_function = container_click;
      }
      
      public function set body(param1:IBody) : void
      {
         _body = param1;
         if(_body)
         {
            c.select(_body.action);
         }
      }
      
      private function container_click(param1:String) : void
      {
         var _loc2_:uint = Math.max(0,Math.floor(Number(param1.substr(1))));
         if(debug)
         {
            trace("Hi from: " + String(_loc2_));
         }
         if(_body)
         {
            _body.action = _loc2_;
         }
      }
   }
}
