package com.bitstrips.comicbuilder.library
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class TypeInterface extends Sprite
   {
       
      
      private var myLibraryManager:LibraryManager;
      
      private var itemList:Array;
      
      private var selectedTypeName:String;
      
      private var areaRect:Rectangle;
      
      private var debug:Boolean = false;
      
      private var _type:String;
      
      public function TypeInterface(param1:LibraryManager, param2:Rectangle)
      {
         super();
         this.myLibraryManager = param1;
         this.areaRect = param2;
         this.itemList = new Array();
      }
      
      public function assignTypes(param1:Array) : void
      {
         if(this.debug)
         {
            trace("--TypeInterface.assignTypes()--");
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.addTypeItem(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function addTypeItem(param1:String) : void
      {
         var _loc2_:TypeItem = new TypeItem(this,param1);
         var _loc3_:TypeItem = this.itemList[this.itemList.length - 1];
         var _loc4_:int = 0;
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.x + _loc3_.width + 5;
         }
         addChild(_loc2_);
         _loc2_.x = _loc4_;
         _loc2_.y = -3;
         this.itemList.push(_loc2_);
      }
      
      public function drawMe() : void
      {
         if(this.debug)
         {
            trace("--TypeInterface.drawMe(" + this.areaRect.x + ")--");
         }
         this.x = this.areaRect.x;
         this.y = this.areaRect.y - this.height + 2;
      }
      
      public function handleItemCLICK(param1:TypeItem) : void
      {
         if(this.debug)
         {
            trace("--TypeInterface.handleItemCLICK(" + param1.getName() + ")--");
         }
         this.myLibraryManager.selectType(param1.getName());
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function selectType(param1:String) : void
      {
         var _loc2_:TypeItem = null;
         if(this.debug)
         {
            trace("--TypeInterface.selectType(" + param1 + ")--");
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.itemList.length)
         {
            this.itemList[_loc3_].doSelect(false);
            if(this.itemList[_loc3_].getName() == param1)
            {
               _loc2_ = this.itemList[_loc3_];
            }
            _loc3_++;
         }
         this.selectedTypeName = param1;
         _loc2_.doSelect(true);
         this._type = param1;
      }
      
      public function determineDefaultType() : String
      {
         if(this.debug)
         {
            trace("--TypeInterface.determineDefaultType()--");
         }
         if(this.debug)
         {
            trace("selectedTypeName: " + this.selectedTypeName);
         }
         if(this.itemList[0])
         {
            return this.itemList[0].getName();
         }
         return null;
      }
   }
}
