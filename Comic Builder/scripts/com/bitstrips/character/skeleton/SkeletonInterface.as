package com.bitstrips.character.skeleton
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SkeletonInterface extends Sprite
   {
       
      
      private var _skeleton:Skeleton;
      
      private var selection:Sprite;
      
      private var rect:Rectangle;
      
      public var mouse_offset:Point;
      
      public function SkeletonInterface(param1:Skeleton)
      {
         this.selection = new Sprite();
         super();
         this._skeleton = param1;
         this._skeleton.addEventListener(SkeletonEvent.CHAR_HEIGHT_CHANGE,this.height_change,false,0,true);
         this.graphics.beginFill(16711680);
         this.graphics.drawCircle(0,0,5);
         this.show_selection(false);
         this.render();
      }
      
      public function remove() : void
      {
         var _loc1_:int = numChildren - 1;
         while(_loc1_ >= 0)
         {
            removeChildAt(_loc1_);
            _loc1_--;
         }
         this._skeleton = null;
         this.selection = null;
      }
      
      public function render(param1:uint = 0, param2:uint = 0, param3:uint = 0) : void
      {
         var _loc5_:Sprite = null;
         var _loc6_:Bone = null;
         var _loc7_:uint = 0;
         _loc7_ = this.numChildren;
         while(_loc7_ > 0)
         {
            this.removeChildAt(_loc7_ - 1);
            _loc7_--;
         }
         var _loc4_:Array = this._skeleton.get_bones();
         if(Skeleton.debug)
         {
            trace("bones.length: " + _loc4_.length);
         }
         _loc7_ = 0;
         while(_loc7_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc7_];
            _loc5_ = new Sprite();
            _loc5_.graphics.beginFill(Math.random() * 16777215);
            _loc5_.graphics.drawRoundRect(-2.5,-2.5,_loc6_.length + 5,5,5);
            _loc5_.graphics.beginFill(13382604,0.5);
            _loc5_.graphics.drawCircle(0,0,5);
            _loc6_.graphic = _loc5_;
            addChild(_loc5_);
            _loc7_++;
         }
         this.update();
      }
      
      public function update() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Sprite = null;
         var _loc1_:Array = this._skeleton.get_bones();
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = Sprite(_loc1_[_loc2_].graphic);
            _loc3_.x = _loc1_[_loc2_].x;
            _loc3_.y = _loc1_[_loc2_].y;
            _loc3_.rotation = _loc1_[_loc2_].rotation;
            _loc2_++;
         }
         this.update_selection();
      }
      
      public function show_selection(param1:Boolean) : void
      {
         this.update_selection();
         this.selection.visible = param1;
      }
      
      public function update_selection() : void
      {
         this.selection.graphics.clear();
         this.selection.graphics.lineStyle(1,3381759);
         this.rect = this.getBounds(this);
         this.selection.graphics.drawRect(this.rect.x,this.rect.y,this.rect.width,this.rect.height);
         this.addChild(this.selection);
      }
      
      private function height_change(param1:Event) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:Bone = null;
         var _loc2_:Array = this._skeleton.get_bones();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc5_];
            _loc3_ = Sprite(_loc4_.graphic);
            _loc3_.graphics.clear();
            _loc3_.graphics.beginFill(Math.random() * 16777215);
            _loc3_.graphics.drawRoundRect(-2.5,-2.5,_loc4_.length + 5,5,5);
            _loc3_.graphics.beginFill(Math.random() * 16777215);
            _loc3_.graphics.drawCircle(0,0,5);
            _loc5_++;
         }
      }
   }
}
