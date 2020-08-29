package com.bitstrips.character
{
   import com.bitstrips.character.skeleton.Skin;
   import com.bitstrips.core.ColourData;
   import flash.events.IEventDispatcher;
   
   public interface IBody extends IEventDispatcher
   {
       
      
      function get head() : HeadBase;
      
      function set head_angle(param1:Number) : void;
      
      function get head_angle() : Number;
      
      function set_rotation(param1:uint) : uint;
      
      function get master_rotation() : uint;
      
      function stance_up() : void;
      
      function stance_down() : void;
      
      function stance_left() : void;
      
      function stance_right() : void;
      
      function get stance() : uint;
      
      function set stance(param1:uint) : void;
      
      function get gesture() : uint;
      
      function set gesture(param1:uint) : void;
      
      function get_hand_info() : Array;
      
      function set_hand(param1:uint, param2:uint, param3:uint) : uint;
      
      function set_breast(param1:uint) : uint;
      
      function set_height(param1:uint) : uint;
      
      function get mode() : uint;
      
      function set mode(param1:uint) : void;
      
      function set action(param1:uint) : void;
      
      function get action() : uint;
      
      function get hands() : Array;
      
      function get simple() : Boolean;
      
      function add_clothing(param1:String, param2:Boolean = false) : void;
      
      function remove_clothing(param1:String) : void;
      
      function get body_height() : uint;
      
      function get body_type() : uint;
      
      function set body_height(param1:uint) : void;
      
      function set body_type(param1:uint) : void;
      
      function get breast_type() : uint;
      
      function set breast_type(param1:uint) : void;
      
      function get sex() : uint;
      
      function set sex(param1:uint) : void;
      
      function get cld() : ColourData;
      
      function get flipped() : Boolean;
      
      function toggle_control() : Boolean;
      
      function bone_up(param1:String) : Boolean;
      
      function bone_down(param1:String) : Boolean;
      
      function simple_bone_up(param1:String) : Boolean;
      
      function simple_bone_down(param1:String) : Boolean;
      
      function get skin() : Skin;
      
      function get features() : Array;
   }
}
