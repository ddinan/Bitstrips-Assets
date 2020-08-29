package com.bitstrips.controls
{
   import com.bitstrips.character.Container;
   import com.bitstrips.character.IBody;
   import com.bitstrips.ui.SlidePane;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class GesturePane extends Sprite
   {
       
      
      private var _body:IBody;
      
      private var c:Container;
      
      private var container:Sprite;
      
      public var debug:Boolean = false;
      
      private var gesture_list:Array;
      
      private var sl:SlidePane;
      
      public function GesturePane()
      {
         var _loc2_:MovieClip = null;
         super();
         gesture_list = new Array();
         container = new Sprite();
         var _loc1_:uint = 0;
         while(_loc1_ < 20)
         {
            _loc2_ = new gesture_man();
            container.addChild(_loc2_);
            _loc2_.gotoAndStop(_loc1_ + 1);
            gesture_list.push(_loc2_);
            _loc2_.x = _loc1_ * 45;
            _loc2_.y = -40;
            _loc2_.name = String(_loc1_);
            _loc2_.height = 75;
            _loc2_.scaleX = _loc2_.scaleY;
            _loc1_ = _loc1_ + 1;
         }
         c = new Container(gesture_list);
         c.over_updates = false;
         c.click_function = container_click;
         sl = new SlidePane();
         sl.setSize(237,85);
         addChild(sl);
         sl.set_source(container);
      }
      
      public function set body(param1:IBody) : void
      {
         _body = param1;
         if(_body)
         {
            go_to_gesture(_body.gesture);
         }
      }
      
      private function container_click(param1:String) : void
      {
         var _loc2_:int = Math.floor(Number(param1));
         if(debug)
         {
            trace("Hi from: " + String(_loc2_));
         }
         if(_body)
         {
            _body.gesture = _loc2_;
         }
      }
      
      public function go_to_gesture(param1:uint) : void
      {
         var _loc2_:int = Math.min(Math.max(0,param1 - 3),20);
         sl.go_to_x(_loc2_ * 45);
         c.select(param1);
      }
   }
}
