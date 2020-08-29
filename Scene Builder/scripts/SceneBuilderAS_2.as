package
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.comicbuilder.SceneBuilder;
   import flash.system.Security;
   
   public class SceneBuilderAS extends SceneBuilder
   {
       
      
      public function SceneBuilderAS()
      {
         BSConstants.STICKMAN = false;
         BSConstants.PROPS = true;
         BSConstants.SKELETON = true;
         BSConstants.IMAGES = false;
         BSConstants.EDU = false;
         BSConstants.DOMAIN = "bitstrips.com";
         BSConstants.CHARS_URL = "http://chars.bitstrips.com/";
         BSConstants.NEW_ASSET_URL = "http://cassets.bitstrips.com/";
         BSConstants.URL = "www." + BSConstants.DOMAIN;
         Security.allowDomain("*");
         super();
      }
   }
}
