package com.bitstrips.ui
{
   import com.bitstrips.BSConstants;
   import fl.controls.Button;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   
   public class RGBField extends Sprite
   {
      
      public static const CHANGE_EVENT:String = "rgb_change";
       
      
      private var rgb_txt:TextField;
      
      private var set_btn:Button;
      
      private var btn:Sprite;
      
      public function RGBField()
      {
         this.rgb_txt = new TextField();
         this.set_btn = new Button();
         this.btn = new Sprite();
         super();
         this.btn.buttonMode = true;
         this.btn.graphics.lineStyle(2);
         this.btn.graphics.beginFill(16711680);
         this.btn.graphics.drawRect(0,0,38,20);
         this.btn.x = 81;
         this.btn.y = 0;
         this.btn.addEventListener(MouseEvent.CLICK,this.color_change);
         var _loc1_:TextField = new TextField();
         _loc1_.text = "SET";
         BSConstants.tf_fix(_loc1_);
         _loc1_.x = 4;
         _loc1_.y = 1;
         _loc1_.selectable = false;
         _loc1_.mouseEnabled = false;
         this.btn.addChild(_loc1_);
         this.rgb_txt.y = 0;
         this.rgb_txt.type = TextFieldType.INPUT;
         this.rgb_txt.height = 21;
         this.rgb_txt.width = 75;
         this.rgb_txt.background = true;
         this.rgb_txt.border = true;
         this.rgb_txt.maxChars = 7;
         this.rgb_txt.restrict = "a-f A-F 0-9";
         BSConstants.tf_fix(this.rgb_txt);
         this.rgb_txt.addEventListener(Event.CHANGE,this.text_change);
         this.rgb_txt.addEventListener(KeyboardEvent.KEY_UP,this.check_key);
         addChild(this.rgb_txt);
         addChild(this.btn);
      }
      
      private function text_change(param1:Event = null) : void
      {
         if(this.rgb_txt.text.indexOf("#") != 0)
         {
            this.rgb_txt.text = String("#" + this.rgb_txt.text);
         }
         if(this.rgb_txt.text.length > 7)
         {
            this.rgb_txt.text = this.rgb_txt.text.substr(0,7);
         }
         this.rgb_txt.text = this.rgb_txt.text.toUpperCase();
         if(this.rgb_txt.text.length == 7)
         {
            this.valid = true;
         }
         else
         {
            this.valid = false;
         }
      }
      
      public function set color(param1:Number) : void
      {
         this.rgb_txt.text = "#" + ("000000" + param1.toString(16)).substr(-6);
         trace("Colour " + param1 + ", " + this.rgb_txt.text);
         this.text_change();
      }
      
      public function get color() : Number
      {
         return uint("0x" + this.rgb_txt.text.substr(1));
      }
      
      public function color_change(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(RGBField.CHANGE_EVENT));
      }
      
      private function check_key(param1:KeyboardEvent) : void
      {
         var _loc2_:String = null;
         if(param1.keyCode == Keyboard.ENTER)
         {
            _loc2_ = "0x" + this.rgb_txt.text.substr(1);
            if(_loc2_.length == 8)
            {
               this.color_change();
            }
         }
      }
      
      private function set valid(param1:Boolean) : void
      {
         this.btn.graphics.clear();
         if(param1)
         {
            this.btn.graphics.lineStyle(2);
            this.btn.graphics.beginFill(52326);
            this.btn.graphics.drawRect(0,0,38,20);
         }
         else
         {
            this.btn.graphics.lineStyle(2);
            this.btn.graphics.beginFill(16711680);
            this.btn.graphics.drawRect(0,0,38,20);
         }
      }
   }
}
