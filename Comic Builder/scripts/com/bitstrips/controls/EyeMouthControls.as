package com.bitstrips.controls
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.Container;
   import com.bitstrips.character.Features;
   import com.bitstrips.character.IHead;
   import com.bitstrips.ui.PupilControl;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   
   public class EyeMouthControls extends Sprite
   {
       
      
      private var em_ui:EyeMouthUI;
      
      private var mouths:Container;
      
      private var lids:Container;
      
      private var p1:PupilControl;
      
      private var p2:PupilControl;
      
      private var _plocked:Boolean = true;
      
      private var lidsync:Array;
      
      private var p_slide:MovieClip;
      
      private var _head:IHead;
      
      public function EyeMouthControls()
      {
         this.lidsync = [1,1];
         super();
         this.em_ui = new EyeMouthUI();
         addChild(this.em_ui);
         this.p_slide = this.em_ui.pupils.p_slider.p_slide;
         this.mouths = new Container([this.em_ui.mouths.mouth0,this.em_ui.mouths.mouth1,this.em_ui.mouths.mouth2,this.em_ui.mouths.mouth3]);
         this.lids = new Container([this.em_ui.eyelids.lid1,this.em_ui.eyelids.lid2,this.em_ui.eyelids.lid3,this.em_ui.eyelids.lid4,this.em_ui.eyelids.lid5]);
         this.mouths.over_updates = this.lids.over_updates = false;
         this.mouths.click_function = this.mouth_click;
         this.lids.click_function = this.lid_click;
         this.pupil_setup();
         this.disable();
      }
      
      private function pupil_setup() : void
      {
         this.p1 = new PupilControl(40);
         this.p2 = new PupilControl(40);
         addChild(this.p1);
         addChild(this.p2);
         this.p1.name = "p1";
         this.p2.name = "p2";
         this.p1.x = 200 - 172;
         this.p1.y = 37;
         this.p2.x = 248 - 172;
         this.p2.y = this.p1.y;
         this.em_ui.pupils.p_linked.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            p_locked = false;
         });
         this.em_ui.pupils.p_broken.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            p_locked = true;
         });
         this.p1.addEventListener("PUPIL_UPDATE",this.pupil_update);
         this.p2.addEventListener("PUPIL_UPDATE",this.pupil_update);
         this.p_slide.buttonMode = true;
         this.p_slide.addEventListener(MouseEvent.MOUSE_DOWN,this.start_slide);
         this.em_ui.pupils.p_slider.p_smaller.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            pupil_width = pupil_width - 0.1;
         });
         this.em_ui.pupils.p_slider.p_bigger.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            pupil_width = pupil_width + 0.1;
         });
         this.em_ui.pupils.p_slider.p_smaller.buttonMode = this.em_ui.pupils.p_slider.p_bigger.buttonMode = true;
         this.em_ui.pupils.p_slider.p_smaller.mouseChildren = this.em_ui.pupils.p_slider.p_bigger.mouseChildren = false;
         this.p_locked = true;
      }
      
      private function pupil_update(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(this.p_locked)
         {
            if(param1.target.name == "p1")
            {
               _loc2_ = this.p1.get_pupil();
               this.p2.set_pupil(_loc2_);
            }
            else
            {
               _loc2_ = this.p2.get_pupil();
               this.p1.set_pupil(_loc2_);
            }
            this.pupil_width = _loc2_.width;
         }
         else
         {
            this.p1.selected = false;
            this.p2.selected = false;
            if(param1.target.name == "p1")
            {
               this.p1.selected = true;
               this.pupil_width = this.p1.get_pupil().width;
            }
            else
            {
               this.p2.selected = true;
               this.pupil_width = this.p2.get_pupil().width;
            }
         }
         if(this._head)
         {
            this._head.update_pupils(this.p1.get_pupil(),this.p2.get_pupil());
            this._head.mouse_look = false;
         }
      }
      
      private function get p_locked() : Boolean
      {
         return this._plocked;
      }
      
      private function set p_locked(param1:Boolean) : void
      {
         if(param1)
         {
            trace("Locking...");
            this.em_ui.pupils.p_linked.visible = true;
            this.em_ui.pupils.p_broken.visible = false;
            if(this.p1.selected)
            {
               this.p2.set_pupil(this.p1.get_pupil());
               this.lidsync[1] = this.lidsync[0];
            }
            else
            {
               this.p1.set_pupil(this.p2.get_pupil());
               this.lidsync[0] = this.lidsync[1];
            }
            if(this._head)
            {
               this._head.update_pupils(this.p1.get_pupil(),this.p2.get_pupil());
               this._head.set_lids(this.lidsync);
            }
         }
         else
         {
            trace("Unlocking...");
            this.em_ui.pupils.p_linked.visible = false;
            this.em_ui.pupils.p_broken.visible = true;
         }
         this._plocked = param1;
      }
      
      private function disable() : void
      {
         this.transform.colorTransform = new ColorTransform(0.5,0.5,0.5);
         this.mouseEnabled = this.mouseChildren = false;
      }
      
      private function enable() : void
      {
         this.transform.colorTransform = new ColorTransform();
         this.mouseEnabled = this.mouseChildren = true;
      }
      
      public function get head() : IHead
      {
         return this._head;
      }
      
      public function set head(param1:IHead) : void
      {
         var _loc2_:Object = null;
         this._head = param1;
         if(this._head)
         {
            this.enable();
            if(this._head.features.indexOf(Features.LIPSYNC) != -1)
            {
               this.mouths.select(this._head.lipsync - 1);
               Utils.enable_shade(this.em_ui.mouths);
            }
            else
            {
               this.mouths.deselect();
               Utils.disable_shade(this.em_ui.mouths);
            }
            if(this._head.features.indexOf(Features.EYELIDS) != -1)
            {
               this.lidsync[0] = this._head.lids[0];
               this.lidsync[1] = this._head.lids[1];
               this.lids.select(this._head.lids[0] - 1);
               Utils.enable_shade(this.em_ui.eyelids);
            }
            else
            {
               this.lids.deselect();
               Utils.disable_shade(this.em_ui.eyelids);
            }
            if(this._head.features.indexOf(Features.PUPILS) != -1)
            {
               _loc2_ = this.head.get_pupils();
               this.p1.set_pupil(_loc2_[0]);
               this.p2.set_pupil(_loc2_[1]);
               this.pupil_width = _loc2_[0].width;
               if(_loc2_[0].x == _loc2_[1].x && _loc2_[0].y == _loc2_[1].y && _loc2_[0].width == _loc2_[1].width)
               {
                  this.p_locked = true;
               }
               else
               {
                  this.p_locked = false;
                  this.p1.selected = true;
               }
               Utils.enable_shade(this.em_ui.pupils);
            }
            else
            {
               Utils.disable_shade(this.em_ui.pupils);
            }
         }
         else
         {
            this.disable();
            this.mouths.deselect();
            this.lids.deselect();
         }
      }
      
      private function mouth_click(param1:String) : void
      {
         var _loc2_:Number = Number(param1.substr(5)) + 1;
         if(this._head)
         {
            this._head.set_lipsync(_loc2_);
         }
      }
      
      private function lid_click(param1:String) : void
      {
         var _loc2_:Number = Number(param1.substr(3)) * 1;
         trace("lid_click");
         if(this._head)
         {
            if(this.p_locked)
            {
               this.lidsync[0] = this.lidsync[1] = _loc2_;
            }
            else if(this.p1.selected)
            {
               this.lidsync[0] = _loc2_;
            }
            else
            {
               this.lidsync[1] = _loc2_;
            }
            this.head.set_lids(this.lidsync);
         }
      }
      
      public function get pupil_width() : Number
      {
         return (this.p_slide.x - 5) / (61 - 5);
      }
      
      public function set pupil_width(param1:Number) : void
      {
         param1 = Math.min(1,Math.max(0,param1));
         this.p_slide.x = (61 - 5) * param1 + 5;
         this.pupilSlide(new Event(""));
      }
      
      private function pupilSlide(param1:Event) : void
      {
         var _loc2_:Number = this.pupil_width;
         if(this.p_locked)
         {
            this.p1.set_pupil_width(_loc2_);
            this.p2.set_pupil_width(_loc2_);
         }
         else if(this.p1.selected)
         {
            this.p1.set_pupil_width(_loc2_);
         }
         else
         {
            this.p2.set_pupil_width(_loc2_);
         }
         if(this._head)
         {
            this._head.update_pupils(this.p1.get_pupil(),this.p2.get_pupil());
         }
      }
      
      private function start_slide(param1:Event) : void
      {
         this.p_slide.startDrag(false,new Rectangle(5,0,56,0));
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stop_slide);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.pupilSlide);
      }
      
      private function stop_slide(param1:Event) : void
      {
         this.p_slide.stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stop_slide);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.pupilSlide);
      }
   }
}
