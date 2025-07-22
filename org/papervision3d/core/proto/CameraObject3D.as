package org.papervision3d.core.proto
{
   import flash.geom.Rectangle;
   import org.papervision3d.Papervision3D;
   import org.papervision3d.core.culling.IObjectCuller;
   import org.papervision3d.core.log.PaperLogger;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.core.math.util.GLU;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class CameraObject3D extends DisplayObject3D
   {
      
      public static var DEFAULT_POS:Number3D = new Number3D(0,0,-1000);
      
      public static var DEFAULT_UP:Number3D = new Number3D(0,1,0);
      
      public static var DEFAULT_VIEWPORT:Rectangle = new Rectangle(0,0,550,400);
      
      private static var _flipY:Matrix3D = Matrix3D.scaleMatrix(1,-1,1);
      
      protected var _orthoScale:Number = 1;
      
      public var culler:IObjectCuller;
      
      public var sort:Boolean;
      
      public var viewport:Rectangle;
      
      protected var _target:DisplayObject3D;
      
      protected var _orthoScaleMatrix:Matrix3D;
      
      public var eye:Matrix3D;
      
      protected var _ortho:Boolean;
      
      protected var _useCulling:Boolean;
      
      public var zoom:Number;
      
      public var yUP:Boolean;
      
      public var focus:Number;
      
      protected var _useProjectionMatrix:Boolean;
      
      protected var _far:Number;
      
      public function CameraObject3D(param1:Number = 500, param2:Number = 3)
      {
         super();
         this.x = DEFAULT_POS.x;
         this.y = DEFAULT_POS.y;
         this.z = DEFAULT_POS.z;
         this.zoom = param2;
         this.focus = param1;
         this.eye = Matrix3D.IDENTITY;
         this.viewport = DEFAULT_VIEWPORT;
         this.sort = true;
         _ortho = false;
         _orthoScaleMatrix = Matrix3D.scaleMatrix(1,1,1);
         if(Papervision3D.useRIGHTHANDED)
         {
            DEFAULT_UP.y = -1;
            this.yUP = false;
            this.lookAt(DisplayObject3D.ZERO);
         }
         else
         {
            this.yUP = true;
         }
      }
      
      public function get target() : DisplayObject3D
      {
         return _target;
      }
      
      public function get useProjectionMatrix() : Boolean
      {
         return _useProjectionMatrix;
      }
      
      public function set fov(param1:Number) : void
      {
         if(!viewport || viewport.isEmpty())
         {
            PaperLogger.warning("CameraObject3D#viewport not set, can\'t set fov!");
            return;
         }
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         if(_target)
         {
            _loc2_ = _target.world.n14;
            _loc3_ = _target.world.n24;
            _loc4_ = _target.world.n34;
         }
         var _loc5_:Number = viewport.height / 2;
         var _loc6_:Number = param1 / 2 * (Math.PI / 180);
         this.focus = _loc5_ / Math.tan(_loc6_) / this.zoom;
      }
      
      public function pan(param1:Number) : void
      {
      }
      
      public function get far() : Number
      {
         return _far;
      }
      
      public function set target(param1:DisplayObject3D) : void
      {
         _target = param1;
      }
      
      public function projectFaces(param1:Array, param2:DisplayObject3D, param3:RenderSessionData) : Number
      {
         return 0;
      }
      
      public function get useCulling() : Boolean
      {
         return _useCulling;
      }
      
      public function set far(param1:Number) : void
      {
         if(param1 > this.focus)
         {
            _far = param1;
         }
      }
      
      public function get near() : Number
      {
         return this.focus;
      }
      
      public function transformView(param1:Matrix3D = null) : void
      {
         if(this.yUP)
         {
            eye.calculateMultiply(param1 || this.transform,_flipY);
            eye.invert();
         }
         else
         {
            eye.calculateInverse(param1 || this.transform);
         }
      }
      
      public function set useProjectionMatrix(param1:Boolean) : void
      {
         _useProjectionMatrix = param1;
      }
      
      public function tilt(param1:Number) : void
      {
      }
      
      override public function lookAt(param1:DisplayObject3D, param2:Number3D = null) : void
      {
         if(this.yUP)
         {
            super.lookAt(param1,param2);
         }
         else
         {
            super.lookAt(param1,param2 || DEFAULT_UP);
         }
      }
      
      public function get ortho() : Boolean
      {
         return _ortho;
      }
      
      public function orbit(param1:Number, param2:Number, param3:Boolean = true, param4:DisplayObject3D = null) : void
      {
      }
      
      public function get fov() : Number
      {
         if(!viewport || viewport.isEmpty())
         {
            PaperLogger.warning("CameraObject3D#viewport not set, can\'t calculate fov!");
            return NaN;
         }
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         if(_target)
         {
            _loc1_ = _target.world.n14;
            _loc2_ = _target.world.n24;
            _loc3_ = _target.world.n34;
         }
         var _loc4_:Number = this.x - _loc1_;
         var _loc5_:Number = this.y - _loc2_;
         var _loc6_:Number = this.z - _loc3_;
         var _loc7_:Number = this.focus;
         var _loc8_:Number = this.zoom;
         var _loc9_:Number = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_ + _loc6_ * _loc6_) + _loc7_;
         var _loc10_:Number = viewport.height / 2;
         var _loc11_:Number = 180 / Math.PI;
         return Math.atan(_loc9_ / _loc7_ / _loc8_ * _loc10_ / _loc9_) * _loc11_ * 2;
      }
      
      public function set near(param1:Number) : void
      {
         if(param1 > 0)
         {
            this.focus = param1;
         }
      }
      
      public function set useCulling(param1:Boolean) : void
      {
         _useCulling = param1;
      }
      
      public function set orthoScale(param1:Number) : void
      {
         _orthoScale = param1 > 0 ? param1 : 0.0001;
         _orthoScaleMatrix.n11 = _orthoScale;
         _orthoScaleMatrix.n22 = _orthoScale;
         _orthoScaleMatrix.n33 = _orthoScale;
      }
      
      public function unproject(param1:Number, param2:Number, param3:Number = 0) : Number3D
      {
         var _loc4_:Number3D = null;
         var _loc5_:Matrix3D = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Number = NaN;
         if(_useProjectionMatrix)
         {
            if(!viewport)
            {
               return null;
            }
            _loc5_ = this.transform;
            _loc6_ = [-viewport.width / 2,-viewport.height / 2,viewport.width,viewport.height];
            _loc7_ = [_loc5_.n11,_loc5_.n21,_loc5_.n31,_loc5_.n41,_loc5_.n12,_loc5_.n22,_loc5_.n32,_loc5_.n42,_loc5_.n13,_loc5_.n23,_loc5_.n33,_loc5_.n43,_loc5_.n14,_loc5_.n24,_loc5_.n34,_loc5_.n44];
            _loc8_ = new Array(16);
            _loc9_ = new Array(4);
            GLU.invertMatrix(_loc7_,_loc7_);
            if(_ortho)
            {
               _loc10_ = new Array(16);
               _loc11_ = new Array(16);
               GLU.ortho(_loc11_,viewport.width / 2,-viewport.width / 2,-viewport.height / 2,viewport.height / 2,far,near);
               GLU.scale(_loc10_,_orthoScale,_orthoScale,1);
               GLU.multMatrices(_loc10_,_loc11_,_loc8_);
            }
            else
            {
               GLU.perspective(_loc8_,fov,viewport.width / viewport.height,-near,-far);
            }
            GLU.unProject(-param1,param2,param3,_loc7_,_loc8_,_loc6_,_loc9_);
            _loc4_ = new Number3D();
            _loc4_.x = _loc9_[0];
            _loc4_.y = _loc9_[1];
            _loc4_.z = _loc9_[2];
         }
         else
         {
            _loc12_ = focus * zoom / focus;
            _loc4_ = new Number3D(param1 / _loc12_,(yUP ? -param2 : param2) / _loc12_,focus);
            Matrix3D.multiplyVector3x3(transform,_loc4_);
         }
         return _loc4_;
      }
      
      public function set ortho(param1:Boolean) : void
      {
         _ortho = param1;
      }
      
      public function projectVertices(param1:Array, param2:DisplayObject3D, param3:RenderSessionData) : Number
      {
         return 0;
      }
      
      public function get orthoScale() : Number
      {
         return _orthoScale;
      }
   }
}

