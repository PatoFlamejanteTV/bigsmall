package net.pluginmedia.pv3d.materials
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   
   public class MirrorMaterial extends WindowMaterial
   {
      
      private var x1:Number;
      
      private var y1:Number;
      
      private var y0:Number;
      
      private var x0:Number;
      
      private var y2:Number;
      
      private var x2:Number;
      
      public function MirrorMaterial(param1:* = null, param2:Number = 1, param3:Boolean = false, param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function drawTriangle(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData, param4:BitmapData = null, param5:Matrix = null) : void
      {
         var _loc6_:Number = param3.camera.focus * param3.camera.zoom;
         var _loc7_:Number = _loc6_ / (param3.camera.focus + distanceVertex.vertex3DInstance.z);
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
               _localMatrix.scale(scale * _loc7_,scale * _loc7_);
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

