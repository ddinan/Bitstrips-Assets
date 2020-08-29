package com.bitstrips.character
{
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.core.Artwork;
   import com.bitstrips.core.ColourData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Head extends HeadBase implements IHead
   {
       
      
      private var glow_selected:GlowFilter;
      
      private var glow_over:GlowFilter;
      
      public var _cld:ColourData;
      
      public var artwork:ArtLoader;
      
      public var trans:HeadTrans;
      
      private var _mouse_look:Boolean = true;
      
      public var ppd:PPData;
      
      public var bdat:BitmapData;
      
      public var fg_head:Sprite;
      
      public var bg_head:Sprite;
      
      public var snap_back:Boolean = false;
      
      public var do_bdat:Boolean = false;
      
      public var pause_bdat:Boolean = false;
      
      public var bdat_scale:Number = 1;
      
      public var exp_save:Boolean;
      
      public var hair_back:HeadPiece;
      
      private var hat_back:HeadPiece;
      
      public var hbc:Sprite;
      
      private var _h_rot:Number = 0;
      
      public var expression:Number = 1;
      
      private var _cur_expression:Number = 1;
      
      public var mouth_expression:Number = 1;
      
      private var _lipsync:Number = 1;
      
      private var _lids:Array;
      
      public var hairstyle:Number = 1;
      
      public var beardstyle:Number = 0;
      
      public var backstyle:Number = 1;
      
      private var pupils:Array;
      
      public var line_width:Number = 1;
      
      public var lwm:Number = 1;
      
      public var library:Function;
      
      public var colour_click_call:Function;
      
      public var piece_dict:Object;
      
      public var pieces:Vector.<HeadPiece>;
      
      public var debug:Boolean = false;
      
      private var _edit:Boolean = false;
      
      public function Head(param1:PPData = undefined, param2:ColourData = undefined)
      {
         var _loc4_:* = null;
         var _loc5_:Object = null;
         var _loc6_:* = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:HeadPiece = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Vector.<HeadPiece> = null;
         var _loc13_:* = null;
         var _loc14_:Vector.<HeadPiece> = null;
         var _loc15_:* = null;
         this.glow_selected = new GlowFilter(52479,1,8,8,5);
         this.glow_over = new GlowFilter(65280,1,8,8,5);
         this._lids = [1,1];
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
         this.artwork = ArtLoader.getInstance();
         if(param1)
         {
            this.ppd = param1;
         }
         else
         {
            this.ppd = new PPData();
         }
         if(param2)
         {
            this.cld = param2;
         }
         else
         {
            this.cld = new ColourData();
         }
         this.cld.addEventListener("NEW_COLOUR",this.update_colours,false,0,true);
         var _loc3_:Array = ["hat","glasses","hair_front","brow_L","brow_R","nose","eyelash_L","eye_L","eyelid_L","pupil_L","eyelash_R","eye_R","eyelid_R","pupil_R","moustache","mouth","detail_L","detail_R","detail_T","chin","cheek_L","cheek_R","detail_E_L","detail_E_R","forehead","cranium","earring_L","ear_L","earring_R","ear_R","goatee","beard","jaw","hair_back"];
         if(this.debug)
         {
            trace("Initing pieces");
         }
         this.pieces = new Vector.<HeadPiece>();
         this.piece_dict = new Object();
         for(_loc4_ in _loc3_)
         {
            _loc8_ = _loc3_[_loc4_];
            _loc9_ = this.init_head_piece(_loc8_);
            this.piece_dict[_loc8_] = _loc9_;
            if(_loc9_ != null)
            {
               this.pieces.push(_loc9_);
               addChild(_loc9_);
               if(_loc3_[_loc4_] == "hair_back")
               {
                  this.hair_back = this.init_head_piece(_loc8_);
               }
               this.bounds_test();
            }
         }
         this.piece_dict["earring_L"].over_check_piece = this.piece_dict["ear_L"];
         this.piece_dict["earring_R"].over_check_piece = this.piece_dict["ear_R"];
         this.piece_dict["goatee"].over_check_piece = this.piece_dict["chin"];
         _loc5_ = new Object();
         _loc5_["x_syms"] = [["brow_R","brow_L"],["eye_L","eye_R"],["cheek_R","cheek_L"],["ear_L","ear_R"],["detail_L","detail_R"],["eyelash_L","eyelash_R"],["earring_R","earring_L"],["pupil_L","pupil_R"],["eyelid_L","eyelid_R"]];
         _loc5_["locked"] = {
            "eye_L":["eyelash_L","eyelid_L","detail_E_L"],
            "eye_R":["eyelash_R","eyelid_R","detail_E_R"]
         };
         _loc5_["x_locked"] = ["mouth","nose","detail_T","moustache","chin","glasses","goatee","hat"];
         _loc5_["y_locked"] = ["jaw","cranium","forehead","beard","hair_back","hair_front"];
         _loc5_["x_scales"] = [["jaw","cranium","forehead","hair_back","glasses","beard","hair_front"]];
         for(_loc6_ in _loc5_["x_syms"])
         {
            _loc10_ = _loc5_["x_syms"][_loc6_];
            this.piece_dict[_loc10_[0]].x_sym = this.piece_dict[_loc10_[1]];
            this.piece_dict[_loc10_[1]].x_sym = this.piece_dict[_loc10_[0]];
         }
         for(_loc6_ in _loc5_["x_locked"])
         {
            _loc7_ = _loc5_["x_locked"][_loc6_];
            this.piece_dict[_loc7_].x_locked = 1;
         }
         for(_loc6_ in _loc5_["y_locked"])
         {
            _loc7_ = _loc5_["y_locked"][_loc6_];
            this.piece_dict[_loc7_].y_locked = 1;
         }
         if(this.debug)
         {
            trace("X SCALES: " + " " + _loc5_["x_scales"]);
         }
         for(_loc6_ in _loc5_["x_scales"])
         {
            _loc11_ = _loc5_["x_scales"][_loc6_];
            _loc12_ = new Vector.<HeadPiece>();
            for(_loc13_ in _loc11_)
            {
               _loc12_.push(this.piece_dict[_loc11_[_loc13_]]);
            }
            if(this.debug)
            {
               trace("X scale: " + _loc6_ + " " + _loc12_);
            }
            _loc12_.push(this.hair_back);
            for(_loc13_ in _loc11_)
            {
               this.piece_dict[_loc11_[_loc13_]].x_scales = _loc12_;
            }
         }
         for(_loc6_ in _loc5_["locked"])
         {
            _loc11_ = _loc5_["locked"][_loc6_];
            _loc14_ = new Vector.<HeadPiece>();
            for(_loc15_ in _loc11_)
            {
               _loc14_.push(this.piece_dict[_loc11_[_loc15_]]);
            }
            this.piece_dict[_loc6_].locked = _loc14_;
         }
         this.set_masky(this.piece_dict["eye_L"],this.piece_dict["eyelid_L"]);
         this.set_masky(this.piece_dict["eye_R"],this.piece_dict["eyelid_R"]);
         this.set_masky(this.piece_dict["eye_L"],this.piece_dict["pupil_L"],2);
         this.set_masky(this.piece_dict["eye_R"],this.piece_dict["pupil_R"],2);
         this.set_masky(this.piece_dict["forehead"],this.piece_dict["detail_T"]);
         this.set_masky(this.piece_dict["jaw"],this.piece_dict["mouth"]);
         this.piece_dict["eye_L"].update_masks();
         this.piece_dict["eye_R"].update_masks();
         head_back = new Sprite();
         head_back.addChild(this.hair_back);
         if(param1 && param1["hairstyle"] != undefined)
         {
            this.set_hairstyle(param1["hairstyle"]);
            if(param1["beardstyle"])
            {
               this.set_beardstyle(param1["beardstyle"]);
            }
            this.set_backstyle(param1["backstyle"]);
         }
         this.set_rotation(this.h_rot);
         this.tabEnabled = this.tabChildren = false;
         _head_adjustment = -30;
      }
      
      override public function save() : Object
      {
         this.ppd.hairstyle = this.hairstyle;
         this.ppd.beardstyle = this.beardstyle;
         this.ppd.backstyle = this.backstyle;
         var _loc1_:Object = this.ppd.save_data();
         _loc1_["colours"] = this.cld.save_data();
         _loc1_["ratio"] = scaleX / scaleY;
         return _loc1_;
      }
      
      public function get_piece(param1:String) : HeadPiece
      {
         return this.piece_dict[param1];
      }
      
      public function get_art_id(param1:String) : String
      {
         if(this.piece_dict[param1].art_id == null)
         {
            return "_blank";
         }
         return this.piece_dict[param1].art_id;
      }
      
      public function dump_obj(param1:Object, param2:String = "\t") : void
      {
         var _loc3_:* = null;
         for(_loc3_ in param1)
         {
            trace(param2 + _loc3_ + " : " + param1[_loc3_]);
            if(param1[_loc3_] is Object)
            {
               this.dump_obj(param1[_loc3_],param2 + "\t");
            }
         }
      }
      
      override public function remove() : void
      {
         var _loc1_:int = 0;
         super.remove();
         _loc1_ = this.numChildren - 1;
         while(_loc1_ >= 0)
         {
            this.removeChildAt(_loc1_);
            _loc1_--;
         }
         this._cld = null;
         this.artwork = null;
         this.trans = null;
         this.ppd = null;
         this.bdat = null;
         this.fg_head = null;
         this.bg_head = null;
         this.hair_back = null;
         this.hat_back = null;
         this.pieces = null;
         this.piece_dict = null;
      }
      
      public function deselect() : void
      {
         if(this.trans)
         {
            this.trans.deselect();
         }
      }
      
      public function enable_bdats() : void
      {
         this.fg_head = new Sprite();
         this.fg_head.addChild(new Bitmap());
         this.bg_head = new Sprite();
         this.bg_head.addChild(new Bitmap());
         this.hbc = new Sprite();
         this.hbc.addChild(head_back);
         this.do_bdat = true;
         this.bdat_update();
      }
      
      public function set_art(param1:String, param2:String, param3:String) : void
      {
         if(this.debug)
         {
            trace("Set art: " + param1 + " " + param2 + " " + param3);
         }
         var _loc4_:Object = this.artwork.get_art(param2,param3);
         var _loc5_:HeadPiece = this.piece_dict[param1];
         _loc5_.set_art(_loc4_,param3);
      }
      
      private function init_head_piece(param1:String) : HeadPiece
      {
         var _loc2_:String = this.ppd.get_art_type(param1);
         var _loc3_:String = this.ppd.get_art_id(param1);
         if(_loc2_ == "beard" && _loc3_ == "_blank")
         {
            _loc3_ = "beard_art1";
            this.ppd.reset_mod("beard");
            this.ppd.set_art_id(param1,_loc3_);
         }
         var _loc4_:Object = this.artwork.get_art(_loc2_,_loc3_);
         if(_loc4_ == null)
         {
            trace("Failed to get art: " + _loc2_ + " " + _loc3_);
         }
         var _loc5_:HeadPiece = new HeadPiece(param1,_loc2_,this);
         _loc5_.name = param1;
         _loc5_.flipped = PieceData.rdata[param1]["flipped"];
         if(this.ppd.moveable(param1) || this.ppd.scaleable(param1))
         {
            if(this._edit == true)
            {
               _loc5_.buttonMode = true;
            }
         }
         if(_loc3_ != "_blank")
         {
            _loc5_.set_art(_loc4_,_loc3_);
         }
         if(this._edit == true)
         {
            _loc5_.addEventListener(MouseEvent.MOUSE_DOWN,this.piece_down,false,0,true);
            _loc5_.addEventListener(MouseEvent.ROLL_OVER,this.piece_over,false,0,true);
            _loc5_.addEventListener(MouseEvent.ROLL_OUT,this.piece_out,false,0,true);
         }
         return _loc5_;
      }
      
      public function get edit() : Boolean
      {
         return this._edit;
      }
      
      public function set edit(param1:Boolean) : void
      {
         var _loc2_:* = null;
         if(param1 == this._edit)
         {
            return;
         }
         this._edit = param1;
         if(this._edit == false)
         {
            this.clear_transforms();
            this.trans.deselect();
            for(_loc2_ in this.pieces)
            {
               this.pieces[_loc2_].removeEventListener(MouseEvent.MOUSE_DOWN,this.piece_down);
               this.pieces[_loc2_].removeEventListener(MouseEvent.ROLL_OVER,this.piece_over);
               this.pieces[_loc2_].removeEventListener(MouseEvent.ROLL_OUT,this.piece_out);
               this.pieces[_loc2_].buttonMode = false;
            }
            removeChild(this.trans);
            this.trans = null;
         }
         else
         {
            for(_loc2_ in this.pieces)
            {
               this.pieces[_loc2_].buttonMode = true;
               this.pieces[_loc2_].addEventListener(MouseEvent.MOUSE_DOWN,this.piece_down,false,0,true);
               this.pieces[_loc2_].addEventListener(MouseEvent.ROLL_OVER,this.piece_over,false,0,true);
               this.pieces[_loc2_].addEventListener(MouseEvent.ROLL_OUT,this.piece_out,false,0,true);
            }
            this.trans = new HeadTrans(this);
            addChild(this.trans);
            setChildIndex(this.trans,this.numChildren - 1);
         }
         this.mouseChildren = this._edit;
      }
      
      private function set_masky(param1:HeadPiece, param2:HeadPiece, param3:uint = 1) : void
      {
         if(param3 == 2)
         {
            param1.masky2 = param2;
            param2.masker2 = param1;
         }
         else
         {
            param1.masky = param2;
            param2.masker = param1;
         }
      }
      
      private function compare_depth(param1:HeadPiece, param2:HeadPiece) : Number
      {
         if(param1.depth > param2.depth)
         {
            return -1;
         }
         if(param1.depth == param2.depth)
         {
            return 0;
         }
         return 1;
      }
      
      private function update_levels() : void
      {
         var _loc3_:HeadPiece = null;
         var _loc4_:* = undefined;
         this.pieces.sort(this.compare_depth);
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < this.pieces.length)
         {
            if(this.pieces[_loc2_] && this.contains(this.pieces[_loc2_]))
            {
               _loc3_ = this.pieces[_loc2_];
               setChildIndex(this.pieces[_loc2_],_loc1_);
               _loc1_ = _loc1_ + 1;
            }
            else
            {
               _loc4_ = this.pieces[_loc2_];
               trace("No Update" + " " + _loc4_);
            }
            _loc2_ = _loc2_ + 1;
         }
         if(this.trans)
         {
            setChildIndex(this.trans,numChildren - 1);
         }
      }
      
      public function get_eye_centers() : Array
      {
         var _loc1_:HeadPiece = this.piece_dict["eye_L"];
         var _loc2_:HeadPiece = this.piece_dict["eye_R"];
         var _loc3_:Point = _loc1_.center_point_head();
         var _loc4_:Point = _loc2_.center_point_head();
         _loc3_ = this.localToGlobal(_loc3_);
         _loc4_ = this.localToGlobal(_loc4_);
         return [_loc3_,_loc4_];
      }
      
      override public function draw_pupils() : void
      {
         var _loc1_:HeadPiece = this.piece_dict["eye_L"];
         var _loc2_:HeadPiece = this.piece_dict["pupil_L"];
         var _loc3_:HeadPiece = this.piece_dict["eye_R"];
         var _loc4_:HeadPiece = this.piece_dict["pupil_R"];
         _loc2_.visible = _loc4_.visible = true;
         if(_loc1_.visible == false)
         {
            _loc2_.visible = false;
         }
         if(_loc3_.visible == false)
         {
            _loc4_.visible = false;
         }
         if(_loc2_.visible == false && _loc4_.visible == false)
         {
            return;
         }
         _loc2_.artwork.height = _loc1_.width * this.pupils[0].width;
         _loc4_.artwork.height = _loc3_.width * this.pupils[1].width;
         _loc2_.scale_xy(_loc2_.artwork.scaleY,_loc2_.artwork.scaleY);
         _loc4_.scale_xy(_loc4_.artwork.scaleY,_loc4_.artwork.scaleY);
         var _loc5_:Point = new Point();
         var _loc6_:Point = new Point();
         _loc5_.y = _loc1_.y;
         _loc5_.x = _loc1_.x - 20.5 * _loc1_.scale_x;
         _loc6_.y = _loc3_.y;
         _loc6_.x = _loc3_.x + 20.5 * _loc1_.scale_x;
         _loc2_.x = _loc5_.x + _loc1_.width * this.pupils[0].x;
         _loc2_.y = _loc5_.y + _loc1_.height * this.pupils[0].y;
         _loc4_.x = _loc6_.x + _loc3_.width * this.pupils[1].x;
         _loc4_.y = _loc6_.y + _loc3_.height * this.pupils[1].y;
      }
      
      public function get_piece_frame(param1:String) : uint
      {
         var _loc2_:uint = this.lids[0];
         if(param1 == "eyelid_L" || param1 == "eyelash_L")
         {
            _loc2_ = this.lids[0];
         }
         else if(param1 == "eyelid_R" || param1 == "eyelash_R")
         {
            _loc2_ = this.lids[1];
         }
         return this.ppd.get_frame(param1,this.h_rot,this.expression,this.mouth_expression,this.lipsync,_loc2_);
      }
      
      private function ppd_piece_update(param1:String) : void
      {
         var _loc2_:Object = this.ppd.get_data(param1,this.h_rot,this.expression,this.lipsync);
         var _loc3_:HeadPiece = this.piece_dict[param1];
         var _loc4_:uint = this.get_piece_frame(param1);
         if(param1 == "cranium")
         {
            _loc3_.go_to_frame(this.hairstyle * 3 + _loc4_);
            _loc3_.draw_lines();
         }
         else if(param1 == "beard")
         {
            _loc3_.go_to_frame(this.beardstyle * 3 + _loc4_);
            _loc3_.draw_lines();
         }
         else if(param1 == "hair_back")
         {
            _loc3_.go_to_frame(this.backstyle * 3 + _loc4_);
            _loc4_ = this.backstyle * 3 + _loc4_;
            _loc3_.draw_lines();
         }
         else
         {
            _loc3_.go_to_frame(_loc4_);
         }
         _loc3_.x = _loc2_.x;
         _loc3_.y = _loc2_.y;
         _loc3_.visible = _loc2_.visible;
         _loc3_.scale_x = _loc2_.xs;
         _loc3_.scale_y = _loc2_.ys;
         if(param1.substr(-1) != "L" && param1.substr(-1) != "R")
         {
            if(_loc3_.artwork != null)
            {
               _loc3_.flipped = _loc2_.f;
            }
         }
         _loc3_.depth = _loc2_.level;
         _loc3_.update_locks();
         if(param1 == "hair_back" && used_back)
         {
            _loc3_.visible = false;
            this.hair_back.go_to_frame(_loc4_);
            this.hair_back.scale_x = _loc3_.scale_x;
            this.hair_back.scale_y = _loc3_.scale_y;
            this.hair_back.flipped = _loc2_.f;
         }
         this.draw_pupils();
      }
      
      public function update_locks() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this.pieces)
         {
            if(this.pieces[_loc1_].locked)
            {
               this.pieces[_loc1_].update_locks();
            }
         }
      }
      
      override public function set_rotation(param1:int) : void
      {
         var _loc3_:* = null;
         if(param1 > 7)
         {
            param1 = 0;
         }
         if(param1 < 0)
         {
            param1 = 7;
         }
         this._h_rot = param1;
         this.pause_bdat = true;
         var _loc2_:HeadPiece = this.piece_dict["hat"];
         if(param1 >= 3 && param1 <= 5)
         {
            if(head_back.contains(_loc2_) == false)
            {
               this.removeChild(_loc2_);
               head_back.addChild(_loc2_);
            }
         }
         else if(head_back.contains(_loc2_))
         {
            head_back.removeChild(_loc2_);
            this.addChild(_loc2_);
         }
         for(_loc3_ in this.pieces)
         {
            this.ppd_piece_update(this.pieces[_loc3_].piece_id);
         }
         this.update_levels();
         this.update_locks();
         this.draw_pupils();
         dispatchEvent(new Event("ROTATION"));
         this.bdat_update(true);
         if(this.library != null)
         {
            this.library("updated");
         }
      }
      
      override public function set_expression(param1:uint) : uint
      {
         this.expression = Math.max(8,param1);
         this.cur_expression = param1;
         switch(param1)
         {
            case 1:
               this.expression = 1;
               this.mouth_expression = 1;
               break;
            case 2:
               this.expression = 2;
               this.mouth_expression = 2;
               break;
            case 3:
               this.expression = 3;
               this.mouth_expression = 2;
               break;
            case 4:
               this.expression = 4;
               this.mouth_expression = 2;
               break;
            case 5:
               this.expression = 4;
               this.mouth_expression = 1;
               break;
            case 6:
               this.expression = 4;
               this.mouth_expression = 3;
               break;
            case 7:
               this.expression = 3;
               this.mouth_expression = 3;
               break;
            case 8:
               this.expression = 8;
               this.mouth_expression = 4;
         }
         this.set_rotation(this.h_rot);
         if(this.library != null)
         {
            this.library("exp_update");
         }
         return param1;
      }
      
      override public function set_lipsync(param1:uint) : void
      {
         this.lipsync = Math.min(param1,5);
         this.pause_bdat = true;
         this.ppd_piece_update("mouth");
         this.ppd_piece_update("jaw");
         this.ppd_piece_update("chin");
         this.ppd_piece_update("goatee");
         this.ppd_piece_update("beard");
         this.bdat_update(true);
         if(this.library != null)
         {
            this.library("exp_update");
         }
      }
      
      override public function get_lipsync() : Number
      {
         return this.lipsync;
      }
      
      public function set_backstyle(param1:uint) : uint
      {
         var _loc2_:Object = null;
         this.backstyle = param1;
         this.pause_bdat = true;
         if(this.debug)
         {
            trace("Setting backstyle: " + this.backstyle);
         }
         this.ppd_piece_update("hair_back");
         if(used_back)
         {
            _loc2_ = this.hair_back.artwork;
         }
         else
         {
            _loc2_ = this.piece_dict["hair_back"].artwork;
         }
         if(this.backstyle == 0)
         {
            this.hair_back.artwork.base_colour = "ffcc99";
            this.piece_dict["hair_back"].artwork.base_colour = "ffcc99";
            if(this.cld.get_colour("ffcc99") == -1)
            {
               this.cld.set_colour("ffcc99",16764057);
            }
            this.cld.colour_clip(this.hair_back.artwork);
            this.cld.colour_clip(this.piece_dict["hair_back"].artwork);
         }
         else
         {
            if(this.cld.get_colour("926715") == -1)
            {
               this.cld.set_colour("926715",9594645);
            }
            this.piece_dict["hair_back"].artwork.base_colour = "926715";
            this.cld.colour_clip(this.piece_dict["hair_back"].artwork);
            this.hair_back.artwork.base_colour = "926715";
            this.cld.colour_clip(this.hair_back.artwork);
         }
         this.update_levels();
         this.bdat_update(true);
         this.bdat_back_update();
         return this.backstyle;
      }
      
      public function set_beardstyle(param1:uint) : uint
      {
         param1 = param1 % 7;
         if(param1 < 0)
         {
            param1 = 6;
         }
         this.beardstyle = param1;
         this.pause_bdat = true;
         this.ppd_piece_update("beard");
         this.bdat_update(true);
         return this.beardstyle;
      }
      
      public function set_hairstyle(param1:uint) : uint
      {
         this.pause_bdat = true;
         this.hairstyle = Math.max(0,param1);
         var _loc2_:HeadPiece = this.piece_dict["cranium"];
         var _loc3_:HeadPiece = this.piece_dict["forehead"];
         if(_loc2_ && _loc3_ && _loc2_.artwork && _loc3_.artwork)
         {
            if(this.hairstyle == 0)
            {
               _loc2_.artwork.base_colour = "ffcc99";
               _loc3_.no_lines = true;
               if(this.cld.get_colour("ffcc99") == -1)
               {
                  this.cld.set_colour("ffcc99",16764057);
               }
               this.cld.colour_clip(_loc2_.artwork);
            }
            else
            {
               if(this.cld.get_colour("926715") == -1)
               {
                  this.cld.set_colour("926715",9594645);
               }
               _loc2_.artwork.base_colour = "926715";
               _loc3_.no_lines = false;
               this.cld.colour_clip(_loc2_.artwork);
            }
         }
         this.ppd_piece_update("cranium");
         this.bdat_update(true);
         if(this.library != null)
         {
            this.library("exp_update");
         }
         return this.hairstyle;
      }
      
      override public function set_lids(param1:Array) : void
      {
         this.pause_bdat = true;
         this.lids[0] = param1[0];
         this.lids[1] = param1[1];
         this.ppd_piece_update("eyelid_L");
         this.ppd_piece_update("eyelid_R");
         this.ppd_piece_update("eyelash_L");
         this.ppd_piece_update("eyelash_R");
         this.update_locks();
         this.bdat_update(true);
         if(this.library != null)
         {
            this.library("exp_update");
         }
      }
      
      private function xy_adjust(param1:Point, param2:Point) : Point
      {
         var _loc3_:Number = Point.distance(param1,param2);
         var _loc4_:Point = param2.subtract(param1);
         var _loc5_:Number = Math.atan2(_loc4_.y,_loc4_.x);
         var _loc6_:Number = Math.min(Math.max(_loc3_ / 200,0),0.3);
         var _loc7_:Point = new Point(Math.cos(_loc5_) * _loc6_,Math.sin(_loc5_) * _loc6_);
         var _loc8_:Point = new Point((param2.x - param1.x) / _loc3_ / 3.4,(param2.y - param1.y) / _loc3_ / 3.4);
         return _loc7_;
      }
      
      override public function look_at_mouse(param1:int = 0, param2:int = 0) : void
      {
         var _loc3_:Point = null;
         if(param1 && param2)
         {
            _loc3_ = new Point(param1,param2);
         }
         else
         {
            if(stage == null)
            {
               return;
            }
            _loc3_ = new Point(stage.mouseX,stage.mouseY);
         }
         var _loc4_:Array = this.get_eye_centers();
         var _loc5_:Point = this.localToGlobal(new Point(0,0));
         var _loc6_:Point = this.xy_adjust(_loc5_,_loc3_);
         var _loc7_:Point = this.xy_adjust(_loc5_,_loc3_);
         this.update_pupils({
            "x":_loc6_.x,
            "y":_loc6_.y,
            "width":this.pupils[0].width
         },{
            "x":_loc7_.x,
            "y":_loc7_.y,
            "width":this.pupils[1].width
         });
         if(this.piece_dict["eye_L"].hitTestPoint(_loc3_.x,_loc3_.y) || this.piece_dict["eye_R"].hitTestPoint(_loc3_.x,_loc3_.y) || this.piece_dict["eye_L"].selected || this.piece_dict["eye_R"].selected)
         {
            this.update_pupils({
               "x":0,
               "y":0,
               "width":this.pupils[0].width
            },{
               "x":0,
               "y":0,
               "width":this.pupils[1].width
            });
         }
      }
      
      override public function update_pupils(param1:Object, param2:Object = null) : void
      {
         this.pause_bdat = true;
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
         this.bdat_update(true);
      }
      
      override public function get_pupils() : Object
      {
         return this.pupils;
      }
      
      override public function save_state() : Object
      {
         var _loc1_:Object = {
            "h_rot":this.h_rot,
            "expression":this.expression,
            "mouth_expression":this.mouth_expression,
            "lipsync":this.lipsync,
            "lids":this.lids
         };
         _loc1_["pupils"] = this.get_pupils();
         return _loc1_;
      }
      
      override public function load_state(param1:Object) : void
      {
         this.expression = param1["expression"];
         this.mouth_expression = param1["mouth_expression"];
         this.lipsync = param1["lipsync"];
         if(param1["lidsync"])
         {
            this.lids[0] = this.lids[1] = param1["lidsync"];
         }
         if(param1["lids"])
         {
            this.lids[0] = param1["lids"][0];
            this.lids[1] = param1["lids"][1];
         }
         this.set_rotation(param1["h_rot"]);
         this.update_pupils(param1["pupils"][0],param1["pupils"][1]);
      }
      
      public function colour_click(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:uint = 0;
         this.pieces.sort(this.compare_depth);
         var _loc5_:uint = 0;
         while(_loc5_ < this.pieces.length)
         {
            if(!(this.pieces[_loc5_].visible == false || this.pieces[_loc5_].artwork == null))
            {
               _loc4_ = this.colour_check(this.pieces[_loc5_].artwork as DisplayObjectContainer,new Point(param1,param2),param3);
               if(_loc4_ == 1)
               {
                  break;
               }
            }
            _loc5_ = _loc5_ + 1;
         }
      }
      
      public function colour_check(param1:DisplayObjectContainer, param2:Point, param3:Number) : Number
      {
         var _loc6_:DisplayObject = null;
         var _loc4_:Number = 0;
         var _loc5_:uint = 0;
         while(_loc5_ < param1.numChildren)
         {
            _loc6_ = param1.getChildAt(_loc5_);
            if(_loc6_.name.substr(0,2) == "c_")
            {
               if(_loc6_.hitTestPoint(param2.x,param2.y,true))
               {
                  this.cld.set_colour(_loc6_.name.split("_")[1],param3);
                  _loc4_ = 1;
               }
            }
            _loc5_ = _loc5_ + 1;
         }
         return _loc4_;
      }
      
      public function update_colours(param1:Event = null) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         if(this.debug)
         {
            trace("UPDATE COLORUS ------------------------------------------------- " + this + " " + this.name);
         }
         for(_loc2_ in this.pieces)
         {
            if(this.debug)
            {
               trace("\t" + _loc2_ + " -- " + this.pieces[_loc2_]);
            }
            if(this.pieces[_loc2_].artwork != null)
            {
               _loc3_ = this._cld.colour_clip(this.pieces[_loc2_].artwork);
               if(_loc3_ == -1)
               {
                  if(this.debug)
                  {
                     trace("Failed colour: " + this.pieces[_loc2_].piece_id);
                  }
               }
            }
         }
         if(this.debug)
         {
            trace("DONE");
         }
         this._cld.colour_clip(this.hair_back.artwork);
      }
      
      private function piece_down(param1:MouseEvent) : void
      {
         if(this._edit == false)
         {
            return;
         }
         var _loc2_:HeadPiece = param1.currentTarget as HeadPiece;
         this.selectPiece(_loc2_);
      }
      
      public function selectPiece(param1:HeadPiece) : void
      {
         if(this.debug)
         {
            trace("I was clicked: " + param1 + " - " + param1.piece_id);
         }
         if(param1.artwork && param1.artwork.base_colour)
         {
            if(this.colour_click_call != null)
            {
               this.colour_click_call([param1.artwork.base_colour]);
            }
         }
         else if(this.colour_click_call != null)
         {
            this.colour_click_call(this.get_colours(param1.artwork));
         }
         if(param1.art_type == "eyelid")
         {
            this.library("piece_down","eye");
         }
         else if(this.ppd.swapable(param1.piece_id))
         {
            this.library("piece_down",param1.art_type);
         }
         this.clear_transforms();
         if(this.trans)
         {
            this.trans.deselect();
         }
         if(this.trans)
         {
            this.trans.select_clip(param1);
         }
         this.update_transforms();
         dispatchEvent(new Event("PIECE_DOWN"));
      }
      
      public function get_colours(param1:Object) : Array
      {
         return ColourData.get_colours(param1);
      }
      
      private function update_transforms() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this.pieces)
         {
            if(this.pieces[_loc1_].artwork && this.pieces[_loc1_].artwork.mask)
            {
               if(this.pieces[_loc1_].masker && this.pieces[_loc1_].masker.selected)
               {
                  continue;
               }
               if(this.pieces[_loc1_].masker2 && this.pieces[_loc1_].masker2.selected)
               {
                  continue;
               }
            }
            if(this.pieces[_loc1_].selected)
            {
               this.pieces[_loc1_].filters = [this.glow_selected];
               if(this.pieces[_loc1_].piece_id == "mouth")
               {
                  this.pieces[_loc1_].mask = null;
               }
            }
            else if(this.pieces[_loc1_].over)
            {
               this.pieces[_loc1_].filters = [this.glow_over];
               if(this.pieces[_loc1_].piece_id == "mouth")
               {
                  this.pieces[_loc1_].mask = null;
               }
            }
            else
            {
               this.pieces[_loc1_].filters = [];
               if(this.pieces[_loc1_].piece_id == "mouth")
               {
                  this.pieces[_loc1_].update_masks();
               }
            }
         }
      }
      
      private function clear_transforms() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this.pieces)
         {
            this.pieces[_loc1_].filters = [];
         }
      }
      
      private function piece_over(param1:MouseEvent) : void
      {
         var _loc3_:* = null;
         var _loc2_:HeadPiece = param1.currentTarget as HeadPiece;
         if(this.debug)
         {
            trace("Piece Over: " + param1.target.name);
         }
         if(_loc2_.over == true)
         {
            return;
         }
         for(_loc3_ in this.pieces)
         {
            this.pieces[_loc3_].over = false;
         }
         if(this._edit == false)
         {
            if(this.debug)
            {
               trace("\tEditing == false, returning");
            }
            this.update_transforms();
            return;
         }
         if(this.trans && (this.trans.moving == 1 || this.trans.scaling == 1))
         {
            if(this.debug)
            {
               trace("\t - moving or scaling");
            }
            this.update_transforms();
            return;
         }
         if(this.trans && this.trans.is_selected(_loc2_))
         {
            if(this.debug)
            {
               trace("\t Is selected already, returning: " + _loc2_ + ", " + _loc2_.name);
            }
            this.update_transforms();
            return;
         }
         if(this.ppd.swapable(_loc2_.piece_id))
         {
            this.library("piece_over",param1.currentTarget.art_type);
         }
         _loc2_.over = true;
         if(_loc2_.x_sym)
         {
            _loc2_.x_sym.over = true;
         }
         this.update_transforms();
      }
      
      private function piece_out(param1:MouseEvent) : void
      {
         if(this.trans == null)
         {
            return;
         }
         if(this.debug)
         {
            trace("Piece Out: " + param1.target.name);
         }
         if(param1.target.name == "mouth")
         {
            return;
         }
         if(this._edit == false)
         {
            return;
         }
         if(this.trans.moving == 1 || this.trans.scaling == 1)
         {
            return;
         }
         var _loc2_:HeadPiece = param1.currentTarget as HeadPiece;
         if(this.trans.is_selected(_loc2_))
         {
            return;
         }
         if(_loc2_.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            return;
         }
         if(this.debug)
         {
            trace("Doing piece-out testing: " + _loc2_.name);
         }
         if(_loc2_.name == "mouth" || _loc2_.name == "pupil_L" || _loc2_.name == "pupil_R")
         {
            if(_loc2_.hitTestPoint(param1.stageX,param1.stageY))
            {
               if(this.debug)
               {
                  trace(" Piece out test isn\'t really true");
               }
               return;
            }
            if(this.debug)
            {
               trace("\t" + param1.stageX + ", " + param1.stageY);
            }
            if(this.debug)
            {
               trace("\t" + _loc2_.getBounds(stage));
            }
         }
         if(this.ppd.swapable(_loc2_.piece_id))
         {
            this.library("piece_out",param1.currentTarget.art_type);
         }
         if(this.debug)
         {
            trace("About to remove filters...");
         }
         if(this.debug)
         {
            trace("P: " + _loc2_ + " P filters: " + _loc2_.filters + _loc2_.name);
         }
         if(this.debug)
         {
            trace("Removed filsters, visible? " + _loc2_.visible);
         }
         _loc2_.over = false;
         if(_loc2_.x_sym)
         {
            _loc2_.x_sym.over = false;
         }
         this.update_transforms();
      }
      
      public function blank_it(param1:HeadPiece) : void
      {
         this.pause_bdat = true;
         if(param1 == null)
         {
            trace("UNDEFINED IN BLANK IT");
            return;
         }
         if(param1.piece_id == "eyelid_L" || param1.piece_id == "eyelid_R" || param1.piece_id == "pupil_L" || param1.piece_id == "pupil_R")
         {
            param1.visible = false;
            return;
         }
         if(this.debug)
         {
            trace("Blank it: " + param1 + " " + param1.name);
         }
         this.snap_back = false;
         if(this.snap_back)
         {
            param1.x = 0;
            param1.y = 0;
            param1.updated();
         }
         else
         {
            if(this.debug)
            {
               trace("Reseting mod:");
            }
            this.ppd.reset_mod(param1.piece_id);
            param1.set_art(new Artwork(),"_blank");
            this.ppd_piece_update(param1.piece_id);
            this.library("blank",param1.art_type);
         }
         this.draw_pupils();
         this.bdat_update(true);
      }
      
      private function bounds_test() : void
      {
         var _loc1_:Rectangle = this.getBounds(this);
         if(_loc1_.x < -500 || _loc1_.y < -500 || _loc1_.width > 1000 || _loc1_.height > 1000 || _loc1_.x > 500 || _loc1_.y > 500)
         {
            trace("Unreasonable bounds!");
            trace(_loc1_);
         }
      }
      
      public function bdat_update(param1:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Rectangle = null;
         if(this.pause_bdat && param1)
         {
            this.pause_bdat = false;
         }
         this.pause_bdat = false;
         if(this.do_bdat == false || this.pause_bdat == true)
         {
            return;
         }
         var _loc2_:Bitmap = this.fg_head.getChildAt(0) as Bitmap;
         if(_loc2_ == null)
         {
            trace("Error in bdat_update! Null B!");
            return;
         }
         var _loc3_:Rectangle = this.getBounds(this);
         var _loc4_:Matrix = new Matrix();
         if(_loc3_.x < -500 || _loc3_.y < -500 || _loc3_.width > 1000 || _loc3_.height > 1000 || _loc3_.x > 500 || _loc3_.y > 500)
         {
            trace("Unreasonable bounds!" + _loc3_);
            _loc3_.x = Math.min(Math.max(_loc3_.x,-100),100);
            _loc3_.y = Math.min(Math.max(_loc3_.x,-100),100);
            _loc3_.width = Math.min(Math.max(_loc3_.width,100),300);
            _loc3_.height = Math.min(Math.max(_loc3_.height,100),300);
            _loc5_ = 0;
            while(_loc5_ < this.pieces.length)
            {
               _loc6_ = this.pieces[_loc5_].getBounds(this);
               if(_loc6_.x < -500 || _loc6_.y < -500 || _loc6_.width > 1000 || _loc6_.height > 1000 || _loc6_.x > 500 || _loc6_.y > 500)
               {
                  trace("\t" + this.pieces[_loc5_].name + " " + this.pieces[_loc5_].getBounds(this));
                  this.ppd.reset_mod(this.pieces[_loc5_].piece_id);
                  this.ppd_piece_update(this.pieces[_loc5_].piece_id);
               }
               _loc5_++;
            }
            _loc3_ = this.getBounds(this);
         }
         _loc4_.scale(this.bdat_scale,this.bdat_scale);
         _loc4_.translate(-_loc3_.x * this.bdat_scale,-_loc3_.y * this.bdat_scale);
         this.bdat = new BitmapData(_loc3_.width * this.bdat_scale,_loc3_.height * this.bdat_scale,true,16777215);
         _loc2_.scaleX = _loc2_.scaleY = 1 / this.bdat_scale;
         if(this.bdat == null)
         {
            trace(_loc3_ + " - " + this.bdat_scale);
            trace("Error with get bitmapdata! - bdat" + this.bdat);
            return;
         }
         this.bdat.draw(this,_loc4_);
         dispatchEvent(new Event("BDAT"));
         _loc2_.bitmapData = this.bdat;
         _loc2_.smoothing = true;
         _loc2_.pixelSnapping = "never";
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y;
         this.bdat_back_update();
      }
      
      public function bdat_back_update() : void
      {
         if(this.do_bdat == false || used_back == false)
         {
            return;
         }
         var _loc1_:Sprite = this.hbc;
         var _loc2_:Bitmap = this.bg_head.getChildAt(0) as Bitmap;
         var _loc3_:Rectangle = _loc1_.getBounds(_loc1_);
         var _loc4_:Matrix = new Matrix();
         _loc4_.scale(this.bdat_scale,this.bdat_scale);
         _loc4_.translate(-_loc3_.x * this.bdat_scale,-_loc3_.y * this.bdat_scale);
         this.bdat = new BitmapData(_loc3_.width * this.bdat_scale,_loc3_.height * this.bdat_scale,true,16777215);
         _loc2_.scaleX = _loc2_.scaleY = 1 / this.bdat_scale;
         this.bdat.draw(_loc1_,_loc4_,null,null,null,true);
         dispatchEvent(new Event("BDAT"));
         _loc2_.bitmapData = this.bdat;
         _loc2_.smoothing = true;
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y - 3;
      }
      
      private function bitmap() : Bitmap
      {
         var _loc1_:Bitmap = new Bitmap(this.bdat,PixelSnapping.NEVER,true);
         return _loc1_;
      }
      
      override public function get cld() : ColourData
      {
         return this._cld;
      }
      
      override public function set cld(param1:ColourData) : void
      {
         this._cld = param1;
      }
      
      override public function get h_rot() : Number
      {
         return this._h_rot;
      }
      
      override public function set h_rot(param1:Number) : void
      {
         this.set_rotation(param1);
      }
      
      override public function set lids(param1:Array) : void
      {
         this._lids = param1;
      }
      
      override public function get lids() : Array
      {
         return this._lids;
      }
      
      override public function set lipsync(param1:Number) : void
      {
         this._lipsync = param1;
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
      
      override public function get features() : Array
      {
         return [Features.EXPRESSION,Features.PUPILS,Features.EYELIDS,Features.LIPSYNC,Features.HEAD_ROTATION];
      }
   }
}
