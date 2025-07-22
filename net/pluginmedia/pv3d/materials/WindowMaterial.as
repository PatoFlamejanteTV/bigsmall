package net.pluginmedia.pv3d.materials
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.materials.BitmapMaterial;
   
   public class WindowMaterial extends BitmapMaterial
   {
      
      public var distanceVertex:Vertex3D;
      
      public var scale:Number;
      
      private var y2:Number;
      
      private var y0:Number;
      
      private var y1:Number;
      
      private var x1:Number;
      
      private var x2:Number;
      
      private var x0:Number;
      
      public function WindowMaterial(param1:* = null, param2:Number = 1, param3:Boolean = false, param4:int = 0)
      {
         var _loc5_:BitmapData = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Matrix = null;
         if(param1 is DisplayObject)
         {
            _loc6_ = param1 as DisplayObject;
            _loc5_ = new BitmapData(_loc6_.width,_loc6_.height,param3,param4);
            _loc7_ = _loc6_.getBounds(_loc6_);
            _loc8_ = new Matrix();
            _loc8_.translate(-_loc7_.left,-_loc7_.top);
            _loc5_.draw(_loc6_,_loc8_);
         }
         else if(param1 is BitmapData)
         {
            _loc5_ = param1 as BitmapData;
         }
         else
         {
            PaperLogger.error("WindowMaterial sent neither DisplayObject or Bitmapdata");
         }
         super(_loc5_,false);
         this.scale = param2;
      }
      
      public function setDistanceVertex(param1:Vertex3D) : void
      {
         distanceVertex = param1;
      }
      
      override public function drawTriangle(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData, param4:BitmapData = null, param5:Matrix = null) : void
      {
         param4 = param4 ? param4 : bitmap;
         _triMap = param5 ? param5 : uvMatrices[param1] || transformUVRT(param1);
         if(!_precise || !_triMap)
         {
            if(lineAlpha)
            {
               param2.lineStyle(lineThickness,lineColor,lineAlpha);
            }
            if(bitmap)
            {
               x0 = param1.v0.x;
               y0 = param1.v0.y;
               x1 = param1.v1.x;
               y1 = param1.v1.y;
               x2 = param1.v2.x;
               y2 = param1.v2.y;
               _localMatrix.identity();
               _localMatrix.translate(param4.width * -0.5,param4.height * -0.5);
               _localMatrix.scale(scale,scale);
               if(distanceVertex)
               {
                  _localMatrix.translate(distanceVertex.vertex3DInstance.x,distanceVertex.vertex3DInstance.y);
               }
               param2.beginBitmapFill(param4,_localMatrix,true,smooth);
            }
            param2.moveTo(x0,y0);
            param2.lineTo(x1,y1);
            param2.lineTo(x2,y2);
            param2.lineTo(x0,y0);
            if(bitmap)
            {
               param2.endFill();
            }
            if(lineAlpha)
            {
               param2.lineStyle();
            }
            ++param3.renderStatistics.triangles;
         }
         else if(bitmap)
         {
            focus = param3.camera.focus;
            tempPreBmp = param4 ? param4 : bitmap;
            tempPreRSD = param3;
            tempPreGrp = param2;
            cullRect = param3.viewPort.cullingRectangle;
            renderRec(_triMap,param1.v0,param1.v1,param1.v2,0);
         }
      }
   }
}

