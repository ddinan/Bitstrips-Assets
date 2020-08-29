package com.bitstrips.core
{
   import com.quasimondo.geom.ColorMatrix;
   import flash.display.Sprite;
   
   public class FilterContainer extends Sprite
   {
       
      
      private var contrast:Number = 0;
      
      public var panelMatrix:ColorMatrix;
      
      private var threshold:Number = 0;
      
      private var brightness:Number = 0;
      
      private var saturation:Number = 1;
      
      private var alpha_value:Number = 1;
      
      private var hue:Number = 0;
      
      private var _enabled:Boolean = false;
      
      public function FilterContainer()
      {
         super();
         _enabled = false;
      }
      
      private function check_vals() : void
      {
         if(hue == 0 && saturation == 1 && contrast == 0 && brightness == 0 && alpha_value == 1 && threshold == 0)
         {
            _enabled = false;
         }
         else
         {
            _enabled = true;
         }
      }
      
      public function reset_filters() : void
      {
         hue = 0;
         saturation = 1;
         contrast = 0;
         brightness = 0;
         alpha_value = 1;
         threshold = 0;
         update_filters();
      }
      
      private function between(param1:Number, param2:Number, param3:Number) : Number
      {
         return Math.max(Math.min(param1,param3),param2);
      }
      
      private function update_filters() : void
      {
         var _loc2_:ColorMatrix = null;
         var _loc1_:Array = [];
         check_vals();
         if(_enabled)
         {
            _loc2_ = new ColorMatrix();
            _loc2_.adjustHue(hue);
            _loc2_.adjustSaturation(saturation);
            _loc2_.adjustContrast(contrast);
            _loc2_.adjustBrightness(brightness);
            _loc2_.setAlpha(alpha_value);
            if(threshold)
            {
               _loc2_.threshold(threshold);
            }
            _loc1_.push(_loc2_.filter);
         }
         if(panelMatrix)
         {
            _loc1_.push(panelMatrix.filter);
         }
         this.filters = _loc1_;
      }
      
      public function set_panelMatrix(param1:ColorMatrix) : void
      {
         panelMatrix = param1;
         update_filters();
      }
      
      public function get_filters() : Object
      {
         var _loc1_:Object = {
            "hue":hue,
            "saturation":saturation,
            "contrast":contrast,
            "brightness":brightness,
            "alpha":alpha_value,
            "threshold":threshold
         };
         return _loc1_;
      }
      
      public function get_matrix() : ColorMatrix
      {
         var _loc1_:ColorMatrix = null;
         if(_enabled)
         {
            _loc1_ = new ColorMatrix();
            _loc1_.adjustHue(hue);
            _loc1_.adjustSaturation(saturation);
            _loc1_.adjustContrast(contrast);
            _loc1_.adjustBrightness(brightness);
            _loc1_.setAlpha(alpha_value);
            if(threshold)
            {
               _loc1_.threshold(threshold);
            }
            return _loc1_;
         }
         return null;
      }
      
      public function set_filters(param1:Object) : void
      {
         hue = between(param1.hue,0,360);
         saturation = between(param1.saturation,0,2);
         contrast = between(param1.contrast,-1,1);
         brightness = between(param1.brightness,-255,255);
         alpha_value = between(param1.alpha,0.05,1);
         threshold = between(param1.threshold,0,255);
         update_filters();
      }
   }
}
