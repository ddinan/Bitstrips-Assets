package com.bitstrips.character.skeleton
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.Head;
   import com.bitstrips.character.HeadBase;
   import com.bitstrips.character.HeadPiece;
   import com.bitstrips.character.skeleton.data.LengthData;
   import com.bitstrips.character.skeleton.data.PointData;
   import com.bitstrips.core.ArtEvent;
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.core.ColourData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   
   public class Skeleton extends Sprite
   {
      
      public static var debug:Boolean = false;
      
      public static const _pose_defaults:Object = {};
      
      private static var old_clothes:Object = {
         "shirt1":"shirt02",
         "shirt2":"shirt01",
         "shirt3":["shirt03","tie01"],
         "skirt1":"skirt02",
         "pearls":"necklace01",
         "glove1":"glove01",
         "shorts1":"pants05",
         "shorts2":"pants06",
         "pants1":"pants02",
         "pants2":"pants03",
         "sock1":"sock01",
         "sock2":"sock02",
         "shoe1":"shoe01",
         "shoe2":"shoe02",
         "suit1":"jacket01"
      };
       
      
      protected var bones:Array;
      
      protected var bone_structures:Array;
      
      protected var m:Matrix;
      
      protected var bone_lookup:Object;
      
      protected var skin_lookup:Object;
      
      protected var structure_lookup:Object;
      
      protected var _skin:Skin;
      
      protected var _interface:SkeletonInterface;
      
      protected var _controller:SkeletonController;
      
      protected var _body_type:uint;
      
      protected var _body_height:uint;
      
      protected var _body_rotation:uint;
      
      protected var _master_rotation:uint;
      
      protected var _costume:Object;
      
      protected var _pose:Pose;
      
      protected var _adjusted_float:Number = 0;
      
      public var _cld:ColourData;
      
      protected var _head:HeadBase;
      
      protected var stack_groups:Object;
      
      public var art_loader:ArtLoader;
      
      public var edit_mode:Boolean = false;
      
      var tmp_clothes:Array;
      
      private var _breast_type:int = 3;
      
      public var _sex:uint = 1;
      
      var _flipped:Boolean = false;
      
      protected var _temp_rot:Number;
      
      public var show_shoulder_patches:Boolean = true;
      
      protected var _point_data_source:Class;
      
      protected var _length_data_source:Class;
      
      public var species:String = "";
      
      private var waiting_clothes:Array;
      
      public var clothes:Array;
      
      private var _edit:Boolean = false;
      
      public function Skeleton(param1:HeadBase, param2:ArtLoader, param3:Object = undefined, param4:Boolean = true)
      {
         this.m = new Matrix();
         this.tmp_clothes = [];
         this.waiting_clothes = [];
         this.clothes = [];
         super();
         doubleClickEnabled = true;
         this.art_loader = param2;
         if(param1)
         {
            this._head = param1;
            this._cld = this._head.cld;
         }
         this.edit_mode = param4;
         if(param3 != null)
         {
            this._body_type = param3["body_type"];
            this._body_height = param3["body_height"];
            this.breast_type = param3["breast_type"];
            if(param3["sex"])
            {
               this.sex = param3["sex"];
            }
            else if(this.body_type == 7 || this.body_type == 8 || this.body_type == 9 || this.body_type == 10)
            {
               this.sex = 2;
            }
            if(param3["clothes"])
            {
               this.tmp_clothes = param3["clothes"];
            }
         }
         if(Skeleton.debug)
         {
            trace("_body_type: " + this._body_type);
         }
         if(Skeleton.debug)
         {
            graphics.lineStyle(4,39423);
            graphics.moveTo(-100,9);
            graphics.lineTo(100,9);
         }
         this.stack_groups = new Object();
         this._point_data_source = PointData;
         this._length_data_source = LengthData;
      }
      
      public function add_bone(param1:Object, param2:Bone, param3:Bone = null) : void
      {
         param1.bones.push(param2);
         this.bones.push(param2);
         if(param3)
         {
            param3.add_child(param2);
         }
         this.bone_lookup[param2.name] = param2;
      }
      
      public function get_bones() : Array
      {
         return this.bones;
      }
      
      public function get_bone(param1:String) : Bone
      {
         if(this.bone_lookup.hasOwnProperty(param1))
         {
            return this.bone_lookup[param1];
         }
         return null;
      }
      
      public function get_structure(param1:String) : Object
      {
         if(this.structure_lookup.hasOwnProperty(param1))
         {
            return this.structure_lookup[param1];
         }
         return null;
      }
      
      public function init() : void
      {
         this.bone_lookup = new Object();
         this.skin_lookup = new Object();
         this.structure_lookup = new Object();
         this.bones = new Array();
         this.bone_structures = new Array();
         this._skin = new Skin(this);
         this._interface = new SkeletonInterface(this);
         this._interface.mouseEnabled = false;
         this._interface.mouseChildren = false;
         this._interface.visible = Skeleton.debug;
         this._controller = new SkeletonController(this,this._interface);
         addChild(this._skin);
         if(Skeleton.debug)
         {
            addChild(this._interface);
            this._interface.render();
         }
         this._controller.init();
         if(this._head)
         {
            this._cld.addEventListener("NEW_COLOUR",this.update_colours,false,0,true);
            this._head.addEventListener("ROTATION",this.rotate_head_handler,false,0,true);
         }
      }
      
      public function remove() : void
      {
      }
      
      protected function update_offset_positions() : void
      {
         this.adjust_pose();
         if(Skeleton.debug)
         {
            trace("update_offset_positions()");
         }
         var _loc1_:uint = 0;
         while(_loc1_ < this.bone_structures.length)
         {
            this.bone_structures[_loc1_].position = Utils.clone(this.point_data_source.data[this.bone_structures[_loc1_].pos_name][this.body_type][this.body_height][this.body_rotation]);
            if(Skeleton.debug)
            {
               trace(this.bone_structures[_loc1_].name + "  " + this.bone_structures[_loc1_].position);
            }
            _loc1_++;
         }
         this.structure_lookup.spine.position[1] = this.structure_lookup.spine.position[1] + this._adjusted_float;
         this.update_bone_positions();
      }
      
      public function update_bone_positions() : void
      {
         if(this._interface)
         {
            this._interface.update();
         }
      }
      
      public function set pose(param1:Pose) : void
      {
         var _loc2_:uint = this._body_rotation;
         this.body_rotation = 0;
         param1 = this.configure_incoming_pose(param1);
         this._pose = new Pose(param1,this.pose_defaults);
         this.assume_pose(this._pose);
         this.body_rotation = _loc2_;
         dispatchEvent(new Event(Event.CHANGE));
         dispatchEvent(new Event(SkeletonEvent.CHAR_POSE_CHANGE));
      }
      
      protected function configure_incoming_pose(param1:Pose) : Pose
      {
         return param1;
      }
      
      public function get pose() : Pose
      {
         return this._pose;
      }
      
      protected function assume_pose(param1:Pose) : void
      {
         var _loc4_:* = null;
         var _loc5_:uint = 0;
         if(Skeleton.debug)
         {
            trace("Skeleton.assume_pose(" + param1.name + ")");
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.bones.length)
         {
            Bone(this.bones[_loc2_]).update = true;
            Bone(this.bones[_loc2_]).adjustment_rotation = 0;
            _loc2_++;
         }
         var _loc3_:Object = Utils.clone(this._pose.angles);
         for(_loc4_ in _loc3_)
         {
            this.get_bone(_loc4_).internal_rotation = _loc3_[_loc4_];
         }
         _loc5_ = 0;
         while(_loc5_ < this.bones.length)
         {
            this.bones[_loc5_].addEventListener(SkeletonEvent.BONE_ROT_CHANGE,this.update_pose_angle,false,0,true);
            _loc5_++;
         }
         if(this._pose.skin_stack)
         {
            this._skin.restack(this._pose.skin_stack[this.body_rotation]);
         }
         this.update_offset_positions();
      }
      
      private function update_pose_angle(param1:Event) : void
      {
         var _loc2_:Bone = Bone(param1.currentTarget);
         this._pose.angles[_loc2_.name] = _loc2_.internal_rotation;
      }
      
      public function get_bone_angles() : Object
      {
         var _loc3_:uint = 0;
         var _loc1_:Object = new Object();
         var _loc2_:uint = 0;
         while(_loc2_ < this.structures.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.structures[_loc2_].bones.length)
            {
               _loc1_[Bone(this.structures[_loc2_].bones[_loc3_]).name] = Bone(this.structures[_loc2_].bones[_loc3_]).internal_rotation;
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function adjust_pose() : void
      {
         var _loc2_:* = null;
         if(Skeleton.debug)
         {
            trace("adjust_pose");
         }
         var _loc1_:Object = Utils.clone(this._pose.angles);
         for(_loc2_ in _loc1_)
         {
            _loc1_[_loc2_] = 0;
         }
         this.adjusted_float = this._pose.float + this._pose.get_float_adjustment(this._body_rotation,this._body_height,this._body_type);
         if(this.pose.adjustments["rotation_" + this.body_rotation])
         {
            if(this.pose.adjustments["rotation_" + this.body_rotation].adj)
            {
               if(Skeleton.debug)
               {
                  trace("there is a rotation adjustment for this pose");
               }
               for(_loc2_ in _loc1_)
               {
                  if(this.pose.adjustments["rotation_" + this.body_rotation].adj.hasOwnProperty(_loc2_))
                  {
                     _loc1_[_loc2_] = _loc1_[_loc2_] + this.pose.adjustments["rotation_" + this.body_rotation].adj[_loc2_];
                     if(Skeleton.debug)
                     {
                        trace("adjusting " + _loc2_ + " by " + this.pose.adjustments["rotation_" + this.body_rotation].adj[_loc2_]);
                     }
                  }
               }
            }
            if(this.pose.adjustments["rotation_" + this.body_rotation]["height_" + this.body_height])
            {
               if(this.pose.adjustments["rotation_" + this.body_rotation]["height_" + this.body_height].adj)
               {
                  if(Skeleton.debug)
                  {
                     trace("there is a height adjustment for this pose");
                  }
                  for(_loc2_ in _loc1_)
                  {
                     if(this.pose.adjustments["rotation_" + this.body_rotation]["height_" + this.body_height].adj.hasOwnProperty(_loc2_))
                     {
                        _loc1_[_loc2_] = _loc1_[_loc2_] + this.pose.adjustments["rotation_" + this.body_rotation]["height_" + this.body_height].adj[_loc2_];
                        if(Skeleton.debug)
                        {
                           trace("adjusting " + _loc2_ + " by " + this.pose.adjustments["rotation_" + this.body_rotation]["height_" + this.body_height].adj[_loc2_]);
                        }
                     }
                  }
               }
               if(this.pose.adjustments["rotation_" + this.body_rotation]["height_" + this.body_height]["type_" + this.body_type])
               {
                  if(Skeleton.debug)
                  {
                     trace("there is a body type adjustment for this pose");
                  }
                  if(this.pose.adjustments["rotation_" + this.body_rotation]["height_" + this.body_height]["type_" + this.body_type].adj)
                  {
                     for(_loc2_ in _loc1_)
                     {
                        if(this.pose.adjustments["rotation_" + this.body_rotation]["height_" + this.body_height]["type_" + this.body_type].adj.hasOwnProperty(_loc2_))
                        {
                           _loc1_[_loc2_] = _loc1_[_loc2_] + this.pose.adjustments["rotation_" + this.body_rotation]["height_" + this.body_height]["type_" + this.body_type].adj[_loc2_];
                           if(Skeleton.debug)
                           {
                              trace("adjusting " + _loc2_ + " by " + this.pose.adjustments["rotation_" + this.body_rotation]["height_" + this.body_height]["type_" + this.body_type].adj[_loc2_]);
                           }
                        }
                     }
                  }
               }
            }
         }
         for(_loc2_ in _loc1_)
         {
            if(Skeleton.debug)
            {
               trace("adjusting angle of bone " + _loc2_ + " byyy " + _loc1_[_loc2_]);
            }
            this.get_bone(_loc2_).adjustment_rotation = _loc1_[_loc2_];
         }
      }
      
      public function set body_height(param1:uint) : void
      {
         this._body_height = param1;
         var _loc2_:uint = 0;
         while(_loc2_ < this.bones.length)
         {
            this.bones[_loc2_].length = this._length_data_source[this.bones[_loc2_].type][this._body_height];
            _loc2_++;
         }
         this.update_offset_positions();
         this.dispatchEvent(new Event(SkeletonEvent.CHAR_HEIGHT_CHANGE));
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set body_type(param1:uint) : void
      {
         this._body_type = param1;
         if(this._interface)
         {
            this._interface.render();
         }
         this.update_offset_positions();
         this.dispatchEvent(new Event(SkeletonEvent.CHAR_TYPE_CHANGE));
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set_rotation(param1:uint) : uint
      {
         if(param1 >= 8)
         {
            param1 = 0;
         }
         param1 = Math.min(7,Math.max(0,param1));
         this._master_rotation = param1;
         var _loc2_:Boolean = false;
         this._flipped = false;
         switch(this._master_rotation)
         {
            case 7:
               this._flipped = true;
               _loc2_ = true;
               this.body_rotation = 1;
               break;
            case 6:
               _loc2_ = true;
               this._flipped = true;
               this.body_rotation = 2;
               break;
            case 5:
               _loc2_ = true;
               this._flipped = true;
               this.body_rotation = 3;
               break;
            default:
               this.body_rotation = this._master_rotation;
         }
         if(_loc2_)
         {
            this._skin.scaleX = -1;
            this._skin.get_skin_piece("head").clip.scaleX = -1;
            this._skin.get_skin_piece("head_back").clip.scaleX = -1;
            this._flipped = true;
         }
         else
         {
            this._skin.scaleX = 1;
            this._skin.get_skin_piece("head").clip.scaleX = 1;
            this._skin.get_skin_piece("head_back").clip.scaleX = 1;
            this._flipped = false;
         }
         dispatchEvent(new Event(Event.CHANGE));
         return this._master_rotation;
      }
      
      public function get master_rotation() : uint
      {
         return this._master_rotation;
      }
      
      public function set body_rotation(param1:uint) : void
      {
         var _loc2_:Boolean = false;
         if(param1 == 0 && this._body_rotation != 0 && this._body_rotation != 4)
         {
            _loc2_ = true;
         }
         else if(this._body_rotation == 0 && param1 != 0 && param1 != 4)
         {
            _loc2_ = true;
         }
         else if(param1 == 4 && this._body_rotation != 4 && this._body_rotation != 0)
         {
            _loc2_ = true;
         }
         else if(this._body_rotation == 4 && param1 != 4 && param1 != 0)
         {
            _loc2_ = true;
         }
         this._body_rotation = param1;
         this.update_offset_positions();
         if(_loc2_)
         {
            this.dispatchEvent(new Event(SkeletonEvent.LEG_FLIP));
         }
         this.update_offset_positions();
         this.dispatchEvent(new Event(SkeletonEvent.CHAR_ROT_CHANGE));
      }
      
      public function get body_type() : uint
      {
         return this._body_type;
      }
      
      public function get body_height() : uint
      {
         return this._body_height;
      }
      
      public function get body_rotation() : uint
      {
         return this._body_rotation;
      }
      
      public function get skin() : Skin
      {
         return this._skin;
      }
      
      public function get_skin_stack() : Array
      {
         var _loc1_:Array = new Array();
         if(this._pose.skin_stack[this.body_rotation])
         {
            _loc1_ = this._pose.skin_stack[this.body_rotation];
         }
         return _loc1_;
      }
      
      public function get structures() : Array
      {
         return this.bone_structures;
      }
      
      public function reset_bones() : void
      {
         this.set_rotation(0);
         var _loc1_:uint = 0;
         while(_loc1_ < this.bones.length)
         {
            Bone(this.bones[_loc1_]).reset();
            Bone(this.bones[_loc1_]).update = true;
            _loc1_++;
         }
         this.adjusted_float = 0;
         this.update_bone_positions();
      }
      
      public function set adjusted_float(param1:Number) : void
      {
         if(Skeleton.debug)
         {
            trace("Skeleton.adjusted_float = " + this._adjusted_float);
         }
         this._adjusted_float = param1;
      }
      
      public function get controller() : SkeletonController
      {
         return this._controller;
      }
      
      public function update_colours(param1:Event = null) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:DisplayObject = null;
         if(Skeleton.debug)
         {
            trace("UPDATE COLOURS ---------------------------------------------------- " + this.name + " " + this);
         }
         var _loc2_:Array = this._skin.get_skin_pieces();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = 0;
            while(_loc4_ < Sprite(_loc2_[_loc3_].clip).numChildren)
            {
               _loc5_ = _loc2_[_loc3_].clip.getChildAt(_loc4_);
               if(!(_loc5_ is Head || _loc5_ is HeadPiece))
               {
                  this._cld.colour_clip(_loc5_);
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public function save_state() : Object
      {
         return new Object();
      }
      
      public function load_state(param1:Object) : void
      {
      }
      
      private function naked() : Boolean
      {
         if(this.clothes.length == 1)
         {
            if(ArtLoader.exclusive_clothing.indexOf(this.clothes[0]) != -1)
            {
               return false;
            }
         }
         if((this.is_wearing("shirt") || this.is_wearing("jacket")) == false)
         {
            return true;
         }
         if((this.is_wearing("pants") || this.is_wearing("skirt")) == false)
         {
            return true;
         }
         return false;
      }
      
      public function get loaded() : Boolean
      {
         if(this.waiting_clothes.length == 0)
         {
            return true;
         }
         return false;
      }
      
      public function wearing(param1:String) : Boolean
      {
         if(this.clothes.indexOf(param1) == -1)
         {
            return false;
         }
         return true;
      }
      
      public function add_clothing(param1:String, param2:Boolean = false) : void
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         if(Skeleton.old_clothes.hasOwnProperty(param1))
         {
            if(param1 == "shirt3")
            {
               param1 = "shirt03";
               this.add_clothing("tie01");
            }
            else
            {
               param1 = Skeleton.old_clothes[param1];
            }
         }
         if(this.clothes.indexOf(param1) >= 0)
         {
            if(Skeleton.debug)
            {
               trace("add_clothing: I\'m already wearing it: " + param1);
            }
            return;
         }
         if(ArtLoader.exclusive_clothing.indexOf(param1) != -1)
         {
            this.clothes = [];
         }
         if(this.art_loader.clothing_loaded(param1,this.species) == false)
         {
            if(this.waiting_clothes.indexOf(param1) == -1)
            {
               this.art_loader.clothing_queue(param1,this,this.species);
               this.waiting_clothes.push(param1);
               if(this.naked())
               {
                  this._skin.visible = false;
               }
               return;
            }
            return;
         }
         if(this.waiting_clothes.indexOf(param1) != -1)
         {
            _loc5_ = this.waiting_clothes.indexOf(param1);
            this.waiting_clothes.splice(_loc5_,1);
            if(this.waiting_clothes.length == 0 || this.naked() == false)
            {
               this._skin.visible = true;
               dispatchEvent(new Event(Event.COMPLETE));
            }
         }
         this.clothes.push(param1);
         var _loc3_:Array = this._skin.get_skin_pieces();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc6_ = _loc3_[_loc4_].type;
            _loc7_ = this.art_loader.get_art(this.species,_loc6_ + "_" + param1);
            if(_loc7_)
            {
               this._skin.add_skin_layer(_loc3_[_loc4_].name,DisplayObjectContainer(_loc7_));
               this._controller.selected_skin_patch = _loc7_;
               if(_loc7_.base_colour == null)
               {
                  _loc7_.set_new_frame_func(this.cld.colour_clip);
               }
               if(this._edit)
               {
                  _loc7_.buttonMode = true;
                  _loc7_.addEventListener(MouseEvent.CLICK,this.art_piece_click,false,0,true);
               }
            }
            else if(Skeleton.debug)
            {
               trace("Didn\'t get a piece: " + _loc6_ + "_" + param1);
            }
            _loc4_++;
         }
         this.dispatchEvent(new Event(SkeletonEvent.CHAR_CLOTHES_CHANGE));
         this.update_colours();
         this.dispatchEvent(new Event("clothing_click"));
         this._controller.update_skin_listeners();
         this.clothing_special_rules();
         this._skin.update_frame();
      }
      
      public function remove_clothing(param1:String) : void
      {
         if(this.clothes.indexOf(param1) == -1 || param1 == "bare")
         {
            if(Skeleton.debug)
            {
               trace("Remove Clothing: I\'m not wearing it:" + param1);
            }
            return;
         }
         var _loc2_:Array = this._skin.get_skin_pieces();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            this._skin.remove_skin_layer(_loc2_[_loc3_].name,param1);
            _loc3_++;
         }
         this.clothes.splice(this.clothes.indexOf(param1),1);
         this.clothing_special_rules();
         this._skin.update_frame();
      }
      
      public function get skin_colours() : Array
      {
         if(this._controller.selected_skin_patch)
         {
            if(this._controller.selected_skin_patch.hasOwnProperty("base_colour"))
            {
               return [this._controller.selected_skin_patch.base_colour];
            }
            return [ColourData.get_colours(MovieClip(this._controller.selected_skin_patch))];
         }
         return [];
      }
      
      public function get skin_name() : String
      {
         if(this._controller.selected_skin_patch is MovieClip)
         {
            return MovieClip(this._controller.selected_skin_patch).name;
         }
         if(this._controller.selected_skin_patch is Head)
         {
            return "head";
         }
         return "unknown";
      }
      
      public function set breast_type(param1:uint) : void
      {
         if(param1 <= 3)
         {
            this._breast_type = param1;
         }
         else
         {
            this._breast_type = 0;
         }
         this.dispatchEvent(new Event(SkeletonEvent.CHAR_BREASTS_CHANGE));
      }
      
      public function get breast_type() : uint
      {
         return this._breast_type;
      }
      
      public function set sex(param1:uint) : void
      {
         if(param1 == 2)
         {
            this._sex = 2;
            if(this._body_type == 0)
            {
               this.body_type = 7;
            }
            if(this._body_type == 1)
            {
               this.body_type = 8;
            }
            if(this._body_type == 3)
            {
               this.body_type = 9;
            }
            if(this._body_type == 5)
            {
               this.body_type = 10;
            }
         }
         else
         {
            this._sex = 1;
            if(this._body_type == 7)
            {
               this.body_type = 0;
            }
            if(this._body_type == 8)
            {
               this.body_type = 1;
            }
            if(this._body_type == 9)
            {
               this.body_type = 3;
            }
            if(this._body_type == 10)
            {
               this.body_type = 5;
            }
         }
         this.dispatchEvent(new Event(SkeletonEvent.CHAR_SEX_CHANGE));
      }
      
      public function get sex() : uint
      {
         return this._sex;
      }
      
      private function rotate_head_handler(param1:Event) : void
      {
         this.manage_head_rotation();
      }
      
      public function manage_head_rotation() : void
      {
         this._skin.restack(this.get_skin_stack());
         var _loc1_:Boolean = false;
         if(this._head.h_rot >= 3 && this._head.h_rot <= 5 && (this.body_rotation <= 2 || this.body_rotation >= 6))
         {
            _loc1_ = true;
         }
         else if(this.body_rotation >= 3 && this.body_rotation <= 5 && (this._head.h_rot >= 6 || this._head.h_rot <= 2))
         {
            _loc1_ = true;
         }
         if(_loc1_)
         {
            if(this._skin.get_skin_piece("head") && this._skin.get_skin_piece("head_back"))
            {
               if(0 == 0)
               {
                  if(0 == 0)
                  {
                     this._skin.swapChildren(this._skin.get_skin_piece("head").clip,this._skin.get_skin_piece("head_back").clip);
                  }
               }
            }
         }
      }
      
      public function set temp_rot(param1:Number) : void
      {
         this._temp_rot = param1;
         dispatchEvent(new Event(SkeletonEvent.SKELETON_ANGLE_CHANGE));
      }
      
      public function get temp_rot() : Number
      {
         return this._temp_rot;
      }
      
      public function get flipped() : Boolean
      {
         return this._flipped;
      }
      
      public function get_stack_group(param1:String) : Array
      {
         var _loc2_:Array = new Array();
         if(this.stack_groups.hasOwnProperty(param1))
         {
            _loc2_ = this.stack_groups[param1];
         }
         return _loc2_;
      }
      
      protected function clothing_special_rules() : void
      {
      }
      
      public function get adjusted_float() : Number
      {
         return this._adjusted_float;
      }
      
      public function set button_float(param1:Number) : void
      {
         var _loc2_:Number = this._pose.get_float_adjustment(this._body_rotation,this._body_height,this._body_type);
         this._pose.float = param1 - _loc2_;
         this.update_offset_positions();
      }
      
      public function get head() : HeadBase
      {
         return this._head;
      }
      
      public function get cld() : ColourData
      {
         return this._cld;
      }
      
      public function set edit(param1:Boolean) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:Sprite = null;
         if(param1 == this._edit)
         {
            return;
         }
         this._edit = param1;
         var _loc2_:Array = this._skin.get_skin_pieces();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = 0;
            while(_loc4_ < Sprite(_loc2_[_loc3_].clip).numChildren)
            {
               _loc5_ = _loc2_[_loc3_].clip.getChildAt(_loc4_);
               if(!(_loc5_ is Head || _loc5_ is HeadPiece))
               {
                  if(this._edit)
                  {
                     _loc5_.buttonMode = true;
                     _loc5_.addEventListener(MouseEvent.CLICK,this.art_piece_click,false,0,true);
                  }
                  else
                  {
                     _loc5_.buttonMode = false;
                     _loc5_.removeEventListener(MouseEvent.CLICK,this.art_piece_click);
                  }
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      private function art_piece_click(param1:MouseEvent) : void
      {
         var _loc3_:Array = null;
         var _loc2_:Object = param1.currentTarget;
         if(_loc2_.base_colour)
         {
            _loc3_ = [_loc2_.base_colour];
         }
         else
         {
            _loc3_ = ColourData.get_colours(_loc2_);
         }
         dispatchEvent(new ArtEvent(ArtEvent.CLICK,_loc2_.name,_loc3_));
      }
      
      public function is_wearing(param1:String) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in this.clothes)
         {
            if(_loc2_.indexOf(param1) != -1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function toggle_control() : Boolean
      {
         this._controller.bone_control = !this._controller.bone_control;
         return this._controller.bone_control;
      }
      
      public function set_control(param1:Boolean) : void
      {
         this._controller.bone_control = param1;
      }
      
      public function bone_up(param1:String) : Boolean
      {
         var _loc5_:Array = null;
         var _loc2_:Array = this._pose.skin_stack;
         var _loc3_:Array = Utils.clone(_loc2_[this._body_rotation]) as Array;
         var _loc4_:int = _loc3_.indexOf(param1);
         if(_loc4_ != -1 && _loc4_ != _loc3_.length - 1)
         {
            _loc5_ = _loc3_.splice(_loc4_,1);
            _loc3_ = _loc3_.slice(0,_loc4_ + 1).concat(_loc5_).concat(_loc3_.slice(_loc4_ + 1));
            _loc2_[this.body_rotation] = _loc3_;
            this._pose.skin_stack = _loc2_;
            this._skin.restack(_loc3_);
            return true;
         }
         return false;
      }
      
      public function bone_down(param1:String) : Boolean
      {
         var _loc5_:Array = null;
         var _loc2_:Array = this._pose.skin_stack;
         var _loc3_:Array = Utils.clone(_loc2_[this._body_rotation]) as Array;
         var _loc4_:int = _loc3_.indexOf(param1);
         if(_loc4_ != -1 && _loc4_ != 0)
         {
            _loc5_ = _loc3_.splice(_loc4_,1);
            _loc3_ = _loc3_.slice(0,_loc4_ - 1).concat(_loc5_).concat(_loc3_.slice(_loc4_ - 1));
            _loc2_[this.body_rotation] = _loc3_;
            this._pose.skin_stack = _loc2_;
            this._skin.restack(_loc3_);
            return true;
         }
         return false;
      }
      
      public function get pose_defaults() : Object
      {
         return _pose_defaults;
      }
      
      public function set head(param1:HeadBase) : void
      {
         this._head = param1;
         this._cld = this._head.cld;
         this._cld.addEventListener("NEW_COLOUR",this.update_colours,false,0,true);
         this._head.addEventListener("ROTATION",this.rotate_head_handler,false,0,true);
         this._head.mouseChildren = false;
      }
      
      public function get bone_interface() : SkeletonInterface
      {
         return this._interface;
      }
      
      public function get point_data_source() : Class
      {
         return this._point_data_source;
      }
   }
}
