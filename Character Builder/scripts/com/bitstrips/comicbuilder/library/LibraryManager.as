package com.bitstrips.comicbuilder.library
{
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.bitstrips.BitStrips;
   import com.bitstrips.Utils;
   import com.bitstrips.character.CharLoader;
   import com.bitstrips.core.ImageLoader;
   import com.bitstrips.core.Remote;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TextEvent;
   import flash.geom.Rectangle;
   
   public class LibraryManager extends EventDispatcher
   {
       
      
      private var assets:Object;
      
      public var basics:Boolean = false;
      
      private var libraryDisplay:Sprite;
      
      private var libraryDefault:String = "01";
      
      private var _type:String = "";
      
      private var assetArea:Rectangle;
      
      private var il:ImageLoader;
      
      private var collectionInterface:CollectionInterface;
      
      private var remote:Remote;
      
      private var type_trees:Object;
      
      private var bs:BitStrips;
      
      private var myTypeInterface:TypeInterface;
      
      private var standardTypeList:Array;
      
      private var debug:Boolean = false;
      
      private var libraryArea:Rectangle;
      
      private var cl:CharLoader;
      
      private var myAssetInterface:AssetInterface;
      
      private var bannedTypes:Object;
      
      public function LibraryManager(param1:BitStrips, param2:Array = null)
      {
         var _t:String = null;
         var t:Boolean = false;
         var obj:Array = null;
         var bs:BitStrips = param1;
         var typeList:Array = param2;
         standardTypeList = ["characters","scenes","props","furniture","wall stuff","effects","shapes"];
         assets = {
            "characters":[],
            "scenes":[],
            "props":[],
            "furniture":[],
            "wall stuff":[],
            "effects":[],
            "shapes":[],
            "image":[],
            "backdrops":[],
            "walls":[],
            "floors":[]
         };
         type_trees = {};
         bannedTypes = new Object();
         super();
         if(debug)
         {
            trace("--LibraryManager()--");
         }
         if(BSConstants.IMAGES)
         {
            standardTypeList.push("image");
         }
         for(_t in assets)
         {
            type_trees[_t] = {
               "id":"top",
               "label":"top",
               "order":0,
               "children":[]
            };
         }
         libraryArea = new Rectangle();
         libraryArea.x = 10;
         libraryArea.y = 45;
         libraryArea.width = 144;
         libraryArea.height = 73;
         assetArea = new Rectangle();
         assetArea.x = 165;
         assetArea.y = 45;
         assetArea.width = 575;
         assetArea.height = 73;
         il = bs.image_loader;
         cl = bs.char_loader;
         remote = bs.remote;
         this.bs = bs;
         myAssetInterface = new AssetInterface(this,assetArea,il,cl);
         myAssetInterface.addEventListener(AssetDragEvent.ASSET_DRAG,dispatchEvent);
         myAssetInterface.addEventListener("CHAR_BUILDER",dispatchEvent);
         collectionInterface = new CollectionInterface(this,libraryArea);
         collectionInterface.addEventListener(Event.SELECT,collection_select);
         collectionInterface.addEventListener(FlickrSearch.FLICKR_SEARCH,flickr_search);
         myTypeInterface = new TypeInterface(this,assetArea);
         libraryDisplay = new Sprite();
         if(typeList != null)
         {
            standardTypeList = typeList;
         }
         myTypeInterface.assignTypes(standardTypeList);
         addLibrary({
            "id":"01",
            "label":_("Bitstrips Basics"),
            "order":0,
            "type":"characters",
            "contents":[]
         });
         addLibrary({
            "id":"MyImage",
            "label":_("My Images"),
            "order":0,
            "type":"image",
            "contents":[]
         });
         if(BSConstants.FLICKR)
         {
            addLibrary({
               "id":"Flickr",
               "label":"Flickr",
               "order":1000,
               "type":"image",
               "contents":[]
            });
         }
         this.selectType(standardTypeList[0]);
         if(standardTypeList.indexOf("characters") != -1 || standardTypeList.indexOf("scenes") != -1)
         {
            t = true;
            if(bs.basic_libs_amfs)
            {
               obj = Utils.amfs2object(bs.basic_libs_amfs) as Array;
               if(obj)
               {
                  setLibraryData(obj);
                  t = false;
               }
            }
            if(t)
            {
               remote.get_basic_libs(setLibraryData);
            }
         }
         if(bs.user_id)
         {
            addLibrary({
               "id":"loading",
               "label":_("Loading Libraries"),
               "order":1,
               "type":"characters",
               "contents":[]
            });
         }
         if(cl.loaded_done)
         {
            load_props();
         }
         else
         {
            cl.addEventListener("LOADED",function(param1:Event):void
            {
               load_props();
            });
         }
      }
      
      private function image_results(param1:Array) : void
      {
         this.add_assets(param1,"Flickr");
         collectionInterface.flickr_item.enabled = true;
         if(param1.length == 0)
         {
            this.myAssetInterface.text_prompt(_("No results found"));
         }
         else
         {
            this.collection_select();
         }
      }
      
      public function getDisplay() : Sprite
      {
         return libraryDisplay;
      }
      
      private function upload_image(param1:Event) : void
      {
         var _loc2_:ImageUploader = new ImageUploader(bs.code,bs.user_id);
         _loc2_.addEventListener(Event.CANCEL,cancel_image,false,0,true);
         assets["image"].push(_loc2_);
         _loc2_.addEventListener(AssetDragEvent.ASSET_DRAG,dispatchEvent,false,0,true);
         this.selectType(_type);
      }
      
      private function flickr_search(param1:TextEvent) : void
      {
         var _loc3_:AssetItem = null;
         trace("Flick Search: " + param1.text);
         remote.image_search(param1.text,image_results);
         myAssetInterface.text_prompt(_("Searching for") + " " + param1.text);
         var _loc2_:int = assets["image"].length - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = assets["image"][_loc2_];
            if(_loc3_.tags == "Flickr")
            {
               assets["image"].splice(_loc2_,1);
            }
            _loc3_ = null;
            _loc2_--;
         }
      }
      
      private function collection_select(param1:Event = null) : void
      {
         var _loc4_:IAssetItem = null;
         var _loc2_:String = collectionInterface.tag;
         var _loc3_:Array = [];
         for each(_loc4_ in assets[_type])
         {
            if(_loc4_.tagged(_loc2_))
            {
               _loc3_.push(_loc4_);
            }
         }
         _loc3_.sortOn(["order","tags","name"],Array.CASEINSENSITIVE);
         if(debug)
         {
            trace("Collection Select: " + _loc2_);
         }
         myAssetInterface.displayAssetType(_loc3_,myTypeInterface.type + "-" + _loc2_);
      }
      
      public function setLibraryData(param1:Array) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            addLibrary(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function selectType(param1:String) : void
      {
         if(debug)
         {
            trace("--LibraryManager.selectType(" + param1 + ")--");
         }
         if(param1)
         {
            _type = param1;
            myTypeInterface.selectType(_type);
            if(BSConstants.EDU)
            {
               myAssetInterface.name_floats = _type == "characters" || _type == "image";
            }
            this.collectionInterface.type = _type;
            this.collection_select();
         }
      }
      
      public function get_user_libs(param1:BitStrips) : void
      {
         var _loc2_:Array = null;
         if(basics || param1.user_id <= 0)
         {
            return;
         }
         if(param1.my_stuff_amfs)
         {
            _loc2_ = Utils.amfs2object(param1.my_stuff_amfs) as Array;
            if(_loc2_)
            {
               setLibraryData(_loc2_);
            }
         }
         else
         {
            remote.get_my_stuff(param1.user_id,setLibraryData);
         }
         if(BSConstants.EDU == false)
         {
            remote.get_friends_lib(param1.user_id,setLibraryData);
            remote.get_friends_stuff(param1.user_id,setLibraryData);
            remote.get_faves(param1.user_id,setLibraryData);
         }
      }
      
      private function delete_asset(param1:Event) : void
      {
         var _loc2_:Object = param1.currentTarget;
         var _loc3_:int = assets[_loc2_.type].indexOf(_loc2_);
         if(_loc3_ != -1 && _loc2_.assetData["can_delete"] == 1)
         {
            assets[_loc2_.type].splice(_loc3_,1);
            this.selectType(_loc2_.type);
            remote.delete_asset(bs.user_id,_loc2_.assetData["id"],_loc2_.assetData["type"]);
         }
      }
      
      private function cancel_image(param1:Event) : void
      {
         if(param1.currentTarget.assetData["can_delete"] == 1)
         {
            delete_asset(param1);
         }
         else
         {
            assets["image"].splice(assets["image"].indexOf(param1.currentTarget),1);
            this.selectType("image");
         }
      }
      
      public function load_props() : void
      {
         var _loc3_:* = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:* = null;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc9_:IAssetItem = null;
         var _loc1_:Object = cl.art_loader.props;
         if(debug)
         {
            trace("props: " + _loc1_);
         }
         var _loc2_:Array = [];
         for(_loc3_ in standardTypeList)
         {
            if(debug)
            {
               trace("type: " + standardTypeList[_loc3_]);
            }
            for(_loc6_ in _loc1_[standardTypeList[_loc3_]])
            {
               _loc7_ = false;
               if(!(BSConstants.EDU && (_loc6_ == "gun" || _loc6_ == "bottle1" || _loc6_ == "winebottle" || _loc6_ == "beer_pint" || _loc6_ == "logo")))
               {
                  if(_loc3_ == "furniture")
                  {
                     _loc7_ = true;
                  }
                  if(debug)
                  {
                     trace("adding prop p: " + _loc6_);
                  }
                  _loc2_.push({
                     "id":_loc6_,
                     "asset_type":standardTypeList[_loc3_],
                     "type":standardTypeList[_loc3_],
                     "name":_loc6_,
                     "lockedGround":_loc7_
                  });
               }
            }
         }
         add_assets(_loc2_,libraryDefault);
         _loc4_ = ["props","furniture","wall stuff","effects","shapes","backdrops","walls","floors"];
         this.addLibrary({
            "id":_("All Props"),
            "label":_("All Props"),
            "type":"props",
            "contents":[],
            "order":0
         });
         this.addLibrary({
            "id":_("All Wall Items"),
            "label":_("All Wall Items"),
            "type":"wall stuff",
            "contents":[],
            "order":0
         });
         this.addLibrary({
            "id":_("All Effects"),
            "label":_("All Effects"),
            "type":"effects",
            "contents":[],
            "order":0
         });
         this.addLibrary({
            "id":_("All Shapes"),
            "label":_("All Shapes"),
            "type":"shapes",
            "contents":[],
            "order":0
         });
         this.addLibrary({
            "id":_("All Furniture"),
            "label":_("All Furniture"),
            "type":"furniture",
            "contents":[],
            "order":0
         });
         for each(_loc5_ in _loc4_)
         {
            for each(_loc8_ in ["Food","Kitchen","Home","Sports","Seasonal","Street","Nature","Office","Animals","School","Science"])
            {
               for each(_loc9_ in assets[_loc5_])
               {
                  if(_loc9_.tagged(_loc8_))
                  {
                     this.addLibrary({
                        "id":_loc8_,
                        "label":_(_loc8_),
                        "type":_loc5_,
                        "contents":[],
                        "order":1
                     });
                     break;
                  }
               }
            }
         }
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      public function add_assets(param1:Array, param2:String) : void
      {
         var _loc3_:Object = null;
         var _loc6_:String = null;
         var _loc7_:AssetItem = null;
         var _loc4_:String = "";
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc3_ = param1[_loc5_];
            if(_loc3_["char_id"])
            {
               _loc4_ = _loc3_["char_id"];
               if(_loc3_["data"])
               {
                  remote.dat_loader.save_char_data(_loc3_["char_id"],_loc3_["version"],_loc3_["data"]);
               }
               addr78:
               _loc6_ = _loc3_["asset_type"];
               assetData_mod(_loc3_);
               if(_loc3_.hasOwnProperty("tags") == false)
               {
                  _loc3_["tags"] = [param2];
               }
               _loc7_ = new AssetItem(_loc3_,this.cl);
               _loc7_.addEventListener(AssetDragEvent.ASSET_DRAG,dispatchEvent,false,0,true);
               if(_loc4_ == "-1" || _loc4_ == "-2")
               {
                  _loc7_.addEventListener("CHAR_BUILDER",dispatchEvent,false,0,true);
                  _loc7_.addEventListener("UPLOAD_IMAGE",upload_image);
               }
               if(_loc3_["can_delete"])
               {
                  _loc7_.addEventListener(Event.CANCEL,delete_asset,false,0,true);
               }
               if(_loc7_.name == "bomb" || _loc7_.name == "sword")
               {
                  _loc7_.order = 2000;
               }
               assets[_loc6_].push(_loc7_);
            }
            else if(_loc3_["scene_id"])
            {
               _loc4_ = "scene_" + _loc3_["scene_id"];
               §§goto(addr78);
            }
            else if(_loc3_["id"])
            {
               _loc4_ = _loc3_["id"];
               §§goto(addr78);
            }
            else
            {
               _loc4_ = "";
               trace("UNKNOWN ID: " + _loc3_);
            }
            _loc5_++;
         }
      }
      
      public function isBanned(param1:String) : Boolean
      {
         if(bannedTypes[param1])
         {
            return true;
         }
         return false;
      }
      
      public function banType(param1:String) : void
      {
         bannedTypes[param1] = true;
      }
      
      public function got_chars(param1:Array) : void
      {
         if(debug)
         {
            trace("--LibraryManager.got_chars()--");
         }
         this.add_assets(param1,libraryDefault);
      }
      
      public function addLibrary(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc2_:String = _("Bitstrips Basics");
         _loc2_ = _("My Characters");
         if(param1.id == "MyChar01")
         {
            _loc5_ = type_trees[param1.type].children;
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               if(_loc5_[_loc6_].id == "loading")
               {
                  _loc5_ = _loc5_.splice(_loc6_,1);
                  break;
               }
               _loc6_++;
            }
         }
         trace("Hello from addLibrary");
         if(param1.hasOwnProperty("type") && param1.hasOwnProperty("id") && param1.hasOwnProperty("label"))
         {
            trace("OK");
            if(param1.hasOwnProperty("children") == false)
            {
               param1["children"] = [];
            }
            if(param1.hasOwnProperty("order") == false)
            {
               param1["order"] = 1000;
            }
            _loc5_ = type_trees[param1.type].children;
            var _loc3_:Boolean = false;
            for each(_loc4_ in _loc5_)
            {
               if(_loc4_.id == param1.id)
               {
                  _loc4_.children = _loc4_.children.concat(param1.children);
                  _loc3_ = true;
                  break;
               }
            }
            if(_loc3_ == false)
            {
               _loc7_ = {
                  "id":param1.id,
                  "label":param1.label,
                  "order":param1.order,
                  "children":param1.children
               };
               this.type_trees[param1.type]["children"].push(_loc7_);
            }
            add_assets(param1.contents,param1.id);
            this.collectionInterface.update_tags(param1.type,type_trees[param1.type]);
            this.collection_select();
            return;
         }
         trace("Not a library!");
      }
      
      public function drawMe() : void
      {
         if(debug)
         {
            trace("--LibraryManager.drawMe()--");
         }
         myAssetInterface.drawMe();
         collectionInterface.drawMe();
         myTypeInterface.drawMe();
         libraryDisplay.addChild(collectionInterface);
         libraryDisplay.addChild(myAssetInterface);
         libraryDisplay.addChild(myTypeInterface);
      }
      
      private function assetData_mod(param1:Object) : void
      {
         var _loc3_:* = null;
         param1.lockedGround = true;
         param1.lockedEditing = false;
         if(param1["thumb"])
         {
            param1["bmpURL"] = param1["thumb"];
         }
         param1["type"] = param1["asset_type"];
         switch(param1["asset_type"])
         {
            case "characters":
               param1["id"] = param1["char_id"];
               param1["guid"] = "char" + param1["id"];
               break;
            case "scenes":
               param1["id"] = param1["scene_id"];
               param1["guid"] = "scene" + param1["id"];
               break;
            case "props":
               param1["tags"] = [_("All Props")];
               break;
            case "wall stuff":
               param1["tags"] = [_("All Wall Items")];
               break;
            case "effects":
               param1["tags"] = [_("All Effects")];
               break;
            case "shapes":
               param1["tags"] = [_("All Shapes")];
               break;
            case "furniture":
               param1["tags"] = [_("All Furniture")];
         }
         var _loc2_:Object = {
            "Food":["banana","PopCan","egg","matzahball_soup","matzah","shankbone","parsley","charoset","horseradish","apple","bacon","BLT","chicken_drumstick","fountain_soda","fries","grapes","hamburger","hotdog","lemon","onion","orange","pear","steak","toast","tomato","lettuce","pumpkin","birthday_cake","beer_pint","applesauce","cookie_chocochip","carrot","glass_of_milk"],
            "Kitchen":["mug-art1","glass","TinCan","bottle1","winebottle","bowl","butterknife","candle","dish","fork","spoon","wineglass","saucer"],
            "Home":["smallTV","lamp-desk","Computer-art1","plant1","flower1","outlet","mousehole","poster","window","clock","picture","lightswitch","DiningTable","TVStand","Desk-art1","FileCabinet_art1","Chair-art1","Chair_art2","Table-art1","Table_art2","Couch1","CoffeeTable","Counter1","CubicleWall","wastebasket","door1","window2","door2","shelves","entertainment_center","TV_HD","Bar","CableBox","DVDplayer","laptop","Tuner","TV_Speaker","barstool","book","cellphone1","phone_cordless","table_round","broom","birthday_candle","balloon","firelog","fireplace","fireplace_basket","hat_tophat"],
            "Sports":["football","basketball","soccerball","baseball","baseball_bat","baseball_mitt","hockey_stick","hockey_puck","tennisball","tennis_racket","golfball","golf_tee","golf_club_iron","bowlingball","bowling_pin"],
            "Seasonal":["basket_easter","chocobunny","egg_easter1","egg_easter2","egg_easter3","tombstone","confetti","noisemaker","streamer","pot_o_gold","rainbow","shamrock","candycane","dreidel","gift_1","gift_2","Hannukah_candle","latka","menorah","mistletoe","Xmas_lights","Xmas_ornament1","Xmas_ornament2","Xmas_star","Xmas_stocking","Xmas_tree","Xmas_wreath"],
            "Street":["bike_post","parking_meter","streetlamp","trashcan"],
            "Nature":["tree01","bush01","grass","rock","cloud","moon","sun","leaf_fall","leaf_pile","rain_falling","snow_falling","snow_pile","snowfort","snowman","stick","tree_evergreen","coal"],
            "Office":["watercooler","presentation_easel","podium","clipboard","crayon","folder","lightbulb","marker","money","paper","pen_ballpoint","pencil","stopwatch","blinds","Stage","gold_coin"],
            "Animals":["fish","rubber_chicken","bat","spider","spiderweb"],
            "School":["chalkboard","chalk","chalk_eraser","Desk_School","AlphabetPoster","bulletinboard","calendar","Cupboard","door3","glue","locker","padlock","post-it_note","pushpin","ruler","scissors","tape","test_tube","test_tube_rack","beaker","flask_erlenmeyer","flask_florence","flask_stand","bunsen_burner","microscope","jar_chemicals","lab_stool","periodic_table","desk_lab","cabinet"],
            "Science":["test_tube","test_tube_rack","beaker","flask_erlenmeyer","flask_florence","flask_stand","bunsen_burner","microscope","jar_chemicals","lab_stool","periodic_table","desk_lab","cabinet"]
         };
         for(_loc3_ in _loc2_)
         {
            if(_loc2_[_loc3_].indexOf(param1["id"]) != -1)
            {
               param1["tags"].push(_loc3_);
            }
         }
      }
   }
}
