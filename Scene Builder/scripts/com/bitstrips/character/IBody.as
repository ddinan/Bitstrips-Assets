package com.bitstrips.character
{
   import com.bitstrips.character.skeleton.Skin;
   import com.bitstrips.core.ColourData;
   import flash.events.IEventDispatcher;
   
   public interface IBody extends IEventDispatcher
   {
       
      
      function set_rotation(param1:uint) : uint;
      
      function get skin() : Skin;
      
      function get breast_type() : uint;
      
      function bone_up(param1:String) : Boolean;
      
      function set mode(param1:uint) : void;
      
      function set body_height(param1:uint) : void;
      
      function get gesture() : uint;
      
      function stance_up() : void;
      
      function set sex(param1:uint) : void;
      
      function stance_right() : void;
      
      function stance_down() : void;
      
      function set gesture(param1:uint) : void;
      
      function get_hand_info() : Array;
      
      function set breast_type(param1:uint) : void;
      
      function set_breast(param1:uint) : uint;
      
      function get flipped() : Boolean;
      
      function get cld() : ColourData;
      
      function bone_down(param1:String) : Boolean;
      
      function get head() : HeadBase;
      
      function get mode() : uint;
      
      function set_height(param1:uint) : uint;
      
      function add_clothing(param1:String, param2:Boolean = false) : void;
      
      function set stance(param1:uint) : void;
      
      function set head_angle(param1:Number) : void;
      
      function simple_bone_up(param1:String) : Boolean;
      
      function remove_clothing(param1:String) : void;
      
      function get hands() : Array;
      
      function set_hand(param1:uint, param2:uint, param3:uint) : uint;
      
      function get sex() : uint;
      
      function set body_type(param1:uint) : void;
      
      function get stance() : uint;
      
      function get simple() : Boolean;
      
      function set action(param1:uint) : void;
      
      function get head_angle() : Number;
      
      function stance_left() : void;
      
      function get body_type() : uint;
      
      function toggle_control() : Boolean;
      
      function get master_rotation() : uint;
      
      function get body_height() : uint;
      
      function get action() : uint;
      
      function simple_bone_down(param1:String) : Boolean;
   }
}
