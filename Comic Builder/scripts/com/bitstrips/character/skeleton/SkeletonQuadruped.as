package com.bitstrips.character.skeleton
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.CharLoader;
   import com.bitstrips.character.HeadBase;
   import com.bitstrips.core.ArtLoader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class SkeletonQuadruped extends Skeleton
   {
      
      public static const pose_defaults:Object = {
         "skin_stack":[["torso","tail","legFR","legFL","legBR","legBL","neck","head","control_zone"],["torso","tail","legFR","legFL","legBR","legBL","neck","head","control_zone"],["torso","tail","legFR","legFL","legBR","legBL","neck","head","control_zone"],["torso","tail","legFR","legFL","legBR","legBL","neck","head","control_zone"],["torso","tail","legFR","legFL","legBR","legBL","neck","head","control_zone"]],
         "_default_skin_stack":[["control_zone"],["control_zone"],["control_zone"],["control_zone"],["control_zone"]],
         "_simple_stack_bottom":[],
         "_simple_stack_top":[]
      };
       
      
      private var front_legs:Array;
      
      private var back_legs:Array;
      
      public const head_adjustment:Number = -30;
      
      private var _hands:Array;
      
      private var _mode:uint = 0;
      
      private var _action:uint = 0;
      
      private var _gesture:uint = 0;
      
      private var _stance:uint = 1;
      
      public function SkeletonQuadruped(param1:HeadBase, param2:ArtLoader, param3:Object, param4:Boolean = true)
      {
         this._hands = new Array(2);
         super(param1,param2,param3,param4);
      }
      
      override public function init() : void
      {
         super.init();
         _pose = new Pose(null,SkeletonQuadruped.pose_defaults);
         this.front_legs = new Array();
         this.back_legs = new Array();
         var _loc1_:BoneStructure = new BoneStructure("spine",0,"spine_base");
         add_bone(_loc1_,new Bone("spine_1","spine_1","spine"),null);
         add_bone(_loc1_,new Bone("spine_2","spine_2","spine"),get_bone("spine_1"));
         var _loc2_:BoneStructure = new BoneStructure("neck",270,"neck");
         add_bone(_loc2_,new Bone("neck","neck","neck",[-28,28]),null);
         add_bone(_loc2_,new Bone("head","head","neck",[-60,60]),get_bone("neck"));
         var _loc3_:BoneStructure = new BoneStructure("tail",270,"tail_base");
         add_bone(_loc3_,new Bone("tail_1","tail_1","tail",[-28,28]),null);
         add_bone(_loc3_,new Bone("tail_2","tail_2","tail",[-60,60]),get_bone("tail_1"));
         var _loc4_:BoneStructure = new BoneStructure("legF",90,"shoulder_R");
         add_bone(_loc4_,new Bone("thighFR","thighF","legFR"),null);
         add_bone(_loc4_,new Bone("shinFR","shinF","legFR"),get_bone("thighFR"));
         add_bone(_loc4_,new Bone("ankleFR","ankleF","legFR"),get_bone("shinFR"));
         add_bone(_loc4_,new Bone("footFR","footF","legFR"),get_bone("ankleFR"));
         this.front_legs.push(_loc4_);
         var _loc5_:BoneStructure = new BoneStructure("legF",90,"shoulder_L");
         add_bone(_loc5_,new Bone("thighFL","thighF","legFL"),null);
         add_bone(_loc5_,new Bone("shinFL","shinF","legFL"),get_bone("thighFL"));
         add_bone(_loc5_,new Bone("ankleFL","ankleF","legFL"),get_bone("shinFL"));
         add_bone(_loc5_,new Bone("footFL","footF","legFL"),get_bone("ankleFL"));
         this.front_legs.push(_loc5_);
         var _loc6_:BoneStructure = new BoneStructure("legB",90,"hip_R",new Array());
         add_bone(_loc6_,new Bone("thighBR","thighB","legBR"),null);
         add_bone(_loc6_,new Bone("shinBR","shinB","legBR"),get_bone("thighBR"));
         add_bone(_loc6_,new Bone("ankleBR","ankleB","legBR"),get_bone("shinBR"));
         add_bone(_loc6_,new Bone("footBR","footB","legBR"),get_bone("ankleBR"));
         this.back_legs.push(_loc6_);
         var _loc7_:BoneStructure = new BoneStructure("legB",90,"hip_L");
         add_bone(_loc7_,new Bone("thighBL","thighB","legBL"),null);
         add_bone(_loc7_,new Bone("shinBL","shinB","legBL"),get_bone("thighBL"));
         add_bone(_loc7_,new Bone("ankleBL","ankleB","legBL"),get_bone("shinBL"));
         add_bone(_loc7_,new Bone("footBL","footB","legBL"),get_bone("ankleBL"));
         this.back_legs.push(_loc7_);
         bone_structures = [_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_];
         structure_lookup = {
            "spine":_loc1_,
            "neck":_loc2_,
            "tail":_loc3_,
            "legFR":_loc4_,
            "legFL":_loc5_,
            "legBR":_loc6_,
            "legBL":_loc7_
         };
         _skin.add_skin_piece({
            "name":"torso",
            "type":"torso",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_1",
            "side":"center",
            "angles":[360,0,180],
            "stack_group":"torso"
         });
         _skin.add_skin_piece({
            "name":"tail",
            "type":"tail",
            "clip":new Sprite(),
            "pos_bone":"tail_1",
            "rot_bone":"tail_1",
            "bend_bone":"tail_2",
            "control_bone":"tail_1",
            "side":"center",
            "angles":[360,0,180],
            "stack_group":"tail"
         });
         _skin.add_skin_piece({
            "name":"neck",
            "type":"neck",
            "clip":new Sprite(),
            "pos_bone":"neck",
            "rot_bone":"neck",
            "bend_bone":"neck",
            "control_bone":"neck",
            "side":"center",
            "angles":[360,0,180],
            "stack_group":"neck"
         });
         _skin.add_skin_piece({
            "name":"head",
            "type":"head",
            "clip":new Sprite(),
            "pos_bone":"head",
            "rot_bone":"head",
            "bend_bone":"head",
            "control_bone":"head",
            "side":"center",
            "angles":[300,0,180],
            "stack_group":"head"
         });
         _skin.add_skin_piece({
            "name":"control_zone",
            "type":"control_zone",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_1",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"control_zone"
         });
         _skin.add_skin_piece({
            "name":"thighFR",
            "type":"thighF",
            "clip":new Sprite(),
            "pos_bone":"thighFR",
            "rot_bone":"thighFR",
            "bend_bone":"thighFR",
            "control_bone":"thighFR",
            "side":"right",
            "angles":[300,0,180],
            "stack_group":"legFR"
         });
         _skin.add_skin_piece({
            "name":"shinFR",
            "type":"shinF",
            "clip":new Sprite(),
            "pos_bone":"shinFR",
            "rot_bone":"shinFR",
            "bend_bone":"shinFR",
            "control_bone":"shinFR",
            "side":"right",
            "angles":[300,0,180],
            "stack_group":"legFR"
         });
         _skin.add_skin_piece({
            "name":"ankleFR",
            "type":"ankleF",
            "clip":new Sprite(),
            "pos_bone":"ankleFR",
            "rot_bone":"ankleFR",
            "bend_bone":"ankleFR",
            "control_bone":"ankleFR",
            "side":"right",
            "angles":[300,0,180],
            "stack_group":"legFR"
         });
         _skin.add_skin_piece({
            "name":"footFR",
            "type":"footF",
            "clip":new Sprite(),
            "pos_bone":"footFR",
            "rot_bone":"footFR",
            "bend_bone":"footFR",
            "control_bone":"footFR",
            "side":"lerightft",
            "angles":[300,0,180],
            "stack_group":"legFR"
         });
         _skin.add_skin_piece({
            "name":"thighFL",
            "type":"thighF",
            "clip":new Sprite(),
            "pos_bone":"thighFL",
            "rot_bone":"thighFL",
            "bend_bone":"thighFL",
            "control_bone":"thighFL",
            "side":"left",
            "angles":[300,0,180],
            "stack_group":"legFL"
         });
         _skin.add_skin_piece({
            "name":"shinFL",
            "type":"shinF",
            "clip":new Sprite(),
            "pos_bone":"shinFL",
            "rot_bone":"shinFL",
            "bend_bone":"shinFL",
            "control_bone":"shinFL",
            "side":"left",
            "angles":[300,0,180],
            "stack_group":"legFL"
         });
         _skin.add_skin_piece({
            "name":"ankleFL",
            "type":"ankleF",
            "clip":new Sprite(),
            "pos_bone":"ankleFL",
            "rot_bone":"ankleFL",
            "bend_bone":"ankleFL",
            "control_bone":"ankleFL",
            "side":"left",
            "angles":[300,0,180],
            "stack_group":"legFL"
         });
         _skin.add_skin_piece({
            "name":"footFL",
            "type":"footF",
            "clip":new Sprite(),
            "pos_bone":"footFL",
            "rot_bone":"footFL",
            "bend_bone":"footFL",
            "control_bone":"footFL",
            "side":"left",
            "angles":[300,0,180],
            "stack_group":"legFL"
         });
         _skin.add_skin_piece({
            "name":"thighBL",
            "type":"thighB",
            "clip":new Sprite(),
            "pos_bone":"thighBL",
            "rot_bone":"thighBL",
            "bend_bone":"thighBL",
            "control_bone":"thighBL",
            "side":"left",
            "angles":[300,0,180],
            "stack_group":"legBL"
         });
         _skin.add_skin_piece({
            "name":"shinBL",
            "type":"shinB",
            "clip":new Sprite(),
            "pos_bone":"shinBL",
            "rot_bone":"shinBL",
            "bend_bone":"shinBL",
            "control_bone":"shinBL",
            "side":"left",
            "angles":[300,0,180],
            "stack_group":"legBL"
         });
         _skin.add_skin_piece({
            "name":"ankleBL",
            "type":"ankleB",
            "clip":new Sprite(),
            "pos_bone":"ankleBL",
            "rot_bone":"ankleBL",
            "bend_bone":"ankleBL",
            "control_bone":"ankleBL",
            "side":"left",
            "angles":[300,0,180],
            "stack_group":"legBL"
         });
         _skin.add_skin_piece({
            "name":"footBL",
            "type":"footB",
            "clip":new Sprite(),
            "pos_bone":"footBL",
            "rot_bone":"footBL",
            "bend_bone":"footBL",
            "control_bone":"footBL",
            "side":"left",
            "angles":[300,0,180],
            "stack_group":"legBL"
         });
         _skin.add_skin_piece({
            "name":"thighBR",
            "type":"thighB",
            "clip":new Sprite(),
            "pos_bone":"thighBR",
            "rot_bone":"thighBR",
            "bend_bone":"thighBR",
            "control_bone":"thighBR",
            "side":"right",
            "angles":[300,0,180],
            "stack_group":"legBR"
         });
         _skin.add_skin_piece({
            "name":"shinBR",
            "type":"shinB",
            "clip":new Sprite(),
            "pos_bone":"shinBR",
            "rot_bone":"shinBR",
            "bend_bone":"shinBR",
            "control_bone":"shinBR",
            "side":"right",
            "angles":[300,0,180],
            "stack_group":"legBR"
         });
         _skin.add_skin_piece({
            "name":"ankleBR",
            "type":"ankleB",
            "clip":new Sprite(),
            "pos_bone":"ankleBR",
            "rot_bone":"ankleBR",
            "bend_bone":"ankleBR",
            "control_bone":"ankleBR",
            "side":"right",
            "angles":[300,0,180],
            "stack_group":"legBR"
         });
         _skin.add_skin_piece({
            "name":"footBR",
            "type":"footB",
            "clip":new Sprite(),
            "pos_bone":"footBR",
            "rot_bone":"footBR",
            "bend_bone":"footBR",
            "control_bone":"footBR",
            "side":"right",
            "angles":[300,0,180],
            "stack_group":"legBR"
         });
         stack_groups = {
            "head":["head"],
            "neck":["neck"],
            "tail":["tail"],
            "torso":["torso"],
            "legFR":["thighFR","shinFR","ankleFR","footFR"],
            "legFL":["thighFL","shinFL","ankleFL","footFL"],
            "legBR":["thighBR","shinBR","ankleBR","footBR"],
            "legBL":["thighBL","shinBL","ankleBL","footBL"]
         };
         add_clothing("bare");
         _head.mouseChildren = false;
         _skin.render();
         _interface.render();
         _controller.init();
         body_height = _body_height;
         addChild(_interface);
         this.stance = 1;
      }
      
      public function get hands() : Array
      {
         return this._hands;
      }
      
      public function get_hand_info() : Array
      {
         return [{
            "rot":_pose.hand_rotate[body_rotation][0],
            "frame":_pose.hand_pose[0]
         },{
            "rot":_pose.hand_rotate[body_rotation][1],
            "frame":_pose.hand_pose[1]
         }];
      }
      
      public function set_hand(param1:uint, param2:uint, param3:uint) : uint
      {
         _pose.set_hand(param1,param2,param3,body_rotation);
         this.manage_hands();
         return param1;
      }
      
      private function manage_hands() : void
      {
      }
      
      public function set_breast(param1:uint) : uint
      {
         breast_type = param1;
         return breast_type;
      }
      
      public function set_height(param1:uint) : uint
      {
         body_height = param1;
         return body_height;
      }
      
      public function simple_bone_down(param1:String) : Boolean
      {
         return false;
      }
      
      public function simple_bone_up(param1:String) : Boolean
      {
         return false;
      }
      
      override public function update_bone_positions() : void
      {
         this.setup_spine();
         this.setup_tail();
         this.align_tail();
         this.setup_neck();
         this.align_neck();
         this.setup_legs();
         this.align_front_legs();
         this.align_back_legs();
         super.update_bone_positions();
         this.align_head();
      }
      
      public function setup_spine() : void
      {
         var _loc1_:Object = get_structure("spine");
         _loc1_.bones[0].set_position(new Point(_loc1_.position[0],_loc1_.position[1]),_loc1_.starting_rot);
      }
      
      public function setup_tail() : void
      {
         var _loc1_:Object = get_structure("tail");
         _loc1_.bones[0].set_position(new Point(_loc1_.position[0],_loc1_.position[1]),_loc1_.starting_rot);
      }
      
      public function setup_neck() : void
      {
         var _loc1_:Object = get_structure("neck");
         _loc1_.bones[0].set_position(new Point(_loc1_.position[0],_loc1_.position[1]),_loc1_.starting_rot);
      }
      
      public function setup_legs() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.front_legs.length)
         {
            this.front_legs[_loc1_].bones[0].set_position(new Point(0,0),this.front_legs[_loc1_].starting_rot);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.back_legs.length)
         {
            this.back_legs[_loc1_].bones[0].set_position(new Point(0,0),this.back_legs[_loc1_].starting_rot);
            _loc1_++;
         }
      }
      
      public function align_neck() : void
      {
         var _loc1_:Object = get_structure("spine");
         var _loc2_:Object = get_structure("neck");
         var _loc3_:Point = _loc1_.bones[1].get_end_point();
         var _loc4_:Number = _loc1_.bones[1].rotation - _loc1_.starting_rot;
         var _loc5_:Point = new Point(_loc2_.position[0],_loc2_.position[1]);
         m.identity();
         m.rotate(_loc4_ * Math.PI / 180);
         m.translate(_loc3_.x,_loc3_.y);
         _loc5_ = m.transformPoint(_loc5_);
         _loc2_.bones[0].set_position(_loc5_,_loc4_ + _loc2_.starting_rot);
      }
      
      public function align_tail() : void
      {
         var _loc1_:Object = get_structure("spine");
         var _loc2_:Object = get_structure("tail");
         var _loc3_:Point = _loc1_.bones[0].get_position();
         var _loc4_:Number = _loc1_.bones[1].rotation - _loc1_.starting_rot;
         var _loc5_:Point = new Point(_loc2_.position[0],_loc2_.position[1]);
         m.identity();
         m.rotate(_loc4_ * Math.PI / 180);
         m.translate(_loc3_.x,_loc3_.y);
         _loc5_ = m.transformPoint(_loc5_);
         _loc2_.bones[0].set_position(_loc5_,_loc4_ + _loc2_.starting_rot);
      }
      
      public function align_back_legs() : void
      {
         var _loc1_:Object = null;
         var _loc5_:Point = null;
         var _loc2_:Object = get_structure("spine");
         var _loc3_:Point = _loc2_.bones[0].get_position();
         var _loc4_:Number = _loc2_.bones[0].rotation - _loc2_.starting_rot;
         var _loc6_:uint = 0;
         while(_loc6_ < this.back_legs.length)
         {
            _loc1_ = this.back_legs[_loc6_];
            _loc5_ = new Point(_loc1_.position[0],_loc1_.position[1]);
            m.identity();
            m.rotate(_loc4_ * Math.PI / 180);
            m.translate(_loc3_.x,_loc3_.y);
            _loc5_ = m.transformPoint(_loc5_);
            _loc1_.bones[0].set_position(_loc5_,_loc4_ + this.back_legs[_loc6_].starting_rot);
            _loc6_++;
         }
      }
      
      public function align_front_legs() : void
      {
         var _loc1_:Object = null;
         var _loc5_:Point = null;
         var _loc2_:Object = get_structure("spine");
         var _loc3_:Point = _loc2_.bones[1].get_end_point();
         var _loc4_:Number = _loc2_.bones[0].rotation - _loc2_.starting_rot;
         var _loc6_:uint = 0;
         while(_loc6_ < this.front_legs.length)
         {
            _loc1_ = this.front_legs[_loc6_];
            _loc5_ = new Point(_loc1_.position[0],_loc1_.position[1]);
            m.identity();
            m.rotate(_loc4_ * Math.PI / 180);
            m.translate(_loc3_.x,_loc3_.y);
            _loc5_ = m.transformPoint(_loc5_);
            _loc1_.bones[0].set_position(_loc5_,_loc4_ + this.front_legs[_loc6_].starting_rot);
            _loc6_++;
         }
      }
      
      public function align_head() : void
      {
         if(_head)
         {
            _head.y = this.head_adjustment;
         }
      }
      
      public function get simple() : Boolean
      {
         return false;
      }
      
      public function get mode() : uint
      {
         return this._mode;
      }
      
      public function set mode(param1:uint) : void
      {
         if(this._mode == param1)
         {
            return;
         }
         var _loc2_:Boolean = false;
         if(this._mode == 2 || this._mode == 3)
         {
            _loc2_ = true;
         }
         this._mode = param1;
         if(this._mode == 0 || this._mode == 1)
         {
            if(_loc2_)
            {
               this.gesture = this._gesture;
            }
            this.stance = 1;
         }
         else if(this._mode == 2)
         {
            this.action = this._action;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get action() : uint
      {
         return this._action;
      }
      
      public function set action(param1:uint) : void
      {
         var _loc4_:Pose = null;
         this._action = param1;
         if(this._mode != 2)
         {
            return;
         }
         var _loc2_:Object = CharLoader.pose_data;
         trace("POSE NAME: " + "p" + this._action);
         var _loc3_:Object = _loc2_["action"]["p" + this._action];
         if(!_loc3_)
         {
            _loc3_ = {
               "name":"p" + this._action,
               "type":PoseType.ACTION
            };
         }
         _loc4_ = new Pose(_loc3_,SkeletonQuadruped.pose_defaults);
         pose = _loc4_;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get gesture() : uint
      {
         return this._gesture;
      }
      
      public function set gesture(param1:uint) : void
      {
         this._gesture = param1;
         var _loc2_:Object = CharLoader.pose_data;
         trace("GESTURE NAME: " + "g" + param1);
         var _loc3_:Object = _loc2_["gesture"]["g" + this._gesture];
         if(!_loc3_)
         {
            _loc3_ = {
               "name":"g" + this._gesture,
               "type":PoseType.GESTURE
            };
         }
         pose = new Pose(_loc3_,SkeletonQuadruped.pose_defaults);
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get stance() : uint
      {
         return this._stance;
      }
      
      public function set stance(param1:uint) : void
      {
         var _loc3_:Pose = null;
         this._stance = Math.min(9,Math.max(0,param1));
         var _loc2_:Object = {
            "name":"s" + this._stance,
            "type":PoseType.STANCE
         };
         _loc3_ = new Pose(_loc2_,SkeletonQuadruped.pose_defaults);
         pose = _loc3_;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function stance_up() : void
      {
         if(this._stance >= 3)
         {
            this.stance = this.stance - 3;
         }
      }
      
      public function stance_down() : void
      {
         if(this._stance <= 5)
         {
            this.stance = this.stance + 3;
         }
      }
      
      public function stance_left() : void
      {
         if(flipped)
         {
            if(this._stance % 3 != 2)
            {
               this.stance = this.stance + 1;
            }
         }
         else if(this._stance % 3 != 0)
         {
            this.stance = this.stance - 1;
         }
      }
      
      public function stance_right() : void
      {
         if(flipped)
         {
            if(this._stance % 3 != 0)
            {
               this.stance = this.stance - 1;
            }
         }
         else if(this._stance % 3 != 2)
         {
            this.stance = this.stance + 1;
         }
      }
      
      public function set head_angle(param1:Number) : void
      {
         if(_flipped)
         {
            param1 = param1 * -1;
         }
         var _loc2_:Bone = Bone(bone_lookup["head"]);
         _loc2_.internal_rotation = param1;
         _loc2_.update = true;
      }
      
      public function get head_angle() : Number
      {
         var _loc1_:Bone = Bone(bone_lookup["head"]);
         var _loc2_:Number = _loc1_.internal_rotation;
         if(_flipped)
         {
            _loc2_ = Utils.degrees(_loc2_ * -1);
         }
         return _loc2_;
      }
      
      override protected function update_offset_positions() : void
      {
         adjust_pose();
         if(Skeleton.debug)
         {
            trace("update_offset_positions()");
         }
         var _loc1_:uint = 0;
         while(_loc1_ < bone_structures.length)
         {
            bone_structures[_loc1_].position = Utils.clone(point_data_source.data[bone_structures[_loc1_].pos_name][0][0][0]);
            if(Skeleton.debug)
            {
               trace(bone_structures[_loc1_].name + "  " + bone_structures[_loc1_].position);
            }
            _loc1_++;
         }
         structure_lookup.spine.position[1] = structure_lookup.spine.position[1] + _adjusted_float;
         this.update_bone_positions();
      }
   }
}
