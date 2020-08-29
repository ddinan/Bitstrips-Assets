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
       
      
      private var al:ArtLoader;
      
      private var bd:Object;
      
      private var color:Number;
      
      private var myPanel:Object;
      
      private var sky:Shape;
      
      private var _sky_colour:uint = 16777215;
      
      private var _ground_colour:uint = 16777215;
      
      public function BackDrop()
      {
         super();
         if(debug)
         {
            trace("--BackDrop()--");
         }
         this.al = ArtLoader.getInstance();
      }
      
      public function setBackdrop(param1:String) : void
      {
         var _loc2_:int = this.numChildren - 1;
         while(_loc2_ >= 0)
         {
            this.removeChildAt(_loc2_);
            _loc2_--;
         }
         this.sky = new Shape();
         addChild(this.sky);
         this.sky.graphics.beginFill(16777215);
         this.sky.graphics.drawRect(-650,-650,1300,650);
         name = param1;
         this.bd = this.al.get_prop("backdrops",param1);
         if(this.bd.hasOwnProperty("sky"))
         {
            this.sky_colour = this.bd["sky"];
         }
         if(this.bd.hasOwnProperty("ground"))
         {
            this.ground_colour = this.bd["ground"];
         }
         addChild(DisplayObject(this.bd));
      }
      
      public function set sky_colour(param1:uint) : void
      {
         this._sky_colour = param1;
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = this._sky_colour;
         this.sky.transform.colorTransform = _loc2_;
         if(this.bd["tint_group_A"])
         {
            this.bd["tint_group_A"].transform.colorTransform = Utils.negative_colour(this._sky_colour);
         }
      }
      
      public function set ground_colour(param1:uint) : void
      {
         this._ground_colour = param1;
         if(this.bd != null && this.bd["tint_group_B"])
         {
            this.bd["tint_group_B"].transform.colorTransform = Utils.negative_colour(this._ground_colour);
         }
      }
      
      public function get sky_colour() : uint
      {
         return this._sky_colour;
      }
      
      public function get ground_colour() : uint
      {
         return this._ground_colour;
      }
      
      public function getColor() : Number
      {
         return this.color;
      }
      
      public function setPanel(param1:Object) : void
      {
         this.myPanel = param1;
      }
   }
}
