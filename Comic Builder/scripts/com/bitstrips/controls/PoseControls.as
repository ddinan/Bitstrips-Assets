package com.bitstrips.controls
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.Container;
   import com.bitstrips.character.Features;
   import com.bitstrips.character.FixedCharacter;
   import com.bitstrips.character.IBody;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PoseControls extends Sprite
   {
       
      
      private var ui:PoseUI;
      
      private var _body:IBody;
      
      private var slidebox:Container;
      
      private var hp:HandPane;
      
      private var gp:GesturePane;
      
      private var ap:ActionPane;
      
      private var fp:FixedPosePane;
      
      public function PoseControls()
      {
         this.hp = new HandPane();
         this.gp = new GesturePane();
         this.ap = new ActionPane();
         this.fp = new FixedPosePane();
         super();
         this.ui = new PoseUI();
         addChild(this.ui);
         this.slidebox = new Container([this.ui.standing_btn,this.ui.sitting_btn,this.ui.action_btn,this.ui.hand_l,this.ui.hand_r]);
         this.slidebox.over_updates = false;
         this.slidebox.select(0);
         this.slidebox.click_function = this.pose_click_function;
         this.ui.addChild(this.hp);
         this.hp.x = 28;
         this.hp.visible = false;
         this.ui.addChild(this.gp);
         this.gp.x = 28;
         this.ui.addChild(this.ap);
         this.ap.x = 28;
         this.ui.addChild(this.fp);
         this.fp.x = 28;
         this.fp.visible = false;
         this.disable();
      }
      
      public function pose_click_function(param1:String) : void
      {
         var _loc2_:Array = null;
         this.gp.visible = this.ap.visible = this.hp.visible = false;
         if(param1 == "hand_l" || param1 == "hand_r")
         {
            _loc2_ = [25,13];
            if(this._body)
            {
               _loc2_ = this._body.hands;
            }
            this.hp.visible = true;
            if(param1 == "hand_l")
            {
               this.hp.handed = 0;
            }
            else
            {
               this.hp.handed = 1;
            }
         }
         else if(param1 == "action_btn")
         {
            if(this._body)
            {
               this._body.mode = 2;
            }
            this.ap.visible = true;
            this.ap.body = this._body;
         }
         else if(param1 == "standing_btn")
         {
            if(this._body)
            {
               this._body.mode = 0;
            }
            this.gp.visible = true;
         }
         else if(param1 == "sitting_btn")
         {
            if(this._body)
            {
               this._body.mode = 1;
            }
            this.gp.visible = true;
         }
         else
         {
            trace("WTF!? " + param1);
         }
      }
      
      public function get body() : IBody
      {
         return this._body;
      }
      
      public function set body(param1:IBody) : void
      {
         this._body = param1;
         this.gp.body = this._body;
         this.hp.body = this._body;
         this.ap.body = this._body;
         this.fp.body = this._body;
         if(this._body)
         {
            this.enable();
            this.body_change();
            this._body.addEventListener(Event.CHANGE,this.body_change,false,0,true);
            this._body.addEventListener("body_right_hand_click",this.body_right_hand_click,false,0,true);
            this._body.addEventListener("body_left_hand_click",this.body_left_hand_click,false,0,true);
         }
         else
         {
            this.disable();
         }
         if(this._body == null || this._body.features.indexOf(Features.POSE_LIBRARY) == -1)
         {
         }
         if(this._body == null || this._body.features.indexOf(Features.POSE_TYPE) == -1)
         {
            Utils.disable_shade(this.ui.standing_btn);
            Utils.disable_shade(this.ui.sitting_btn);
            Utils.disable_shade(this.ui.action_btn);
         }
         else
         {
            Utils.enable_shade(this.ui.standing_btn);
            Utils.enable_shade(this.ui.sitting_btn);
            Utils.enable_shade(this.ui.action_btn);
         }
         if(this._body == null || this._body.features.indexOf(Features.HAND_POSES) == -1)
         {
            Utils.disable_shade(this.ui.hand_l);
            Utils.disable_shade(this.ui.hand_r);
         }
         else
         {
            Utils.enable_shade(this.ui.hand_l);
            Utils.enable_shade(this.ui.hand_r);
         }
         if(this._body && this._body is FixedCharacter)
         {
            this.fp.visible = true;
         }
         else
         {
            this.fp.visible = false;
         }
      }
      
      private function body_change(param1:Event = null) : void
      {
         this.gp.visible = this.ap.visible = this.hp.visible = false;
         Utils.enable_shade(this.gp);
         if(this._body.mode == 3)
         {
            this.gp.visible = true;
            Utils.disable_shade(this.gp);
            this.slidebox.select(null);
         }
         else if(this._body.mode == 2)
         {
            this.slidebox.select("action_btn");
            this.ap.visible = true;
         }
         else if(this._body.mode == 1)
         {
            this.slidebox.select("sitting_btn");
            this.gp.visible = true;
            this.gp.go_to_gesture(this._body.gesture);
         }
         else if(this._body.mode == 0)
         {
            this.slidebox.select("standing_btn");
            this.gp.visible = true;
            this.gp.go_to_gesture(this._body.gesture);
         }
         else
         {
            trace("WHAT IS THE BODY DOING?!");
         }
      }
      
      private function disable() : void
      {
         Utils.disable_shade(this.ui);
      }
      
      private function enable() : void
      {
         Utils.enable_shade(this.ui);
      }
      
      private function body_right_hand_click(param1:Event) : void
      {
         this.pose_click_function("hand_r");
         this.slidebox.select(4);
      }
      
      private function body_left_hand_click(param1:Event) : void
      {
         this.pose_click_function("hand_l");
         this.slidebox.select(3);
      }
   }
}
