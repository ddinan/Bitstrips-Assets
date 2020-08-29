package com.bitstrips.controls
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.Container;
   import com.bitstrips.character.IBody;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PoseControls extends Sprite
   {
       
      
      private var _body:IBody;
      
      private var gp:GesturePane;
      
      private var ap:ActionPane;
      
      private var hp:HandPane;
      
      private var slidebox:Container;
      
      private var ui:PoseUI;
      
      public function PoseControls()
      {
         hp = new HandPane();
         gp = new GesturePane();
         ap = new ActionPane();
         super();
         ui = new PoseUI();
         addChild(ui);
         slidebox = new Container([ui.standing_btn,ui.sitting_btn,ui.action_btn,ui.hand_l,ui.hand_r]);
         slidebox.over_updates = false;
         slidebox.select(0);
         slidebox.click_function = pose_click_function;
         ui.addChild(hp);
         hp.x = 28;
         hp.visible = false;
         ui.addChild(gp);
         gp.x = 28;
         ui.addChild(ap);
         ap.x = 28;
         this.disable();
      }
      
      private function disable() : void
      {
         Utils.disable_shade(ui);
      }
      
      private function enable() : void
      {
         Utils.enable_shade(ui);
      }
      
      public function set body(param1:IBody) : void
      {
         _body = param1;
         gp.body = _body;
         hp.body = _body;
         ap.body = _body;
         if(_body)
         {
            enable();
            body_change();
            _body.addEventListener(Event.CHANGE,body_change,false,0,true);
            _body.addEventListener("body_right_hand_click",body_right_hand_click,false,0,true);
            _body.addEventListener("body_left_hand_click",body_left_hand_click,false,0,true);
         }
         else
         {
            disable();
         }
      }
      
      private function body_left_hand_click(param1:Event) : void
      {
         pose_click_function("hand_l");
         slidebox.select(3);
      }
      
      private function body_change(param1:Event = null) : void
      {
         gp.visible = ap.visible = hp.visible = false;
         Utils.enable_shade(gp);
         if(_body.mode == 3)
         {
            gp.visible = true;
            Utils.disable_shade(gp);
            slidebox.select(null);
         }
         else if(_body.mode == 2)
         {
            slidebox.select("action_btn");
            ap.visible = true;
         }
         else if(_body.mode == 1)
         {
            slidebox.select("sitting_btn");
            gp.visible = true;
            gp.go_to_gesture(_body.gesture);
         }
         else if(_body.mode == 0)
         {
            slidebox.select("standing_btn");
            gp.visible = true;
            gp.go_to_gesture(_body.gesture);
         }
         else
         {
            trace("WHAT IS THE BODY DOING?!");
         }
      }
      
      public function get body() : IBody
      {
         return _body;
      }
      
      private function body_right_hand_click(param1:Event) : void
      {
         pose_click_function("hand_r");
         slidebox.select(4);
      }
      
      public function pose_click_function(param1:String) : void
      {
         var _loc2_:Array = null;
         gp.visible = ap.visible = hp.visible = false;
         if(param1 == "hand_l" || param1 == "hand_r")
         {
            _loc2_ = [25,13];
            if(_body)
            {
               _loc2_ = _body.hands;
            }
            hp.visible = true;
            if(param1 == "hand_l")
            {
               hp.handed = 0;
            }
            else
            {
               hp.handed = 1;
            }
         }
         else if(param1 == "action_btn")
         {
            if(_body)
            {
               _body.mode = 2;
            }
            ap.visible = true;
            ap.body = _body;
         }
         else if(param1 == "standing_btn")
         {
            if(_body)
            {
               _body.mode = 0;
            }
            gp.visible = true;
         }
         else if(param1 == "sitting_btn")
         {
            if(_body)
            {
               _body.mode = 1;
            }
            gp.visible = true;
         }
         else
         {
            trace("WTF!? " + param1);
         }
      }
   }
}
