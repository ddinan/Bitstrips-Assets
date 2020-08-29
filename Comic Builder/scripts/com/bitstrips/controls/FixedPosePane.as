package com.bitstrips.controls
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.Container;
   import com.bitstrips.character.FixedCharacter;
   import com.bitstrips.character.IBody;
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.ui.SlidePane;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class FixedPosePane extends Sprite
   {
       
      
      private var pose_list:Array;
      
      private var container:Sprite;
      
      private var sl:SlidePane;
      
      private var _body:IBody;
      
      private var c:Container;
      
      private var _display_id:String;
      
      public var debug:Boolean = false;
      
      public function FixedPosePane()
      {
         super();
         this.container = new Sprite();
      }
      
      public function set display_id(param1:String) : void
      {
         this._display_id = param1;
         var _loc2_:ArtLoader = ArtLoader.getInstance();
         if(_loc2_.clip_loaded(this._display_id) == true)
         {
            this.display_clip(_loc2_.get_clip(this._display_id));
         }
         else
         {
            _loc2_.clip_queue(this._display_id,this.display_clip);
         }
      }
      
      private function display_clip(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc3_:uint = param1.totalFrames;
         param1.width = 45;
         var _loc4_:Number = param1.scaleX;
         var _loc7_:ArtLoader = ArtLoader.getInstance();
         this.pose_list = new Array();
         var _loc8_:uint = 0;
         while(_loc8_ < _loc3_)
         {
            _loc5_ = _loc7_.get_clip(this._display_id);
            _loc5_.gotoAndStop(_loc8_ + 1);
            this.pose_list.push(_loc5_);
            _loc5_.scaleY = _loc5_.scaleX = _loc4_;
            if(_loc8_ > 0)
            {
               Utils.stack_right(_loc5_,_loc6_);
            }
            else
            {
               _loc5_.x = 0;
            }
            _loc5_.x = _loc5_.x + (_loc5_.x - _loc5_.getBounds(this.container).x);
            _loc5_.y = 80;
            _loc5_.name = String(_loc8_);
            _loc2_ = new MovieClip();
            _loc2_.addChild(_loc5_);
            this.container.addChild(_loc2_);
            _loc6_ = _loc5_;
            _loc8_++;
         }
         this.c = new Container(this.pose_list);
         this.c.over_updates = false;
         this.c.click_function = this.container_click;
         this.sl = new SlidePane();
         this.sl.setSize(237,85);
         addChild(this.sl);
         this.sl.set_source(this.container);
      }
      
      private function container_click(param1:String) : void
      {
         var _loc2_:int = Math.floor(Number(param1));
         if(this.debug)
         {
            trace("Hi from: " + String(_loc2_));
         }
         if(this._body)
         {
            this._body.action = _loc2_ + 1;
         }
      }
      
      public function go_to_gesture(param1:uint) : void
      {
         var _loc2_:int = Math.min(Math.max(0,param1 - 3),20);
         this.sl.go_to_x(_loc2_ * 45);
         this.c.select(param1);
      }
      
      public function set body(param1:IBody) : void
      {
         this._body = param1;
         if(this._body)
         {
            if(this._body is FixedCharacter)
            {
               this.display_id = (this._body as FixedCharacter).art_clip_name;
            }
         }
      }
   }
}
