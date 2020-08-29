package com.bitstrips.controls
{
   import com.bitstrips.character.IBody;
   import com.bitstrips.character.IHead;
   import flash.display.Sprite;
   
   public class CharControls extends Sprite
   {
       
      
      private var _head:IHead;
      
      private var _body:IBody;
      
      private var emo_c:EmoControls;
      
      private var emc_c:EyeMouthControls;
      
      private var tiltrot_c:TiltRotateControls;
      
      private var stance_c:StanceControls;
      
      private var pose_c:PoseControls;
      
      public var debug:Boolean = false;
      
      public function CharControls()
      {
         var _loc1_:IBody = null;
         this.emo_c = new EmoControls();
         this.emc_c = new EyeMouthControls();
         this.tiltrot_c = new TiltRotateControls();
         this.stance_c = new StanceControls();
         this.pose_c = new PoseControls();
         super();
         addChild(this.emo_c);
         addChild(this.emc_c);
         addChild(this.tiltrot_c);
         addChild(this.stance_c);
         addChild(this.pose_c);
         this.emc_c.x = 162;
         this.tiltrot_c.x = 295;
         this.stance_c.x = 369;
         this.pose_c.x = 434;
         if(this._body != null)
         {
            _loc1_ = this._body;
            this.register(_loc1_);
         }
      }
      
      public function get head() : IHead
      {
         return this._head;
      }
      
      public function set head(param1:IHead) : void
      {
         this._head = param1;
         this.emo_c.head = param1;
         this.emc_c.head = param1;
         this.tiltrot_c.head = param1;
      }
      
      public function get body() : IBody
      {
         return this._body;
      }
      
      public function set body(param1:IBody) : void
      {
         this._body = param1;
         this.tiltrot_c.body = param1;
         this.stance_c.body = param1;
         this.pose_c.body = param1;
      }
      
      public function register(param1:IBody) : void
      {
         if(this.debug)
         {
            trace("CONTROLLER REGISTER: " + param1);
         }
         this.body = param1;
         if(param1 && param1.head)
         {
            this.head = param1.head;
         }
         else
         {
            this.head = null;
         }
      }
   }
}
