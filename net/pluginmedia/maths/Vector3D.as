package net.pluginmedia.maths
{
   public class Vector3D
   {
      
      public var y:Number;
      
      public var x:Number;
      
      public var z:Number;
      
      public function Vector3D(param1:Number, param2:Number, param3:Number)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.z = param3;
      }
      
      public function crossNew(param1:Vector3D) : Vector3D
      {
         var _loc2_:Vector3D = this.getClone();
         _loc2_.cross(param1);
         return _loc2_;
      }
      
      public function isMagGreaterThan(param1:Number) : Boolean
      {
         var _loc2_:Number = x * x + y * y + z * z;
         if(_loc2_ > param1 * param1)
         {
            return true;
         }
         return false;
      }
      
      public function isMagLessThan(param1:Number) : Boolean
      {
         var _loc2_:Number = x * x + y * y + z * z;
         if(_loc2_ < param1 * param1)
         {
            return true;
         }
         return false;
      }
      
      public function rotateYAroundPoint(param1:Vector3D, param2:Number) : void
      {
         var _loc3_:Vector3D = null;
         var _loc4_:Number = SuperMath.cos(param2);
         var _loc5_:Number = SuperMath.sin(param2);
         _loc3_ = this.subtractNew(param1);
         this.x = _loc3_.x * _loc4_ + _loc3_.z * _loc5_;
         this.y = _loc3_.y;
         this.z = _loc3_.x * -_loc5_ + _loc3_.z * _loc4_;
         this.plus(param1);
      }
      
      public function equals(param1:Vector3D) : Boolean
      {
         var v:Vector3D = param1;
         var _loc3_:* = this;
         with(_loc3_)
         {
            return x == v.x && y == v.y && z == v.z;
         }
         
         public function cross(param1:Vector3D) : void
         {
            var v:Vector3D = param1;
            var temp:Vector3D = this.getClone();
            with(this)
            {
               x = temp.y * v.z - temp.z * v.y;
               y = -temp.x * v.z + temp.z * v.x;
               z = temp.x * v.y - temp.y * v.x;
            }
         }
         
         public function dot(param1:Vector3D) : Number
         {
            var v:Vector3D = param1;
            var _loc3_:* = this;
            with(_loc3_)
            {
               return x * v.x + y * v.y + z * v.z;
            }
            
            public function projNew(param1:Vector3D) : Vector3D
            {
               var _loc2_:Number = this.dot(param1) / param1.dot(param1);
               return this.multiplyNew(_loc2_);
            }
            
            public function copyTo(param1:Vector3D) : void
            {
               param1.x = this.x;
               param1.y = this.y;
               param1.z = this.z;
            }
            
            public function angle() : Number
            {
               var returncode:* = undefined;
               var _loc2_:* = this;
               with(_loc2_)
               {
                  returncode = Math.atan(y / x);
                  if(x < 0)
                  {
                     returncode += 180;
                  }
                  return returncode;
               }
               
               public function subtract(param1:Vector3D) : void
               {
                  x -= param1.x;
                  y -= param1.y;
                  z -= param1.z;
               }
               
               public function isCloseTo(param1:Vector3D, param2:Number) : Boolean
               {
                  if(this.equals(param1))
                  {
                     return true;
                  }
                  var _loc3_:Vector3D = new Vector3D(0,0,0);
                  _loc3_ = this.subtractNew(param1);
                  var _loc4_:Number = _loc3_.x * _loc3_.x + _loc3_.y * _loc3_.y + _loc3_.z * _loc3_.z;
                  if(_loc4_ < param2 * param2)
                  {
                     return true;
                  }
                  return false;
               }
               
               public function plus(param1:Vector3D) : void
               {
                  x += param1.x;
                  y += param1.y;
                  z += param1.z;
               }
               
               public function normaliseAngles() : void
               {
                  x %= 360;
                  y %= 360;
                  z %= 360;
                  if(x < 0)
                  {
                     x += 360;
                  }
                  if(y < 0)
                  {
                     y += 360;
                  }
                  if(z < 0)
                  {
                     z += 360;
                  }
               }
               
               public function multiplyNew(param1:Object) : Vector3D
               {
                  var _loc2_:Vector3D = this.getClone();
                  _loc2_.multiply(param1);
                  return _loc2_;
               }
               
               public function rotateX(param1:Number) : void
               {
                  var _loc4_:Vector3D = null;
                  var _loc2_:Number = SuperMath.cos(param1);
                  var _loc3_:Number = SuperMath.sin(param1);
                  _loc4_ = this.getClone();
                  this.y = _loc4_.y * _loc2_ - _loc4_.z * _loc3_;
                  this.z = _loc4_.y * _loc3_ + _loc4_.z * _loc2_;
               }
               
               public function rotateY(param1:Number) : void
               {
                  var _loc4_:Vector3D = null;
                  var _loc2_:Number = SuperMath.cos(param1);
                  var _loc3_:Number = SuperMath.sin(param1);
                  _loc4_ = this.getClone();
                  this.x = _loc4_.x * _loc2_ + _loc4_.z * _loc3_;
                  this.z = _loc4_.x * -_loc3_ + _loc4_.z * _loc2_;
               }
               
               public function rotateZ(param1:Number) : void
               {
                  var _loc4_:Vector3D = null;
                  var _loc2_:Number = SuperMath.cos(param1);
                  var _loc3_:Number = SuperMath.sin(param1);
                  _loc4_ = this.getClone();
                  this.x = _loc4_.x * _loc2_ - _loc4_.y * _loc3_;
                  this.y = _loc4_.x * _loc3_ + _loc4_.y * _loc2_;
               }
               
               public function getMagnitude() : Number
               {
                  return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
               }
               
               public function reverse() : void
               {
                  this.x = -this.x;
                  this.y = -this.y;
                  this.z = -this.z;
               }
               
               public function multiply(param1:Object) : void
               {
                  if(param1 is Vector3D)
                  {
                     x *= param1.x;
                     y *= param1.y;
                     z *= param1.z;
                  }
                  else if(typeof param1 == "number")
                  {
                     x *= Number(param1);
                     y *= Number(param1);
                     z *= Number(param1);
                  }
                  else
                  {
                     trace("ERROR - multiply method sent neither number or vector");
                  }
               }
               
               public function plusNew(param1:Vector3D) : Vector3D
               {
                  return new Vector3D(x + param1.x,y + param1.y,z + param1.z);
               }
               
               public function getClone() : Vector3D
               {
                  return new Vector3D(this.x,this.y,this.z);
               }
               
               public function set(param1:Number, param2:Number, param3:Number) : void
               {
                  this.x = param1;
                  this.y = param2;
                  this.z = param3;
               }
               
               public function rotateZAroundPoint(param1:Vector3D, param2:Number) : void
               {
                  var _loc3_:Vector3D = null;
                  var _loc4_:Number = SuperMath.cos(param2);
                  var _loc5_:Number = SuperMath.sin(param2);
                  _loc3_ = this.subtractNew(param1);
                  this.x = _loc3_.x * _loc4_ - _loc3_.y * _loc5_;
                  this.y = _loc3_.x * _loc5_ + _loc3_.y * _loc4_;
                  this.z = _loc3_.z;
                  this.plus(param1);
               }
               
               public function subtractNew(param1:Vector3D) : Vector3D
               {
                  return new Vector3D(this.x - param1.x,this.y - param1.y,this.z - param1.z);
               }
               
               public function rotateXAroundPoint(param1:Vector3D, param2:Number) : void
               {
                  var _loc5_:Vector3D = null;
                  var _loc3_:Number = SuperMath.cos(param2);
                  var _loc4_:Number = SuperMath.sin(param2);
                  _loc5_ = this.subtractNew(param1);
                  this.x = _loc5_.x;
                  this.y = _loc5_.y * _loc3_ + _loc5_.z * _loc4_;
                  this.z = _loc5_.y * -_loc4_ + _loc5_.z * _loc3_;
                  this.plus(param1);
               }
               
               public function divideNew(param1:Object) : Vector3D
               {
                  var _loc2_:Vector3D = this.getClone();
                  _loc2_.divide(param1);
                  return _loc2_;
               }
               
               public function toString() : String
               {
                  var _loc1_:Number = Math.round(this.x * 1000) / 1000;
                  var _loc2_:Number = Math.round(this.y * 1000) / 1000;
                  var _loc3_:Number = Math.round(this.z * 1000) / 1000;
                  return "[x:" + _loc1_ + ", y:" + _loc2_ + ", z:" + _loc3_ + "]";
               }
               
               public function angleBetween(param1:Vector3D) : Number
               {
                  var _loc2_:Number = (this.angle() - param1.angle()) % 360;
                  if(_loc2_ > 180)
                  {
                     _loc2_ -= 360;
                  }
                  else if(_loc2_ < -180)
                  {
                     _loc2_ += 360;
                  }
                  return _loc2_;
               }
               
               public function divide(param1:Object) : void
               {
                  if(param1 is Vector3D)
                  {
                     x /= param1.x;
                     y /= param1.y;
                     z /= param1.z;
                  }
                  else if(typeof param1 == "number")
                  {
                     x /= Number(param1);
                     y /= Number(param1);
                     z /= Number(param1);
                  }
                  else
                  {
                     trace("ERROR - multiply method sent neither number or vector");
                  }
               }
               
               public function normalise() : void
               {
                  var _loc1_:Number = this.getMagnitude();
                  this.x /= _loc1_;
                  this.y /= _loc1_;
                  this.z /= _loc1_;
               }
               
               public function copyFrom(param1:Vector3D) : void
               {
                  this.x = param1.x;
                  this.y = param1.y;
                  this.z = param1.z;
               }
            }
         }
         
         