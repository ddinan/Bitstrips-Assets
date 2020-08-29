package com.bitstrips.character
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import ws.tink.display.HitTest;
   
   public class HeadPiece extends Sprite
   {
       
      
      public var x_sym:HeadPiece;
      
      private var _scale_y:Number = 1;
      
      private var _scale_x:Number = 1;
      
      public var piece_id:String;
      
      public var masky:HeadPiece;
      
      public var y_locked:Boolean;
      
      public var locked:Array;
      
      public var over_check_piece:HeadPiece;
      
      public var art_type:String;
      
      public var x_scales:Array;
      
      public var masker:HeadPiece;
      
      public var selected:Boolean = false;
      
      private var my_frame:int = 0;
      
      private var art_lines:Shape;
      
      public var x_locked:Boolean;
      
      public var masker2:HeadPiece;
      
      public var depth:Number;
      
      public var masky2:HeadPiece;
      
      public var _flipped:int = 1;
      
      public var over:Boolean = false;
      
      public var head:Head;
      
      public var b:Boolean;
      
      private var _no_lines:Boolean = false;
      
      public var artwork:Object;
      
      public var art_id:String;
      
      public function HeadPiece(param1:String, param2:String, param3:Head)
      {
         super();
         this.piece_id = param1;
         this.art_type = param2;
         art_lines = new Shape();
         addChild(art_lines);
         head = param3;
      }
      
      public function get no_lines() : Boolean
      {
         return _no_lines;
      }
      
      public function set no_lines(param1:Boolean) : void
      {
         _no_lines = param1;
         draw_lines();
      }
      
      public function set flipped(param1:Boolean) : void
      {
         if(param1)
         {
            _flipped = -1;
         }
         else
         {
            _flipped = 1;
         }
         update_scales();
      }
      
      public function get flipped() : Boolean
      {
         if(_flipped == -1)
         {
            return true;
         }
         return false;
      }
      
      public function set scale_y(param1:Number) : void
      {
         _scale_y = param1;
         update_scales();
      }
      
      public function scale_xy(param1:Number, param2:Number) : void
      {
         _scale_x = param1;
         _scale_y = param2;
         update_scales();
      }
      
      public function set_art(param1:Object, param2:String = "") : void
      {
         var _loc4_:HeadPiece = null;
         if(head && head.library != null)
         {
            head.ppd.set_art_id(piece_id,param2);
         }
         art_id = param2;
         if(param2 == "_blank" || param1 == null)
         {
            if(artwork != null)
            {
               removeChild(DisplayObject(artwork));
               artwork = null;
            }
            visible = false;
            return;
         }
         visible = true;
         var _loc3_:uint = 1;
         if(artwork != null)
         {
            _loc3_ = artwork.currentFrame;
            param1.ignore_lines = artwork.ignore_lines;
            removeChild(DisplayObject(artwork));
         }
         else
         {
            _loc3_ = head.get_piece_frame(this.piece_id);
         }
         artwork = param1;
         if(artwork == null)
         {
            trace(piece_id + " - " + "NULL ART");
            art_lines.visible = false;
            return;
         }
         param1.tabEnabled = param1.tabChildren = false;
         addChild(DisplayObject(artwork));
         setChildIndex(art_lines,numChildren - 1);
         if(piece_id == "hair_front" && param2 != "_blank")
         {
            _loc4_ = head.get_piece("forehead");
            if(_loc4_)
            {
               _scale_x = _loc4_.scale_x;
               _scale_y = _loc4_.scale_y;
               update_scales();
               save_mod();
            }
         }
         artwork.set_new_frame_func(new_frame_func);
         go_to_frame(_loc3_);
         scale_x = _scale_x;
      }
      
      public function center_point_stage() : Point
      {
         var _loc1_:Rectangle = this.getBounds(stage);
         return new Point(_loc1_.x + _loc1_.width / 2,_loc1_.y + _loc1_.height / 2);
      }
      
      private function update_scales() : void
      {
         if(artwork)
         {
            artwork.scaleX = _scale_x * _flipped;
            artwork.scaleY = _scale_y;
         }
         draw_lines();
      }
      
      public function update_masks() : Boolean
      {
         var _loc1_:Boolean = false;
         if(art_id == "_blank")
         {
            return false;
         }
         if(masky && artwork)
         {
            masky.mask = MovieClip(artwork).m_mask;
            _loc1_ = true;
         }
         if(masker && masker.artwork)
         {
            this.mask = MovieClip(masker.artwork).m_mask;
            _loc1_ = true;
         }
         if(masky2 && artwork)
         {
            masky2.mask = MovieClip(artwork).m_mask2;
            _loc1_ = true;
         }
         if(masker2 && masker2.artwork)
         {
            this.mask = MovieClip(masker2.artwork).m_mask2;
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public function go_to_frame(param1:Number) : uint
      {
         if(artwork == null)
         {
            return 0;
         }
         param1 = Math.min(Math.max(1,param1),artwork.totalFrames);
         my_frame = param1;
         if(artwork.currentFrame == param1)
         {
            draw_lines();
            update_masks();
            return param1;
         }
         artwork.go_to_frame(param1);
         my_frame = param1;
         draw_lines();
         artwork.addEventListener(Event.ENTER_FRAME,check_colour);
         return param1;
      }
      
      public function updated() : void
      {
         var _loc2_:Object = null;
         var _loc4_:HeadPiece = null;
         var _loc5_:HeadPiece = null;
         var _loc1_:Number = head.h_rot;
         if(piece_id == "chin")
         {
         }
         save_mod();
         var _loc3_:Object = head.ppd.get_rmod(piece_id,_loc1_,head.expression);
         if(x_sym)
         {
            _loc2_ = head.ppd.get_base(x_sym.piece_id,_loc1_,head.lipsync);
            if(_loc1_ == 0)
            {
               x_sym.x = -_loc3_.x + _loc2_.x;
            }
            x_sym.y = _loc3_.y + _loc2_.y;
            x_sym.scale_x = _loc3_.xs * _loc2_.xs;
            x_sym.scale_y = _loc3_.ys * _loc2_.ys;
            x_sym.save_mod();
            x_sym.update_locks();
            x_sym.update_masks();
         }
         if(piece_id == "forehead")
         {
            _loc4_ = head.get_piece("hair_front");
            _loc4_.x = x;
            _loc4_.y = y;
            _loc4_.scale_x = _scale_x;
            _loc4_.scale_y = _scale_y;
            _loc4_.updated();
         }
         if(x_scales)
         {
            for each(_loc5_ in x_scales)
            {
               if(_loc5_ != this)
               {
                  _loc2_ = head.ppd.get_base(_loc5_.piece_id,_loc1_,head.lipsync);
                  _loc5_.scale_x = _loc3_.xs * _loc2_.xs;
                  _loc5_.save_mod();
                  _loc5_.update_locks();
               }
            }
         }
         if(piece_id == "eye_L" || piece_id == "eye_R")
         {
            head.draw_pupils();
         }
         update_locks();
      }
      
      public function set scale_x(param1:Number) : void
      {
         _scale_x = param1;
         update_scales();
      }
      
      public function update_locks() : void
      {
         var _loc1_:HeadPiece = null;
         if(locked)
         {
            for each(_loc1_ in locked)
            {
               _loc1_.x = x;
               _loc1_.y = y;
               _loc1_.scale_x = _scale_x;
               _loc1_.scale_y = _scale_y;
            }
         }
      }
      
      public function draw_lines() : void
      {
         var _loc1_:* = null;
         var _loc2_:Array = null;
         if(artwork == null || artwork.lines == null || _no_lines)
         {
            art_lines.visible = false;
            return;
         }
         art_lines.visible = true;
         art_lines.graphics.clear();
         for(_loc1_ in artwork.lines)
         {
            art_lines.graphics.lineStyle(Number(_loc1_));
            for each(_loc2_ in artwork.lines[_loc1_][my_frame - 1])
            {
               art_lines.graphics.moveTo(_loc2_[0] * _scale_x * _flipped,_loc2_[1] * _scale_y);
               art_lines.graphics.curveTo(_loc2_[2] * _scale_x * _flipped,_loc2_[3] * _scale_y,_loc2_[4] * _scale_x * _flipped,_loc2_[5] * _scale_y);
            }
         }
      }
      
      public function save_mod() : void
      {
         var _loc1_:Number = head.h_rot;
         if(art_id != "_blank")
         {
            if(head.exp_save)
            {
               head.ppd.set_mod(piece_id,{
                  "x":x,
                  "y":y,
                  "xs":_scale_x,
                  "ys":_scale_y
               },_loc1_,head.expression,head.lipsync);
            }
            else
            {
               head.ppd.set_mod(piece_id,{
                  "x":x,
                  "y":y,
                  "xs":_scale_x,
                  "ys":_scale_y
               },_loc1_,1,head.lipsync);
            }
         }
      }
      
      public function get scale_x() : Number
      {
         return _scale_x;
      }
      
      public function get scale_y() : Number
      {
         return _scale_y;
      }
      
      private function new_frame_func(param1:MovieClip) : void
      {
         if(art_id == "_blank")
         {
            param1.removeEventListener(Event.ENTER_FRAME,check_colour);
            return;
         }
         update_masks();
         var _loc2_:int = head.cld.colour_clip(param1);
         if(_loc2_ != -1)
         {
            if(my_frame && my_frame == param1.currentFrame)
            {
               param1.removeEventListener(Event.ENTER_FRAME,check_colour);
            }
            else if(my_frame == 0)
            {
               param1.removeEventListener(Event.ENTER_FRAME,check_colour);
            }
            param1.gotoAndStop(my_frame);
         }
         head.bdat_update();
      }
      
      public function center_point_head() : Point
      {
         var _loc1_:Rectangle = this.getBounds(head);
         return new Point(_loc1_.x + _loc1_.width / 2,_loc1_.y + _loc1_.height / 2);
      }
      
      public function over_check() : Boolean
      {
         if(over_check_piece)
         {
            return HitTest.complexHitTestObject(Sprite(this),over_check_piece);
         }
         return false;
      }
      
      private function check_colour(param1:Event) : void
      {
         new_frame_func(MovieClip(param1.currentTarget));
      }
   }
}
