package com.bitstrips.core
{
   import com.bitstrips.comicbuilder.ComicAsset;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class Depth
   {
       
      
      public function Depth()
      {
         super();
      }
      
      public static function depth_translate(param1:Object, param2:Number, param3:Number, param4:Number) : Object
      {
         var _loc5_:Object = {
            "x":0,
            "y":0,
            "scale":1
         };
         _loc5_["scale"] = 1 - param1.z;
         _loc5_["y"] = param4 - param4 * (1 - param2) * param1.z - param1.float * _loc5_["scale"];
         _loc5_["x"] = (1 - param1.z) * param1.deviation + param3 * (1 - param1.z);
         return _loc5_;
      }
      
      public static function depth_resize(param1:ComicAsset, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc7_:Number = NaN;
      }
      
      public static function get_groundLevel(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Number = param3 - param3 * (1 - param2) * param1;
         return _loc4_;
      }
      
      public static function draw_ground(param1:Number, param2:Number, param3:Number, param4:DisplayObject) : void
      {
         param4 = Sprite(param4);
         Sprite(param4).scaleX = 1;
         Sprite(param4).scaleY = 1;
         Sprite(param4).graphics.clear();
         Sprite(param4).graphics.beginFill(14737632);
         Sprite(param4).graphics.drawRect(0,0,param2,param3 * (1 - param1));
         Sprite(param4).y = param3 * param1;
         Sprite(param4).graphics.endFill();
      }
      
      public static function draw_sky(param1:Number, param2:Number, param3:Number, param4:DisplayObject) : void
      {
         param4 = Sprite(param4);
         Sprite(param4).scaleX = 1;
         Sprite(param4).scaleY = 1;
         Sprite(param4).graphics.clear();
         Sprite(param4).graphics.beginFill(16777215);
         Sprite(param4).graphics.drawRect(0,0 - param3 * param1,param2,param3 * param1);
         Sprite(param4).y = param3 * param1;
         Sprite(param4).graphics.endFill();
      }
   }
}
