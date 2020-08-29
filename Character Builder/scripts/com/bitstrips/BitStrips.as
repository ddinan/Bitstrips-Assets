package com.bitstrips
{
   import br.com.stimuli.loading.BulkLoader;
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.character.CharLoader;
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.core.ImageLoader;
   import com.bitstrips.core.Remote;
   import com.gskinner.spelling.SpellingDictionary;
   import com.gskinner.spelling.SpellingHighlighter;
   import com.gskinner.spelling.WordListLoader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.text.Font;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.ByteArray;
   
   public class BitStrips extends EventDispatcher
   {
      
      public static const ERROR:String = BulkLoader.ERROR;
       
      
      public var series:Array;
      
      public var fonti:Class;
      
      public var comic_id:String = "";
      
      public var user_id:uint;
      
      public var char_loader:CharLoader;
      
      public var char_id:String;
      
      private var _ready:Boolean = false;
      
      public var scene_id:String = "";
      
      private var _url:String;
      
      private var wll:WordListLoader;
      
      public var basic_libs_amfs:String;
      
      public var fontvb:Class;
      
      public var char_id_version:uint;
      
      public var caching:Boolean = false;
      
      public var remote:Remote;
      
      public var font:Class;
      
      public var contextMenu:ContextMenu;
      
      public var char_name:String;
      
      public var fontbi:Class;
      
      public var my_stuff_amfs:String;
      
      public var locale:String = "en";
      
      public var so:SharedObject;
      
      public var assign_id:String = "";
      
      public var user_amfs:String;
      
      public var fontb:Class;
      
      public var image_loader:ImageLoader;
      
      private const BS_fr:Class = BitStrips_BS_fr;
      
      public var code:String;
      
      public var user_name:String;
      
      public function BitStrips()
      {
         font = BitStrips_font;
         fontb = BitStrips_fontb;
         fonti = BitStrips_fonti;
         fontbi = BitStrips_fontbi;
         fontvb = BitStrips_fontvb;
         super();
         var _loc1_:Array = Font.enumerateFonts(false);
         if(BSConstants.EDU)
         {
            BSConstants.CREATIVEBLOCK = BSConstants.VERDANA;
         }
      }
      
      public function init(param1:String, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = null;
         var _loc5_:Object = null;
         var _loc6_:GetText = null;
         var _loc7_:ByteArray = null;
         if(param2.pack)
         {
            _loc3_ = Utils.amfs2object(unescape(param2.pack));
            if(_loc3_ == null)
            {
               dispatchEvent(new ErrorEvent(BulkLoader.ERROR,false,false,_("Unable to decode pack - please contact support")));
            }
            else if(_loc3_.art)
            {
               for(_loc4_ in _loc3_.art)
               {
                  _loc5_ = _loc3_.art[_loc4_];
                  if(_loc5_["base"])
                  {
                     ArtLoader.base_colour[_loc4_] = _loc5_["base"];
                  }
                  if(_loc5_["v"])
                  {
                     if(ArtLoader.swf_urls[_loc4_])
                     {
                        if(ArtLoader.swf_urls[_loc4_] < _loc5_["v"])
                        {
                           ArtLoader.swf_urls[_loc4_] = _loc5_["v"];
                        }
                     }
                     else
                     {
                        ArtLoader.swf_urls[_loc4_] = _loc5_["v"];
                     }
                  }
               }
            }
            if(_loc3_.series)
            {
               series = _loc3_.series;
            }
            if(_loc3_.locale)
            {
               _loc6_ = GetText.getInstance();
               locale = _loc3_.locale;
               if(locale == "fr")
               {
                  _loc7_ = new BS_fr() as ByteArray;
                  _loc6_.translation("BS","ignored_url","fr",_loc7_);
                  BSConstants.CREATIVEBLOCK = BSConstants.VERDANA;
               }
            }
            if(param1)
            {
               _url = param1;
            }
            else
            {
               _url = "file://";
            }
            if(_loc3_.pants)
            {
               code = _loc3_.pants;
            }
            if(_loc3_.user_id)
            {
               user_id = _loc3_.user_id;
            }
            else if(param2.user_id)
            {
               user_id = param2.user_id;
            }
            if(_loc3_.student)
            {
               BSConstants.KID_MODE = true;
            }
            if(_loc3_.flickr && _loc3_.flickr == 1)
            {
               BSConstants.FLICKR = true;
            }
            if(_loc3_.image_upload && _loc3_.image_upload == 1)
            {
               BSConstants.IMAGE_UPLOAD = true;
            }
            BSConstants.IMAGES = BSConstants.FLICKR || BSConstants.IMAGE_UPLOAD;
            if(_loc3_.shared_images && _loc3_.shared_images == 1)
            {
               BSConstants.IMAGES = true;
            }
            if(param2.char_id != null)
            {
               char_id = param2.char_id;
            }
            if(param2.char_id_version != null)
            {
               char_id_version = param2.char_id_version;
            }
            if(param2.comic_id)
            {
               comic_id = param2.comic_id;
            }
            if(param2.scene_id)
            {
               scene_id = param2.scene_id;
            }
            if(param2.char_name)
            {
               char_name = param2.char_name;
            }
            if(param2.assign_id)
            {
               assign_id = param2.assign_id;
            }
            if(_loc3_.name)
            {
               user_name = _loc3_.name;
            }
            if(param2.basic_libs)
            {
               basic_libs_amfs = unescape(param2.basic_libs);
            }
            if(param2.my_stuff)
            {
               my_stuff_amfs = unescape(param2.my_stuff);
            }
            if(param2.caching)
            {
               caching = true;
               so = SharedObject.getLocal("bitstrips.BitStrips","/");
            }
            remote = new Remote(_url,code,_loc3_.testing);
            remote.bs_user_id = this.user_id;
            remote.addEventListener(BulkLoader.ERROR,dispatchEvent);
            if(param2.PAD)
            {
               remote.prop_asset_dir = param2.PAD;
            }
            else
            {
               remote.prop_asset_dir = BSConstants.PROP_ASSET_DIR;
            }
            char_loader = new CharLoader(remote,caching);
            char_loader.addEventListener("LOADED",dispatchEvent);
            char_loader.addEventListener(BulkLoader.ERROR,dispatchEvent);
            image_loader = ImageLoader.getInstance();
            image_loader.addEventListener(BulkLoader.ERROR,dispatchEvent);
            image_loader.remote = remote;
            contextMenu = new ContextMenu();
            contextMenu.builtInItems["forwardAndBack"] = false;
            contextMenu.builtInItems["loop"] = false;
            contextMenu.builtInItems["play"] = false;
            contextMenu.builtInItems["print"] = false;
            contextMenu.customItems.push(new ContextMenuItem(BSConstants.VERSION,true,false));
            _ready = true;
            return;
         }
         Remote.log_error_post("No Pack Available",{});
         dispatchEvent(new ErrorEvent(BitStrips.ERROR,false,false,_("No pack available - please contact support")));
      }
      
      public function get ready() : Boolean
      {
         return _ready;
      }
      
      private function wll_complete(param1:Event) : void
      {
         var _loc2_:SpellingDictionary = SpellingDictionary.getInstance();
         _loc2_.setMasterWordList(wll.data);
         _loc2_.addCustomWord("bitstrips");
         _loc2_.ignoreMixedCaps = false;
         _loc2_.useFastMode = true;
         trace("Done adding words---------------------------------------------------");
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      public function spellcheck() : void
      {
         var _loc1_:String = "en_us.zlib";
         if(locale == "fr")
         {
            _loc1_ = "fr.zlib";
         }
         else if(locale == "en_CA")
         {
            _loc1_ = "en_uk.zlib";
         }
         if(wll != null)
         {
            return;
         }
         wll = new WordListLoader(new URLRequest(BSConstants.ASSET_URL + _loc1_));
         wll.addEventListener(Event.COMPLETE,wll_complete);
         SpellingHighlighter.str_add_to_dictionary = _("Add to my dictionary");
         SpellingHighlighter.str_no_suggestions = _("No suggestions for: %WORD%");
         SpellingHighlighter.str_remove_from_dictionary = _("Remove from my dictionary");
         SpellingHighlighter.str_spelling_is_correct = _("Spelling is correct");
      }
   }
}
