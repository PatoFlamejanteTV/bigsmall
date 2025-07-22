package net.pluginmedia.bigandsmall.core.mesh
{
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Reflection extends AnimationPlane
   {
      
      public var sourcePlane:AnimationPlane;
      
      public var colorTransform:ColorTransform = new ColorTransform(0.8,0.8,0.8);
      
      public var topLeft:Point = new Point(0,0);
      
      public var blurFilter:BlurFilter = new BlurFilter(8,2,1);
      
      public function Reflection(param1:AnimationPlane, param2:Number = 1, param3:Number = 1)
      {
         sourcePlane = param1;
         super(sourcePlane.movie,sourcePlane.drawScaleX,sourcePlane.drawScaleY,sourcePlane.segmentsW,sourcePlane.segmentsH);
         drawScaleX = param2;
         drawScaleY = param3;
         pMat.opposite = true;
      }
      
      override public function project(param1:DisplayObject3D, param2:RenderSessionData) : Number
      {
         updateMesh();
         _isPlaying = false;
         return super.project(param1,param2);
      }
      
      override public function updateMesh() : void
      {
         var _loc6_:Vertex3D = null;
         var _loc7_:Vertex3D = null;
         bounds = sourcePlane.bounds.clone();
         bounds.left *= drawScaleX;
         bounds.right *= drawScaleX;
         bounds.top *= drawScaleY;
         bounds.bottom *= drawScaleY;
         pMat.bitmap = bitmapData = getNewBitmapData(bounds.width,bounds.height,bitmapData);
         bitmapData.lock();
         var _loc1_:int = int(startPoints.length);
         var _loc2_:Array = sourcePlane.geometry.vertices;
         var _loc3_:Array = geometry.vertices;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc6_ = _loc2_[_loc4_];
            _loc7_ = _loc3_[_loc4_];
            _loc7_.x = _loc6_.x;
            _loc7_.y = -_loc6_.y;
            _loc4_++;
         }
         pMat.maxU = bounds.width / bitmapData.width;
         pMat.maxV = bounds.height / bitmapData.height;
         bitmapData.fillRect(bitmapData.rect,0);
         var _loc5_:Matrix = new Matrix();
         _loc5_.scale(drawScaleX,drawScaleY);
         bitmapData.draw(sourcePlane.bitmapData,_loc5_,colorTransform);
         if(blurFilter)
         {
            fillRect.x = fillRect.y = 0;
            fillRect.width = bounds.width;
            fillRect.height = bounds.height;
            bitmapData.applyFilter(bitmapData,fillRect,topLeft,blurFilter);
         }
         _dirtyMesh = false;
         geometry.dirty = true;
         geometry.ready = true;
         pMat.resetUVS();
         bitmapData.unlock();
      }
   }
}

