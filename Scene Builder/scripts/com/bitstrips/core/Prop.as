package com.bitstrips.core
{
   public class Prop extends Artwork
   {
       
      
      public var states:uint = 0;
      
      public var pass:Function;
      
      var _state:uint = 0;
      
      public var rotations:uint = 0;
      
      public var prop_rotation:int = 0;
      
      public var cld:ColourData;
      
      public function Prop()
      {
         cld = new ColourData();
         super();
      }
      
      public function pass_colour(param1:Number) : void
      {
         pass(this.base_colour,param1);
      }
      
      public function rotate_left() : void
      {
         prop_rotation = prop_rotation + 1;
         if(prop_rotation > rotations)
         {
            prop_rotation = 0;
         }
         else if(prop_rotation < 0)
         {
            prop_rotation = rotations;
         }
         set_rotation(prop_rotation);
      }
      
      public function load_state(param1:Object) : void
      {
         if(param1.state || param1.state == 0)
         {
            state = param1.state;
         }
         if(param1.prop_rotation || param1.prop_rotation == 0)
         {
            set_rotation(param1.prop_rotation);
         }
         if(param1.hasOwnProperty("cld"))
         {
            cld.load_data(param1["cld"]);
            pass_colour(cld.get_colour("ffffff"));
         }
      }
      
      public function save_state() : Object
      {
         var _loc1_:Object = {
            "state":state,
            "prop_rotation":prop_rotation,
            "cld":cld.save_data()
         };
         return _loc1_;
      }
      
      private function new_frame() : uint
      {
         return prop_rotation + state * (rotations + 1) + 1;
      }
      
      public function set state(param1:uint) : void
      {
         param1 = Math.max(0,Math.min(states,param1));
         _state = param1;
         go_to_frame(new_frame());
      }
      
      public function init(param1:Object) : void
      {
         rotations = param1.rotations;
         states = param1.max_states;
      }
      
      public function get state() : uint
      {
         return _state;
      }
      
      public function set_rotation(param1:uint) : void
      {
         var _loc2_:uint = Math.max(0,Math.min(rotations,param1));
         prop_rotation = _loc2_;
         go_to_frame(new_frame());
      }
      
      public function set_cld(param1:ColourData) : void
      {
         cld = param1;
      }
      
      public function rotate_right() : void
      {
         prop_rotation = prop_rotation - 1;
         if(prop_rotation > rotations)
         {
            prop_rotation = 0;
         }
         else if(prop_rotation < 0)
         {
            prop_rotation = rotations;
         }
         set_rotation(prop_rotation);
      }
   }
}
