package org.papervision3d.cameras
{
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import org.papervision3d.core.culling.FrustumCuller;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.proto.CameraObject3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Camera3D extends CameraObject3D
   {
      
      protected var _focusFix:Matrix3D;
      
      protected var _prevUseProjection:Boolean;
      
      protected var _prevZoom:Number;
      
      protected var _prevOrtho:Boolean;
      
      protected var _prevWidth:Number;
      
      protected var _prevHeight:Number;
      
      protected var _prevFocus:Number;
      
      protected var _projection:Matrix3D;
      
      protected var _prevOrthoProjection:Boolean;
      
      public function Camera3D(param1:Number = 60, param2:Number = 10, param3:Number = 5000, param4:Boolean = false, param5:Boolean = false)
      {
         super(param2,40);
         this.fov = param1;
         _prevFocus = 0;
         _prevZoom = 0;
         _prevOrtho = false;
         _prevUseProjection = false;
         _useCulling = param4;
         _useProjectionMatrix = param5;
         _far = param3;
         _focusFix = Matrix3D.IDENTITY;
      }
      
      public static function createPerspectiveMatrix(param1:Number, param2:Number, param3:Number, param4:Number) : Matrix3D
      {
         var _loc5_:Number = param1 / 2 * (Math.PI / 180);
         var _loc6_:Number = Math.tan(_loc5_);
         var _loc7_:Number = 1 / _loc6_;
         return new Matrix3D([_loc7_ / param2,0,0,0,0,_loc7_,0,0,0,0,-((param3 + param4) / (param3 - param4)),2 * param4 * param3 / (param3 - param4),0,0,1,0]);
      }
      
      public static function createOrthoMatrix(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Matrix3D
      {
         var _loc7_:Number = (param2 + param1) / (param2 - param1);
         var _loc8_:Number = (param4 + param3) / (param4 - param3);
         var _loc9_:Number = (param6 + param5) / (param6 - param5);
         var _loc10_:Matrix3D = new Matrix3D([2 / (param2 - param1),0,0,_loc7_,0,2 / (param4 - param3),0,_loc8_,0,0,-2 / (param6 - param5),_loc9_,0,0,0,1]);
         _loc10_.calculateMultiply(Matrix3D.scaleMatrix(1,1,-1),_loc10_);
         return _loc10_;
      }
      
      public function update(param1:Rectangle) : void
      {
         if(!param1)
         {
            throw new Error("Camera3D#update: Invalid viewport rectangle! " + param1);
         }
         this.viewport = param1;
         _prevFocus = this.focus;
         _prevZoom = this.zoom;
         _prevWidth = this.viewport.width;
         _prevHeight = this.viewport.height;
         if(_prevOrtho != this.ortho)
         {
            if(this.ortho)
            {
               _prevOrthoProjection = this.useProjectionMatrix;
               this.useProjectionMatrix = true;
            }
            else
            {
               this.useProjectionMatrix = _prevOrthoProjection;
            }
         }
         this.useProjectionMatrix = this._useProjectionMatrix;
         _prevOrtho = this.ortho;
         _prevUseProjection = _useProjectionMatrix;
         this.useCulling = _useCulling;
      }
      
      public function get projection() : Matrix3D
      {
         return _projection;
      }
      
      override public function set near(param1:Number) : void
      {
         if(param1 > 0)
         {
            this.focus = param1;
            this.update(this.viewport);
         }
      }
      
      override public function orbit(param1:Number, param2:Number, param3:Boolean = true, param4:DisplayObject3D = null) : void
      {
         var _loc8_:Number = NaN;
         param4 ||= _target;
         param4 = (param4) || DisplayObject3D.ZERO;
         if(param3)
         {
            param1 *= Math.PI / 180;
            param2 *= Math.PI / 180;
         }
         var _loc5_:Number = param4.world.n14 - this.x;
         var _loc6_:Number = param4.world.n24 - this.y;
         var _loc7_:Number = param4.world.n34 - this.z;
         _loc8_ = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_ + _loc7_ * _loc7_);
         var _loc9_:Number = Math.cos(param2) * Math.sin(param1);
         var _loc10_:Number = Math.sin(param2) * Math.sin(param1);
         var _loc11_:Number = Math.cos(param1);
         this.x = param4.world.n14 + _loc9_ * _loc8_;
         this.y = param4.world.n24 + _loc11_ * _loc8_;
         this.z = param4.world.n34 + _loc10_ * _loc8_;
         this.lookAt(param4);
      }
      
      override public function set useCulling(param1:Boolean) : void
      {
         super.useCulling = param1;
         if(_useCulling)
         {
            if(!this.culler)
            {
               this.culler = new FrustumCuller();
            }
            FrustumCuller(this.culler).initialize(this.fov,this.viewport.width / this.viewport.height,this.focus / this.zoom,_far);
         }
         else
         {
            this.culler = null;
         }
      }
      
      override public function projectFaces(param1:Array, param2:DisplayObject3D, param3:RenderSessionData) : Number
      {
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Vertex3D = null;
         var _loc25_:Vertex3DInstance = null;
         var _loc26_:Number = NaN;
         var _loc34_:Array = null;
         var _loc36_:Triangle3D = null;
         var _loc4_:Matrix3D = param2.view;
         var _loc5_:Number = _loc4_.n11;
         var _loc6_:Number = _loc4_.n12;
         var _loc7_:Number = _loc4_.n13;
         var _loc8_:Number = _loc4_.n21;
         var _loc9_:Number = _loc4_.n22;
         var _loc10_:Number = _loc4_.n23;
         var _loc11_:Number = _loc4_.n31;
         var _loc12_:Number = _loc4_.n32;
         var _loc13_:Number = _loc4_.n33;
         var _loc14_:Number = _loc4_.n41;
         var _loc15_:Number = _loc4_.n42;
         var _loc16_:Number = _loc4_.n43;
         var _loc27_:int = 0;
         var _loc28_:Number = param3.camera.focus;
         var _loc29_:Number = _loc28_ * param3.camera.zoom;
         var _loc30_:Number = viewport.width / 2;
         var _loc31_:Number = viewport.height / 2;
         var _loc32_:Number = param3.camera.far;
         var _loc33_:Number = _loc32_ - _loc28_;
         var _loc35_:Number = getTimer();
         for each(_loc36_ in param1)
         {
            _loc34_ = _loc36_.vertices;
            _loc27_ = int(_loc34_.length);
            while(true)
            {
               _loc24_ = _loc34_[--_loc27_];
               if(!_loc24_)
               {
                  break;
               }
               if(_loc24_.timestamp != _loc35_)
               {
                  _loc24_.timestamp = _loc35_;
                  _loc17_ = _loc24_.x;
                  _loc18_ = _loc24_.y;
                  _loc19_ = _loc24_.z;
                  _loc22_ = _loc17_ * _loc11_ + _loc18_ * _loc12_ + _loc19_ * _loc13_ + _loc4_.n34;
                  _loc25_ = _loc24_.vertex3DInstance;
                  if(_useProjectionMatrix)
                  {
                     _loc23_ = _loc17_ * _loc14_ + _loc18_ * _loc15_ + _loc19_ * _loc16_ + _loc4_.n44;
                     _loc22_ /= _loc23_;
                     if(_loc25_.visible = _loc22_ > 0 && _loc22_ < 1)
                     {
                        _loc20_ = (_loc17_ * _loc5_ + _loc18_ * _loc6_ + _loc19_ * _loc7_ + _loc4_.n14) / _loc23_;
                        _loc21_ = (_loc17_ * _loc8_ + _loc18_ * _loc9_ + _loc19_ * _loc10_ + _loc4_.n24) / _loc23_;
                        _loc25_.x = _loc20_ * _loc30_;
                        _loc25_.y = _loc21_ * _loc31_;
                        _loc25_.z = _loc22_ * _loc23_;
                     }
                  }
                  else if(_loc25_.visible = _loc28_ + _loc22_ > 0)
                  {
                     _loc20_ = _loc17_ * _loc5_ + _loc18_ * _loc6_ + _loc19_ * _loc7_ + _loc4_.n14;
                     _loc21_ = _loc17_ * _loc8_ + _loc18_ * _loc9_ + _loc19_ * _loc10_ + _loc4_.n24;
                     _loc26_ = _loc29_ / (_loc28_ + _loc22_);
                     _loc25_.x = _loc20_ * _loc26_;
                     _loc25_.y = _loc21_ * _loc26_;
                     _loc25_.z = _loc22_;
                  }
               }
            }
         }
         return 0;
      }
      
      override public function set orthoScale(param1:Number) : void
      {
         super.orthoScale = param1;
         this.useProjectionMatrix = this.useProjectionMatrix;
         _prevOrtho = !this.ortho;
         this.update(this.viewport);
      }
      
      override public function transformView(param1:Matrix3D = null) : void
      {
         if(ortho != _prevOrtho || _prevUseProjection != _useProjectionMatrix || focus != _prevFocus || zoom != _prevZoom || viewport.width != _prevWidth || viewport.height != _prevHeight)
         {
            update(viewport);
         }
         if(_target)
         {
            lookAt(_target);
         }
         else if(_transformDirty)
         {
            updateTransform();
         }
         if(_useProjectionMatrix)
         {
            super.transformView();
            this.eye.calculateMultiply4x4(_projection,this.eye);
         }
         else
         {
            _focusFix.copy(this.transform);
            _focusFix.n14 += focus * this.transform.n13;
            _focusFix.n24 += focus * this.transform.n23;
            _focusFix.n34 += focus * this.transform.n33;
            super.transformView(_focusFix);
         }
         if(culler is FrustumCuller)
         {
            FrustumCuller(culler).transform.copy(this.transform);
         }
      }
      
      override public function set far(param1:Number) : void
      {
         if(param1 > this.focus)
         {
            _far = param1;
            this.update(this.viewport);
         }
      }
      
      override public function projectVertices(param1:Array, param2:DisplayObject3D, param3:RenderSessionData) : Number
      {
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Vertex3D = null;
         var _loc25_:Vertex3DInstance = null;
         var _loc26_:Number = NaN;
         var _loc4_:Matrix3D = param2.view;
         var _loc5_:Number = _loc4_.n11;
         var _loc6_:Number = _loc4_.n12;
         var _loc7_:Number = _loc4_.n13;
         var _loc8_:Number = _loc4_.n21;
         var _loc9_:Number = _loc4_.n22;
         var _loc10_:Number = _loc4_.n23;
         var _loc11_:Number = _loc4_.n31;
         var _loc12_:Number = _loc4_.n32;
         var _loc13_:Number = _loc4_.n33;
         var _loc14_:Number = _loc4_.n41;
         var _loc15_:Number = _loc4_.n42;
         var _loc16_:Number = _loc4_.n43;
         var _loc27_:int = int(param1.length);
         var _loc28_:Number = param3.camera.focus;
         var _loc29_:Number = _loc28_ * param3.camera.zoom;
         var _loc30_:Number = viewport.width / 2;
         var _loc31_:Number = viewport.height / 2;
         var _loc32_:Number = param3.camera.far;
         var _loc33_:Number = _loc32_ - _loc28_;
         while(true)
         {
            _loc24_ = param1[--_loc27_];
            if(!_loc24_)
            {
               break;
            }
            _loc17_ = _loc24_.x;
            _loc18_ = _loc24_.y;
            _loc19_ = _loc24_.z;
            _loc22_ = _loc17_ * _loc11_ + _loc18_ * _loc12_ + _loc19_ * _loc13_ + _loc4_.n34;
            _loc25_ = _loc24_.vertex3DInstance;
            if(_useProjectionMatrix)
            {
               _loc23_ = _loc17_ * _loc14_ + _loc18_ * _loc15_ + _loc19_ * _loc16_ + _loc4_.n44;
               _loc22_ /= _loc23_;
               if(_loc25_.visible = _loc22_ > 0 && _loc22_ < 1)
               {
                  _loc20_ = (_loc17_ * _loc5_ + _loc18_ * _loc6_ + _loc19_ * _loc7_ + _loc4_.n14) / _loc23_;
                  _loc21_ = (_loc17_ * _loc8_ + _loc18_ * _loc9_ + _loc19_ * _loc10_ + _loc4_.n24) / _loc23_;
                  _loc25_.x = _loc20_ * _loc30_;
                  _loc25_.y = _loc21_ * _loc31_;
                  _loc25_.z = _loc22_ * _loc23_;
               }
            }
            else if(_loc25_.visible = _loc28_ + _loc22_ > 0)
            {
               _loc20_ = _loc17_ * _loc5_ + _loc18_ * _loc6_ + _loc19_ * _loc7_ + _loc4_.n14;
               _loc21_ = _loc17_ * _loc8_ + _loc18_ * _loc9_ + _loc19_ * _loc10_ + _loc4_.n24;
               _loc26_ = _loc29_ / (_loc28_ + _loc22_);
               _loc25_.x = _loc20_ * _loc26_;
               _loc25_.y = _loc21_ * _loc26_;
               _loc25_.z = _loc22_;
            }
         }
         return 0;
      }
      
      override public function set useProjectionMatrix(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1)
         {
            if(this.ortho)
            {
               _loc2_ = viewport.width / 2;
               _loc3_ = viewport.height / 2;
               _projection = createOrthoMatrix(-_loc2_,_loc2_,-_loc3_,_loc3_,-_far,_far);
               _projection = Matrix3D.multiply(_orthoScaleMatrix,_projection);
            }
            else
            {
               _projection = createPerspectiveMatrix(fov,viewport.width / viewport.height,this.focus,this.far);
            }
         }
         else if(this.ortho)
         {
            param1 = true;
         }
         super.useProjectionMatrix = param1;
      }
   }
}

