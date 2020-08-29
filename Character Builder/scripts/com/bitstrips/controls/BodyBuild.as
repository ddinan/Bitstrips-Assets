package com.bitstrips.controls
{
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.bitstrips.Utils;
   import com.bitstrips.character.Container;
   import com.bitstrips.character.IBody;
   import com.bitstrips.core.ArtLoader;
   import fl.controls.CheckBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   
   public final class BodyBuild extends Sprite
   {
       
      
      private var chest:Container;
      
      public var body:IBody;
      
      private var heights:Container;
      
      private var clothes:Array;
      
      private var bodys:Container;
      
      private var chest_ui:MovieClip;
      
      private var ui:bodybuildUI;
      
      public function BodyBuild()
      {
         var t:TextField = null;
         var cb:CheckBox = null;
         var s:Array = null;
         var boxes:Array = null;
         var offsetX:Number = NaN;
         var offsetY:Number = NaN;
         var newCol:Boolean = false;
         var i:uint = 0;
         var j:int = 0;
         var pieces:Array = null;
         var v:int = 0;
         super();
         ui = new bodybuildUI();
         addChild(ui);
         chest_ui = ui.chest_ui;
         for each(t in [chest_ui.chest_txt,ui.height_txt,ui.short,ui.tall,ui.body_type,ui.average,ui.thin,ui.fat,ui.buff])
         {
            BSConstants.tf_fix(t);
            t.mouseEnabled = false;
         }
         ui.chest_ui.chest_txt.text = _("CHEST");
         ui.height_txt.text = _("HEIGHT");
         ui.short.text = _("Short");
         ui.tall.text = _("Tall");
         ui.body_type.text = _("BODY TYPE");
         ui.average.text = _("Average");
         ui.thin.text = _("Thin");
         ui.fat.text = _("Fat");
         ui.buff.text = _("Buff");
         if(BSConstants.EDU)
         {
            ui.thin.text = ui.fat.text = ui.buff.text = "";
         }
         heights = new Container([ui.h0,ui.h1,ui.h2,ui.h3,ui.h4]);
         heights.click_function = function(param1:String):void
         {
            var _loc2_:Number = Number(param1.substr(1));
            trace("Val!: " + _loc2_);
            if(body)
            {
               body.body_height = _loc2_;
            }
         };
         heights.over_updates = false;
         heights.select(0);
         bodys = new Container([ui.b0,ui.b1,ui.b2,ui.b3,ui.b4,ui.b5,ui.b6]);
         bodys.click_function = function(param1:String):void
         {
            var _loc2_:Number = Number(param1.substr(1));
            trace("Val!: " + _loc2_);
            if(body)
            {
               if(body.sex == 1)
               {
                  body.body_type = _loc2_;
               }
               else
               {
                  if(_loc2_ == 0)
                  {
                     _loc2_ = 7;
                  }
                  if(_loc2_ == 1)
                  {
                     _loc2_ = 8;
                  }
                  if(_loc2_ == 3)
                  {
                     _loc2_ = 9;
                  }
                  if(_loc2_ == 5)
                  {
                     _loc2_ = 10;
                  }
                  body.body_type = _loc2_;
               }
            }
         };
         bodys.over_updates = false;
         bodys.select(0);
         chest = new Container([ui.c0,ui.c1,ui.c2,ui.c3]);
         chest.over_updates = false;
         chest.click_function = function(param1:String):void
         {
            var _loc2_:Number = Number(param1.substr(1));
            body.breast_type = _loc2_;
         };
         chest.select("c0");
         sex(1);
         if(BSConstants.OLD_BODY)
         {
            cb = new CheckBox();
            addChild(cb);
            cb.y = 350;
            cb.label = "Male";
            cb.addEventListener(Event.CHANGE,function(param1:Event):void
            {
               if(param1.currentTarget.selected)
               {
                  body.sex = 1;
               }
               else
               {
                  body.sex = 2;
               }
               sex(body.sex);
            });
            cb.selected = true;
            clothes = new Array();
            for each(s in ArtLoader.clothing_categories)
            {
               j = 0;
               while(j < s.length)
               {
                  pieces = s[j].pieces;
                  v = 0;
                  while(v < pieces.length)
                  {
                     if(clothes.indexOf(pieces[v]) == -1 && pieces[v] != "bare")
                     {
                        clothes.push(pieces[v]);
                     }
                     v++;
                  }
                  j++;
               }
            }
            boxes = [];
            offsetX = 0;
            offsetY = 375;
            newCol = false;
            i = 0;
            while(i < clothes.length)
            {
               cb = new CheckBox();
               cb.name = clothes[i];
               cb.label = clothes[i];
               cb.addEventListener(Event.CHANGE,box_click);
               cb.x = offsetX;
               cb.y = offsetY;
               offsetY = offsetY + 25;
               if(i + 1 > clothes.length / 2 && !newCol)
               {
                  offsetX = 100;
                  offsetY = 375;
                  newCol = true;
               }
               i++;
            }
         }
      }
      
      public function sex(param1:uint) : void
      {
         if(param1 == 1)
         {
            chest.hide();
            chest_ui.visible = false;
         }
         else
         {
            chest.show();
            chest_ui.visible = true;
         }
      }
      
      public function get_clothes() : Array
      {
         return Utils.clone(clothes) as Array;
      }
      
      private function box_click(param1:Event) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         if(param1.currentTarget.selected)
         {
            body.add_clothing(_loc2_,true);
         }
         else
         {
            body.remove_clothing(_loc2_);
         }
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
   }
}
