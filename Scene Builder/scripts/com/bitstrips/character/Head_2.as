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
       
      
      public var colour_click_call:Function;
      
      private var hat_back:HeadPiece;
      
      private var glow_selected:GlowFilter;
      
      public var hairstyle:Number = 1;
      
      public var mouth_expression:Number = 1;
      
      private var _cur_expression:Number = 1;
      
      public var hair_back:HeadPiece;
      
      public var do_bdat:Boolean = false;
      
      public var backstyle:Number = 1;
      
      public var snap_back:Boolean = false;
      
      public var lwm:Number = 1;
      
      public var pieces:Array;
      
      private var glow_over:GlowFilter;
      
      public var debug:Boolean = false;
      
      public var _cld:ColourData;
      
      public var exp_save:Boolean;
      
      public var ppd:PPData;
      
      public var piece_dict:Object;
      
      private var _lipsync:Number = 1;
      
      public var bdat_scale:Number = 1;
      
      private var _h_rot:Number = 0;
      
      public var beardstyle:Number = 0;
      
      private var _mouse_look:Boolean = true;
      
      public var bg_head:Sprite;
      
      public var pause_bdat:Boolean = false;
      
      public var expression:Number = 1;
      
      public var fg_head:Sprite;
      
      public var trans:HeadTrans;
      
      public var hbc:Sprite;
      
      private var _lids:Array;
      
      public var line_width:Number = 1;
      
      private var pupils:Array;
      
      public var library:Function;
      
      private var _edit:Boolean = false;
      
      public var artwork:ArtLoader;
      
      public var bdat:BitmapData;
      
      public function Head(param1:PPData = undefined, param2:ColourData = undefined)
      {
         var p:String = null;
         var limits:Object = null;
         var i:String = null;
         var id:String = null;
         var p_name:String = null;
         var piece:HeadPiece = null;
         var sym:Array = null;
         var lock:Array = null;
         var temp:Array = null;
         var l:String = null;
         var locks:Array = null;
         var i2:String = null;
         var i_ppd:PPData = param1;
         var i_cldata:ColourData = param2;
         glow_selected = new GlowFilter(52479,1,8,8,5);
         glow_over = new GlowFilter(65280,1,8,8,5);
         _lids = [1,1];
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
         artwork = ArtLoader.getInstance();
         if(i_ppd)
         {
            ppd = i_ppd;
         }
         else
         {
            ppd = new PPData();
         }
         if(i_cldata)
         {
            cld = i_cldata;
         }
         else
         {
            cld = new ColourData();
         }
         cld.addEventListener("NEW_COLOUR",function(param1:Event):void
         {
            update_colours();
         });
         var piece_list:Array = ["hat","glasses","hair_front","brow_L","brow_R","nose","eyelash_L","eye_L","eyelid_L","pupil_L","eyelash_R","eye_R","eyelid_R","pupil_R","moustache","mouth","detail_L","detail_R","detail_T","chin","cheek_L","cheek_R","detail_E_L","detail_E_R","forehead","cranium","earring_L","ear_L","earring_R","ear_R","goatee","beard","jaw","hair_back"];
         if(debug)
         {
            trace("Initing pieces");
         }
         pieces = new Array();
         piece_dict = new Object();
         for(p in piece_list)
         {
            p_name = piece_list[p];
            piece = init_head_piece(p_name);
            piece_dict[p_name] = piece;
            if(piece != null)
            {
               pieces.push(piece);
               addChild(piece);
               if(piece_list[p] == "hair_back")
               {
                  hair_back = init_head_piece(p_name);
               }
               this.bounds_test();
            }
         }
         piece_dict["earring_L"].over_check_piece = piece_dict["ear_L"];
         piece_dict["earring_R"].over_check_piece = piece_dict["ear_R"];
         piece_dict["goatee"].over_check_piece = piece_dict["chin"];
         limits = new Object();
         limits["x_syms"] = [["brow_R","brow_L"],["eye_L","eye_R"],["cheek_R","cheek_L"],["ear_L","ear_R"],["detail_L","detail_R"],["eyelash_L","eyelash_R"],["earring_R","earring_L"],["pupil_L","pupil_R"],["eyelid_L","eyelid_R"]];
         limits["locked"] = {
            "eye_L":["eyelash_L","eyelid_L","detail_E_L"],
            "eye_R":["eyelash_R","eyelid_R","detail_E_R"]
         };
         limits["x_locked"] = ["mouth","nose","detail_T","moustache","chin","glasses","goatee","hat"];
         limits["y_locked"] = ["jaw","cranium","forehead","beard","hair_back","hair_front"];
         limits["x_scales"] = [["jaw","cranium","forehead","hair_back","glasses","beard","hair_front"]];
         for(i in limits["x_syms"])
         {
            sym = limits["x_syms"][i];
            piece_dict[sym[0]].x_sym = piece_dict[sym[1]];
            piece_dict[sym[1]].x_sym = piece_dict[sym[0]];
         }
         for(i in limits["x_locked"])
         {
            id = limits["x_locked"][i];
            piece_dict[id].x_locked = 1;
         }
         for(i in limits["y_locked"])
         {
            id = limits["y_locked"][i];
            piece_dict[id].y_locked = 1;
         }
         if(debug)
         {
            trace("X SCALES: " + " " + limits["x_scales"]);
         }
         for(i in limits["x_scales"])
         {
            lock = limits["x_scales"][i];
            temp = new Array();
            for(l in lock)
            {
               temp.push(piece_dict[lock[l]]);
            }
            if(debug)
            {
               trace("X scale: " + i + " " + temp);
            }
            temp.push(hair_back);
            for(l in lock)
            {
               piece_dict[lock[l]].x_scales = temp;
            }
         }
         for(i in limits["locked"])
         {
            lock = limits["locked"][i];
            locks = new Array();
            for(i2 in lock)
            {
               locks.push(piece_dict[lock[i2]]);
            }
            piece_dict[i].locked = locks;
         }
         set_masky(piece_dict["eye_L"],piece_dict["eyelid_L"]);
         set_masky(piece_dict["eye_R"],piece_dict["eyelid_R"]);
         set_masky(piece_dict["eye_L"],piece_dict["pupil_L"],2);
         set_masky(piece_dict["eye_R"],piece_dict["pupil_R"],2);
         set_masky(piece_dict["forehead"],piece_dict["detail_T"]);
         set_masky(piece_dict["jaw"],piece_dict["mouth"]);
         piece_dict["eye_L"].update_masks();
         piece_dict["eye_R"].update_masks();
         head_back = new Sprite();
         head_back.addChild(hair_back);
         if(i_ppd && i_ppd["hairstyle"] != undefined)
         {
            set_hairstyle(i_ppd["hairstyle"]);
            if(i_ppd["beardstyle"])
            {
               set_beardstyle(i_ppd["beardstyle"]);
            }
            set_backstyle(i_ppd["backstyle"]);
         }
         set_rotation(h_rot);
         this.tabEnabled = this.tabChildren = false;
      }
      
      public function set_art(param1:String, param2:String, param3:String) : void
      {
         if(debug)
         {
            trace("Set art: " + param1 + " " + param2 + " " + param3);
         }
         var _loc4_:Object = artwork.get_art(param2,param3);
         var _loc5_:HeadPiece = piece_dict[param1];
         _loc5_.set_art(_loc4_,param3);
      }
      
      override public function set h_rot(param1:Number) : void
      {
         set_rotation(param1);
      }
      
      public function get edit() : Boolean
      {
         return _edit;
      }
      
      override public function get mouse_look() : Boolean
      {
         return _mouse_look;
      }
      
      public function set edit(param1:Boolean) : void
      {
         var _loc2_:* = null;
         if(param1 == _edit)
         {
            return;
         }
         _edit = param1;
         if(_edit == false)
         {
            clear_transforms();
            trans.deselect();
            for(_loc2_ in pieces)
            {
               pieces[_loc2_].removeEventListener(MouseEvent.MOUSE_DOWN,piece_down);
               pieces[_loc2_].removeEventListener(MouseEvent.ROLL_OVER,piece_over);
               pieces[_loc2_].removeEventListener(MouseEvent.ROLL_OUT,piece_out);
               pieces[_loc2_].buttonMode = false;
            }
            removeChild(trans);
            trans = null;
         }
         else
         {
            for(_loc2_ in pieces)
            {
               pieces[_loc2_].buttonMode = true;
               pieces[_loc2_].addEventListener(MouseEvent.MOUSE_DOWN,piece_down);
               pieces[_loc2_].addEventListener(MouseEvent.ROLL_OVER,piece_over);
               pieces[_loc2_].addEventListener(MouseEvent.ROLL_OUT,piece_out);
            }
            trans = new HeadTrans(this);
            addChild(trans);
            setChildIndex(trans,this.numChildren - 1);
         }
         this.mouseChildren = _edit;
      }
      
      override public function get cld() : ColourData
      {
         return _cld;
      }
      
      override public function draw_pupils() : void
      {
         var _loc1_:HeadPiece = piece_dict["eye_L"];
         var _loc2_:HeadPiece = piece_dict["pupil_L"];
         var _loc3_:HeadPiece = piece_dict["eye_R"];
         var _loc4_:HeadPiece = piece_dict["pupil_R"];
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
         _loc2_.artwork.height = _loc1_.width * pupils[0].width;
         _loc4_.artwork.height = _loc3_.width * pupils[1].width;
         _loc2_.scale_xy(_loc2_.artwork.scaleY,_loc2_.artwork.scaleY);
         _loc4_.scale_xy(_loc4_.artwork.scaleY,_loc4_.artwork.scaleY);
         var _loc5_:Point = new Point();
         var _loc6_:Point = new Point();
         _loc5_.y = _loc1_.y;
         _loc5_.x = _loc1_.x - 20.5 * _loc1_.scale_x;
         _loc6_.y = _loc3_.y;
         _loc6_.x = _loc3_.x + 20.5 * _loc1_.scale_x;
         _loc2_.x = _loc5_.x + _loc1_.width * pupils[0].x;
         _loc2_.y = _loc5_.y + _loc1_.height * pupils[0].y;
         _loc4_.x = _loc6_.x + _loc3_.width * pupils[1].x;
         _loc4_.y = _loc6_.y + _loc3_.height * pupils[1].y;
      }
      
      private function bitmap() : Bitmap
      {
         var _loc1_:Bitmap = new Bitmap(bdat,PixelSnapping.NEVER,true);
         return _loc1_;
      }
      
      public function dump_obj(param1:Object, param2:String = "\t") : void
      {
         var _loc3_:* = null;
         for(_loc3_ in param1)
         {
            trace(param2 + _loc3_ + " : " + param1[_loc3_]);
            if(param1[_loc3_] is Object)
            {
               dump_obj(param1[_loc3_],param2 + "\t");
            }
         }
      }
      
      private function ppd_piece_update(param1:String) : void
      {
         var _loc2_:Object = ppd.get_data(param1,h_rot,expression,lipsync);
         var _loc3_:HeadPiece = piece_dict[param1];
         var _loc4_:uint = get_piece_frame(param1);
         if(param1 == "cranium")
         {
            _loc3_.go_to_frame(hairstyle * 3 + _loc4_);
            _loc3_.draw_lines();
         }
         else if(param1 == "beard")
         {
            _loc3_.go_to_frame(beardstyle * 3 + _loc4_);
            _loc3_.draw_lines();
         }
         else if(param1 == "hair_back")
         {
            _loc3_.go_to_frame(backstyle * 3 + _loc4_);
            _loc4_ = backstyle * 3 + _loc4_;
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
            hair_back.go_to_frame(_loc4_);
            hair_back.scale_x = _loc3_.scale_x;
            hair_back.scale_y = _loc3_.scale_y;
            hair_back.flipped = _loc2_.f;
         }
         draw_pupils();
      }
      
      override public function set cld(param1:ColourData) : void
      {
         _cld = param1;
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
         var _loc4_:Array = get_eye_centers();
         var _loc5_:Point = this.localToGlobal(new Point(0,0));
         var _loc6_:Point = xy_adjust(_loc5_,_loc3_);
         var _loc7_:Point = xy_adjust(_loc5_,_loc3_);
         update_pupils({
            "x":_loc6_.x,
            "y":_loc6_.y,
            "width":pupils[0].width
         },{
            "x":_loc7_.x,
            "y":_loc7_.y,
            "width":pupils[1].width
         });
         if(piece_dict["eye_L"].hitTestPoint(_loc3_.x,_loc3_.y) || piece_dict["eye_R"].hitTestPoint(_loc3_.x,_loc3_.y) || piece_dict["eye_L"].selected || piece_dict["eye_R"].selected)
         {
            update_pupils({
               "x":0,
               "y":0,
               "width":pupils[0].width
            },{
               "x":0,
               "y":0,
               "width":pupils[1].width
            });
         }
      }
      
      public function get_colours(param1:Object) : Array
      {
         return ColourData.get_colours(param1);
      }
      
      public function get_eye_centers() : Array
      {
         var _loc1_:HeadPiece = piece_dict["eye_L"];
         var _loc2_:HeadPiece = piece_dict["eye_R"];
         var _loc3_:Point = _loc1_.center_point_head();
         var _loc4_:Point = _loc2_.center_point_head();
         _loc3_ = this.localToGlobal(_loc3_);
         _loc4_ = this.localToGlobal(_loc4_);
         return [_loc3_,_loc4_];
      }
      
      override public function save_state() : Object
      {
         var _loc1_:Object = {
            "h_rot":h_rot,
            "expression":expression,
            "mouth_expression":mouth_expression,
            "lipsync":lipsync,
            "lids":lids
         };
         _loc1_["pupils"] = get_pupils();
         return _loc1_;
      }
      
      private function piece_down(param1:MouseEvent) : void
      {
         if(_edit == false)
         {
            return;
         }
         var _loc2_:HeadPiece = param1.currentTarget as HeadPiece;
         selectPiece(_loc2_);
      }
      
      private function init_head_piece(param1:String) : HeadPiece
      {
         var _loc2_:String = ppd.get_art_type(param1);
         var _loc3_:String = ppd.get_art_id(param1);
         if(_loc2_ == "beard" && _loc3_ == "_blank")
         {
            _loc3_ = "beard_art1";
            ppd.reset_mod("beard");
            ppd.set_art_id(param1,_loc3_);
         }
         var _loc4_:Object = artwork.get_art(_loc2_,_loc3_);
         if(_loc4_ == null)
         {
            trace("Failed to get art: " + _loc2_ + " " + _loc3_);
         }
         var _loc5_:HeadPiece = new HeadPiece(param1,_loc2_,this);
         _loc5_.name = param1;
         _loc5_.flipped = PieceData.rdata[param1]["flipped"];
         if(ppd.moveable(param1) || ppd.scaleable(param1))
         {
            if(_edit == true)
            {
               _loc5_.buttonMode = true;
            }
         }
         if(_loc3_ != "_blank")
         {
            _loc5_.set_art(_loc4_,_loc3_);
         }
         if(_edit == true)
         {
            _loc5_.addEventListener(MouseEvent.MOUSE_DOWN,piece_down);
            _loc5_.addEventListener(MouseEvent.ROLL_OVER,piece_over);
            _loc5_.addEventListener(MouseEvent.ROLL_OUT,piece_out);
         }
         return _loc5_;
      }
      
      public function selectPiece(param1:HeadPiece) : void
      {
         if(debug)
         {
            trace("I was clicked: " + param1 + " - " + param1.piece_id);
         }
         if(param1.artwork && param1.artwork.base_colour)
         {
            if(colour_click_call != null)
            {
               colour_click_call([param1.artwork.base_colour]);
            }
         }
         else if(colour_click_call != null)
         {
            colour_click_call(get_colours(param1.artwork));
         }
         if(param1.art_type == "eyelid")
         {
            library("piece_down","eye");
         }
         else if(ppd.swapable(param1.piece_id))
         {
            library("piece_down",param1.art_type);
         }
         clear_transforms();
         if(trans)
         {
            trans.deselect();
         }
         if(trans)
         {
            trans.select_clip(param1);
         }
         update_transforms();
         dispatchEvent(new Event("PIECE_DOWN"));
      }
      
      public function enable_bdats() : void
      {
         fg_head = new Sprite();
         fg_head.addChild(new Bitmap());
         bg_head = new Sprite();
         bg_head.addChild(new Bitmap());
         hbc = new Sprite();
         hbc.addChild(head_back);
         do_bdat = true;
         bdat_update();
      }
      
      override public function set lipsync(param1:Number) : void
      {
         _lipsync = param1;
      }
      
      public function bdat_update(param1:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Rectangle = null;
         if(pause_bdat && param1)
         {
            pause_bdat = false;
         }
         pause_bdat = false;
         if(do_bdat == false || pause_bdat == true)
         {
            return;
         }
         var _loc2_:Bitmap = fg_head.getChildAt(0) as Bitmap;
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
            while(_loc5_ < pieces.length)
            {
               _loc6_ = pieces[_loc5_].getBounds(this);
               if(_loc6_.x < -500 || _loc6_.y < -500 || _loc6_.width > 1000 || _loc6_.height > 1000 || _loc6_.x > 500 || _loc6_.y > 500)
               {
                  trace("\t" + pieces[_loc5_].name + " " + pieces[_loc5_].getBounds(this));
                  ppd.reset_mod(pieces[_loc5_].piece_id);
                  ppd_piece_update(pieces[_loc5_].piece_id);
               }
               _loc5_++;
            }
            _loc3_ = this.getBounds(this);
         }
         _loc4_.scale(bdat_scale,bdat_scale);
         _loc4_.translate(-_loc3_.x * bdat_scale,-_loc3_.y * bdat_scale);
         bdat = new BitmapData(_loc3_.width * bdat_scale,_loc3_.height * bdat_scale,true,16777215);
         _loc2_.scaleX = _loc2_.scaleY = 1 / bdat_scale;
         if(bdat == null)
         {
            trace(_loc3_ + " - " + bdat_scale);
            trace("Error with get bitmapdata! - bdat" + bdat);
            return;
         }
         bdat.draw(this,_loc4_);
         dispatchEvent(new Event("BDAT"));
         _loc2_.bitmapData = bdat;
         _loc2_.smoothing = true;
         _loc2_.pixelSnapping = "never";
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y;
         bdat_back_update();
      }
      
      public function colour_click(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:uint = 0;
         pieces.sortOn("depth",Array.NUMERIC);
         var _loc5_:uint = 0;
         while(_loc5_ < pieces.length)
         {
            if(!(pieces[_loc5_].visible == false || pieces[_loc5_].artwork == null))
            {
               _loc4_ = colour_check(pieces[_loc5_].artwork,new Point(param1,param2),param3);
               if(_loc4_ == 1)
               {
                  break;
               }
            }
            _loc5_ = _loc5_ + 1;
         }
      }
      
      public function set_hairstyle(param1:uint) : uint
      {
         pause_bdat = true;
         hairstyle = Math.max(0,param1);
         var _loc2_:HeadPiece = piece_dict["cranium"];
         var _loc3_:HeadPiece = piece_dict["forehead"];
         if(_loc2_ && _loc3_ && _loc2_.artwork && _loc3_.artwork)
         {
            if(hairstyle == 0)
            {
               _loc2_.artwork.base_colour = "ffcc99";
               _loc3_.no_lines = true;
               if(cld.get_colour("ffcc99") == -1)
               {
                  cld.set_colour("ffcc99",16764057);
               }
               cld.colour_clip(_loc2_.artwork);
            }
            else
            {
               if(cld.get_colour("926715") == -1)
               {
                  cld.set_colour("926715",9594645);
               }
               _loc2_.artwork.base_colour = "926715";
               _loc3_.no_lines = false;
               cld.colour_clip(_loc2_.artwork);
            }
         }
         ppd_piece_update("cranium");
         bdat_update(true);
         if(library != null)
         {
            library("exp_update");
         }
         return hairstyle;
      }
      
      public function get_piece_frame(param1:String) : uint
      {
         var _loc2_:uint = lids[0];
         if(param1 == "eyelid_L" || param1 == "eyelash_L")
         {
            _loc2_ = lids[0];
         }
         else if(param1 == "eyelid_R" || param1 == "eyelash_R")
         {
            _loc2_ = lids[1];
         }
         return ppd.get_frame(param1,h_rot,expression,mouth_expression,lipsync,_loc2_);
      }
      
      public function save() : Object
      {
         ppd.hairstyle = hairstyle;
         ppd.beardstyle = beardstyle;
         ppd.backstyle = backstyle;
         var _loc1_:Object = ppd.save_data();
         _loc1_["colours"] = cld.save_data();
         _loc1_["ratio"] = scaleX / scaleY;
         return _loc1_;
      }
      
      public function set_beardstyle(param1:uint) : uint
      {
         param1 = param1 % 7;
         if(param1 < 0)
         {
            param1 = 6;
         }
         beardstyle = param1;
         pause_bdat = true;
         ppd_piece_update("beard");
         bdat_update(true);
         return beardstyle;
      }
      
      public function get_art_id(param1:String) : String
      {
         if(piece_dict[param1].art_id == null)
         {
            return "_blank";
         }
         return piece_dict[param1].art_id;
      }
      
      override public function set_lids(param1:Array) : void
      {
         pause_bdat = true;
         lids[0] = param1[0];
         lids[1] = param1[1];
         ppd_piece_update("eyelid_L");
         ppd_piece_update("eyelid_R");
         ppd_piece_update("eyelash_L");
         ppd_piece_update("eyelash_R");
         update_locks();
         bdat_update(true);
         if(library != null)
         {
            library("exp_update");
         }
      }
      
      public function set_backstyle(param1:uint) : uint
      {
         var _loc2_:Object = null;
         backstyle = param1;
         pause_bdat = true;
         if(debug)
         {
            trace("Setting backstyle: " + backstyle);
         }
         ppd_piece_update("hair_back");
         if(used_back)
         {
            _loc2_ = hair_back.artwork;
         }
         else
         {
            _loc2_ = piece_dict["hair_back"].artwork;
         }
         if(backstyle == 0)
         {
            hair_back.artwork.base_colour = "ffcc99";
            piece_dict["hair_back"].artwork.base_colour = "ffcc99";
            if(cld.get_colour("ffcc99") == -1)
            {
               cld.set_colour("ffcc99",16764057);
            }
            cld.colour_clip(hair_back.artwork);
            cld.colour_clip(piece_dict["hair_back"].artwork);
         }
         else
         {
            if(cld.get_colour("926715") == -1)
            {
               cld.set_colour("926715",9594645);
            }
            piece_dict["hair_back"].artwork.base_colour = "926715";
            cld.colour_clip(piece_dict["hair_back"].artwork);
            hair_back.artwork.base_colour = "926715";
            cld.colour_clip(hair_back.artwork);
         }
         update_levels();
         bdat_update(true);
         bdat_back_update();
         return backstyle;
      }
      
      override public function get h_rot() : Number
      {
         return _h_rot;
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
      
      override public function set_expression(param1:uint) : uint
      {
         expression = Math.max(8,param1);
         cur_expression = param1;
         switch(param1)
         {
            case 1:
               expression = 1;
               mouth_expression = 1;
               break;
            case 2:
               expression = 2;
               mouth_expression = 2;
               break;
            case 3:
               expression = 3;
               mouth_expression = 2;
               break;
            case 4:
               expression = 4;
               mouth_expression = 2;
               break;
            case 5:
               expression = 4;
               mouth_expression = 1;
               break;
            case 6:
               expression = 4;
               mouth_expression = 3;
               break;
            case 7:
               expression = 3;
               mouth_expression = 3;
               break;
            case 8:
               expression = 8;
               mouth_expression = 4;
         }
         set_rotation(h_rot);
         if(library != null)
         {
            library("exp_update");
         }
         return param1;
      }
      
      private function piece_over(param1:MouseEvent) : void
      {
         var _loc3_:* = null;
         var _loc2_:HeadPiece = param1.currentTarget as HeadPiece;
         if(debug)
         {
            trace("Piece Over: " + param1.target.name);
         }
         if(_loc2_.over == true)
         {
            return;
         }
         for(_loc3_ in pieces)
         {
            pieces[_loc3_].over = false;
         }
         if(_edit == false)
         {
            if(debug)
            {
               trace("\tEditing == false, returning");
            }
            update_transforms();
            return;
         }
         if(trans && (trans.moving == 1 || trans.scaling == 1))
         {
            if(debug)
            {
               trace("\t - moving or scaling");
            }
            update_transforms();
            return;
         }
         if(trans && trans.is_selected(_loc2_))
         {
            if(debug)
            {
               trace("\t Is selected already, returning: " + _loc2_ + ", " + _loc2_.name);
            }
            update_transforms();
            return;
         }
         if(ppd.swapable(_loc2_.piece_id))
         {
            library("piece_over",param1.currentTarget.art_type);
         }
         _loc2_.over = true;
         if(_loc2_.x_sym)
         {
            _loc2_.x_sym.over = true;
         }
         update_transforms();
      }
      
      override public function set lids(param1:Array) : void
      {
         _lids = param1;
      }
      
      private function piece_out(param1:MouseEvent) : void
      {
         if(trans == null)
         {
            return;
         }
         if(debug)
         {
            trace("Piece Out: " + param1.target.name);
         }
         if(param1.target.name == "mouth")
         {
            return;
         }
         if(_edit == false)
         {
            return;
         }
         if(trans.moving == 1 || trans.scaling == 1)
         {
            return;
         }
         var _loc2_:HeadPiece = param1.currentTarget as HeadPiece;
         if(trans.is_selected(_loc2_))
         {
            return;
         }
         if(_loc2_.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            return;
         }
         if(debug)
         {
            trace("Doing piece-out testing: " + _loc2_.name);
         }
         if(_loc2_.name == "mouth" || _loc2_.name == "pupil_L" || _loc2_.name == "pupil_R")
         {
            if(_loc2_.hitTestPoint(param1.stageX,param1.stageY))
            {
               if(debug)
               {
                  trace(" Piece out test isn\'t really true");
               }
               return;
            }
            if(debug)
            {
               trace("\t" + param1.stageX + ", " + param1.stageY);
            }
            if(debug)
            {
               trace("\t" + _loc2_.getBounds(stage));
            }
         }
         if(ppd.swapable(_loc2_.piece_id))
         {
            library("piece_out",param1.currentTarget.art_type);
         }
         if(debug)
         {
            trace("About to remove filters...");
         }
         if(debug)
         {
            trace("P: " + _loc2_ + " P filters: " + _loc2_.filters + _loc2_.name);
         }
         if(debug)
         {
            trace("Removed filsters, visible? " + _loc2_.visible);
         }
         _loc2_.over = false;
         if(_loc2_.x_sym)
         {
            _loc2_.x_sym.over = false;
         }
         update_transforms();
      }
      
      private function update_levels() : void
      {
         var _loc3_:HeadPiece = null;
         var _loc4_:* = undefined;
         pieces.sortOn("depth",Array.NUMERIC | Array.DESCENDING);
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < pieces.length)
         {
            if(pieces[_loc2_] && this.contains(pieces[_loc2_]))
            {
               _loc3_ = pieces[_loc2_];
               setChildIndex(pieces[_loc2_],_loc1_);
               _loc1_ = _loc1_ + 1;
            }
            else
            {
               _loc4_ = pieces[_loc2_];
               trace("No Update" + " " + _loc4_);
            }
            _loc2_ = _loc2_ + 1;
         }
         if(trans)
         {
            setChildIndex(trans,numChildren - 1);
         }
      }
      
      override public function get lipsync() : Number
      {
         return _lipsync;
      }
      
      public function update_colours() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         if(debug)
         {
            trace("UPDATE COLORUS ------------------------------------------------- " + this + " " + this.name);
         }
         for(_loc1_ in pieces)
         {
            if(debug)
            {
               trace("\t" + _loc1_ + " -- " + pieces[_loc1_]);
            }
            if(pieces[_loc1_].artwork != null)
            {
               _loc2_ = cld.colour_clip(pieces[_loc1_].artwork);
               if(_loc2_ == -1)
               {
                  if(debug)
                  {
                     trace("Failed colour: " + pieces[_loc1_].piece_id);
                  }
               }
            }
         }
         if(debug)
         {
            trace("DONE");
         }
         cld.colour_clip(hair_back.artwork);
      }
      
      public function update_locks() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in pieces)
         {
            if(pieces[_loc1_].locked)
            {
               pieces[_loc1_].update_locks();
            }
         }
      }
      
      private function clear_transforms() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in pieces)
         {
            pieces[_loc1_].filters = [];
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
         _h_rot = param1;
         pause_bdat = true;
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
         for(_loc3_ in pieces)
         {
            ppd_piece_update(pieces[_loc3_].piece_id);
         }
         update_levels();
         update_locks();
         draw_pupils();
         dispatchEvent(new Event("ROTATION"));
         bdat_update(true);
         if(library != null)
         {
            library("updated");
         }
      }
      
      public function deselect() : void
      {
         if(trans)
         {
            trans.deselect();
         }
      }
      
      private function update_transforms() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in pieces)
         {
            if(pieces[_loc1_].artwork && pieces[_loc1_].artwork.mask)
            {
               if(pieces[_loc1_].masker && pieces[_loc1_].masker.selected)
               {
                  continue;
               }
               if(pieces[_loc1_].masker2 && pieces[_loc1_].masker2.selected)
               {
                  continue;
               }
            }
            if(pieces[_loc1_].selected)
            {
               pieces[_loc1_].filters = [glow_selected];
               if(pieces[_loc1_].piece_id == "mouth")
               {
                  pieces[_loc1_].mask = null;
               }
            }
            else if(pieces[_loc1_].over)
            {
               pieces[_loc1_].filters = [glow_over];
               if(pieces[_loc1_].piece_id == "mouth")
               {
                  pieces[_loc1_].mask = null;
               }
            }
            else
            {
               pieces[_loc1_].filters = [];
               if(pieces[_loc1_].piece_id == "mouth")
               {
                  pieces[_loc1_].update_masks();
               }
            }
         }
      }
      
      public function get_piece(param1:String) : HeadPiece
      {
         return piece_dict[param1];
      }
      
      override public function set_lipsync(param1:uint) : void
      {
         lipsync = Math.min(param1,5);
         pause_bdat = true;
         ppd_piece_update("mouth");
         ppd_piece_update("jaw");
         ppd_piece_update("chin");
         ppd_piece_update("goatee");
         ppd_piece_update("beard");
         bdat_update(true);
         if(library != null)
         {
            library("exp_update");
         }
      }
      
      override public function get_lipsync() : Number
      {
         return lipsync;
      }
      
      override public function get_pupils() : Object
      {
         return pupils;
      }
      
      public function bdat_back_update() : void
      {
         if(do_bdat == false || used_back == false)
         {
            return;
         }
         var _loc1_:Sprite = hbc;
         var _loc2_:Bitmap = bg_head.getChildAt(0) as Bitmap;
         var _loc3_:Rectangle = _loc1_.getBounds(_loc1_);
         var _loc4_:Matrix = new Matrix();
         _loc4_.scale(bdat_scale,bdat_scale);
         _loc4_.translate(-_loc3_.x * bdat_scale,-_loc3_.y * bdat_scale);
         bdat = new BitmapData(_loc3_.width * bdat_scale,_loc3_.height * bdat_scale,true,16777215);
         _loc2_.scaleX = _loc2_.scaleY = 1 / bdat_scale;
         bdat.draw(_loc1_,_loc4_,null,null,null,true);
         dispatchEvent(new Event("BDAT"));
         _loc2_.bitmapData = bdat;
         _loc2_.smoothing = true;
         _loc2_.x = _loc3_.x;
         _loc2_.y = _loc3_.y - 3;
      }
      
      override public function get lids() : Array
      {
         return _lids;
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
                  cld.set_colour(_loc6_.name.split("_")[1],param3);
                  _loc4_ = 1;
               }
            }
            _loc5_ = _loc5_ + 1;
         }
         return _loc4_;
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
      
      override public function set cur_expression(param1:Number) : void
      {
         _cur_expression = param1;
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
      
      override public function set mouse_look(param1:Boolean) : void
      {
         _mouse_look = param1;
      }
      
      public function blank_it(param1:HeadPiece) : void
      {
         pause_bdat = true;
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
         if(debug)
         {
            trace("Blank it: " + param1 + " " + param1.name);
         }
         snap_back = false;
         if(snap_back)
         {
            param1.x = 0;
            param1.y = 0;
            param1.updated();
         }
         else
         {
            if(debug)
            {
               trace("Reseting mod:");
            }
            ppd.reset_mod(param1.piece_id);
            param1.set_art(new Artwork(),"_blank");
            ppd_piece_update(param1.piece_id);
            library("blank",param1.art_type);
         }
         draw_pupils();
         bdat_update(true);
      }
      
      override public function get cur_expression() : Number
      {
         return _cur_expression;
      }
      
      override public function load_state(param1:Object) : void
      {
         expression = param1["expression"];
         mouth_expression = param1["mouth_expression"];
         lipsync = param1["lipsync"];
         if(param1["lidsync"])
         {
            lids[0] = lids[1] = param1["lidsync"];
         }
         if(param1["lids"])
         {
            lids[0] = param1["lids"][0];
            lids[1] = param1["lids"][1];
         }
         set_rotation(param1["h_rot"]);
         update_pupils(param1["pupils"][0],param1["pupils"][1]);
      }
      
      override public function update_pupils(param1:Object, param2:Object = null) : void
      {
         pause_bdat = true;
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
         bdat_update(true);
      }
   }
}
