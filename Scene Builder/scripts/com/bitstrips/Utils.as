package com.bitstrips
{
   import com.dynamicflash.util.Base64;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public final class Utils
   {
      
      public static const over_filter:GlowFilter = new GlowFilter(65280,0.8,4,4,4);
      
      public static const textbubble_filter:GlowFilter = new GlowFilter(12255487,0.8,5,5,80);
      
      public static const locked_filter:GlowFilter = new GlowFilter(16711680,0.8,5,5,80);
      
      public static const selected_filter:GlowFilter = new GlowFilter(52479,0.8,5,5,80);
      
      public static const editing_filter:GlowFilter = new GlowFilter(16776960,0.8,5,5,80);
       
      
      public function Utils()
      {
         super();
      }
      
      public static function center_piece(param1:Object, param2:DisplayObjectContainer, param3:Number, param4:Number) : void
      {
         var _loc5_:Point = center_point(param1,param2);
         param1.x = param3 - _loc5_.x;
         param1.y = param4 - _loc5_.y;
      }
      
      public static function stack_above(param1:DisplayObject, param2:DisplayObject, param3:Number = 0) : void
      {
         var _loc4_:Rectangle = param2.getBounds(param2);
         var _loc5_:Number = _loc4_.y - _loc4_.height;
         var _loc6_:Point = new Point(0,_loc5_);
         _loc6_ = param2.localToGlobal(_loc6_);
         param1.y = _loc6_.y - param3;
      }
      
      public static function intersection(param1:Point, param2:Point, param3:Point, param4:Point) : Point
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc5_:Point = new Point();
         var _loc9_:Number = param4.x - param3.x;
         var _loc10_:Number = param4.y - param3.y;
         var _loc11_:Number = param2.x - param1.x;
         var _loc12_:Number = param2.y - param1.y;
         var _loc13_:Number = param1.y - param3.y;
         var _loc14_:Number = param1.x - param3.x;
         _loc6_ = _loc9_ * _loc13_ - _loc10_ * _loc14_;
         _loc7_ = _loc11_ * _loc13_ - _loc12_ * _loc14_;
         _loc8_ = _loc10_ * _loc11_ - _loc9_ * _loc12_;
         _loc6_ = _loc6_ / _loc8_;
         _loc7_ = _loc7_ / _loc8_;
         if(_loc6_ >= 0 && _loc6_ <= 1 && _loc7_ >= 0 && _loc7_ <= 1)
         {
            _loc7_ = param1.y + _loc6_ * _loc12_;
            _loc6_ = param1.x + _loc6_ * _loc11_;
            _loc5_.x = _loc6_;
            _loc5_.y = _loc7_;
         }
         else
         {
            _loc5_ = null;
         }
         return _loc5_;
      }
      
      private static function roll_out(param1:MouseEvent) : void
      {
         if(param1.currentTarget.hasOwnProperty("selected") && param1.currentTarget.selected == true)
         {
            return;
         }
         param1.currentTarget.filters = [];
      }
      
      public static function enable_shade_btn(param1:SimpleButton) : void
      {
         param1.transform.colorTransform = new ColorTransform();
         param1.mouseEnabled = param1.enabled = true;
      }
      
      public static function disable_shade(param1:InteractiveObject) : void
      {
         param1.transform.colorTransform = new ColorTransform(0.5,0.5,0.5);
         if(param1 is DisplayObjectContainer)
         {
            DisplayObjectContainer(param1).mouseChildren = false;
         }
         else
         {
            param1.mouseEnabled = false;
         }
      }
      
      public static function get_degrees_from_points(param1:Point, param2:Point) : Number
      {
         var _loc3_:Number = param2.x - param1.x;
         var _loc4_:Number = param2.y - param1.y;
         var _loc5_:Number = Math.atan2(_loc4_,_loc3_);
         var _loc6_:Number = 360 * _loc5_ / (2 * Math.PI);
         return degrees(_loc6_);
      }
      
      public static function amfs2object(param1:String) : Object
      {
         var tmp:ByteArray = null;
         var s:String = param1;
         var obj:Object = null;
         try
         {
            tmp = Base64.decodeToByteArray(s);
            tmp.uncompress();
            obj = tmp.readObject();
         }
         catch(e:Error)
         {
            trace("amf2obj error: " + e);
         }
         finally
         {
            trace("Yup...");
         }
         return obj;
      }
      
      private static function roll_over(param1:MouseEvent) : void
      {
         if(param1.currentTarget.hasOwnProperty("selected") && param1.currentTarget.selected == true)
         {
            return;
         }
         if(param1.buttonDown == false)
         {
            param1.currentTarget.filters = [over_filter];
         }
      }
      
      public static function stack_left(param1:DisplayObject, param2:DisplayObject, param3:Number = 0) : void
      {
         var _loc4_:Rectangle = param2.getBounds(param2);
         var _loc5_:Number = _loc4_.x - _loc4_.width;
         var _loc6_:Point = new Point(_loc5_,0);
         _loc6_ = param2.localToGlobal(_loc6_);
         param1.x = _loc6_.x - param3;
      }
      
      public static function art_split(param1:String) : Object
      {
         var _loc2_:int = param1.lastIndexOf("_");
         return {
            "part":param1.substr(0,_loc2_),
            "type":param1.substr(_loc2_ + 1)
         };
      }
      
      public static function over_out(param1:InteractiveObject) : void
      {
         param1.addEventListener(MouseEvent.ROLL_OVER,roll_over,false,0,true);
         param1.addEventListener(MouseEvent.ROLL_OUT,roll_out,false,0,true);
      }
      
      public static function clone(param1:Object) : Object
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         return _loc2_.readObject();
      }
      
      public static function stack_right(param1:DisplayObject, param2:DisplayObject, param3:Number = 0) : void
      {
         var _loc4_:Rectangle = param2.getBounds(param2);
         var _loc5_:Number = _loc4_.x + _loc4_.width;
         var _loc6_:Point = new Point(_loc5_,0);
         _loc6_ = param2.localToGlobal(_loc6_);
         param1.x = _loc6_.x + param3;
      }
      
      public static function center_point(param1:Object, param2:DisplayObjectContainer) : Point
      {
         var _loc3_:Rectangle = param1.getBounds(param2);
         return new Point(_loc3_.x + _loc3_.width / 2,_loc3_.y + _loc3_.height / 2);
      }
      
      public static function degrees(param1:Number) : Number
      {
         return (param1 % 360 + 360) % 360;
      }
      
      public static function get_BitmapData(param1:DisplayObject) : BitmapData
      {
         var _loc2_:Rectangle = param1.getBounds(param1);
         var _loc3_:Matrix = new Matrix();
         var _loc4_:Number = 1;
         _loc3_.scale(_loc4_,_loc4_);
         _loc3_.translate(-_loc2_.x * _loc4_,-_loc2_.y * _loc4_);
         if(_loc2_.x < -500 || _loc2_.y < -500 || _loc2_.width > 1000 || _loc2_.height > 1000 || _loc2_.x > 500 || _loc2_.y > 500)
         {
            trace("Unreasonable bounds!");
            trace(_loc2_);
            _loc2_.x = _loc2_.y = 0;
            _loc2_.width = _loc2_.height = 100;
         }
         var _loc5_:BitmapData = new BitmapData(_loc2_.width * _loc4_,_loc2_.height * _loc4_,true,16777215);
         var _loc6_:DisplayObject = param1.mask;
         param1.mask = null;
         _loc5_.draw(param1,_loc3_,null,null,null,true);
         param1.mask = _loc6_;
         return _loc5_;
      }
      
      public static function project_point(param1:Point, param2:Number, param3:Number) : Point
      {
         var _loc4_:Number = degrees(param3);
         var _loc5_:Number = _loc4_ * Math.PI / 180;
         var _loc6_:Number = param1.x + Math.cos(_loc5_) * param2;
         var _loc7_:Number = param1.y + Math.sin(_loc5_) * param2;
         return new Point(_loc6_,_loc7_);
      }
      
      public static function scale_me(param1:DisplayObject, param2:Number, param3:Number) : void
      {
         var _loc5_:Number = NaN;
         param1.x = 0;
         param1.y = 0;
         var _loc4_:Rectangle = param1.getBounds(param1);
         if(param1.scrollRect)
         {
            _loc4_ = param1.scrollRect;
         }
         if(param2 / param3 < _loc4_.width / _loc4_.height)
         {
            _loc5_ = param2 / _loc4_.width;
         }
         else
         {
            _loc5_ = param3 / _loc4_.height;
         }
         param1.scaleX = _loc5_;
         param1.scaleY = _loc5_;
      }
      
      public static function negative_colour(param1:uint) : ColorTransform
      {
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = param1;
         _loc2_.redOffset = _loc2_.redOffset - 255;
         _loc2_.greenOffset = _loc2_.greenOffset - 255;
         _loc2_.blueOffset = _loc2_.blueOffset - 255;
         _loc2_.redMultiplier = 1;
         _loc2_.greenMultiplier = 1;
         _loc2_.blueMultiplier = 1;
         return _loc2_;
      }
      
      public static function enable_shade(param1:InteractiveObject) : void
      {
         param1.transform.colorTransform = new ColorTransform();
         if(param1 is DisplayObjectContainer)
         {
            DisplayObjectContainer(param1).mouseChildren = true;
         }
         else
         {
            param1.mouseEnabled = true;
         }
      }
      
      public static function disable_shade_btn(param1:SimpleButton) : void
      {
         param1.transform.colorTransform = new ColorTransform(0.7,0.7,0.7);
         param1.mouseEnabled = param1.enabled = false;
      }
      
      public static function random_i() : int
      {
         if(Math.random() >= 0.5)
         {
            return 1;
         }
         return -1;
      }
      
      public static function on_top(param1:DisplayObject) : void
      {
         if(param1.parent)
         {
            param1.parent.setChildIndex(param1,param1.parent.numChildren - 1);
         }
      }
      
      public static function alphaBitmapData(param1:BitmapData) : BitmapData
      {
         var _loc2_:Rectangle = null;
         var _loc3_:BitmapData = null;
         if(param1 != null)
         {
            _loc2_ = param1.getColorBoundsRect(4278190080,0,false);
            _loc3_ = new BitmapData(_loc2_.width,_loc2_.height,true,16777215);
            _loc3_.copyPixels(param1,_loc2_,new Point(0,0),null,null,true);
         }
         else
         {
            trace("ERROR: alphaBitmapData passed null value...");
            _loc3_ = new BitmapData(1,1);
         }
         return _loc3_;
      }
      
      public static function stack_below(param1:DisplayObject, param2:DisplayObject, param3:Number = 0) : void
      {
         var _loc4_:Rectangle = param2.getBounds(param2);
         var _loc5_:Number = _loc4_.y + _loc4_.height;
         var _loc6_:Point = new Point(0,_loc5_);
         _loc6_ = param2.localToGlobal(_loc6_);
         param1.y = _loc6_.y + param3;
      }
      
      public static function distance(param1:Point, param2:Point) : Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
   }
}
