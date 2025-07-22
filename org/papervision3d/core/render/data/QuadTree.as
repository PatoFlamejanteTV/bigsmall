package org.papervision3d.core.render.data
{
   import flash.display.Graphics;
   import org.papervision3d.core.clipping.draw.Clipping;
   import org.papervision3d.core.clipping.draw.RectangleClipping;
   import org.papervision3d.core.render.command.RenderableListItem;
   import org.papervision3d.objects.DisplayObject3D;
   
   public final class QuadTree
   {
      
      private var _root:QuadTreeNode;
      
      private var _rect:RectangleClipping;
      
      private var _result:Array;
      
      private var _maxlevel:uint = 4;
      
      private var _maxX:Number;
      
      private var _maxY:Number;
      
      private var _child:RenderableListItem;
      
      private var _children:Array;
      
      private var _minX:Number;
      
      private var _minY:Number;
      
      private var i:int;
      
      private var _clip:Clipping;
      
      private var _center:Array;
      
      private var _except:DisplayObject3D;
      
      public function QuadTree()
      {
         super();
      }
      
      public function get maxLevel() : uint
      {
         return _maxlevel;
      }
      
      public function remove(param1:RenderableListItem) : void
      {
         _center = param1.quadrant.center;
         _center.splice(_center.indexOf(param1),1);
      }
      
      public function set maxLevel(param1:uint) : void
      {
         _maxlevel = param1;
         if(_root)
         {
            _root.maxlevel = _maxlevel;
         }
      }
      
      public function getOverlaps(param1:RenderableListItem, param2:DisplayObject3D = null) : Array
      {
         _result = [];
         _minX = param1.minX;
         _minY = param1.minY;
         _maxX = param1.maxX;
         _maxY = param1.maxY;
         _except = param2;
         getList(param1.quadrant);
         getParent(param1.quadrant);
         return _result;
      }
      
      public function get clip() : Clipping
      {
         return _clip;
      }
      
      public function render(param1:RenderSessionData, param2:Graphics) : void
      {
         _root.render(-Infinity,param1,param2);
      }
      
      public function list() : Array
      {
         _result = [];
         _minX = -1000000;
         _minY = -1000000;
         _maxX = 1000000;
         _maxY = 1000000;
         _except = null;
         getList(_root);
         return _result;
      }
      
      public function getRoot() : QuadTreeNode
      {
         return _root;
      }
      
      private function getList(param1:QuadTreeNode) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.onlysourceFlag && _except == param1.onlysource)
         {
            return;
         }
         if(_minX < param1.xdiv)
         {
            if(param1.lefttopFlag && _minY < param1.ydiv)
            {
               getList(param1.lefttop);
            }
            if(param1.leftbottomFlag && _maxY > param1.ydiv)
            {
               getList(param1.leftbottom);
            }
         }
         if(_maxX > param1.xdiv)
         {
            if(param1.righttopFlag && _minY < param1.ydiv)
            {
               getList(param1.righttop);
            }
            if(param1.rightbottomFlag && _maxY > param1.ydiv)
            {
               getList(param1.rightbottom);
            }
         }
         _children = param1.center;
         if(_children != null)
         {
            i = _children.length;
            while(i--)
            {
               _child = _children[i];
               if((_except == null || _child.instance != _except) && _child.maxX > _minX && _child.minX < _maxX && _child.maxY > _minY && _child.minY < _maxY)
               {
                  _result.push(_child);
               }
            }
         }
      }
      
      private function getParent(param1:QuadTreeNode = null) : void
      {
         if(!param1)
         {
            return;
         }
         param1 = param1.parent;
         if(param1 == null || param1.onlysourceFlag && _except == param1.onlysource)
         {
            return;
         }
         _children = param1.center;
         if(_children != null)
         {
            i = _children.length;
            while(i--)
            {
               _child = _children[i];
               if((_except == null || _child.instance != _except) && _child.maxX > _minX && _child.minX < _maxX && _child.maxY > _minY && _child.minY < _maxY)
               {
                  _result.push(_child);
               }
            }
         }
         getParent(param1);
      }
      
      public function add(param1:RenderableListItem) : void
      {
         if(_clip.check(param1))
         {
            _root.push(param1);
         }
      }
      
      public function set clip(param1:Clipping) : void
      {
         _clip = param1;
         _rect = _clip.asRectangleClipping();
         if(!_root)
         {
            _root = new QuadTreeNode((_rect.minX + _rect.maxX) / 2,(_rect.minY + _rect.maxY) / 2,_rect.maxX - _rect.minX,_rect.maxY - _rect.minY,0,null,_maxlevel);
         }
         else
         {
            _root.reset((_rect.minX + _rect.maxX) / 2,(_rect.minY + _rect.maxY) / 2,_rect.maxX - _rect.minX,_rect.maxY - _rect.minY,_maxlevel);
         }
      }
   }
}

