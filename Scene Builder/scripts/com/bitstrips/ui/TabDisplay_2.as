package com.bitstrips.ui
{
   import com.bitstrips.BSConstants;
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class TabDisplay extends Sprite
   {
       
      
      private const labelWidthTop:Number = 120;
      
      private var bg:Boolean = true;
      
      private var debug:Boolean = false;
      
      private const gap:Number = 4;
      
      private const tabHeight:Number = 105;
      
      public var focusedTab:String;
      
      private var tabData:Object;
      
      private var tabObjList:Array;
      
      private var tabBkgr:Sprite;
      
      private var tabContainer:Sprite;
      
      private const tabWidth:Number = 748;
      
      private const labelWidth:Number = 110;
      
      private const labelHeight:Number = 16;
      
      private const labelWidthBottom:Number = 150;
      
      public function TabDisplay(param1:Boolean = true)
      {
         super();
         if(debug)
         {
            trace("--TabDisplay()--");
         }
         this.x = this.x + 1;
         tabData = new Object();
         this.bg = param1;
         setData({"tabDataList":[{
            "name":"NONE",
            "label":"BLANK TAB",
            "colour":16711680
         }]});
         focusTab(tabObjList[0].name);
      }
      
      public function setData(param1:Object) : void
      {
         var _loc2_:* = null;
         if(debug)
         {
            trace("--TabDisplay.setData(" + param1.tabDataList.length + ")--");
         }
         for(_loc2_ in param1)
         {
            tabData[_loc2_] = param1[_loc2_];
         }
         drawMe();
      }
      
      public function updateTabLabel(param1:Object) : void
      {
         if(debug)
         {
            trace("--TabDisplay.updateTabLabel()--");
         }
         var _loc2_:int = 0;
         while(_loc2_ < tabObjList.length)
         {
            if(tabObjList[_loc2_].name == param1.name)
            {
               break;
            }
            _loc2_++;
         }
         tabObjList[_loc2_].data.label = param1.label;
         redrawTabLabel(tabObjList[_loc2_],param1.label);
      }
      
      public function drawMe() : void
      {
         if(debug)
         {
            trace("--TabDisplay.drawMe()--");
         }
         tabContainer = new Sprite();
         tabBkgr = new Sprite();
         tabBkgr.graphics.clear();
         var _loc1_:Matrix = new Matrix();
         _loc1_.createGradientBox(tabWidth + 2,labelHeight + 10,Math.PI / 2);
         tabBkgr.graphics.beginGradientFill(GradientType.LINEAR,[11267839,11004158],[1,1],[10,255],_loc1_);
         tabBkgr.graphics.drawRect(-1,-10,tabWidth + 2,labelHeight + 10);
         tabObjList = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < tabData.tabDataList.length)
         {
            tabObjList[_loc2_] = new Object();
            tabObjList[_loc2_].data = tabData.tabDataList[_loc2_];
            tabObjList[_loc2_].tab = new Sprite();
            tabObjList[_loc2_].tab.name = tabObjList[_loc2_].data.name;
            tabObjList[_loc2_].tabPosition = tabWidth - (labelWidth + gap) * (1 + _loc2_);
            build_tab(tabObjList[_loc2_]);
            draw_tab_unselected(tabObjList[_loc2_]);
            tabContainer.addChild(tabObjList[_loc2_].tab);
            redrawTabLabel(tabObjList[_loc2_],tabObjList[_loc2_].data.label);
            if(tabData.tabDataList[_loc2_].clip)
            {
               tabData.tabDataList[_loc2_].clip.y = tabData.tabDataList[_loc2_].clip.y - 5;
               tabObjList[_loc2_].tab.addChild(tabData.tabDataList[_loc2_].clip);
            }
            _loc2_++;
         }
         if(bg)
         {
            addChild(tabBkgr);
         }
         addChild(tabContainer);
         if(debug)
         {
            trace("TabDisplay.height: " + this.height);
         }
      }
      
      public function redrawTabLabel(param1:Object, param2:String) : void
      {
         param1.tabField.text = param2.toUpperCase();
         param1.tabField.x = param1.tabPosition + labelWidth / 2 - param1.tabField.width / 2;
      }
      
      public function focusTab(param1:String) : void
      {
         var _loc2_:uint = 0;
         if(debug)
         {
            trace("--TabDisplay.focusTab(" + param1 + ")--");
         }
         if(focusedTab == param1)
         {
            if(debug)
            {
               trace("trying to re-focus on current tab");
            }
            return;
         }
         focusedTab = param1;
         _loc2_ = 0;
         while(_loc2_ < tabData.tabDataList.length)
         {
            draw_tab_unselected(tabObjList[_loc2_]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < tabObjList.length)
         {
            if(tabObjList[_loc2_].data.name == param1)
            {
               break;
            }
            _loc2_++;
         }
         if(_loc2_ >= tabObjList.length)
         {
            if(debug)
            {
               trace("FOCUS UKNOWN TAB: " + param1);
            }
            return;
         }
         draw_tab_selected(tabObjList[_loc2_]);
         tabContainer.setChildIndex(tabObjList[_loc2_].tab,tabContainer.numChildren - 1);
         this.dispatchEvent(new Event("NEW_TAB"));
      }
      
      public function build_tab(param1:Object) : void
      {
         var _loc2_:Sprite = new Sprite();
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.font = BSConstants.VERDANA;
         _loc3_.bold = true;
         _loc3_.size = 9;
         _loc3_.align = TextFormatAlign.CENTER;
         _loc3_.color = 0;
         var _loc4_:TextField = new TextField();
         _loc4_.defaultTextFormat = _loc3_;
         _loc4_.selectable = false;
         _loc4_.mouseEnabled = false;
         _loc4_.embedFonts = true;
         param1.tab.addChild(_loc2_);
         param1.tab.addChild(_loc4_);
         param1.tabLabel = _loc2_;
         param1.tabField = _loc4_;
         _loc2_.name = param1.data.name;
         _loc2_.addEventListener(MouseEvent.CLICK,clickTab);
      }
      
      public function clickTab(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--TabDisplay.clickTab(" + param1.currentTarget.name + ")--");
         }
         focusTab(param1.currentTarget.name);
      }
      
      public function draw_tab_selected(param1:Object) : void
      {
         if(debug)
         {
            trace("--TabDisplay.draw_tab_unselected()--");
         }
         if(param1 == null)
         {
            if(debug)
            {
               trace("Draw Null Tab!");
            }
            return;
         }
         var _loc2_:Matrix = new Matrix();
         var _loc3_:Number = 4;
         var _loc4_:Sprite = param1.tabLabel;
         _loc2_.createGradientBox(tabWidth,labelHeight + tabHeight,Math.PI / 2);
         _loc4_.graphics.clear();
         _loc4_.graphics.beginGradientFill(GradientType.LINEAR,[14013909,5329233],[1,1],[20,255],_loc2_);
         _loc4_.graphics.lineStyle(2,0,1);
         _loc4_.graphics.moveTo(0,labelHeight);
         _loc4_.graphics.lineTo(param1.tabPosition,labelHeight);
         _loc4_.graphics.lineTo(param1.tabPosition,0 + _loc3_);
         _loc4_.graphics.curveTo(param1.tabPosition,0,param1.tabPosition + _loc3_,0);
         _loc4_.graphics.lineTo(param1.tabPosition + labelWidth - _loc3_,0);
         _loc4_.graphics.curveTo(param1.tabPosition + labelWidth,0,param1.tabPosition + labelWidth,0 + _loc3_);
         _loc4_.graphics.lineTo(param1.tabPosition + labelWidth,labelHeight);
         _loc4_.graphics.lineTo(tabWidth,labelHeight);
         _loc4_.graphics.lineTo(tabWidth,labelHeight + tabHeight);
         _loc4_.graphics.lineTo(0,labelHeight + tabHeight);
         _loc4_.graphics.lineTo(0,labelHeight);
         _loc4_.buttonMode = false;
         var _loc5_:TextFormat = new TextFormat();
         _loc5_.color = 10027008;
         redrawTabLabel(param1,param1.data.label);
         param1.tabField.setTextFormat(_loc5_);
      }
      
      public function draw_tab_unselected(param1:Object) : void
      {
         if(debug)
         {
            trace("--TabDisplay.draw_tab_unselected()--");
         }
         var _loc2_:Number = 4;
         var _loc3_:Sprite = param1.tabLabel;
         var _loc4_:Matrix = new Matrix();
         _loc4_.createGradientBox(tabWidth,labelHeight + tabHeight,Math.PI / 2);
         _loc3_.graphics.beginGradientFill(GradientType.LINEAR,[16056209,12851738],[1,1],[0,100],_loc4_);
         _loc3_.graphics.lineStyle(2,0,1);
         _loc3_.graphics.moveTo(0,labelHeight);
         _loc3_.graphics.lineTo(param1.tabPosition,labelHeight);
         _loc3_.graphics.lineTo(param1.tabPosition,0 + _loc2_);
         _loc3_.graphics.curveTo(param1.tabPosition,0,param1.tabPosition + _loc2_,0);
         _loc3_.graphics.lineTo(param1.tabPosition + labelWidth - _loc2_,0);
         _loc3_.graphics.curveTo(param1.tabPosition + labelWidth,0,param1.tabPosition + labelWidth,0 + _loc2_);
         _loc3_.graphics.lineTo(param1.tabPosition + labelWidth,labelHeight);
         _loc3_.graphics.lineTo(tabWidth,labelHeight);
         _loc3_.graphics.lineTo(tabWidth,labelHeight + tabHeight);
         _loc3_.graphics.lineTo(0,labelHeight + tabHeight);
         _loc3_.graphics.lineTo(0,labelHeight);
         _loc3_.buttonMode = true;
         var _loc5_:TextFormat = new TextFormat();
         _loc5_.color = 0;
         redrawTabLabel(param1,param1.data.label);
         param1.tabField.setTextFormat(_loc5_);
      }
   }
}
