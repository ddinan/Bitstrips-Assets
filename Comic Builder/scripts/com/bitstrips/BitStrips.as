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
       
      
      public var font:Class;
      
      public var fontb:Class;
      
      public var fontvb:Class;
      
      private const BS_fr:Class = BitStrips_BS_fr;
      
      public var remote:Remote;
      
      public var locale:String = "en";
      
      private var _url:String;
      
      public var code:String;
      
      public var user_id:uint;
      
      public var char_id:String;
      
      public var char_id_version:uint;
      
      public var series:Array;
      
      public var user_amfs:String;
      
      public var basic_libs_amfs:String;
      
      public var my_stuff_amfs:String;
      
      public var comic_id:String = "";
      
      public var scene_id:String = "";
      
      public var char_name:String;
      
      public var caching:Boolean = false;
      
      public var so:SharedObject;
      
      public var assign_id:String = "";
      
      public var user_name:String;
      
      public var char_loader:CharLoader;
      
      public var image_loader:ImageLoader;
      
      public var contextMenu:ContextMenu;
      
      private var wll:WordListLoader;
      
      private var _ready:Boolean = false;
      
      public function BitStrips()
      {
         this.font = BitStrips_font;
         this.fontb = BitStrips_fontb;
         this.fontvb = BitStrips_fontvb;
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
               dispatchEvent(new ErrorEvent(BulkLoader.ERROR,false,false,this._("Unable to decode pack - please contact support")));
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
               this.series = _loc3_.series;
            }
            if(_loc3_.locale)
            {
               _loc6_ = GetText.getInstance();
               this.locale = _loc3_.locale;
               if(this.locale == "fr")
               {
                  _loc7_ = new this.BS_fr() as ByteArray;
                  _loc6_.translation("BS","ignored_url","fr",_loc7_);
                  BSConstants.CREATIVEBLOCK = BSConstants.VERDANA;
               }
            }
            if(param1)
            {
               this._url = param1;
            }
            else
            {
               this._url = "file://";
            }
            if(_loc3_.pants)
            {
               this.code = _loc3_.pants;
            }
            if(_loc3_.user_id)
            {
               this.user_id = _loc3_.user_id;
            }
            else if(param2.user_id)
            {
               this.user_id = param2.user_id;
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
               this.char_id = param2.char_id;
            }
            if(param2.char_id_version != null)
            {
               this.char_id_version = param2.char_id_version;
            }
            if(param2.comic_id)
            {
               this.comic_id = param2.comic_id;
            }
            if(param2.scene_id)
            {
               this.scene_id = param2.scene_id;
            }
            if(param2.char_name)
            {
               this.char_name = param2.char_name;
            }
            if(param2.assign_id)
            {
               this.assign_id = param2.assign_id;
            }
            if(_loc3_.name)
            {
               this.user_name = _loc3_.name;
            }
            if(param2.basic_libs)
            {
               this.basic_libs_amfs = unescape(param2.basic_libs);
            }
            if(param2.my_stuff)
            {
               this.my_stuff_amfs = unescape(param2.my_stuff);
            }
            if(param2.caching)
            {
               this.caching = true;
               this.so = SharedObject.getLocal("bitstrips.BitStrips","/");
            }
            this.remote = new Remote(this._url,this.code,_loc3_.testing);
            this.remote.bs_user_id = this.user_id;
            this.remote.addEventListener(BulkLoader.ERROR,dispatchEvent);
            if(param2.PAD)
            {
               this.remote.prop_asset_dir = param2.PAD;
            }
            else
            {
               this.remote.prop_asset_dir = BSConstants.PROP_ASSET_DIR;
            }
            this.char_loader = new CharLoader(this.remote,this.caching);
            this.char_loader.addEventListener("LOADED",dispatchEvent);
            this.char_loader.addEventListener(BulkLoader.ERROR,dispatchEvent);
            this.image_loader = ImageLoader.getInstance();
            this.image_loader.addEventListener(BulkLoader.ERROR,dispatchEvent);
            this.image_loader.remote = this.remote;
            this.contextMenu = new ContextMenu();
            this.contextMenu.builtInItems["forwardAndBack"] = false;
            this.contextMenu.builtInItems["loop"] = false;
            this.contextMenu.builtInItems["play"] = false;
            this.contextMenu.builtInItems["print"] = false;
            this.contextMenu.customItems.push(new ContextMenuItem(BSConstants.VERSION,true,false));
            this._ready = true;
            return;
         }
         Remote.log_error_post("No Pack Available",{});
         dispatchEvent(new ErrorEvent(BitStrips.ERROR,false,false,this._("No pack available - please contact support")));
      }
      
      public function get ready() : Boolean
      {
         return this._ready;
      }
      
      public function spellcheck() : void
      {
         var _loc1_:String = "en_us.zlib";
         if(this.locale == "fr")
         {
            _loc1_ = "fr.zlib";
         }
         else if(this.locale == "en_CA")
         {
            _loc1_ = "en_uk.zlib";
         }
         if(this.wll != null)
         {
            return;
         }
         this.wll = new WordListLoader(new URLRequest(BSConstants.ASSET_URL + _loc1_));
         this.wll.addEventListener(Event.COMPLETE,this.wll_complete);
         SpellingHighlighter.str_add_to_dictionary = this._("Add to my dictionary");
         SpellingHighlighter.str_no_suggestions = this._("No suggestions for: %WORD%");
         SpellingHighlighter.str_remove_from_dictionary = this._("Remove from my dictionary");
         SpellingHighlighter.str_spelling_is_correct = this._("Spelling is correct");
      }
      
      private function wll_complete(param1:Event) : void
      {
         var _loc2_:SpellingDictionary = SpellingDictionary.getInstance();
         _loc2_.setMasterWordList(this.wll.data);
         _loc2_.addCustomWord("bitstrips");
         _loc2_.ignoreMixedCaps = false;
         _loc2_.useFastMode = true;
         trace("Done adding words---------------------------------------------------");
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
   }
}
