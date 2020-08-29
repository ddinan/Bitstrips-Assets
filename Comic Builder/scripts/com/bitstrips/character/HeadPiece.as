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
       
      
      public var masky:HeadPiece;
      
      public var masky2:HeadPiece;
      
      public var masker:HeadPiece;
      
      public var masker2:HeadPiece;
      
      public var artwork:Object;
      
      private var art_lines:Shape;
      
      public var art_type:String;
      
      public var art_id:String;
      
      public var piece_id:String;
      
      public var over_check_piece:HeadPiece;
      
      public var depth:Number;
      
      public var b:Boolean;
      
      public var locked:Vector.<HeadPiece>;
      
      public var x_locked:Boolean;
      
      public var y_locked:Boolean;
      
      public var x_scales:Vector.<HeadPiece>;
      
      public var selected:Boolean = false;
      
      public var over:Boolean = false;
      
      public var _flipped:int = 1;
      
      private var _no_lines:Boolean = false;
      
      public var head:Head;
      
      public var x_sym:HeadPiece;
      
      private var my_frame:int = 0;
      
      private var _scale_x:Number = 1;
      
      private var _scale_y:Number = 1;
      
      public function HeadPiece(param1:String, param2:String, param3:Head)
      {
         super();
         this.piece_id = param1;
         this.art_type = param2;
         this.art_lines = new Shape();
         addChild(this.art_lines);
         this.head = param3;
      }
      
      public function get no_lines() : Boolean
      {
         return this._no_lines;
      }
      
      public function set no_lines(param1:Boolean) : void
      {
         this._no_lines = param1;
         this.draw_lines();
      }
      
      public function get flipped() : Boolean
      {
         if(this._flipped == -1)
         {
            return true;
         }
         return false;
      }
      
      public function set flipped(param1:Boolean) : void
      {
         if(param1)
         {
            this._flipped = -1;
         }
         else
         {
            this._flipped = 1;
         }
         this.update_scales();
      }
      
      public function over_check() : Boolean
      {
         if(this.over_check_piece)
         {
            return HitTest.complexHitTestObject(Sprite(this),this.over_check_piece);
         }
         return false;
      }
      
      public function set_art(param1:Object, param2:String = "") : void
      {
         var _loc4_:HeadPiece = null;
         if(this.head && this.head.library != null)
         {
            this.head.ppd.set_art_id(this.piece_id,param2);
         }
         this.art_id = param2;
         if(param2 == "_blank" || param1 == null)
         {
            if(this.artwork != null)
            {
               removeChild(DisplayObject(this.artwork));
               this.artwork = null;
            }
            visible = false;
            return;
         }
         visible = true;
         var _loc3_:uint = 1;
         if(this.artwork != null)
         {
            _loc3_ = this.artwork.currentFrame;
            param1.ignore_lines = this.artwork.ignore_lines;
            removeChild(DisplayObject(this.artwork));
         }
         else
         {
            _loc3_ = this.head.get_piece_frame(this.piece_id);
         }
         this.artwork = param1;
         if(this.artwork == null)
         {
            trace(this.piece_id + " - " + "NULL ART");
            this.art_lines.visible = false;
            return;
         }
         param1.tabEnabled = param1.tabChildren = false;
         addChild(DisplayObject(this.artwork));
         setChildIndex(this.art_lines,numChildren - 1);
         if(this.piece_id == "hair_front" && param2 != "_blank")
         {
            _loc4_ = this.head.get_piece("forehead");
            if(_loc4_)
            {
               this._scale_x = _loc4_.scale_x;
               this._scale_y = _loc4_.scale_y;
               this.update_scales();
               this.save_mod();
            }
         }
         this.artwork.set_new_frame_func(this.new_frame_func);
         this.go_to_frame(_loc3_);
         this.scale_x = this._scale_x;
      }
      
      public function update_masks() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.art_id == "_blank")
         {
            return false;
         }
         if(this.masky && this.artwork)
         {
            this.masky.mask = MovieClip(this.artwork).m_mask;
            _loc1_ = true;
         }
         if(this.masker && this.masker.artwork)
         {
            this.mask = MovieClip(this.masker.artwork).m_mask;
            _loc1_ = true;
         }
         if(this.masky2 && this.artwork)
         {
            this.masky2.mask = MovieClip(this.artwork).m_mask2;
            _loc1_ = true;
         }
         if(this.masker2 && this.masker2.artwork)
         {
            this.mask = MovieClip(this.masker2.artwork).m_mask2;
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      private function check_colour(param1:Event) : void
      {
         this.new_frame_func(MovieClip(param1.currentTarget));
      }
      
      private function new_frame_func(param1:MovieClip) : void
      {
         if(this.art_id == "_blank")
         {
            param1.removeEventListener(Event.ENTER_FRAME,this.check_colour);
            return;
         }
         this.update_masks();
         var _loc2_:int = this.head.cld.colour_clip(param1);
         if(_loc2_ != -1)
         {
            if(this.my_frame && this.my_frame == param1.currentFrame)
            {
               param1.removeEventListener(Event.ENTER_FRAME,this.check_colour);
            }
            else if(this.my_frame == 0)
            {
               param1.removeEventListener(Event.ENTER_FRAME,this.check_colour);
            }
            param1.gotoAndStop(this.my_frame);
         }
         this.head.bdat_update();
      }
      
      public function go_to_frame(param1:Number) : uint
      {
         if(this.artwork == null)
         {
            return 0;
         }
         param1 = Math.min(Math.max(1,param1),this.artwork.totalFrames);
         this.my_frame = param1;
         if(this.artwork.currentFrame == param1)
         {
            this.draw_lines();
            this.update_masks();
            return param1;
         }
         this.artwork.go_to_frame(param1);
         this.my_frame = param1;
         this.draw_lines();
         this.artwork.addEventListener(Event.ENTER_FRAME,this.check_colour,false,0,true);
         return param1;
      }
      
      public function draw_lines() : void
      {
         var _loc1_:* = null;
         var _loc2_:Array = null;
         if(this.artwork == null || this.artwork.lines == null || this._no_lines)
         {
            this.art_lines.visible = false;
            return;
         }
         this.art_lines.visible = true;
         this.art_lines.graphics.clear();
         for(_loc1_ in this.artwork.lines)
         {
            this.art_lines.graphics.lineStyle(Number(_loc1_));
            for each(_loc2_ in this.artwork.lines[_loc1_][this.my_frame - 1])
            {
               this.art_lines.graphics.moveTo(_loc2_[0] * this._scale_x * this._flipped,_loc2_[1] * this._scale_y);
               this.art_lines.graphics.curveTo(_loc2_[2] * this._scale_x * this._flipped,_loc2_[3] * this._scale_y,_loc2_[4] * this._scale_x * this._flipped,_loc2_[5] * this._scale_y);
            }
         }
      }
      
      public function set scale_x(param1:Number) : void
      {
         this._scale_x = param1;
         this.update_scales();
      }
      
      public function set scale_y(param1:Number) : void
      {
         this._scale_y = param1;
         this.update_scales();
      }
      
      public function scale_xy(param1:Number, param2:Number) : void
      {
         this._scale_x = param1;
         this._scale_y = param2;
         this.update_scales();
      }
      
      private function update_scales() : void
      {
         if(this.artwork)
         {
            this.artwork.scaleX = this._scale_x * this._flipped;
            this.artwork.scaleY = this._scale_y;
         }
         this.draw_lines();
      }
      
      public function get scale_x() : Number
      {
         return this._scale_x;
      }
      
      public function get scale_y() : Number
      {
         return this._scale_y;
      }
      
      public function center_point_head() : Point
      {
         var _loc1_:Rectangle = this.getBounds(this.head);
         return new Point(_loc1_.x + _loc1_.width / 2,_loc1_.y + _loc1_.height / 2);
      }
      
      public function center_point_stage() : Point
      {
         var _loc1_:Rectangle = this.getBounds(stage);
         return new Point(_loc1_.x + _loc1_.width / 2,_loc1_.y + _loc1_.height / 2);
      }
      
      public function update_locks() : void
      {
         var _loc1_:HeadPiece = null;
         if(this.locked)
         {
            for each(_loc1_ in this.locked)
            {
               _loc1_.x = x;
               _loc1_.y = y;
               _loc1_.scale_x = this._scale_x;
               _loc1_.scale_y = this._scale_y;
            }
         }
      }
      
      public function save_mod() : void
      {
         var _loc1_:Number = this.head.h_rot;
         if(this.art_id != "_blank")
         {
            if(this.head.exp_save)
            {
               this.head.ppd.set_mod(this.piece_id,{
                  "x":x,
                  "y":y,
                  "xs":this._scale_x,
                  "ys":this._scale_y
               },_loc1_,this.head.expression,this.head.lipsync);
            }
            else
            {
               this.head.ppd.set_mod(this.piece_id,{
                  "x":x,
                  "y":y,
                  "xs":this._scale_x,
                  "ys":this._scale_y
               },_loc1_,1,this.head.lipsync);
            }
         }
      }
      
      public function updated() : void
      {
         var _loc2_:Object = null;
         var _loc4_:HeadPiece = null;
         var _loc5_:HeadPiece = null;
         var _loc1_:Number = this.head.h_rot;
         if(this.piece_id == "chin")
         {
         }
         this.save_mod();
         var _loc3_:Object = this.head.ppd.get_rmod(this.piece_id,_loc1_,this.head.expression);
         if(this.x_sym)
         {
            _loc2_ = this.head.ppd.get_base(this.x_sym.piece_id,_loc1_,this.head.lipsync);
            if(_loc1_ == 0)
            {
               this.x_sym.x = -_loc3_.x + _loc2_.x;
            }
            this.x_sym.y = _loc3_.y + _loc2_.y;
            this.x_sym.scale_x = _loc3_.xs * _loc2_.xs;
            this.x_sym.scale_y = _loc3_.ys * _loc2_.ys;
            this.x_sym.save_mod();
            this.x_sym.update_locks();
            this.x_sym.update_masks();
         }
         if(this.piece_id == "forehead")
         {
            _loc4_ = this.head.get_piece("hair_front");
            _loc4_.x = x;
            _loc4_.y = y;
            _loc4_.scale_x = this._scale_x;
            _loc4_.scale_y = this._scale_y;
            _loc4_.updated();
         }
         if(this.x_scales)
         {
            for each(_loc5_ in this.x_scales)
            {
               if(_loc5_ != this)
               {
                  _loc2_ = this.head.ppd.get_base(_loc5_.piece_id,_loc1_,this.head.lipsync);
                  _loc5_.scale_x = _loc3_.xs * _loc2_.xs;
                  _loc5_.save_mod();
                  _loc5_.update_locks();
               }
            }
         }
         if(this.piece_id == "eye_L" || this.piece_id == "eye_R")
         {
            this.head.draw_pupils();
         }
         this.update_locks();
      }
   }
}
