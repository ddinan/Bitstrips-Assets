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
       
      
      public var prop:Object;
      
      private var ceiling_sprite:Sprite;
      
      private var ceiling_fc:FilterContainer;
      
      private var _ceiling:Boolean = false;
      
      private var _ceiling_colour:int = -1;
      
      public function ComicPropAsset(param1:String)
      {
         if(debug)
         {
            trace("--ComicPropAsset()--");
         }
         super();
      }
      
      private function ceiling_init() : void
      {
         this.ceiling_sprite = new Sprite();
         this.ceiling_fc = new FilterContainer();
         addChild(this.ceiling_fc);
         this.ceiling_fc.addChild(this.ceiling_sprite);
         this.ceiling_fc.visible = false;
      }
      
      public function loadComplete(param1:Object) : void
      {
         var p:Object = param1;
         if(debug)
         {
            trace("--ComicPropAsset.loadComplete(" + this.name + ")--");
         }
         super.originalWidth = this.width;
         this.prop = p;
         if(this.prop)
         {
            this.prop.mouseEnabled = this.prop.mouseChildren = false;
         }
         this.rescaleProp(BSConstants.RESCALE);
         if(debug)
         {
            trace("myPanel: " + myPanel);
         }
         if(debug)
         {
            trace("p.width: " + this.prop.width);
         }
         if(super._selected)
         {
            super.controller.register(this);
         }
         super.artwork.addChild(DisplayObject(this.prop));
         this.prop.pass = function(param1:String, param2:Number):void
         {
            if(debug)
            {
               trace("color name: " + param1);
            }
            colorCeiling(param2);
         };
         loaded();
      }
      
      override public function save_state() : Object
      {
         var _loc1_:Object = super.save_state();
         if(this.prop)
         {
            _loc1_["prop"] = this.prop.save_state();
         }
         return _loc1_;
      }
      
      override public function load_state(param1:Object) : void
      {
         if(debug)
         {
            trace("--ComicPropAsset.load_state()--");
         }
         super.load_state(param1);
         if(this.prop && param1["prop"])
         {
            this.prop.load_state(param1["prop"]);
            this.prop.cld.colour_clip(this.prop);
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
               this.drawCeiling();
            }
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
      
      public function rescaleProp(param1:Number) : void
      {
         if(this.prop && this.prop is PropShape == false)
         {
            this.prop.scaleX = this.prop.scaleY = param1;
         }
      }
      
      override public function resized(param1:Number = 0) : void
      {
         if(assetData && assetData["type"] == "walls")
         {
            this._ceiling = assetData["ceiling"];
            this.drawCeiling();
         }
      }
      
      public function drawCeiling() : void
      {
         if(debug)
         {
            trace("--ComicPropAsset.drawCeiling()--");
         }
         if(this._ceiling == false)
         {
            if(this.ceiling_sprite)
            {
               this.ceiling_sprite.graphics.clear();
            }
            return;
         }
         if(this.ceiling_sprite == null)
         {
            this.ceiling_init();
         }
         this.ceiling_sprite.graphics.clear();
         this.cacheAsBitmap = false;
         var _loc1_:Rectangle = this.prop.getBounds(this);
         var _loc2_:Point = this.parent.localToGlobal(new Point(-650,-650));
         _loc2_ = this.ceiling_sprite.globalToLocal(_loc2_);
         var _loc3_:Point = this.parent.localToGlobal(new Point(650,-650));
         _loc3_ = this.ceiling_sprite.globalToLocal(_loc3_);
         var _loc4_:Point = this.parent.localToGlobal(new Point(-650,650));
         _loc4_ = this.ceiling_sprite.globalToLocal(_loc4_);
         var _loc5_:Point = this.parent.localToGlobal(new Point(650,650));
         _loc5_ = this.ceiling_sprite.globalToLocal(_loc5_);
         this.ceiling_sprite.graphics.lineStyle(0,0,1);
         this.ceiling_sprite.graphics.beginFill(13224393);
         this.ceiling_sprite.graphics.moveTo(_loc2_.x,_loc2_.y);
         this.ceiling_sprite.graphics.lineTo(_loc1_.x,_loc1_.y);
         this.ceiling_sprite.graphics.lineTo(_loc1_.x + _loc1_.width,_loc1_.y);
         this.ceiling_sprite.graphics.lineTo(_loc3_.x,_loc3_.y);
         this.ceiling_sprite.graphics.lineTo(_loc2_.x,_loc3_.y);
         this.ceiling_sprite.graphics.moveTo(_loc2_.x,_loc2_.y);
         this.ceiling_sprite.graphics.lineTo(_loc4_.x,_loc4_.y);
         this.ceiling_sprite.graphics.lineTo(_loc1_.x,_loc1_.y + _loc1_.height);
         this.ceiling_sprite.graphics.lineTo(_loc1_.x,_loc1_.y);
         this.ceiling_sprite.graphics.lineTo(_loc2_.x,_loc2_.y);
         this.ceiling_sprite.graphics.moveTo(_loc3_.x,_loc3_.y);
         this.ceiling_sprite.graphics.lineTo(_loc5_.x,_loc5_.y);
         this.ceiling_sprite.graphics.lineTo(_loc1_.x + _loc1_.width,_loc1_.y + _loc1_.height);
         this.ceiling_sprite.graphics.lineTo(_loc1_.x + _loc1_.width,_loc1_.y);
         this.ceiling_sprite.graphics.lineTo(_loc3_.x,_loc3_.y);
         if(this._ceiling_colour != -1)
         {
            this.colorCeiling(this._ceiling_colour);
         }
         this.ceiling_fc.visible = true;
      }
      
      override public function set_filters(param1:Object) : void
      {
      }
      
      override public function set_panelMatrix(param1:ColorMatrix) : void
      {
      }
      
      public function colorCeiling(param1:Number) : void
      {
         this._ceiling_colour = param1;
         if(this.ceiling_sprite == null)
         {
            return;
         }
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = this._ceiling_colour;
         _loc2_.redOffset = _loc2_.redOffset + -255;
         _loc2_.greenOffset = _loc2_.greenOffset + -255;
         _loc2_.blueOffset = _loc2_.blueOffset + -255;
         _loc2_.redMultiplier = 1;
         _loc2_.greenMultiplier = 1;
         _loc2_.blueMultiplier = 1;
         this.ceiling_sprite.transform.colorTransform = _loc2_;
      }
      
      public function get ceiling() : Boolean
      {
         return this._ceiling;
      }
      
      public function set ceiling(param1:Boolean) : void
      {
         if(debug)
         {
            trace("--ComicPropAsset.setCeiling(" + param1 + ")--");
         }
         assetData["ceiling"] = param1;
         this._ceiling = param1;
         this.drawCeiling();
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
   }
}
