package com.bitstrips.character.skeleton
{
   import com.bitstrips.Utils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class Bone extends EventDispatcher
   {
       
      
      private var _x:Number = 0;
      
      private var _y:Number = 0;
      
      private var children:Array;
      
      private var _name:String = "";
      
      private var _type:String = "";
      
      private var _structure:String = "";
      
      private var _length:Number = 0;
      
      private var _internal_rotation:Number = 0;
      
      private var _inherited_rotation:Number = 0;
      
      private var _adjustment_rotation:Number = 0;
      
      private var _graphic:Object;
      
      public var frame:uint = 1;
      
      public var position_skins:Array;
      
      public var rotation_skins:Array;
      
      public var control_skins:Array;
      
      public var bend_skins:Array;
      
      public var debug:Boolean = false;
      
      private var _limits:Array;
      
      private var _flipped:Boolean;
      
      private var _update:Boolean;
      
      public function Bone(param1:String, param2:String, param3:String = "", param4:Array = null)
      {
         super();
         this._name = param1;
         this._type = param2;
         this._structure = param3;
         this._limits = param4;
         this.children = new Array();
         this.position_skins = new Array();
         this.rotation_skins = new Array();
         this.control_skins = new Array();
         this.bend_skins = new Array();
         this._flipped = false;
         this._update = false;
      }
      
      public function remove() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Bone = null;
         if(this.children)
         {
            _loc1_ = 0;
            while(_loc1_ < this.children.length)
            {
               _loc2_ = this.children[_loc1_];
               _loc2_.remove();
               _loc2_ = null;
               _loc1_++;
            }
         }
         this.children = null;
         this.position_skins = null;
         this.rotation_skins = null;
         this.control_skins = null;
         this.bend_skins = null;
      }
      
      public function add_child(param1:Bone) : void
      {
         this.children.push(param1);
         if(this.debug)
         {
            trace("Bone.add_child()");
         }
         this.update_children();
      }
      
      public function add_position_skin(param1:Object) : void
      {
         this.position_skins.push(param1);
      }
      
      public function add_rotation_skin(param1:Object) : void
      {
         this.rotation_skins.push(param1);
      }
      
      public function add_control_skin(param1:Object) : void
      {
         this.control_skins.push(param1);
      }
      
      public function add_bend_skin(param1:Object) : void
      {
         this.bend_skins.push(param1);
      }
      
      public function set_position(param1:Point, param2:Number = 0) : void
      {
         if(this._x == param1.x && this._y == param1.y && this.inherited_rotation == param2)
         {
            return;
         }
         this._x = param1.x;
         this._y = param1.y;
         this.inherited_rotation = param2;
         this.dispatchEvent(new Event(SkeletonEvent.BONE_POS_CHANGE));
         if(this.debug)
         {
            trace("Bone.set_position()");
         }
         this.update_children();
      }
      
      private function update_children() : void
      {
         this._update = true;
         var _loc1_:uint = 0;
         while(_loc1_ < this.children.length)
         {
            Bone(this.children[_loc1_]).set_position(this.get_end_point(),this.rotation);
            _loc1_++;
         }
      }
      
      public function get_end_point() : Point
      {
         var _loc1_:Number = this.rotation * Math.PI / 180;
         var _loc2_:Number = this._x + Math.cos(_loc1_) * this._length;
         var _loc3_:Number = this._y + Math.sin(_loc1_) * this._length;
         return new Point(_loc2_,_loc3_);
      }
      
      public function get_proto_point(param1:Number, param2:Number) : Point
      {
         var _loc3_:Number = (this.rotation + param2 + 360) % 360;
         var _loc4_:Number = _loc3_ * Math.PI / 180;
         var _loc5_:Number = this._x + Math.cos(_loc4_) * param1;
         var _loc6_:Number = this._y + Math.sin(_loc4_) * param1;
         return new Point(_loc5_,_loc6_);
      }
      
      public function get_mid_point() : Point
      {
         var _loc1_:Number = this.rotation * Math.PI / 180;
         var _loc2_:Number = Math.cos(_loc1_) * this._length;
         var _loc3_:Number = Math.sin(_loc1_) * this._length;
         return new Point(this._x + _loc2_ / 2,this._y + _loc3_ / 2);
      }
      
      public function get_position() : Point
      {
         return new Point(this._x,this._y);
      }
      
      public function bone_over(param1:Event) : void
      {
         dispatchEvent(new Event("bone_over"));
      }
      
      public function bone_out(param1:Event) : void
      {
         dispatchEvent(new Event("bone_out"));
      }
      
      public function bone_down(param1:Event) : void
      {
         dispatchEvent(new Event("bone_down"));
      }
      
      public function bone_up(param1:Event) : void
      {
         dispatchEvent(new Event("bone_up"));
      }
      
      public function bone_move_around(param1:Event) : void
      {
         dispatchEvent(new Event("bone_move_around"));
      }
      
      public function bone_click(param1:Event) : void
      {
      }
      
      public function reset() : void
      {
         this._adjustment_rotation = 0;
         this.internal_rotation = 0;
         this._inherited_rotation = 0;
         this.update_children();
      }
      
      public function set x(param1:Number) : void
      {
         this._x = param1;
         if(this.debug)
         {
            trace("Bone.set x()");
         }
         this.update_children();
      }
      
      public function get x() : Number
      {
         return this._x;
      }
      
      public function set y(param1:Number) : void
      {
         this._y = param1;
         if(this.debug)
         {
            trace("Bone.set y()");
         }
         this.update_children();
      }
      
      public function get y() : Number
      {
         return this._y;
      }
      
      public function set length(param1:Number) : void
      {
         this._length = param1;
         if(this.debug)
         {
            trace("Bone.set length()");
         }
         this.update_children();
      }
      
      public function get length() : Number
      {
         return this._length;
      }
      
      public function set inherited_rotation(param1:Number) : void
      {
         this._inherited_rotation = param1;
         if(this.debug)
         {
            trace("Bone.set inherited_rotation()");
         }
         this.update_children();
      }
      
      public function set internal_rotation_move(param1:Number) : void
      {
         this.internal_rotation = param1;
         this.dispatchEvent(new Event(SkeletonEvent.BONE_ROT_CHANGE));
      }
      
      public function set internal_rotation(param1:Number) : void
      {
         this._internal_rotation = Utils.degrees(this.conform_to_limits(param1 + this._adjustment_rotation) - this._adjustment_rotation);
         this.dispatchEvent(new Event(SkeletonEvent.BONE_POS_CHANGE));
         this.dispatchEvent(new Event(SkeletonEvent.BONE_ASPECT_CHANGE));
         this.update_children();
      }
      
      public function set adjustment_rotation(param1:Number) : void
      {
         this._adjustment_rotation = Utils.degrees(param1);
      }
      
      public function get adjustment_rotation() : Number
      {
         return Utils.degrees(this._adjustment_rotation);
      }
      
      public function get rotation() : Number
      {
         return Utils.degrees(this._internal_rotation + this._inherited_rotation + this._adjustment_rotation);
      }
      
      public function get internal_rotation() : Number
      {
         return Utils.degrees(this._internal_rotation);
      }
      
      public function get inherited_rotation() : Number
      {
         return this._inherited_rotation;
      }
      
      public function flip() : void
      {
         this._flipped = !this._flipped;
         this._internal_rotation = 360 - this.internal_rotation;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get structure() : String
      {
         return this._structure;
      }
      
      private function check_limits(param1:Number) : Boolean
      {
         var _loc2_:Boolean = true;
         if(this._limits)
         {
            if(param1 > 180)
            {
               param1 = param1 - 360;
            }
            if(param1 > this._limits[1])
            {
               _loc2_ = false;
            }
            else if(param1 < this._limits[0])
            {
               _loc2_ = false;
            }
         }
         return _loc2_;
      }
      
      private function conform_to_limits(param1:Number) : Number
      {
         param1 = Utils.degrees(param1);
         if(this._limits)
         {
            if(param1 > 180)
            {
               param1 = param1 - 360;
            }
            if(this._flipped)
            {
               if(param1 < 0 - this._limits[1])
               {
                  param1 = 0 - this._limits[1];
               }
               else if(param1 > 0 - this._limits[0])
               {
                  param1 = 0 - this._limits[0];
               }
            }
            else if(param1 < this._limits[0])
            {
               param1 = this._limits[0];
            }
            else if(param1 > this._limits[1])
            {
               param1 = this._limits[1];
            }
         }
         return Utils.degrees(param1);
      }
      
      public function set limits(param1:Array) : void
      {
         this._limits = param1;
         this.internal_rotation = this._internal_rotation;
      }
      
      public function set update(param1:Boolean) : void
      {
         this._update = param1;
      }
      
      public function get update() : Boolean
      {
         return this._update;
      }
      
      public function get flipped() : Boolean
      {
         return this._flipped;
      }
      
      public function set graphic(param1:Object) : void
      {
         this._graphic = param1;
      }
      
      public function get graphic() : Object
      {
         return this._graphic;
      }
   }
}
