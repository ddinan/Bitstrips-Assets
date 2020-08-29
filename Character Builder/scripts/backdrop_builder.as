package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public dynamic class backdrop_builder extends MovieClip
   {
       
      
      public var timer:Timer;
      
      public var clouds:Array;
      
      public function backdrop_builder()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function make_cloud(param1:Boolean = true, param2:Number = 0) : *
      {
         var _loc3_:MovieClip = new clouddy();
         _loc3_.scaleX = _loc3_.scaleY = 1 + Math.random() * 0.5;
         if(param1)
         {
            if(param2 == 0)
            {
               _loc3_.x = Math.random() * 750 / 2 + 400;
            }
            else
            {
               _loc3_.x = Math.random() * 200;
            }
         }
         else
         {
            _loc3_.x = -_loc3_.width - 50;
         }
         _loc3_.y = Math.random() * 200;
         _loc3_.speed = 0.05 + Math.random() * 0.1;
         clouds.push(_loc3_);
         addChild(_loc3_);
      }
      
      function frame1() : *
      {
         stop();
         clouds = new Array();
         make_cloud(true,0);
         make_cloud(true,1);
         timer = new Timer(1000);
         timer.start();
         timer.addEventListener(TimerEvent.TIMER,adjust_clouds);
         trace("Adding clouds...");
      }
      
      public function adjust_clouds(param1:Event) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = new Array();
         for(_loc3_ in clouds)
         {
            clouds[_loc3_].x = clouds[_loc3_].x + clouds[_loc3_].speed;
            if(clouds[_loc3_].y > 200)
            {
               clouds[_loc3_].y = 200;
            }
            if(clouds[_loc3_].x > 850)
            {
               removeChild(clouds[_loc3_]);
               make_cloud(false);
            }
            else
            {
               _loc2_.push(clouds[_loc3_]);
            }
         }
         clouds = _loc2_;
      }
   }
}
