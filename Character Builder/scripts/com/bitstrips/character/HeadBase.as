package com.bitstrips.character
{
   import com.bitstrips.core.ColourData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class HeadBase extends MovieClip implements IHead
   {
       
      
      public var used_back:Boolean = false;
      
      public var head_back:Sprite;
      
      public function HeadBase()
      {
         super();
      }
      
      public function set h_rot(param1:Number) : void
      {
      }
      
      public function set mouse_look(param1:Boolean) : void
      {
      }
      
      public function remove() : void
      {
         if(this.contains(head_back))
         {
            removeChild(head_back);
         }
         head_back = null;
      }
      
      public function set_lids(param1:Array) : void
      {
      }
      
      public function set_expression_eye_L(param1:uint) : void
      {
      }
      
      public function set_expression(param1:uint) : uint
      {
         return param1;
      }
      
      public function set lids(param1:Array) : void
      {
      }
      
      public function set_expression_eye_R(param1:uint) : void
      {
      }
      
      public function get cld() : ColourData
      {
         return new ColourData();
      }
      
      public function set_expression_mouth(param1:uint) : void
      {
      }
      
      public function draw_pupils() : void
      {
      }
      
      public function get h_rot() : Number
      {
         return 0;
      }
      
      public function get lipsync() : Number
      {
         return 0;
      }
      
      public function set cld(param1:ColourData) : void
      {
      }
      
      public function look_at_mouse(param1:int = 0, param2:int = 0) : void
      {
      }
      
      public function set_rotation(param1:int) : void
      {
      }
      
      public function get_lipsync() : Number
      {
         return 0;
      }
      
      public function save_state() : Object
      {
         return new Object();
      }
      
      public function get lids() : Array
      {
         return new Array();
      }
      
      public function get_pupils() : Object
      {
         return new Object();
      }
      
      public function set_lipsync(param1:uint) : void
      {
      }
      
      public function center_point_head() : Point
      {
         return new Point();
      }
      
      public function set lipsync(param1:Number) : void
      {
      }
      
      public function set cur_expression(param1:Number) : void
      {
      }
      
      public function get cur_expression() : Number
      {
         return 0;
      }
      
      public function get mouse_look() : Boolean
      {
         return false;
      }
      
      public function update_pupils(param1:Object, param2:Object = null) : void
      {
      }
      
      public function save() : Object
      {
         return {};
      }
      
      public function load_state(param1:Object) : void
      {
      }
   }
}
