package com.bitstrips.comicbuilder
{
   import com.bitstrips.Utils;
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.core.FilterContainer;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.geom.ColorTransform;
   
   public class BackDrop extends FilterContainer
   {
      
      private static var debug:Boolean = false;
       
      
      private var sky:Shape;
      
      private var bd:Object;
      
      private var color:Number;
      
      private var _ground_colour:uint = 16777215;
      
      private var al:ArtLoader;
      
      private var _sky_colour:uint = 16777215;
      
      private var myPanel:Object;
      
      public function BackDrop()
      {
         super();
         if(debug)
         {
            trace("--BackDrop()--");
         }
         al = ArtLoader.getInstance();
      }
      
      public function set ground_colour(param1:uint) : void
      {
         _ground_colour = param1;
         if(bd != null && bd["tint_group_B"])
         {
            bd["tint_group_B"].transform.colorTransform = Utils.negative_colour(_ground_colour);
         }
      }
      
      public function getColor() : Number
      {
         return color;
      }
      
      public function get sky_colour() : uint
      {
         return _sky_colour;
      }
      
      public function set sky_colour(param1:uint) : void
      {
         _sky_colour = param1;
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = _sky_colour;
         sky.transform.colorTransform = _loc2_;
         if(bd["tint_group_A"])
         {
            bd["tint_group_A"].transform.colorTransform = Utils.negative_colour(_sky_colour);
         }
      }
      
      public function setPanel(param1:Object) : void
      {
         myPanel = param1;
      }
      
      public function get ground_colour() : uint
      {
         return _ground_colour;
      }
      
      public function setBackdrop(param1:String) : void
      {
         var _loc2_:int = this.numChildren - 1;
         while(_loc2_ >= 0)
         {
            this.removeChildAt(_loc2_);
            _loc2_--;
         }
         sky = new Shape();
         addChild(sky);
         sky.graphics.beginFill(16777215);
         sky.graphics.drawRect(-650,-650,1300,650);
         name = param1;
         bd = al.get_prop("backdrops",param1);
         if(bd.hasOwnProperty("sky"))
         {
            sky_colour = bd["sky"];
         }
         if(bd.hasOwnProperty("ground"))
         {
            this.ground_colour = bd["ground"];
         }
         addChild(DisplayObject(bd));
      }
   }
}
