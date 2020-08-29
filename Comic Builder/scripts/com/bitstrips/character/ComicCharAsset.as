package com.bitstrips.character
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.character.skeleton.SkeletonBuddy;
   import com.bitstrips.character.skeleton.SkeletonEvent;
   import com.bitstrips.comicbuilder.ComicAsset;
   import com.bitstrips.controls.ComicControl;
   import com.bitstrips.core.HitTester;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ComicCharAsset extends ComicAsset
   {
       
      
      public var body:SkeletonBuddy;
      
      private var bodyStateWaiting:Object;
      
      private var edit_control_clip:MovieClip;
      
      public function ComicCharAsset(param1:String)
      {
         if(debug)
         {
            trace("--ComicCharAsset()--");
         }
         this.edit_control_clip = new MovieClip();
         this.edit_control_clip.name = "control_clip";
         this.edit_control_clip.addEventListener(MouseEvent.MOUSE_OVER,this.editing_override_over,false,99,true);
         this.edit_control_clip.addEventListener(MouseEvent.MOUSE_OUT,this.editing_override_out,false,0,true);
         super();
      }
      
      override public function remove() : void
      {
         super.remove();
         this.bodyStateWaiting = null;
         if(this.body)
         {
            this.body.remove();
            this.body = null;
         }
      }
      
      public function loaded_body(param1:Number, param2:SkeletonBuddy) : void
      {
         if(debug)
         {
            trace("--ComicCharAsset.loaded(" + this.width + ")--");
         }
         if(debug)
         {
            trace("BODY POSITION: " + this.getBounds(stage));
         }
         if(debug)
         {
            trace("BODY stage: " + param2.getBounds(stage));
         }
         if(debug)
         {
            trace("BODY self : " + param2.getBounds(param2));
         }
         super.originalWidth = this.width;
         this.body = param2;
         if(this.body.loaded)
         {
            this.body_setup();
         }
         else
         {
            this.body.addEventListener(Event.COMPLETE,this.body_setup);
         }
      }
      
      private function body_setup(param1:Event = null) : void
      {
         this.body.scaleX = this.body.scaleY = BSConstants.RESCALE;
         if(debug)
         {
            trace("body.width: " + this.body.width);
         }
         if(artwork.numChildren > 0)
         {
            artwork.removeChildAt(0);
         }
         this.body.mouseChildren = false;
         this.body.mouseEnabled = false;
         if(this.bodyStateWaiting)
         {
            if(debug)
            {
               trace("loading waiting state");
            }
            this.body.load_state(this.bodyStateWaiting);
            this.bodyStateWaiting = null;
         }
         if(_selected && controller)
         {
            controller.register(this.body);
         }
         super.artwork.addChild(this.body);
         if(debug)
         {
            trace("BODY POSITION: " + this.getBounds(stage));
         }
         dispatchEvent(new Event("BodyLoaded"));
         loaded();
      }
      
      override public function load_state(param1:Object) : void
      {
         super.load_state(param1);
         if(this.body)
         {
            if(param1["body"])
            {
               this.body.load_state(param1["body"]);
            }
         }
         else
         {
            if(debug)
            {
               trace("saving state for when the body loads");
            }
            this.bodyStateWaiting = param1["body"];
         }
      }
      
      override public function save_state() : Object
      {
         var _loc1_:Object = super.save_state();
         if(this.body)
         {
            _loc1_["body"] = this.body.save_state();
         }
         return _loc1_;
      }
      
      override public function centerInPanel() : void
      {
         super.centerInPanel();
      }
      
      override public function doubleClick(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--ComicCharAsset.doubleClick()--");
         }
         param1.stopImmediatePropagation();
         if(myPanel)
         {
            super.myPanel.getComic().getComicBuilder().focusTab("instance");
            myPanel.pop_to_top(this);
         }
         this.editing = true;
      }
      
      override public function set editing(param1:Boolean) : void
      {
         if(_editing == param1)
         {
            return;
         }
         _editing = param1;
         this.body.set_control(_editing);
         this.mouseChildren = _editing;
         this.buttonMode = _editing;
         container.filters = this.apply_filter();
         _editing_override = false;
         if(_editing)
         {
            this.insert_edit_control_clip();
            this.position_edit_control_clip();
            this.size_edit_control_clip();
            this.body.addEventListener("body rotate",this.body_rotate_handler,false,0,true);
            this.body.skin.addEventListener(SkeletonEvent.SKIN_RESTACK,this.body_rotate_handler,false,0,true);
            this.body.addEventListener(Event.CHANGE,this.skeleton_change_handler,false,0,true);
            this.body.addEventListener("select_skin_piece",this.select_skin_piece_handler);
         }
         else if(this.body.skin.contains(this.edit_control_clip))
         {
            this.body.skin.removeChild(this.edit_control_clip);
            this.body.removeEventListener("body rotate",this.body_rotate_handler);
            this.body.skin.addEventListener(SkeletonEvent.SKIN_RESTACK,this.body_rotate_handler,false,0,true);
            this.body.removeEventListener(Event.CHANGE,this.skeleton_change_handler);
            this.body.removeEventListener("select_skin_piece",this.select_skin_piece_handler);
         }
         if(_editing == false && myPanel)
         {
            myPanel.pop_back();
         }
      }
      
      private function body_rotate_handler(param1:Event) : void
      {
         this.insert_edit_control_clip();
         this.position_edit_control_clip();
         this.select_skin_piece_handler(param1);
      }
      
      private function skeleton_change_handler(param1:Event) : void
      {
         this.size_edit_control_clip();
      }
      
      private function insert_edit_control_clip() : void
      {
         if(this.body.skin.contains(this.edit_control_clip))
         {
            this.body.skin.removeChild(this.edit_control_clip);
         }
         var _loc1_:Sprite = this.body.skin.get_skin_piece("control_zone").clip;
         var _loc2_:int = this.body.skin.getChildIndex(this.body.skin.get_skin_piece("control_zone").clip);
         if(debug)
         {
            trace(this.body.skin.getChildIndex(this.body.skin.get_skin_piece("bicepL").clip));
         }
         this.body.skin.addChildAt(this.edit_control_clip,_loc2_);
      }
      
      private function position_edit_control_clip() : void
      {
         if(!this.body)
         {
            return;
         }
         var _loc1_:Point = this.body.get_bone("spine_2").get_position();
         this.edit_control_clip.x = _loc1_.x;
         this.edit_control_clip.y = _loc1_.y;
         this.edit_control_clip.rotation = this.body.get_bone("spine_1").internal_rotation;
      }
      
      private function size_edit_control_clip() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         this.edit_control_clip.graphics.clear();
         this.edit_control_clip.graphics.beginFill(16711935,0);
         var _loc1_:Sprite = this.body.skin.get_skin_piece("pelvis").clip;
         if(_loc1_)
         {
            _loc2_ = _loc1_.width * 0.8;
            _loc3_ = _loc1_.height * 0.8;
            this.edit_control_clip.graphics.drawRect(0 - _loc2_ / 2,0 - _loc3_ / 2,_loc2_,_loc3_);
         }
         else
         {
            this.edit_control_clip.graphics.drawRect(-15,-10,30,20);
         }
      }
      
      private function editing_override_out(param1:MouseEvent) : void
      {
         _editing_override = false;
         if(myPanel)
         {
            myPanel.pop_control();
         }
      }
      
      private function editing_override_over(param1:MouseEvent) : void
      {
         _editing_override = true;
         if(myPanel)
         {
            myPanel.pop_control();
         }
      }
      
      override public function doHitTest(param1:Point) : Boolean
      {
         if(this.body)
         {
            return HitTester.realHitTest(this.body,param1);
         }
         return HitTester.realHitTest(this,param1);
      }
      
      public function getBody() : SkeletonBuddy
      {
         return this.body;
      }
      
      private function select_skin_piece_handler(param1:Event) : void
      {
         var _loc2_:ComicControl = null;
         if(myPanel)
         {
            _loc2_ = myPanel.myComic.getComicBuilder().getComic_controls();
            if(_loc2_)
            {
               _loc2_.update_stacking();
            }
         }
      }
   }
}
