package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class ImageUpload extends MovieClip
   {
       
      
      public var loading:thumb_loading;
      
      public var percent_txt:TextField;
      
      public function ImageUpload()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      function frame1() : *
      {
         stop();
         loading.play();
      }
   }
}
