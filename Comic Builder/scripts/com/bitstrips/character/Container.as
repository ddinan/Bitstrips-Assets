package com.bitstrips.character
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   
   public class Container
   {
       
      
      private var colours:Object;
      
      private var clip_list:Array;
      
      private var debug:Boolean = false;
      
      private var _enabled:Boolean = true;
      
      public var click_function:Function = null;
      
      public var down_function:Function = null;
      
      public var over_updates:Boolean = true;
      
      public var fx:Boolean = true;
      
      private var glow:GlowFilter;
      
      public function Container(param1:Array)
      {
         var _loc2_:* = null;
         this.colours = new Object();
         super();
         this.colours["over"] = 16763904;
         this.colours["out"] = 16777215;
         this.colours["down"] = 16763904;
         this.colours["up"] = 16777062;
         this.glow = new GlowFilter();
         this.glow.strength = 255;
         this.glow.quality = 1;
         this.glow.blurX = 2;
         this.glow.blurY = 2;
         this.glow.color = 52479;
         for(_loc2_ in param1)
         {
            this.setup(param1[_loc2_]);
         }
         this.clip_list = param1;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
         var _loc2_:uint = 0;
         while(_loc2_ < this.clip_list.length)
         {
            this.clip_list[_loc2_].mouseEnabled = this.clip_list[_loc2_].mouseChildren = this.clip_list[_loc2_].buttonMode = param1;
            _loc2_ = _loc2_ + 1;
         }
      }
      
      public function get_selected() : uint
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.clip_list.length)
         {
            if(this.clip_list[_loc1_].selected == "true")
            {
               return _loc1_;
            }
            _loc1_ = _loc1_ + 1;
         }
         return 0;
      }
      
      public function highlight(param1:uint) : void
      {
         if(this.debug)
         {
            trace("Highlight: " + param1);
         }
         if(param1 < 0 || param1 >= this.clip_list.length)
         {
            return;
         }
         if(this.clip_list[param1].selected == false)
         {
            if(this.fx)
            {
               this.clip_list[param1].transform.colorTransform = this.get_c("over");
            }
         }
      }
      
      public function de_light(param1:uint) : void
      {
         if(param1 < 0 || param1 >= this.clip_list.length)
         {
            return;
         }
         if(this.clip_list[param1].selected == false)
         {
            if(this.fx)
            {
               this.clip_list[param1].transform.colorTransform = this.get_c("out");
            }
         }
      }
      
      public function select(param1:*) : void
      {
         var _loc2_:* = null;
         if(this.clip_list == null)
         {
            return;
         }
         if(this.debug)
         {
            trace("Container.select()" + " " + param1);
         }
         this.deselect();
         if(param1 is uint)
         {
            if(param1 < 0 || param1 >= this.clip_list.length)
            {
               return;
            }
            this.clip_list[param1].selected = true;
            if(this.fx)
            {
               this.clip_list[param1].transform.colorTransform = this.get_c("up");
            }
         }
         else
         {
            for(_loc2_ in this.clip_list)
            {
               if(this.clip_list[_loc2_].name == param1)
               {
                  this.clip_list[_loc2_].selected = true;
                  if(this.fx)
                  {
                     this.clip_list[_loc2_].transform.colorTransform = this.get_c("up");
                  }
                  break;
               }
            }
         }
      }
      
      public function hide() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this.clip_list)
         {
            this.clip_list[_loc1_].visible = false;
         }
      }
      
      public function show() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this.clip_list)
         {
            this.clip_list[_loc1_].visible = true;
         }
      }
      
      private function setup(param1:MovieClip) : void
      {
         param1.buttonMode = true;
         param1.addEventListener(MouseEvent.ROLL_OVER,this.over);
         param1.addEventListener(MouseEvent.ROLL_OUT,this.out);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.up);
         param1.selected = false;
      }
      
      private function get_c(param1:String) : ColorTransform
      {
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = this.colours[param1];
         _loc2_.redOffset = _loc2_.redOffset + -255;
         _loc2_.greenOffset = _loc2_.greenOffset + -255;
         _loc2_.blueOffset = _loc2_.blueOffset + -255;
         _loc2_.redMultiplier = 1;
         _loc2_.greenMultiplier = 1;
         _loc2_.blueMultiplier = 1;
         return _loc2_;
      }
      
      private function over(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         if(this.debug)
         {
            trace("Over: " + _loc2_.name + " - " + param1.eventPhase);
         }
         if(this.fx)
         {
            _loc2_.transform.colorTransform = this.get_c("over");
         }
         if(this.click_function != null && this.over_updates)
         {
            this.click_function(_loc2_.name);
         }
      }
      
      private function out(param1:MouseEvent) : void
      {
         var _loc3_:* = null;
         var _loc2_:Object = param1.currentTarget;
         if(this.debug)
         {
            trace("Off: " + _loc2_.name + " " + this.fx);
         }
         if(_loc2_.selected)
         {
            if(this.debug)
            {
               trace("\t Selected, so setting \"up\" state");
            }
            if(this.fx)
            {
               _loc2_.transform.colorTransform = this.get_c("up");
            }
         }
         else
         {
            if(this.fx)
            {
               _loc2_.transform.colorTransform = this.get_c("out");
            }
            for(_loc3_ in this.clip_list)
            {
               if(this.clip_list[_loc3_].selected == true && this.click_function != null && this.over_updates)
               {
                  this.click_function(this.clip_list[_loc3_].name);
               }
            }
         }
      }
      
      private function down(param1:MouseEvent) : void
      {
         if(this.debug)
         {
            trace("Container.down()");
         }
         var _loc2_:Object = param1.currentTarget;
         if(this.debug)
         {
            trace("Down: " + _loc2_.name);
         }
         if(this.fx)
         {
            _loc2_.transform.colorTransform = this.get_c("down");
         }
      }
      
      public function deselect() : void
      {
         var _loc1_:* = null;
         if(this.debug)
         {
            trace("Container.deselect()");
         }
         for(_loc1_ in this.clip_list)
         {
            this.clip_list[_loc1_].selected = false;
            if(this.fx)
            {
               this.clip_list[_loc1_].transform.colorTransform = this.get_c("out");
               this.clip_list[_loc1_].filters = new Array();
            }
         }
      }
      
      private function up(param1:MouseEvent) : void
      {
         if(this.debug)
         {
            trace("Container.up()");
         }
         var _loc2_:Object = param1.currentTarget;
         if(this.debug)
         {
            trace("\tUp: " + _loc2_.name);
         }
         this.deselect();
         if(this.fx)
         {
            _loc2_.transform.colorTransform = this.get_c("up");
         }
         _loc2_.selected = true;
         var _loc3_:Array = new Array(this.glow);
         if(this.fx)
         {
            _loc2_.filters = _loc3_;
         }
         if(this.click_function != null)
         {
            this.click_function(_loc2_.name);
         }
         if(this.down_function != null)
         {
            this.down_function(_loc2_.name);
         }
      }
   }
}
