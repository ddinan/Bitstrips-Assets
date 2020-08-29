package com.bitstrips.core
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.ColorTransform;
   
   public class ColourData extends EventDispatcher
   {
       
      
      public var colours:Object;
      
      public var name:String = "";
      
      private var debug:Boolean = true;
      
      public function ColourData(param1:Object = undefined)
      {
         super();
         colours = new Object();
         if(param1)
         {
            load_data(param1);
         }
         debug = false;
      }
      
      public static function get_colours(param1:Object) : Array
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:String = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ != null)
            {
               if(_loc4_.name.substr(0,2) == "c_")
               {
                  _loc5_ = _loc4_.name.substr(2);
                  if(_loc2_.indexOf(_loc5_) == -1)
                  {
                     _loc2_.push(_loc5_);
                  }
               }
            }
            _loc3_ = _loc3_ + 1;
         }
         return _loc2_;
      }
      
      public function equalize(param1:ColourData) : void
      {
         var _loc3_:* = null;
         var _loc2_:Boolean = false;
         for(_loc3_ in param1.colours)
         {
            if(colours[_loc3_] != param1.colours[_loc3_])
            {
               colours[_loc3_] = param1.colours[_loc3_];
               _loc2_ = true;
            }
         }
         if(_loc2_)
         {
            dispatchEvent(new Event("NEW_COLOUR"));
         }
      }
      
      public function load_data(param1:Object) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            colours[_loc2_.toLowerCase()] = param1[_loc2_];
         }
      }
      
      public function set_colour(param1:String, param2:Number, param3:Boolean = true) : void
      {
         param1 = param1.toLowerCase();
         if(colours[param1] && colours[param1] == param2)
         {
            return;
         }
         colours[param1] = param2;
         if(param3)
         {
            dispatchEvent(new Event("NEW_COLOUR"));
         }
      }
      
      public function colour_clip(param1:Object) : int
      {
         var _loc4_:ColorTransform = null;
         var _loc5_:DisplayObject = null;
         if(debug)
         {
            trace("Colourling the clip: " + param1 + ", ");
         }
         if(param1 == null)
         {
            if(debug)
            {
               trace("\tColour a null clip?");
            }
            return -1;
         }
         var _loc2_:uint = 0;
         if(param1.hasOwnProperty("base_colour") && param1.base_colour != undefined)
         {
            if(debug)
            {
               trace("\t it has a basecolour: " + param1.base_colour);
            }
            if(colours[param1.base_colour] != undefined)
            {
               _loc4_ = new ColorTransform();
               if(debug)
               {
                  trace("\tColouring it: " + colours[param1.base_colour].toString(16));
               }
               _loc4_.color = colours[param1.base_colour];
               _loc4_.redOffset = _loc4_.redOffset - 255;
               _loc4_.greenOffset = _loc4_.greenOffset - 255;
               _loc4_.blueOffset = _loc4_.blueOffset - 255;
               _loc4_.redMultiplier = 1;
               _loc4_.greenMultiplier = 1;
               _loc4_.blueMultiplier = 1;
               param1.transform.colorTransform = _loc4_;
               return 1;
            }
            if(debug)
            {
               trace("\t it has basecolour, but colours is undefined for it");
            }
            return 0;
         }
         if(debug)
         {
            trace("\tlooping through children");
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            if(debug)
            {
               trace("\t Get child: " + _loc3_);
            }
            _loc5_ = param1.getChildAt(_loc3_);
            if(_loc5_ == null)
            {
               if(debug)
               {
                  trace("NULL MOVIE CLIP IN COLOUR_CLIP!");
               }
               return -1;
            }
            if(debug)
            {
               trace("\tM name: " + _loc5_);
            }
            if(debug)
            {
               trace("\t" + _loc5_.name);
            }
            if(_loc5_.name.substr(0,2) == "c_")
            {
               if(colour_me(_loc5_))
               {
                  _loc2_ = 1;
               }
            }
            if(debug)
            {
               trace("Looping again?");
            }
            _loc3_ = _loc3_ + 1;
         }
         return _loc2_;
      }
      
      public function save_data() : Object
      {
         return colours;
      }
      
      public function clear() : void
      {
         colours = new Object();
      }
      
      public function colour_me(param1:Object) : Boolean
      {
         var _loc3_:ColorTransform = null;
         if(debug)
         {
            trace("\t colour_me: " + param1);
         }
         var _loc2_:String = param1.name.split("_")[1];
         _loc2_ = _loc2_.toLowerCase();
         if(debug)
         {
            trace("\t colour_me:" + _loc2_);
         }
         if(colours[_loc2_] != undefined)
         {
            _loc3_ = new ColorTransform();
            _loc3_.color = colours[_loc2_];
            param1.transform.colorTransform = _loc3_;
            return true;
         }
         if(_loc2_.length == 6)
         {
            _loc3_ = new ColorTransform();
            _loc3_.color = int("0x" + _loc2_);
            _loc3_.redOffset = _loc3_.redOffset - 255;
            _loc3_.greenOffset = _loc3_.greenOffset - 255;
            _loc3_.blueOffset = _loc3_.blueOffset - 255;
            _loc3_.redMultiplier = 1;
            _loc3_.greenMultiplier = 1;
            _loc3_.blueMultiplier = 1;
            param1.transform.colorTransform = _loc3_;
         }
         return false;
      }
      
      public function get_colour(param1:String) : Number
      {
         param1 = param1.toLowerCase();
         if(colours[param1] != undefined)
         {
            return colours[param1];
         }
         return -1;
      }
   }
}
