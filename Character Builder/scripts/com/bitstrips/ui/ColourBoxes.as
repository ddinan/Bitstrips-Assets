package com.bitstrips.ui
{
   import com.bitstrips.core.ColourData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ColourBoxes extends Sprite
   {
       
      
      private var size:Number = 13;
      
      private var cnames:Object;
      
      public var update_func:Function;
      
      private var debug:Boolean = false;
      
      private const scale_size:Number = 1.2;
      
      public var cld:ColourData;
      
      public var active_colour:Number;
      
      private var colours:Object;
      
      private var boxes:Array;
      
      public var base_colour:String = "ffcc99";
      
      public function ColourBoxes(param1:GradientBox2, param2:uint = 0, param3:Boolean = false)
      {
         boxes = new Array();
         colours = new Object();
         cnames = new Object();
         super();
         colours["ffcc99"] = ["f3e1de","ffcc99","dcc29f","cc9667","895b3d"];
         cnames["ffcc99"] = "skin";
         colours["926715"] = ["dfd1d0","ece7a2","926715","b6523a","3b302a"];
         cnames["926715"] = "hair";
         colours["4f453e"] = ["666666","84621a","5a3425","803928","4f453e"];
         cnames["4f453e"] = "eyebrow";
         colours["36a7e9"] = ["0099cc","339966","b07700","6c3f20","999999"];
         cnames["36a7e9"] = "pupils";
         colours["fffffe"] = ["fffffe","99ccff","e1e100","cc0033","ff9999"];
         cnames["a2cdf2"] = "shirts";
         colours["f5f5f5"] = ["f5f5f5","3399cc","006699","828200","66380f"];
         cnames["f5f5f5"] = "pants";
         colours["838383"] = ["f3f3f3","cccccc","999999","990000","292929"];
         cnames["838383"] = "socks";
         colours["422828"] = ["f3f3f3","99ccff","cc0033","91553d","292929"];
         cnames["422828"] = "shoes";
         var _loc4_:uint = 0;
         while(_loc4_ < 6)
         {
            if(_loc4_ == 5)
            {
               boxes[_loc4_] = param1;
               param1.grad_align(param2);
            }
            else
            {
               boxes[_loc4_] = new ColourBox(int("0x" + colours[base_colour][_loc4_]));
            }
            boxes[_loc4_].name = _loc4_;
            addChild(boxes[_loc4_]);
            boxes[_loc4_].x = boxes[_loc4_].x + _loc4_ * 18;
            boxes[_loc4_].addEventListener("SELECTED",set_colour);
            if(_loc4_ == 5 && param3 == false)
            {
               boxes[_loc4_].addEventListener("COLOUR_OVER",select_colour);
            }
            _loc4_ = _loc4_ + 1;
         }
         addEventListener(MouseEvent.MOUSE_OUT,mouse_out);
      }
      
      private function set_colour(param1:Event) : void
      {
         if(debug)
         {
            trace("Set colour" + " " + param1.currentTarget.name + " - " + param1);
         }
         var _loc2_:uint = 0;
         while(_loc2_ < 6)
         {
            if(debug)
            {
               trace("\t" + _loc2_);
            }
            if(param1.currentTarget.name != _loc2_)
            {
               if(debug)
               {
                  trace("\t" + boxes[_loc2_] + " - deselect");
               }
               boxes[_loc2_].deselect();
            }
            _loc2_ = _loc2_ + 1;
         }
         if(debug)
         {
            trace("Active colour: " + param1.currentTarget.colour);
         }
         active_colour = param1.currentTarget.colour;
         select_colour(param1);
      }
      
      public function get_boxes() : Array
      {
         return boxes;
      }
      
      public function set_base_colour(param1:String) : void
      {
         var _loc2_:Array = null;
         base_colour = param1;
         if(debug)
         {
            trace("Set base colour: " + param1);
         }
         if(cld && cld.get_colour(base_colour) != -1)
         {
            active_colour = cld.get_colour(base_colour);
         }
         else
         {
            active_colour = int("0x" + param1);
         }
         if(colours[base_colour])
         {
            _loc2_ = colours[base_colour];
         }
         else
         {
            if(debug)
            {
               trace("MISSING BASECOLOUR DEFINITION: " + base_colour);
            }
            _loc2_ = ["FF0000","00FF00","0000FF","000000","ffffff"];
         }
         if(debug)
         {
            trace("\tActive colour: " + active_colour);
         }
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         while(_loc4_ < 6)
         {
            if(_loc2_[_loc4_])
            {
               boxes[_loc4_].set_colour(int("0x" + _loc2_[_loc4_]));
            }
            else
            {
               if(debug)
               {
                  trace("\tI don\'t have a colour for: " + _loc4_);
               }
               if(_loc4_ == 5)
               {
                  boxes[_loc4_].set_colour(-1);
               }
            }
            if(boxes[_loc4_].colour == active_colour)
            {
               if(debug)
               {
                  trace("\t Active Colour! - " + _loc4_ + " -- " + active_colour + " " + boxes[_loc4_].colour);
               }
               _loc3_ = true;
               boxes[_loc4_].select();
            }
            else
            {
               boxes[_loc4_].deselect();
               if(debug)
               {
                  trace("\t Not active - " + _loc4_ + " -- " + active_colour + " " + boxes[_loc4_].colour);
               }
            }
            _loc4_ = _loc4_ + 1;
         }
         if(_loc3_ == false)
         {
            if(debug)
            {
               trace("\tNobody made it, setting 5 as colour:");
            }
            boxes[5].set_colour(active_colour);
            boxes[5].select();
         }
      }
      
      private function colour_out(param1:Event) : void
      {
         if(cld)
         {
            cld.set_colour(base_colour,active_colour);
         }
         if(update_func != null)
         {
            update_func(active_colour);
         }
      }
      
      private function select_colour(param1:Event) : void
      {
         if(debug)
         {
            trace("New colour for base: " + base_colour + " - " + param1.currentTarget.colour);
         }
         if(cld)
         {
            cld.set_colour(base_colour,param1.currentTarget.colour);
         }
         if(update_func != null)
         {
            update_func(param1.currentTarget.colour);
         }
      }
      
      private function mouse_out(param1:Event) : void
      {
         if(debug)
         {
            trace("Mouse out of colourboxes");
         }
      }
   }
}
