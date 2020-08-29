package com.bitstrips.character.skeleton
{
   import com.bitstrips.Utils;
   
   public class Pose
   {
       
      
      private var _name:String = "";
      
      private var _type:String = "none";
      
      private var _angles:Object;
      
      private var _float:Number = 0;
      
      private var _adjustments:Object;
      
      private var _skin_stack:Array;
      
      public var _default_skin_stack:Array;
      
      private var _simple_stack_top:Array;
      
      private var _simple_stack_bottom:Array;
      
      var _hand_rotate:Array;
      
      private var _hand_flip:Array;
      
      private var _hand_pose:Array;
      
      private const properties:Array = ["name","type","angles","adjustments","skin_stack","_default_skin_stack","_simple_stack_top","_simple_stack_bottom","hand_pose","hand_rotate","hand_flip","float"];
      
      private var debug:Boolean;
      
      public function Pose(param1:Object = null, param2:Object = null)
      {
         var _loc3_:uint = 0;
         this._angles = new Object();
         this._adjustments = new Object();
         this.debug = Skeleton.debug;
         super();
         if(!param1)
         {
            param1 = new Object();
         }
         if(!param2)
         {
            param2 = new Object();
         }
         _loc3_ = 0;
         while(_loc3_ < this.properties.length)
         {
            if(param1.hasOwnProperty(this.properties[_loc3_]))
            {
               if(this.debug)
               {
                  trace("info." + this.properties[_loc3_] + ": " + param1[this.properties[_loc3_]]);
               }
               this[this.properties[_loc3_]] = Utils.clone(param1[this.properties[_loc3_]]);
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.properties.length)
         {
            if(param2.hasOwnProperty(this.properties[_loc3_]))
            {
               if(this.debug)
               {
                  trace("default." + this.properties[_loc3_] + ": " + param2[this.properties[_loc3_]]);
               }
               if(this[this.properties[_loc3_]] == null || this[this.properties[_loc3_]] == undefined)
               {
                  this[this.properties[_loc3_]] = Utils.clone(param2[this.properties[_loc3_]]);
               }
            }
            _loc3_++;
         }
         if(param1.hasOwnProperty("type"))
         {
            if(param1.type == PoseType.GESTURE)
            {
               this._float = 0;
            }
         }
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
      }
      
      public function set angles(param1:Object) : void
      {
         this._angles = Utils.clone(param1);
      }
      
      public function set adjustments(param1:Object) : void
      {
         this._adjustments = Utils.clone(param1);
      }
      
      public function set skin_stack(param1:Array) : void
      {
         this._skin_stack = Utils.clone(param1) as Array;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get angles() : Object
      {
         return this._angles;
      }
      
      public function get adjustments() : Object
      {
         return this._adjustments;
      }
      
      public function get skin_stack() : Array
      {
         return this._skin_stack;
      }
      
      public function get default_skin_stack() : Array
      {
         return this._default_skin_stack;
      }
      
      public function get simple_stack_top() : Array
      {
         return this._simple_stack_top;
      }
      
      public function get simple_stack_bottom() : Array
      {
         return this._simple_stack_bottom;
      }
      
      public function get hand_rotate() : Array
      {
         return this._hand_rotate;
      }
      
      public function set hand_rotate(param1:Array) : void
      {
         this._hand_rotate = param1;
      }
      
      public function get hand_flip() : Array
      {
         return this._hand_flip;
      }
      
      public function set hand_flip(param1:Array) : void
      {
         this._hand_flip = param1;
      }
      
      public function get hand_pose() : Array
      {
         return this._hand_pose;
      }
      
      public function set hand_pose(param1:Array) : void
      {
         this._hand_pose = param1;
      }
      
      public function set_hand(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         this._hand_pose[param1] = param3;
         this._hand_rotate[param4][param1] = param2;
      }
      
      public function get float() : Number
      {
         return this._float;
      }
      
      public function get_float_adjustment(param1:uint, param2:uint, param3:uint) : Number
      {
         if(this._type != PoseType.ACTION && this._type != PoseType.STANCE && this._type != PoseType.COMBO)
         {
            return 0;
         }
         var _loc4_:String = String(param1);
         var _loc5_:String = String(param2);
         var _loc6_:String = String(param3);
         var _loc7_:Number = 0;
         if(this.adjustments["rotation_" + _loc4_])
         {
            if(this.adjustments["rotation_" + _loc4_].hasOwnProperty("float"))
            {
               _loc7_ = _loc7_ + this.adjustments["rotation_" + _loc4_].float;
            }
            if(this.adjustments["rotation_" + _loc4_]["height_" + _loc5_])
            {
               if(this.adjustments["rotation_" + _loc4_]["height_" + _loc5_].hasOwnProperty("float"))
               {
                  _loc7_ = _loc7_ + this.adjustments["rotation_" + _loc4_]["height_" + _loc5_].float;
               }
               if(this.adjustments["rotation_" + _loc4_]["height_" + _loc5_]["type_" + _loc6_])
               {
                  if(this.adjustments["rotation_" + _loc4_]["height_" + _loc5_]["type_" + _loc6_].hasOwnProperty("float"))
                  {
                     _loc7_ = _loc7_ + this.adjustments["rotation_" + _loc4_]["height_" + _loc5_]["type_" + _loc6_].float;
                  }
               }
            }
         }
         if(this.debug)
         {
            trace("adjusted_float: " + _loc7_);
         }
         return _loc7_;
      }
      
      public function set float(param1:Number) : void
      {
         this._float = param1;
      }
      
      public function save_state() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.name = this.name;
         _loc1_.type = this.type;
         _loc1_.angles = Utils.clone(this.angles);
         _loc1_.adjustments = Utils.clone(this.adjustments);
         _loc1_.skin_stack = Utils.clone(this.skin_stack);
         _loc1_.hand_pose = Utils.clone(this.hand_pose);
         _loc1_.hand_rotate = Utils.clone(this.hand_rotate);
         _loc1_.float = this.float;
         return _loc1_;
      }
   }
}
