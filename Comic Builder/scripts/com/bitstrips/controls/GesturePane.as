package com.bitstrips.controls
{
   import com.bitstrips.character.Container;
   import com.bitstrips.character.IBody;
   import com.bitstrips.ui.SlidePane;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class GesturePane extends Sprite
   {
       
      
      private var gesture_list:Array;
      
      private var container:Sprite;
      
      private var sl:SlidePane;
      
      private var _body:IBody;
      
      private var c:Container;
      
      public var debug:Boolean = false;
      
      public function GesturePane()
      {
         var _loc2_:MovieClip = null;
         super();
         this.gesture_list = new Array();
         this.container = new Sprite();
         var _loc1_:uint = 0;
         while(_loc1_ < 20)
         {
            _loc2_ = new gesture_man();
            this.container.addChild(_loc2_);
            _loc2_.gotoAndStop(_loc1_ + 1);
            this.gesture_list.push(_loc2_);
            _loc2_.x = _loc1_ * 45;
            _loc2_.y = -40;
            _loc2_.name = String(_loc1_);
            _loc2_.height = 75;
            _loc2_.scaleX = _loc2_.scaleY;
            _loc1_ = _loc1_ + 1;
         }
         this.c = new Container(this.gesture_list);
         this.c.over_updates = false;
         this.c.click_function = this.container_click;
         this.sl = new SlidePane();
         this.sl.setSize(237,85);
         addChild(this.sl);
         this.sl.set_source(this.container);
      }
      
      private function container_click(param1:String) : void
      {
         var _loc2_:int = Math.floor(Number(param1));
         if(this.debug)
         {
            trace("Hi from: " + String(_loc2_));
         }
         if(this._body)
         {
            this._body.gesture = _loc2_;
         }
      }
      
      public function go_to_gesture(param1:uint) : void
      {
         var _loc2_:int = Math.min(Math.max(0,param1 - 3),20);
         this.sl.go_to_x(_loc2_ * 45);
         this.c.select(param1);
      }
      
      public function set body(param1:IBody) : void
      {
         this._body = param1;
         if(this._body)
         {
            this.go_to_gesture(this._body.gesture);
         }
      }
   }
}
