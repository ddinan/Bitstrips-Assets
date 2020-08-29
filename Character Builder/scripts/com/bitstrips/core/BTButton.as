package com.bitstrips.core
{
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BTButton extends MovieClip
   {
       
      
      private var _selected:Boolean = false;
      
      private var _enabled:Boolean = false;
      
      private var debug:Boolean = false;
      
      public function BTButton()
      {
         super();
         stop();
         buttonMode = true;
         addEventListener(MouseEvent.ROLL_OVER,over);
         addEventListener(MouseEvent.ROLL_OUT,out);
         addEventListener(MouseEvent.MOUSE_DOWN,down);
         addEventListener(MouseEvent.MOUSE_UP,clicked);
      }
      
      private function clicked(param1:Event) : void
      {
         this.selected = true;
         dispatchEvent(new Event("clicked"));
      }
      
      private function down(param1:Event) : void
      {
         if(debug)
         {
            trace("BT DOWN: " + name);
         }
         if(_selected == false)
         {
            gotoAndStop(3);
            addEventListener(Event.ENTER_FRAME,lbl_check);
         }
      }
      
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      private function out(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("BT Out: " + name + param1);
         }
         if(hitTestPoint(param1.stageX,param1.stageY))
         {
            if(debug)
            {
               trace("\tHittest was true, returning early");
            }
            return;
         }
         if(_selected == false)
         {
            gotoAndStop(1);
            addEventListener(Event.ENTER_FRAME,lbl_check);
         }
      }
      
      public function blah() : void
      {
         if(debug)
         {
            trace("Hi from: " + this);
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(debug)
         {
            trace("Setting selected: " + _selected + " New val: " + param1 + " - " + name);
         }
         _selected = param1;
         if(_selected)
         {
            gotoAndStop(4);
         }
         else
         {
            gotoAndStop(1);
         }
         buttonMode = !_selected;
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      private function over(param1:Event) : void
      {
         if(debug)
         {
            trace("BT - Over: " + name + param1);
         }
         if(_selected == false)
         {
            gotoAndStop(2);
            addEventListener(Event.ENTER_FRAME,lbl_check);
         }
      }
      
      private function lbl_check(param1:Event) : void
      {
         if(this["lbl_txt"])
         {
            BSConstants.tf_fix(this["lbl_txt"]);
            this["lbl_txt"].text = _(this["lbl_txt"].text);
            removeEventListener(Event.ENTER_FRAME,lbl_check);
         }
      }
   }
}
