package com.bitstrips.controls
{
   import com.bitstrips.character.Container;
   import com.bitstrips.character.IBody;
   import com.bitstrips.ui.SlidePane;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class HandPane extends Sprite
   {
       
      
      private var container:Sprite;
      
      private var container_angles:Sprite;
      
      private var _handed:uint = 0;
      
      private var hand_rot:uint = 0;
      
      private var hand_frame:uint = 0;
      
      private var _body:IBody;
      
      private var hand_frames:Array;
      
      private var hand_frame_container:Container;
      
      private var hand_rots:Array;
      
      private var hand_rot_container:Container;
      
      private var sl:SlidePane;
      
      private var rectangles:Sprite;
      
      private const handScale:Number = 0.7;
      
      public var debug:Boolean = true;
      
      public function HandPane()
      {
         var _loc3_:MovieClip = null;
         super();
         this.container = new Sprite();
         this.container_angles = new Sprite();
         this.hand_frames = [];
         this.hand_rots = [];
         var _loc1_:uint = 0;
         while(_loc1_ < 10)
         {
            _loc3_ = new hand();
            this.hand_frames.push(_loc3_);
            this.container.addChild(_loc3_);
            _loc3_.gotoAndStop(_loc1_);
            _loc3_.x = _loc1_ * 45 * this.handScale;
            _loc3_.y = 23;
            _loc3_.name = String(_loc1_);
            _loc3_.scaleX = _loc3_.scaleY = this.handScale;
            if(this._handed == 0)
            {
               _loc3_.scaleX = _loc3_.scaleX * -1;
            }
            _loc1_ = _loc1_ + 1;
         }
         this.hand_frame_container = new Container(this.hand_frames);
         this.hand_frame_container.click_function = this.hand_frame_click;
         this.hand_frame_container.over_updates = false;
         this.sl = new SlidePane();
         this.sl.setSize(237,41);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc3_ = new hand();
            this.container_angles.addChild(_loc3_);
            _loc3_.gotoAndStop(_loc1_ * 10 + 1);
            this.hand_rots.push(_loc3_);
            _loc3_.x = 30 + _loc1_ * (45 * this.handScale + 27);
            _loc3_.name = String(_loc1_);
            _loc3_.scaleX = _loc3_.scaleY = this.handScale;
            if(this._handed == 0)
            {
               _loc3_.scaleX = _loc3_.scaleX * -1;
            }
            _loc1_++;
         }
         this.hand_rot_container = new Container(this.hand_rots);
         this.hand_rot_container.click_function = this.hand_rot_click;
         this.hand_rot_container.over_updates = false;
         this.rectangles = new Sprite();
         var _loc2_:Number = 44;
         this.rectangles.graphics.lineStyle(2,0);
         this.rectangles.graphics.beginFill(16777215);
         this.rectangles.graphics.drawRect(0,_loc2_,57,41);
         this.rectangles.graphics.drawRect(60,_loc2_,57,41);
         this.rectangles.graphics.drawRect(120,_loc2_,57,41);
         this.rectangles.graphics.drawRect(180,_loc2_,57,41);
         addChild(this.sl);
         addChild(this.rectangles);
         addChild(this.container_angles);
         if(this.debug)
         {
            trace("this.numChildren: " + this.numChildren);
         }
         this.container_angles.y = 67;
         this.sl.set_source(this.container);
         this.redraw_hands();
      }
      
      public function set handed(param1:uint) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         this._handed = param1;
         if(this._body)
         {
            _loc2_ = this._body.get_hand_info();
            _loc3_ = _loc2_[this._handed];
            this.hand_rot = _loc3_["rot"];
            this.hand_frame = _loc3_["frame"] - 1;
            this.sl.go_to_x(this.hand_frame * -30);
         }
         this.hand_frame_container.select(this.hand_frame);
         this.hand_rot_container.select(this.hand_rot);
         this.update_hands();
      }
      
      private function hand_frame_click(param1:String) : void
      {
         var _loc2_:uint = Math.max(0,Math.floor(Number(param1)));
         if(this.debug)
         {
            trace("Hi from: " + String(_loc2_));
         }
         trace("Hand frame click: " + _loc2_);
         if(_loc2_ != this.hand_frame)
         {
            this.hand_frame = _loc2_;
            this.update_hands();
         }
      }
      
      private function hand_rot_click(param1:String) : void
      {
         var _loc2_:uint = Math.max(0,Math.floor(Number(param1)));
         if(this.debug)
         {
            trace("Hi from: " + String(_loc2_));
         }
         trace("Hand Rot Click" + _loc2_);
         if(_loc2_ != this.hand_rot)
         {
            this.hand_rot = _loc2_;
            this.update_hands();
         }
      }
      
      private function update_hands() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         if(this._body)
         {
            _loc1_ = this._body.get_hand_info();
            _loc2_ = _loc1_[this._handed];
            if(_loc2_["rot"] != this.hand_rot || _loc2_["frame"] - 1 != this.hand_frame)
            {
               this._body.set_hand(this._handed,this.hand_rot,this.hand_frame + 1);
            }
         }
         this.redraw_hands();
      }
      
      private function redraw_hands() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = this.handScale;
         if(this._handed == 0)
         {
            _loc2_ = _loc2_ * -1;
         }
         _loc1_ = 0;
         while(_loc1_ < this.hand_frames.length)
         {
            this.hand_frames[_loc1_].gotoAndStop(_loc1_ + this.hand_rot * 10 + 1);
            this.hand_frames[_loc1_].scaleX = _loc2_;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.hand_rots.length)
         {
            this.hand_rots[_loc1_].gotoAndStop(_loc1_ * 10 + this.hand_frame + 1);
            this.hand_rots[_loc1_].scaleX = _loc2_;
            _loc1_++;
         }
      }
      
      public function set body(param1:IBody) : void
      {
         this._body = param1;
      }
   }
}
