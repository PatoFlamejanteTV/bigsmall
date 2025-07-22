package net.pluginmedia.pv3d.cameras
{
   import flash.ui.Keyboard;
   import net.pluginmedia.pv3d.interfaces.ICameraUpdateable;
   import net.pluginmedia.utils.KeyUtils;
   import org.papervision3d.cameras.Camera3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class OrbitCamera3D extends Camera3D implements ICameraUpdateable
   {
      
      public static var debug:Boolean = false;
      
      private var freeRotYMin:Number = -180;
      
      public var orbitCentre:DisplayObject3D;
      
      private var freeRotXMax:Number = 90;
      
      public var rotationYMax:Number = 30;
      
      private var storedRotXMin:Number = -180;
      
      private var freeRotYMax:Number = 180;
      
      public var rotationXMin:Number = -30;
      
      public var radius:Number = 100;
      
      private var _rotationX:Number;
      
      private var storedRotXMax:Number = 180;
      
      private var _rotationY:Number;
      
      private var freeRotXMin:Number = -90;
      
      private var _freeRotation:Boolean;
      
      public var rotationXMax:Number = 30;
      
      private var storedRotYMin:Number = -180;
      
      private var _isLocked:Boolean = false;
      
      public var rotationYMin:Number = -30;
      
      private var storedRotYMax:Number = 180;
      
      public function OrbitCamera3D(param1:Number = 60)
      {
         super(param1);
         _rotationX = 0;
         _rotationY = 0;
         orbitCentre = DisplayObject3D.ZERO;
         target = orbitCentre;
         updatePosition(0.5,0.5);
      }
      
      public function get isLocked() : Boolean
      {
         return _isLocked;
      }
      
      public function lock() : void
      {
         _isLocked = true;
      }
      
      public function release() : void
      {
         _isLocked = false;
      }
      
      public function updateRadial() : void
      {
         if(_isLocked)
         {
            return;
         }
         x = orbitCentre.x;
         y = orbitCentre.y;
         z = orbitCentre.z;
         moveBackward(radius);
      }
      
      public function updateRotation(param1:Number, param2:Number, param3:Number = 0.2) : Boolean
      {
         if(_isLocked)
         {
            return false;
         }
         var _loc4_:Boolean = false;
         if(easeValue("_rotationY",param1,rotationYMin,rotationYMax,param3) > 0.01)
         {
            _loc4_ = true;
         }
         if(easeValue("_rotationX",param2,rotationXMin,rotationXMax,param3) > 0.01)
         {
            _loc4_ = true;
         }
         rotationX = _rotationX;
         rotationY = _rotationY;
         return _loc4_;
      }
      
      public function checkKeys() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = 2;
         if(KeyUtils.isDown(87))
         {
            orbitCentre.z += _loc2_;
            _loc1_ = true;
         }
         if(KeyUtils.isDown(88))
         {
            orbitCentre.z -= _loc2_;
            _loc1_ = true;
         }
         if(KeyUtils.isDown(65))
         {
            orbitCentre.x -= _loc2_;
            _loc1_ = true;
         }
         if(KeyUtils.isDown(68))
         {
            orbitCentre.x += _loc2_;
            _loc1_ = true;
         }
         if(KeyUtils.isDown(83))
         {
            if(KeyUtils.isDown(Keyboard.SHIFT))
            {
               orbitCentre.y -= _loc2_;
            }
            else
            {
               orbitCentre.y += _loc2_;
            }
            _loc1_ = true;
         }
         if(KeyUtils.isDown(81))
         {
            if(KeyUtils.isDown(Keyboard.SHIFT))
            {
               radius -= _loc2_;
            }
            else
            {
               radius += _loc2_;
            }
            _loc1_ = true;
         }
         _loc2_ = 0.2;
         if(KeyUtils.isDown(69))
         {
            if(KeyUtils.isDown(Keyboard.SHIFT))
            {
               radius -= _loc2_;
            }
            else
            {
               radius += _loc2_;
            }
            _loc1_ = true;
         }
         _loc2_ = 4;
         if(KeyUtils.isDown(85))
         {
            if(KeyUtils.isDown(Keyboard.SHIFT))
            {
               rotationYMin -= _loc2_;
            }
            else
            {
               rotationYMin += _loc2_;
            }
            _loc1_ = true;
         }
         if(KeyUtils.isDown(73))
         {
            if(KeyUtils.isDown(Keyboard.SHIFT))
            {
               rotationYMax += _loc2_;
            }
            else
            {
               rotationYMax -= _loc2_;
            }
            _loc1_ = true;
         }
         if(KeyUtils.isDown(74))
         {
            if(KeyUtils.isDown(Keyboard.SHIFT))
            {
               rotationXMin -= _loc2_;
            }
            else
            {
               rotationXMin += _loc2_;
            }
            _loc1_ = true;
         }
         if(KeyUtils.isDown(75))
         {
            if(KeyUtils.isDown(Keyboard.SHIFT))
            {
               rotationXMax += _loc2_;
            }
            else
            {
               rotationXMax -= _loc2_;
            }
            _loc1_ = true;
         }
         if(KeyUtils.isDown(82))
         {
            _freeRotation = !_freeRotation;
            if(_freeRotation)
            {
               storedRotYMin = rotationYMin;
               storedRotYMax = rotationYMax;
               storedRotXMin = rotationXMin;
               storedRotXMax = rotationXMax;
               rotationYMin = freeRotYMin;
               rotationYMax = freeRotYMax;
               rotationXMin = freeRotXMin;
               rotationXMax = freeRotXMax;
            }
            else
            {
               rotationYMin = storedRotYMin;
               rotationYMax = storedRotYMax;
               rotationXMin = storedRotXMin;
               rotationXMax = storedRotXMax;
            }
            _loc1_ = true;
         }
         if(KeyUtils.isDown(Keyboard.SHIFT))
         {
            if(KeyUtils.isDown(Keyboard.LEFT))
            {
               zoom -= _loc2_ * 0.1;
               _loc1_ = true;
            }
            else if(KeyUtils.isDown(Keyboard.RIGHT))
            {
               zoom += _loc2_ * 0.1;
               _loc1_ = true;
            }
         }
         if(KeyUtils.isDown(Keyboard.SPACE))
         {
            trace(this.toString());
         }
         return _loc1_;
      }
      
      public function easeValue(param1:String, param2:Number, param3:Number = -90, param4:Number = 90, param5:Number = 0.2) : Number
      {
         if(param2 > 1)
         {
            param2 = 1;
         }
         else if(param2 < 0)
         {
            param2 = 0;
         }
         var _loc6_:Number = (param4 - param3) * param2 + param3;
         var _loc7_:Number = _loc6_ - this[param1];
         var _loc8_:Number = 0;
         if(Math.abs(_loc7_) < 0.001)
         {
            this[param1] = _loc6_;
            _loc7_ = 0;
         }
         else
         {
            _loc7_ *= param5;
            this[param1] += _loc7_;
         }
         return Math.abs(_loc7_);
      }
      
      public function updatePosition(param1:Number, param2:Number, param3:Number = 0.2) : Boolean
      {
         if(_isLocked)
         {
            return false;
         }
         var _loc4_:Boolean = updateRotation(param1,param2,param3);
         if(debug)
         {
            _loc4_ ||= checkKeys();
         }
         updateRadial();
         return _loc4_;
      }
      
      override public function toString() : String
      {
         var _loc1_:String = "\n";
         var _loc2_:String = "OrbitCamera3D ::" + _loc1_;
         _loc2_ += "camera.orbitCentre.x =" + orbitCentre.x + ";" + _loc1_;
         _loc2_ += "camera.orbitCentre.y =" + orbitCentre.y + ";" + _loc1_;
         _loc2_ += "camera.orbitCentre.z =" + orbitCentre.z + ";" + _loc1_;
         _loc2_ += "camera.radius = " + radius + ";" + _loc1_;
         _loc2_ += "camera.fov = " + fov + ";" + _loc1_;
         _loc2_ += "camera.zoom = " + zoom + ";" + _loc1_;
         _loc2_ += "camera.focus = " + focus + ";" + _loc1_;
         _loc2_ += "camera.rotationX = " + _rotationX + ";" + _loc1_;
         _loc2_ += "camera.rotationY = " + _rotationY + ";" + _loc1_;
         return _loc2_ + "---";
      }
   }
}

