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
      
      private var edit_control_clip:MovieClip;
      
      private var bodyStateWaiting:Object;
      
      public function ComicCharAsset(param1:String)
      {
         if(debug)
         {
            trace("--ComicCharAsset()--");
         }
         edit_control_clip = new MovieClip();
         edit_control_clip.name = "control_clip";
         edit_control_clip.addEventListener(MouseEvent.MOUSE_OVER,editing_override_over,false,99,true);
         edit_control_clip.addEventListener(MouseEvent.MOUSE_OUT,editing_override_out,false,0,true);
         super();
      }
      
      private function body_setup(param1:Event = null) : void
      {
         body.scaleX = body.scaleY = BSConstants.RESCALE;
         if(debug)
         {
            trace("body.width: " + body.width);
         }
         if(artwork.numChildren > 0)
         {
            artwork.removeChildAt(0);
         }
         body.mouseChildren = false;
         body.mouseEnabled = false;
         if(bodyStateWaiting)
         {
            if(debug)
            {
               trace("loading waiting state");
            }
            body.load_state(bodyStateWaiting);
            bodyStateWaiting = null;
         }
         if(_selected && controller)
         {
            controller.register(this.body);
         }
         super.artwork.addChild(body);
         if(debug)
         {
            trace("BODY POSITION: " + this.getBounds(stage));
         }
         dispatchEvent(new Event("BodyLoaded"));
         loaded();
      }
      
      private function insert_edit_control_clip() : void
      {
         if(body.skin.contains(edit_control_clip))
         {
            body.skin.removeChild(edit_control_clip);
         }
         var _loc1_:Sprite = body.skin.get_skin_piece("control_zone").clip;
         var _loc2_:int = body.skin.getChildIndex(body.skin.get_skin_piece("control_zone").clip);
         if(debug)
         {
            trace(body.skin.getChildIndex(body.skin.get_skin_piece("bicepL").clip));
         }
         body.skin.addChildAt(edit_control_clip,_loc2_);
      }
      
      private function size_edit_control_clip() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         edit_control_clip.graphics.clear();
         edit_control_clip.graphics.beginFill(16711935,0);
         var _loc1_:Sprite = body.skin.get_skin_piece("pelvis").clip;
         if(_loc1_)
         {
            _loc2_ = _loc1_.width * 0.8;
            _loc3_ = _loc1_.height * 0.8;
            edit_control_clip.graphics.drawRect(0 - _loc2_ / 2,0 - _loc3_ / 2,_loc2_,_loc3_);
         }
         else
         {
            edit_control_clip.graphics.drawRect(-15,-10,30,20);
         }
      }
      
      override public function centerInPanel() : void
      {
         super.centerInPanel();
      }
      
      override public function remove() : void
      {
         super.remove();
         bodyStateWaiting = null;
         if(body)
         {
            body.remove();
            body = null;
         }
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
      
      private function skeleton_change_handler(param1:Event) : void
      {
         size_edit_control_clip();
      }
      
      override public function save_state() : Object
      {
         var _loc1_:Object = super.save_state();
         if(body)
         {
            _loc1_["body"] = body.save_state();
         }
         return _loc1_;
      }
      
      override public function set editing(param1:Boolean) : void
      {
         if(_editing == param1)
         {
            return;
         }
         _editing = param1;
         body.set_control(_editing);
         this.mouseChildren = _editing;
         this.buttonMode = _editing;
         container.filters = this.apply_filter();
         _editing_override = false;
         if(_editing)
         {
            insert_edit_control_clip();
            position_edit_control_clip();
            size_edit_control_clip();
            body.addEventListener("body rotate",body_rotate_handler,false,0,true);
            body.skin.addEventListener(SkeletonEvent.SKIN_RESTACK,body_rotate_handler,false,0,true);
            body.addEventListener(Event.CHANGE,skeleton_change_handler,false,0,true);
            body.addEventListener("select_skin_piece",select_skin_piece_handler);
         }
         else if(body.skin.contains(edit_control_clip))
         {
            body.skin.removeChild(edit_control_clip);
            body.removeEventListener("body rotate",body_rotate_handler);
            body.skin.addEventListener(SkeletonEvent.SKIN_RESTACK,body_rotate_handler,false,0,true);
            body.removeEventListener(Event.CHANGE,skeleton_change_handler);
            body.removeEventListener("select_skin_piece",select_skin_piece_handler);
         }
         if(_editing == false && myPanel)
         {
            myPanel.pop_back();
         }
      }
      
      private function position_edit_control_clip() : void
      {
         if(!body)
         {
            return;
         }
         var _loc1_:Point = body.get_bone("spine_2").get_position();
         edit_control_clip.x = _loc1_.x;
         edit_control_clip.y = _loc1_.y;
         edit_control_clip.rotation = body.get_bone("spine_1").internal_rotation;
      }
      
      private function body_rotate_handler(param1:Event) : void
      {
         insert_edit_control_clip();
         position_edit_control_clip();
         select_skin_piece_handler(param1);
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
         editing = true;
      }
      
      override public function load_state(param1:Object) : void
      {
         super.load_state(param1);
         if(body)
         {
            if(param1["body"])
            {
               body.load_state(param1["body"]);
            }
         }
         else
         {
            if(debug)
            {
               trace("saving state for when the body loads");
            }
            bodyStateWaiting = param1["body"];
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
      
      private function editing_override_out(param1:MouseEvent) : void
      {
         _editing_override = false;
         if(myPanel)
         {
            myPanel.pop_control();
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
         body = param2;
         if(body.loaded)
         {
            body_setup();
         }
         else
         {
            body.addEventListener(Event.COMPLETE,body_setup);
         }
      }
      
      override public function doHitTest(param1:Point) : Boolean
      {
         if(body)
         {
            return HitTester.realHitTest(body,param1);
         }
         return HitTester.realHitTest(this,param1);
      }
      
      public function getBody() : SkeletonBuddy
      {
         return body;
      }
   }
}
