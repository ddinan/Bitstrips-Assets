package com.bitstrips.core
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.ColorTransform;
   
   public class ColourData extends EventDispatcher
   {
       
      
      public var colours:Object;
      
      private var debug:Boolean = true;
      
      public var name:String = "";
      
      public function ColourData(param1:Object = undefined)
      {
         super();
         this.colours = new Object();
         if(param1)
         {
            this.load_data(param1);
         }
         this.debug = false;
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
      
      public function clear() : void
      {
         this.colours = new Object();
      }
      
      public function save_data() : Object
      {
         return this.colours;
      }
      
      public function load_data(param1:Object) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            this.colours[_loc2_.toLowerCase()] = param1[_loc2_];
         }
      }
      
      public function equalize(param1:ColourData) : void
      {
         var _loc3_:* = null;
         var _loc2_:Boolean = false;
         for(_loc3_ in param1.colours)
         {
            if(this.colours[_loc3_] != param1.colours[_loc3_])
            {
               this.colours[_loc3_] = param1.colours[_loc3_];
               _loc2_ = true;
            }
         }
         if(_loc2_)
         {
            dispatchEvent(new Event("NEW_COLOUR"));
         }
      }
      
      public function set_colour(param1:String, param2:Number, param3:Boolean = true) : void
      {
         param1 = param1.toLowerCase();
         if(this.colours[param1] && this.colours[param1] == param2)
         {
            return;
         }
         this.colours[param1] = param2;
         if(param3)
         {
            dispatchEvent(new Event("NEW_COLOUR"));
         }
      }
      
      public function get_colour(param1:String) : Number
      {
         param1 = param1.toLowerCase();
         if(this.colours[param1] != undefined)
         {
            return this.colours[param1];
         }
         return -1;
      }
      
      public function colour_clip(param1:Object) : int
      {
         var _loc4_:ColorTransform = null;
         var _loc5_:DisplayObject = null;
         if(this.debug)
         {
            trace("Colourling the clip: " + param1 + ", ");
         }
         if(param1 == null)
         {
            if(this.debug)
            {
               trace("\tColour a null clip?");
            }
            return -1;
         }
         var _loc2_:uint = 0;
         if(param1.hasOwnProperty("base_colour") && param1.base_colour != undefined)
         {
            if(this.debug)
            {
               trace("\t it has a basecolour: " + param1.base_colour);
            }
            if(this.colours[param1.base_colour] != undefined)
            {
               _loc4_ = new ColorTransform();
               if(this.debug)
               {
                  trace("\tColouring it: " + this.colours[param1.base_colour].toString(16));
               }
               _loc4_.color = this.colours[param1.base_colour];
               _loc4_.redOffset = _loc4_.redOffset - 255;
               _loc4_.greenOffset = _loc4_.greenOffset - 255;
               _loc4_.blueOffset = _loc4_.blueOffset - 255;
               _loc4_.redMultiplier = 1;
               _loc4_.greenMultiplier = 1;
               _loc4_.blueMultiplier = 1;
               param1.transform.colorTransform = _loc4_;
               return 1;
            }
            if(this.debug)
            {
               trace("\t it has basecolour, but colours is undefined for it");
            }
            return 0;
         }
         if(this.debug)
         {
            trace("\tlooping through children");
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            if(this.debug)
            {
               trace("\t Get child: " + _loc3_);
            }
            _loc5_ = param1.getChildAt(_loc3_);
            if(_loc5_ == null)
            {
               if(this.debug)
               {
                  trace("NULL MOVIE CLIP IN COLOUR_CLIP!");
               }
               return -1;
            }
            if(this.debug)
            {
               trace("\tM name: " + _loc5_);
            }
            if(this.debug)
            {
               trace("\t" + _loc5_.name);
            }
            if(_loc5_.name.substr(0,2) == "c_")
            {
               if(this.colour_me(_loc5_))
               {
                  _loc2_ = 1;
               }
            }
            if(this.debug)
            {
               trace("Looping again?");
            }
            _loc3_ = _loc3_ + 1;
         }
         return _loc2_;
      }
      
      public function colour_me(param1:Object) : Boolean
      {
         var _loc3_:ColorTransform = null;
         if(this.debug)
         {
            trace("\t colour_me: " + param1);
         }
         var _loc2_:String = param1.name.split("_")[1];
         _loc2_ = _loc2_.toLowerCase();
         if(this.debug)
         {
            trace("\t colour_me:" + _loc2_);
         }
         if(this.colours[_loc2_] != undefined)
         {
            _loc3_ = new ColorTransform();
            _loc3_.color = this.colours[_loc2_];
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
   }
}
