package com.bitstrips.ui
{
   import com.bitstrips.BSConstants;
   import fl.controls.Button;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class AlertBox extends Sprite
   {
       
      
      private var myDisplayParent:Sprite;
      
      private var btnContainer:Sprite;
      
      private var boxHeight:Number = 150;
      
      private var bkgr:Sprite;
      
      private var myMsg:TextField;
      
      private var msgFormat:TextFormat;
      
      private var btnList:Array;
      
      private var boxWidth:Number = 250;
      
      private var closeFunc:Function;
      
      public function AlertBox(param1:String, param2:Array, param3:Sprite)
      {
         closeFunc = function():void
         {
         };
         super();
         myDisplayParent = param3;
         myDisplayParent.addChild(this);
         btnList = new Array();
         btnContainer = new Sprite();
         var _loc4_:Number = 20;
         var _loc5_:Number = 0;
         var _loc6_:int = 0;
         while(_loc6_ < param2.length)
         {
            btnList[_loc6_] = new Object();
            btnList[_loc6_].f = param2[_loc6_].f;
            btnList[_loc6_].btn = new Button();
            btnList[_loc6_].btn.name = "button " + _loc6_;
            btnList[_loc6_].btn.label = param2[_loc6_].txt;
            btnList[_loc6_].btn.addEventListener(MouseEvent.CLICK,btnList[_loc6_].f,false,1);
            btnList[_loc6_].btn.addEventListener(MouseEvent.CLICK,closeBox,false,2);
            btnContainer.addChild(btnList[_loc6_].btn);
            if(btnList[_loc6_ - 1] != null)
            {
               _loc5_ = btnList[_loc6_ - 1].btn.x + btnList[_loc6_ - 1].btn.width + _loc4_;
            }
            btnList[_loc6_].btn.x = _loc5_;
            _loc6_++;
         }
         bkgr = new Sprite();
         if(btnContainer.width > boxWidth - 40)
         {
            boxWidth = btnContainer.width + 40;
         }
         drawMessage(param1);
         drawBox();
         addChild(bkgr);
         addChild(myMsg);
         addChild(btnContainer);
      }
      
      public function set_closeFunc(param1:Function) : void
      {
         closeFunc = param1;
      }
      
      public function drawMessage(param1:String) : void
      {
         msgFormat = new TextFormat();
         msgFormat.font = BSConstants.CREATIVEBLOCK;
         msgFormat.size = 14;
         msgFormat.align = TextFormatAlign.CENTER;
         msgFormat.color = 0;
         myMsg = new TextField();
         myMsg.defaultTextFormat = msgFormat;
         myMsg.width = boxWidth - 40;
         myMsg.autoSize = TextFieldAutoSize.CENTER;
         myMsg.wordWrap = true;
         myMsg.border = false;
         myMsg.selectable = false;
         myMsg.embedFonts = true;
         myMsg.text = param1;
         myMsg.y = 20;
         trace("myMsg.width: " + myMsg.width);
         btnContainer.y = myMsg.y + myMsg.height + 20;
         boxHeight = btnContainer.y + 50;
      }
      
      public function closeBox(param1:MouseEvent) : void
      {
         trace("--AlertBox.closeBox(" + param1.target + ")--");
         myDisplayParent.removeChild(this);
         closeFunc();
      }
      
      public function drawBox() : void
      {
         bkgr.graphics.clear();
         bkgr.graphics.beginFill(16448250,1);
         bkgr.graphics.lineStyle(2,0,1);
         bkgr.graphics.drawRect(0,0,boxWidth,boxHeight);
         bkgr.graphics.endFill();
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         bkgr.filters = [_loc1_];
         centerInBox(myMsg);
         centerInBox(btnContainer);
      }
      
      public function centerInBox(param1:DisplayObject) : void
      {
         param1.x = bkgr.width / 2 - param1.width / 2;
      }
   }
}
