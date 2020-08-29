package com.bitstrips.controls
{
   import com.bitstrips.character.Container;
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
       
      
      private var p1:PupilControl;
      
      private var p2:PupilControl;
      
      private var mouths:Container;
      
      private var em_ui:EyeMouthUI;
      
      private var lids:Container;
      
      private var lidsync:Array;
      
      private var p_slide:MovieClip;
      
      private var _plocked:Boolean = true;
      
      private var _head:IHead;
      
      public function EyeMouthControls()
      {
         lidsync = [1,1];
         super();
         em_ui = new EyeMouthUI();
         addChild(em_ui);
         p_slide = em_ui.p_slider.p_slide;
         mouths = new Container([em_ui.mouth0,em_ui.mouth1,em_ui.mouth2,em_ui.mouth3]);
         lids = new Container([em_ui.lid1,em_ui.lid2,em_ui.lid3,em_ui.lid4,em_ui.lid5]);
         mouths.over_updates = lids.over_updates = false;
         mouths.click_function = mouth_click;
         lids.click_function = lid_click;
         pupil_setup();
         disable();
      }
      
      public function set head(param1:IHead) : void
      {
         var _loc2_:Object = null;
         _head = param1;
         if(_head)
         {
            enable();
            mouths.select(_head.lipsync - 1);
            _loc2_ = head.get_pupils();
            p1.set_pupil(_loc2_[0]);
            p2.set_pupil(_loc2_[1]);
            lidsync[0] = _head.lids[0];
            lidsync[1] = _head.lids[1];
            pupil_width = _loc2_[0].width;
            if(_loc2_[0].x == _loc2_[1].x && _loc2_[0].y == _loc2_[1].y && _loc2_[0].width == _loc2_[1].width)
            {
               p_locked = true;
            }
            else
            {
               p_locked = false;
               p1.selected = true;
            }
            lids.select(_head.lids[0] - 1);
            trace("Recording pupils");
         }
         else
         {
            disable();
            mouths.deselect();
            lids.deselect();
         }
      }
      
      private function enable() : void
      {
         this.transform.colorTransform = new ColorTransform();
         this.mouseEnabled = this.mouseChildren = true;
      }
      
      private function mouth_click(param1:String) : void
      {
         var _loc2_:Number = Number(param1.substr(5)) + 1;
         if(_head)
         {
            _head.set_lipsync(_loc2_);
         }
      }
      
      private function start_slide(param1:Event) : void
      {
         p_slide.startDrag(false,new Rectangle(5,0,56,0));
         stage.addEventListener(MouseEvent.MOUSE_UP,stop_slide);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,pupilSlide);
      }
      
      private function lid_click(param1:String) : void
      {
         var _loc2_:Number = Number(param1.substr(3)) * 1;
         trace("lid_click");
         if(_head)
         {
            if(p_locked)
            {
               lidsync[0] = lidsync[1] = _loc2_;
            }
            else if(p1.selected)
            {
               lidsync[0] = _loc2_;
            }
            else
            {
               lidsync[1] = _loc2_;
            }
            head.set_lids(lidsync);
         }
      }
      
      public function get head() : IHead
      {
         return _head;
      }
      
      private function pupilSlide(param1:Event) : void
      {
         var _loc2_:Number = pupil_width;
         if(p_locked)
         {
            p1.set_pupil_width(_loc2_);
            p2.set_pupil_width(_loc2_);
         }
         else if(p1.selected)
         {
            p1.set_pupil_width(_loc2_);
         }
         else
         {
            p2.set_pupil_width(_loc2_);
         }
         if(_head)
         {
            _head.update_pupils(p1.get_pupil(),p2.get_pupil());
         }
      }
      
      private function disable() : void
      {
         this.transform.colorTransform = new ColorTransform(0.5,0.5,0.5);
         this.mouseEnabled = this.mouseChildren = false;
      }
      
      public function set pupil_width(param1:Number) : void
      {
         param1 = Math.min(1,Math.max(0,param1));
         p_slide.x = (61 - 5) * param1 + 5;
         pupilSlide(new Event(""));
      }
      
      private function pupil_setup() : void
      {
         p1 = new PupilControl(40);
         p2 = new PupilControl(40);
         addChild(p1);
         addChild(p2);
         p1.name = "p1";
         p2.name = "p2";
         p1.x = 200 - 172;
         p1.y = 37;
         p2.x = 248 - 172;
         p2.y = p1.y;
         em_ui.p_linked.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            p_locked = false;
         });
         em_ui.p_broken.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            p_locked = true;
         });
         p1.addEventListener("PUPIL_UPDATE",pupil_update);
         p2.addEventListener("PUPIL_UPDATE",pupil_update);
         p_slide.buttonMode = true;
         p_slide.addEventListener(MouseEvent.MOUSE_DOWN,start_slide);
         em_ui.p_slider.p_smaller.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            pupil_width = pupil_width - 0.1;
         });
         em_ui.p_slider.p_bigger.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            pupil_width = pupil_width + 0.1;
         });
         em_ui.p_slider.p_smaller.buttonMode = em_ui.p_slider.p_bigger.buttonMode = true;
         em_ui.p_slider.p_smaller.mouseChildren = em_ui.p_slider.p_bigger.mouseChildren = false;
         p_locked = true;
      }
      
      private function set p_locked(param1:Boolean) : void
      {
         if(param1)
         {
            trace("Locking...");
            em_ui.p_linked.visible = true;
            em_ui.p_broken.visible = false;
            if(p1.selected)
            {
               p2.set_pupil(p1.get_pupil());
               lidsync[1] = lidsync[0];
            }
            else
            {
               p1.set_pupil(p2.get_pupil());
               lidsync[0] = lidsync[1];
            }
            if(_head)
            {
               _head.update_pupils(p1.get_pupil(),p2.get_pupil());
               _head.set_lids(lidsync);
            }
         }
         else
         {
            trace("Unlocking...");
            em_ui.p_linked.visible = false;
            em_ui.p_broken.visible = true;
         }
         _plocked = param1;
      }
      
      private function stop_slide(param1:Event) : void
      {
         p_slide.stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_UP,stop_slide);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,pupilSlide);
      }
      
      public function get pupil_width() : Number
      {
         return (p_slide.x - 5) / (61 - 5);
      }
      
      private function get p_locked() : Boolean
      {
         return _plocked;
      }
      
      private function pupil_update(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(p_locked)
         {
            if(param1.target.name == "p1")
            {
               _loc2_ = p1.get_pupil();
               p2.set_pupil(_loc2_);
            }
            else
            {
               _loc2_ = p2.get_pupil();
               p1.set_pupil(_loc2_);
            }
            pupil_width = _loc2_.width;
         }
         else
         {
            p1.selected = false;
            p2.selected = false;
            if(param1.target.name == "p1")
            {
               p1.selected = true;
               pupil_width = p1.get_pupil().width;
            }
            else
            {
               p2.selected = true;
               pupil_width = p2.get_pupil().width;
            }
         }
         if(_head)
         {
            _head.update_pupils(p1.get_pupil(),p2.get_pupil());
            _head.mouse_look = false;
         }
      }
   }
}
