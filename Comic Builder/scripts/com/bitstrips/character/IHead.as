package com.bitstrips.character
{
   import flash.events.IEventDispatcher;
   
   public interface IHead extends IEventDispatcher
   {
       
      
      function update_pupils(param1:Object, param2:Object = null) : void;
      
      function set_lids(param1:Array) : void;
      
      function set_rotation(param1:int) : void;
      
      function set_expression(param1:uint) : uint;
      
      function set_lipsync(param1:uint) : void;
      
      function get_lipsync() : Number;
      
      function get_pupils() : Object;
      
      function load_state(param1:Object) : void;
      
      function save_state() : Object;
      
      function set lids(param1:Array) : void;
      
      function get lids() : Array;
      
      function set lipsync(param1:Number) : void;
      
      function get lipsync() : Number;
      
      function set mouse_look(param1:Boolean) : void;
      
      function get mouse_look() : Boolean;
      
      function set cur_expression(param1:Number) : void;
      
      function get cur_expression() : Number;
      
      function set h_rot(param1:Number) : void;
      
      function get h_rot() : Number;
      
      function get features() : Array;
   }
}
