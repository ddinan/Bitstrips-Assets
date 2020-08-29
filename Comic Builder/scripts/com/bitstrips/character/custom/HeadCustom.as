package com.bitstrips.character.custom
{
   import com.bitstrips.character.HeadBase;
   import com.bitstrips.character.IHead;
   import com.bitstrips.character.PPData;
   import com.bitstrips.core.ColourData;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HeadCustom extends HeadBase implements IHead
   {
       
      
      public var art_clip_name:String;
      
      protected var _mouse_look:Boolean = true;
      
      protected var _lipsync:Number = 1;
      
      protected var _lids:Array;
      
      protected var _cur_expression:Number = 1;
      
      protected var mouth_expression:Number = 1;
      
      protected var piece_dict:Object;
      
      protected var _h_rot:Number = 0;
      
      protected var _cld:ColourData;
      
      protected var clip:MovieClip;
      
      protected var head_rot_inversion:int = 1;
      
      protected var pupils:Array;
      
      protected const head_scale:Number = 0.85;
      
      public function HeadCustom(param1:PPData = undefined, param2:ColourData = undefined)
      {
         this._lids = [1,1];
         this.piece_dict = new Object();
         this.pupils = [{
            "x":0,
            "y":0,
            "width":0.25
         },{
            "x":0,
            "y":0,
            "width":0.25
         }];
         super();
         this.cld = param2;
         head_back = new MovieClip();
         this.clip = new MovieClip();
      }
      
      public function set_clip(param1:MovieClip) : void
      {
         this.clip = param1;
         this.clip.scaleX = this.clip.scaleY = this.head_scale;
         this.clip.y = 6;
         addChild(this.clip);
         this.set_rotation(this.h_rot);
         this.clip.addEventListener("refresh",this.refresh_head_bits);
      }
      
      override public function update_pupils(param1:Object, param2:Object = null) : void
      {
         if(param1.width == undefined)
         {
            param1.width = 0.25;
         }
         this.pupils[0].x = param1.x;
         this.pupils[0].y = param1.y;
         this.pupils[0].width = param1.width;
         if(param2 == null)
         {
            param2 = param1;
         }
         else if(param2.width == undefined)
         {
            param2.width = 0.25;
         }
         this.pupils[1].x = param2.x;
         this.pupils[1].y = param2.y;
         this.pupils[1].width = param2.width;
         this.draw_pupils();
      }
      
      override public function draw_pupils() : void
      {
         var _loc1_:MovieClip = this.piece_dict["eye_L"];
         var _loc2_:MovieClip = this.piece_dict["pupil_L"];
         var _loc3_:MovieClip = this.piece_dict["eye_R"];
         var _loc4_:MovieClip = this.piece_dict["pupil_R"];
         if(!_loc2_)
         {
            return;
         }
         _loc2_.visible = _loc4_.visible = true;
         var _loc5_:Array = [];
         if(this.head_rot_inversion == 1)
         {
            _loc5_[0] = this.pupils[0];
            _loc5_[1] = this.pupils[1];
         }
         else
         {
            _loc5_[0] = this.pupils[1];
            _loc5_[1] = this.pupils[0];
         }
         _loc2_.height = _loc1_.height * _loc5_[0].width;
         _loc4_.height = _loc3_.height * _loc5_[1].width;
         _loc2_.scaleX = _loc2_.scaleY;
         _loc4_.scaleX = _loc4_.scaleY;
         var _loc6_:Point = this.center_point_head();
         var _loc7_:Point = this.center_point_head();
         _loc6_.y = _loc1_.y;
         _loc6_.x = _loc1_.x;
         _loc7_.y = _loc3_.y;
         _loc7_.x = _loc3_.x;
         _loc2_.x = _loc1_.width * _loc5_[0].x * this.head_rot_inversion;
         _loc2_.y = _loc6_.y + _loc1_.height * _loc5_[0].y;
         _loc4_.x = _loc3_.width * _loc5_[1].x * this.head_rot_inversion;
         _loc4_.y = _loc7_.y + _loc3_.height * _loc5_[1].y;
      }
      
      override public function center_point_head() : Point
      {
         var _loc1_:Rectangle = this.getBounds(this.parent);
         return new Point(_loc1_.x + _loc1_.width / 2,_loc1_.y + _loc1_.height / 2);
      }
      
      override public function get_pupils() : Object
      {
         return this.pupils;
      }
      
      override public function set_rotation(param1:int) : void
      {
         if(param1 > 7)
         {
            param1 = 0;
         }
         if(param1 < 0)
         {
            param1 = 7;
         }
         this._h_rot = param1;
         var _loc2_:int = Math.floor(this._h_rot);
         this.head_rot_inversion = 1;
         if(this._h_rot > 4)
         {
            _loc2_ = 4 - (this._h_rot - 4);
            this.head_rot_inversion = -1;
         }
         this.clip.gotoAndStop(_loc2_ + 1);
         this.clip.scaleX = this.head_scale * this.head_rot_inversion;
      }
      
      protected function refresh_head_bits(param1:Event) : void
      {
         if(this.clip["pupil_L"])
         {
            this.piece_dict["pupil_L"] = this.clip["pupil_L"]["pupil_mc"];
         }
         else
         {
            this.piece_dict["pupil_L"] = new MovieClip();
         }
         if(this.clip["pupil_R"])
         {
            this.piece_dict["pupil_R"] = this.clip["pupil_R"]["pupil_mc"];
         }
         else
         {
            this.piece_dict["pupil_R"] = new MovieClip();
         }
         if(this.clip["eye_L"])
         {
            this.piece_dict["eye_L"] = this.clip["eye_L"];
            this.piece_dict["eye_mask_L"] = this.clip["eye_mask_L"];
            this.piece_dict["brow_L"] = this.clip["brow_L"];
            (this.piece_dict["pupil_L"] as MovieClip).mask = this.piece_dict["eye_mask_L"] as MovieClip;
         }
         else
         {
            this.piece_dict["eye_L"] = new MovieClip();
         }
         if(this.clip["eye_R"])
         {
            this.piece_dict["eye_R"] = this.clip["eye_R"];
            this.piece_dict["eye_mask_R"] = this.clip["eye_mask_R"];
            this.piece_dict["brow_R"] = this.clip["brow_R"];
            (this.piece_dict["pupil_R"] as MovieClip).mask = this.piece_dict["eye_mask_R"] as MovieClip;
         }
         else
         {
            this.piece_dict["eye_R"] = new MovieClip();
         }
         if(this.clip["mouth"])
         {
            this.piece_dict["mouth"] = this.clip["mouth"];
         }
         else
         {
            this.piece_dict["mouth"] = new MovieClip();
         }
         this.draw_pupils();
         this.set_expression(this.cur_expression);
      }
      
      override public function set lids(param1:Array) : void
      {
         this._lids = param1;
      }
      
      override public function get lids() : Array
      {
         return this._lids;
      }
      
      override public function set_lipsync(param1:uint) : void
      {
         this.lipsync = param1;
         this.set_expression(this.cur_expression);
      }
      
      override public function set lipsync(param1:Number) : void
      {
         param1 = Math.min(param1,4);
         this._lipsync = param1;
         var _loc2_:MovieClip = this.piece_dict["mouth"] as MovieClip;
         _loc2_.gotoAndStop(_loc2_.currentFrame + (this._lipsync - 1));
      }
      
      override public function get lipsync() : Number
      {
         return this._lipsync;
      }
      
      override public function set mouse_look(param1:Boolean) : void
      {
         this._mouse_look = param1;
      }
      
      override public function get mouse_look() : Boolean
      {
         return this._mouse_look;
      }
      
      override public function set cur_expression(param1:Number) : void
      {
         this._cur_expression = param1;
      }
      
      override public function get cur_expression() : Number
      {
         return this._cur_expression;
      }
      
      override public function get h_rot() : Number
      {
         return this._h_rot;
      }
      
      override public function set h_rot(param1:Number) : void
      {
         this.set_rotation(param1);
      }
      
      override public function set_expression(param1:uint) : uint
      {
         param1 = Math.min(8,param1);
         this.cur_expression = param1;
         switch(this.cur_expression)
         {
            case 1:
               this.set_expression_eye_L(1);
               this.set_expression_eye_R(1);
               this.set_expression_mouth(1);
               break;
            case 2:
               this.set_expression_eye_L(2);
               this.set_expression_eye_R(2);
               this.set_expression_mouth(5);
               break;
            case 3:
               this.set_expression_eye_L(3);
               this.set_expression_eye_R(3);
               this.set_expression_mouth(5);
               break;
            case 4:
               this.set_expression_eye_L(4);
               this.set_expression_eye_R(4);
               this.set_expression_mouth(5);
               break;
            case 5:
               this.set_expression_eye_L(4);
               this.set_expression_eye_R(4);
               this.set_expression_mouth(1);
               break;
            case 6:
               this.set_expression_eye_L(4);
               this.set_expression_eye_R(4);
               this.set_expression_mouth(9);
               break;
            case 7:
               this.set_expression_eye_L(3);
               this.set_expression_eye_R(3);
               this.set_expression_mouth(9);
               break;
            case 8:
               this.set_expression_eye_L(5);
               this.set_expression_eye_R(5);
               this.set_expression_mouth(13);
         }
         switch(param1)
         {
            case 1:
               this.mouth_expression = 1;
               break;
            case 2:
               this.mouth_expression = 2;
               break;
            case 3:
               this.mouth_expression = 2;
               break;
            case 4:
               this.mouth_expression = 2;
               break;
            case 5:
               this.mouth_expression = 1;
               break;
            case 6:
               this.mouth_expression = 3;
               break;
            case 7:
               this.mouth_expression = 3;
               break;
            case 8:
               this.mouth_expression = 4;
         }
         return this.cur_expression;
      }
      
      override public function set_expression_eye_L(param1:uint) : void
      {
         if(this.piece_dict["eye_L"])
         {
            (this.piece_dict["eye_L"] as MovieClip).gotoAndStop(param1);
         }
         if(this.piece_dict["eye_mask_L"])
         {
            (this.piece_dict["eye_mask_L"] as MovieClip).gotoAndStop(param1);
         }
         if(this.piece_dict["brow_L"])
         {
            (this.piece_dict["brow_L"] as MovieClip).gotoAndStop(param1);
         }
      }
      
      override public function set_expression_eye_R(param1:uint) : void
      {
         if(this.piece_dict["eye_R"])
         {
            (this.piece_dict["eye_R"] as MovieClip).gotoAndStop(param1);
         }
         if(this.piece_dict["eye_mask_R"])
         {
            (this.piece_dict["eye_mask_R"] as MovieClip).gotoAndStop(param1);
         }
         if(this.piece_dict["brow_R"])
         {
            (this.piece_dict["brow_R"] as MovieClip).gotoAndStop(param1);
         }
      }
      
      override public function set_expression_mouth(param1:uint) : void
      {
         var _loc2_:uint = 0;
         switch(this._h_rot)
         {
            case 1:
            case 7:
               _loc2_ = 16;
               break;
            case 2:
            case 6:
               _loc2_ = 32;
         }
         if(this.piece_dict["mouth"])
         {
            (this.piece_dict["mouth"] as MovieClip).gotoAndStop(_loc2_ + param1);
         }
         this.lipsync = this.lipsync;
      }
      
      override public function save_state() : Object
      {
         var _loc1_:Object = {
            "h_rot":this.h_rot,
            "expression":this.cur_expression,
            "mouth_expression":this.mouth_expression,
            "lipsync":this.lipsync,
            "lids":this.lids
         };
         _loc1_["pupils"] = this.get_pupils();
         return _loc1_;
      }
      
      override public function load_state(param1:Object) : void
      {
         this.set_rotation(param1["h_rot"]);
         this.cur_expression = param1["expression"];
         this.mouth_expression = param1["mouth_expression"];
         this._lipsync = param1["lipsync"];
         if(param1["lidsync"])
         {
            this._lids[0] = this.lids[1] = param1["lidsync"];
         }
         if(param1["lids"])
         {
            this._lids[0] = param1["lids"][0];
            this._lids[1] = param1["lids"][1];
         }
         this.update_pupils(param1["pupils"][0],param1["pupils"][1]);
      }
      
      override public function get cld() : ColourData
      {
         return this._cld;
      }
      
      override public function set cld(param1:ColourData) : void
      {
         this._cld = param1;
      }
   }
}
