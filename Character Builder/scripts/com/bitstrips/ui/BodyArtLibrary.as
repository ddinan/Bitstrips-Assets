package com.bitstrips.ui
{
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.bitstrips.Utils;
   import com.bitstrips.character.BodyBuilder;
   import com.bitstrips.character.Head;
   import com.bitstrips.character.skeleton.Skeleton;
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.core.ArtworkLines;
   import com.bitstrips.core.ColourData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Timer;
   
   public class BodyArtLibrary extends Sprite
   {
       
      
      private var _body:Skeleton;
      
      private var artwork:ArtLoader;
      
      private var timer:Timer;
      
      private var loading:MovieClip;
      
      private var _bottom_buttons:Array;
      
      private var _bottom_category:String = "";
      
      private var bottom_grid:Grid;
      
      private var categories:Object;
      
      private var _category:String = "";
      
      private var _top_buttons:Array;
      
      private var _cld:ColourData;
      
      private var top_grid:Grid;
      
      private var wait_click:int = 0;
      
      public function BodyArtLibrary()
      {
         var _loc1_:String = null;
         artwork = ArtLoader.getInstance();
         categories = ArtLoader.clothing_categories;
         super();
         artwork.load_swfs([ArtLoader.clothing_url("thumbs")],thumbs_loaded);
         top_grid = new Grid(300,370,4,3,8,8);
         addChild(top_grid);
         top_grid.visible = false;
         top_grid.addEventListener(Event.SELECT,top_grid_click);
         bottom_grid = new Grid(300,180,2,3);
         addChild(bottom_grid);
         bottom_grid.visible = false;
         bottom_grid.y = 190;
         bottom_grid.addEventListener(Event.SELECT,bottom_grid_click);
         categories["hats"] = new Array();
         categories["hats"].push({
            "pieces":["bare"],
            "rank":"1",
            "thumb":"thumb_bare"
         });
         for each(_loc1_ in ArtLibrary.art_order["hat"][1])
         {
            if(_loc1_ != "_blank")
            {
               categories["hats"].push({
                  "pieces":[_loc1_],
                  "thumb":_loc1_
               });
            }
         }
         if(BSConstants.EDU == false)
         {
            categories["shirts"].push({
               "pieces":["bare"],
               "rank":"1",
               "thumb":"thumb_bare"
            });
            categories["pants"].push({
               "pieces":["bare"],
               "rank":"1",
               "thumb":"thumb_bare"
            });
         }
         timer = new Timer(1000);
         timer.addEventListener(TimerEvent.TIMER,timer_wait);
         enabled = false;
      }
      
      public function set body(param1:Skeleton) : void
      {
         _body = param1;
         _cld = _body.cld;
         _cld.addEventListener("NEW_COLOUR",update_colours);
      }
      
      private function draw_categories() : void
      {
         var _loc1_:String = null;
         if(_bottom_category)
         {
            _loc1_ = "";
            _bottom_buttons = get_buttons(_bottom_category);
            if(_bottom_category == "ties" && wearing_collar == false)
            {
               _loc1_ = _("Requires shirt with collar");
            }
            bottom_grid.add_buttons(_bottom_buttons,_loc1_);
            bottom_grid.visible = true;
            top_grid.set_size(300,180,2,3);
         }
         else
         {
            bottom_grid.visible = false;
            top_grid.set_size(300,370,4,3);
         }
         if(this._category == "sex")
         {
            top_grid.set_size(300,370,1,2);
         }
         _top_buttons = get_buttons(_category);
         top_grid.add_buttons(_top_buttons);
         timer.stop();
         this.mouseChildren = this.mouseEnabled = true;
         this.transform.colorTransform = new ColorTransform();
      }
      
      private function category_click(param1:String, param2:int, param3:Array = null) : uint
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:DisplayObjectContainer = null;
         var _loc11_:DisplayObject = null;
         var _loc12_:String = null;
         if(param2 == -1)
         {
            return 0;
         }
         if(param1 == "sex")
         {
            if(param2 == 0)
            {
               _loc8_ = 1;
            }
            else
            {
               _loc8_ = 2;
            }
            if(_loc8_ == _body.sex)
            {
               return 0;
            }
            _body.sex = _loc8_;
            if(_loc8_ == 1)
            {
               BodyBuilder.set_man(_body.head as Head);
            }
            else
            {
               BodyBuilder.set_woman(_body.head as Head);
            }
            return 0;
         }
         var _loc7_:Array = categories[param1];
         if(param1 == "hats")
         {
            _loc9_ = _loc7_[param2]["pieces"][0];
            if(_loc9_ == "bare")
            {
               _loc9_ = "_blank";
            }
            Head(_body.head).set_art("hat","hat",_loc9_);
         }
         else if(param1 == "jewels")
         {
            _loc6_ = _loc7_[param2]["pieces"];
            _loc5_ = 0;
            while(_loc5_ < _loc6_.length)
            {
               _loc10_ = param3[param2];
               if(_loc10_.numChildren == 1)
               {
                  _body.add_clothing(_loc6_[_loc5_]);
                  _loc11_ = DisplayObject(artwork.get_art("thumbs","thumb_bare"));
                  _loc11_.scaleX = _loc11_.scaleY = 0.25;
                  _loc11_.x = _loc11_.y = 20;
                  _loc10_.addChildAt(_loc11_,1);
               }
               else
               {
                  _body.remove_clothing(_loc6_[_loc5_]);
                  _loc10_.removeChildAt(1);
               }
               _loc5_++;
            }
         }
         else if(categories.hasOwnProperty(param1))
         {
            _loc6_ = _loc7_[param2]["pieces"];
            if(param1 == "ties" && _loc6_[0] != "bare" && wearing_collar == false)
            {
               _loc12_ = get_collar();
               if(artwork.clothing_loaded(_loc12_) == false)
               {
                  artwork.clothing_queue(_loc12_);
                  enabled = false;
                  timer.start();
                  return 1;
               }
               _body.add_clothing(_loc12_);
            }
            _loc5_ = 0;
            while(_loc5_ < _loc6_.length)
            {
               if(artwork.clothing_loaded(_loc6_[_loc5_]) == false)
               {
                  enabled = false;
                  timer.start();
                  artwork.clothing_queue(_loc6_[_loc5_]);
                  return 1;
               }
               _loc5_++;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc7_.length)
            {
               _loc6_ = _loc7_[_loc4_]["pieces"];
               _loc5_ = 0;
               while(_loc5_ < _loc6_.length)
               {
                  if(_loc4_ != param2)
                  {
                     _body.remove_clothing(_loc6_[_loc5_]);
                  }
                  _loc5_++;
               }
               _loc4_++;
            }
            _loc6_ = _loc7_[param2]["pieces"];
            _loc5_ = 0;
            while(_loc5_ < _loc6_.length)
            {
               _body.add_clothing(_loc6_[_loc5_]);
               _loc5_++;
            }
            if(param1 == "shirts")
            {
               if(wearing_collar == false && wearing_tie == true)
               {
                  category_click("ties",0);
               }
            }
         }
         dispatchEvent(new Event("DONE_LOADING"));
         return 0;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this.mouseChildren = this.mouseEnabled = param1;
         if(top_grid)
         {
            top_grid.enabled = param1;
         }
         else if(bottom_grid)
         {
            bottom_grid.enabled = param1;
         }
         if(loading)
         {
            if(param1 == false)
            {
               this.addChild(loading);
               loading.x = 150;
               loading.y = 75;
               loading.play();
            }
            else if(this.contains(loading))
            {
               this.removeChild(loading);
            }
         }
      }
      
      public function get category() : String
      {
         return _category;
      }
      
      public function set section(param1:uint) : void
      {
         if(wait_click != 0)
         {
            return;
         }
         trace("Section Click: " + param1);
         _bottom_category = "";
         if(param1 == 2)
         {
            category = "shirts";
         }
         else if(param1 == 3)
         {
            category = "sweaters";
         }
         else if(param1 == 4)
         {
            category = "jackets";
         }
         else if(param1 == 5)
         {
            category = "pants";
         }
         else if(param1 == 6)
         {
            category = "skirts";
         }
         else if(param1 == 7)
         {
            _bottom_category = "socks";
            category = "shoes";
         }
         else if(param1 == 8)
         {
            category = "gloves";
         }
         else if(param1 == 9)
         {
            category = "hats";
         }
         else if(param1 == 10)
         {
            _bottom_category = "ties";
            category = "jewels";
         }
         else if(param1 == 11)
         {
            _bottom_category = "belts";
            category = "backthings";
         }
      }
      
      private function get wearing_tie() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         for each(_loc1_ in ArtLoader.clothing_categories["ties"])
         {
            _loc2_ = _loc1_["pieces"];
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_[_loc3_] != "bare")
               {
                  if(_body.wearing(_loc2_[_loc3_]) == true)
                  {
                     return true;
                  }
               }
               _loc3_++;
            }
         }
         return false;
      }
      
      private function get wearing_collar() : Boolean
      {
         var _loc1_:* = null;
         for(_loc1_ in ArtLoader.collared_shirts)
         {
            if(_body.wearing(_loc1_) == true)
            {
               return true;
            }
         }
         return false;
      }
      
      public function set category(param1:String) : void
      {
         if(_category != param1)
         {
            top_grid.visible = true;
            if(param1 == "sex")
            {
               this._bottom_category = "";
            }
            _category = param1;
            draw_categories();
         }
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      private function get_buttons(param1:String) : Array
      {
         var _loc4_:uint = 0;
         var _loc2_:Array = [];
         var _loc3_:Array = categories[param1];
         if(param1 == "sex")
         {
            _loc2_.push(DisplayObject(get_thumb(param1,"thumb_male")));
            _loc2_.push(DisplayObject(get_thumb(param1,"thumb_female")));
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_.push(DisplayObject(get_thumb(param1,_loc3_[_loc4_]["thumb"])));
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      private function bottom_grid_click(param1:Event = null) : void
      {
         var _loc2_:int = 0;
         wait_click = 0;
         if(category_click(_bottom_category,bottom_grid.selected,_bottom_buttons) == 1)
         {
            dispatchEvent(new Event("LOADING"));
            wait_click = 2;
            timer.start();
            if(loading)
            {
               _loc2_ = bottom_grid.selected % 6;
               loading.scaleX = loading.scaleY = 0.7;
               loading.x = _loc2_ % 3 * 100 + 50;
               loading.y = Math.floor(_loc2_ / 3) * 85 + 50 + 190;
               trace("X Y:" + loading.x + "," + loading.y);
            }
         }
      }
      
      private function get_thumb(param1:String, param2:String) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:ArtworkLines = null;
         var _loc5_:Object = null;
         var _loc6_:DisplayObject = null;
         if(param1 == "hats" && param2 != "thumb_bare")
         {
            _loc4_ = new ArtworkLines();
            _loc3_ = artwork.get_art("hat",param2);
            if(_loc3_)
            {
               _cld.colour_clip(_loc3_);
               _loc4_.art = _loc3_;
               _loc3_ = _loc4_;
            }
         }
         else
         {
            _loc3_ = artwork.get_art("thumbs",param2);
         }
         if(_loc3_ == null)
         {
            _loc3_ = artwork.get_art("thumbs","missing");
         }
         _cld.colour_clip(_loc3_);
         if(param1 == "jewels")
         {
            _loc5_ = Utils.art_split(param2);
            if(_body.wearing(_loc5_["type"]) == true)
            {
               _loc6_ = DisplayObject(artwork.get_art("thumbs","thumb_bare"));
               _loc6_.scaleX = _loc6_.scaleY = 0.25;
               _loc6_.x = _loc6_.y = 20;
               _loc3_.addChildAt(_loc6_,1);
            }
         }
         return _loc3_;
      }
      
      private function thumbs_loaded(param1:int) : void
      {
         loading = MovieClip(artwork.get_art("thumbs","thumb_loading"));
         enabled = true;
      }
      
      private function timer_wait(param1:TimerEvent) : void
      {
         timer.stop();
         enabled = true;
         if(wait_click == 1)
         {
            top_grid_click();
         }
         else
         {
            bottom_grid_click();
         }
      }
      
      private function update_colours(param1:Event = null) : void
      {
         top_grid.colour_buttons(_cld);
         bottom_grid.colour_buttons(_cld);
      }
      
      private function get_collar() : String
      {
         var _loc1_:* = null;
         for(_loc1_ in ArtLoader.collared_shirts)
         {
            if(ArtLoader.collared_shirts[_loc1_] && _body.wearing(ArtLoader.collared_shirts[_loc1_]))
            {
               return _loc1_;
            }
         }
         return "shirt05";
      }
      
      private function top_grid_click(param1:Event = null) : void
      {
         var _loc2_:int = 0;
         wait_click = 0;
         if(category_click(_category,top_grid.selected,_top_buttons) == 1)
         {
            dispatchEvent(new Event("LOADING"));
            wait_click = 1;
            timer.start();
            if(loading)
            {
               loading.scaleX = loading.scaleY = 0.7;
               loading.x = top_grid.selected % 3 * 100 + 50;
               loading.y = Math.floor(top_grid.selected / 3) * 85 + 50;
               trace("X Y:" + loading.x + "," + loading.y);
            }
         }
      }
      
      private function updated(param1:Event) : void
      {
         trace("Something changed on the body!");
      }
      
      public function type_to_category(param1:String) : String
      {
         var _loc2_:* = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         for(_loc2_ in categories)
         {
            _loc3_ = 0;
            while(_loc3_ < categories[_loc2_].length)
            {
               _loc4_ = 0;
               while(_loc4_ < categories[_loc2_][_loc3_]["pieces"].length)
               {
                  if(param1 == categories[_loc2_][_loc3_]["pieces"][_loc4_])
                  {
                     return _loc2_;
                  }
                  _loc4_++;
               }
               _loc3_++;
            }
         }
         return "";
      }
   }
}
