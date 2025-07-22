package net.pluginmedia.pv3d.materials.special
{
   import flash.display.Graphics;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.math.Number2D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.render.command.RenderLine;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ILineDrawer;
   import org.papervision3d.materials.special.LineMaterial;
   
   public class LineMaterial3D extends LineMaterial implements ILineDrawer
   {
      
      private var p1:Number2D = new Number2D();
      
      private var p3:Number2D = new Number2D();
      
      private var p2:Number2D = new Number2D();
      
      private var p4:Number2D = new Number2D();
      
      private var vertex1:Number2D = new Number2D();
      
      private var vertex2:Number2D = new Number2D();
      
      private var spur:Number2D = new Number2D();
      
      private var lineVector:Number2D = new Number2D();
      
      public function LineMaterial3D(param1:Number = 16711680, param2:Number = 1)
      {
         super(param1,param2);
      }
      
      public function drawLine3D(param1:Graphics, param2:Vertex3DInstance, param3:Vertex3DInstance, param4:Number, param5:Number) : void
      {
         vertex1.reset(param2.x,param2.y);
         vertex2.reset(param3.x,param3.y);
         lineVector.copyFrom(vertex1);
         lineVector.minusEq(vertex2);
         var _loc6_:Number = lineVector.modulo;
         var _loc7_:Number = Math.acos((param5 - param4) / _loc6_) * Number3D.toDEGREES;
         if(isNaN(_loc7_))
         {
            _loc7_ = 0;
         }
         spur.copyFrom(lineVector);
         spur.divideEq(_loc6_);
         spur.rotate(_loc7_);
         p1.copyFrom(vertex1);
         spur.multiplyEq(param4);
         p1.plusEq(spur);
         p2.copyFrom(vertex2);
         spur.multiplyEq(param5 / param4);
         p2.plusEq(spur);
         spur.rotate(_loc7_ * -2);
         p3.copyFrom(vertex2);
         p3.plusEq(spur);
         spur.multiplyEq(param4 / param5);
         p4.copyFrom(vertex1);
         p4.plusEq(spur);
         param1.lineStyle();
         param1.beginFill(lineColor,lineAlpha);
         param1.moveTo(vertex1.x,vertex1.y);
         param1.lineTo(p1.x,p1.y);
         param1.lineTo(p2.x,p2.y);
         param1.lineTo(vertex2.x,vertex2.y);
         param1.lineTo(p3.x,p3.y);
         param1.lineTo(p4.x,p4.y);
         param1.lineTo(vertex1.x,vertex1.y);
         param1.endFill();
         param1.beginFill(lineColor,lineAlpha);
         param1.drawCircle(vertex1.x,vertex1.y,param4);
         param1.endFill();
         param1.beginFill(lineColor,lineAlpha);
         param1.drawCircle(vertex2.x,vertex2.y,param5);
         param1.endFill();
      }
      
      override public function drawLine(param1:RenderLine, param2:Graphics, param3:RenderSessionData) : void
      {
         var _loc4_:Number = param3.camera.focus * param3.camera.zoom;
         var _loc5_:Number = _loc4_ / (param3.camera.focus + param1.v0.z) * param1.size;
         var _loc6_:Number = _loc4_ / (param3.camera.focus + param1.v1.z) * param1.size;
         param2.lineStyle();
         drawLine3D(param2,param1.v0,param1.v1,_loc5_,_loc6_);
         param2.moveTo(0,0);
      }
   }
}

