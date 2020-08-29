package com.bitstrips.character.skeleton
{
   import com.bitstrips.Utils;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class Skin extends Sprite
   {
       
      
      private var _skeleton:Skeleton;
      
      private var skin_pieces:Array;
      
      private var skin_lookup:Object;
      
      private var frame:uint;
      
      private var _selected_skin_piece:Object = null;
      
      public var debug:Boolean;
      
      private var rotation_zone:MovieClip;
      
      public function Skin(param1:Skeleton)
      {
         this.skin_pieces = new Array();
         this.debug = Skeleton.debug;
         super();
         if(this.debug)
         {
            trace("Skin()");
         }
         this._skeleton = param1;
         this._skeleton.addEventListener(SkeletonEvent.CHAR_SEX_CHANGE,this.update_frame_handler,false,0,true);
         this._skeleton.addEventListener(SkeletonEvent.CHAR_BREASTS_CHANGE,this.update_frame_handler,false,0,true);
         this._skeleton.addEventListener(SkeletonEvent.CHAR_CLOTHES_CHANGE,this.update_frame_handler,false,0,true);
         this._skeleton.addEventListener(SkeletonEvent.CHAR_TYPE_CHANGE,this.update_frame_handler,false,0,true);
         this._skeleton.addEventListener(SkeletonEvent.CHAR_HEIGHT_CHANGE,this.update_frame_handler,false,0,true);
         this._skeleton.addEventListener(SkeletonEvent.CHAR_ROT_CHANGE,this.update_frame_handler,false,0,true);
         this._skeleton.addEventListener(SkeletonEvent.CHAR_ROT_CHANGE,this.update_stack_handler,false,0,true);
         this._skeleton.addEventListener(SkeletonEvent.CHAR_ROT_CHANGE,this.update_head_rot_handler,false,0,true);
         this.skin_lookup = new Object();
         this.rotation_zone = new MovieClip();
      }
      
      public function remove() : void
      {
         var _loc1_:int = this.numChildren - 1;
         while(_loc1_ >= 0)
         {
            removeChildAt(_loc1_);
            _loc1_--;
         }
         this.skin_pieces = null;
         this.skin_lookup = null;
         this._skeleton = null;
      }
      
      public function render() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Bone = null;
         var _loc3_:Bone = null;
         var _loc4_:Bone = null;
         var _loc5_:Bone = null;
         var _loc7_:Bone = null;
         if(this.debug)
         {
            trace("Skin.render()");
         }
         _loc1_ = 0;
         while(_loc1_ < this.skin_pieces.length)
         {
            _loc2_ = this._skeleton.get_bone(this.skin_pieces[_loc1_].pos_bone);
            if(_loc2_)
            {
               _loc2_.add_position_skin(this.skin_pieces[_loc1_]);
            }
            _loc3_ = this._skeleton.get_bone(this.skin_pieces[_loc1_].rot_bone);
            if(_loc3_)
            {
               _loc3_.add_rotation_skin(this.skin_pieces[_loc1_]);
            }
            _loc4_ = this._skeleton.get_bone(this.skin_pieces[_loc1_].bend_bone);
            if(_loc4_)
            {
               _loc4_.add_bend_skin(this.skin_pieces[_loc1_]);
            }
            _loc5_ = this._skeleton.get_bone(this.skin_pieces[_loc1_].control_bone);
            if(_loc5_)
            {
               _loc5_.add_control_skin(this.skin_pieces[_loc1_]);
            }
            _loc1_++;
         }
         var _loc6_:Array = this._skeleton.get_bones();
         _loc1_ = 0;
         while(_loc1_ < _loc6_.length)
         {
            _loc7_ = _loc6_[_loc1_];
            _loc7_.addEventListener(SkeletonEvent.BONE_POS_CHANGE,this.update_position_handler,false,0,true);
            _loc7_.addEventListener(SkeletonEvent.BONE_ASPECT_CHANGE,this.update_bend_handler,false,0,true);
            _loc1_++;
         }
         this.update_position(this.skin_pieces);
      }
      
      private function update_frame_handler(param1:Event) : void
      {
         if(this.debug)
         {
            trace("Skin.update_frame_handler from " + param1.target);
         }
         this.update_frame();
      }
      
      public function update_frame() : void
      {
         this.frame = this._skeleton.body_rotation * 3 + this._skeleton.body_height * 5 * 3 + this._skeleton.body_type * 5 * 5 * 3 + 1;
         if(this.debug)
         {
            trace("frame: " + this.frame);
         }
         this.update_side_flip();
         this.update_bend(this.skin_pieces);
         if(this._skeleton is SkeletonBuddy)
         {
            if(this._skeleton.sex == 1 || this._skeleton.breast_type == 3)
            {
               this.skin_lookup.breasts.clip.visible = false;
               this.skin_lookup.breasts_top.clip.visible = false;
            }
            else
            {
               this.skin_lookup.breasts.clip.visible = true;
               this.skin_lookup.breasts_top.clip.visible = true;
            }
         }
      }
      
      private function update_position_handler(param1:Event) : void
      {
         this.update_position(Bone(param1.currentTarget).position_skins);
      }
      
      private function update_position(param1:Array) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Bone = null;
         var _loc4_:Bone = null;
         var _loc5_:Bone = null;
         var _loc6_:Object = null;
         var _loc7_:uint = 0;
         while(_loc7_ < param1.length)
         {
            _loc2_ = param1[_loc7_].clip;
            _loc3_ = this._skeleton.get_bone(param1[_loc7_].pos_bone);
            _loc4_ = this._skeleton.get_bone(param1[_loc7_].rot_bone);
            _loc5_ = this._skeleton.get_bone(param1[_loc7_].control_bone);
            _loc6_ = this._skeleton.get_structure(_loc3_.structure);
            if(param1[_loc7_].type != "shoulderA_OLD" && param1[_loc7_].type != "shoulderB_OLD")
            {
               if(_loc3_.update)
               {
                  _loc2_.x = _loc3_.x;
                  _loc2_.y = _loc3_.y;
                  _loc2_.rotation = _loc4_.rotation - _loc6_.starting_rot;
                  if(this.debug)
                  {
                     trace(param1[_loc7_].name);
                     trace(_loc4_.name);
                     trace(_loc4_.rotation);
                     trace(_loc6_.starting_rot);
                     trace("---");
                  }
                  if(param1[_loc7_].name == "head")
                  {
                     if(this.debug)
                     {
                        trace("adding head skin");
                     }
                  }
                  param1[_loc7_].update = false;
               }
            }
            else
            {
               _loc2_.rotation = _loc4_.rotation - this._skeleton.get_structure("spine").starting_rot;
            }
            _loc7_++;
         }
      }
      
      private function update_bend_handler(param1:Event) : void
      {
         this.update_bend(Bone(param1.currentTarget).bend_skins);
      }
      
      private function update_bend(param1:Array) : void
      {
         var _loc2_:Bone = null;
         var _loc3_:Sprite = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc7_:Number = NaN;
         if(this.debug)
         {
            trace("\nSkin.update_bend() " + param1);
         }
         var _loc6_:uint = 0;
         while(_loc6_ < param1.length)
         {
            if(param1[_loc6_].type != "head" && param1[_loc6_].type != "hand" && param1[_loc6_].type != "hand_top")
            {
               _loc2_ = this._skeleton.get_bone(param1[_loc6_].bend_bone);
               _loc3_ = param1[_loc6_].clip;
               if(_loc2_)
               {
                  _loc7_ = Utils.degrees(_loc2_.internal_rotation + _loc2_.adjustment_rotation);
                  this._skeleton.temp_rot = Math.round(_loc7_ * 100) / 100;
                  if(param1[_loc6_].clip.scaleX == -1)
                  {
                     _loc7_ = Utils.degrees(360 - _loc7_);
                     if(this.debug)
                     {
                        trace("using inverted");
                     }
                  }
                  _loc5_ = param1[_loc6_].type;
                  switch(_loc5_)
                  {
                     case "torso_nude":
                     case "torso_top":
                     case "accfront":
                     case "accback":
                     case "pelvis":
                     case "shirtfront":
                     case "cuff":
                     case "cuff_top":
                     case "fore":
                     case "bicep":
                     case "thigh":
                     case "shin":
                     case "shin_top":
                     case "skirt_shin_OL":
                     case "skirt_thigh_OL":
                     case "skirt_thigh_mask":
                     case "skirt_shin_mask":
                     case "tucked":
                     case "untucked":
                     case "toe":
                        if(_loc7_ > param1[_loc6_].angles[0] || _loc7_ < param1[_loc6_].angles[1])
                        {
                           this.bend_layers(_loc3_,this.frame);
                           if(this.debug)
                           {
                              trace(param1[_loc6_].type + " " + _loc7_ + " CENTER");
                           }
                        }
                        else if(_loc7_ > param1[_loc6_].angles[1] && _loc7_ < param1[_loc6_].angles[2])
                        {
                           this.bend_layers(_loc3_,this.frame + 1);
                           if(this.debug)
                           {
                              trace(param1[_loc6_].type + " " + _loc7_ + " LEFT");
                           }
                        }
                        else
                        {
                           this.bend_layers(_loc3_,this.frame + 2);
                           if(this.debug)
                           {
                              trace(param1[_loc6_].type + " " + _loc7_ + " RIGHT");
                           }
                        }
                        break;
                     case "hipA":
                        _loc4_ = param1[_loc6_].angles[this._skeleton.body_type];
                        if(_loc7_ > _loc4_[0] || _loc7_ < _loc4_[1])
                        {
                           this.bend_layers(_loc3_,this.frame);
                        }
                        else if(_loc7_ > _loc4_[1] && _loc7_ < _loc4_[2])
                        {
                           this.bend_layers(_loc3_,this.frame + 1);
                        }
                        else
                        {
                           this.bend_layers(_loc3_,this.frame + 2);
                        }
                        break;
                     case "hipB":
                        _loc4_ = param1[_loc6_].angles[this._skeleton.body_type];
                        if(_loc7_ > _loc4_[0] || _loc7_ < _loc4_[1])
                        {
                           this.bend_layers(_loc3_,this.frame);
                        }
                        else if(_loc7_ > _loc4_[1] && _loc7_ < _loc4_[2])
                        {
                           this.bend_layers(_loc3_,this.frame + 2);
                        }
                        else
                        {
                           this.bend_layers(_loc3_,this.frame + 1);
                        }
                        break;
                     case "shoulderA":
                        _loc3_.visible = this._skeleton.show_shoulder_patches;
                        _loc4_ = param1[_loc6_].angles[this._skeleton.body_type];
                        if(_loc7_ > _loc4_[0] || _loc7_ < _loc4_[1])
                        {
                           this.bend_layers(_loc3_,this.frame);
                        }
                        else if(_loc7_ > _loc4_[1] && _loc7_ < _loc4_[2])
                        {
                           this.bend_layers(_loc3_,this.frame + 1);
                        }
                        else if(_loc7_ > _loc4_[2] && _loc7_ < _loc4_[3])
                        {
                           this.bend_layers(_loc3_,this.frame + 2);
                        }
                        else if(_loc7_ > _loc4_[3] && _loc7_ < _loc4_[4])
                        {
                           _loc3_.visible = false;
                        }
                        break;
                     case "shoulderB":
                        _loc3_.visible = this._skeleton.show_shoulder_patches;
                        _loc4_ = param1[_loc6_].angles[this._skeleton.body_type];
                        if(_loc7_ < _loc4_[0])
                        {
                           _loc3_.visible = false;
                           if(this.debug)
                           {
                              trace(param1[_loc6_].type + " " + _loc7_ + " INVISIBLE");
                           }
                        }
                        else if(_loc7_ > _loc4_[0] && _loc7_ < _loc4_[1])
                        {
                           this.bend_layers(_loc3_,this.frame);
                           if(this.debug)
                           {
                              trace(param1[_loc6_].type + " " + _loc7_ + " CENTER");
                           }
                        }
                        else if(_loc7_ > _loc4_[1] && _loc7_ < _loc4_[2])
                        {
                           this.bend_layers(_loc3_,this.frame + 1);
                           if(this.debug)
                           {
                              param1[_loc6_].type + " " + _loc7_ + " LEFT";
                           }
                        }
                        else if(_loc7_ > _loc4_[2] && _loc7_ < _loc4_[3])
                        {
                           this.bend_layers(_loc3_,this.frame + 2);
                           if(this.debug)
                           {
                              trace(param1[_loc6_].type + " " + _loc7_ + " RIGHT");
                           }
                        }
                        else if(_loc7_ > _loc4_[3])
                        {
                           _loc3_.visible = false;
                           if(this.debug)
                           {
                              trace(param1[_loc6_].type + " " + _loc7_ + " INVISIBLE");
                           }
                        }
                        break;
                     case "breasts":
                     case "breasts_top":
                        this.bend_layers(_loc3_,this.frame + this._skeleton.breast_type);
                        if(this.debug)
                        {
                           trace("breasts to frame " + String(this._skeleton.breast_type));
                        }
                        break;
                     case "foot":
                     case "foot_top":
                        if(_loc7_ > param1[_loc6_].angles[0] || _loc7_ < param1[_loc6_].angles[1])
                        {
                           this.bend_layers(_loc3_,this.frame);
                           if(this.debug)
                           {
                              trace(param1[_loc6_].type + " " + _loc7_ + " CENTER");
                           }
                        }
                        else if(_loc7_ > param1[_loc6_].angles[1] && _loc7_ < param1[_loc6_].angles[2])
                        {
                           this.bend_layers(_loc3_,this.frame + 2);
                           if(this.debug)
                           {
                              trace(param1[_loc6_].type + " " + _loc7_ + " LEFT");
                           }
                        }
                        else
                        {
                           this.bend_layers(_loc3_,this.frame + 1);
                           if(this.debug)
                           {
                              trace(param1[_loc6_].type + " " + _loc7_ + " RIGHT");
                           }
                        }
                        break;
                     default:
                        if(_loc7_ > param1[_loc6_].angles[0] || _loc7_ < param1[_loc6_].angles[1])
                        {
                           this.bend_layers(_loc3_,this.frame);
                           if(this.debug)
                           {
                              trace(param1[_loc6_].type + " " + _loc7_ + " CENTER");
                           }
                        }
                        else if(_loc7_ > param1[_loc6_].angles[1] && _loc7_ < param1[_loc6_].angles[2])
                        {
                           this.bend_layers(_loc3_,this.frame + 2);
                           if(this.debug)
                           {
                              trace(param1[_loc6_].type + " " + _loc7_ + " LEFT");
                           }
                        }
                        else
                        {
                           this.bend_layers(_loc3_,this.frame + 1);
                           if(this.debug)
                           {
                              trace(param1[_loc6_].type + " " + _loc7_ + " RIGHT");
                           }
                        }
                  }
               }
               else
               {
                  this.bend_layers(_loc3_,this.frame);
               }
            }
            _loc6_++;
         }
      }
      
      private function bend_layers(param1:Sprite, param2:uint) : void
      {
         if(param1.numChildren == 0)
         {
            return;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc3_) is MovieClip)
            {
               MovieClip(param1.getChildAt(_loc3_)).gotoAndStop(param2);
            }
            _loc3_++;
         }
         if(this.skin_lookup["pelvis"])
         {
            this.update_rotation_zone();
         }
      }
      
      public function add_skin_piece(param1:Object) : void
      {
         this.skin_pieces.push(param1);
         this.skin_lookup[param1.name] = param1;
      }
      
      public function add_skin_layer(param1:String, param2:DisplayObjectContainer) : void
      {
         var depth:int = 0;
         var i:int = 0;
         var piece:* = undefined;
         var toe_bit:MovieClip = null;
         var piece_name:String = param1;
         var skin_clip:DisplayObjectContainer = param2;
         if(!this.skin_lookup[piece_name])
         {
            return;
         }
         var clip:Sprite = this.skin_lookup[piece_name].clip;
         if(skin_clip.hasOwnProperty("depth"))
         {
            depth = Object(skin_clip).depth;
            i = 0;
            while(i < clip.numChildren)
            {
               piece = clip.getChildAt(i);
               if(piece.depth && piece.depth > depth)
               {
                  clip.addChildAt(skin_clip,i);
                  return;
               }
               i++;
            }
         }
         clip.addChild(skin_clip);
         if(this.debug)
         {
            trace("clip depth:" + clip.getChildIndex(skin_clip));
         }
         if(piece_name == "footL" || piece_name == "footR" || piece_name == "foot_topL" || piece_name == "foot_topR")
         {
            toe_bit = new MovieClip();
            toe_bit.name = "toe_bit";
            toe_bit.graphics.beginFill(65280,0);
            toe_bit.graphics.drawCircle(0,15,15);
            toe_bit.x = -20;
            toe_bit.flip = function(param1:Event):void
            {
               if((param1.currentTarget as Skeleton).body_rotation == 0 || (param1.currentTarget as Skeleton).body_rotation == 4)
               {
                  toe_bit.x = -20;
               }
               else
               {
                  toe_bit.x = 20;
               }
            };
            clip.addChild(toe_bit);
            this._skeleton.addEventListener(SkeletonEvent.CHAR_ROT_CHANGE,toe_bit.flip,false,0,true);
         }
         if(piece_name == "pelvis")
         {
            if(DisplayObjectContainer(this.skin_lookup["control_zone"].clip).numChildren == 0)
            {
               this.add_skin_layer("control_zone",new MovieClip());
            }
         }
         if(piece_name == "control_zone")
         {
            clip.addChild(this.rotation_zone);
            trace(clip.getChildIndex(this.rotation_zone));
         }
      }
      
      public function remove_skin_layer(param1:String, param2:String) : void
      {
         var _loc5_:DisplayObject = null;
         if(!this.skin_lookup[param1])
         {
            return;
         }
         var _loc3_:Sprite = this.skin_lookup[param1].clip;
         var _loc4_:int = _loc3_.numChildren - 1;
         while(_loc4_ >= 0)
         {
            _loc5_ = _loc3_.getChildAt(_loc4_);
            if(_loc5_.name.indexOf(param2) > 0)
            {
               _loc3_.removeChild(_loc5_);
            }
            _loc4_--;
         }
      }
      
      private function update_stack_handler(param1:Event) : void
      {
         this.restack(this._skeleton.get_skin_stack());
         this._skeleton.manage_head_rotation();
      }
      
      public function restack(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc6_:Array = null;
         if(this.debug)
         {
            trace("Skin.restack() - stack_list: " + param1);
         }
         _loc2_ = this.numChildren;
         while(_loc2_ > 0)
         {
            this.removeChildAt(_loc2_ - 1);
            _loc2_--;
         }
         if(Skeleton.debug)
         {
            trace("stack_list");
         }
         var _loc5_:int = 0;
         if(this._skeleton.pose.default_skin_stack)
         {
            _loc6_ = this._skeleton.pose.default_skin_stack[this._skeleton.body_rotation];
         }
         _loc5_ = _loc6_.indexOf("control_zone");
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(_loc2_ == _loc5_)
            {
               this.addChild(this.skin_lookup["control_zone"].clip);
            }
            if(this.debug)
            {
               trace("stack_list[i]: " + param1[_loc2_]);
            }
            _loc4_ = this._skeleton.get_stack_group(param1[_loc2_]);
            if(this.debug)
            {
               trace("stack_group: " + _loc4_);
            }
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               this.addChild(this.skin_lookup[_loc4_[_loc3_]].clip);
               if(this.debug)
               {
                  trace("stacking " + _loc4_[_loc3_]);
               }
               _loc3_++;
            }
            _loc2_++;
         }
         dispatchEvent(new Event(SkeletonEvent.SKIN_RESTACK));
      }
      
      private function update_side_flip_handler(param1:Event) : void
      {
         this.update_side_flip();
      }
      
      public function update_side_flip() : void
      {
         if(this._skeleton is SkeletonQuadruped)
         {
            return;
         }
         if(this.debug)
         {
            trace("Skin.update_side_flip()");
         }
         var _loc1_:uint = 0;
         while(_loc1_ < this.skin_pieces.length)
         {
            switch(this.skin_pieces[_loc1_].type)
            {
               case "foot":
               case "foot_top":
                  switch(this._skeleton.body_rotation)
                  {
                     case 0:
                     case 4:
                        switch(this.skin_pieces[_loc1_].side)
                        {
                           case "center":
                           case "left":
                              this.skin_pieces[_loc1_].clip.scaleX = 1;
                              break;
                           case "right":
                              this.skin_pieces[_loc1_].clip.scaleX = -1;
                        }
                        break;
                     default:
                        this.skin_pieces[_loc1_].clip.scaleX = 1;
                  }
                  break;
               case "hand":
               case "hand_top":
                  switch(this._skeleton.body_rotation)
                  {
                     case 0:
                     case 4:
                        switch(this.skin_pieces[_loc1_].side)
                        {
                           case "center":
                           case "left":
                              this.skin_pieces[_loc1_].clip.scaleX = 1;
                              break;
                           case "right":
                              this.skin_pieces[_loc1_].clip.scaleX = -1;
                        }
                        break;
                     case 1:
                     case 2:
                     case 3:
                        switch(this.skin_pieces[_loc1_].side)
                        {
                           case "center":
                              this.skin_pieces[_loc1_].clip.scaleX = 1;
                              break;
                           case "right":
                           case "left":
                              this.skin_pieces[_loc1_].clip.scaleX = -1;
                        }
                  }
                  break;
               case "head":
               case "head_back":
                  break;
               default:
                  switch(this._skeleton.body_rotation)
                  {
                     case 0:
                     case 4:
                        switch(this.skin_pieces[_loc1_].side)
                        {
                           case "right":
                              this.skin_pieces[_loc1_].clip.scaleX = -1;
                              break;
                           case "center":
                           case "left":
                              this.skin_pieces[_loc1_].clip.scaleX = 1;
                        }
                        break;
                     case 1:
                     case 2:
                     case 3:
                        switch(this.skin_pieces[_loc1_].side)
                        {
                           case "right":
                              this.skin_pieces[_loc1_].clip.scaleX = -1;
                              break;
                           case "left":
                           case "center":
                              this.skin_pieces[_loc1_].clip.scaleX = 1;
                        }
                  }
            }
            _loc1_++;
         }
      }
      
      private function update_head_rot_handler(param1:Event) : void
      {
         if(this.debug)
         {
            trace(this.skin_lookup.head);
         }
      }
      
      public function get_skin_pieces() : Array
      {
         return this.skin_pieces;
      }
      
      public function get_skin_piece(param1:String) : Object
      {
         return this.skin_lookup[param1];
      }
      
      public function get selected_skin_piece() : Object
      {
         return this._selected_skin_piece;
      }
      
      public function set selected_skin_piece(param1:Object) : void
      {
         if(this.debug)
         {
            trace("selecting skin piece " + param1.name);
         }
         this._selected_skin_piece = param1;
         this.dispatchEvent(new Event(SkeletonEvent.SKIN_SELECT));
      }
      
      public function hide(param1:String, param2:Boolean) : void
      {
         if(this.skin_lookup.hasOwnProperty(param1))
         {
            this.skin_lookup[param1].clip.visible = !param2;
            if(param2)
            {
               if(this.debug)
               {
                  trace("HIDING " + param1);
               }
            }
         }
      }
      
      public function update_rotation_zone() : void
      {
         this.rotation_zone.graphics.clear();
         this.rotation_zone.graphics.beginFill(65280,0);
         var _loc1_:Sprite = this.skin_lookup["pelvis"].clip;
         var _loc2_:Number = _loc1_.width * 0.8;
         var _loc3_:Number = _loc1_.height * 0.8;
         this.rotation_zone.graphics.drawRect(0 - _loc2_ / 2,0 - _loc3_,_loc2_,_loc3_);
      }
   }
}
