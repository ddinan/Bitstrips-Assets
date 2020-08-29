package com.bitstrips.controls
{
   import com.bitstrips.character.IBody;
   import com.bitstrips.character.IHead;
   import flash.display.Sprite;
   
   public class CharControls extends Sprite
   {
       
      
      private var _body:IBody;
      
      private var tiltrot_c:TiltRotateControls;
      
      private var _head:IHead;
      
      private var emo_c:EmoControls;
      
      public var debug:Boolean = false;
      
      private var stance_c:StanceControls;
      
      private var pose_c:PoseControls;
      
      private var emc_c:EyeMouthControls;
      
      public function CharControls()
      {
         var _loc1_:IBody = null;
         emo_c = new EmoControls();
         emc_c = new EyeMouthControls();
         tiltrot_c = new TiltRotateControls();
         stance_c = new StanceControls();
         pose_c = new PoseControls();
         super();
         addChild(emo_c);
         addChild(emc_c);
         addChild(tiltrot_c);
         addChild(stance_c);
         addChild(pose_c);
         emc_c.x = 162;
         tiltrot_c.x = 295;
         stance_c.x = 369;
         pose_c.x = 434;
         if(_body != null)
         {
            _loc1_ = _body;
            register(_loc1_);
         }
      }
      
      public function get head() : IHead
      {
         return _head;
      }
      
      public function register(param1:IBody) : void
      {
         if(debug)
         {
            trace("CONTROLLER REGISTER: " + param1);
         }
         body = param1;
         if(param1 && param1.head)
         {
            head = param1.head;
         }
         else
         {
            head = null;
         }
      }
      
      public function set body(param1:IBody) : void
      {
         _body = param1;
         tiltrot_c.body = param1;
         stance_c.body = param1;
         pose_c.body = param1;
      }
      
      public function set head(param1:IHead) : void
      {
         _head = param1;
         emo_c.head = param1;
         emc_c.head = param1;
      }
      
      public function get body() : IBody
      {
         return _body;
      }
   }
}
