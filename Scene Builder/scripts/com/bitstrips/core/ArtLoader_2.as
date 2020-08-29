package com.bitstrips.core
{
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.loadingtypes.LoadingItem;
   import com.bitstrips.BSConstants;
   import com.bitstrips.character.skeleton.Skeleton;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public final class ArtLoader extends EventDispatcher
   {
      
      public static const clothing_categories:Object = {
         "shirts":[{
            "pieces":["shirt01"],
            "rank":"0",
            "thumb":"thumb_shirt01"
         },{
            "pieces":["shirt02"],
            "rank":"1",
            "thumb":"thumb_shirt02"
         },{
            "pieces":["shirt03"],
            "rank":"2",
            "thumb":"thumb_shirt03"
         },{
            "pieces":["shirt04"],
            "rank":"3",
            "thumb":"thumb_shirt04"
         },{
            "pieces":["shirt05"],
            "rank":"4",
            "thumb":"thumb_shirt05"
         },{
            "pieces":["shirt06"],
            "rank":"5",
            "thumb":"thumb_shirt06"
         },{
            "pieces":["shirt07"],
            "rank":"6",
            "thumb":"thumb_shirt07"
         },{
            "pieces":["shirt08"],
            "rank":"7",
            "thumb":"thumb_shirt08"
         },{
            "pieces":["shirt09"],
            "rank":"8",
            "thumb":"thumb_shirt09"
         }],
         "pants":[{
            "pieces":["pants01"],
            "rank":"1",
            "thumb":"thumb_pants01"
         },{
            "pieces":["pants02"],
            "rank":"2",
            "thumb":"thumb_pants02"
         },{
            "pieces":["pants03"],
            "rank":"3",
            "thumb":"thumb_pants03"
         },{
            "pieces":["pants04"],
            "rank":"4",
            "thumb":"thumb_pants04"
         },{
            "pieces":["pants05"],
            "rank":"5",
            "thumb":"thumb_pants05"
         },{
            "pieces":["pants06"],
            "rank":"6",
            "thumb":"thumb_pants06"
         }],
         "socks":[{
            "pieces":["bare"],
            "rank":"0",
            "thumb":"thumb_bare"
         },{
            "pieces":["sock01"],
            "rank":"1",
            "thumb":"thumb_sock01"
         },{
            "pieces":["sock02"],
            "rank":"2",
            "thumb":"thumb_sock02"
         }],
         "shoes":[{
            "pieces":["bare"],
            "rank":"0",
            "thumb":"thumb_bare"
         },{
            "pieces":["shoe01"],
            "rank":"1",
            "thumb":"thumb_shoe01"
         },{
            "pieces":["shoe02"],
            "rank":"2",
            "thumb":"thumb_shoe02"
         },{
            "pieces":["shoe03"],
            "rank":"3",
            "thumb":"thumb_shoe03"
         },{
            "pieces":["shoe04"],
            "rank":"5",
            "thumb":"thumb_shoe04"
         },{
            "pieces":["shoe05"],
            "rank":"6",
            "thumb":"thumb_shoe05"
         }],
         "jackets":[{
            "pieces":["bare"],
            "rank":"0",
            "thumb":"thumb_bare"
         },{
            "pieces":["jacket01"],
            "rank":"1",
            "thumb":"thumb_jacket01"
         },{
            "pieces":["jacket02"],
            "rank":"2",
            "thumb":"thumb_jacket02"
         }],
         "skirts":[{
            "pieces":["bare"],
            "rank":"0",
            "thumb":"thumb_bare"
         },{
            "pieces":["skirt02"],
            "rank":"1",
            "thumb":"thumb_skirt02"
         }],
         "gloves":[{
            "pieces":["bare"],
            "rank":"0",
            "thumb":"thumb_bare"
         },{
            "pieces":["glove01"],
            "rank":"1",
            "thumb":"thumb_glove01"
         },{
            "pieces":["glove02"],
            "rank":"2",
            "thumb":"thumb_glove02"
         }],
         "jewels":[{
            "pieces":["necklace01"],
            "rank":"1",
            "thumb":"thumb_necklace01"
         },{
            "pieces":["scarf01"],
            "rank":"3",
            "thumb":"thumb_scarf01"
         }],
         "ties":[{
            "pieces":["bare"],
            "rank":"1",
            "thumb":"thumb_bare"
         },{
            "pieces":["tie01"],
            "rank":"2",
            "thumb":"thumb_tie01"
         }],
         "backthings":[{
            "pieces":["bare"],
            "rank":"1",
            "thumb":"thumb_bare"
         },{
            "pieces":["strap01"],
            "rank":"2",
            "thumb":"thumb_strap01"
         }],
         "belts":[{
            "pieces":["bare"],
            "rank":"1",
            "thumb":"thumb_bare"
         },{
            "pieces":["waist01"],
            "rank":"2",
            "thumb":"thumb_waist01"
         }],
         "sweaters":[{
            "pieces":["bare"],
            "rank":"1",
            "thumb":"thumb_bare"
         },{
            "pieces":["sweater01"],
            "rank":"2",
            "thumb":"thumb_sweater01"
         }]
      };
      
      public static var swf_urls:Object = {
         "bare":2,
         "glove01":3,
         "glove02":2,
         "jacket01":2,
         "jacket02":4,
         "necklace00":2,
         "necklace01":2,
         "pants01":2,
         "pants02":2,
         "pants03":2,
         "pants04":2,
         "pants05":2,
         "pants06":2,
         "scarf01":2,
         "shirt01":2,
         "shirt02":2,
         "shirt03":2,
         "shirt04":2,
         "shirt05":2,
         "shirt06":2,
         "shirt07":2,
         "shirt08":2,
         "shirt09":2,
         "shoe01":2,
         "shoe02":2,
         "shoe03":2,
         "shoe04":2,
         "shoe05":2,
         "skirt01":2,
         "skirt02":3,
         "skirt03":2,
         "sock01":2,
         "sock02":2,
         "stickman":3,
         "strap01":5,
         "sweater01":4,
         "thumbs":6,
         "tie01":2,
         "waist01":3
      };
      
      public static const collared_shirts:Object = {
         "shirt03":null,
         "shirt05":null,
         "shirt06":null,
         "shirt07":"shirt02",
         "shirt08":"shirt04",
         "shirt09":"shirt01"
      };
      
      private static var debug:Boolean = true;
      
      private static var instance:ArtLoader = new ArtLoader();
      
      public static var base_colour:Object = {
         "sock01":"272727",
         "sock02":"272727",
         "strap01":"373737",
         "tie01":"3a4592",
         "waist01":"444444",
         "glove01":"494545",
         "glove02":"494545",
         "shoe05":"63300e",
         "skirt01":"9b2aa8",
         "skirt02":"9b2aa8",
         "skirt03":"9b2aa8",
         "sweater01":"cccfc9",
         "scarf01":"d02900",
         "jacket01":"d4d4d4",
         "jacket02":"d4d4d4",
         "pants01":"f5f5f5",
         "pants02":"f5f5f5",
         "pants03":"f5f5f5",
         "pants04":"f5f5f5",
         "pants05":"f5f5f5",
         "pants06":"f5f5f5",
         "necklace01":"fbfbfb",
         "bare":"ffcc99",
         "shirt01":"fffffe",
         "shirt02":"fffffe",
         "shirt03":"fffffe",
         "shirt04":"fffffe",
         "shirt05":"fffffe",
         "shirt06":"fffffe",
         "shirt07":"fffffe",
         "shirt08":"fffffe",
         "shirt09":"fffffe"
      };
       
      
      private var states:Object;
      
      public var loaded:uint;
      
      public var line_data:Object;
      
      private var line_widths:Object;
      
      public var categories:Object;
      
      private var colours:Object;
      
      private var _clothing_queue:Object;
      
      private var loaders:Object;
      
      private var body_art:Object;
      
      private var bl:BulkLoader;
      
      private var load_pack:Array;
      
      public var loaded_count:uint;
      
      private var _clothing_loaded:Object;
      
      public var art:Array;
      
      private var finished_swfs:Object;
      
      private var skyground:Object;
      
      public var points:Object;
      
      private var levels:Array;
      
      public var props:Object;
      
      public function ArtLoader()
      {
         var _loc1_:String = null;
         art = new Array();
         body_art = new Object();
         colours = new Object();
         skyground = {};
         line_widths = new Object();
         props = {};
         categories = {};
         states = {};
         levels = new Array();
         loaders = new Object();
         finished_swfs = new Object();
         load_pack = new Array();
         _clothing_queue = {};
         _clothing_loaded = {};
         super();
         if(instance)
         {
            throw new Error("ArtLoader can only be accesed through ArtLoader.getInstance();");
         }
         loaded = 0;
         loaded_count = 0;
         bl = new BulkLoader("artloader",BulkLoader.DEFAULT_NUM_CONNECTIONS);
         bl.addEventListener(BulkLoader.PROGRESS,dispatchEvent);
         bl.addEventListener(BulkLoader.ERROR,dispatchEvent);
         props["shapes"] = [];
         for each(_loc1_ in PropShape.shapes)
         {
            props["shapes"][_loc1_] = _loc1_;
         }
      }
      
      public static function getInstance() : ArtLoader
      {
         return instance;
      }
      
      public static function clothing_url(param1:String) : String
      {
         if(BSConstants.AIR)
         {
            return "app:/body_art/" + param1 + ".swf";
         }
         var _loc2_:String = ArtLoader.swf_urls[param1];
         if(_loc2_ && !Skeleton.debug)
         {
            return BSConstants.NEW_ASSET_URL + "art/v" + _loc2_ + "/" + param1 + ".swf";
         }
         return "http://bitstrips.com/tester/parts/" + param1 + ".swf";
      }
      
      public function clothing_queue(param1:String, param2:Skeleton = null) : void
      {
         if(_clothing_queue.hasOwnProperty(param1) == false)
         {
            _clothing_queue[param1] = [];
            this.load_swf(ArtLoader.clothing_url(param1));
         }
         if(param2)
         {
            _clothing_queue[param1].push(param2);
         }
      }
      
      private function url_basefile(param1:String) : String
      {
         var _loc2_:Array = param1.split("/");
         return _loc2_[_loc2_.length - 1];
      }
      
      public function part_colour(param1:String) : String
      {
         if(ArtLoader.base_colour.hasOwnProperty(param1))
         {
            return ArtLoader.base_colour[param1];
         }
         if(param1 == "beard")
         {
            return "926715";
         }
         if(param1 == "hair_front")
         {
            return "926715";
         }
         return "";
      }
      
      public function clothing_loaded(param1:String) : Boolean
      {
         return _clothing_loaded.hasOwnProperty(param1);
      }
      
      public function load_swf(param1:String) : void
      {
         var _loc2_:LoadingItem = null;
         if(loaders[param1] == undefined)
         {
            if(debug)
            {
               trace("Load SWF: " + param1);
            }
            _loc2_ = bl.add(param1);
            loaded_count = loaded_count + 1;
            _loc2_.addEventListener(Event.COMPLETE,import_art);
            loaders[param1] = _loc2_;
            bl.start();
         }
         else if(debug)
         {
            trace("ArtLoader - load_swf, already requested: " + param1);
         }
      }
      
      public function get_prop(param1:String, param2:String) : Object
      {
         if(props.hasOwnProperty(param1) == false)
         {
            throw new Error("Unknown art type: " + param1 + " for id " + param2);
         }
         if(param1 == "shapes")
         {
            return new PropShape(param2);
         }
         if(param2 == "backdrop13a")
         {
            param2 = "backdrop13";
         }
         if(props[param1] == undefined)
         {
            trace("PROPS " + param1 + " undefined");
            return undefined;
         }
         if(props[param1][param2] == undefined)
         {
            trace("PROPS " + param1 + " : " + param2 + " - undefined");
            return undefined;
         }
         var _loc3_:Object = new props[param1][param2]();
         _loc3_.name = param2;
         _loc3_.type = param1;
         if(states[param2])
         {
            _loc3_.states = states[param2]["states"];
            _loc3_.rotations = states[param2]["rotations"];
         }
         if(colours.hasOwnProperty(param2))
         {
            _loc3_.set_base_colour(colours[param2]);
         }
         else
         {
            _loc3_.set_base_colour("ffffff");
         }
         if(skyground.hasOwnProperty(param2))
         {
            if(skyground[param2].hasOwnProperty("sky"))
            {
               _loc3_.sky = skyground[param2]["sky"];
            }
            if(skyground[param2].hasOwnProperty("ground"))
            {
               _loc3_.ground = skyground[param2]["ground"];
            }
         }
         return _loc3_;
      }
      
      private function art_split(param1:String) : Object
      {
         var _loc2_:int = param1.lastIndexOf("_");
         var _loc3_:String = param1.substr(0,_loc2_);
         var _loc4_:Object = undefined;
         if(_loc3_.substr(2,1) == "_")
         {
            _loc4_ = _loc3_.substr(0,2);
            _loc3_ = _loc3_.substr(3,_loc2_);
         }
         return {
            "part":_loc3_,
            "type":param1.substr(_loc2_ + 1),
            "cat":_loc4_
         };
      }
      
      private function import_art(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:String = null;
         var _loc7_:Array = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:* = null;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:Skeleton = null;
         if(debug)
         {
            trace("ArtLoader import_art: " + url_basefile(param1.target.url.url));
         }
         var _loc5_:Loader = Loader(param1.target.loader);
         var _loc6_:MovieClip = _loc5_.content as MovieClip;
         if(_loc6_.hasOwnProperty("type"))
         {
            _loc9_ = _loc6_["type"]["body_type"];
            _loc10_ = _loc6_["type"]["height"];
            if(body_art[_loc9_] == undefined)
            {
               body_art[_loc9_] = {};
            }
            if(body_art[_loc9_][_loc10_] == undefined)
            {
               body_art[_loc9_][_loc10_] = new Array();
            }
            _loc7_ = body_art[_loc9_][_loc10_];
         }
         else
         {
            _loc7_ = art;
         }
         if(_loc6_.hasOwnProperty("line_data"))
         {
            line_data = _loc6_.line_data;
         }
         if(_loc6_.hasOwnProperty("artwork"))
         {
            for(_loc2_ in _loc6_.artwork)
            {
               if(_loc7_[_loc2_] == undefined)
               {
                  _loc7_[_loc2_] = new Array();
               }
               for(_loc3_ in _loc6_.artwork[_loc2_])
               {
                  _loc4_ = _loc6_.artwork[_loc2_][_loc3_];
                  _loc7_[_loc2_][_loc4_] = _loc5_.contentLoaderInfo.applicationDomain.getDefinition(_loc4_) as Class;
               }
               _loc7_[_loc2_].sort();
            }
         }
         if(_loc6_.hasOwnProperty("props"))
         {
            for(_loc2_ in _loc6_.props)
            {
               if(_loc2_ != "shapes")
               {
                  if(props[_loc2_] == undefined)
                  {
                     props[_loc2_] = new Array();
                  }
                  for(_loc3_ in _loc6_.props[_loc2_])
                  {
                     _loc4_ = _loc6_.props[_loc2_][_loc3_];
                     props[_loc2_][_loc4_] = _loc5_.contentLoaderInfo.applicationDomain.getDefinition(_loc4_) as Class;
                  }
               }
            }
         }
         if(_loc6_.hasOwnProperty("categories"))
         {
            categories = _loc6_.categories;
         }
         if(_loc6_.hasOwnProperty("states"))
         {
            for(_loc2_ in _loc6_.states)
            {
               states[_loc2_] = _loc6_.states[_loc2_];
            }
         }
         if(_loc6_.hasOwnProperty("line_width"))
         {
            for(_loc2_ in _loc6_.line_width)
            {
               line_widths[_loc2_] = _loc6_.line_width[_loc2_];
            }
         }
         if(_loc6_.hasOwnProperty("colours"))
         {
            for(_loc2_ in _loc6_.colours)
            {
               colours[_loc2_] = _loc6_.colours[_loc2_];
            }
         }
         if(_loc6_.hasOwnProperty("skyground"))
         {
            for(_loc2_ in _loc6_.skyground)
            {
               skyground[_loc2_] = _loc6_.skyground[_loc2_];
            }
         }
         if(_loc6_.hasOwnProperty("levels"))
         {
            for(_loc11_ in _loc6_.levels)
            {
               levels[_loc11_] = _loc6_.levels[_loc11_];
            }
         }
         finished_swfs[url_basefile(param1.target.url.url)] = 1;
         var _loc8_:int = 0;
         while(_loc8_ < load_pack.length)
         {
            if(load_pack[_loc8_])
            {
               check_pack(_loc8_);
            }
            _loc8_ = _loc8_ + 1;
         }
         if(_loc2_ == "new_body")
         {
            _loc12_ = url_basefile(param1.target.url.url);
            _loc12_ = _loc12_.replace(".swf","");
            _clothing_loaded[_loc12_] = true;
            if(_clothing_queue.hasOwnProperty(_loc12_) == true)
            {
               _loc13_ = 0;
               while(_loc13_ < _clothing_queue[_loc12_].length)
               {
                  _loc14_ = _clothing_queue[_loc12_][_loc13_];
                  _loc14_.add_clothing(_loc12_);
                  _loc13_++;
               }
            }
         }
      }
      
      private function art_part(param1:String) : String
      {
         return param1.substr(param1.lastIndexOf("_") + 1);
      }
      
      public function sorted_index(param1:String, param2:Number = 0) : Array
      {
         var _loc4_:* = null;
         var _loc5_:Array = null;
         var _loc3_:Array = new Array();
         for(_loc4_ in art[param1])
         {
            if(param2)
            {
               _loc5_ = _loc4_.split("_");
               if(_loc5_[_loc5_.length - 1] == param2 || _loc4_ == "_blank")
               {
                  _loc3_.push(_loc4_);
               }
            }
            else
            {
               _loc3_.push(_loc4_);
            }
         }
         _loc3_.sort();
         return _loc3_;
      }
      
      public function sorted_index2(param1:String, param2:Array, param3:int = -1, param4:int = -1) : Array
      {
         var _loc7_:* = null;
         var _loc8_:String = null;
         var _loc5_:Array = new Array();
         var _loc6_:Array = [];
         if(param3 != -1 && param4 != -1)
         {
            if(body_art[param3] && body_art[param3][param4])
            {
               _loc6_ = body_art[param3][param4];
            }
            else
            {
               trace("Can\'t get it for this one:" + param3 + ", " + param4 + " " + body_art[param3]);
            }
         }
         else
         {
            _loc6_ = art;
         }
         if(param2 == null)
         {
            trace("Null filter!" + param1);
            return _loc5_;
         }
         for(_loc7_ in _loc6_[param1])
         {
            _loc8_ = art_part(_loc7_);
            if(param2.indexOf(art_part(_loc7_)) != -1)
            {
               _loc5_.push(_loc7_);
            }
         }
         _loc5_.sort();
         return _loc5_;
      }
      
      public function load_swfs(param1:Array, param2:Function) : uint
      {
         var _loc4_:* = null;
         var _loc3_:uint = load_pack.length;
         load_pack[_loc3_] = {
            "swfs":param1,
            "finished":param2
         };
         for(_loc4_ in param1)
         {
            load_swf(param1[_loc4_]);
         }
         check_pack(_loc3_);
         return _loc3_;
      }
      
      public function part_depth(param1:String) : uint
      {
         var _loc5_:uint = 0;
         var _loc2_:uint = 100;
         var _loc3_:Object = {
            "bare":1,
            "sock1":2,
            "sock2":3,
            "shoe1":4,
            "shoe2":4,
            "shirt1":4,
            "shirt2":4,
            "shirt3":4,
            "pants1":5,
            "pants2":5,
            "shirt4":6
         };
         var _loc4_:Array = ["bare","sock","shirt","pants","shoe","skirt","tie","dress","waist","necklace","sweater","glove","jacket","strap","scarf","stickman"];
         if(_loc3_.hasOwnProperty(param1))
         {
            _loc2_ = _loc3_[param1];
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(param1.indexOf(String(_loc4_[_loc5_])) != -1)
               {
                  _loc2_ = _loc5_ + 1;
                  break;
               }
               _loc5_++;
            }
         }
         return _loc2_;
      }
      
      public function get_art(param1:String, param2:String = "", param3:int = -1, param4:int = -1) : Object
      {
         var _loc5_:Array = null;
         if(param3 != -1 && param4 != -1)
         {
            _loc5_ = body_art[param3][param4];
         }
         else
         {
            _loc5_ = art;
         }
         if(_loc5_[param1] == undefined)
         {
            return undefined;
         }
         if(param2 == "")
         {
            trace("\t\t ---------------------- HOLY GET art! - THEY WANT NULL ID ART! - " + " " + param1);
            return _loc5_[param1][param2];
         }
         if(_loc5_[param1].hasOwnProperty(param2) == false)
         {
            return undefined;
         }
         var _loc6_:Object = art_split(param2);
         var _loc7_:Object = DisplayObject(new _loc5_[param1][param2]());
         _loc7_.name = param2;
         _loc7_.body_part = _loc6_["part"];
         _loc7_.type = _loc6_["cat"];
         var _loc8_:String = part_colour(_loc6_["type"]);
         if(_loc8_ == "")
         {
            _loc8_ = part_colour(_loc6_["part"]);
         }
         if(_loc7_.set_depth)
         {
            _loc7_.set_depth(part_depth(_loc6_["type"]));
         }
         if(colours.hasOwnProperty(param2))
         {
            _loc7_.set_base_colour(colours[param2]);
         }
         else if(_loc8_ && ColourData.get_colours(_loc7_).length == 0)
         {
            _loc7_.set_base_colour(_loc8_);
         }
         else if(_loc7_.no_base_colour)
         {
            _loc7_.no_base_colour();
         }
         if(line_data && line_data[param2])
         {
            _loc7_.set_lines(line_data[param2]);
         }
         if(line_widths[param2])
         {
            _loc7_.line_width = line_widths[param2];
         }
         return _loc7_;
      }
      
      private function check_pack(param1:uint) : Boolean
      {
         var _loc3_:* = null;
         var _loc4_:String = null;
         var _loc2_:Array = load_pack[param1]["swfs"];
         for(_loc3_ in _loc2_)
         {
            _loc4_ = url_basefile(_loc2_[_loc3_]);
            if(debug)
            {
               trace("T: " + _loc4_);
            }
            if(debug)
            {
               trace("check_pack - checking swf: " + _loc2_[_loc3_] + ", Loaded?" + finished_swfs[url_basefile(_loc2_[_loc3_])]);
            }
            if(finished_swfs[url_basefile(_loc2_[_loc3_])] == undefined)
            {
               trace("Pack: " + param1 + ", " + url_basefile(_loc2_[_loc3_]) + " not loaded");
               return false;
            }
         }
         if(debug)
         {
            trace("Calling finished: " + load_pack[param1]["finished"] + ", " + param1);
         }
         load_pack[param1]["finished"](param1);
         load_pack[param1] = null;
         return true;
      }
   }
}
