package
{
   import com.bitstrips.ui.GradientBox2;
   
   public dynamic class GradientBox extends GradientBox2
   {
       
      
      public function GradientBox()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      function frame1() : *
      {
         stop();
      }
   }
}
