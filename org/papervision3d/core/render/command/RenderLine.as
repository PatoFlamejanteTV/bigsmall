package org.papervision3d.core.render.command
{
   import flash.display.Graphics;
   import flash.geom.Point;
   import org.papervision3d.core.geom.renderables.Line3D;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.math.Number2D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.materials.special.LineMaterial;
   
   public class RenderLine extends RenderableListItem implements IRenderListItem
   {
      
      private static var lineVector:Number3D = Number3D.ZERO;
      
      private static var mouseVector:Number3D = Number3D.ZERO;
      
      public var size:Number;
      
      private var fbz:Number;
      
      private var db:Number;
      
      private var bzf:Number;
      
      private var axf:Number;
      
      public var v1:Vertex3DInstance;
      
      private var dx:Number;
      
      private var dy:Number;
      
      private var faz:Number;
      
      private var det:Number;
      
      private var ayf:Number;
      
      private var da:Number;
      
      private var ax:Number;
      
      private var ay:Number;
      
      private var az:Number;
      
      public var renderer:LineMaterial;
      
      private var l1:Number2D;
      
      private var l2:Number2D;
      
      private var azf:Number;
      
      private var bxf:Number;
      
      public var cV:Vertex3DInstance;
      
      private var bx:Number;
      
      private var by:Number;
      
      private var bz:Number;
      
      public var length:Number;
      
      private var xfocus:Number;
      
      private var cp3d:Number3D;
      
      private var byf:Number;
      
      private var p:Number2D;
      
      private var v:Number2D;
      
      public var v0:Vertex3DInstance;
      
      public var line:Line3D;
      
      private var yfocus:Number;
      
      public function RenderLine(param1:Line3D)
      {
         super();
         this.renderable = Line3D;
         this.renderableInstance = param1;
         this.line = param1;
         this.instance = param1.instance;
         v0 = param1.v0.vertex3DInstance;
         v1 = param1.v1.vertex3DInstance;
         cV = param1.cV.vertex3DInstance;
         p = new Number2D();
         l1 = new Number2D();
         l2 = new Number2D();
         v = new Number2D();
         cp3d = new Number3D();
      }
      
      override public function render(param1:RenderSessionData, param2:Graphics) : void
      {
         renderer.drawLine(this,param2,param1);
      }
      
      override public function getZ(param1:Number, param2:Number, param3:Number) : Number
      {
         ax = v0.x;
         ay = v0.y;
         az = v0.z;
         bx = v1.x;
         by = v1.y;
         bz = v1.z;
         if(ax == param1 && ay == param2)
         {
            return az;
         }
         if(bx == param1 && by == param2)
         {
            return bz;
         }
         dx = bx - ax;
         dy = by - ay;
         azf = az / param3;
         bzf = bz / param3;
         faz = 1 + azf;
         fbz = 1 + bzf;
         xfocus = param1;
         yfocus = param2;
         axf = ax * faz - param1 * azf;
         bxf = bx * fbz - param1 * bzf;
         ayf = ay * faz - param2 * azf;
         byf = by * fbz - param2 * bzf;
         det = dx * (axf - bxf) + dy * (ayf - byf);
         db = dx * (axf - param1) + dy * (ayf - param2);
         da = dx * (param1 - bxf) + dy * (param2 - byf);
         return (da * az + db * bz) / det;
      }
      
      override public function hitTestPoint2D(param1:Point, param2:RenderHitData) : RenderHitData
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(renderer.interactive)
         {
            _loc3_ = line.size;
            p.reset(param1.x,param1.y);
            l1.reset(line.v0.vertex3DInstance.x,line.v0.vertex3DInstance.y);
            l2.reset(line.v1.vertex3DInstance.x,line.v1.vertex3DInstance.y);
            v.copyFrom(l2);
            v.minusEq(l1);
            _loc4_ = ((p.x - l1.x) * (l2.x - l1.x) + (p.y - l1.y) * (l2.y - l1.y)) / (v.x * v.x + v.y * v.y);
            if(_loc4_ > 0 && _loc4_ < 1)
            {
               v.multiplyEq(_loc4_);
               v.plusEq(l1);
               v.minusEq(p);
               _loc5_ = v.x * v.x + v.y * v.y;
               if(_loc5_ < _loc3_ * _loc3_)
               {
                  param2.displayObject3D = line.instance;
                  param2.material = renderer;
                  param2.renderable = line;
                  param2.hasHit = true;
                  cp3d.reset(line.v1.x - line.v0.x,line.v1.y - line.v0.y,line.v1.x - line.v0.x);
                  cp3d.x *= _loc4_;
                  cp3d.y *= _loc4_;
                  cp3d.z *= _loc4_;
                  cp3d.x += line.v0.x;
                  cp3d.y += line.v0.y;
                  cp3d.z += line.v0.z;
                  param2.x = cp3d.x;
                  param2.y = cp3d.y;
                  param2.z = cp3d.z;
                  param2.u = 0;
                  param2.v = 0;
                  return param2;
               }
            }
         }
         return param2;
      }
   }
}

