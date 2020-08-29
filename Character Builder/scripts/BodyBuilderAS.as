package
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.builder.BodyBuilderUI;
   
   public class BodyBuilderAS extends BodyBuilderUI
   {
       
      
      public function BodyBuilderAS()
      {
         BSConstants.SKELETON = true;
         BSConstants.PROPS = false;
         BSConstants.BODY_BUILDER = true;
         BSConstants.DOMAIN = "bitstrips.com";
         BSConstants.CHARS_URL = "http://chars.bitstrips.com/";
         BSConstants.URL = "www." + BSConstants.DOMAIN;
         super();
      }
   }
}
