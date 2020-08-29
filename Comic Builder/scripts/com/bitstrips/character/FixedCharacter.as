package com.bitstrips.character
{
   import com.bitstrips.character.skeleton.Skin;
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.core.ColourData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class FixedCharacter extends Sprite implements IBody
   {
       
      
      public var art_clip_name:String;
      
      protected var clip:MovieClip;
      
      protected var _head:HeadBase;
      
      protected var _pose_frame:uint = 1;
      
      public function FixedCharacter(param1:HeadBase, param2:ArtLoader)
      {
         this.head = param1;
         super();
      }
      
      public function set_clip(param1:MovieClip) : void
      {
         this.clip = param1;
         this.clip.gotoAndStop(this.pose_frame);
         addChildAt(this.clip,0);
         this.clip.addEventListener("refresh",this.refresh);
      }
      
      public function set head(param1:HeadBase) : void
      {
         this._head = param1;
         addChild(this._head);
         if(this.clip)
         {
            this.clip.gotoAndStop(this.pose_frame);
         }
      }
      
      public function refresh(param1:Event = null) : void
      {
         var _loc2_:MovieClip = null;
         if(this._head && this.clip.headmark_mc)
         {
            _loc2_ = this.clip.headmark_mc as MovieClip;
            _loc2_.visible = false;
            this._head.rotation = _loc2_.rotation;
            this._head.x = _loc2_.x;
            this._head.y = _loc2_.y;
         }
      }
      
      public function set pose_frame(param1:uint) : void
      {
         this._pose_frame = param1;
         this.clip.gotoAndStop(this.pose_frame);
      }
      
      public function get pose_frame() : uint
      {
         return this._pose_frame;
      }
      
      public function set action(param1:uint) : void
      {
         this.pose_frame = param1;
      }
      
      public function get action() : uint
      {
         return 0;
      }
      
      public function get head() : HeadBase
      {
         return new HeadBase();
      }
      
      public function set head_angle(param1:Number) : void
      {
      }
      
      public function get head_angle() : Number
      {
         return 0;
      }
      
      public function set_rotation(param1:uint) : uint
      {
         return param1;
      }
      
      public function get master_rotation() : uint
      {
         return 0;
      }
      
      public function stance_up() : void
      {
      }
      
      public function stance_down() : void
      {
      }
      
      public function stance_left() : void
      {
      }
      
      public function stance_right() : void
      {
      }
      
      public function get stance() : uint
      {
         return 0;
      }
      
      public function set stance(param1:uint) : void
      {
      }
      
      public function get gesture() : uint
      {
         return 0;
      }
      
      public function set gesture(param1:uint) : void
      {
      }
      
      public function get_hand_info() : Array
      {
         return new Array();
      }
      
      public function set_hand(param1:uint, param2:uint, param3:uint) : uint
      {
         return 0;
      }
      
      public function set_breast(param1:uint) : uint
      {
         return 0;
      }
      
      public function set_height(param1:uint) : uint
      {
         return 0;
      }
      
      public function get mode() : uint
      {
         return 0;
      }
      
      public function set mode(param1:uint) : void
      {
      }
      
      public function get hands() : Array
      {
         return new Array();
      }
      
      public function get simple() : Boolean
      {
         return true;
      }
      
      public function add_clothing(param1:String, param2:Boolean = false) : void
      {
      }
      
      public function remove_clothing(param1:String) : void
      {
      }
      
      public function get body_height() : uint
      {
         return 0;
      }
      
      public function get body_type() : uint
      {
         return 0;
      }
      
      public function set body_height(param1:uint) : void
      {
      }
      
      public function set body_type(param1:uint) : void
      {
      }
      
      public function get breast_type() : uint
      {
         return 0;
      }
      
      public function set breast_type(param1:uint) : void
      {
      }
      
      public function get sex() : uint
      {
         return 0;
      }
      
      public function set sex(param1:uint) : void
      {
      }
      
      public function get cld() : ColourData
      {
         return new ColourData();
      }
      
      public function get flipped() : Boolean
      {
         return false;
      }
      
      public function toggle_control() : Boolean
      {
         return false;
      }
      
      public function bone_up(param1:String) : Boolean
      {
         return false;
      }
      
      public function bone_down(param1:String) : Boolean
      {
         return false;
      }
      
      public function simple_bone_up(param1:String) : Boolean
      {
         return false;
      }
      
      public function simple_bone_down(param1:String) : Boolean
      {
         return false;
      }
      
      public function get skin() : Skin
      {
         return null;
      }
      
      public function get features() : Array
      {
         return new Array();
      }
   }
}
