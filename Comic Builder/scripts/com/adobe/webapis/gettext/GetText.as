package com.adobe.webapis.gettext
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.net.URLStream;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class GetText extends EventDispatcher
   {
      
      private static var translations:Object;
      
      private static var singleton:GetText;
      
      public static const iso639_languageDict:Object = {
         "aa":"Afar. ",
         "ab":"Abkhazian",
         "ae":"Avestan",
         "af":"Afrikaans",
         "am":"Amharic",
         "ar":"Arabic",
         "as":"Assamese",
         "ay":"Aymara",
         "az":"Azerbaijani",
         "ba":"Bashkir",
         "be":"Byelorussian; Belarusian",
         "bg":"Bulgarian",
         "bh":"Bihari",
         "bi":"Bislama",
         "bn":"Bengali; Bangla",
         "bo":"Tibetan",
         "br":"Breton",
         "bs":"Bosnian",
         "ca":"Catalan",
         "ce":"Chechen",
         "ch":"Chamorro",
         "co":"Corsican",
         "cs":"Czech",
         "cu":"Church Slavic",
         "cv":"Chuvash",
         "cy":"Welsh",
         "da":"Danish",
         "de":"German",
         "dz":"Dzongkha; Bhutani",
         "el":"Greek",
         "en":"English",
         "eo":"Esperanto",
         "es":"Spanish",
         "et":"Estonian",
         "eu":"Basque",
         "fa":"Persian",
         "fi":"Finnish",
         "fj":"Fijian; Fiji",
         "fo":"Faroese",
         "fr":"French",
         "fy":"Frisian",
         "ga":"Irish",
         "gd":"Scots; Gaelic",
         "gl":"Gallegan; Galician",
         "gn":"Guarani",
         "gu":"Gujarati",
         "gv":"Manx",
         "ha":"Hausa (?)",
         "he":"Hebrew (formerly iw)",
         "hi":"Hindi",
         "ho":"Hiri Motu",
         "hr":"Croatian",
         "hu":"Hungarian",
         "hy":"Armenian",
         "hz":"Herero",
         "ia":"Interlingua",
         "id":"Indonesian (formerly in)",
         "ie":"Interlingue",
         "ik":"Inupiak",
         "io":"Ido",
         "is":"Icelandic",
         "it":"Italian",
         "iu":"Inuktitut",
         "ja":"Japanese",
         "jv":"Javanese",
         "ka":"Georgian",
         "ki":"Kikuyu",
         "kj":"Kuanyama",
         "kk":"Kazakh",
         "kl":"Kalaallisut; Greenlandic",
         "km":"Khmer; Cambodian",
         "kn":"Kannada",
         "ko":"Korean",
         "ks":"Kashmiri",
         "ku":"Kurdish",
         "kv":"Komi",
         "kw":"Cornish",
         "ky":"Kirghiz",
         "la":"Latin",
         "lb":"Letzeburgesch",
         "ln":"Lingala",
         "lo":"Lao; Laotian",
         "lt":"Lithuanian",
         "lv":"Latvian; Lettish",
         "mg":"Malagasy",
         "mh":"Marshall",
         "mi":"Maori",
         "mk":"Macedonian",
         "ml":"Malayalam",
         "mn":"Mongolian",
         "mo":"Moldavian",
         "mr":"Marathi",
         "ms":"Malay",
         "mt":"Maltese",
         "my":"Burmese",
         "na":"Nauru",
         "nb":"Norwegian Bokmål",
         "nd":"Ndebele, North",
         "ne":"Nepali",
         "ng":"Ndonga",
         "nl":"Dutch",
         "nn":"Norwegian Nynorsk",
         "no":"Norwegian",
         "nr":"Ndebele, South",
         "nv":"Navajo",
         "ny":"Chichewa; Nyanja",
         "oc":"Occitan; Provençal",
         "om":"(Afan) Oromo",
         "or":"Oriya",
         "os":"Ossetian; Ossetic",
         "pa":"Panjabi; Punjabi",
         "pi":"Pali",
         "pl":"Polish",
         "ps":"Pashto, Pushto",
         "pt":"Portuguese",
         "qu":"Quechua",
         "rm":"Rhaeto-Romance",
         "rn":"Rundi; Kirundi",
         "ro":"Romanian",
         "ru":"Russian",
         "rw":"Kinyarwanda",
         "sa":"Sanskrit",
         "sc":"Sardinian",
         "sd":"Sindhi",
         "se":"Northern Sami",
         "sg":"Sango; Sangro",
         "si":"Sinhalese",
         "sk":"Slovak",
         "sl":"Slovenian",
         "sm":"Samoan",
         "sn":"Shona",
         "so":"Somali",
         "sq":"Albanian",
         "sr":"Serbian",
         "ss":"Swati; Siswati",
         "st":"Sesotho; Sotho, Southern",
         "su":"Sundanese",
         "sv":"Swedish",
         "sw":"Swahili",
         "ta":"Tamil",
         "te":"Telugu",
         "tg":"Tajik",
         "th":"Thai",
         "ti":"Tigrinya",
         "tk":"Turkmen",
         "tl":"Tagalog",
         "tn":"Tswana; Setswana",
         "to":"Tonga",
         "tr":"Turkish",
         "ts":"Tsonga",
         "tt":"Tatar",
         "tw":"Twi",
         "ty":"Tahitian",
         "ug":"Uighur",
         "uk":"Ukrainian",
         "ur":"Urdu",
         "uz":"Uzbek",
         "vi":"Vietnamese",
         "vo":"Volapük; Volapuk",
         "wa":"Walloon",
         "wo":"Wolof",
         "xh":"Xhosa",
         "yi":"Yiddish (formerly ji)",
         "yo":"Yoruba",
         "za":"Zhuang",
         "zh":"Chinese",
         "zh_tw":"Chinese Transitional",
         "zh_cn":"Chinese Simplified",
         "zu":"Zulu"
      };
       
      
      private var name:String;
      
      private var language:String;
      
      private var charset:String;
      
      private var url:String;
      
      private var info:Object;
      
      private var xstream:URLStream;
      
      public function GetText(param1:Function = null)
      {
         super();
         if(param1 != GetText.getInstance)
         {
            throw new Error("Singleton is a singleton class, use GetText.getInstance() instead");
         }
      }
      
      public static function getInstance() : GetText
      {
         if(GetText.singleton == null)
         {
            GetText.singleton = new GetText(arguments.callee);
         }
         return GetText.singleton;
      }
      
      public static function translate(param1:String) : String
      {
         var id:String = param1;
         try
         {
            if(GetText.translations.hasOwnProperty(id))
            {
               return GetText.translations[id];
            }
            throw new TypeError();
         }
         catch(e:TypeError)
         {
            return id;
         }
         return "";
      }
      
      public static function FindLanguageInfo(param1:String) : String
      {
         if(iso639_languageDict.hasOwnProperty(param1))
         {
            return iso639_languageDict[param1];
         }
         return "";
      }
      
      public final function install() : void
      {
         var _loc1_:URLRequest = new URLRequest(this.url + this.getLocale() + "/LC_MESSAGES/" + this.name + ".mo");
         this.xstream = new URLStream();
         this.xstream.addEventListener(Event.COMPLETE,this.handleEvent);
         this.xstream.addEventListener(Event.OPEN,this.handleEvent);
         this.xstream.addEventListener(ProgressEvent.PROGRESS,this.handleEvent);
         this.xstream.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.handleEvent);
         this.xstream.addEventListener(IOErrorEvent.IO_ERROR,this.handleEvent);
         this.xstream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleEvent);
         this.xstream.load(_loc1_);
      }
      
      public final function translation(param1:String, param2:String, param3:String, param4:ByteArray = null) : void
      {
         var _loc5_:Object = null;
         this.url = "locale/";
         if(param2.length > 0)
         {
            this.url = param2;
         }
         this.name = param1;
         this.language = param3;
         if(param4 != null)
         {
            param4.endian = Endian.LITTLE_ENDIAN;
            _loc5_ = Parser.parse(param4);
            GetText.translations = _loc5_.translation;
            this.info = _loc5_.info;
            this.charset = _loc5_.charset;
         }
      }
      
      public function getLocale() : String
      {
         return this.language;
      }
      
      protected function handleEvent(param1:Event) : void
      {
         var byte:ByteArray = null;
         var retObject:Object = null;
         var errEvent:ErrorEvent = null;
         var event:Event = param1;
         trace(event);
         if(event.type == Event.COMPLETE)
         {
            byte = new ByteArray();
            byte.endian = Endian.LITTLE_ENDIAN;
            event.target.readBytes(byte,0,event.target.bytesAvailable);
            try
            {
               retObject = Parser.parse(byte);
               GetText.translations = retObject.translation;
               this.info = retObject.info;
               this.charset = retObject.charset;
            }
            catch(e:Error)
            {
               errEvent = new ErrorEvent(ErrorEvent.ERROR,true,false,"EOFError: " + e.message);
               this.dispatchEvent(errEvent);
               return;
            }
         }
         var evt:Event = new Event(event.type,true,true);
         this.dispatchEvent(evt);
      }
   }
}
