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
      
      public static const _pose_defaults:Object = {};
      
      public static var debug:Boolean = false;
       
      
      protected var _length_data_source:Class;
      
      var tmp_clothes:Array;
      
      private var _breast_type:int = 3;
      
      protected var bones:Array;
      
      protected var _body_type:uint;
      
      protected var _controller:SkeletonController;
      
      public var species:String = "";
      
      var _flipped:Boolean = false;
      
      public var clothes:Array;
      
      protected var _temp_rot:Number;
      
      protected var bone_lookup:Object;
      
      private var waiting_clothes:Array;
      
      public var show_shoulder_patches:Boolean = true;
      
      protected var _skin:Skin;
      
      public var _cld:ColourData;
      
      protected var _adjusted_float:Number = 0;
      
      protected var stack_groups:Object;
      
      protected var m:Matrix;
      
      public var art_loader:ArtLoader;
      
      protected var _pose:Pose;
      
      protected var skin_lookup:Object;
      
      protected var _master_rotation:uint;
      
      protected var _body_rotation:uint;
      
      protected var _costume:Object;
      
      protected var _point_data_source:Class;
      
      protected var _body_height:uint;
      
      public var _sex:uint = 1;
      
      protected var _interface:SkeletonInterface;
      
      protected var bone_structures:Array;
      
      protected var _head:HeadBase;
      
      protected var structure_lookup:Object;
      
      public var edit_mode:Boolean = false;
      
      private var _edit:Boolean = false;
      
      public function Skeleton(param1:HeadBase, param2:ArtLoader, param3:Object = undefined, param4:Boolean = true)
      {
         m = new Matrix();
         tmp_clothes = [];
         waiting_clothes = [];
         clothes = [];
         super();
         doubleClickEnabled = true;
         art_loader = param2;
         if(param1)
         {
            _head = param1;
            _cld = _head.cld;
         }
         edit_mode = param4;
         if(param3 != null)
         {
            _body_type = param3["body_type"];
            _body_height = param3["body_height"];
            breast_type = param3["breast_type"];
            if(param3["sex"])
            {
               sex = param3["sex"];
            }
            else if(body_type == 7 || body_type == 8 || body_type == 9 || body_type == 10)
            {
               sex = 2;
            }
            if(param3["clothes"])
            {
               tmp_clothes = param3["clothes"];
            }
         }
         if(Skeleton.debug)
         {
            trace("_body_type: " + _body_type);
         }
         if(Skeleton.debug)
         {
            graphics.lineStyle(4,39423);
            graphics.moveTo(-100,9);
            graphics.lineTo(100,9);
         }
         stack_groups = new Object();
         _point_data_source = PointData;
         _length_data_source = LengthData;
      }
      
      public function wearing(param1:String) : Boolean
      {
         if(clothes.indexOf(param1) == -1)
         {
            return false;
         }
         return true;
      }
      
      public function get loaded() : Boolean
      {
         if(waiting_clothes.length == 0)
         {
            return true;
         }
         return false;
      }
      
      public function get_bones() : Array
      {
         return bones;
      }
      
      public function get_bone(param1:String) : Bone
      {
         if(bone_lookup.hasOwnProperty(param1))
         {
            return bone_lookup[param1];
         }
         return null;
      }
      
      public function init() : void
      {
         bone_lookup = new Object();
         skin_lookup = new Object();
         structure_lookup = new Object();
         bones = new Array();
         bone_structures = new Array();
         _skin = new Skin(this);
         _interface = new SkeletonInterface(this);
         _interface.mouseEnabled = false;
         _interface.mouseChildren = false;
         _interface.visible = false;
         _controller = new SkeletonController(this,_interface);
         addChild(_skin);
         addChild(_interface);
         _interface.render();
         _controller.init();
         if(_head)
         {
            _cld.addEventListener("NEW_COLOUR",update_colours,false,0,true);
            _head.addEventListener("ROTATION",rotate_head_handler,false,0,true);
         }
      }
      
      public function get skin_name() : String
      {
         if(_controller.selected_skin_patch is MovieClip)
         {
            return MovieClip(_controller.selected_skin_patch).name;
         }
         if(_controller.selected_skin_patch is Head)
         {
            return "head";
         }
         return "unknown";
      }
      
      public function get cld() : ColourData
      {
         return _cld;
      }
      
      public function set button_float(param1:Number) : void
      {
         var _loc2_:Number = _pose.get_float_adjustment(_body_rotation,_body_height,_body_type);
         _pose.float = param1 - _loc2_;
         update_offset_positions();
      }
      
      public function get point_data_source() : Class
      {
         return _point_data_source;
      }
      
      public function set pose(param1:Pose) : void
      {
         var _loc2_:uint = _body_rotation;
         body_rotation = 0;
         param1 = configure_incoming_pose(param1);
         _pose = new Pose(param1,pose_defaults);
         assume_pose(_pose);
         body_rotation = _loc2_;
         dispatchEvent(new Event(Event.CHANGE));
         dispatchEvent(new Event(SkeletonEvent.CHAR_POSE_CHANGE));
      }
      
      public function set edit(param1:Boolean) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:Sprite = null;
         if(param1 == _edit)
         {
            return;
         }
         _edit = param1;
         var _loc2_:Array = _skin.get_skin_pieces();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = 0;
            while(_loc4_ < Sprite(_loc2_[_loc3_].clip).numChildren)
            {
               _loc5_ = _loc2_[_loc3_].clip.getChildAt(_loc4_);
               if(!(_loc5_ is Head || _loc5_ is HeadPiece))
               {
                  if(_edit)
                  {
                     _loc5_.buttonMode = true;
                     _loc5_.addEventListener(MouseEvent.CLICK,art_piece_click,false,0,true);
                  }
                  else
                  {
                     _loc5_.buttonMode = false;
                     _loc5_.removeEventListener(MouseEvent.CLICK,art_piece_click);
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
      
      public function bone_down(param1:String) : Boolean
      {
         var _loc5_:Array = null;
         var _loc2_:Array = _pose.skin_stack;
         var _loc3_:Array = Utils.clone(_loc2_[_body_rotation]) as Array;
         var _loc4_:int = _loc3_.indexOf(param1);
         if(_loc4_ != -1 && _loc4_ != 0)
         {
            _loc5_ = _loc3_.splice(_loc4_,1);
            _loc3_ = _loc3_.slice(0,_loc4_ - 1).concat(_loc5_).concat(_loc3_.slice(_loc4_ - 1));
            _loc2_[body_rotation] = _loc3_;
            _pose.skin_stack = _loc2_;
            _skin.restack(_loc3_);
            return true;
         }
         return false;
      }
      
      public function reset_bones() : void
      {
         set_rotation(0);
         var _loc1_:uint = 0;
         while(_loc1_ < bones.length)
         {
            Bone(bones[_loc1_]).reset();
            Bone(bones[_loc1_]).update = true;
            _loc1_++;
         }
         adjusted_float = 0;
         update_bone_positions();
      }
      
      public function adjust_pose() : void
      {
         var _loc2_:* = null;
         if(Skeleton.debug)
         {
            trace("adjust_pose");
         }
         var _loc1_:Object = Utils.clone(_pose.angles);
         for(_loc2_ in _loc1_)
         {
            _loc1_[_loc2_] = 0;
         }
         adjusted_float = _pose.float + _pose.get_float_adjustment(_body_rotation,_body_height,_body_type);
         if(pose.adjustments["rotation_" + body_rotation])
         {
            if(pose.adjustments["rotation_" + body_rotation].adj)
            {
               if(Skeleton.debug)
               {
                  trace("there is a rotation adjustment for this pose");
               }
               for(_loc2_ in _loc1_)
               {
                  if(pose.adjustments["rotation_" + body_rotation].adj.hasOwnProperty(_loc2_))
                  {
                     _loc1_[_loc2_] = _loc1_[_loc2_] + pose.adjustments["rotation_" + body_rotation].adj[_loc2_];
                     if(Skeleton.debug)
                     {
                        trace("adjusting " + _loc2_ + " by " + pose.adjustments["rotation_" + body_rotation].adj[_loc2_]);
                     }
                  }
               }
            }
            if(pose.adjustments["rotation_" + body_rotation]["height_" + body_height])
            {
               if(pose.adjustments["rotation_" + body_rotation]["height_" + body_height].adj)
               {
                  if(Skeleton.debug)
                  {
                     trace("there is a height adjustment for this pose");
                  }
                  for(_loc2_ in _loc1_)
                  {
                     if(pose.adjustments["rotation_" + body_rotation]["height_" + body_height].adj.hasOwnProperty(_loc2_))
                     {
                        _loc1_[_loc2_] = _loc1_[_loc2_] + pose.adjustments["rotation_" + body_rotation]["height_" + body_height].adj[_loc2_];
                        if(Skeleton.debug)
                        {
                           trace("adjusting " + _loc2_ + " by " + pose.adjustments["rotation_" + body_rotation]["height_" + body_height].adj[_loc2_]);
                        }
                     }
                  }
               }
               if(pose.adjustments["rotation_" + body_rotation]["height_" + body_height]["type_" + body_type])
               {
                  if(Skeleton.debug)
                  {
                     trace("there is a body type adjustment for this pose");
                  }
                  if(pose.adjustments["rotation_" + body_rotation]["height_" + body_height]["type_" + body_type].adj)
                  {
                     for(_loc2_ in _loc1_)
                     {
                        if(pose.adjustments["rotation_" + body_rotation]["height_" + body_height]["type_" + body_type].adj.hasOwnProperty(_loc2_))
                        {
                           _loc1_[_loc2_] = _loc1_[_loc2_] + pose.adjustments["rotation_" + body_rotation]["height_" + body_height]["type_" + body_type].adj[_loc2_];
                           if(Skeleton.debug)
                           {
                              trace("adjusting " + _loc2_ + " by " + pose.adjustments["rotation_" + body_rotation]["height_" + body_height]["type_" + body_type].adj[_loc2_]);
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
            get_bone(_loc2_).adjustment_rotation = _loc1_[_loc2_];
         }
      }
      
      public function get pose_defaults() : Object
      {
         return _pose_defaults;
      }
      
      public function save_state() : Object
      {
         return new Object();
      }
      
      public function get adjusted_float() : Number
      {
         return _adjusted_float;
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
         while(_loc2_ < bones.length)
         {
            Bone(bones[_loc2_]).update = true;
            Bone(bones[_loc2_]).adjustment_rotation = 0;
            _loc2_++;
         }
         var _loc3_:Object = Utils.clone(_pose.angles);
         for(_loc4_ in _loc3_)
         {
            get_bone(_loc4_).internal_rotation = _loc3_[_loc4_];
         }
         _loc5_ = 0;
         while(_loc5_ < bones.length)
         {
            bones[_loc5_].addEventListener(SkeletonEvent.BONE_ROT_CHANGE,update_pose_angle,false,0,true);
            _loc5_++;
         }
         if(_pose.skin_stack)
         {
            _skin.restack(_pose.skin_stack[body_rotation]);
         }
         update_offset_positions();
      }
      
      public function get structures() : Array
      {
         return bone_structures;
      }
      
      public function get body_height() : uint
      {
         return _body_height;
      }
      
      public function get skin_colours() : Array
      {
         if(_controller.selected_skin_patch)
         {
            if(_controller.selected_skin_patch.hasOwnProperty("base_colour"))
            {
               return [_controller.selected_skin_patch.base_colour];
            }
            return [ColourData.get_colours(MovieClip(_controller.selected_skin_patch))];
         }
         return [];
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
         if(clothes.indexOf(param1) >= 0)
         {
            if(Skeleton.debug)
            {
               trace("add_clothing: I\'m already wearing it: " + param1);
            }
            return;
         }
         if(ArtLoader.exclusive_clothing.indexOf(param1) != -1)
         {
            clothes = [];
         }
         if(art_loader.clothing_loaded(param1,species) == false)
         {
            if(waiting_clothes.indexOf(param1) == -1)
            {
               art_loader.clothing_queue(param1,this,species);
               waiting_clothes.push(param1);
               if(naked())
               {
                  _skin.visible = false;
               }
               return;
            }
            return;
         }
         if(waiting_clothes.indexOf(param1) != -1)
         {
            _loc5_ = waiting_clothes.indexOf(param1);
            waiting_clothes.splice(_loc5_,1);
            if(waiting_clothes.length == 0 || naked() == false)
            {
               _skin.visible = true;
               dispatchEvent(new Event(Event.COMPLETE));
            }
         }
         clothes.push(param1);
         var _loc3_:Array = _skin.get_skin_pieces();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc6_ = _loc3_[_loc4_].type;
            _loc7_ = art_loader.get_art(species,_loc6_ + "_" + param1);
            if(_loc7_)
            {
               _skin.add_skin_layer(_loc3_[_loc4_].name,DisplayObjectContainer(_loc7_));
               _controller.selected_skin_patch = _loc7_;
               if(_loc7_.base_colour == null)
               {
                  _loc7_.set_new_frame_func(cld.colour_clip);
               }
               if(_edit)
               {
                  _loc7_.buttonMode = true;
                  _loc7_.addEventListener(MouseEvent.CLICK,art_piece_click,false,0,true);
               }
            }
            else if(Skeleton.debug)
            {
               trace("Didn\'t get a piece: " + _loc6_ + "_" + param1);
            }
            _loc4_++;
         }
         this.dispatchEvent(new Event(SkeletonEvent.CHAR_CLOTHES_CHANGE));
         update_colours();
         this.dispatchEvent(new Event("clothing_click"));
         _controller.update_skin_listeners();
         clothing_special_rules();
         _skin.update_frame();
      }
      
      private function rotate_head_handler(param1:Event) : void
      {
         manage_head_rotation();
      }
      
      public function set body_type(param1:uint) : void
      {
         _body_type = param1;
         _interface.render();
         update_offset_positions();
         this.dispatchEvent(new Event(SkeletonEvent.CHAR_TYPE_CHANGE));
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function configure_incoming_pose(param1:Pose) : Pose
      {
         return param1;
      }
      
      public function get_bone_angles() : Object
      {
         var _loc3_:uint = 0;
         var _loc1_:Object = new Object();
         var _loc2_:uint = 0;
         while(_loc2_ < structures.length)
         {
            _loc3_ = 0;
            while(_loc3_ < structures[_loc2_].bones.length)
            {
               _loc1_[Bone(structures[_loc2_].bones[_loc3_]).name] = Bone(structures[_loc2_].bones[_loc3_]).internal_rotation;
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get sex() : uint
      {
         return _sex;
      }
      
      public function toggle_control() : Boolean
      {
         _controller.bone_control = !_controller.bone_control;
         return _controller.bone_control;
      }
      
      protected function clothing_special_rules() : void
      {
      }
      
      public function get body_rotation() : uint
      {
         return _body_rotation;
      }
      
      public function get skin() : Skin
      {
         return _skin;
      }
      
      public function set_control(param1:Boolean) : void
      {
         _controller.bone_control = param1;
      }
      
      public function get flipped() : Boolean
      {
         return _flipped;
      }
      
      public function remove() : void
      {
      }
      
      public function get bone_interface() : SkeletonInterface
      {
         return _interface;
      }
      
      public function get pose() : Pose
      {
         return _pose;
      }
      
      public function get controller() : SkeletonController
      {
         return _controller;
      }
      
      public function set adjusted_float(param1:Number) : void
      {
         if(Skeleton.debug)
         {
            trace("Skeleton.adjusted_float = " + _adjusted_float);
         }
         _adjusted_float = param1;
      }
      
      public function get_stack_group(param1:String) : Array
      {
         var _loc2_:Array = new Array();
         if(stack_groups.hasOwnProperty(param1))
         {
            _loc2_ = stack_groups[param1];
         }
         return _loc2_;
      }
      
      public function manage_head_rotation() : void
      {
         _skin.restack(get_skin_stack());
         var _loc1_:Boolean = false;
         if(_head.h_rot >= 3 && _head.h_rot <= 5 && (body_rotation <= 2 || body_rotation >= 6))
         {
            _loc1_ = true;
         }
         else if(body_rotation >= 3 && body_rotation <= 5 && (_head.h_rot >= 6 || _head.h_rot <= 2))
         {
            _loc1_ = true;
         }
         if(_loc1_)
         {
            if(_skin.get_skin_piece("head") && _skin.get_skin_piece("head_back"))
            {
               if(0 == 0)
               {
                  if(0 == 0)
                  {
                     _skin.swapChildren(_skin.get_skin_piece("head").clip,_skin.get_skin_piece("head_back").clip);
                  }
               }
            }
         }
      }
      
      public function add_bone(param1:Object, param2:Bone, param3:Bone = null) : void
      {
         param1.bones.push(param2);
         bones.push(param2);
         if(param3)
         {
            param3.add_child(param2);
         }
         bone_lookup[param2.name] = param2;
      }
      
      protected function update_offset_positions() : void
      {
         adjust_pose();
         if(Skeleton.debug)
         {
            trace("update_offset_positions()");
         }
         var _loc1_:uint = 0;
         while(_loc1_ < bone_structures.length)
         {
            bone_structures[_loc1_].position = Utils.clone(point_data_source.data[bone_structures[_loc1_].pos_name][body_type][body_height][body_rotation]);
            if(Skeleton.debug)
            {
               trace(bone_structures[_loc1_].name + "  " + bone_structures[_loc1_].position);
            }
            _loc1_++;
         }
         structure_lookup.spine.position[1] = structure_lookup.spine.position[1] + _adjusted_float;
         update_bone_positions();
      }
      
      public function update_colours(param1:Event = null) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:DisplayObject = null;
         if(Skeleton.debug)
         {
            trace("UPDATE COLOURS ---------------------------------------------------- " + this.name + " " + this);
         }
         var _loc2_:Array = _skin.get_skin_pieces();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = 0;
            while(_loc4_ < Sprite(_loc2_[_loc3_].clip).numChildren)
            {
               _loc5_ = _loc2_[_loc3_].clip.getChildAt(_loc4_);
               if(!(_loc5_ is Head || _loc5_ is HeadPiece))
               {
                  _cld.colour_clip(_loc5_);
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public function get body_type() : uint
      {
         return _body_type;
      }
      
      private function naked() : Boolean
      {
         if(clothes.length == 1)
         {
            if(ArtLoader.exclusive_clothing.indexOf(clothes[0]) != -1)
            {
               return false;
            }
         }
         if((is_wearing("shirt") || is_wearing("jacket")) == false)
         {
            return true;
         }
         if((is_wearing("pants") || is_wearing("skirt")) == false)
         {
            return true;
         }
         return false;
      }
      
      public function set head(param1:HeadBase) : void
      {
         _head = param1;
         _cld = _head.cld;
         _cld.addEventListener("NEW_COLOUR",update_colours,false,0,true);
         _head.addEventListener("ROTATION",rotate_head_handler,false,0,true);
         _head.mouseChildren = false;
      }
      
      public function set_rotation(param1:uint) : uint
      {
         if(param1 >= 8)
         {
            param1 = 0;
         }
         param1 = Math.min(7,Math.max(0,param1));
         _master_rotation = param1;
         var _loc2_:Boolean = false;
         _flipped = false;
         switch(_master_rotation)
         {
            case 7:
               _flipped = true;
               _loc2_ = true;
               body_rotation = 1;
               break;
            case 6:
               _loc2_ = true;
               _flipped = true;
               body_rotation = 2;
               break;
            case 5:
               _loc2_ = true;
               _flipped = true;
               body_rotation = 3;
               break;
            default:
               body_rotation = _master_rotation;
         }
         if(_loc2_)
         {
            _skin.scaleX = -1;
            _skin.get_skin_piece("head").clip.scaleX = -1;
            _skin.get_skin_piece("head_back").clip.scaleX = -1;
            _flipped = true;
         }
         else
         {
            _skin.scaleX = 1;
            _skin.get_skin_piece("head").clip.scaleX = 1;
            _skin.get_skin_piece("head_back").clip.scaleX = 1;
            _flipped = false;
         }
         dispatchEvent(new Event(Event.CHANGE));
         return _master_rotation;
      }
      
      public function set body_height(param1:uint) : void
      {
         _body_height = param1;
         var _loc2_:uint = 0;
         while(_loc2_ < bones.length)
         {
            bones[_loc2_].length = _length_data_source[bones[_loc2_].type][_body_height];
            _loc2_++;
         }
         update_offset_positions();
         this.dispatchEvent(new Event(SkeletonEvent.CHAR_HEIGHT_CHANGE));
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get_structure(param1:String) : Object
      {
         if(structure_lookup.hasOwnProperty(param1))
         {
            return structure_lookup[param1];
         }
         return null;
      }
      
      public function set sex(param1:uint) : void
      {
         if(param1 == 2)
         {
            _sex = 2;
            if(_body_type == 0)
            {
               body_type = 7;
            }
            if(_body_type == 1)
            {
               body_type = 8;
            }
            if(_body_type == 3)
            {
               body_type = 9;
            }
            if(_body_type == 5)
            {
               body_type = 10;
            }
         }
         else
         {
            _sex = 1;
            if(_body_type == 7)
            {
               body_type = 0;
            }
            if(_body_type == 8)
            {
               body_type = 1;
            }
            if(_body_type == 9)
            {
               body_type = 3;
            }
            if(_body_type == 10)
            {
               body_type = 5;
            }
         }
         this.dispatchEvent(new Event(SkeletonEvent.CHAR_SEX_CHANGE));
      }
      
      public function get_skin_stack() : Array
      {
         var _loc1_:Array = new Array();
         if(_pose.skin_stack[body_rotation])
         {
            _loc1_ = _pose.skin_stack[body_rotation];
         }
         return _loc1_;
      }
      
      public function get master_rotation() : uint
      {
         return _master_rotation;
      }
      
      public function set breast_type(param1:uint) : void
      {
         if(param1 <= 3)
         {
            _breast_type = param1;
         }
         else
         {
            _breast_type = 0;
         }
         this.dispatchEvent(new Event(SkeletonEvent.CHAR_BREASTS_CHANGE));
      }
      
      private function update_pose_angle(param1:Event) : void
      {
         var _loc2_:Bone = Bone(param1.currentTarget);
         _pose.angles[_loc2_.name] = _loc2_.internal_rotation;
      }
      
      public function set temp_rot(param1:Number) : void
      {
         _temp_rot = param1;
         dispatchEvent(new Event(SkeletonEvent.SKELETON_ANGLE_CHANGE));
      }
      
      public function remove_clothing(param1:String) : void
      {
         if(clothes.indexOf(param1) == -1 || param1 == "bare")
         {
            if(Skeleton.debug)
            {
               trace("Remove Clothing: I\'m not wearing it:" + param1);
            }
            return;
         }
         var _loc2_:Array = _skin.get_skin_pieces();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _skin.remove_skin_layer(_loc2_[_loc3_].name,param1);
            _loc3_++;
         }
         clothes.splice(clothes.indexOf(param1),1);
         clothing_special_rules();
         _skin.update_frame();
      }
      
      public function update_bone_positions() : void
      {
         _interface.update();
      }
      
      public function get head() : HeadBase
      {
         return _head;
      }
      
      public function get breast_type() : uint
      {
         return _breast_type;
      }
      
      public function is_wearing(param1:String) : Boolean
      {
         var _loc2_:String = null;
         for each(_loc2_ in clothes)
         {
            if(_loc2_.indexOf(param1) != -1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get temp_rot() : Number
      {
         return _temp_rot;
      }
      
      public function set body_rotation(param1:uint) : void
      {
         var _loc2_:Boolean = false;
         if(param1 == 0 && _body_rotation != 0 && _body_rotation != 4)
         {
            _loc2_ = true;
         }
         else if(_body_rotation == 0 && param1 != 0 && param1 != 4)
         {
            _loc2_ = true;
         }
         else if(param1 == 4 && _body_rotation != 4 && _body_rotation != 0)
         {
            _loc2_ = true;
         }
         else if(_body_rotation == 4 && param1 != 4 && param1 != 0)
         {
            _loc2_ = true;
         }
         _body_rotation = param1;
         update_offset_positions();
         if(_loc2_)
         {
            this.dispatchEvent(new Event(SkeletonEvent.LEG_FLIP));
         }
         update_offset_positions();
         this.dispatchEvent(new Event(SkeletonEvent.CHAR_ROT_CHANGE));
      }
      
      public function bone_up(param1:String) : Boolean
      {
         var _loc5_:Array = null;
         var _loc2_:Array = _pose.skin_stack;
         var _loc3_:Array = Utils.clone(_loc2_[_body_rotation]) as Array;
         var _loc4_:int = _loc3_.indexOf(param1);
         if(_loc4_ != -1 && _loc4_ != _loc3_.length - 1)
         {
            _loc5_ = _loc3_.splice(_loc4_,1);
            _loc3_ = _loc3_.slice(0,_loc4_ + 1).concat(_loc5_).concat(_loc3_.slice(_loc4_ + 1));
            _loc2_[body_rotation] = _loc3_;
            _pose.skin_stack = _loc2_;
            _skin.restack(_loc3_);
            return true;
         }
         return false;
      }
      
      public function load_state(param1:Object) : void
      {
      }
   }
}
