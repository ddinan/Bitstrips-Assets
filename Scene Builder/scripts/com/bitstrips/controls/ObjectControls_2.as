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
       
      
      private var buttons:Array;
      
      private var _enabled:Boolean = true;
      
      private var rot_prop:Object;
      
      private var debug:Boolean = false;
      
      private var ui:ObjectControlsUI;
      
      private var comic:Comic;
      
      public var prop:Object;
      
      private var al:ArtLoader;
      
      private var _comic_prop:ComicPropAsset;
      
      private var myGradientBox:GradientBox3;
      
      private var colour_clips:Array;
      
      public function ObjectControls(param1:Comic = null)
      {
         var new_comic:Comic = param1;
         colour_clips = [];
         super();
         comic = new_comic;
         al = ArtLoader.getInstance();
         ui = new ObjectControlsUI();
         addChild(ui);
         buttons = new Array();
         var i:uint = 0;
         while(i < 26)
         {
            buttons[i] = new Sprite();
            buttons[i].name = i;
            buttons[i].addEventListener(MouseEvent.CLICK,function(param1:Event):void
            {
               state_click(param1.currentTarget.name);
            });
            buttons[i].visible = false;
            buttons[i].buttonMode = true;
            buttons[i].graphics.beginFill(0,0);
            buttons[i].graphics.drawRect(0,0,50,85);
            buttons[i].graphics.endFill();
            buttons[i].x = i * 50 + 10;
            buttons[i].buttonMode = true;
            Utils.over_out(buttons[i]);
            ui.state_buttons.addChild(buttons[i]);
            i = i + 1;
         }
         BSConstants.tf_fix(ui.colour);
         ui.colour.text = _("Color");
         ui.prop_inc.addEventListener(MouseEvent.CLICK,rotate_left);
         ui.prop_dec.addEventListener(MouseEvent.CLICK,rotate_right);
         ui.ceiling_mc.visible = false;
         ui.ceiling_mc.buttonMode = true;
         ui.ceiling_mc.addEventListener(MouseEvent.CLICK,toggleCeiling);
         myGradientBox = new GradientBox3();
         myGradientBox.x = ui.colourBox_area_mc.x;
         myGradientBox.y = ui.colourBox_area_mc.y;
         addChild(myGradientBox);
         myGradientBox.addEventListener("COLOUR_OVER",setColour);
         myGradientBox.addEventListener("SELECTED",setColour);
         disable();
      }
      
      private function enable() : void
      {
         Utils.enable_shade(this);
      }
      
      private function ceiling_checkbox() : void
      {
         if(_comic_prop.ceiling)
         {
            ui.ceiling_mc.check_mc.gotoAndStop(2);
         }
         else
         {
            ui.ceiling_mc.check_mc.gotoAndStop(1);
         }
      }
      
      private function update_centers() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:Point = get_scaling();
         rot_prop.scaleX = _loc1_.x;
         rot_prop.scaleY = _loc1_.y;
         Utils.center_piece(rot_prop,ui.rotate_prop,107 / 2,85 / 2);
         var _loc2_:uint = 0;
         while(_loc2_ <= prop.states)
         {
            _loc3_ = buttons[_loc2_].getChildAt(0);
            _loc3_.scaleX = _loc1_.x;
            _loc3_.scaleY = _loc1_.y;
            Utils.center_piece(_loc3_,buttons[_loc2_],50 / 2,85 / 2);
            _loc2_ = _loc2_ + 1;
         }
      }
      
      private function setColour(param1:Event) : void
      {
         trace("--object_controls.setColour(" + myGradientBox.colour + ")--");
         if(comic && prop)
         {
            comic.pre_undo();
         }
         if(prop && prop.base_colour)
         {
            prop.cld.set_colour(prop.base_colour,myGradientBox.colour);
            prop.cld.colour_clip(prop);
            prop.pass_colour(myGradientBox.colour);
            update_colours();
         }
      }
      
      private function toggleCeiling(param1:MouseEvent) : void
      {
         _comic_prop.ceiling = !_comic_prop.ceiling;
         ceiling_checkbox();
      }
      
      private function state_click(param1:String) : void
      {
         var _loc2_:Number = Number(param1);
         if(comic && prop)
         {
            comic.pre_undo();
         }
         if(prop)
         {
            prop.state = _loc2_;
         }
         if(rot_prop)
         {
            rot_prop.state = _loc2_;
         }
         update_centers();
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      private function get_scaling() : Point
      {
         var _loc4_:DisplayObject = null;
         Utils.scale_me(DisplayObject(rot_prop),45,70);
         var _loc1_:Number = rot_prop.scaleX;
         var _loc2_:Number = rot_prop.scaleY;
         var _loc3_:uint = 0;
         while(_loc3_ <= prop.states)
         {
            _loc4_ = buttons[_loc3_].getChildAt(0);
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
      
      public function register(param1:ComicPropAsset) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         if(debug)
         {
            trace("Hidding old buttons");
         }
         var _loc2_:uint = 0;
         while(_loc2_ < buttons.length)
         {
            buttons[_loc2_].visible = false;
            if(buttons[_loc2_].numChildren > 0)
            {
               buttons[_loc2_].removeChildAt(0);
            }
            _loc2_ = _loc2_ + 1;
         }
         prop = null;
         _comic_prop = null;
         if(param1)
         {
            prop = param1.prop;
            _comic_prop = param1;
         }
         ui.ceiling_mc.visible = false;
         if(param1)
         {
            if(debug)
            {
               trace("Register: " + param1.name);
            }
            if(debug)
            {
               trace("Testing rot_prop");
            }
            if(rot_prop)
            {
               if(ui.rotate_prop.contains(DisplayObject(rot_prop)))
               {
                  ui.rotate_prop.removeChild(DisplayObject(rot_prop));
               }
            }
            if(debug)
            {
               trace(prop.type + " " + prop.name);
            }
            rot_prop = al.get_prop(prop.type,prop.name);
            ui.rotate_prop.addChild(DisplayObject(rot_prop));
            rot_prop.set_rotation(prop.prop_rotation);
            rot_prop.state = prop.state;
            colour_clips = [rot_prop];
            _loc3_ = 1;
            if(prop.states > 10)
            {
               _loc3_ = 10 / (prop.states + 1);
            }
            _loc2_ = 0;
            while(_loc2_ <= prop.states)
            {
               _loc4_ = al.get_prop(prop.type,prop.name);
               _loc4_.set_rotation(prop.prop_rotation);
               _loc4_.state = _loc2_;
               colour_clips.push(_loc4_);
               buttons[_loc2_].addChild(_loc4_);
               buttons[_loc2_].visible = true;
               if(buttons[_loc2_].scaleX != _loc3_)
               {
                  buttons[_loc2_].scaleX = buttons[_loc2_].scaleY = _loc3_;
                  buttons[_loc2_].x = _loc2_ * 50 * _loc3_ + 10 * _loc3_;
               }
               _loc2_ = _loc2_ + 1;
            }
            update_colours();
            update_centers();
            if(_comic_prop.asset_type == "walls")
            {
               ui.ceiling_mc.visible = true;
               ceiling_checkbox();
            }
         }
         else
         {
            prop = undefined;
            if(rot_prop)
            {
               ui.rotate_prop.removeChild(DisplayObject(rot_prop));
            }
            rot_prop = undefined;
         }
         if(prop == null)
         {
            colour_clips = [];
            disable();
         }
         else
         {
            enable();
            if(prop.states == 0)
            {
               Utils.disable_shade(ui.state_buttons);
            }
            else
            {
               Utils.enable_shade(ui.state_buttons);
            }
            if(prop.rotations == 0)
            {
               ui.prop_dec.visible = ui.prop_inc.visible = false;
            }
            else
            {
               ui.prop_dec.visible = ui.prop_inc.visible = true;
            }
            if(prop.base_colour)
            {
               _loc5_ = prop.cld.get_colour(prop.base_colour);
               if(_loc5_ == -1 && prop.base_colour != "ffffff")
               {
                  _loc5_ = int("0x" + prop.base_colour);
               }
               myGradientBox.set_colour(_loc5_);
            }
         }
      }
      
      private function update_colours() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Number = -1;
         if(prop.base_colour)
         {
            _loc1_ = prop.cld.get_colour(prop.base_colour);
            if(_loc1_ >= 0)
            {
               _loc2_ = 0;
               while(_loc2_ < colour_clips.length)
               {
                  colour_clips[_loc2_].cld.set_colour(prop.base_colour,_loc1_);
                  colour_clips[_loc2_].cld.colour_clip(colour_clips[_loc2_]);
                  _loc2_++;
               }
            }
         }
      }
      
      private function rotate_left(param1:Event) : void
      {
         if(comic && prop)
         {
            comic.pre_undo();
         }
         if(prop)
         {
            prop.rotate_left();
         }
         if(rot_prop)
         {
            rot_prop.rotate_left();
         }
         var _loc2_:uint = 0;
         while(_loc2_ <= prop.states)
         {
            buttons[_loc2_].getChildAt(0).rotate_left();
            _loc2_ = _loc2_ + 1;
         }
         update_centers();
      }
      
      private function disable() : void
      {
         Utils.disable_shade(this);
      }
      
      private function rotate_right(param1:Event) : void
      {
         if(comic && prop)
         {
            comic.pre_undo();
         }
         if(prop)
         {
            prop.rotate_right();
         }
         if(rot_prop)
         {
            rot_prop.rotate_right();
         }
         var _loc2_:uint = 0;
         while(_loc2_ <= prop.states)
         {
            buttons[_loc2_].getChildAt(0).rotate_right();
            _loc2_ = _loc2_ + 1;
         }
         update_centers();
      }
   }
}
