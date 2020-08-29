package com.bitstrips.controls
{
   import com.bitstrips.character.Container;
   import com.bitstrips.character.IBody;
   import com.bitstrips.ui.SlidePane;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ActionPane extends Sprite
   {
       
      
      private var sl:SlidePane;
      
      private var ui:MovieClip;
      
      private var c:Container;
      
      private var _body:IBody;
      
      public var debug:Boolean = false;
      
      public function ActionPane()
      {
         super();
         this.sl = new SlidePane();
         this.sl.setSize(237,85);
         addChild(this.sl);
         this.ui = new sticky_container();
         this.ui.height = 70;
         this.ui.scaleX = this.ui.scaleY;
         this.ui.y = this.ui.y + 90;
         this.sl.set_source(this.ui);
         this.c = new Container([this.ui.s0,this.ui.s1,this.ui.s2,this.ui.s3,this.ui.s4,this.ui.s5,this.ui.s6,this.ui.s7,this.ui.s8,this.ui.s9]);
         this.c.over_updates = false;
         this.c.click_function = this.container_click;
      }
      
      private function container_click(param1:String) : void
      {
         var _loc2_:uint = Math.max(0,Math.floor(Number(param1.substr(1))));
         if(this.debug)
         {
            trace("Hi from: " + String(_loc2_));
         }
         if(this._body)
         {
            this._body.action = _loc2_;
         }
      }
      
      public function set body(param1:IBody) : void
      {
         this._body = param1;
         if(this._body)
         {
            this.c.select(this._body.action);
         }
      }
   }
}
