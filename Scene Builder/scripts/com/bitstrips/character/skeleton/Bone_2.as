package com.bitstrips.character.skeleton
{
   import com.bitstrips.Utils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class Bone extends EventDispatcher
   {
       
      
      public var position_skins:Array;
      
      private var _length:Number = 0;
      
      public var rotation_skins:Array;
      
      public var bend_skins:Array;
      
      private var _type:String = "";
      
      public var control_skins:Array;
      
      private var _limits:Array;
      
      private var _internal_rotation:Number = 0;
      
      private var _flipped:Boolean;
      
      private var _adjustment_rotation:Number = 0;
      
      public var debug:Boolean = false;
      
      private var _inherited_rotation:Number = 0;
      
      private var _update:Boolean;
      
      private var _name:String = "";
      
      public var frame:uint = 1;
      
      private var _structure:String = "";
      
      public var graphic:Object;
      
      private var _x:Number = 0;
      
      private var _y:Number = 0;
      
      private var children:Array;
      
      public function Bone(param1:String, param2:String, param3:String = "", param4:Array = null)
      {
         super();
         _name = param1;
         _type = param2;
         _structure = param3;
         _limits = param4;
         children = new Array();
         position_skins = new Array();
         rotation_skins = new Array();
         control_skins = new Array();
         bend_skins = new Array();
         _flipped = false;
         _update = false;
      }
      
      public function get_position() : Point
      {
         return new Point(_x,_y);
      }
      
      public function get_end_point() : Point
      {
         var _loc1_:Number = rotation * Math.PI / 180;
         var _loc2_:Number = _x + Math.cos(_loc1_) * _length;
         var _loc3_:Number = _y + Math.sin(_loc1_) * _length;
         return new Point(_loc2_,_loc3_);
      }
      
      public function get y() : Number
      {
         return _y;
      }
      
      public function get flipped() : Boolean
      {
         return _flipped;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function bone_up(param1:Event) : void
      {
         dispatchEvent(new Event("bone_up"));
      }
      
      public function add_rotation_skin(param1:Object) : void
      {
         rotation_skins.push(param1);
      }
      
      public function get_proto_point(param1:Number, param2:Number) : Point
      {
         var _loc3_:Number = (rotation + param2 + 360) % 360;
         var _loc4_:Number = _loc3_ * Math.PI / 180;
         var _loc5_:Number = _x + Math.cos(_loc4_) * param1;
         var _loc6_:Number = _y + Math.sin(_loc4_) * param1;
         return new Point(_loc5_,_loc6_);
      }
      
      public function set update(param1:Boolean) : void
      {
         _update = param1;
      }
      
      public function set y(param1:Number) : void
      {
         _y = param1;
         if(debug)
         {
            trace("Bone.set y()");
         }
         update_children();
      }
      
      public function get rotation() : Number
      {
         return Utils.degrees(_internal_rotation + _inherited_rotation + _adjustment_rotation);
      }
      
      public function bone_move_around(param1:Event) : void
      {
         dispatchEvent(new Event("bone_move_around"));
      }
      
      public function set inherited_rotation(param1:Number) : void
      {
         _inherited_rotation = param1;
         if(debug)
         {
            trace("Bone.set inherited_rotation()");
         }
         update_children();
      }
      
      public function get adjustment_rotation() : Number
      {
         return Utils.degrees(_adjustment_rotation);
      }
      
      private function conform_to_limits(param1:Number) : Number
      {
         param1 = Utils.degrees(param1);
         if(_limits)
         {
            if(param1 > 180)
            {
               param1 = param1 - 360;
            }
            if(_flipped)
            {
               if(param1 < 0 - _limits[1])
               {
                  param1 = 0 - _limits[1];
               }
               else if(param1 > 0 - _limits[0])
               {
                  param1 = 0 - _limits[0];
               }
            }
            else if(param1 < _limits[0])
            {
               param1 = _limits[0];
            }
            else if(param1 > _limits[1])
            {
               param1 = _limits[1];
            }
         }
         return Utils.degrees(param1);
      }
      
      public function add_bend_skin(param1:Object) : void
      {
         bend_skins.push(param1);
      }
      
      public function set adjustment_rotation(param1:Number) : void
      {
         _adjustment_rotation = Utils.degrees(param1);
      }
      
      public function set internal_rotation(param1:Number) : void
      {
         _internal_rotation = Utils.degrees(conform_to_limits(param1 + _adjustment_rotation) - _adjustment_rotation);
         this.dispatchEvent(new Event(SkeletonEvent.BONE_POS_CHANGE));
         this.dispatchEvent(new Event(SkeletonEvent.BONE_ASPECT_CHANGE));
         update_children();
      }
      
      private function check_limits(param1:Number) : Boolean
      {
         var _loc2_:Boolean = true;
         if(_limits)
         {
            if(param1 > 180)
            {
               param1 = param1 - 360;
            }
            if(param1 > _limits[1])
            {
               _loc2_ = false;
            }
            else if(param1 < _limits[0])
            {
               _loc2_ = false;
            }
         }
         return _loc2_;
      }
      
      public function get_mid_point() : Point
      {
         var _loc1_:Number = rotation * Math.PI / 180;
         var _loc2_:Number = Math.cos(_loc1_) * _length;
         var _loc3_:Number = Math.sin(_loc1_) * _length;
         return new Point(_x + _loc2_ / 2,_y + _loc3_ / 2);
      }
      
      public function add_position_skin(param1:Object) : void
      {
         position_skins.push(param1);
      }
      
      public function get type() : String
      {
         return _type;
      }
      
      private function update_children() : void
      {
         _update = true;
         var _loc1_:uint = 0;
         while(_loc1_ < children.length)
         {
            Bone(children[_loc1_]).set_position(get_end_point(),rotation);
            _loc1_++;
         }
      }
      
      public function bone_down(param1:Event) : void
      {
         dispatchEvent(new Event("bone_down"));
      }
      
      public function set limits(param1:Array) : void
      {
         _limits = param1;
         internal_rotation = _internal_rotation;
      }
      
      public function get internal_rotation() : Number
      {
         return Utils.degrees(_internal_rotation);
      }
      
      public function get update() : Boolean
      {
         return _update;
      }
      
      public function get inherited_rotation() : Number
      {
         return _inherited_rotation;
      }
      
      public function set length(param1:Number) : void
      {
         _length = param1;
         if(debug)
         {
            trace("Bone.set length()");
         }
         update_children();
      }
      
      public function bone_click(param1:Event) : void
      {
      }
      
      public function reset() : void
      {
         _adjustment_rotation = 0;
         internal_rotation = 0;
         _inherited_rotation = 0;
         update_children();
      }
      
      public function set internal_rotation_move(param1:Number) : void
      {
         internal_rotation = param1;
         this.dispatchEvent(new Event(SkeletonEvent.BONE_ROT_CHANGE));
      }
      
      public function set_position(param1:Point, param2:Number = 0) : void
      {
         _x = param1.x;
         _y = param1.y;
         inherited_rotation = param2;
         this.dispatchEvent(new Event(SkeletonEvent.BONE_POS_CHANGE));
         if(debug)
         {
            trace("Bone.set_position()");
         }
         update_children();
      }
      
      public function bone_out(param1:Event) : void
      {
         dispatchEvent(new Event("bone_out"));
      }
      
      public function set x(param1:Number) : void
      {
         _x = param1;
         if(debug)
         {
            trace("Bone.set x()");
         }
         update_children();
      }
      
      public function get structure() : String
      {
         return _structure;
      }
      
      public function get length() : Number
      {
         return _length;
      }
      
      public function bone_over(param1:Event) : void
      {
         dispatchEvent(new Event("bone_over"));
      }
      
      public function get x() : Number
      {
         return _x;
      }
      
      public function flip() : void
      {
         _flipped = !_flipped;
         _internal_rotation = 360 - internal_rotation;
      }
      
      public function add_control_skin(param1:Object) : void
      {
         control_skins.push(param1);
      }
      
      public function add_child(param1:Bone) : void
      {
         children.push(param1);
         if(debug)
         {
            trace("Bone.add_child()");
         }
         update_children();
      }
   }
}
