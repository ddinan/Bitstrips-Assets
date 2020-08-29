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
       
      
      protected var _h_rot:Number = 0;
      
      protected var head_rot_inversion:int = 1;
      
      protected var mouth_expression:Number = 1;
      
      protected var _cur_expression:Number = 1;
      
      protected var _mouse_look:Boolean = true;
      
      protected var _lids:Array;
      
      protected const head_scale:Number = 0.85;
      
      protected var pupils:Array;
      
      protected var clip:MovieClip;
      
      protected var _cld:ColourData;
      
      protected var piece_dict:Object;
      
      protected var _lipsync:Number = 1;
      
      public function HeadCustom(param1:PPData = undefined, param2:ColourData = undefined)
      {
         _lids = [1,1];
         piece_dict = new Object();
         pupils = [{
            "x":0,
            "y":0,
            "width":0.25
         },{
            "x":0,
            "y":0,
            "width":0.25
         }];
         super();
         cld = param2;
         head_back = new MovieClip();
         clip = new MovieClip();
      }
      
      override public function get h_rot() : Number
      {
         return _h_rot;
      }
      
      public function set_clip(param1:MovieClip) : void
      {
         clip = param1;
         clip.scaleX = clip.scaleY = head_scale;
         clip.y = 6;
         addChild(clip);
         set_rotation(h_rot);
         clip.addEventListener("refresh",refresh_head_bits);
      }
      
      override public function update_pupils(param1:Object, param2:Object = null) : void
      {
         if(param1.width == undefined)
         {
            param1.width = 0.25;
         }
         pupils[0].x = param1.x;
         pupils[0].y = param1.y;
         pupils[0].width = param1.width;
         if(param2 == null)
         {
            param2 = param1;
         }
         else if(param2.width == undefined)
         {
            param2.width = 0.25;
         }
         pupils[1].x = param2.x;
         pupils[1].y = param2.y;
         pupils[1].width = param2.width;
         draw_pupils();
      }
      
      override public function set mouse_look(param1:Boolean) : void
      {
         _mouse_look = param1;
      }
      
      override public function set_expression(param1:uint) : uint
      {
         param1 = Math.min(8,param1);
         cur_expression = param1;
         switch(cur_expression)
         {
            case 1:
               set_expression_eye_L(1);
               set_expression_eye_R(1);
               set_expression_mouth(1);
               break;
            case 2:
               set_expression_eye_L(2);
               set_expression_eye_R(2);
               set_expression_mouth(5);
               break;
            case 3:
               set_expression_eye_L(3);
               set_expression_eye_R(3);
               set_expression_mouth(5);
               break;
            case 4:
               set_expression_eye_L(4);
               set_expression_eye_R(4);
               set_expression_mouth(5);
               break;
            case 5:
               set_expression_eye_L(4);
               set_expression_eye_R(4);
               set_expression_mouth(1);
               break;
            case 6:
               set_expression_eye_L(4);
               set_expression_eye_R(4);
               set_expression_mouth(9);
               break;
            case 7:
               set_expression_eye_L(3);
               set_expression_eye_R(3);
               set_expression_mouth(9);
               break;
            case 8:
               set_expression_eye_L(5);
               set_expression_eye_R(5);
               set_expression_mouth(13);
         }
         switch(param1)
         {
            case 1:
               mouth_expression = 1;
               break;
            case 2:
               mouth_expression = 2;
               break;
            case 3:
               mouth_expression = 2;
               break;
            case 4:
               mouth_expression = 2;
               break;
            case 5:
               mouth_expression = 1;
               break;
            case 6:
               mouth_expression = 3;
               break;
            case 7:
               mouth_expression = 3;
               break;
            case 8:
               mouth_expression = 4;
         }
         return cur_expression;
      }
      
      override public function set_expression_eye_R(param1:uint) : void
      {
         if(piece_dict["eye_R"])
         {
            (piece_dict["eye_R"] as MovieClip).gotoAndStop(param1);
         }
         if(piece_dict["eye_mask_R"])
         {
            (piece_dict["eye_mask_R"] as MovieClip).gotoAndStop(param1);
         }
         if(piece_dict["brow_R"])
         {
            (piece_dict["brow_R"] as MovieClip).gotoAndStop(param1);
         }
      }
      
      override public function set_expression_eye_L(param1:uint) : void
      {
         if(piece_dict["eye_L"])
         {
            (piece_dict["eye_L"] as MovieClip).gotoAndStop(param1);
         }
         if(piece_dict["eye_mask_L"])
         {
            (piece_dict["eye_mask_L"] as MovieClip).gotoAndStop(param1);
         }
         if(piece_dict["brow_L"])
         {
            (piece_dict["brow_L"] as MovieClip).gotoAndStop(param1);
         }
      }
      
      override public function set_expression_mouth(param1:uint) : void
      {
         var _loc2_:uint = 0;
         switch(_h_rot)
         {
            case 1:
            case 7:
               _loc2_ = 16;
               break;
            case 2:
            case 6:
               _loc2_ = 32;
         }
         if(piece_dict["mouth"])
         {
            (piece_dict["mouth"] as MovieClip).gotoAndStop(_loc2_ + param1);
         }
         lipsync = lipsync;
      }
      
      override public function draw_pupils() : void
      {
         var _loc1_:MovieClip = piece_dict["eye_L"];
         var _loc2_:MovieClip = piece_dict["pupil_L"];
         var _loc3_:MovieClip = piece_dict["eye_R"];
         var _loc4_:MovieClip = piece_dict["pupil_R"];
         if(!_loc2_)
         {
            return;
         }
         _loc2_.visible = _loc4_.visible = true;
         var _loc5_:Array = [];
         if(head_rot_inversion == 1)
         {
            _loc5_[0] = pupils[0];
            _loc5_[1] = pupils[1];
         }
         else
         {
            _loc5_[0] = pupils[1];
            _loc5_[1] = pupils[0];
         }
         _loc2_.height = _loc1_.height * _loc5_[0].width;
         _loc4_.height = _loc3_.height * _loc5_[1].width;
         _loc2_.scaleX = _loc2_.scaleY;
         _loc4_.scaleX = _loc4_.scaleY;
         var _loc6_:Point = center_point_head();
         var _loc7_:Point = center_point_head();
         _loc6_.y = _loc1_.y;
         _loc6_.x = _loc1_.x;
         _loc7_.y = _loc3_.y;
         _loc7_.x = _loc3_.x;
         _loc2_.x = _loc1_.width * _loc5_[0].x * head_rot_inversion;
         _loc2_.y = _loc6_.y + _loc1_.height * _loc5_[0].y;
         _loc4_.x = _loc3_.width * _loc5_[1].x * head_rot_inversion;
         _loc4_.y = _loc7_.y + _loc3_.height * _loc5_[1].y;
      }
      
      protected function refresh_head_bits(param1:Event) : void
      {
         if(clip["pupil_L"])
         {
            piece_dict["pupil_L"] = clip["pupil_L"]["pupil_mc"];
         }
         else
         {
            piece_dict["pupil_L"] = new MovieClip();
         }
         if(clip["pupil_R"])
         {
            piece_dict["pupil_R"] = clip["pupil_R"]["pupil_mc"];
         }
         else
         {
            piece_dict["pupil_R"] = new MovieClip();
         }
         if(clip["eye_L"])
         {
            piece_dict["eye_L"] = clip["eye_L"];
            piece_dict["eye_mask_L"] = clip["eye_mask_L"];
            piece_dict["brow_L"] = clip["brow_L"];
            (piece_dict["pupil_L"] as MovieClip).mask = piece_dict["eye_mask_L"] as MovieClip;
         }
         else
         {
            piece_dict["eye_L"] = new MovieClip();
         }
         if(clip["eye_R"])
         {
            piece_dict["eye_R"] = clip["eye_R"];
            piece_dict["eye_mask_R"] = clip["eye_mask_R"];
            piece_dict["brow_R"] = clip["brow_R"];
            (piece_dict["pupil_R"] as MovieClip).mask = piece_dict["eye_mask_R"] as MovieClip;
         }
         else
         {
            piece_dict["eye_R"] = new MovieClip();
         }
         if(clip["mouth"])
         {
            piece_dict["mouth"] = clip["mouth"];
         }
         else
         {
            piece_dict["mouth"] = new MovieClip();
         }
         draw_pupils();
         set_expression(cur_expression);
      }
      
      override public function set h_rot(param1:Number) : void
      {
         set_rotation(param1);
      }
      
      override public function get cld() : ColourData
      {
         return _cld;
      }
      
      override public function get lipsync() : Number
      {
         return _lipsync;
      }
      
      override public function set cld(param1:ColourData) : void
      {
         _cld = param1;
      }
      
      override public function set lids(param1:Array) : void
      {
         _lids = param1;
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
         _h_rot = param1;
         var _loc2_:int = Math.floor(_h_rot);
         head_rot_inversion = 1;
         if(_h_rot > 4)
         {
            _loc2_ = 4 - (_h_rot - 4);
            head_rot_inversion = -1;
         }
         clip.gotoAndStop(_loc2_ + 1);
         clip.scaleX = head_scale * head_rot_inversion;
      }
      
      override public function get lids() : Array
      {
         return _lids;
      }
      
      override public function save_state() : Object
      {
         var _loc1_:Object = {
            "h_rot":h_rot,
            "expression":cur_expression,
            "mouth_expression":mouth_expression,
            "lipsync":lipsync,
            "lids":lids
         };
         _loc1_["pupils"] = get_pupils();
         return _loc1_;
      }
      
      override public function set_lipsync(param1:uint) : void
      {
         lipsync = param1;
         set_expression(cur_expression);
      }
      
      override public function get_pupils() : Object
      {
         return pupils;
      }
      
      override public function center_point_head() : Point
      {
         var _loc1_:Rectangle = this.getBounds(this.parent);
         return new Point(_loc1_.x + _loc1_.width / 2,_loc1_.y + _loc1_.height / 2);
      }
      
      override public function set lipsync(param1:Number) : void
      {
         param1 = Math.min(param1,4);
         _lipsync = param1;
         var _loc2_:MovieClip = piece_dict["mouth"] as MovieClip;
         _loc2_.gotoAndStop(_loc2_.currentFrame + (_lipsync - 1));
      }
      
      override public function set cur_expression(param1:Number) : void
      {
         _cur_expression = param1;
      }
      
      override public function get cur_expression() : Number
      {
         return _cur_expression;
      }
      
      override public function load_state(param1:Object) : void
      {
         set_rotation(param1["h_rot"]);
         cur_expression = param1["expression"];
         mouth_expression = param1["mouth_expression"];
         _lipsync = param1["lipsync"];
         if(param1["lidsync"])
         {
            _lids[0] = lids[1] = param1["lidsync"];
         }
         if(param1["lids"])
         {
            _lids[0] = param1["lids"][0];
            _lids[1] = param1["lids"][1];
         }
         update_pupils(param1["pupils"][0],param1["pupils"][1]);
      }
      
      override public function get mouse_look() : Boolean
      {
         return _mouse_look;
      }
   }
}
