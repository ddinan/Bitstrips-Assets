package com.bitstrips.character.skeleton
{
   import com.bitstrips.Utils;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class SkeletonController
   {
       
      
      private var _bone_control:Boolean = false;
      
      private var skin_selection:Boolean = false;
      
      private var showing_hidden_bicep:Boolean = false;
      
      private var bone_down_point:Point;
      
      public var selected_skin_patch;
      
      private var saved_bone_rotation:Number;
      
      private var hidden_stuff:Sprite;
      
      private var ct_hilight:ColorTransform;
      
      public var selected_bone:Bone = null;
      
      private var _skeleton:Skeleton;
      
      private var bone_interface_clip:Sprite;
      
      private var ct_normal:ColorTransform;
      
      private var _interface:SkeletonInterface;
      
      private var temp_skin_list:Array;
      
      public function SkeletonController(param1:Skeleton, param2:SkeletonInterface)
      {
         temp_skin_list = new Array();
         super();
         _skeleton = param1;
         _interface = param2;
         ct_hilight = new ColorTransform(1.5,1.5,1.5);
         ct_normal = new ColorTransform();
         bone_interface_clip = new Sprite();
         bone_interface_clip.visible = false;
         hidden_stuff = new Sprite();
         hidden_stuff.graphics.beginFill(65280,0.5);
         hidden_stuff.graphics.drawRect(-100,-100,200,200);
      }
      
      private function bone_move_around(param1:Event) : void
      {
      }
      
      public function set bone_control(param1:Boolean) : void
      {
         _bone_control = param1;
         apply_control();
      }
      
      public function enable_skin_selection(param1:Boolean) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:Sprite = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc2_:Array = _skeleton.skin.get_skin_pieces();
         skin_selection = param1;
         if(skin_selection)
         {
            update_skin_listeners();
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               _loc3_ = DisplayObjectContainer(_loc2_[_loc5_].clip);
               _loc6_ = 0;
               while(_loc6_ < _loc3_.numChildren)
               {
                  _loc4_ = Sprite(_loc3_.getChildAt(_loc6_));
                  _loc4_.buttonMode = false;
                  if(_loc4_.hasEventListener(MouseEvent.CLICK))
                  {
                     _loc4_.removeEventListener(MouseEvent.CLICK,skin_patch_click);
                  }
                  _loc6_++;
               }
               _loc5_++;
            }
         }
      }
      
      private function select_none(param1:MouseEvent) : void
      {
         select_bone(null);
      }
      
      public function update_skin_listeners() : void
      {
         var _loc2_:DisplayObjectContainer = null;
         var _loc3_:Sprite = null;
         var _loc5_:int = 0;
         if(skin_selection == false)
         {
            return;
         }
         var _loc1_:Array = _skeleton.skin.get_skin_pieces();
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_.length)
         {
            _loc2_ = Sprite(_loc1_[_loc4_].clip);
            _loc5_ = 0;
            while(_loc5_ < _loc2_.numChildren)
            {
               _loc3_ = Sprite(_loc2_.getChildAt(_loc5_));
               if(_loc3_.hasEventListener(MouseEvent.CLICK) == false)
               {
                  _loc3_.addEventListener(MouseEvent.CLICK,skin_patch_click,false,0,true);
                  _loc3_.buttonMode = true;
               }
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      private function skin_patch_click(param1:MouseEvent) : void
      {
         if(this.skin_selection)
         {
            selected_skin_patch = param1.currentTarget;
            param1.stopImmediatePropagation();
            _skeleton.dispatchEvent(new Event("clothing_click"));
         }
      }
      
      public function enable_relocation_control(param1:Boolean) : void
      {
         if(!param1)
         {
         }
      }
      
      public function apply_control() : void
      {
         _skeleton.mouseChildren = bone_control;
         enable_bone_control(bone_control);
      }
      
      private function bone_out(param1:Event) : void
      {
      }
      
      public function enable_bone_control(param1:Boolean) : void
      {
         var _loc3_:Bone = null;
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         _bone_control = param1;
         var _loc2_:Array = _skeleton.skin.get_skin_pieces();
         if(_skeleton.stage)
         {
            _skeleton.stage.doubleClickEnabled = true;
         }
         if(param1)
         {
            _skeleton.removeEventListener(MouseEvent.DOUBLE_CLICK,skin_doubleclick);
            if(_skeleton.stage)
            {
               _skeleton.stage.addEventListener(MouseEvent.DOUBLE_CLICK,skin_doubleclick,false,0,true);
            }
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               _loc6_ = _loc2_[_loc5_].name;
               _loc4_ = DisplayObjectContainer(_loc2_[_loc5_].clip);
               _loc4_.mouseChildren = false;
               _loc3_ = _skeleton.get_bone(_loc2_[_loc5_].control_bone);
               _loc4_.addEventListener(MouseEvent.MOUSE_OVER,_loc3_.bone_over,false,0,true);
               _loc4_.addEventListener(MouseEvent.MOUSE_OUT,_loc3_.bone_out,false,0,true);
               _loc4_.addEventListener(MouseEvent.MOUSE_DOWN,_loc3_.bone_down,false,0,true);
               _loc4_.addEventListener(MouseEvent.MOUSE_MOVE,_loc3_.bone_move_around,false,0,true);
               _loc4_.addEventListener(MouseEvent.CLICK,_loc3_.bone_click,false,0,true);
               _loc4_.addEventListener(MouseEvent.MOUSE_DOWN,select_skin);
               _loc3_.addEventListener("bone_over",bone_over,false,0,true);
               _loc3_.addEventListener("bone_out",bone_out,false,0,true);
               _loc3_.addEventListener("bone_down",bone_down,false,0,true);
               _loc3_.addEventListener("bone_up",bone_up,false,0,true);
               _loc3_.addEventListener("bone_move_around",bone_move_around,false,0,true);
               if(_skeleton.stage)
               {
                  _skeleton.stage.addEventListener(MouseEvent.MOUSE_MOVE,bone_detector,false,0,true);
               }
               _loc5_++;
            }
         }
         else
         {
            _skeleton.addEventListener(MouseEvent.DOUBLE_CLICK,skin_doubleclick,false,0,true);
            if(_skeleton.stage)
            {
               _skeleton.stage.removeEventListener(MouseEvent.DOUBLE_CLICK,skin_doubleclick);
            }
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length)
            {
               _loc4_ = DisplayObjectContainer(_loc2_[_loc5_].clip);
               _loc3_ = _skeleton.get_bone(_loc2_[_loc5_].control_bone);
               _loc4_.removeEventListener(MouseEvent.MOUSE_OVER,_loc3_.bone_over);
               _loc4_.removeEventListener(MouseEvent.MOUSE_OUT,_loc3_.bone_out);
               _loc4_.removeEventListener(MouseEvent.MOUSE_DOWN,_loc3_.bone_down);
               _loc4_.removeEventListener(MouseEvent.CLICK,_loc3_.bone_click);
               _loc4_.removeEventListener(MouseEvent.CLICK,select_skin);
               _loc3_.removeEventListener("bone_over",bone_over);
               _loc3_.removeEventListener("bone_out",bone_out);
               _loc3_.removeEventListener("bone_down",bone_down);
               _loc3_.removeEventListener("bone_up",bone_up);
               if(_skeleton.stage)
               {
                  _skeleton.stage.removeEventListener(MouseEvent.CLICK,select_none);
                  _skeleton.stage.removeEventListener(MouseEvent.MOUSE_MOVE,bone_detector);
               }
               _loc5_++;
            }
            select_bone(null);
         }
      }
      
      private function select_skin(param1:MouseEvent) : void
      {
         var _loc2_:Array = _skeleton.skin.get_skin_pieces();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].clip == param1.currentTarget)
            {
               _skeleton.skin.selected_skin_piece = _loc2_[_loc3_];
               break;
            }
            _loc3_++;
         }
         _skeleton.dispatchEvent(new Event("select_skin_piece"));
      }
      
      private function skin_doubleclick(param1:MouseEvent) : void
      {
         if(Skeleton.debug)
         {
            trace("doubleclick");
         }
         bone_control = !bone_control;
         param1.stopImmediatePropagation();
      }
      
      public function get bone_control() : Boolean
      {
         return _bone_control;
      }
      
      private function draw_bone_graphic(param1:Bone, param2:Sprite) : void
      {
         var _loc3_:Sprite = param2;
         var _loc4_:Point = param1.get_position();
         if(_skeleton.flipped)
         {
            _loc4_.x = 0 - _loc4_.x;
         }
         _loc3_.graphics.clear();
         switch(selected_bone.name)
         {
            case "spine_1":
            case "toeL":
            case "toeR":
               return;
            default:
               _loc3_.graphics.beginFill(65280);
               _loc3_.graphics.drawCircle(_loc4_.x,_loc4_.y,3);
               _loc3_.graphics.endFill();
               _loc3_.graphics.lineStyle(1,6737151,0.5);
               _loc3_.graphics.drawCircle(_loc4_.x,_loc4_.y,param1.length);
               _loc3_.graphics.lineStyle(2,65280,1);
               _loc3_.graphics.moveTo(_loc4_.x,_loc4_.y);
               _loc3_.graphics.lineTo(_skeleton.mouseX,_skeleton.mouseY);
               return;
         }
      }
      
      public function select_bone(param1:Bone) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         var _loc6_:DisplayObjectContainer = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Number = NaN;
         if(selected_bone)
         {
            _loc2_ = selected_bone.control_skins;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc2_[_loc3_].clip.transform.colorTransform = ct_normal;
               _loc3_++;
            }
         }
         selected_bone = param1;
         if(selected_bone)
         {
            if(selected_bone.name == "footL")
            {
               _loc7_ = 0;
               while(_loc7_ < selected_bone.control_skins.length)
               {
                  _loc6_ = DisplayObjectContainer(selected_bone.control_skins[_loc7_].clip);
                  _loc8_ = 0;
                  while(_loc8_ < _loc6_.numChildren)
                  {
                     if(_loc6_.getChildAt(_loc8_) is MovieClip)
                     {
                        if(MovieClip(_loc6_.getChildAt(_loc8_)).name == "toe_bit")
                        {
                           if(_loc6_.getChildAt(_loc8_).hitTestPoint(_skeleton.stage.mouseX,_skeleton.stage.mouseY,true))
                           {
                              trace("hit");
                              selected_bone = _skeleton.get_bone("toeL");
                           }
                        }
                     }
                     _loc8_++;
                  }
                  _loc7_++;
               }
            }
            if(selected_bone.name == "footR")
            {
               _loc7_ = 0;
               while(_loc7_ < selected_bone.control_skins.length)
               {
                  _loc6_ = DisplayObjectContainer(selected_bone.control_skins[_loc7_].clip);
                  _loc8_ = 0;
                  while(_loc8_ < _loc6_.numChildren)
                  {
                     if(_loc6_.getChildAt(_loc8_) is MovieClip)
                     {
                        if(MovieClip(_loc6_.getChildAt(_loc8_)).name == "toe_bit")
                        {
                           if(_loc6_.getChildAt(_loc8_).hitTestPoint(_skeleton.stage.mouseX,_skeleton.stage.mouseY,true))
                           {
                              trace("hit");
                              selected_bone = _skeleton.get_bone("toeR");
                           }
                        }
                     }
                     _loc8_++;
                  }
                  _loc7_++;
               }
            }
            _loc9_ = 30;
            if(selected_bone.name == "head")
            {
               _loc4_ = Point.distance(_skeleton.localToGlobal(new Point(_skeleton.get_bone("neck").x,_skeleton.get_bone("neck").y)),new Point(_skeleton.stage.mouseX,_skeleton.stage.mouseY));
               if(_loc4_ < _loc9_)
               {
                  selected_bone = _skeleton.get_bone("neck");
               }
            }
            _loc2_ = selected_bone.control_skins;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc2_[_loc3_].clip.transform.colorTransform = ct_hilight;
               _loc3_++;
            }
         }
      }
      
      private function bone_over(param1:Event) : void
      {
      }
      
      private function bone_detector(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc3_:Boolean = false;
         switch(_skeleton.body_rotation)
         {
            case 0:
            case 1:
            case 2:
               _loc5_ = "bicepR";
               break;
            case 4:
            case 5:
            default:
               _loc5_ = "bicepL";
         }
         if(!(_skeleton is SkeletonBuddy))
         {
            return;
         }
         if(!param1.buttonDown || selected_bone == null || selected_bone.name == _loc5_)
         {
            if(_skeleton.skin.get_skin_piece("torso_nude").clip.hitTestPoint(param1.stageX,param1.stageY,true) || _skeleton.skin.get_skin_piece("torso_top").clip.hitTestPoint(param1.stageX,param1.stageY,true))
            {
               trace("hit on torso");
               if(_skeleton.skin.get_skin_piece(_loc5_).clip.hitTestPoint(param1.stageX,param1.stageY,true) || hidden_stuff.hitTestPoint(param1.stageX,param1.stageY,true))
               {
                  _loc3_ = true;
               }
            }
         }
         if(_loc3_ && !showing_hidden_bicep)
         {
            _loc2_ = _skeleton.get_bone("spine_2").control_skins;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc2_[_loc4_].clip.addEventListener(MouseEvent.MOUSE_DOWN,_skeleton.get_bone(_loc5_).bone_down,false,0,true);
               _loc4_++;
            }
            showing_hidden_bicep = true;
            hidden_stuff.x = _skeleton.get_bone(_loc5_).get_position().x;
            hidden_stuff.y = _skeleton.get_bone(_loc5_).get_position().y;
            hidden_stuff.mask = DisplayObject(_skeleton.skin.get_skin_piece(_loc5_).clip);
            hidden_stuff.addEventListener(MouseEvent.MOUSE_DOWN,_skeleton.get_bone(_loc5_).bone_down,false,0,true);
            _skeleton.addChild(hidden_stuff);
         }
         else if(!_loc3_ && showing_hidden_bicep)
         {
            _loc2_ = _skeleton.get_bone("spine_2").control_skins;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc2_[_loc4_].clip.removeEventListener(MouseEvent.MOUSE_DOWN,_skeleton.get_bone(_loc5_).bone_down);
               _loc4_++;
            }
            showing_hidden_bicep = false;
            _skeleton.removeChild(hidden_stuff);
            hidden_stuff.mask = null;
            hidden_stuff.removeEventListener(MouseEvent.MOUSE_DOWN,_skeleton.get_bone(_loc5_).bone_down);
         }
      }
      
      public function init() : void
      {
         if(Skeleton.debug)
         {
            trace("SkeletonController.init()");
         }
         _bone_control = false;
      }
      
      private function bone_up(param1:MouseEvent) : void
      {
         _skeleton.stage.removeEventListener(MouseEvent.MOUSE_UP,bone_up);
         _skeleton.stage.removeEventListener(MouseEvent.MOUSE_MOVE,bone_move);
         _skeleton.removeChild(bone_interface_clip);
      }
      
      private function bone_move(param1:MouseEvent) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc8_:Bone = null;
         var _loc9_:int = 0;
         var _loc10_:Point = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Point = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc2_:Number = selected_bone.graphic.parent.mouseX - selected_bone.x;
         if(_skeleton.flipped)
         {
            _loc2_ = 0 - selected_bone.graphic.parent.mouseX - selected_bone.x;
         }
         var _loc3_:Number = selected_bone.graphic.parent.mouseY - selected_bone.y;
         var _loc4_:Number = Math.atan2(_loc3_,_loc2_);
         switch(selected_bone.name)
         {
            case "spine_1":
               _loc5_ = Utils.degrees(saved_bone_rotation + _loc2_ / 2);
               _skeleton.dispatchEvent(new Event("body rotate"));
               break;
            case "toeL":
            case "toeR":
               _loc9_ = 1;
               _loc10_ = new Point(selected_bone.graphic.parent.mouseX,selected_bone.graphic.parent.mouseY);
               _loc2_ = _loc10_.x - bone_down_point.x;
               if(_skeleton.flipped)
               {
                  _loc2_ = 0 - _loc2_;
               }
               _loc3_ = _loc10_.y - bone_down_point.y;
               _loc4_ = Math.atan2(_loc3_,_loc2_);
               if(selected_bone.name == "toeL")
               {
                  _loc8_ = _skeleton.get_bone("footL");
               }
               else
               {
                  _loc8_ = _skeleton.get_bone("footR");
               }
               _loc5_ = Utils.degrees(_loc4_ * 180 / Math.PI - _loc8_.rotation - 90);
               if(_loc5_ > 45 && _loc5_ < 135)
               {
                  _loc9_ = 1;
               }
               else if(_loc5_ > 225 && _loc5_ < 315)
               {
                  _loc9_ = -1;
               }
               else
               {
                  _loc9_ = 0;
               }
               _loc6_ = Utils.distance(bone_down_point,_loc10_) * _loc9_;
               if(selected_bone.name == "toeR" && (_skeleton.body_rotation == 0 || _skeleton.body_rotation == 4))
               {
                  if(_loc6_ > 20)
                  {
                     _loc5_ = 71;
                  }
                  else if(_loc6_ < -20)
                  {
                     _loc5_ = 181;
                  }
                  else
                  {
                     _loc5_ = 291;
                  }
               }
               else if(_loc6_ > 20)
               {
                  _loc5_ = 181;
               }
               else if(_loc6_ < -20)
               {
                  _loc5_ = 71;
               }
               else
               {
                  _loc5_ = 291;
               }
               _loc5_ = _loc5_ + selected_bone.inherited_rotation + selected_bone.adjustment_rotation;
               break;
            default:
               _loc5_ = Utils.degrees(_loc4_ * 180 / Math.PI);
         }
         if(selected_bone.name == "spine_2")
         {
            _loc5_ = Utils.degrees(_loc5_ - selected_bone.inherited_rotation);
            if(Skeleton.debug)
            {
               trace("rot: " + _loc5_);
            }
            _loc11_ = Utils.degrees(-25);
            _loc12_ = 25;
            _loc13_ = 180;
            if(_loc5_ < _loc11_ && _loc5_ > _loc13_)
            {
               _loc5_ = _loc11_;
            }
            else if(_loc5_ > _loc12_ && _loc5_ < _loc13_)
            {
               _loc5_ = _loc12_;
            }
            else
            {
               _loc5_ = 0;
            }
            _loc5_ = _loc5_ + selected_bone.inherited_rotation;
            _loc5_ = Utils.degrees(_loc5_ + 360);
         }
         var _loc7_:Number = selected_bone.internal_rotation;
         selected_bone.internal_rotation_move = _loc5_ - selected_bone.inherited_rotation - selected_bone.adjustment_rotation;
         if(_skeleton.is_wearing("skirt"))
         {
            if(selected_bone.name == "thighR" || selected_bone.name == "thighL")
            {
               _loc14_ = _skeleton.get_bone("spine_1").get_position();
               _loc15_ = Utils.get_degrees_from_points(_loc14_,_skeleton.get_bone("shinR").get_position());
               _loc16_ = Utils.get_degrees_from_points(_loc14_,_skeleton.get_bone("shinL").get_position());
               _loc17_ = 11;
               _loc18_ = Utils.degrees(_loc16_ - _loc15_);
               if(Skeleton.debug)
               {
                  trace("left_angle after: " + _loc16_);
                  trace("right_angle after: " + _loc15_);
                  trace("angle_diff: " + _loc18_);
               }
               if(_loc18_ < _loc17_ || _loc18_ > 180)
               {
                  selected_bone.internal_rotation_move = _loc7_;
               }
            }
            if(selected_bone.name == "shinR" || selected_bone.name == "shinL")
            {
               if(Utils.intersection(_skeleton.get_bone("shinR").get_position(),_skeleton.get_bone("shinR").get_proto_point(100,0),_skeleton.get_bone("shinL").get_position(),_skeleton.get_bone("shinL").get_proto_point(100,0)))
               {
                  selected_bone.internal_rotation_move = _loc7_;
               }
            }
         }
         _skeleton.update_bone_positions();
         draw_bone_graphic(selected_bone,bone_interface_clip);
         if(_skeleton is SkeletonBuddy && selected_bone.name != "head")
         {
            SkeletonBuddy(_skeleton).mode = 3;
         }
      }
      
      private function bone_down(param1:Event) : void
      {
         trace(Bone(param1.currentTarget).name + " bone down");
         select_bone(Bone(param1.currentTarget));
         _skeleton.stage.addEventListener(MouseEvent.MOUSE_UP,bone_up,false,0,true);
         _skeleton.stage.addEventListener(MouseEvent.MOUSE_MOVE,bone_move,false,0,true);
         param1.stopImmediatePropagation();
         draw_bone_graphic(selected_bone,bone_interface_clip);
         _skeleton.addChild(bone_interface_clip);
         saved_bone_rotation = selected_bone.rotation;
         bone_down_point = new Point(selected_bone.graphic.parent.mouseX,selected_bone.graphic.parent.mouseY);
         if(Bone(param1.currentTarget).name == "handL")
         {
            _skeleton.dispatchEvent(new Event("body_left_hand_click"));
         }
         else if(Bone(param1.currentTarget).name == "handR")
         {
            _skeleton.dispatchEvent(new Event("body_right_hand_click"));
         }
      }
   }
}
