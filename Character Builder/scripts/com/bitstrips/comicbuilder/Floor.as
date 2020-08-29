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
       
      
      private var color:uint = 16777215;
      
      private var g:Object;
      
      private var ground:Shape;
      
      private var myPanel:PanelContents;
      
      public function Floor()
      {
         super();
         if(debug)
         {
            trace("--Floor()--");
         }
         al = ArtLoader.getInstance();
      }
      
      public function setColor(param1:Number) : void
      {
         if(debug)
         {
            trace("--Floor.setColor(" + param1 + ")--");
         }
         color = param1;
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = color;
         ground.transform.colorTransform = _loc2_;
         if(g["tint_group_B"])
         {
            g["tint_group_B"].transform.colorTransform = Utils.negative_colour(color);
         }
      }
      
      public function setPanel(param1:PanelContents) : void
      {
         myPanel = param1;
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
         ground = new Shape();
         addChild(ground);
         ground.graphics.beginFill(16711680);
         ground.graphics.drawRect(-650,0,1300,650);
         g = al.get_prop("floors",param1);
         if(g.hasOwnProperty("ground"))
         {
            color = g["ground"];
         }
         addChild(DisplayObject(g));
         setColor(color);
      }
      
      public function getColor() : Number
      {
         return color;
      }
   }
}
