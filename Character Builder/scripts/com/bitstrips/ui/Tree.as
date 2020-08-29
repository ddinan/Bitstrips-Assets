package com.bitstrips.ui
{
   import fl.containers.ScrollPane;
   import fl.controls.ScrollPolicy;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class Tree extends Sprite
   {
       
      
      public var pane:ScrollPane;
      
      private var outline:Sprite;
      
      private var _treeData:Object;
      
      public var display:Sprite;
      
      public var on_selected:Function = null;
      
      public var on_checked:Function = null;
      
      private var topBranch:TreeNode;
      
      public var on_unchecked:Function = null;
      
      private var tree_width:Number = 100;
      
      private const indent:Number = 20;
      
      private var showNodes:Array;
      
      private var tree_height:Number = 100;
      
      public var content:Sprite;
      
      private var _id:String = "";
      
      private var bkgr:Sprite;
      
      public var on_deselected:Function = null;
      
      private var allNodes:Array;
      
      public function Tree()
      {
         display = new Sprite();
         content = new Sprite();
         super();
         bkgr = new Sprite();
         outline = new Sprite();
         bkgr.graphics.beginFill(14540253,1);
         outline.graphics.lineStyle(0,1);
         pane = new ScrollPane();
         pane.source = content;
         pane.horizontalScrollPolicy = ScrollPolicy.OFF;
         setSize(tree_width,tree_height);
         display.addChild(pane);
         addChild(display);
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = 0;
         tree_width = Math.abs(param1);
         tree_height = Math.abs(param2);
         pane.setSize(tree_width,tree_height);
         pane.update();
         bkgr.graphics.clear();
         bkgr.graphics.drawRect(0,0,tree_width,tree_height);
         outline.graphics.clear();
         outline.graphics.drawRect(0,0,tree_width,tree_height);
         if(allNodes)
         {
            _loc3_ = 0;
            while(_loc3_ < allNodes.length)
            {
               (allNodes[_loc3_] as TreeNode).width = tree_width;
               _loc3_++;
            }
         }
      }
      
      public function set dataProvider(param1:Object) : void
      {
         _treeData = param1;
         allNodes = new Array();
         topBranch = makeBranch(_treeData);
         topBranch.label = "top";
         var _loc2_:uint = 0;
         while(_loc2_ < topBranch.branch.length)
         {
            (topBranch.branch[_loc2_] as TreeNode).shown = true;
            _loc2_++;
         }
         draw();
      }
      
      private function draw_branch(param1:Array) : void
      {
         var _loc2_:TreeNode = null;
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = param1[_loc3_] as TreeNode;
            if(_loc2_.shown)
            {
               showNodes.push(_loc2_);
               if(_loc2_.branch.length > 0)
               {
                  draw_branch(_loc2_.branch);
               }
            }
            _loc3_++;
         }
      }
      
      private function handle_selected(param1:Event) : void
      {
         var _loc2_:TreeNode = param1.currentTarget as TreeNode;
         trace(_loc2_.id);
         var _loc3_:uint = 0;
         while(_loc3_ < allNodes.length)
         {
            if(allNodes[_loc3_] != _loc2_)
            {
               (allNodes[_loc3_] as TreeNode).selected = false;
            }
            _loc3_++;
         }
         if(on_selected != null)
         {
            on_selected(_loc2_.id);
         }
         _id = _loc2_.id;
         dispatchEvent(new Event(Event.SELECT));
      }
      
      public function select_first_node() : void
      {
         if(allNodes.length > 1)
         {
            allNodes[1].select(true);
         }
      }
      
      private function handle_deselected(param1:Event) : void
      {
         trace((param1.currentTarget as TreeNode).id);
         (param1.currentTarget as TreeNode).selected = false;
         if(on_deselected != null)
         {
            on_deselected((param1.currentTarget as TreeNode).id);
         }
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      private function handle_unchecked(param1:Event) : void
      {
         trace((param1.currentTarget as TreeNode).id);
         if(on_unchecked != null)
         {
            on_unchecked((param1.currentTarget as TreeNode).id);
         }
      }
      
      private function handle_checked(param1:Event) : void
      {
         trace((param1.currentTarget as TreeNode).id);
         if(on_checked != null)
         {
            on_checked((param1.currentTarget as TreeNode).id);
         }
      }
      
      public function draw() : void
      {
         var _loc2_:TreeNode = null;
         var _loc1_:uint = content.numChildren;
         while(_loc1_ > 0)
         {
            content.removeChildAt(_loc1_ - 1);
            _loc1_--;
         }
         showNodes = new Array();
         draw_branch(topBranch.branch);
         var _loc3_:uint = 0;
         while(_loc3_ < showNodes.length)
         {
            _loc2_ = showNodes[_loc3_] as TreeNode;
            content.addChild(_loc2_.display);
            if(_loc3_ == 0)
            {
               _loc2_.display.y = 0;
            }
            else
            {
               _loc2_.display.y = (showNodes[_loc3_ - 1] as TreeNode).display.y + (showNodes[_loc3_ - 1] as TreeNode).height;
            }
            _loc3_++;
         }
         pane.update();
         trace("done drawing");
      }
      
      public function selectNode(param1:String) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < allNodes.length)
         {
            if((allNodes[_loc2_] as TreeNode).id == param1)
            {
               (allNodes[_loc2_] as TreeNode).select(true);
               break;
            }
            _loc2_++;
         }
      }
      
      public function makeBranch(param1:Object, param2:TreeNode = null) : TreeNode
      {
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc3_:TreeNode = new TreeNode(tree_width,indent);
         allNodes.push(_loc3_);
         if(param2)
         {
            _loc3_.parent = param2;
         }
         var _loc4_:Array = new Array();
         if(param1.hasOwnProperty("children"))
         {
            _loc5_ = param1.children;
            _loc5_.sortOn(["order","label"],[Array.NUMERIC,Array.CASEINSENSITIVE]);
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc4_.push(makeBranch(_loc5_[_loc6_],_loc3_));
               _loc6_++;
            }
         }
         if(param1.hasOwnProperty("checkbox"))
         {
            _loc3_.checkbox = param1.checkbox;
         }
         if(param1.hasOwnProperty("extraDisplay"))
         {
            _loc3_.extraDisplay = param1.extraDisplay;
         }
         _loc3_.id = param1.id;
         _loc3_.label = param1.label;
         _loc3_.branch = _loc4_;
         _loc3_.addEventListener("redraw",handle_redraw);
         _loc3_.addEventListener("checked",handle_checked);
         _loc3_.addEventListener("unchecked",handle_unchecked);
         _loc3_.addEventListener("selected",handle_selected);
         _loc3_.addEventListener("deselected",handle_deselected);
         return _loc3_;
      }
      
      private function handle_redraw(param1:Event) : void
      {
         draw();
      }
   }
}
