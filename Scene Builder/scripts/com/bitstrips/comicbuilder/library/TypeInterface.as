package com.bitstrips.comicbuilder.library
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class TypeInterface extends Sprite
   {
       
      
      private var selectedTypeName:String;
      
      private var itemList:Array;
      
      private var debug:Boolean = false;
      
      private var areaRect:Rectangle;
      
      private var _type:String;
      
      private var myLibraryManager:LibraryManager;
      
      public function TypeInterface(param1:LibraryManager, param2:Rectangle)
      {
         super();
         myLibraryManager = param1;
         areaRect = param2;
         itemList = new Array();
      }
      
      public function get type() : String
      {
         return _type;
      }
      
      public function drawMe() : void
      {
         if(debug)
         {
            trace("--TypeInterface.drawMe(" + areaRect.x + ")--");
         }
         this.x = areaRect.x;
         this.y = areaRect.y - this.height + 2;
      }
      
      public function determineDefaultType() : String
      {
         if(debug)
         {
            trace("--TypeInterface.determineDefaultType()--");
         }
         if(debug)
         {
            trace("selectedTypeName: " + selectedTypeName);
         }
         if(itemList[0])
         {
            return itemList[0].getName();
         }
         return null;
      }
      
      public function assignTypes(param1:Array) : void
      {
         if(debug)
         {
            trace("--TypeInterface.assignTypes()--");
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            addTypeItem(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function handleItemCLICK(param1:TypeItem) : void
      {
         if(debug)
         {
            trace("--TypeInterface.handleItemCLICK(" + param1.getName() + ")--");
         }
         myLibraryManager.selectType(param1.getName());
      }
      
      private function addTypeItem(param1:String) : void
      {
         var _loc2_:TypeItem = new TypeItem(this,param1);
         var _loc3_:TypeItem = itemList[itemList.length - 1];
         var _loc4_:int = 0;
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.x + _loc3_.width + 5;
         }
         addChild(_loc2_);
         _loc2_.x = _loc4_;
         _loc2_.y = -3;
         itemList.push(_loc2_);
      }
      
      public function selectType(param1:String) : void
      {
         var _loc2_:TypeItem = null;
         if(debug)
         {
            trace("--TypeInterface.selectType(" + param1 + ")--");
         }
         var _loc3_:int = 0;
         while(_loc3_ < itemList.length)
         {
            itemList[_loc3_].doSelect(false);
            if(itemList[_loc3_].getName() == param1)
            {
               _loc2_ = itemList[_loc3_];
            }
            _loc3_++;
         }
         selectedTypeName = param1;
         _loc2_.doSelect(true);
         _type = param1;
      }
   }
}
