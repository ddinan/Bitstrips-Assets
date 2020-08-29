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
       
      
      private var boxWidth:Number = 250;
      
      private var boxHeight:Number = 150;
      
      private var bkgr:Sprite;
      
      private var btnContainer:Sprite;
      
      private var myMsg:TextField;
      
      private var msgFormat:TextFormat;
      
      private var btnList:Array;
      
      private var myDisplayParent:Sprite;
      
      private var closeFunc:Function;
      
      public function AlertBox(param1:String, param2:Array, param3:Sprite)
      {
         this.closeFunc = function():void
         {
         };
         super();
         this.myDisplayParent = param3;
         this.myDisplayParent.addChild(this);
         this.btnList = new Array();
         this.btnContainer = new Sprite();
         var _loc4_:Number = 20;
         var _loc5_:Number = 0;
         var _loc6_:int = 0;
         while(_loc6_ < param2.length)
         {
            this.btnList[_loc6_] = new Object();
            this.btnList[_loc6_].f = param2[_loc6_].f;
            this.btnList[_loc6_].btn = new Button();
            this.btnList[_loc6_].btn.name = "button " + _loc6_;
            this.btnList[_loc6_].btn.label = param2[_loc6_].txt;
            this.btnList[_loc6_].btn.addEventListener(MouseEvent.CLICK,this.btnList[_loc6_].f,false,1);
            this.btnList[_loc6_].btn.addEventListener(MouseEvent.CLICK,this.closeBox,false,2);
            this.btnContainer.addChild(this.btnList[_loc6_].btn);
            if(this.btnList[_loc6_ - 1] != null)
            {
               _loc5_ = this.btnList[_loc6_ - 1].btn.x + this.btnList[_loc6_ - 1].btn.width + _loc4_;
            }
            this.btnList[_loc6_].btn.x = _loc5_;
            _loc6_++;
         }
         this.bkgr = new Sprite();
         if(this.btnContainer.width > this.boxWidth - 40)
         {
            this.boxWidth = this.btnContainer.width + 40;
         }
         this.drawMessage(param1);
         this.drawBox();
         addChild(this.bkgr);
         addChild(this.myMsg);
         addChild(this.btnContainer);
      }
      
      public function closeBox(param1:MouseEvent) : void
      {
         trace("--AlertBox.closeBox(" + param1.target + ")--");
         this.myDisplayParent.removeChild(this);
         this.closeFunc();
      }
      
      public function drawMessage(param1:String) : void
      {
         this.msgFormat = new TextFormat();
         this.msgFormat.font = BSConstants.CREATIVEBLOCK;
         this.msgFormat.size = 14;
         this.msgFormat.align = TextFormatAlign.CENTER;
         this.msgFormat.color = 0;
         this.myMsg = new TextField();
         this.myMsg.defaultTextFormat = this.msgFormat;
         this.myMsg.width = this.boxWidth - 40;
         this.myMsg.autoSize = TextFieldAutoSize.CENTER;
         this.myMsg.wordWrap = true;
         this.myMsg.border = false;
         this.myMsg.selectable = false;
         this.myMsg.embedFonts = true;
         this.myMsg.text = param1;
         this.myMsg.y = 20;
         trace("myMsg.width: " + this.myMsg.width);
         this.btnContainer.y = this.myMsg.y + this.myMsg.height + 20;
         this.boxHeight = this.btnContainer.y + 50;
      }
      
      public function drawBox() : void
      {
         this.bkgr.graphics.clear();
         this.bkgr.graphics.beginFill(16448250,1);
         this.bkgr.graphics.lineStyle(2,0,1);
         this.bkgr.graphics.drawRect(0,0,this.boxWidth,this.boxHeight);
         this.bkgr.graphics.endFill();
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         this.bkgr.filters = [_loc1_];
         this.centerInBox(this.myMsg);
         this.centerInBox(this.btnContainer);
      }
      
      public function centerInBox(param1:DisplayObject) : void
      {
         param1.x = this.bkgr.width / 2 - param1.width / 2;
      }
      
      public function set_closeFunc(param1:Function) : void
      {
         this.closeFunc = param1;
      }
   }
}
