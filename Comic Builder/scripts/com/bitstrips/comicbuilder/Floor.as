package com.bitstrips.comicbuilder
{
   import com.bitstrips.Utils;
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.core.FilterContainer;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.geom.ColorTransform;
   
   public class Floor extends FilterContainer
   {
      
      private static var al:ArtLoader;
      
      private static var debug:Boolean = false;
       
      
      private var g:Object;
      
      private var color:uint = 16777215;
      
      private var myPanel:PanelContents;
      
      private var ground:Shape;
      
      public function Floor()
      {
         super();
         if(debug)
         {
            trace("--Floor()--");
         }
         al = ArtLoader.getInstance();
      }
      
      public function setFloor(param1:String) : void
      {
         name = param1;
         var _loc2_:int = this.numChildren - 1;
         while(_loc2_ >= 0)
         {
            this.removeChildAt(_loc2_);
            _loc2_--;
         }
         this.ground = new Shape();
         addChild(this.ground);
         this.ground.graphics.beginFill(16711680);
         this.ground.graphics.drawRect(-650,0,1300,650);
         this.g = al.get_prop("floors",param1);
         if(this.g.hasOwnProperty("ground"))
         {
            this.color = this.g["ground"];
         }
         addChild(DisplayObject(this.g));
         this.setColor(this.color);
      }
      
      public function setColor(param1:Number) : void
      {
         if(debug)
         {
            trace("--Floor.setColor(" + param1 + ")--");
         }
         this.color = param1;
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = this.color;
         this.ground.transform.colorTransform = _loc2_;
         if(this.g["tint_group_B"])
         {
            this.g["tint_group_B"].transform.colorTransform = Utils.negative_colour(this.color);
         }
      }
      
      public function getColor() : Number
      {
         return this.color;
      }
      
      public function setPanel(param1:PanelContents) : void
      {
         this.myPanel = param1;
      }
   }
}
