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
      
      private var hand_rot:uint = 0;
      
      private var _body:IBody;
      
      private var hand_rot_container:Container;
      
      private var hand_rots:Array;
      
      public var debug:Boolean = true;
      
      private var sl:SlidePane;
      
      private const handScale:Number = 0.7;
      
      private var hand_frame:uint = 0;
      
      private var hand_frame_container:Container;
      
      private var rectangles:Sprite;
      
      private var _handed:uint = 0;
      
      private var hand_frames:Array;
      
      public function HandPane()
      {
         var _loc3_:MovieClip = null;
         super();
         container = new Sprite();
         container_angles = new Sprite();
         hand_frames = [];
         hand_rots = [];
         var _loc1_:uint = 0;
         while(_loc1_ < 10)
         {
            _loc3_ = new hand();
            hand_frames.push(_loc3_);
            container.addChild(_loc3_);
            _loc3_.gotoAndStop(_loc1_);
            _loc3_.x = _loc1_ * 45 * handScale;
            _loc3_.y = 23;
            _loc3_.name = String(_loc1_);
            _loc3_.scaleX = _loc3_.scaleY = handScale;
            if(_handed == 0)
            {
               _loc3_.scaleX = _loc3_.scaleX * -1;
            }
            _loc1_ = _loc1_ + 1;
         }
         hand_frame_container = new Container(hand_frames);
         hand_frame_container.click_function = hand_frame_click;
         hand_frame_container.over_updates = false;
         sl = new SlidePane();
         sl.setSize(237,41);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc3_ = new hand();
            container_angles.addChild(_loc3_);
            _loc3_.gotoAndStop(_loc1_ * 10 + 1);
            hand_rots.push(_loc3_);
            _loc3_.x = 30 + _loc1_ * (45 * handScale + 27);
            _loc3_.name = String(_loc1_);
            _loc3_.scaleX = _loc3_.scaleY = handScale;
            if(_handed == 0)
            {
               _loc3_.scaleX = _loc3_.scaleX * -1;
            }
            _loc1_++;
         }
         hand_rot_container = new Container(hand_rots);
         hand_rot_container.click_function = hand_rot_click;
         hand_rot_container.over_updates = false;
         rectangles = new Sprite();
         var _loc2_:Number = 44;
         rectangles.graphics.lineStyle(2,0);
         rectangles.graphics.beginFill(16777215);
         rectangles.graphics.drawRect(0,_loc2_,57,41);
         rectangles.graphics.drawRect(60,_loc2_,57,41);
         rectangles.graphics.drawRect(120,_loc2_,57,41);
         rectangles.graphics.drawRect(180,_loc2_,57,41);
         addChild(sl);
         addChild(rectangles);
         addChild(container_angles);
         if(debug)
         {
            trace("this.numChildren: " + this.numChildren);
         }
         container_angles.y = 67;
         sl.set_source(container);
         redraw_hands();
      }
      
      public function set body(param1:IBody) : void
      {
         _body = param1;
      }
      
      private function hand_rot_click(param1:String) : void
      {
         var _loc2_:uint = Math.max(0,Math.floor(Number(param1)));
         if(debug)
         {
            trace("Hi from: " + String(_loc2_));
         }
         trace("Hand Rot Click" + _loc2_);
         if(_loc2_ != hand_rot)
         {
            hand_rot = _loc2_;
            update_hands();
         }
      }
      
      public function set handed(param1:uint) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         _handed = param1;
         if(_body)
         {
            _loc2_ = _body.get_hand_info();
            _loc3_ = _loc2_[_handed];
            hand_rot = _loc3_["rot"];
            hand_frame = _loc3_["frame"] - 1;
            sl.go_to_x(hand_frame * -30);
         }
         hand_frame_container.select(hand_frame);
         hand_rot_container.select(hand_rot);
         update_hands();
      }
      
      private function redraw_hands() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = handScale;
         if(_handed == 0)
         {
            _loc2_ = _loc2_ * -1;
         }
         _loc1_ = 0;
         while(_loc1_ < hand_frames.length)
         {
            hand_frames[_loc1_].gotoAndStop(_loc1_ + hand_rot * 10 + 1);
            hand_frames[_loc1_].scaleX = _loc2_;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < hand_rots.length)
         {
            hand_rots[_loc1_].gotoAndStop(_loc1_ * 10 + hand_frame + 1);
            hand_rots[_loc1_].scaleX = _loc2_;
            _loc1_++;
         }
      }
      
      private function update_hands() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         if(_body)
         {
            _loc1_ = _body.get_hand_info();
            _loc2_ = _loc1_[_handed];
            if(_loc2_["rot"] != hand_rot || _loc2_["frame"] - 1 != hand_frame)
            {
               _body.set_hand(_handed,hand_rot,hand_frame + 1);
            }
         }
         redraw_hands();
      }
      
      private function hand_frame_click(param1:String) : void
      {
         var _loc2_:uint = Math.max(0,Math.floor(Number(param1)));
         if(debug)
         {
            trace("Hi from: " + String(_loc2_));
         }
         trace("Hand frame click: " + _loc2_);
         if(_loc2_ != hand_frame)
         {
            hand_frame = _loc2_;
            update_hands();
         }
      }
   }
}
