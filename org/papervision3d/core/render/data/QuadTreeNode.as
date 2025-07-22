package org.papervision3d.core.render.data
{
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   import org.papervision3d.core.render.command.RenderableListItem;
   import org.papervision3d.objects.DisplayObject3D;
   
   public final class QuadTreeNode
   {
      
      public var parent:QuadTreeNode;
      
      public var create:Function;
      
      private var level:int;
      
      public var righttopFlag:Boolean;
      
      public var hasContent:Boolean = false;
      
      public var rightbottom:QuadTreeNode;
      
      public var righttop:QuadTreeNode;
      
      public var rightbottomFlag:Boolean;
      
      public var onlysource:DisplayObject3D;
      
      public var xdiv:Number;
      
      private var halfheight:Number;
      
      public var center:Array;
      
      public var maxlevel:int = 4;
      
      private var render_center_length:int = -1;
      
      public var onlysourceFlag:Boolean = true;
      
      private var render_center_index:int = -1;
      
      private var halfwidth:Number;
      
      public var lefttop:QuadTreeNode;
      
      public var ydiv:Number;
      
      public var leftbottom:QuadTreeNode;
      
      public var lefttopFlag:Boolean;
      
      public var leftbottomFlag:Boolean;
      
      public function QuadTreeNode(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:QuadTreeNode = null, param7:uint = 4)
      {
         super();
         this.level = param5;
         this.xdiv = param1;
         this.ydiv = param2;
         halfwidth = param3 / 2;
         halfheight = param4 / 2;
         this.parent = param6;
         this.maxlevel = param7;
      }
      
      public function reset(param1:Number, param2:Number, param3:Number, param4:Number, param5:uint) : void
      {
         this.xdiv = param1;
         this.ydiv = param2;
         halfwidth = param3 / 2;
         halfheight = param4 / 2;
         lefttopFlag = false;
         leftbottomFlag = false;
         righttopFlag = false;
         rightbottomFlag = false;
         onlysourceFlag = true;
         onlysource = null;
         render_center_length = -1;
         render_center_index = -1;
         hasContent = false;
         maxlevel = param5;
      }
      
      public function push(param1:RenderableListItem) : void
      {
         hasContent = true;
         if(onlysourceFlag)
         {
            if(onlysource != null && onlysource != param1.instance)
            {
               onlysourceFlag = false;
            }
            onlysource = param1.instance;
         }
         if(level < maxlevel)
         {
            if(param1.maxX <= xdiv)
            {
               if(param1.maxY <= ydiv)
               {
                  if(lefttop == null)
                  {
                     lefttopFlag = true;
                     lefttop = new QuadTreeNode(xdiv - halfwidth / 2,ydiv - halfheight / 2,halfwidth,halfheight,level + 1,this,maxlevel);
                  }
                  else if(!lefttopFlag)
                  {
                     lefttopFlag = true;
                     lefttop.reset(xdiv - halfwidth / 2,ydiv - halfheight / 2,halfwidth,halfheight,maxlevel);
                  }
                  lefttop.push(param1);
                  return;
               }
               if(param1.minY >= ydiv)
               {
                  if(leftbottom == null)
                  {
                     leftbottomFlag = true;
                     leftbottom = new QuadTreeNode(xdiv - halfwidth / 2,ydiv + halfheight / 2,halfwidth,halfheight,level + 1,this,maxlevel);
                  }
                  else if(!leftbottomFlag)
                  {
                     leftbottomFlag = true;
                     leftbottom.reset(xdiv - halfwidth / 2,ydiv + halfheight / 2,halfwidth,halfheight,maxlevel);
                  }
                  leftbottom.push(param1);
                  return;
               }
            }
            else if(param1.minX >= xdiv)
            {
               if(param1.maxY <= ydiv)
               {
                  if(righttop == null)
                  {
                     righttopFlag = true;
                     righttop = new QuadTreeNode(xdiv + halfwidth / 2,ydiv - halfheight / 2,halfwidth,halfheight,level + 1,this,maxlevel);
                  }
                  else if(!righttopFlag)
                  {
                     righttopFlag = true;
                     righttop.reset(xdiv + halfwidth / 2,ydiv - halfheight / 2,halfwidth,halfheight,maxlevel);
                  }
                  righttop.push(param1);
                  return;
               }
               if(param1.minY >= ydiv)
               {
                  if(rightbottom == null)
                  {
                     rightbottomFlag = true;
                     rightbottom = new QuadTreeNode(xdiv + halfwidth / 2,ydiv + halfheight / 2,halfwidth,halfheight,level + 1,this,maxlevel);
                  }
                  else if(!rightbottomFlag)
                  {
                     rightbottomFlag = true;
                     rightbottom.reset(xdiv + halfwidth / 2,ydiv + halfheight / 2,halfwidth,halfheight,maxlevel);
                  }
                  rightbottom.push(param1);
                  return;
               }
            }
         }
         if(center == null)
         {
            center = new Array();
         }
         center.push(param1);
         param1.quadrant = this;
      }
      
      public function render(param1:Number, param2:RenderSessionData, param3:Graphics) : void
      {
         var _loc4_:RenderableListItem = null;
         if(render_center_length == -1)
         {
            if(center != null)
            {
               render_center_length = center.length;
               if(render_center_length > 1)
               {
                  center.sortOn("screenZ",Array.DESCENDING | Array.NUMERIC);
               }
            }
            else
            {
               render_center_length = 0;
            }
            render_center_index = 0;
         }
         while(render_center_index < render_center_length)
         {
            _loc4_ = center[render_center_index];
            if(_loc4_.screenZ < param1)
            {
               break;
            }
            render_other(_loc4_.screenZ,param2,param3);
            _loc4_.render(param2,param3);
            param2.viewPort.lastRenderList.push(_loc4_);
            ++render_center_index;
         }
         if(render_center_index == render_center_length)
         {
            center = null;
         }
         render_other(param1,param2,param3);
      }
      
      public function getRect() : Rectangle
      {
         return new Rectangle(xdiv,ydiv,halfwidth * 2,halfheight * 2);
      }
      
      private function render_other(param1:Number, param2:RenderSessionData, param3:Graphics) : void
      {
         if(lefttopFlag)
         {
            lefttop.render(param1,param2,param3);
         }
         if(leftbottomFlag)
         {
            leftbottom.render(param1,param2,param3);
         }
         if(righttopFlag)
         {
            righttop.render(param1,param2,param3);
         }
         if(rightbottomFlag)
         {
            rightbottom.render(param1,param2,param3);
         }
      }
   }
}

