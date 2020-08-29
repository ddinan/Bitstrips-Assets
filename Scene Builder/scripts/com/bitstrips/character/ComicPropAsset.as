package com.bitstrips.character
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.comicbuilder.ComicAsset;
   import com.bitstrips.core.FilterContainer;
   import com.bitstrips.core.PropShape;
   import com.quasimondo.geom.ColorMatrix;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public final class ComicPropAsset extends ComicAsset
   {
       
      
      private var ceiling_sprite:Sprite;
      
      public var prop:Object;
      
      private var _ceiling_colour:int = -1;
      
      private var _ceiling:Boolean = false;
      
      private var ceiling_fc:FilterContainer;
      
      public function ComicPropAsset(param1:String)
      {
         if(debug)
         {
            trace("--ComicPropAsset()--");
         }
         super();
      }
      
      public function rescaleProp(param1:Number) : void
      {
         if(prop && prop is PropShape == false)
         {
            prop.scaleX = prop.scaleY = param1;
         }
      }
      
      override public function set_panelMatrix(param1:ColorMatrix) : void
      {
         fc.set_panelMatrix(param1);
         if(ceiling)
         {
            ceiling_fc.set_panelMatrix(param1);
         }
      }
      
      override public function save_state() : Object
      {
         var _loc1_:Object = super.save_state();
         if(prop)
         {
            _loc1_["prop"] = prop.save_state();
         }
         return _loc1_;
      }
      
      private function ceiling_init() : void
      {
         ceiling_sprite = new Sprite();
         ceiling_fc = new FilterContainer();
         addChild(ceiling_fc);
         ceiling_fc.addChild(ceiling_sprite);
         ceiling_fc.visible = false;
      }
      
      override public function set scale(param1:Number) : void
      {
         var _loc2_:* = this.prop is PropShape;
         var _loc3_:Number = 5;
         if(_loc2_)
         {
            _loc3_ = 20;
         }
         if(param1 > 0 && param1 < _loc3_)
         {
            assetData["scale"] = param1;
            if(_loc2_)
            {
               PropShape(this.prop).scale = param1;
            }
            else
            {
               super.scale = param1;
            }
         }
      }
      
      public function loadComplete(param1:Object) : void
      {
         var p:Object = param1;
         if(debug)
         {
            trace("--ComicPropAsset.loadComplete(" + this.name + ")--");
         }
         super.originalWidth = this.width;
         prop = p;
         if(prop)
         {
            prop.mouseEnabled = prop.mouseChildren = false;
         }
         rescaleProp(BSConstants.RESCALE);
         if(debug)
         {
            trace("myPanel: " + myPanel);
         }
         if(debug)
         {
            trace("p.width: " + prop.width);
         }
         if(super._selected)
         {
            super.controller.register(this);
         }
         super.artwork.addChild(DisplayObject(prop));
         prop.pass = function(param1:String, param2:Number):void
         {
            if(debug)
            {
               trace("color name: " + param1);
            }
            colorCeiling(param2);
         };
      }
      
      public function drawCeiling() : void
      {
         if(debug)
         {
            trace("--ComicPropAsset.drawCeiling()--");
         }
         if(_ceiling == false)
         {
            if(ceiling_sprite)
            {
               ceiling_sprite.graphics.clear();
            }
            return;
         }
         if(ceiling_sprite == null)
         {
            this.ceiling_init();
         }
         ceiling_sprite.graphics.clear();
         this.cacheAsBitmap = false;
         var _loc1_:Rectangle = prop.getBounds(this);
         var _loc2_:Point = this.parent.localToGlobal(new Point(-650,-650));
         _loc2_ = ceiling_sprite.globalToLocal(_loc2_);
         var _loc3_:Point = this.parent.localToGlobal(new Point(650,-650));
         _loc3_ = ceiling_sprite.globalToLocal(_loc3_);
         var _loc4_:Point = this.parent.localToGlobal(new Point(-650,650));
         _loc4_ = ceiling_sprite.globalToLocal(_loc4_);
         var _loc5_:Point = this.parent.localToGlobal(new Point(650,650));
         _loc5_ = ceiling_sprite.globalToLocal(_loc5_);
         ceiling_sprite.graphics.lineStyle(0,0,1);
         ceiling_sprite.graphics.beginFill(13224393);
         ceiling_sprite.graphics.moveTo(_loc2_.x,_loc2_.y);
         ceiling_sprite.graphics.lineTo(_loc1_.x,_loc1_.y);
         ceiling_sprite.graphics.lineTo(_loc1_.x + _loc1_.width,_loc1_.y);
         ceiling_sprite.graphics.lineTo(_loc3_.x,_loc3_.y);
         ceiling_sprite.graphics.lineTo(_loc2_.x,_loc3_.y);
         ceiling_sprite.graphics.moveTo(_loc2_.x,_loc2_.y);
         ceiling_sprite.graphics.lineTo(_loc4_.x,_loc4_.y);
         ceiling_sprite.graphics.lineTo(_loc1_.x,_loc1_.y + _loc1_.height);
         ceiling_sprite.graphics.lineTo(_loc1_.x,_loc1_.y);
         ceiling_sprite.graphics.lineTo(_loc2_.x,_loc2_.y);
         ceiling_sprite.graphics.moveTo(_loc3_.x,_loc3_.y);
         ceiling_sprite.graphics.lineTo(_loc5_.x,_loc5_.y);
         ceiling_sprite.graphics.lineTo(_loc1_.x + _loc1_.width,_loc1_.y + _loc1_.height);
         ceiling_sprite.graphics.lineTo(_loc1_.x + _loc1_.width,_loc1_.y);
         ceiling_sprite.graphics.lineTo(_loc3_.x,_loc3_.y);
         if(_ceiling_colour != -1)
         {
            this.colorCeiling(_ceiling_colour);
         }
         ceiling_fc.visible = true;
      }
      
      public function colorCeiling(param1:Number) : void
      {
         _ceiling_colour = param1;
         if(ceiling_sprite == null)
         {
            return;
         }
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = _ceiling_colour;
         _loc2_.redOffset = _loc2_.redOffset + -255;
         _loc2_.greenOffset = _loc2_.greenOffset + -255;
         _loc2_.blueOffset = _loc2_.blueOffset + -255;
         _loc2_.redMultiplier = 1;
         _loc2_.greenMultiplier = 1;
         _loc2_.blueMultiplier = 1;
         ceiling_sprite.transform.colorTransform = _loc2_;
      }
      
      override public function set_filters(param1:Object) : void
      {
         fc.set_filters(param1);
         if(ceiling)
         {
            ceiling_fc.set_filters(param1);
         }
         assetData["filters"] = fc.get_filters();
      }
      
      override public function resized(param1:Number = 0) : void
      {
         if(assetData && assetData["type"] == "walls")
         {
            _ceiling = assetData["ceiling"];
            drawCeiling();
         }
      }
      
      override public function doubleClick(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--ComicPropAsset.doubleClick()--");
         }
         super.myPanel.getComic().getComicBuilder().focusTab("instance");
      }
      
      override public function load_state(param1:Object) : void
      {
         if(debug)
         {
            trace("--ComicPropAsset.load_state()--");
         }
         super.load_state(param1);
         if(prop && param1["prop"])
         {
            prop.load_state(param1["prop"]);
            prop.cld.colour_clip(prop);
         }
         else if(debug)
         {
            trace("saving state for when the prop loads");
         }
         if(param1["type"] == "walls")
         {
            if(!param1.hasOwnProperty("ceiling"))
            {
               param1["ceiling"] = true;
               drawCeiling();
            }
         }
      }
      
      public function set ceiling(param1:Boolean) : void
      {
         if(debug)
         {
            trace("--ComicPropAsset.setCeiling(" + param1 + ")--");
         }
         assetData["ceiling"] = param1;
         _ceiling = param1;
         this.drawCeiling();
      }
      
      public function get ceiling() : Boolean
      {
         return _ceiling;
      }
   }
}
