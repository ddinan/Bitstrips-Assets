package
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.comicbuilder.ComicBuilder;
   import flash.system.Security;
   
   public class SuperBuilder extends ComicBuilder
   {
       
      
      public function SuperBuilder()
      {
         BSConstants.PROPS = true;
         BSConstants.SKELETON = true;
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
