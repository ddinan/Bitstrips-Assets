package com.bitstrips.controls
{
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.bitstrips.Utils;
   import com.bitstrips.character.ComicPropAsset;
   import com.bitstrips.comicbuilder.Comic;
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.ui.GradientBox3;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ObjectControls extends Sprite
   {
       
      
      private var comic:Comic;
      
      private var ui:ObjectControlsUI;
      
      private var _enabled:Boolean = true;
      
      private var myGradientBox:GradientBox3;
      
      private var al:ArtLoader;
      
      public var prop:Object;
      
      private var rot_prop:Object;
      
      private var buttons:Array;
      
      private var debug:Boolean = false;
      
      private var colour_clips:Array;
      
      private var _comic_prop:ComicPropAsset;
      
      public function ObjectControls(param1:Comic = null)
      {
         var new_comic:Comic = param1;
         this.colour_clips = [];
         super();
         this.comic = new_comic;
         this.al = ArtLoader.getInstance();
         this.ui = new ObjectControlsUI();
         addChild(this.ui);
         this.buttons = new Array();
         var i:uint = 0;
         while(i < 26)
         {
            this.buttons[i] = new Sprite();
            this.buttons[i].name = i;
            this.buttons[i].addEventListener(MouseEvent.CLICK,function(param1:Event):void
            {
               state_click(param1.currentTarget.name);
            });
            this.buttons[i].visible = false;
            this.buttons[i].buttonMode = true;
            this.buttons[i].graphics.beginFill(0,0);
            this.buttons[i].graphics.drawRect(0,0,50,85);
            this.buttons[i].graphics.endFill();
            this.buttons[i].x = i * 50 + 10;
            this.buttons[i].buttonMode = true;
            Utils.over_out(this.buttons[i]);
            this.ui.state_buttons.addChild(this.buttons[i]);
            i = i + 1;
         }
         BSConstants.tf_fix(this.ui.colour);
         this.ui.colour.text = this._("Color");
         this.ui.prop_inc.addEventListener(MouseEvent.CLICK,this.rotate_left);
         this.ui.prop_dec.addEventListener(MouseEvent.CLICK,this.rotate_right);
         this.ui.ceiling_mc.visible = false;
         this.ui.ceiling_mc.buttonMode = true;
         this.ui.ceiling_mc.addEventListener(MouseEvent.CLICK,this.toggleCeiling);
         this.myGradientBox = new GradientBox3();
         this.myGradientBox.x = this.ui.colourBox_area_mc.x;
         this.myGradientBox.y = this.ui.colourBox_area_mc.y;
         addChild(this.myGradientBox);
         this.myGradientBox.addEventListener("COLOUR_OVER",this.setColour);
         this.myGradientBox.addEventListener("SELECTED",this.setColour);
         this.disable();
      }
      
      private function ceiling_checkbox() : void
      {
         if(this._comic_prop.ceiling)
         {
            this.ui.ceiling_mc.check_mc.gotoAndStop(2);
         }
         else
         {
            this.ui.ceiling_mc.check_mc.gotoAndStop(1);
         }
      }
      
      private function toggleCeiling(param1:MouseEvent) : void
      {
         this._comic_prop.ceiling = !this._comic_prop.ceiling;
         this.ceiling_checkbox();
      }
      
      private function disable() : void
      {
         Utils.disable_shade(this);
      }
      
      private function enable() : void
      {
         Utils.enable_shade(this);
      }
      
      public function register(param1:ComicPropAsset) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         if(this.debug)
         {
            trace("Hidding old buttons");
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.buttons.length)
         {
            this.buttons[_loc2_].visible = false;
            if(this.buttons[_loc2_].numChildren > 0)
            {
               this.buttons[_loc2_].removeChildAt(0);
            }
            _loc2_ = _loc2_ + 1;
         }
         this.prop = null;
         this._comic_prop = null;
         if(param1)
         {
            this.prop = param1.prop;
            this._comic_prop = param1;
         }
         this.ui.ceiling_mc.visible = false;
         if(param1)
         {
            if(this.debug)
            {
               trace("Register: " + param1.name);
            }
            if(this.debug)
            {
               trace("Testing rot_prop");
            }
            if(this.rot_prop)
            {
               if(this.ui.rotate_prop.contains(DisplayObject(this.rot_prop)))
               {
                  this.ui.rotate_prop.removeChild(DisplayObject(this.rot_prop));
               }
            }
            if(this.debug)
            {
               trace(this.prop.type + " " + this.prop.name);
            }
            this.rot_prop = this.al.get_prop(this.prop.type,this.prop.name);
            this.ui.rotate_prop.addChild(DisplayObject(this.rot_prop));
            this.rot_prop.set_rotation(this.prop.prop_rotation);
            this.rot_prop.state = this.prop.state;
            this.colour_clips = [this.rot_prop];
            _loc3_ = 1;
            if(this.prop.states > 10)
            {
               _loc3_ = 10 / (this.prop.states + 1);
            }
            _loc2_ = 0;
            while(_loc2_ <= this.prop.states)
            {
               _loc4_ = this.al.get_prop(this.prop.type,this.prop.name);
               _loc4_.set_rotation(this.prop.prop_rotation);
               _loc4_.state = _loc2_;
               this.colour_clips.push(_loc4_);
               this.buttons[_loc2_].addChild(_loc4_);
               this.buttons[_loc2_].visible = true;
               if(this.buttons[_loc2_].scaleX != _loc3_)
               {
                  this.buttons[_loc2_].scaleX = this.buttons[_loc2_].scaleY = _loc3_;
                  this.buttons[_loc2_].x = _loc2_ * 50 * _loc3_ + 10 * _loc3_;
               }
               _loc2_ = _loc2_ + 1;
            }
            this.update_colours();
            this.update_centers();
            if(this._comic_prop.asset_type == "walls")
            {
               this.ui.ceiling_mc.visible = true;
               this.ceiling_checkbox();
            }
         }
         else
         {
            this.prop = undefined;
            if(this.rot_prop)
            {
               this.ui.rotate_prop.removeChild(DisplayObject(this.rot_prop));
            }
            this.rot_prop = undefined;
         }
         if(this.prop == null)
         {
            this.colour_clips = [];
            this.disable();
         }
         else
         {
            this.enable();
            if(this.prop.states == 0)
            {
               Utils.disable_shade(this.ui.state_buttons);
            }
            else
            {
               Utils.enable_shade(this.ui.state_buttons);
            }
            if(this.prop.rotations == 0)
            {
               this.ui.prop_dec.visible = this.ui.prop_inc.visible = false;
            }
            else
            {
               this.ui.prop_dec.visible = this.ui.prop_inc.visible = true;
            }
            if(this.prop.base_colour)
            {
               _loc5_ = this.prop.cld.get_colour(this.prop.base_colour);
               if(_loc5_ == -1 && this.prop.base_colour != "ffffff")
               {
                  _loc5_ = int("0x" + this.prop.base_colour);
               }
               this.myGradientBox.set_colour(_loc5_);
            }
         }
      }
      
      private function update_colours() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Number = -1;
         if(this.prop.base_colour)
         {
            _loc1_ = this.prop.cld.get_colour(this.prop.base_colour);
            if(_loc1_ >= 0)
            {
               _loc2_ = 0;
               while(_loc2_ < this.colour_clips.length)
               {
                  this.colour_clips[_loc2_].cld.set_colour(this.prop.base_colour,_loc1_);
                  this.colour_clips[_loc2_].cld.colour_clip(this.colour_clips[_loc2_]);
                  _loc2_++;
               }
            }
         }
      }
      
      private function get_scaling() : Point
      {
         var _loc4_:DisplayObject = null;
         Utils.scale_me(DisplayObject(this.rot_prop),45,70);
         var _loc1_:Number = this.rot_prop.scaleX;
         var _loc2_:Number = this.rot_prop.scaleY;
         var _loc3_:uint = 0;
         while(_loc3_ <= this.prop.states)
         {
            _loc4_ = this.buttons[_loc3_].getChildAt(0);
            Utils.scale_me(DisplayObject(_loc4_),45,70);
            if(_loc4_.scaleX < _loc1_ || _loc4_.scaleY < _loc2_)
            {
               _loc1_ = _loc4_.scaleX;
               _loc2_ = _loc4_.scaleY;
            }
            _loc3_ = _loc3_ + 1;
         }
         return new Point(_loc1_,_loc2_);
      }
      
      private function update_centers() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:Point = this.get_scaling();
         this.rot_prop.scaleX = _loc1_.x;
         this.rot_prop.scaleY = _loc1_.y;
         Utils.center_piece(this.rot_prop,this.ui.rotate_prop,107 / 2,85 / 2);
         var _loc2_:uint = 0;
         while(_loc2_ <= this.prop.states)
         {
            _loc3_ = this.buttons[_loc2_].getChildAt(0);
            _loc3_.scaleX = _loc1_.x;
            _loc3_.scaleY = _loc1_.y;
            Utils.center_piece(_loc3_,this.buttons[_loc2_],50 / 2,85 / 2);
            _loc2_ = _loc2_ + 1;
         }
      }
      
      private function state_click(param1:String) : void
      {
         var _loc2_:Number = Number(param1);
         if(this.comic && this.prop)
         {
            this.comic.pre_undo();
         }
         if(this.prop)
         {
            this.prop.state = _loc2_;
         }
         if(this.rot_prop)
         {
            this.rot_prop.state = _loc2_;
         }
         this.update_centers();
      }
      
      private function rotate_left(param1:Event) : void
      {
         if(this.comic && this.prop)
         {
            this.comic.pre_undo();
         }
         if(this.prop)
         {
            this.prop.rotate_left();
         }
         if(this.rot_prop)
         {
            this.rot_prop.rotate_left();
         }
         var _loc2_:uint = 0;
         while(_loc2_ <= this.prop.states)
         {
            this.buttons[_loc2_].getChildAt(0).rotate_left();
            _loc2_ = _loc2_ + 1;
         }
         this.update_centers();
      }
      
      private function rotate_right(param1:Event) : void
      {
         if(this.comic && this.prop)
         {
            this.comic.pre_undo();
         }
         if(this.prop)
         {
            this.prop.rotate_right();
         }
         if(this.rot_prop)
         {
            this.rot_prop.rotate_right();
         }
         var _loc2_:uint = 0;
         while(_loc2_ <= this.prop.states)
         {
            this.buttons[_loc2_].getChildAt(0).rotate_right();
            _loc2_ = _loc2_ + 1;
         }
         this.update_centers();
      }
      
      private function setColour(param1:Event) : void
      {
         trace("--object_controls.setColour(" + this.myGradientBox.colour + ")--");
         if(this.comic && this.prop)
         {
            this.comic.pre_undo();
         }
         if(this.prop && this.prop.base_colour)
         {
            this.prop.cld.set_colour(this.prop.base_colour,this.myGradientBox.colour);
            this.prop.cld.colour_clip(this.prop);
            this.prop.pass_colour(this.myGradientBox.colour);
            this.update_colours();
         }
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
   }
}
