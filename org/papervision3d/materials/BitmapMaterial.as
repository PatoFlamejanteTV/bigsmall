package org.papervision3d.materials
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import org.papervision3d.Papervision3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.material.TriangleMaterial;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.command.RenderTriangle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.ITriangleDrawer;
   import org.papervision3d.materials.utils.PrecisionMode;
   import org.papervision3d.materials.utils.RenderRecStorage;
   
   public class BitmapMaterial extends TriangleMaterial implements ITriangleDrawer
   {
      
      protected static var _triMap:Matrix;
      
      protected static const DEFAULT_FOCUS:Number = 200;
      
      protected static var hitRect:Rectangle = new Rectangle();
      
      public static var AUTO_MIP_MAPPING:Boolean = false;
      
      public static var MIP_MAP_DEPTH:Number = 8;
      
      protected static var _triMatrix:Matrix = new Matrix();
      
      protected static var _localMatrix:Matrix = new Matrix();
      
      protected var renderRecStorage:Array;
      
      protected var dsbc:Number;
      
      private var d2bc:Number;
      
      private var b2:Number;
      
      public var uvMatrices:Dictionary = new Dictionary();
      
      protected var _precise:Boolean;
      
      protected var faz:Number;
      
      protected var dsca:Number;
      
      protected var ax:Number;
      
      protected var ay:Number;
      
      protected var az:Number;
      
      private var d2ca:Number;
      
      protected var tempPreGrp:Graphics;
      
      public var precisionMode:int = PrecisionMode.ORIGINAL;
      
      protected var fbz:Number;
      
      private var c2:Number;
      
      protected var mcax:Number;
      
      protected var mcay:Number;
      
      protected var mcaz:Number;
      
      private var d2:Number;
      
      protected var bx:Number;
      
      protected var by:Number;
      
      protected var bz:Number;
      
      protected var fcz:Number;
      
      public var minimumRenderSize:Number = 4;
      
      protected var dbcx:Number;
      
      protected var dbcy:Number;
      
      protected var cx:Number;
      
      protected var cullRect:Rectangle;
      
      protected var cz:Number;
      
      protected var cy:Number;
      
      protected var dmax:Number;
      
      protected var dabx:Number;
      
      private var dy:Number;
      
      protected var _perPixelPrecision:int = 8;
      
      protected var daby:Number;
      
      protected var tempPreRSD:RenderSessionData;
      
      private var dx:Number;
      
      private var x0:Number;
      
      private var x1:Number;
      
      private var x2:Number;
      
      protected var mbcy:Number;
      
      protected var mbcz:Number;
      
      protected var mbcx:Number;
      
      private var y0:Number;
      
      protected var focus:Number = 200;
      
      private var y2:Number;
      
      protected var _texture:Object;
      
      protected var tempPreBmp:BitmapData;
      
      private var y1:Number;
      
      protected var tempTriangleMatrix:Matrix = new Matrix();
      
      protected var maby:Number;
      
      protected var mabz:Number;
      
      private var d2ab:Number;
      
      protected var dsab:Number;
      
      protected var mabx:Number;
      
      protected var dcax:Number;
      
      protected var dcay:Number;
      
      private var a2:Number;
      
      protected var _precision:int = 8;
      
      public function BitmapMaterial(param1:BitmapData = null, param2:Boolean = false)
      {
         super();
         if(param1)
         {
            texture = param1;
         }
         this.precise = param2;
         createRenderRecStorage();
      }
      
      public function transformUV(param1:Triangle3D) : Matrix
      {
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Matrix = null;
         var _loc16_:Matrix = null;
         if(!param1.uv)
         {
            PaperLogger.error("MaterialObject3D: transformUV() uv not found!");
         }
         else if(bitmap)
         {
            _loc2_ = param1.uv;
            _loc3_ = bitmap.width * maxU;
            _loc4_ = bitmap.height * maxV;
            _loc5_ = _loc3_ * param1.uv0.u;
            _loc6_ = _loc4_ * (1 - param1.uv0.v);
            _loc7_ = _loc3_ * param1.uv1.u;
            _loc8_ = _loc4_ * (1 - param1.uv1.v);
            _loc9_ = _loc3_ * param1.uv2.u;
            _loc10_ = _loc4_ * (1 - param1.uv2.v);
            if(_loc5_ == _loc7_ && _loc6_ == _loc8_ || _loc5_ == _loc9_ && _loc6_ == _loc10_)
            {
               _loc5_ -= _loc5_ > 0.05 ? 0.05 : -0.05;
               _loc6_ -= _loc6_ > 0.07 ? 0.07 : -0.07;
            }
            if(_loc9_ == _loc7_ && _loc10_ == _loc8_)
            {
               _loc9_ -= _loc9_ > 0.05 ? 0.04 : -0.04;
               _loc10_ -= _loc10_ > 0.06 ? 0.06 : -0.06;
            }
            _loc11_ = _loc7_ - _loc5_;
            _loc12_ = _loc8_ - _loc6_;
            _loc13_ = _loc9_ - _loc5_;
            _loc14_ = _loc10_ - _loc6_;
            _loc15_ = new Matrix(_loc11_,_loc12_,_loc13_,_loc14_,_loc5_,_loc6_);
            if(Papervision3D.useRIGHTHANDED)
            {
               _loc15_.scale(-1,1);
               _loc15_.translate(_loc3_,0);
            }
            _loc15_.invert();
            _loc16_ = uvMatrices[param1] = _loc15_.clone();
            _loc16_.a = _loc15_.a;
            _loc16_.b = _loc15_.b;
            _loc16_.c = _loc15_.c;
            _loc16_.d = _loc15_.d;
            _loc16_.tx = _loc15_.tx;
            _loc16_.ty = _loc15_.ty;
         }
         else
         {
            PaperLogger.error("MaterialObject3D: transformUV() material.bitmap not found!");
         }
         return _loc16_;
      }
      
      public function transformUVRT(param1:RenderTriangle) : Matrix
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Matrix = null;
         var _loc15_:Matrix = null;
         if(bitmap)
         {
            _loc2_ = bitmap.width * maxU;
            _loc3_ = bitmap.height * maxV;
            _loc4_ = _loc2_ * param1.uv0.u;
            _loc5_ = _loc3_ * (1 - param1.uv0.v);
            _loc6_ = _loc2_ * param1.uv1.u;
            _loc7_ = _loc3_ * (1 - param1.uv1.v);
            _loc8_ = _loc2_ * param1.uv2.u;
            _loc9_ = _loc3_ * (1 - param1.uv2.v);
            if(_loc4_ == _loc6_ && _loc5_ == _loc7_ || _loc4_ == _loc8_ && _loc5_ == _loc9_)
            {
               _loc4_ -= _loc4_ > 0.05 ? 0.05 : -0.05;
               _loc5_ -= _loc5_ > 0.07 ? 0.07 : -0.07;
            }
            if(_loc8_ == _loc6_ && _loc9_ == _loc7_)
            {
               _loc8_ -= _loc8_ > 0.05 ? 0.04 : -0.04;
               _loc9_ -= _loc9_ > 0.06 ? 0.06 : -0.06;
            }
            _loc10_ = _loc6_ - _loc4_;
            _loc11_ = _loc7_ - _loc5_;
            _loc12_ = _loc8_ - _loc4_;
            _loc13_ = _loc9_ - _loc5_;
            _loc14_ = new Matrix(_loc10_,_loc11_,_loc12_,_loc13_,_loc4_,_loc5_);
            if(Papervision3D.useRIGHTHANDED)
            {
               _loc14_.scale(-1,1);
               _loc14_.translate(_loc2_,0);
            }
            _loc14_.invert();
            _loc15_ = uvMatrices[param1] = _loc14_.clone();
            _loc15_.a = _loc14_.a;
            _loc15_.b = _loc14_.b;
            _loc15_.c = _loc14_.c;
            _loc15_.d = _loc14_.d;
            _loc15_.tx = _loc14_.tx;
            _loc15_.ty = _loc14_.ty;
         }
         else
         {
            PaperLogger.error("MaterialObject3D: transformUV() material.bitmap not found!");
         }
         return _loc15_;
      }
      
      protected function renderRec(param1:Matrix, param2:Vertex3DInstance, param3:Vertex3DInstance, param4:Vertex3DInstance, param5:Number) : void
      {
         az = param2.z;
         bz = param3.z;
         cz = param4.z;
         if(az <= 0 && bz <= 0 && cz <= 0)
         {
            return;
         }
         cx = param4.x;
         cy = param4.y;
         bx = param3.x;
         by = param3.y;
         ax = param2.x;
         ay = param2.y;
         if(cullRect)
         {
            hitRect.x = bx < ax ? (bx < cx ? bx : cx) : (ax < cx ? ax : cx);
            hitRect.width = (bx > ax ? (bx > cx ? bx : cx) : (ax > cx ? ax : cx)) + (hitRect.x < 0 ? -hitRect.x : hitRect.x);
            hitRect.y = by < ay ? (by < cy ? by : cy) : (ay < cy ? ay : cy);
            hitRect.height = (by > ay ? (by > cy ? by : cy) : (ay > cy ? ay : cy)) + (hitRect.y < 0 ? -hitRect.y : hitRect.y);
            if(hitRect.right < cullRect.left || hitRect.left > cullRect.right)
            {
               return;
            }
            if(hitRect.bottom < cullRect.top || hitRect.top > cullRect.bottom)
            {
               return;
            }
         }
         if(param5 >= 100 || hitRect.width < minimumRenderSize || hitRect.height < minimumRenderSize || focus == Infinity)
         {
            a2 = param3.x - param2.x;
            b2 = param3.y - param2.y;
            c2 = param4.x - param2.x;
            d2 = param4.y - param2.y;
            tempTriangleMatrix.a = param1.a * a2 + param1.b * c2;
            tempTriangleMatrix.b = param1.a * b2 + param1.b * d2;
            tempTriangleMatrix.c = param1.c * a2 + param1.d * c2;
            tempTriangleMatrix.d = param1.c * b2 + param1.d * d2;
            tempTriangleMatrix.tx = param1.tx * a2 + param1.ty * c2 + param2.x;
            tempTriangleMatrix.ty = param1.tx * b2 + param1.ty * d2 + param2.y;
            if(lineAlpha)
            {
               tempPreGrp.lineStyle(lineThickness,lineColor,lineAlpha);
            }
            tempPreGrp.beginBitmapFill(tempPreBmp,tempTriangleMatrix,tiled,smooth);
            tempPreGrp.moveTo(param2.x,param2.y);
            tempPreGrp.lineTo(param3.x,param3.y);
            tempPreGrp.lineTo(param4.x,param4.y);
            tempPreGrp.endFill();
            if(lineAlpha)
            {
               tempPreGrp.lineStyle();
            }
            ++tempPreRSD.renderStatistics.triangles;
            return;
         }
         faz = focus + az;
         fbz = focus + bz;
         fcz = focus + cz;
         mabz = 2 / (faz + fbz);
         mbcz = 2 / (fbz + fcz);
         mcaz = 2 / (fcz + faz);
         mabx = (ax * faz + bx * fbz) * mabz;
         maby = (ay * faz + by * fbz) * mabz;
         mbcx = (bx * fbz + cx * fcz) * mbcz;
         mbcy = (by * fbz + cy * fcz) * mbcz;
         mcax = (cx * fcz + ax * faz) * mcaz;
         mcay = (cy * fcz + ay * faz) * mcaz;
         dabx = ax + bx - mabx;
         daby = ay + by - maby;
         dbcx = bx + cx - mbcx;
         dbcy = by + cy - mbcy;
         dcax = cx + ax - mcax;
         dcay = cy + ay - mcay;
         dsab = dabx * dabx + daby * daby;
         dsbc = dbcx * dbcx + dbcy * dbcy;
         dsca = dcax * dcax + dcay * dcay;
         var _loc6_:int = param5 + 1;
         var _loc7_:RenderRecStorage = RenderRecStorage(renderRecStorage[int(param5)]);
         var _loc8_:Matrix = _loc7_.mat;
         if(dsab <= _precision && dsca <= _precision && dsbc <= _precision)
         {
            a2 = param3.x - param2.x;
            b2 = param3.y - param2.y;
            c2 = param4.x - param2.x;
            d2 = param4.y - param2.y;
            tempTriangleMatrix.a = param1.a * a2 + param1.b * c2;
            tempTriangleMatrix.b = param1.a * b2 + param1.b * d2;
            tempTriangleMatrix.c = param1.c * a2 + param1.d * c2;
            tempTriangleMatrix.d = param1.c * b2 + param1.d * d2;
            tempTriangleMatrix.tx = param1.tx * a2 + param1.ty * c2 + param2.x;
            tempTriangleMatrix.ty = param1.tx * b2 + param1.ty * d2 + param2.y;
            if(lineAlpha)
            {
               tempPreGrp.lineStyle(lineThickness,lineColor,lineAlpha);
            }
            tempPreGrp.beginBitmapFill(tempPreBmp,tempTriangleMatrix,tiled,smooth);
            tempPreGrp.moveTo(param2.x,param2.y);
            tempPreGrp.lineTo(param3.x,param3.y);
            tempPreGrp.lineTo(param4.x,param4.y);
            tempPreGrp.endFill();
            if(lineAlpha)
            {
               tempPreGrp.lineStyle();
            }
            ++tempPreRSD.renderStatistics.triangles;
            return;
         }
         if(dsab > _precision && dsca > _precision && dsbc > _precision)
         {
            _loc8_.a = param1.a * 2;
            _loc8_.b = param1.b * 2;
            _loc8_.c = param1.c * 2;
            _loc8_.d = param1.d * 2;
            _loc8_.tx = param1.tx * 2;
            _loc8_.ty = param1.ty * 2;
            _loc7_.v0.x = mabx * 0.5;
            _loc7_.v0.y = maby * 0.5;
            _loc7_.v0.z = (az + bz) * 0.5;
            _loc7_.v1.x = mbcx * 0.5;
            _loc7_.v1.y = mbcy * 0.5;
            _loc7_.v1.z = (bz + cz) * 0.5;
            _loc7_.v2.x = mcax * 0.5;
            _loc7_.v2.y = mcay * 0.5;
            _loc7_.v2.z = (cz + az) * 0.5;
            renderRec(_loc8_,param2,_loc7_.v0,_loc7_.v2,_loc6_);
            --_loc8_.tx;
            renderRec(_loc8_,_loc7_.v0,param3,_loc7_.v1,_loc6_);
            --_loc8_.ty;
            _loc8_.tx = param1.tx * 2;
            renderRec(_loc8_,_loc7_.v2,_loc7_.v1,param4,_loc6_);
            _loc8_.a = -param1.a * 2;
            _loc8_.b = -param1.b * 2;
            _loc8_.c = -param1.c * 2;
            _loc8_.d = -param1.d * 2;
            _loc8_.tx = -param1.tx * 2 + 1;
            _loc8_.ty = -param1.ty * 2 + 1;
            renderRec(_loc8_,_loc7_.v1,_loc7_.v2,_loc7_.v0,_loc6_);
            return;
         }
         if(precisionMode == PrecisionMode.ORIGINAL)
         {
            d2ab = dsab;
            d2bc = dsbc;
            d2ca = dsca;
            dmax = dsca > dsbc ? (dsca > dsab ? dsca : dsab) : (dsbc > dsab ? dsbc : dsab);
         }
         else
         {
            dx = param2.x - param3.x;
            dy = param2.y - param3.y;
            d2ab = dx * dx + dy * dy;
            dx = param3.x - param4.x;
            dy = param3.y - param4.y;
            d2bc = dx * dx + dy * dy;
            dx = param4.x - param2.x;
            dy = param4.y - param2.y;
            d2ca = dx * dx + dy * dy;
            dmax = d2ca > d2bc ? (d2ca > d2ab ? d2ca : d2ab) : (d2bc > d2ab ? d2bc : d2ab);
         }
         if(d2ab == dmax)
         {
            _loc8_.a = param1.a * 2;
            _loc8_.b = param1.b;
            _loc8_.c = param1.c * 2;
            _loc8_.d = param1.d;
            _loc8_.tx = param1.tx * 2;
            _loc8_.ty = param1.ty;
            _loc7_.v0.x = mabx * 0.5;
            _loc7_.v0.y = maby * 0.5;
            _loc7_.v0.z = (az + bz) * 0.5;
            renderRec(_loc8_,param2,_loc7_.v0,param4,_loc6_);
            _loc8_.a = param1.a * 2 + param1.b;
            _loc8_.c = 2 * param1.c + param1.d;
            _loc8_.tx = param1.tx * 2 + param1.ty - 1;
            renderRec(_loc8_,_loc7_.v0,param3,param4,_loc6_);
            return;
         }
         if(d2ca == dmax)
         {
            _loc8_.a = param1.a;
            _loc8_.b = param1.b * 2;
            _loc8_.c = param1.c;
            _loc8_.d = param1.d * 2;
            _loc8_.tx = param1.tx;
            _loc8_.ty = param1.ty * 2;
            _loc7_.v2.x = mcax * 0.5;
            _loc7_.v2.y = mcay * 0.5;
            _loc7_.v2.z = (cz + az) * 0.5;
            renderRec(_loc8_,param2,param3,_loc7_.v2,_loc6_);
            _loc8_.b += param1.a;
            _loc8_.d += param1.c;
            _loc8_.ty += param1.tx - 1;
            renderRec(_loc8_,_loc7_.v2,param3,param4,_loc6_);
            return;
         }
         _loc8_.a = param1.a - param1.b;
         _loc8_.b = param1.b * 2;
         _loc8_.c = param1.c - param1.d;
         _loc8_.d = param1.d * 2;
         _loc8_.tx = param1.tx - param1.ty;
         _loc8_.ty = param1.ty * 2;
         _loc7_.v1.x = mbcx * 0.5;
         _loc7_.v1.y = mbcy * 0.5;
         _loc7_.v1.z = (bz + cz) * 0.5;
         renderRec(_loc8_,param2,param3,_loc7_.v1,_loc6_);
         _loc8_.a = param1.a * 2;
         _loc8_.b = param1.b - param1.a;
         _loc8_.c = param1.c * 2;
         _loc8_.d = param1.d - param1.c;
         _loc8_.tx = param1.tx * 2;
         _loc8_.ty = param1.ty - param1.tx;
         renderRec(_loc8_,param2,_loc7_.v1,param4,_loc6_);
      }
      
      protected function createRenderRecStorage() : void
      {
         this.renderRecStorage = new Array();
         var _loc1_:int = 0;
         while(_loc1_ <= 100)
         {
            this.renderRecStorage[_loc1_] = new RenderRecStorage();
            _loc1_++;
         }
      }
      
      public function get texture() : Object
      {
         return this._texture;
      }
      
      public function resetUVS() : void
      {
         uvMatrices = new Dictionary(false);
      }
      
      public function set pixelPrecision(param1:int) : void
      {
         _precision = param1 * param1 * 1.4;
         _perPixelPrecision = param1;
      }
      
      protected function correctBitmap(param1:BitmapData) : BitmapData
      {
         var _loc2_:BitmapData = null;
         var _loc3_:Number = 1 << MIP_MAP_DEPTH;
         var _loc4_:Number = param1.width / _loc3_;
         _loc4_ = _loc4_ == uint(_loc4_) ? _loc4_ : uint(_loc4_) + 1;
         var _loc5_:Number = param1.height / _loc3_;
         _loc5_ = _loc5_ == uint(_loc5_) ? _loc5_ : uint(_loc5_) + 1;
         var _loc6_:Number = _loc3_ * _loc4_;
         var _loc7_:Number = _loc3_ * _loc5_;
         var _loc8_:Boolean = true;
         if(_loc6_ > 2880)
         {
            _loc6_ = param1.width;
            _loc8_ = false;
         }
         if(_loc7_ > 2880)
         {
            _loc7_ = param1.height;
            _loc8_ = false;
         }
         if(!_loc8_)
         {
            PaperLogger.warning("Material " + this.name + ": Texture too big for mip mapping. Resizing recommended for better performance and quality.");
         }
         if(Boolean(param1) && (param1.width % _loc3_ != 0 || param1.height % _loc3_ != 0))
         {
            _loc2_ = new BitmapData(_loc6_,_loc7_,param1.transparent,0);
            widthOffset = param1.width;
            heightOffset = param1.height;
            this.maxU = param1.width / _loc6_;
            this.maxV = param1.height / _loc7_;
            _loc2_.draw(param1);
            extendBitmapEdges(_loc2_,param1.width,param1.height);
         }
         else
         {
            this.maxU = this.maxV = 1;
            _loc2_ = param1;
         }
         return _loc2_;
      }
      
      protected function createBitmap(param1:BitmapData) : BitmapData
      {
         var _loc2_:BitmapData = null;
         resetMapping();
         if(AUTO_MIP_MAPPING)
         {
            _loc2_ = correctBitmap(param1);
         }
         else
         {
            this.maxU = this.maxV = 1;
            _loc2_ = param1;
         }
         return _loc2_;
      }
      
      public function get precise() : Boolean
      {
         return _precise;
      }
      
      public function set texture(param1:Object) : void
      {
         if(param1 is BitmapData == false)
         {
            PaperLogger.error("BitmapMaterial.texture requires a BitmapData object for the texture");
            return;
         }
         bitmap = createBitmap(BitmapData(param1));
         _texture = param1;
      }
      
      override public function clone() : MaterialObject3D
      {
         var _loc1_:MaterialObject3D = super.clone();
         _loc1_.maxU = this.maxU;
         _loc1_.maxV = this.maxV;
         return _loc1_;
      }
      
      override public function drawTriangle(param1:RenderTriangle, param2:Graphics, param3:RenderSessionData, param4:BitmapData = null, param5:Matrix = null) : void
      {
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
               _triMatrix.a = x1 - x0;
               _triMatrix.b = y1 - y0;
               _triMatrix.c = x2 - x0;
               _triMatrix.d = y2 - y0;
               _triMatrix.tx = x0;
               _triMatrix.ty = y0;
               _localMatrix.a = _triMap.a;
               _localMatrix.b = _triMap.b;
               _localMatrix.c = _triMap.c;
               _localMatrix.d = _triMap.d;
               _localMatrix.tx = _triMap.tx;
               _localMatrix.ty = _triMap.ty;
               _localMatrix.concat(_triMatrix);
               param2.beginBitmapFill(param4 ? param4 : bitmap,_localMatrix,tiled,smooth);
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
      
      public function get precision() : int
      {
         return _precision;
      }
      
      public function resetMapping() : void
      {
         uvMatrices = new Dictionary();
      }
      
      override public function copy(param1:MaterialObject3D) : void
      {
         super.copy(param1);
         this.maxU = param1.maxU;
         this.maxV = param1.maxV;
      }
      
      override public function toString() : String
      {
         return "Texture:" + this.texture + " lineColor:" + this.lineColor + " lineAlpha:" + this.lineAlpha;
      }
      
      public function get pixelPrecision() : int
      {
         return _perPixelPrecision;
      }
      
      public function set precise(param1:Boolean) : void
      {
         _precise = param1;
      }
      
      protected function extendBitmapEdges(param1:BitmapData, param2:Number, param3:Number) : void
      {
         var _loc6_:int = 0;
         var _loc4_:Rectangle = new Rectangle();
         var _loc5_:Point = new Point();
         if(param1.width > param2)
         {
            _loc4_.x = param2 - 1;
            _loc4_.y = 0;
            _loc4_.width = 1;
            _loc4_.height = param3;
            _loc5_.y = 0;
            _loc6_ = param2;
            while(_loc6_ < param1.width)
            {
               _loc5_.x = _loc6_;
               param1.copyPixels(param1,_loc4_,_loc5_);
               _loc6_++;
            }
         }
         if(param1.height > param3)
         {
            _loc4_.x = 0;
            _loc4_.y = param3 - 1;
            _loc4_.width = param1.width;
            _loc4_.height = 1;
            _loc5_.x = 0;
            _loc6_ = param3;
            while(_loc6_ < param1.height)
            {
               _loc5_.y = _loc6_;
               param1.copyPixels(param1,_loc4_,_loc5_);
               _loc6_++;
            }
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(uvMatrices)
         {
            uvMatrices = null;
         }
         if(bitmap)
         {
            bitmap.dispose();
         }
         this.renderRecStorage = null;
      }
      
      public function set precision(param1:int) : void
      {
         _precision = param1;
      }
   }
}

