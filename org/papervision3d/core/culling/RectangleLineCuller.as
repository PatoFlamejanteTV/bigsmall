package org.papervision3d.core.culling
{
   import flash.geom.Rectangle;
   import org.papervision3d.core.geom.renderables.Line3D;
   import org.papervision3d.core.math.util.FastRectangleTools;
   
   public class RectangleLineCuller implements ILineCuller
   {
      
      private var lineBoundsRect:Rectangle;
      
      private var rectIntersection:Rectangle;
      
      private var cullingRectangle:Rectangle;
      
      public function RectangleLineCuller(param1:Rectangle = null)
      {
         super();
         if(param1)
         {
            this.cullingRectangle = param1;
         }
         lineBoundsRect = new Rectangle();
         rectIntersection = new Rectangle();
      }
      
      public function testLine(param1:Line3D) : Boolean
      {
         if(!param1.v0.vertex3DInstance.visible || !param1.v1.vertex3DInstance.visible)
         {
            return false;
         }
         var _loc2_:Number = param1.v0.vertex3DInstance.x;
         var _loc3_:Number = param1.v0.vertex3DInstance.y;
         var _loc4_:Number = param1.v1.vertex3DInstance.x;
         var _loc5_:Number = param1.v1.vertex3DInstance.y;
         lineBoundsRect.width = Math.abs(_loc4_ - _loc2_);
         lineBoundsRect.height = Math.abs(_loc5_ - _loc3_);
         if(_loc2_ < _loc4_)
         {
            lineBoundsRect.x = _loc2_;
         }
         else
         {
            lineBoundsRect.x = _loc4_;
         }
         if(_loc3_ < _loc5_)
         {
            lineBoundsRect.y = _loc3_;
         }
         else
         {
            lineBoundsRect.y = _loc5_;
         }
         if(cullingRectangle.containsRect(lineBoundsRect))
         {
            return true;
         }
         if(!FastRectangleTools.intersects(lineBoundsRect,cullingRectangle))
         {
            return false;
         }
         rectIntersection = FastRectangleTools.intersection(lineBoundsRect,cullingRectangle);
         var _loc6_:Number = (_loc5_ - _loc3_) / (_loc4_ - _loc2_);
         var _loc7_:Number = _loc3_ - _loc6_ * _loc2_;
         var _loc8_:Number = (cullingRectangle.top - _loc7_) / _loc6_;
         if(_loc8_ > rectIntersection.left && _loc8_ < rectIntersection.right)
         {
            return true;
         }
         _loc8_ = (cullingRectangle.bottom - _loc7_) / _loc6_;
         if(_loc8_ > rectIntersection.left && _loc8_ < rectIntersection.right)
         {
            return true;
         }
         var _loc9_:Number = _loc6_ * cullingRectangle.left + _loc7_;
         if(_loc9_ > rectIntersection.top && _loc9_ < rectIntersection.bottom)
         {
            return true;
         }
         _loc9_ = _loc6_ * cullingRectangle.right + _loc7_;
         if(_loc9_ > rectIntersection.top && _loc9_ < rectIntersection.bottom)
         {
            return true;
         }
         return false;
      }
   }
}

