package org.papervision3d.core.clipping.draw
{
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.geom.Point;
   import org.papervision3d.core.render.command.RenderableListItem;
   
   public class Clipping
   {
      
      public var minX:Number = -1000000;
      
      public var minY:Number = -1000000;
      
      private var zeroPoint:Point = new Point(0,0);
      
      private var globalPoint:Point;
      
      private var rectangleClipping:RectangleClipping;
      
      public var maxX:Number = 1000000;
      
      public var maxY:Number = 1000000;
      
      public function Clipping()
      {
         super();
      }
      
      public function rect(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
      {
         return true;
      }
      
      public function screen(param1:Sprite) : Clipping
      {
         if(!rectangleClipping)
         {
            rectangleClipping = new RectangleClipping();
         }
         switch(param1.stage.align)
         {
            case StageAlign.TOP_LEFT:
               zeroPoint.x = 0;
               zeroPoint.y = 0;
               globalPoint = param1.globalToLocal(zeroPoint);
               rectangleClipping.maxX = (rectangleClipping.minX = globalPoint.x) + param1.stage.stageWidth;
               rectangleClipping.maxY = (rectangleClipping.minY = globalPoint.y) + param1.stage.stageHeight;
               break;
            case StageAlign.TOP_RIGHT:
               zeroPoint.x = param1.stage.stageWidth;
               zeroPoint.y = 0;
               globalPoint = param1.globalToLocal(zeroPoint);
               rectangleClipping.minX = (rectangleClipping.maxX = globalPoint.x) - param1.stage.stageWidth;
               rectangleClipping.maxY = (rectangleClipping.minY = globalPoint.y) + param1.stage.stageHeight;
               break;
            case StageAlign.BOTTOM_LEFT:
               zeroPoint.x = 0;
               zeroPoint.y = param1.stage.stageHeight;
               globalPoint = param1.globalToLocal(zeroPoint);
               rectangleClipping.maxX = (rectangleClipping.minX = globalPoint.x) + param1.stage.stageWidth;
               rectangleClipping.minY = (rectangleClipping.maxY = globalPoint.y) - param1.stage.stageHeight;
               break;
            case StageAlign.BOTTOM_RIGHT:
               zeroPoint.x = param1.stage.stageWidth;
               zeroPoint.y = param1.stage.stageHeight;
               globalPoint = param1.globalToLocal(zeroPoint);
               rectangleClipping.minX = (rectangleClipping.maxX = globalPoint.x) - param1.stage.stageWidth;
               rectangleClipping.minY = (rectangleClipping.maxY = globalPoint.y) - param1.stage.stageHeight;
               break;
            case StageAlign.TOP:
               zeroPoint.x = param1.stage.stageWidth / 2;
               zeroPoint.y = 0;
               globalPoint = param1.globalToLocal(zeroPoint);
               rectangleClipping.minX = globalPoint.x - param1.stage.stageWidth / 2;
               rectangleClipping.maxX = globalPoint.x + param1.stage.stageWidth / 2;
               rectangleClipping.maxY = (rectangleClipping.minY = globalPoint.y) + param1.stage.stageHeight;
               break;
            case StageAlign.BOTTOM:
               zeroPoint.x = param1.stage.stageWidth / 2;
               zeroPoint.y = param1.stage.stageHeight;
               globalPoint = param1.globalToLocal(zeroPoint);
               rectangleClipping.minX = globalPoint.x - param1.stage.stageWidth / 2;
               rectangleClipping.maxX = globalPoint.x + param1.stage.stageWidth / 2;
               rectangleClipping.minY = (rectangleClipping.maxY = globalPoint.y) - param1.stage.stageHeight;
               break;
            case StageAlign.LEFT:
               zeroPoint.x = 0;
               zeroPoint.y = param1.stage.stageHeight / 2;
               globalPoint = param1.globalToLocal(zeroPoint);
               rectangleClipping.maxX = (rectangleClipping.minX = globalPoint.x) + param1.stage.stageWidth;
               rectangleClipping.minY = globalPoint.y - param1.stage.stageHeight / 2;
               rectangleClipping.maxY = globalPoint.y + param1.stage.stageHeight / 2;
               break;
            case StageAlign.RIGHT:
               zeroPoint.x = param1.stage.stageWidth;
               zeroPoint.y = param1.stage.stageHeight / 2;
               globalPoint = param1.globalToLocal(zeroPoint);
               rectangleClipping.minX = (rectangleClipping.maxX = globalPoint.x) - param1.stage.stageWidth;
               rectangleClipping.minY = globalPoint.y - param1.stage.stageHeight / 2;
               rectangleClipping.maxY = globalPoint.y + param1.stage.stageHeight / 2;
               break;
            default:
               zeroPoint.x = param1.stage.stageWidth / 2;
               zeroPoint.y = param1.stage.stageHeight / 2;
               globalPoint = param1.globalToLocal(zeroPoint);
               rectangleClipping.minX = globalPoint.x - param1.stage.stageWidth / 2;
               rectangleClipping.maxX = globalPoint.x + param1.stage.stageWidth / 2;
               rectangleClipping.minY = globalPoint.y - param1.stage.stageHeight / 2;
               rectangleClipping.maxY = globalPoint.y + param1.stage.stageHeight / 2;
         }
         return rectangleClipping;
      }
      
      public function check(param1:RenderableListItem) : Boolean
      {
         return true;
      }
      
      public function asRectangleClipping() : RectangleClipping
      {
         if(!rectangleClipping)
         {
            rectangleClipping = new RectangleClipping();
         }
         rectangleClipping.minX = -1000000;
         rectangleClipping.minY = -1000000;
         rectangleClipping.maxX = 1000000;
         rectangleClipping.maxY = 1000000;
         return rectangleClipping;
      }
   }
}

