package com.bitstrips.character.skeleton
{
   import com.bitstrips.Utils;
   
   public class Pose
   {
       
      
      private var _type:String = "none";
      
      private var _angles:Object;
      
      public var _default_skin_stack:Array;
      
      private var _simple_stack_top:Array;
      
      private var _hand_flip:Array;
      
      private const properties:Array = ["name","type","angles","adjustments","skin_stack","_default_skin_stack","_simple_stack_top","_simple_stack_bottom","hand_pose","hand_rotate","hand_flip","float"];
      
      private var debug:Boolean = false;
      
      private var _float:Number = 0;
      
      private var _hand_pose:Array;
      
      private var _skin_stack:Array;
      
      private var _adjustments:Object;
      
      private var _name:String = "";
      
      var _hand_rotate:Array;
      
      private var _simple_stack_bottom:Array;
      
      public function Pose(param1:Object = null, param2:Object = null)
      {
         var _loc3_:uint = 0;
         _angles = new Object();
         _adjustments = new Object();
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
         while(_loc3_ < properties.length)
         {
            if(param1.hasOwnProperty(properties[_loc3_]))
            {
               if(debug)
               {
                  trace(properties[_loc3_] + " " + param1[properties[_loc3_]]);
               }
               this[properties[_loc3_]] = Utils.clone(param1[properties[_loc3_]]);
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < properties.length)
         {
            if(param2.hasOwnProperty(properties[_loc3_]))
            {
               if(this[properties[_loc3_]] == null || this[properties[_loc3_]] == undefined)
               {
                  this[properties[_loc3_]] = Utils.clone(param2[properties[_loc3_]]);
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
      
      public function set angles(param1:Object) : void
      {
         _angles = Utils.clone(param1);
      }
      
      public function get default_skin_stack() : Array
      {
         return _default_skin_stack;
      }
      
      public function get angles() : Object
      {
         return _angles;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function set skin_stack(param1:Array) : void
      {
         _skin_stack = Utils.clone(param1) as Array;
      }
      
      public function set name(param1:String) : void
      {
         _name = param1;
      }
      
      public function get hand_rotate() : Array
      {
         return _hand_rotate;
      }
      
      public function set_hand(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         _hand_pose[param1] = param3;
         _hand_rotate[param4][param1] = param2;
      }
      
      public function get adjustments() : Object
      {
         return _adjustments;
      }
      
      public function get simple_stack_bottom() : Array
      {
         return _simple_stack_bottom;
      }
      
      public function set float(param1:Number) : void
      {
         _float = param1;
      }
      
      public function get type() : String
      {
         return _type;
      }
      
      public function get hand_flip() : Array
      {
         return _hand_flip;
      }
      
      public function set hand_pose(param1:Array) : void
      {
         _hand_pose = param1;
      }
      
      public function set adjustments(param1:Object) : void
      {
         _adjustments = Utils.clone(param1);
      }
      
      public function get skin_stack() : Array
      {
         var _loc1_:Array = _skin_stack;
         if(_loc1_ == null)
         {
            _loc1_ = [];
         }
         return _loc1_;
      }
      
      public function save_state() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.name = name;
         _loc1_.type = type;
         _loc1_.angles = Utils.clone(angles);
         _loc1_.adjustments = Utils.clone(adjustments);
         _loc1_.skin_stack = Utils.clone(skin_stack);
         _loc1_.hand_pose = Utils.clone(hand_pose);
         _loc1_.hand_rotate = Utils.clone(hand_rotate);
         _loc1_.float = float;
         return _loc1_;
      }
      
      public function get simple_stack_top() : Array
      {
         return _simple_stack_top;
      }
      
      public function set hand_rotate(param1:Array) : void
      {
         _hand_rotate = param1;
      }
      
      public function get float() : Number
      {
         return _float;
      }
      
      public function get hand_pose() : Array
      {
         return _hand_pose;
      }
      
      public function set type(param1:String) : void
      {
         _type = param1;
      }
      
      public function get_float_adjustment(param1:uint, param2:uint, param3:uint) : Number
      {
         if(_type != PoseType.ACTION && _type != PoseType.STANCE && _type != PoseType.COMBO)
         {
            return 0;
         }
         var _loc4_:String = String(param1);
         var _loc5_:String = String(param2);
         var _loc6_:String = String(param3);
         var _loc7_:Number = 0;
         if(adjustments["rotation_" + _loc4_])
         {
            if(adjustments["rotation_" + _loc4_].hasOwnProperty("float"))
            {
               _loc7_ = _loc7_ + adjustments["rotation_" + _loc4_].float;
            }
            if(adjustments["rotation_" + _loc4_]["height_" + _loc5_])
            {
               if(adjustments["rotation_" + _loc4_]["height_" + _loc5_].hasOwnProperty("float"))
               {
                  _loc7_ = _loc7_ + adjustments["rotation_" + _loc4_]["height_" + _loc5_].float;
               }
               if(adjustments["rotation_" + _loc4_]["height_" + _loc5_]["type_" + _loc6_])
               {
                  if(adjustments["rotation_" + _loc4_]["height_" + _loc5_]["type_" + _loc6_].hasOwnProperty("float"))
                  {
                     _loc7_ = _loc7_ + adjustments["rotation_" + _loc4_]["height_" + _loc5_]["type_" + _loc6_].float;
                  }
               }
            }
         }
         if(debug)
         {
            trace("adjusted_float: " + _loc7_);
         }
         return _loc7_;
      }
      
      public function set hand_flip(param1:Array) : void
      {
         _hand_flip = param1;
      }
   }
}
