package com.bitstrips.core
{
   public class Prop extends Artwork
   {
       
      
      public var rotations:uint = 0;
      
      public var states:uint = 0;
      
      public var prop_rotation:int = 0;
      
      var _state:uint = 0;
      
      public var pass:Function;
      
      public var cld:ColourData;
      
      public function Prop()
      {
         this.cld = new ColourData();
         super();
      }
      
      public function set_cld(param1:ColourData) : void
      {
         this.cld = param1;
      }
      
      public function pass_colour(param1:Number) : void
      {
         this.pass(this.base_colour,param1);
      }
      
      public function init(param1:Object) : void
      {
         this.rotations = param1.rotations;
         this.states = param1.max_states;
      }
      
      private function new_frame() : uint
      {
         return this.prop_rotation + this.state * (this.rotations + 1) + 1;
      }
      
      public function set_rotation(param1:uint) : void
      {
         var _loc2_:uint = Math.max(0,Math.min(this.rotations,param1));
         this.prop_rotation = _loc2_;
         go_to_frame(this.new_frame());
      }
      
      public function get state() : uint
      {
         return this._state;
      }
      
      public function set state(param1:uint) : void
      {
         param1 = Math.max(0,Math.min(this.states,param1));
         this._state = param1;
         go_to_frame(this.new_frame());
      }
      
      public function rotate_left() : void
      {
         this.prop_rotation = this.prop_rotation + 1;
         if(this.prop_rotation > this.rotations)
         {
            this.prop_rotation = 0;
         }
         else if(this.prop_rotation < 0)
         {
            this.prop_rotation = this.rotations;
         }
         this.set_rotation(this.prop_rotation);
      }
      
      public function rotate_right() : void
      {
         this.prop_rotation = this.prop_rotation - 1;
         if(this.prop_rotation > this.rotations)
         {
            this.prop_rotation = 0;
         }
         else if(this.prop_rotation < 0)
         {
            this.prop_rotation = this.rotations;
         }
         this.set_rotation(this.prop_rotation);
      }
      
      public function save_state() : Object
      {
         var _loc1_:Object = {
            "state":this.state,
            "prop_rotation":this.prop_rotation,
            "cld":this.cld.save_data()
         };
         return _loc1_;
      }
      
      public function load_state(param1:Object) : void
      {
         if(param1.state || param1.state == 0)
         {
            this.state = param1.state;
         }
         if(param1.prop_rotation || param1.prop_rotation == 0)
         {
            this.set_rotation(param1.prop_rotation);
         }
         if(param1.hasOwnProperty("cld"))
         {
            this.cld.load_data(param1["cld"]);
            this.pass_colour(this.cld.get_colour("ffffff"));
         }
      }
   }
}
