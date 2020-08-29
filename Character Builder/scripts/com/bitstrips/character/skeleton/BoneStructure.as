package com.bitstrips.character.skeleton
{
   public class BoneStructure
   {
       
      
      private var _position:Array;
      
      private var _name:String;
      
      private var _pos_name:String;
      
      private var _starting_rot:Number;
      
      private var _bones:Array;
      
      public function BoneStructure(param1:String, param2:Number, param3:String, param4:Array = null)
      {
         super();
         _name = param1;
         _starting_rot = param2;
         _pos_name = param3;
         _bones = param4;
         if(!_bones)
         {
            _bones = new Array();
         }
      }
      
      public function get position() : Array
      {
         return _position;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function get bones() : Array
      {
         return _bones;
      }
      
      public function set position(param1:Array) : void
      {
         _position = param1;
      }
      
      public function get pos_name() : String
      {
         return _pos_name;
      }
      
      public function get starting_rot() : Number
      {
         return _starting_rot;
      }
   }
}
