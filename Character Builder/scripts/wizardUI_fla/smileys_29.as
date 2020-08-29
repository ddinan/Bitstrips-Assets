package wizardUI_fla
{
   import com.bitstrips.character.Container;
   import com.bitstrips.character.Head;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class smileys_29 extends MovieClip
   {
       
      
      public var emo1:MovieClip;
      
      public var emo2:MovieClip;
      
      public var emo3:MovieClip;
      
      public var emo4:MovieClip;
      
      public var emo5:MovieClip;
      
      public var emo6:MovieClip;
      
      public var emo7:MovieClip;
      
      public var emo8:MovieClip;
      
      public var head2:Head;
      
      public var emos;
      
      public var lbl_txt:TextField;
      
      public var head:Head;
      
      public function smileys_29()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      function frame1() : *
      {
         emos = new Container([emo1,emo2,emo3,emo4,emo5,emo6,emo7,emo8]);
         emos.over_updates = false;
         emos.click_function = function(param1:String):*
         {
            var _loc2_:* = Number(param1.substr(3)) * 1;
            if(head)
            {
               head.set_expression(_loc2_);
            }
            if(head2)
            {
               head2.set_expression(_loc2_);
            }
         };
      }
   }
}
