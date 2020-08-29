package com.bitstrips.character
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import ws.tink.display.HitTest;
   
   public class HeadTrans extends Sprite
   {
       
      
      public var head:Head;
      
      public var spacing:Number;
      
      public var selected:Array;
      
      private var move_info:Array;
      
      private var scale_info:Array;
      
      private var selected_transform:ColorTransform;
      
      public var moving:Boolean;
      
      public var scaling:Boolean;
      
      private var scaler:Number;
      
      private var dots:Array;
      
      public var ear:Boolean;
      
      public function HeadTrans(param1:Head)
      {
         this.selected_transform = new ColorTransform();
         super();
         this.head = param1;
         this.spacing = 2;
         this.selected = new Array();
         this.move_info = new Array();
         this.scale_info = new Array();
         this.scaling = false;
         this.moving = false;
         this.dots = new Array();
         var _loc2_:uint = 0;
         while(_loc2_ < 8)
         {
            this.dots[_loc2_] = new Sprite();
            this.dots[_loc2_].graphics.lineStyle(1,0,1,false,"none");
            this.dots[_loc2_].graphics.beginFill(16711680);
            this.dots[_loc2_].graphics.drawRect(0,0,6,6);
            this.dots[_loc2_].graphics.endFill();
            this.dots[_loc2_].graphics.lineStyle(1,0,0,false,"none");
            this.dots[_loc2_].graphics.beginFill(16711680,0);
            this.dots[_loc2_].graphics.drawRect(-2,-2,8,8);
            this.dots[_loc2_].graphics.endFill();
            this.dots[_loc2_].name = _loc2_;
            this.dots[_loc2_].visible = false;
            this.dots[_loc2_].addEventListener(MouseEvent.MOUSE_DOWN,this.scaledot_down);
            this.dots[_loc2_].buttonMode = true;
            addChild(this.dots[_loc2_]);
            _loc2_ = _loc2_ + 1;
         }
      }
      
      public function deselect() : void
      {
         var _loc2_:HeadPiece = null;
         this.remove_blanks();
         trace("Deselect: " + this.selected.length);
         var _loc1_:uint = 0;
         while(_loc1_ < this.selected.length)
         {
            _loc2_ = this.selected[_loc1_];
            _loc2_.transform.colorTransform = new ColorTransform();
            _loc2_.selected = false;
            _loc2_.filters = [];
            if(_loc2_.x_sym)
            {
               _loc2_.x_sym.filters = [];
               _loc2_.x_sym.selected = false;
               _loc2_.x_sym.transform.colorTransform = new ColorTransform();
            }
            _loc1_ = _loc1_ + 1;
         }
         if(this.scaling)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.scale_it);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouse_up);
         }
         this.selected = new Array();
         this.move_info = new Array();
         this.scale_info = new Array();
         this.moving = this.scaling = false;
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.move_it);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouse_up);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handle_jazz);
         }
         this.hide_handles();
         trace("Done in head trans deselect");
      }
      
      public function unselect() : void
      {
         trace("DEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD");
      }
      
      private function print_point(param1:String, param2:Point) : void
      {
         trace(param1 + " point: " + param2.x + ", " + param2.y);
      }
      
      public function select_clip(param1:HeadPiece) : void
      {
         var _loc3_:HeadPiece = null;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         if(_loc3_ != null)
         {
            _loc3_.transform.colorTransform = new ColorTransform();
         }
         _loc3_ = HeadPiece(param1);
         if(_loc3_.piece_id == "eyelid_L")
         {
            _loc3_ = this.head.get_piece("eye_L");
         }
         if(_loc3_.piece_id == "eyelid_R")
         {
            _loc3_ = this.head.get_piece("eye_R");
         }
         if(_loc3_.piece_id == "pupil_L")
         {
            _loc3_ = this.head.get_piece("eye_L");
         }
         if(_loc3_.piece_id == "pupil_R")
         {
            _loc3_ = this.head.get_piece("eye_R");
         }
         if(this.is_selected(_loc3_))
         {
            trace("Already selected");
         }
         else
         {
            this.selected.push(_loc3_);
            this.ear = false;
            if(_loc3_.art_id == "ear_L")
            {
               if(this.head.get_piece("earring_L").over_check())
               {
                  this.selected.push(this.head.get_piece("earring_L"));
                  this.ear = true;
               }
            }
            else if(_loc3_.piece_id == "ear_R")
            {
               if(this.head.get_piece("earring_R").over_check())
               {
                  this.selected.push(this.head.get_piece("earring_R"));
                  this.ear = true;
               }
            }
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.selected.length)
         {
            this.selected[_loc2_].selected = true;
            this.selected[_loc2_].transform.colorTransform = this.selected_transform;
            if(this.selected[_loc2_].x_sym)
            {
               this.selected[_loc2_].x_sym.transform.colorTransform = this.selected_transform;
               this.selected[_loc2_].x_sym.selected = true;
            }
            _loc2_ = _loc2_ + 1;
         }
         this.moving = true;
         _loc2_ = 0;
         while(_loc2_ < this.selected.length)
         {
            _loc3_ = this.selected[_loc2_];
            _loc4_ = new Point(_loc3_.parent.mouseX,_loc3_.parent.mouseY);
            _loc5_ = new Point(_loc3_.x,_loc3_.y);
            _loc6_ = _loc4_.subtract(_loc5_);
            this.move_info[_loc2_] = {"mouse":_loc6_};
            _loc2_ = _loc2_ + 1;
         }
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.move_it);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.mouse_up);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handle_jazz);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handle_jazz_once);
      }
      
      private function handle_jazz_once(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handle_jazz_once);
         this.handle_jazz(param1);
      }
      
      private function get_center(param1:Sprite) : Point
      {
         var _loc2_:Point = new Point();
         var _loc3_:Rectangle = param1.getBounds(param1.parent);
         _loc2_.x = _loc3_.x + _loc3_.width / 2;
         _loc2_.y = _loc3_.y + _loc3_.height / 2;
         return _loc2_;
      }
      
      private function mouse_distance(param1:DisplayObject, param2:Point) : Number
      {
         var _loc3_:Point = new Point(param1.parent.mouseX,param1.parent.mouseY);
         return Point.distance(param2,_loc3_);
      }
      
      public function scale_it(param1:MouseEvent) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:HeadPiece = null;
         var _loc8_:Point = null;
         var _loc9_:Number = NaN;
         var _loc10_:Point = null;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:HeadPiece = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         if(this.scaling == false)
         {
            return;
         }
         var _loc2_:uint = 10;
         var _loc3_:uint = 0;
         while(_loc3_ < this.selected.length)
         {
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = 0;
            _loc7_ = this.selected[_loc3_];
            if(this.head.ppd.scaleable(_loc7_.piece_id) == 1)
            {
               if(!(this.ear && (this.selected[_loc3_].piece_id == "earring_L" || this.selected[_loc3_].piece_id == "earring_R")))
               {
                  if(this.selected[_loc3_].piece_id == "jaw" || this.selected[_loc3_].piece_id == "forehead" || this.selected[_loc3_].piece_id == "cranium" || this.selected[_loc3_].piece_id == "hair_back" || this.selected[_loc3_].piece_id == "glasses" || this.selected[_loc3_].piece_id == "beard")
                  {
                     _loc4_ = this.selected[_loc3_].getBounds(this.head).width;
                     if(this.selected[_loc3_].piece_id == "jaw" || this.selected[_loc3_].piece_id == "beard")
                     {
                        _loc5_ = this.selected[_loc3_].getBounds(this.head).height;
                     }
                     else if(this.selected[_loc3_].piece_id == "forehead")
                     {
                        _loc6_ = this.selected[_loc3_].getBounds(this.head).height;
                     }
                  }
                  _loc8_ = this.get_center(_loc7_);
                  _loc9_ = this.mouse_distance(_loc7_,_loc8_);
                  if(this.scaler % 2 == 0 || this.scaler == 1 || this.scaler == 5)
                  {
                     _loc7_.scale_y = _loc7_.scale_y / this.scale_info[_loc3_]["distance"] * _loc9_;
                  }
                  if(this.scaler % 2 == 0 || this.scaler == 3 || this.scaler == 7)
                  {
                     _loc7_.scale_x = _loc7_.scale_x / this.scale_info[_loc3_]["distance"] * _loc9_;
                  }
                  _loc7_.scale_y = Math.max(0.4,Math.min(2,_loc7_.scale_y));
                  _loc7_.scale_x = Math.max(0.4,Math.min(2,_loc7_.scale_x));
                  _loc10_ = this.get_center(_loc7_);
                  _loc7_.x = _loc7_.x - (_loc10_.x - _loc8_.x);
                  if(_loc7_.y_locked)
                  {
                     _loc7_.y = 0;
                  }
                  else
                  {
                     _loc7_.y = _loc7_.y - (_loc10_.y - _loc8_.y);
                  }
                  if(this.selected[_loc3_].piece_id == "jaw")
                  {
                     this.head.get_piece("beard").scale_y = this.selected[_loc3_].scale_y;
                  }
                  else if(this.selected[_loc3_].piece_id == "beard")
                  {
                     this.head.get_piece("jaw").scale_y = this.selected[_loc3_].scale_y;
                  }
                  _loc7_.updated();
                  _loc8_ = this.get_center(_loc7_);
                  this.scale_info[_loc3_]["distance"] = _loc9_;
                  if(_loc4_ != 0)
                  {
                     _loc15_ = this.selected[_loc3_].x;
                     _loc16_ = (this.selected[_loc3_].getBounds(this.head).width - _loc4_) / 2;
                     _loc11_ = ["ear_L","eye_L","brow_L","detail_L","cheek_L","earring_L"];
                     for each(_loc12_ in _loc11_)
                     {
                        _loc13_ = this.head.get_piece(_loc12_);
                        if(_loc12_ == "ear_L" || _loc12_ == "earring_L")
                        {
                           _loc13_.x = _loc13_.x - _loc16_;
                        }
                        else
                        {
                           _loc13_.x = _loc13_.x - _loc16_ / 2;
                        }
                        _loc13_.updated();
                     }
                  }
                  if(_loc5_ != 0)
                  {
                     trace("Pre HDOWN?");
                     _loc14_ = this.selected[_loc3_].getBounds(this.head).height - _loc5_;
                     _loc11_ = ["mouth","chin","moustache","detail_L","goatee"];
                     for each(_loc12_ in _loc11_)
                     {
                        _loc13_ = this.head.get_piece(_loc12_);
                        if(_loc12_ == "chin")
                        {
                           _loc13_.y = _loc13_.y + _loc14_;
                        }
                        else
                        {
                           _loc13_.y = _loc13_.y + _loc14_ / 2;
                        }
                        _loc13_.updated();
                     }
                  }
                  if(_loc6_ != 0)
                  {
                     _loc17_ = this.head.get_piece("cranium").scale_y;
                     _loc18_ = this.head.get_piece("forehead").scale_y;
                     _loc14_ = this.selected[_loc3_].getBounds(this.head).height - _loc6_;
                     _loc11_ = ["brow_L","detail_T","eye_L"];
                     for each(_loc12_ in _loc11_)
                     {
                        _loc13_ = this.head.get_piece(_loc12_);
                        if(_loc12_ == "ear_L")
                        {
                           _loc13_.y = _loc13_.y - _loc14_;
                        }
                        else
                        {
                           _loc13_.y = _loc13_.y - _loc14_ / 2;
                        }
                        _loc13_.updated();
                     }
                  }
                  else
                  {
                     _loc17_ = this.head.get_piece("cranium").scale_y;
                     _loc18_ = this.head.get_piece("forehead").scale_y;
                  }
               }
            }
            _loc3_ = _loc3_ + 1;
         }
         this.draw_handles();
      }
      
      public function scaledot_down(param1:MouseEvent) : void
      {
         var _loc3_:HeadPiece = null;
         var _loc4_:Point = null;
         this.scaling = true;
         var _loc2_:uint = 0;
         while(_loc2_ < this.selected.length)
         {
            _loc3_ = this.selected[_loc2_];
            _loc4_ = this.get_center(_loc3_);
            this.scale_info[_loc2_] = new Object();
            this.scale_info[_loc2_]["distance"] = this.mouse_distance(_loc3_,_loc4_);
            _loc2_ = _loc2_ + 1;
         }
         this.scaler = param1.currentTarget.name;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.scale_it);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.mouse_up);
      }
      
      private function blank_buddies(param1:HeadPiece) : void
      {
         var _loc2_:* = null;
         trace("Hi from blank_buddies" + param1);
         for(_loc2_ in param1.locked)
         {
            param1.locked[_loc2_].alpha = 1;
            trace("hi" + _loc2_);
            this.head.blank_it(param1.locked[_loc2_]);
         }
         if(param1.x_sym)
         {
            param1.x_sym.alpha = 1;
            this.head.blank_it(param1.x_sym);
            for(_loc2_ in param1.x_sym.locked)
            {
               param1.x_sym.locked[_loc2_].alpha = 1;
               this.head.blank_it(param1.x_sym.locked[_loc2_]);
            }
         }
         if(param1.piece_id == "ear_L" || param1.piece_id == "ear_R")
         {
            if(this.head.get_piece("earring_L").over_check() == false)
            {
               this.head.blank_it(this.head.get_piece("earring_L"));
            }
            if(this.head.get_piece("earring_R").over_check() == false)
            {
               this.head.blank_it(this.head.get_piece("earring_R"));
            }
         }
      }
      
      private function remove_blanks() : void
      {
         var _loc1_:* = null;
         var _loc2_:HeadPiece = null;
         for(_loc1_ in this.selected)
         {
            if(this.selected[_loc1_].alpha != 1)
            {
               _loc2_ = this.selected[_loc1_];
               _loc2_.alpha = 1;
               trace("Blank buddies calling...");
               trace(this.selected[_loc1_]);
               this.blank_buddies(_loc2_);
               this.head.blank_it(_loc2_);
            }
         }
      }
      
      private function mouse_up(param1:MouseEvent) : void
      {
         if(this.moving)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.move_it);
            this.moving = false;
         }
         this.remove_blanks();
         this.scaling = false;
         this.moving = false;
      }
      
      private function move_it(param1:MouseEvent) : void
      {
         var _loc3_:HeadPiece = null;
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:Number = NaN;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:Boolean = false;
         var _loc11_:DisplayObject = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.selected.length)
         {
            _loc3_ = this.selected[_loc2_];
            if(this.head.ppd.moveable(_loc3_.piece_id) == 1)
            {
               _loc4_ = this.move_info[_loc2_]["mouse"];
               _loc5_ = new Point(_loc3_.parent.mouseX,_loc3_.parent.mouseY);
               _loc6_ = _loc5_.subtract(_loc4_);
               if(!_loc3_.x_locked)
               {
                  _loc7_ = _loc3_.x;
                  _loc8_ = _loc3_.center_point_head();
                  _loc3_.x = _loc6_.x;
                  _loc9_ = _loc3_.center_point_head();
                  if(this.head.h_rot == 0)
                  {
                     if(_loc8_.x > 0 && _loc9_.x <= 0)
                     {
                        _loc3_.x = 0;
                     }
                     if(_loc8_.x < 0 && _loc9_.x >= 0)
                     {
                        _loc3_.x = 0;
                     }
                  }
               }
               if(!_loc3_.y_locked)
               {
                  _loc3_.y = _loc6_.y;
               }
               _loc3_.updated();
               _loc6_ = _loc3_.center_point_stage();
               if(_loc3_.piece_id != "mouth" && _loc3_.piece_id != "detail_T")
               {
                  _loc10_ = false;
                  if(_loc3_.over_check())
                  {
                     _loc10_ = true;
                  }
                  if(_loc10_ == false && HitTest.complexHitTestObject(this.head.get_piece("jaw"),_loc3_) || HitTest.complexHitTestObject(this.head.get_piece("forehead"),_loc3_))
                  {
                     _loc10_ = true;
                  }
                  if(_loc10_ == true)
                  {
                     if(_loc3_.alpha != 1)
                     {
                        _loc3_.alpha = 1;
                        this.alpha_buddies(_loc3_,1);
                     }
                  }
                  else if(_loc3_.alpha != 0.5)
                  {
                     _loc3_.alpha = 0.5;
                     this.alpha_buddies(_loc3_,0.5);
                  }
               }
               else if(_loc3_.piece_id == "mouth")
               {
                  _loc11_ = _loc3_.mask;
                  _loc3_.mask = null;
                  if(HitTest.complexHitTestObject(this.head.get_piece("jaw"),_loc3_) == false)
                  {
                     _loc3_.alpha = 0.5;
                  }
                  else
                  {
                     _loc3_.alpha = 1;
                  }
                  _loc3_.mask = _loc11_;
               }
            }
            _loc2_ = _loc2_ + 1;
         }
      }
      
      private function alpha_buddies(param1:HeadPiece, param2:Number) : void
      {
         var _loc3_:* = null;
         for(_loc3_ in param1.locked)
         {
            param1.locked[_loc3_].alpha = param2;
         }
         if(param1.x_sym)
         {
            param1.x_sym.alpha = param2;
            for(_loc3_ in param1.x_sym.locked)
            {
               param1.x_sym.locked[_loc3_].alpha = param2;
            }
         }
      }
      
      public function is_selected(param1:HeadPiece) : Boolean
      {
         var _loc3_:HeadPiece = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.selected.length)
         {
            _loc3_ = this.selected[_loc2_];
            if(param1 == _loc3_)
            {
               return true;
            }
            if(_loc3_.x_sym)
            {
               if(_loc3_.x_sym == param1)
               {
                  return true;
               }
            }
            _loc2_ = _loc2_ + 1;
         }
         return false;
      }
      
      public function handle_jazz(param1:MouseEvent) : void
      {
         var _loc10_:HeadPiece = null;
         if(this.moving != 0)
         {
            this.hide_handles();
            return;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.selected.length)
         {
            _loc10_ = this.selected[_loc2_];
            if(this.head.ppd.scaleable(_loc10_.piece_id) != 1)
            {
               this.hide_handles();
               return;
            }
            _loc2_ = _loc2_ + 1;
         }
         var _loc3_:Rectangle = this.selected_bounds(stage);
         var _loc4_:Boolean = false;
         var _loc5_:Number = this.spacing * 15;
         if(param1.stageX >= _loc3_.x - _loc5_ && param1.stageX <= _loc3_.x + _loc3_.width + _loc5_)
         {
            if(param1.stageY >= _loc3_.y - _loc5_ && param1.stageY <= _loc3_.y + _loc3_.height + _loc5_)
            {
               _loc4_ = true;
            }
         }
         var _loc6_:Number = Math.abs(_loc3_.x - param1.stageX);
         var _loc7_:Number = Math.abs(_loc3_.x + _loc3_.width - param1.stageX);
         var _loc8_:Number = Math.abs(_loc3_.y - param1.stageY);
         var _loc9_:Number = Math.abs(_loc3_.y + _loc3_.height - param1.stageY);
         if((_loc6_ < _loc5_ || _loc7_ < _loc5_ || _loc8_ < _loc5_ || _loc9_ < _loc5_) && _loc4_)
         {
            this.draw_handles();
         }
         else
         {
            this.hide_handles();
         }
      }
      
      private function hide_handles() : void
      {
         var _loc1_:* = null;
         this.graphics.clear();
         for(_loc1_ in this.dots)
         {
            this.dots[_loc1_].visible = false;
         }
      }
      
      private function bounds_add(param1:Rectangle, param2:Rectangle) : Rectangle
      {
         var _loc3_:Number = Math.max(param1.x + param1.width,param2.x + param2.width);
         var _loc4_:Number = Math.max(param1.y + param1.height,param2.y + param2.height);
         var _loc5_:Number = Math.min(param1.x,param2.x);
         var _loc6_:Number = Math.min(param1.y,param2.y);
         var _loc7_:Number = _loc3_ - _loc5_;
         var _loc8_:Number = _loc4_ - _loc6_;
         return new Rectangle(_loc5_,_loc6_,_loc7_,_loc8_);
      }
      
      private function selected_bounds(param1:DisplayObject) : Rectangle
      {
         if(this.selected.length == 0)
         {
            return new Rectangle();
         }
         var _loc2_:Rectangle = this.selected[0].getBounds(param1);
         if(this.selected[0].x_sym)
         {
            _loc2_ = this.bounds_add(_loc2_,this.selected[0].x_sym.getBounds(param1));
         }
         var _loc3_:uint = 1;
         while(_loc3_ < this.selected.length)
         {
            _loc2_ = this.bounds_add(_loc2_,this.selected[_loc3_].getBounds(param1));
            if(this.selected[_loc3_].x_sym)
            {
               _loc2_ = this.bounds_add(_loc2_,this.selected[_loc3_].x_sym.getBounds(param1));
            }
            _loc3_ = _loc3_ + 1;
         }
         return _loc2_;
      }
      
      public function draw_handles() : void
      {
         var _loc8_:* = null;
         this.graphics.clear();
         this.graphics.lineStyle(2,16711680,1,false,"none");
         var _loc1_:Number = 0;
         var _loc2_:Rectangle = this.selected_bounds(this);
         var _loc3_:Number = _loc2_.width + _loc1_ * 2;
         var _loc4_:Number = _loc2_.height + _loc1_ * 2;
         var _loc5_:Number = _loc2_.x - _loc1_;
         var _loc6_:Number = _loc2_.y - _loc1_;
         this.graphics.drawRect(_loc2_.x - _loc1_,_loc2_.y - _loc1_,_loc3_,_loc4_);
         var _loc7_:Number = 6;
         this.dots[0].x = -_loc1_ - _loc7_;
         this.dots[0].y = -_loc1_ - _loc7_;
         this.dots[1].x = _loc3_ / 2 - _loc7_ / 2 - _loc1_;
         this.dots[1].y = this.dots[0].y;
         this.dots[2].x = _loc3_ - _loc7_ - _loc1_ + _loc7_;
         this.dots[2].y = this.dots[0].y;
         this.dots[3].x = this.dots[2].x;
         this.dots[3].y = _loc4_ / 2 - _loc7_ / 2 - _loc1_;
         this.dots[4].x = this.dots[2].x;
         this.dots[4].y = _loc4_ - _loc7_ - _loc1_ + _loc7_;
         this.dots[5].x = this.dots[1].x;
         this.dots[5].y = this.dots[4].y;
         this.dots[6].x = this.dots[0].x;
         this.dots[6].y = this.dots[4].y;
         this.dots[7].x = this.dots[0].x;
         this.dots[7].y = this.dots[3].y;
         for(_loc8_ in this.dots)
         {
            this.dots[_loc8_].x = this.dots[_loc8_].x + _loc2_.x;
            this.dots[_loc8_].y = this.dots[_loc8_].y + _loc2_.y;
            this.dots[_loc8_].visible = true;
         }
      }
   }
}
