package com.bitstrips.core
{
   import com.quasimondo.geom.ColorMatrix;
   import flash.display.Sprite;
   
   public class FilterContainer extends Sprite
   {
       
      
      private var hue:Number = 0;
      
      private var saturation:Number = 1;
      
      private var contrast:Number = 0;
      
      private var brightness:Number = 0;
      
      private var alpha_value:Number = 1;
      
      private var threshold:Number = 0;
      
      private var _enabled:Boolean = false;
      
      public var panelMatrix:ColorMatrix;
      
      public function FilterContainer()
      {
         super();
         this._enabled = false;
      }
      
      private function check_vals() : void
      {
         if(this.hue == 0 && this.saturation == 1 && this.contrast == 0 && this.brightness == 0 && this.alpha_value == 1 && this.threshold == 0)
         {
            this._enabled = false;
         }
         else
         {
            this._enabled = true;
         }
      }
      
      private function between(param1:Number, param2:Number, param3:Number) : Number
      {
         return Math.max(Math.min(param1,param3),param2);
      }
      
      public function set_filters(param1:Object) : void
      {
         this.hue = this.between(param1.hue,0,360);
         this.saturation = this.between(param1.saturation,0,2);
         this.contrast = this.between(param1.contrast,-1,1);
         this.brightness = this.between(param1.brightness,-255,255);
         this.alpha_value = this.between(param1.alpha,0.05,1);
         this.threshold = this.between(param1.threshold,0,255);
         this.update_filters();
      }
      
      private function update_filters() : void
      {
         var _loc2_:ColorMatrix = null;
         var _loc1_:Array = [];
         this.check_vals();
         if(this._enabled)
         {
            _loc2_ = new ColorMatrix();
            _loc2_.adjustHue(this.hue);
            _loc2_.adjustSaturation(this.saturation);
            _loc2_.adjustContrast(this.contrast);
            _loc2_.adjustBrightness(this.brightness);
            _loc2_.setAlpha(this.alpha_value);
            if(this.threshold)
            {
               _loc2_.threshold(this.threshold);
            }
            _loc1_.push(_loc2_.filter);
         }
         if(this.panelMatrix)
         {
            _loc1_.push(this.panelMatrix.filter);
         }
         this.filters = _loc1_;
      }
      
      public function get_matrix() : ColorMatrix
      {
         var _loc1_:ColorMatrix = null;
         if(this._enabled)
         {
            _loc1_ = new ColorMatrix();
            _loc1_.adjustHue(this.hue);
            _loc1_.adjustSaturation(this.saturation);
            _loc1_.adjustContrast(this.contrast);
            _loc1_.adjustBrightness(this.brightness);
            _loc1_.setAlpha(this.alpha_value);
            if(this.threshold)
            {
               _loc1_.threshold(this.threshold);
            }
            return _loc1_;
         }
         return null;
      }
      
      public function set_panelMatrix(param1:ColorMatrix) : void
      {
         this.panelMatrix = param1;
         this.update_filters();
      }
      
      public function get_filters() : Object
      {
         var _loc1_:Object = {
            "hue":this.hue,
            "saturation":this.saturation,
            "contrast":this.contrast,
            "brightness":this.brightness,
            "alpha":this.alpha_value,
            "threshold":this.threshold
         };
         return _loc1_;
      }
      
      public function reset_filters() : void
      {
         this.hue = 0;
         this.saturation = 1;
         this.contrast = 0;
         this.brightness = 0;
         this.alpha_value = 1;
         this.threshold = 0;
         this.update_filters();
      }
   }
}
