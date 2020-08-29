package com.bitstrips.character
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   
   public class Container
   {
       
      
      private var _enabled:Boolean = true;
      
      private var glow:GlowFilter;
      
      public var fx:Boolean = true;
      
      private var debug:Boolean = false;
      
      public var down_function:Function = null;
      
      public var over_updates:Boolean = true;
      
      private var colours:Object;
      
      private var clip_list:Array;
      
      public var click_function:Function = null;
      
      public function Container(param1:Array)
      {
         var _loc2_:* = null;
         colours = new Object();
         super();
         colours["over"] = 16763904;
         colours["out"] = 16777215;
         colours["down"] = 16763904;
         colours["up"] = 16777062;
         glow = new GlowFilter();
         glow.strength = 255;
         glow.quality = 1;
         glow.blurX = 2;
         glow.blurY = 2;
         glow.color = 52479;
         for(_loc2_ in param1)
         {
            setup(param1[_loc2_]);
         }
         clip_list = param1;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         _enabled = param1;
         var _loc2_:uint = 0;
         while(_loc2_ < clip_list.length)
         {
            clip_list[_loc2_].mouseEnabled = clip_list[_loc2_].mouseChildren = clip_list[_loc2_].buttonMode = param1;
            _loc2_ = _loc2_ + 1;
         }
      }
      
      private function setup(param1:MovieClip) : void
      {
         param1.buttonMode = true;
         param1.addEventListener(MouseEvent.ROLL_OVER,over);
         param1.addEventListener(MouseEvent.ROLL_OUT,out);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,up);
         param1.selected = false;
      }
      
      public function hide() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in clip_list)
         {
            clip_list[_loc1_].visible = false;
         }
      }
      
      private function over(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         if(debug)
         {
            trace("Over: " + _loc2_.name + " - " + param1.eventPhase);
         }
         if(fx)
         {
            _loc2_.transform.colorTransform = get_c("over");
         }
         if(click_function != null && over_updates)
         {
            click_function(_loc2_.name);
         }
      }
      
      public function de_light(param1:uint) : void
      {
         if(param1 < 0 || param1 >= clip_list.length)
         {
            return;
         }
         if(clip_list[param1].selected == false)
         {
            if(fx)
            {
               clip_list[param1].transform.colorTransform = get_c("out");
            }
         }
      }
      
      private function up(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("Container.up()");
         }
         var _loc2_:Object = param1.currentTarget;
         if(debug)
         {
            trace("\tUp: " + _loc2_.name);
         }
         deselect();
         if(fx)
         {
            _loc2_.transform.colorTransform = get_c("up");
         }
         _loc2_.selected = true;
         var _loc3_:Array = new Array(glow);
         if(fx)
         {
            _loc2_.filters = _loc3_;
         }
         if(click_function != null)
         {
            click_function(_loc2_.name);
         }
         if(down_function != null)
         {
            down_function(_loc2_.name);
         }
      }
      
      private function out(param1:MouseEvent) : void
      {
         var _loc3_:* = null;
         var _loc2_:Object = param1.currentTarget;
         if(debug)
         {
            trace("Off: " + _loc2_.name + " " + fx);
         }
         if(_loc2_.selected)
         {
            if(debug)
            {
               trace("\t Selected, so setting \"up\" state");
            }
            if(fx)
            {
               _loc2_.transform.colorTransform = get_c("up");
            }
         }
         else
         {
            if(fx)
            {
               _loc2_.transform.colorTransform = get_c("out");
            }
            for(_loc3_ in clip_list)
            {
               if(clip_list[_loc3_].selected == true && click_function != null && over_updates)
               {
                  click_function(clip_list[_loc3_].name);
               }
            }
         }
      }
      
      private function down(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("Container.down()");
         }
         var _loc2_:Object = param1.currentTarget;
         if(debug)
         {
            trace("Down: " + _loc2_.name);
         }
         if(fx)
         {
            _loc2_.transform.colorTransform = get_c("down");
         }
      }
      
      public function get_selected() : uint
      {
         var _loc1_:uint = 0;
         while(_loc1_ < clip_list.length)
         {
            if(clip_list[_loc1_].selected == "true")
            {
               return _loc1_;
            }
            _loc1_ = _loc1_ + 1;
         }
         return 0;
      }
      
      public function highlight(param1:uint) : void
      {
         if(debug)
         {
            trace("Highlight: " + param1);
         }
         if(param1 < 0 || param1 >= clip_list.length)
         {
            return;
         }
         if(clip_list[param1].selected == false)
         {
            if(fx)
            {
               clip_list[param1].transform.colorTransform = get_c("over");
            }
         }
      }
      
      public function deselect() : void
      {
         var _loc1_:* = null;
         if(debug)
         {
            trace("Container.deselect()");
         }
         for(_loc1_ in clip_list)
         {
            clip_list[_loc1_].selected = false;
            if(fx)
            {
               clip_list[_loc1_].transform.colorTransform = get_c("out");
               clip_list[_loc1_].filters = new Array();
            }
         }
      }
      
      private function get_c(param1:String) : ColorTransform
      {
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = colours[param1];
         _loc2_.redOffset = _loc2_.redOffset + -255;
         _loc2_.greenOffset = _loc2_.greenOffset + -255;
         _loc2_.blueOffset = _loc2_.blueOffset + -255;
         _loc2_.redMultiplier = 1;
         _loc2_.greenMultiplier = 1;
         _loc2_.blueMultiplier = 1;
         return _loc2_;
      }
      
      public function select(param1:*) : void
      {
         var _loc2_:* = null;
         if(clip_list == null)
         {
            return;
         }
         if(debug)
         {
            trace("Container.select()" + " " + param1);
         }
         deselect();
         if(param1 is uint)
         {
            if(param1 < 0 || param1 >= clip_list.length)
            {
               return;
            }
            clip_list[param1].selected = true;
            if(fx)
            {
               clip_list[param1].transform.colorTransform = get_c("up");
            }
         }
         else
         {
            for(_loc2_ in clip_list)
            {
               if(clip_list[_loc2_].name == param1)
               {
                  clip_list[_loc2_].selected = true;
                  if(fx)
                  {
                     clip_list[_loc2_].transform.colorTransform = get_c("up");
                  }
                  break;
               }
            }
         }
      }
      
      public function show() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in clip_list)
         {
            clip_list[_loc1_].visible = true;
         }
      }
   }
}
