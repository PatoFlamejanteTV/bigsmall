package org.papervision3d.core.render.command
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.NumberUV;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.data.RenderHitData;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   import org.papervision3d.materials.BitmapMaterial;
   import org.papervision3d.materials.MovieMaterial;
   
   public class RenderTriangle extends RenderableListItem implements IRenderListItem
   {
      
      protected static var resBA:Vertex3DInstance = new Vertex3DInstance();
      
      protected static var resPA:Vertex3DInstance = new Vertex3DInstance();
      
      protected static var resRA:Vertex3DInstance = new Vertex3DInstance();
      
      protected static var vPoint:Vertex3DInstance = new Vertex3DInstance();
      
      public var triangle:Triangle3D;
      
      private var bzf:Number;
      
      private var axf:Number;
      
      private var det:Number;
      
      private var v12:Vertex3DInstance;
      
      private var faz:Number;
      
      private var position:Number3D = new Number3D();
      
      private var ayf:Number;
      
      private var au:Number;
      
      private var av:Number;
      
      private var ax:Number;
      
      private var ay:Number;
      
      private var az:Number;
      
      private var v20:Vertex3DInstance;
      
      private var fbz:Number;
      
      private var azf:Number;
      
      private var bu:Number;
      
      private var bv:Number;
      
      private var bx:Number;
      
      private var by:Number;
      
      private var bz:Number;
      
      private var fcz:Number;
      
      private var uv01:NumberUV;
      
      private var cu:Number;
      
      private var cv:Number;
      
      private var cx:Number;
      
      private var cy:Number;
      
      private var cz:Number;
      
      public var v0:Vertex3DInstance;
      
      public var v1:Vertex3DInstance;
      
      private var da:Number;
      
      private var db:Number;
      
      private var dc:Number;
      
      public var container:Sprite;
      
      private var uv12:NumberUV;
      
      public var v2:Vertex3DInstance;
      
      private var cxf:Number;
      
      private var uv20:NumberUV;
      
      protected var vx0:Vertex3DInstance;
      
      public var uv0:NumberUV;
      
      public var uv1:NumberUV;
      
      public var uv2:NumberUV;
      
      protected var vx1:Vertex3DInstance;
      
      protected var vx2:Vertex3DInstance;
      
      public var renderer:ITriangleDrawer;
      
      private var cyf:Number;
      
      private var czf:Number;
      
      private var bxf:Number;
      
      protected var vPointL:Vertex3DInstance;
      
      public var renderMat:MaterialObject3D;
      
      private var byf:Number;
      
      private var v01:Vertex3DInstance;
      
      public var create:Function;
      
      public function RenderTriangle(param1:Triangle3D)
      {
         super();
         this.triangle = param1;
         this.instance = param1.instance;
         renderableInstance = param1;
         renderable = Triangle3D;
         this.v0 = param1.v0.vertex3DInstance;
         this.v1 = param1.v1.vertex3DInstance;
         this.v2 = param1.v2.vertex3DInstance;
         this.uv0 = param1.uv0;
         this.uv1 = param1.uv1;
         this.uv2 = param1.uv2;
         this.renderer = param1.material;
         update();
      }
      
      private function deepHitTest(param1:Triangle3D, param2:Vertex3DInstance, param3:RenderHitData) : RenderHitData
      {
         var _loc44_:MovieMaterial = null;
         var _loc45_:Rectangle = null;
         var _loc4_:Vertex3DInstance = param1.v0.vertex3DInstance;
         var _loc5_:Vertex3DInstance = param1.v1.vertex3DInstance;
         var _loc6_:Vertex3DInstance = param1.v2.vertex3DInstance;
         var _loc7_:Number = _loc6_.x - _loc4_.x;
         var _loc8_:Number = _loc6_.y - _loc4_.y;
         var _loc9_:Number = _loc5_.x - _loc4_.x;
         var _loc10_:Number = _loc5_.y - _loc4_.y;
         var _loc11_:Number = param2.x - _loc4_.x;
         var _loc12_:Number = param2.y - _loc4_.y;
         var _loc13_:Number = _loc7_ * _loc7_ + _loc8_ * _loc8_;
         var _loc14_:Number = _loc7_ * _loc9_ + _loc8_ * _loc10_;
         var _loc15_:Number = _loc7_ * _loc11_ + _loc8_ * _loc12_;
         var _loc16_:Number = _loc9_ * _loc9_ + _loc10_ * _loc10_;
         var _loc17_:Number = _loc9_ * _loc11_ + _loc10_ * _loc12_;
         var _loc18_:Number = 1 / (_loc13_ * _loc16_ - _loc14_ * _loc14_);
         var _loc19_:Number = (_loc16_ * _loc15_ - _loc14_ * _loc17_) * _loc18_;
         var _loc20_:Number = (_loc13_ * _loc17_ - _loc14_ * _loc15_) * _loc18_;
         var _loc21_:Number = param1.v2.x - param1.v0.x;
         var _loc22_:Number = param1.v2.y - param1.v0.y;
         var _loc23_:Number = param1.v2.z - param1.v0.z;
         var _loc24_:Number = param1.v1.x - param1.v0.x;
         var _loc25_:Number = param1.v1.y - param1.v0.y;
         var _loc26_:Number = param1.v1.z - param1.v0.z;
         var _loc27_:Number = param1.v0.x + _loc21_ * _loc19_ + _loc24_ * _loc20_;
         var _loc28_:Number = param1.v0.y + _loc22_ * _loc19_ + _loc25_ * _loc20_;
         var _loc29_:Number = param1.v0.z + _loc23_ * _loc19_ + _loc26_ * _loc20_;
         var _loc30_:Array = param1.uv;
         var _loc31_:Number = Number(_loc30_[0].u);
         var _loc32_:Number = Number(_loc30_[1].u);
         var _loc33_:Number = Number(_loc30_[2].u);
         var _loc34_:Number = Number(_loc30_[0].v);
         var _loc35_:Number = Number(_loc30_[1].v);
         var _loc36_:Number = Number(_loc30_[2].v);
         var _loc37_:Number = (_loc32_ - _loc31_) * _loc20_ + (_loc33_ - _loc31_) * _loc19_ + _loc31_;
         var _loc38_:Number = (_loc35_ - _loc34_) * _loc20_ + (_loc36_ - _loc34_) * _loc19_ + _loc34_;
         if(triangle.material)
         {
            renderMat = param1.material;
         }
         else
         {
            renderMat = param1.instance.material;
         }
         var _loc39_:BitmapData = renderMat.bitmap;
         var _loc40_:Number = 1;
         var _loc41_:Number = 1;
         var _loc42_:Number = 0;
         var _loc43_:Number = 0;
         if(renderMat is MovieMaterial)
         {
            _loc44_ = renderMat as MovieMaterial;
            _loc45_ = _loc44_.rect;
            if(_loc45_)
            {
               _loc42_ = _loc45_.x;
               _loc43_ = _loc45_.y;
               _loc40_ = _loc45_.width;
               _loc41_ = _loc45_.height;
            }
         }
         else if(_loc39_)
         {
            _loc40_ = BitmapMaterial.AUTO_MIP_MAPPING ? renderMat.widthOffset : _loc39_.width;
            _loc41_ = BitmapMaterial.AUTO_MIP_MAPPING ? renderMat.heightOffset : _loc39_.height;
         }
         param3.displayObject3D = param1.instance;
         param3.material = renderMat;
         param3.renderable = param1;
         param3.hasHit = true;
         position.x = _loc27_;
         position.y = _loc28_;
         position.z = _loc29_;
         Matrix3D.multiplyVector(param1.instance.world,position);
         param3.x = position.x;
         param3.y = position.y;
         param3.z = position.z;
         param3.u = _loc37_ * _loc40_ + _loc42_;
         param3.v = _loc41_ - _loc38_ * _loc41_ + _loc43_;
         return param3;
      }
      
      override public function hitTestPoint2D(param1:Point, param2:RenderHitData) : RenderHitData
      {
         renderMat = triangle.material;
         if(!renderMat)
         {
            renderMat = triangle.instance.material;
         }
         if(Boolean(renderMat) && renderMat.interactive)
         {
            vPointL = RenderTriangle.vPoint;
            vPointL.x = param1.x;
            vPointL.y = param1.y;
            vx0 = triangle.v0.vertex3DInstance;
            vx1 = triangle.v1.vertex3DInstance;
            vx2 = triangle.v2.vertex3DInstance;
            if(sameSide(vPointL,vx0,vx1,vx2))
            {
               if(sameSide(vPointL,vx1,vx0,vx2))
               {
                  if(sameSide(vPointL,vx2,vx0,vx1))
                  {
                     return deepHitTest(triangle,vPointL,param2);
                  }
               }
            }
         }
         return param2;
      }
      
      public function fivepointcut(param1:Vertex3DInstance, param2:Vertex3DInstance, param3:Vertex3DInstance, param4:Vertex3DInstance, param5:Vertex3DInstance, param6:NumberUV, param7:NumberUV, param8:NumberUV, param9:NumberUV, param10:NumberUV) : Array
      {
         if(param1.distanceSqr(param4) < param2.distanceSqr(param5))
         {
            return [create(renderableInstance,renderer,param1,param2,param4,param6,param7,param9),create(renderableInstance,renderer,param2,param3,param4,param7,param8,param9),create(renderableInstance,renderer,param1,param4,param5,param6,param9,param10)];
         }
         return [create(renderableInstance,renderer,param1,param2,param5,param6,param7,param10),create(renderableInstance,renderer,param2,param3,param4,param7,param8,param9),create(renderableInstance,renderer,param2,param4,param5,param7,param9,param10)];
      }
      
      override public function render(param1:RenderSessionData, param2:Graphics) : void
      {
         renderer.drawTriangle(this,param2,param1);
      }
      
      final override public function quarter(param1:Number) : Array
      {
         if(area < 20)
         {
            return null;
         }
         v01 = Vertex3DInstance.median(v0,v1,param1);
         v12 = Vertex3DInstance.median(v1,v2,param1);
         v20 = Vertex3DInstance.median(v2,v0,param1);
         uv01 = NumberUV.median(uv0,uv1);
         uv12 = NumberUV.median(uv1,uv2);
         uv20 = NumberUV.median(uv2,uv0);
         return [create(renderableInstance,renderer,v0,v01,v20,uv0,uv01,uv20),create(renderableInstance,renderer,v1,v12,v01,uv1,uv12,uv01),create(renderableInstance,renderer,v2,v20,v12,uv2,uv20,uv12),create(renderableInstance,renderer,v01,v12,v20,uv01,uv12,uv20)];
      }
      
      final override public function getZ(param1:Number, param2:Number, param3:Number) : Number
      {
         ax = v0.x;
         ay = v0.y;
         az = v0.z;
         bx = v1.x;
         by = v1.y;
         bz = v1.z;
         cx = v2.x;
         cy = v2.y;
         cz = v2.z;
         if(ax == param1 && ay == param2)
         {
            return az;
         }
         if(bx == param1 && by == param2)
         {
            return bz;
         }
         if(cx == param1 && cy == param2)
         {
            return cz;
         }
         azf = az / param3;
         bzf = bz / param3;
         czf = cz / param3;
         faz = 1 + azf;
         fbz = 1 + bzf;
         fcz = 1 + czf;
         axf = ax * faz - param1 * azf;
         bxf = bx * fbz - param1 * bzf;
         cxf = cx * fcz - param1 * czf;
         ayf = ay * faz - param2 * azf;
         byf = by * fbz - param2 * bzf;
         cyf = cy * fcz - param2 * czf;
         det = axf * (byf - cyf) + bxf * (cyf - ayf) + cxf * (ayf - byf);
         da = param1 * (byf - cyf) + bxf * (cyf - param2) + cxf * (param2 - byf);
         db = axf * (param2 - cyf) + param1 * (cyf - ayf) + cxf * (ayf - param2);
         dc = axf * (byf - param2) + bxf * (param2 - ayf) + param1 * (ayf - byf);
         return (da * az + db * bz + dc * cz) / det;
      }
      
      override public function update() : void
      {
         if(v0.x > v1.x)
         {
            if(v0.x > v2.x)
            {
               maxX = v0.x;
            }
            else
            {
               maxX = v2.x;
            }
         }
         else if(v1.x > v2.x)
         {
            maxX = v1.x;
         }
         else
         {
            maxX = v2.x;
         }
         if(v0.x < v1.x)
         {
            if(v0.x < v2.x)
            {
               minX = v0.x;
            }
            else
            {
               minX = v2.x;
            }
         }
         else if(v1.x < v2.x)
         {
            minX = v1.x;
         }
         else
         {
            minX = v2.x;
         }
         if(v0.y > v1.y)
         {
            if(v0.y > v2.y)
            {
               maxY = v0.y;
            }
            else
            {
               maxY = v2.y;
            }
         }
         else if(v1.y > v2.y)
         {
            maxY = v1.y;
         }
         else
         {
            maxY = v2.y;
         }
         if(v0.y < v1.y)
         {
            if(v0.y < v2.y)
            {
               minY = v0.y;
            }
            else
            {
               minY = v2.y;
            }
         }
         else if(v1.y < v2.y)
         {
            minY = v1.y;
         }
         else
         {
            minY = v2.y;
         }
         if(v0.z > v1.z)
         {
            if(v0.z > v2.z)
            {
               maxZ = v0.z;
            }
            else
            {
               maxZ = v2.z;
            }
         }
         else if(v1.z > v2.z)
         {
            maxZ = v1.z;
         }
         else
         {
            maxZ = v2.z;
         }
         if(v0.z < v1.z)
         {
            if(v0.z < v2.z)
            {
               minZ = v0.z;
            }
            else
            {
               minZ = v2.z;
            }
         }
         else if(v1.z < v2.z)
         {
            minZ = v1.z;
         }
         else
         {
            minZ = v2.z;
         }
         screenZ = (v0.z + v1.z + v2.z) / 3;
         area = 0.5 * (v0.x * (v2.y - v1.y) + v1.x * (v0.y - v2.y) + v2.x * (v1.y - v0.y));
      }
      
      public function sameSide(param1:Vertex3DInstance, param2:Vertex3DInstance, param3:Vertex3DInstance, param4:Vertex3DInstance) : Boolean
      {
         Vertex3DInstance.subTo(param4,param3,resBA);
         Vertex3DInstance.subTo(param1,param3,resPA);
         Vertex3DInstance.subTo(param2,param3,resRA);
         return Vertex3DInstance.cross(resBA,resPA) * Vertex3DInstance.cross(resBA,resRA) >= 0;
      }
   }
}

