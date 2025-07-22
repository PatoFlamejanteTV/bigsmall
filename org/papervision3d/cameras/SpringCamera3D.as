package org.papervision3d.cameras
{
   import org.papervision3d.core.math.Matrix3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class SpringCamera3D extends Camera3D
   {
      
      public var _camTarget:DisplayObject3D;
      
      private var _velocity:Number3D = new Number3D();
      
      private var _stretch:Number3D = new Number3D();
      
      public var damping:Number = 4;
      
      public var stiffness:Number = 1;
      
      public var lookOffset:Number3D = new Number3D(0,2,10);
      
      private var _lookAtPosition:Number3D = new Number3D();
      
      public var positionOffset:Number3D = new Number3D(0,5,-50);
      
      private var _acceleration:Number3D = new Number3D();
      
      private var _targetTransform:Matrix3D = new Matrix3D();
      
      private var _desiredPosition:Number3D = new Number3D();
      
      private var _force:Number3D = new Number3D();
      
      private var _xPosition:Number3D = new Number3D();
      
      private var _dv:Number3D = new Number3D();
      
      private var _xLookOffset:Number3D = new Number3D();
      
      public var mass:Number = 40;
      
      private var _xPositionOffset:Number3D = new Number3D();
      
      private var _xLookAtObject:DisplayObject3D = new DisplayObject3D();
      
      private var _zrot:Number = 0;
      
      public function SpringCamera3D(param1:Number = 60, param2:Number = 10, param3:Number = 5000, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function transformView(param1:Matrix3D = null) : void
      {
         if(_camTarget != null)
         {
            _targetTransform.n31 = _camTarget.transform.n31;
            _targetTransform.n32 = _camTarget.transform.n32;
            _targetTransform.n33 = _camTarget.transform.n33;
            _targetTransform.n21 = _camTarget.transform.n21;
            _targetTransform.n22 = _camTarget.transform.n22;
            _targetTransform.n23 = _camTarget.transform.n23;
            _targetTransform.n11 = _camTarget.transform.n11;
            _targetTransform.n12 = _camTarget.transform.n12;
            _targetTransform.n13 = _camTarget.transform.n13;
            _xPositionOffset.x = positionOffset.x;
            _xPositionOffset.y = positionOffset.y;
            _xPositionOffset.z = positionOffset.z;
            Matrix3D.multiplyVector(_targetTransform,_xPositionOffset);
            _xLookOffset.x = lookOffset.x;
            _xLookOffset.y = lookOffset.y;
            _xLookOffset.z = lookOffset.z;
            Matrix3D.multiplyVector(_targetTransform,_xLookOffset);
            _desiredPosition.x = _camTarget.x + _xPositionOffset.x;
            _desiredPosition.y = _camTarget.y + _xPositionOffset.y;
            _desiredPosition.z = _camTarget.z + _xPositionOffset.z;
            _lookAtPosition.x = _camTarget.x + _xLookOffset.x;
            _lookAtPosition.y = _camTarget.y + _xLookOffset.y;
            _lookAtPosition.z = _camTarget.z + _xLookOffset.z;
            _stretch.x = (x - _desiredPosition.x) * -stiffness;
            _stretch.y = (y - _desiredPosition.y) * -stiffness;
            _stretch.z = (z - _desiredPosition.z) * -stiffness;
            _dv.x = _velocity.x * damping;
            _dv.y = _velocity.y * damping;
            _dv.z = _velocity.z * damping;
            _force.x = _stretch.x - _dv.x;
            _force.y = _stretch.y - _dv.y;
            _force.z = _stretch.z - _dv.z;
            _acceleration.x = _force.x * (1 / mass);
            _acceleration.y = _force.y * (1 / mass);
            _acceleration.z = _force.z * (1 / mass);
            _velocity.plusEq(_acceleration);
            _xPosition.x = x + _velocity.x;
            _xPosition.y = y + _velocity.y;
            _xPosition.z = z + _velocity.z;
            x = _xPosition.x;
            y = _xPosition.y;
            z = _xPosition.z;
            _xLookAtObject.x = _lookAtPosition.x;
            _xLookAtObject.y = _lookAtPosition.y;
            _xLookAtObject.z = _lookAtPosition.z;
            lookAt(_xLookAtObject);
            if(Math.abs(_zrot) > 0)
            {
               this.rotationZ = _zrot;
            }
         }
         super.transformView(param1);
      }
      
      override public function get target() : DisplayObject3D
      {
         return _camTarget;
      }
      
      public function get zrot() : Number
      {
         return _zrot;
      }
      
      override public function set target(param1:DisplayObject3D) : void
      {
         _camTarget = param1;
      }
      
      public function set zrot(param1:Number) : void
      {
         _zrot = param1;
         if(_zrot < 0.001)
         {
            param1 = 0;
         }
      }
   }
}

