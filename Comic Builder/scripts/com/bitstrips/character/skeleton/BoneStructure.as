package com.bitstrips.character.skeleton
{
   public class BoneStructure
   {
       
      
      private var _name:String;
      
      private var _starting_rot:Number;
      
      private var _pos_name:String;
      
      private var _position:Array;
      
      private var _bones:Array;
      
      public function BoneStructure(param1:String, param2:Number, param3:String, param4:Array = null)
      {
         super();
         this._name = param1;
         this._starting_rot = param2;
         this._pos_name = param3;
         this._bones = param4;
         if(!this._bones)
         {
            this._bones = new Array();
         }
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get pos_name() : String
      {
         return this._pos_name;
      }
      
      public function get starting_rot() : Number
      {
         return this._starting_rot;
      }
      
      public function get bones() : Array
      {
         return this._bones;
      }
      
      public function set position(param1:Array) : void
      {
         this._position = param1;
      }
      
      public function get position() : Array
      {
         return this._position;
      }
   }
}
