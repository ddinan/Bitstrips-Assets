package com.bitstrips.ui
{
   import fl.containers.ScrollPane;
   import fl.controls.ScrollPolicy;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class Tree extends Sprite
   {
       
      
      private var _treeData:Object;
      
      private var topBranch:TreeNode;
      
      private const indent:Number = 20;
      
      private var tree_width:Number = 100;
      
      private var tree_height:Number = 100;
      
      private var showNodes:Array;
      
      private var allNodes:Array;
      
      private var bkgr:Sprite;
      
      private var outline:Sprite;
      
      public var display:Sprite;
      
      public var content:Sprite;
      
      public var pane:ScrollPane;
      
      public var on_checked:Function = null;
      
      public var on_unchecked:Function = null;
      
      public var on_selected:Function = null;
      
      public var on_deselected:Function = null;
      
      private var _id:String = "";
      
      public function Tree()
      {
         this.display = new Sprite();
         this.content = new Sprite();
         super();
         this.bkgr = new Sprite();
         this.outline = new Sprite();
         this.bkgr.graphics.beginFill(14540253,1);
         this.outline.graphics.lineStyle(0,1);
         this.pane = new ScrollPane();
         this.pane.source = this.content;
         this.pane.horizontalScrollPolicy = ScrollPolicy.OFF;
         this.setSize(this.tree_width,this.tree_height);
         this.display.addChild(this.pane);
         addChild(this.display);
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = 0;
         this.tree_width = Math.abs(param1);
         this.tree_height = Math.abs(param2);
         this.pane.setSize(this.tree_width,this.tree_height);
         this.pane.update();
         this.bkgr.graphics.clear();
         this.bkgr.graphics.drawRect(0,0,this.tree_width,this.tree_height);
         this.outline.graphics.clear();
         this.outline.graphics.drawRect(0,0,this.tree_width,this.tree_height);
         if(this.allNodes)
         {
            _loc3_ = 0;
            while(_loc3_ < this.allNodes.length)
            {
               (this.allNodes[_loc3_] as TreeNode).width = this.tree_width;
               _loc3_++;
            }
         }
      }
      
      public function set dataProvider(param1:Object) : void
      {
         this._treeData = param1;
         this.allNodes = new Array();
         this.topBranch = this.makeBranch(this._treeData);
         this.topBranch.label = "top";
         var _loc2_:uint = 0;
         while(_loc2_ < this.topBranch.branch.length)
         {
            (this.topBranch.branch[_loc2_] as TreeNode).shown = true;
            _loc2_++;
         }
         this.draw();
      }
      
      public function makeBranch(param1:Object, param2:TreeNode = null) : TreeNode
      {
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc3_:TreeNode = new TreeNode(this.tree_width,this.indent);
         this.allNodes.push(_loc3_);
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
               _loc4_.push(this.makeBranch(_loc5_[_loc6_],_loc3_));
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
         _loc3_.addEventListener("redraw",this.handle_redraw);
         _loc3_.addEventListener("checked",this.handle_checked);
         _loc3_.addEventListener("unchecked",this.handle_unchecked);
         _loc3_.addEventListener("selected",this.handle_selected);
         _loc3_.addEventListener("deselected",this.handle_deselected);
         return _loc3_;
      }
      
      private function handle_redraw(param1:Event) : void
      {
         this.draw();
      }
      
      public function draw() : void
      {
         var _loc2_:TreeNode = null;
         var _loc1_:uint = this.content.numChildren;
         while(_loc1_ > 0)
         {
            this.content.removeChildAt(_loc1_ - 1);
            _loc1_--;
         }
         this.showNodes = new Array();
         this.draw_branch(this.topBranch.branch);
         var _loc3_:uint = 0;
         while(_loc3_ < this.showNodes.length)
         {
            _loc2_ = this.showNodes[_loc3_] as TreeNode;
            this.content.addChild(_loc2_.display);
            if(_loc3_ == 0)
            {
               _loc2_.display.y = 0;
            }
            else
            {
               _loc2_.display.y = (this.showNodes[_loc3_ - 1] as TreeNode).display.y + (this.showNodes[_loc3_ - 1] as TreeNode).height;
            }
            _loc3_++;
         }
         this.pane.update();
         trace("done drawing");
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
               this.showNodes.push(_loc2_);
               if(_loc2_.branch.length > 0)
               {
                  this.draw_branch(_loc2_.branch);
               }
            }
            _loc3_++;
         }
      }
      
      private function handle_checked(param1:Event) : void
      {
         trace((param1.currentTarget as TreeNode).id);
         if(this.on_checked != null)
         {
            this.on_checked((param1.currentTarget as TreeNode).id);
         }
      }
      
      private function handle_unchecked(param1:Event) : void
      {
         trace((param1.currentTarget as TreeNode).id);
         if(this.on_unchecked != null)
         {
            this.on_unchecked((param1.currentTarget as TreeNode).id);
         }
      }
      
      private function handle_selected(param1:Event) : void
      {
         var _loc2_:TreeNode = param1.currentTarget as TreeNode;
         trace(_loc2_.id);
         var _loc3_:uint = 0;
         while(_loc3_ < this.allNodes.length)
         {
            if(this.allNodes[_loc3_] != _loc2_)
            {
               (this.allNodes[_loc3_] as TreeNode).selected = false;
            }
            _loc3_++;
         }
         if(this.on_selected != null)
         {
            this.on_selected(_loc2_.id);
         }
         this._id = _loc2_.id;
         dispatchEvent(new Event(Event.SELECT));
      }
      
      private function handle_deselected(param1:Event) : void
      {
         trace((param1.currentTarget as TreeNode).id);
         (param1.currentTarget as TreeNode).selected = false;
         if(this.on_deselected != null)
         {
            this.on_deselected((param1.currentTarget as TreeNode).id);
         }
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function select_first_node() : void
      {
         if(this.allNodes.length > 1)
         {
            this.allNodes[1].select(true);
         }
      }
      
      public function selectNode(param1:String) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.allNodes.length)
         {
            if((this.allNodes[_loc2_] as TreeNode).id == param1)
            {
               (this.allNodes[_loc2_] as TreeNode).select(true);
               break;
            }
            _loc2_++;
         }
      }
   }
}
